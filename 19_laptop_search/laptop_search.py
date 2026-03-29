"""
Laptop search script for IVORY and KSP Israeli retailers.

Searches for laptops matching:
  - CPU: Intel Core i5 or better (i5, i7, i9, Ryzen 5, Ryzen 7, Ryzen 9)
  - RAM: 16 GB or more
  - SSD: 512 GB or more
  - Price: up to 3,000 NIS
  - OS: No pre-installed Windows (FreeDOS / No OS / Linux)
"""

import re
import sys
import requests

# ---------------------------------------------------------------------------
# Shared helpers
# ---------------------------------------------------------------------------

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (X11; Linux x86_64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/120.0.0.0 Safari/537.36"
    ),
    "Accept-Language": "he-IL,he;q=0.9,en-US;q=0.8,en;q=0.7",
}

MAX_PRICE = 3000  # NIS

# Minimum CPU generation/tier patterns (i5 or better, Ryzen 5 or better)
CPU_OK_PATTERNS = [
    re.compile(r"i[5-9][\s\-]", re.IGNORECASE),
    re.compile(r"core\s+i[5-9]", re.IGNORECASE),
    re.compile(r"ryzen\s+[5-9]", re.IGNORECASE),
]

# OS filter: accept only "no OS", FreeDOS, Linux
NO_OS_PATTERNS = [
    re.compile(r"ללא\s+מערכת", re.IGNORECASE),        # Hebrew: "without OS"
    re.compile(r"no[\s\-]?os", re.IGNORECASE),
    re.compile(r"freedos", re.IGNORECASE),
    re.compile(r"\blinux\b", re.IGNORECASE),
    re.compile(r"dos", re.IGNORECASE),
    re.compile(r"ללא\s+os", re.IGNORECASE),
]

WINDOWS_PATTERN = re.compile(r"windows", re.IGNORECASE)


def _has_good_cpu(text: str) -> bool:
    return any(p.search(text) for p in CPU_OK_PATTERNS)


def _ram_ok(text: str) -> bool:
    """Return True if RAM is 16 GB or more."""
    # First: look for explicit RAM keywords (e.g. "16GB DDR4", "32GB LPDDR5", "16GB RAM")
    for m in re.finditer(
        r"(\d+)\s*gb\s+(?:ram|ddr\d*|lpddr\d*|memory)",
        text,
        re.IGNORECASE,
    ):
        if int(m.group(1)) >= 16:
            return True
    # Fallback: bare "NGB" with no keyword, but only accept typical RAM sizes (≤128 GB)
    # to avoid confusing SSD capacity (512 GB, 1 TB) with RAM.
    for m in re.finditer(r"(\d+)\s*gb(?!\s*(?:ssd|nvme|m\.2|nand|storage|hdd))",
                         text, re.IGNORECASE):
        val = int(m.group(1))
        if 16 <= val <= 128:
            return True
    return False


def _ssd_ok(text: str) -> bool:
    """Return True if SSD capacity is 512 GB or more."""
    for m in re.finditer(
        r"(\d+(?:\.\d+)?)\s*(tb|gb)\s*(?:ssd|nvme|m\.2|nand|storage)?",
        text,
        re.IGNORECASE,
    ):
        val = float(m.group(1))
        unit = m.group(2).lower()
        val_gb = val * 1024 if unit == "tb" else val
        if val_gb >= 512:
            return True
    return False


def _no_windows_os(text: str) -> bool:
    """Return True if the product has no pre-installed Windows."""
    if WINDOWS_PATTERN.search(text):
        return False
    return any(p.search(text) for p in NO_OS_PATTERNS)


def matches_criteria(name: str, description: str, price: float) -> bool:
    """Return True if a product meets all search criteria."""
    combined = f"{name} {description}"
    return (
        price <= MAX_PRICE
        and _has_good_cpu(combined)
        and _ram_ok(combined)
        and _ssd_ok(combined)
        and _no_windows_os(combined)
    )


def print_result(source: str, name: str, price: float, url: str) -> None:
    print(f"  [{source}] {name}")
    print(f"         מחיר: {price:.0f} ש\"ח  |  {url}")
    print()


# ---------------------------------------------------------------------------
# KSP scraper  (ksp.co.il)
# ---------------------------------------------------------------------------

KSP_API = "https://ksp.co.il/mob/json/mgn/laptops"
KSP_SEARCH_URL = (
    "https://ksp.co.il/web/cat/Laptops-Notebooks/?priceRange=0-{max_price}"
    "&os=No+OS,FreeDOS&sort=price_asc&pageSize=96"
)
KSP_PRODUCT_BASE = "https://ksp.co.il"


def search_ksp() -> list[dict]:
    """Search KSP for laptops matching criteria via their JSON API."""
    results = []
    page = 1

    while True:
        url = (
            f"https://ksp.co.il/web/cat/Laptops-Notebooks/"
            f"?priceRange=0-{MAX_PRICE}&pageNum={page}&pageSize=48&sort=price_asc"
        )
        try:
            resp = requests.get(url, headers=HEADERS, timeout=15)
            resp.raise_for_status()
        except requests.RequestException as exc:
            print(f"  [KSP] שגיאת רשת: {exc}", file=sys.stderr)
            break

        # KSP returns JSON for this endpoint
        try:
            data = resp.json()
        except ValueError:
            # Fallback: the page might be HTML – try JSON API endpoint
            data = _ksp_json_fallback(page)
            if data is None:
                break

        items = data.get("data", data.get("products", data.get("items", [])))
        if not items:
            break

        for item in items:
            name = item.get("name", item.get("title", ""))
            desc = item.get("desc", item.get("description", item.get("spec", "")))
            price_raw = item.get("price", item.get("priceForSort", 0))
            try:
                price = float(str(price_raw).replace(",", "").replace("₪", "").strip())
            except ValueError:
                continue
            link = item.get("url", item.get("link", ""))
            if link and not link.startswith("http"):
                link = KSP_PRODUCT_BASE + link

            if matches_criteria(name, desc, price):
                results.append({"source": "KSP", "name": name, "price": price, "url": link})

        # Stop if last page
        total = data.get("total", data.get("totalItems", len(items)))
        if page * 48 >= int(total):
            break
        page += 1

    return results


def _ksp_json_fallback(page: int):
    """Try KSP's alternative JSON search endpoint."""
    try:
        resp = requests.get(
            "https://ksp.co.il/web/api/search",
            params={
                "q": "מחשב נייד",
                "priceMax": MAX_PRICE,
                "category": "laptops",
                "pageNum": page,
            },
            headers=HEADERS,
            timeout=15,
        )
        resp.raise_for_status()
        return resp.json()
    except (requests.RequestException, ValueError):
        return None


# ---------------------------------------------------------------------------
# IVORY scraper  (ivory.co.il)
# ---------------------------------------------------------------------------

IVORY_API = "https://www.ivory.co.il/catalog.php"
IVORY_PRODUCT_BASE = "https://www.ivory.co.il"


def search_ivory() -> list[dict]:
    """Search IVORY for laptops matching criteria via their catalog API."""
    results = []
    page = 1

    while True:
        params = {
            "act": "cat",
            "cid": "31",          # category ID for laptops on ivory.co.il
            "priceMax": MAX_PRICE,
            "inStock": "1",
            "page": page,
            "sort": "price_asc",
        }
        try:
            resp = requests.get(
                IVORY_API, params=params, headers=HEADERS, timeout=15
            )
            resp.raise_for_status()
        except requests.RequestException as exc:
            print(f"  [IVORY] שגיאת רשת: {exc}", file=sys.stderr)
            break

        try:
            data = resp.json()
        except ValueError:
            break

        items = data.get("data", data.get("products", data.get("items", [])))
        if not items:
            break

        for item in items:
            name = item.get("name", item.get("title", ""))
            desc = item.get("desc", item.get("description", item.get("longdesc", "")))
            price_raw = item.get("price", item.get("final_price", 0))
            try:
                price = float(str(price_raw).replace(",", "").replace("₪", "").strip())
            except ValueError:
                continue
            link = item.get("url", item.get("link", ""))
            if link and not link.startswith("http"):
                link = IVORY_PRODUCT_BASE + "/" + link.lstrip("/")

            if matches_criteria(name, desc, price):
                results.append(
                    {"source": "IVORY", "name": name, "price": price, "url": link}
                )

        total = data.get("total", data.get("totalItems", len(items)))
        if page * 48 >= int(total):
            break
        page += 1

    return results


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    print("=" * 60)
    print("חיפוש מחשבים ניידים – IVORY ו-KSP")
    print(f"קריטריונים: i5+, 16GB+ RAM, 512GB+ SSD, עד {MAX_PRICE} ש\"ח, ללא Windows")
    print("=" * 60)
    print()

    all_results: list[dict] = []

    print("מחפש ב-KSP…")
    ksp_results = search_ksp()
    print(f"נמצאו {len(ksp_results)} תוצאות ב-KSP\n")
    all_results.extend(ksp_results)

    print("מחפש ב-IVORY…")
    ivory_results = search_ivory()
    print(f"נמצאו {len(ivory_results)} תוצאות ב-IVORY\n")
    all_results.extend(ivory_results)

    if not all_results:
        print("לא נמצאו תוצאות התואמות את הקריטריונים.")
        return

    # Sort by price
    all_results.sort(key=lambda x: x["price"])

    print("=" * 60)
    print(f"סה\"כ {len(all_results)} מוצרים נמצאו (ממוינים לפי מחיר):")
    print("=" * 60)
    print()
    for item in all_results:
        print_result(item["source"], item["name"], item["price"], item["url"])


if __name__ == "__main__":
    main()
