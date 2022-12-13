import unittest
from python_katas.kata_3 import questions
from python_katas.utils import unittest_runner


class TestKnapsack(unittest.TestCase):
    """
    5 Kata
    """
    def test_sample(self):
        # your code here
        pass


class TestTimeMe(unittest.TestCase):
    """
    2 Kata
    """
    def test_sample(self):
        # your code here
        pass


class TestYoutubeDownload(unittest.TestCase):
    """
    3 Kata
    """
    def test_sample(self):
        # your code here
        pass


class TestTasksScheduling(unittest.TestCase):
    """
    5 Kata
    """
    def test_sample(self):
        # your code here
        pass


class TestValidDag(unittest.TestCase):
    """
    5 Kata
    """
    def test_sample(self):
        # your code here
        pass


class TestRotateImg(unittest.TestCase):
    """
    3 Kata
    """
    def test_sample(self):
        # your code here
        pass


class TestImgBlur(unittest.TestCase):
    """
    4 Kata
    """
    def test_sample(self):
        # your code here
        pass


class TestApacheLogsParser(unittest.TestCase):
    """
    3 Kata
    """
    def test_sample(self):
        # your code here
        pass


class TestSimpleHttpRequest(unittest.TestCase):
    """
    2 Kata
    """
    def test_sample(self):
        # your code here
        pass


if __name__ == '__main__':
    import inspect
    import sys
    unittest_runner(inspect.getmembers(sys.modules[__name__], inspect.isclass))
