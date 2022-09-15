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
        pass



class TestIsUniqueString(unittest.TestCase):
    """
    2 Katas
    """
    def test_empty_string(self):
        self.assertTrue(questions.is_unique_string(''))

    def test_none(self):
        self.assertTrue(questions.is_unique_string(None))

    def test_wrong_string(self):
        self.assertFalse(questions.is_unique_string('abbccbba'))
        # your code here

    def test_right_string(self):
        self.assertTrue(questions.is_unique_string('abcd'))


class TestListDiff(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        pass


class TestPrimeNumber(unittest.TestCase):
    """
    1 Katas
    """

    def test_sample(self):
        # your code here
        pass


class TestPalindromeNum(unittest.TestCase):
    """
    1 Katas
    """

    def test_palindrome_num_one_digit(self):
        self.assertFalse(questions.palindrome_num(0))
        print("TEST: test_palindrome_num_one_digit is pass")

    def test_palindrome_num_wrong(self):
        self.assertFalse(questions.palindrome_num(123))
        print("TEST: test_palindrome_num_wrong is pass")

    def test_palindrome_num_valid(self):
        self.assertTrue(questions.palindrome_num(1441))
        print("TEST: test_palindrome_num_valid is pass")

class TestPairMatch(unittest.TestCase):
    """
    3 Katas
    """

    def test_pair_match_valid(self):
        # your code here
        mens = {"John": 20, "Abraham": 45}
        womens = {"July": 18, "Kim": 26}
        result = ['abs(John - July) = abs (20 - 18) = abs(2) =2', 'abs(John - Kim) = abs (20 - 26) = abs(-6) =6', 'abs(Abraham - July) = abs (45 - 18) = abs(27) =27', 'abs(Abraham - Kim) = abs (45 - 26) = abs(19) =19']
        self.assertEqual(questions.pair_match(mens,womens),result)
        print("Tests pair_match is : PASS !!!")

    def test_zero_values(self):
        men = {'Mony': 0, "Nick": 0}
        women = {"Imbal": 0, "Irit": 0}
        self.assertEqual(questions.pair_match(men,women), ('Mony', 'Imbal'))

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