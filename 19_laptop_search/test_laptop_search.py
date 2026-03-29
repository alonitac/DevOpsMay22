"""
Tests for laptop_search.py filtering helpers.
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from laptop_search import _has_good_cpu, _ram_ok, _ssd_ok, _no_windows_os, matches_criteria


# ---------------------------------------------------------------------------
# CPU filter
# ---------------------------------------------------------------------------

class TestHasGoodCpu:
    def test_i5_accepted(self):
        assert _has_good_cpu("Intel Core i5-1235U 16GB 512GB SSD")

    def test_i7_accepted(self):
        assert _has_good_cpu("Intel Core i7-12700H")

    def test_i9_accepted(self):
        assert _has_good_cpu("Intel Core i9-13900H")

    def test_ryzen5_accepted(self):
        assert _has_good_cpu("AMD Ryzen 5 5600H")

    def test_ryzen7_accepted(self):
        assert _has_good_cpu("AMD Ryzen 7 6800H")

    def test_i3_rejected(self):
        assert not _has_good_cpu("Intel Core i3-1215U 8GB 256GB")

    def test_celeron_rejected(self):
        assert not _has_good_cpu("Intel Celeron N4500 4GB 128GB eMMC")

    def test_atom_rejected(self):
        assert not _has_good_cpu("Intel Atom x5-Z8350")

    def test_ryzen3_rejected(self):
        assert not _has_good_cpu("AMD Ryzen 3 3200U")


# ---------------------------------------------------------------------------
# RAM filter
# ---------------------------------------------------------------------------

class TestRamOk:
    def test_16gb_accepted(self):
        assert _ram_ok("16GB DDR4 RAM")

    def test_32gb_accepted(self):
        assert _ram_ok("32GB DDR5")

    def test_64gb_accepted(self):
        assert _ram_ok("64GB LPDDR5")

    def test_8gb_rejected(self):
        assert not _ram_ok("8GB DDR4")

    def test_4gb_rejected(self):
        assert not _ram_ok("4GB RAM")


# ---------------------------------------------------------------------------
# SSD filter
# ---------------------------------------------------------------------------

class TestSsdOk:
    def test_512gb_accepted(self):
        assert _ssd_ok("512GB NVMe SSD")

    def test_1tb_accepted(self):
        assert _ssd_ok("1TB SSD")

    def test_2tb_accepted(self):
        assert _ssd_ok("2TB NVMe")

    def test_256gb_rejected(self):
        assert not _ssd_ok("256GB SSD")

    def test_128gb_rejected(self):
        assert not _ssd_ok("128GB eMMC")


# ---------------------------------------------------------------------------
# OS filter
# ---------------------------------------------------------------------------

class TestNoWindowsOs:
    def test_no_os_accepted(self):
        assert _no_windows_os("Intel i5 No OS")

    def test_freedos_accepted(self):
        assert _no_windows_os("Intel i5 FreeDOS")

    def test_linux_accepted(self):
        assert _no_windows_os("Ubuntu Linux installed")

    def test_dos_accepted(self):
        assert _no_windows_os("ללא מערכת הפעלה DOS")

    def test_windows_rejected(self):
        assert not _no_windows_os("Windows 11 Home")

    def test_windows11_rejected(self):
        assert not _no_windows_os("Intel i5 Windows 11")

    def test_no_os_keyword_hebrew(self):
        assert _no_windows_os("ללא מערכת הפעלה")


# ---------------------------------------------------------------------------
# Combined matches_criteria
# ---------------------------------------------------------------------------

class TestMatchesCriteria:
    def _good(self, **overrides):
        """Return a valid product dict."""
        base = dict(
            name="Laptop i5-1235U 16GB 512GB SSD No OS",
            description="FreeDOS installed",
            price=2999.0,
        )
        base.update(overrides)
        return base

    def test_good_product_accepted(self):
        p = self._good()
        assert matches_criteria(p["name"], p["description"], p["price"])

    def test_price_too_high_rejected(self):
        p = self._good(price=3001.0)
        assert not matches_criteria(p["name"], p["description"], p["price"])

    def test_price_at_limit_accepted(self):
        p = self._good(price=3000.0)
        assert matches_criteria(p["name"], p["description"], p["price"])

    def test_weak_cpu_rejected(self):
        p = self._good(name="Laptop i3-1215U 16GB 512GB SSD No OS")
        assert not matches_criteria(p["name"], p["description"], p["price"])

    def test_low_ram_rejected(self):
        p = self._good(name="Laptop i5-1235U 8GB 512GB SSD No OS")
        assert not matches_criteria(p["name"], p["description"], p["price"])

    def test_small_ssd_rejected(self):
        p = self._good(name="Laptop i5-1235U 16GB 256GB SSD No OS")
        assert not matches_criteria(p["name"], p["description"], p["price"])

    def test_windows_rejected(self):
        p = self._good(description="Windows 11 Home")
        assert not matches_criteria(p["name"], p["description"], p["price"])

    def test_i7_32gb_1tb_linux_accepted(self):
        assert matches_criteria(
            "Laptop i7-12700H 32GB 1TB NVMe SSD Linux",
            "No OS",
            2500.0,
        )
