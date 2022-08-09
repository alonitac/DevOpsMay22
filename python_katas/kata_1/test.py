import unittest
from python_katas.kata_1 import questions
from python_katas.utils import unittest_runner


class TestSumOfElements(unittest.TestCase):
    """
    1 Katas
    """

    def test_empty_list(self):
        lst = []
        self.assertEqual(questions.sum_of_element(lst), 0)

    def test_integers_list(self):
        lst = [1, 2, 3, 4, 5]
        self.assertEqual(questions.sum_of_element(lst), 15)

    def test_negative_numbers(self):
        lst = [1, -6, 7, 0, 99]
        self.assertEqual(questions.sum_of_element(lst), 101)

    def test_all_zeros(self):
        lst = [0] * 50000
        self.assertEqual(questions.sum_of_element(lst), 0)


class TestWordsConcatenation(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        lst =['hey', 'how', 'are', 'you', '?']
        self.assertEqual(questions.words_concatenation(lst), 'hey how are you ?')

    def test_empty_list(self):
        lst = []
        self.assertEqual(questions.words_concatenation(lst), "")

    def test_full_list(self):
        lst = ['no', 'place', 'like', 'home']
        self.assertEqual(questions.words_concatenation(lst), 'no place like home')

    def test_empty_string_in_list(self):
        lst = ['no', '', 'place', '', 'like', 'home']
        self.assertEqual(questions.words_concatenation(lst), 'no place like home')

    def test_list_of_empty_strings(self):
        lst = ["","","","",""]
        self.assertEqual(questions.words_concatenation(lst),"")


class TestReverseWordsConcatenation(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        lst = ['take', 'me', 'home']
        self.assertEqual(questions.reverse_words_concatenation(lst), "home me take")

    def test_empty_list(self):
        # your code here
        lst = []
        self.assertEqual(questions.reverse_words_concatenation(lst), "")

    def test_full_list(self):
        # your code here
        lst = ['Hello','','are','you','today','?']
        self.assertEqual(questions.reverse_words_concatenation(lst), '? today you are Hello')

    def test_sample4(self):
        # your code here
        lst = ['1','','2','','3','','4','','5']
        self.assertEqual(questions.reverse_words_concatenation(lst), '5 4 3 2 1')


class TestIsUniqueString(unittest.TestCase):
    """
    2 Katas
    """

    def test_sample(self):
        # your code here
        some_str = ''
        self.assertEqual(questions.is_unique_string(some_str), True)
    def test_sample2(self):
        # your code here
        some_str = '123456'
        self.assertEqual(questions.is_unique_string(some_str), True)
    def test_sample3(self):
        # your code here
        some_str = 12345
        self.assertEqual(questions.is_unique_string(some_str), "Please enter a valid input(strings only)")

class TestListDiff(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        lst = [1, 2, 3, 4, 7, 11]
        self.assertEqual(questions.list_diff(lst), [None, 1, 1, 1, 3, 4])

    def test_sample2(self):
        # your code here
        lst = [1, 5, 0, 4, 1, 1, 1]
        self.assertEqual(questions.list_diff(lst), [None, 4, -5, 4, -3, 0, 0])

    def test_sample3(self):
        # your code here
        lst = []
        self.assertEqual(questions.list_diff(lst),[])

class TestPrimeNumber(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        num = 0
        self.assertEqual(questions.prime_number(num), f"{num}, is lower from 1 , please enter a higher number")


class TestPalindromeNum(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        pass


class TestPairMatch(unittest.TestCase):
    """
    3 Katas
    """

    def test_sample(self):
        # your code here
        pass


class TestBadAverage(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        pass


class TestBestStudent(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        pass


class TestPrintDictAsTable(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        pass


class TestMergeDicts(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        pass


class TestSevenBoom(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        pass


class TestCaesarCipher(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        pass


class TestSumOfDigits(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        pass


if __name__ == '__main__':
    import inspect
    import sys
    unittest_runner(inspect.getmembers(sys.modules[__name__], inspect.isclass))