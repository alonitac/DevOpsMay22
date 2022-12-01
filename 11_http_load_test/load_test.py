import time
from loguru import logger
import aiohttp
import asyncio
from datetime import datetime

# change target url to your app under test
test_url = 'http://localhost:8080/load-test'

# test duration
test_duration_sec = 10

# http requests per second
requests_per_second = 50


async def single_req(session):
    req_start_time = datetime.now()

    async with session.get(test_url) as resp:
        logger.info(f'request results: code={resp.status} latency={datetime.now() - req_start_time} response={await resp.text()}')


async def test():
    async with aiohttp.ClientSession() as session:
        start_test_time = time.time()

        requests = []
        while time.time() - start_test_time < test_duration_sec:
            requests.append(asyncio.create_task(single_req(session)))
            await asyncio.sleep(1 / requests_per_second)

        await asyncio.gather(*requests)

        logger.info('Test Done')


if __name__ == '__main__':
    asyncio.run(test())
