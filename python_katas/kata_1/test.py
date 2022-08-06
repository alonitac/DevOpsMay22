import unittest
import questions

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
        self.assertEqual(questions.words_concatenation([]), '')

    def test_one_element_none(self):
        self.assertEqual(questions.words_concatenation(['abc', None, 'xyz']), 'abc xyz')

    def test_if_return_string(self):
        self.assertIsInstance(questions.words_concatenation(['x', 'y', 'z']), str)

    def test_str(self):
        self.assertEqual(questions.words_concatenation(['I', 'am', 'a', 'list']), 'I am a list')

class TestReverseWordsConcatenation(unittest.TestCase):
    """
    1 Katas
    """
    def test_empty_list(self):
        self.assertEqual(questions.reverse_words_concatenation([]), '')

    def test_one_element_none(self):
        self.assertEqual(questions.reverse_words_concatenation(['abc',None,'xyz']), 'xyz abc')

    def test_if_return_string(self):
        self.assertIsInstance(questions.reverse_words_concatenation(['x', 'y', 'z']), str)

    def tes_str(self):
        self.assertEqual(questions.reverse_words_concatenation(['I', 'am', 'a', 'list']), 'list a am I')

class TestIsUniqueString(unittest.TestCase):
    """
    2 Katas
    """
    def test_empty_str(self):
        self.assertTrue(questions.is_unique_string(''))

    def test_None(self):
        self.assertTrue(questions.is_unique_string(None))

    def test_not_unique(self):
        self.assertFalse(questions.is_unique_string('aabbcc'))

    def tes_unique(self):
        self.assertTrue(questions.is_unique_string('abc'))


class TestListDiff(unittest.TestCase):
    """
    1 Katas
    """
    def test_if_return_list(self):
        self.assertIsInstance(questions.list_diff([1, 2]), list)

    def test_first_element_None(self):
        self.assertIsNone(questions.list_diff([1, 2, 3])[0])

    def test_empty_list(self):
        self.assertEqual(questions.list_diff([]), [])

    def test_all_negative(self):
        self.assertEqual(questions.list_diff([-1, -2, -3, -4, -5]), [None, -1, -1, -1, -1])

    def test_first_negative(self):
        self.assertEqual(questions.list_diff([-1, 1, 1]), [None, 2, 0])

    def test_all_positive(self):
        self.assertEqual(questions.list_diff([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), [None, 1, 1, 1, 1, 1, 1, 1, 1, 1])


class TestPrimeNumber(unittest.TestCase):
    """
    1 Katas
    """

    def test_negative(self):
        self.assertFalse(questions.prime_number(-1))

    def test_zero(self):
        self.assertFalse(questions.prime_number(0))

    def test_none(self):
        self.assertFalse(questions.prime_number(None))

    def test_float(self):
        self.assertFalse(questions.prime_number(5.5))

    def test_one(self):
        self.assertFalse(questions.prime_number(1))

    def test_prime_true(self):
        self.assertTrue(questions.prime_number(47))

    def test_prime_false(self):
        self.assertFalse(questions.prime_number(55))

class TestPalindromeNum(unittest.TestCase):
    """
    1 Katas
    """

    def test_single_digit(self):
        self.assertTrue(questions.palindrome_num(0))

    def test_true(self):
        self.assertTrue(questions.palindrome_num(1221))

    def test_false(self):
        self.assertFalse(questions.palindrome_num(577))



class TestPairMatch(unittest.TestCase):
    """
    3 Katas
    """

    def negative_vaules(self):
        men = {"John": -20, "Abraham": -45}
        women = {"July": -18, "Kim": -26}
        result = ('John', 'July')
        self.assertEqual(questions.pair_match(men, women), result)

    def is_result_tuple(self):
        men = {"John": -20, "Abraham": -45}
        women = {"July": -18, "Kim": -26}
        self.assertIsInstance(questions.pair_match(men,women), tuple)

    def none_value(self):
        men = {"John": -20, "Abraham": -45}
        women = {"July": None, "Kim": -26}
        self.assertEqual(questions.pair_match(men,women), ('Abraham', 'Kim'))

    def none_key(self):
        men = {None: 255, "Abraham": 55}
        women = {"July": 55, "Kim": 256}
        self.assertEqual(questions.pair_match(men,women), (None, 'Kim'))

    def zero_values(self):
        men = {'Mony': 0, "Nick": 0}
        women = {"Imbal": 0, "Irit": 0}
        self.assertEqual(questions.pair_match(men,women), ('Mony', 'Imbal'))

class TestBadAverage(unittest.TestCase):
    """
    1 Katas
    """

    def test_zeros(self):
        self.assertEqual(questions.bad_average(0, 0, 0), 0)

    def test_negative(self):
        self.assertEqual(questions.bad_average(-5, -5, -5), -5)

    def test_correct(self):
        self.assertEqual(questions.bad_average(20, 40, 40), 33)

    def test_float(self):
        self.assertEqual(questions.bad_average(5.5, 5.5, 5.5), 5)

    def test_return_int(self):
        self.assertIsInstance(questions.bad_average(0, 0, 0), int)


class TestBestStudent(unittest.TestCase):
    """
    1 Katas
    """

    def test_none_value(self):
        data = {
        "Ben": 78,
        "Dan": 88,
        "Nathan": None,
        "Daniel": 65,
        "Tal": 95
        }
        self.assertEqual(questions.best_student(data), 'Tal')

    def return_string(self):
        data = {
            "Ben": 78,
            "Dan": 88,
            "Nathan": None,
            "Daniel": 65,
            "Tal": 95
                }
        self.assertIsInstance(questions.best_student(data), str)

    def test_float(self):
        data = {
            "Ben": 78.55,
            "Dan": 88.66,
            "Nathan": None,
            "Daniel": 65.66,
            "Tal": 5.1
        }
        self.assertEqual(questions.best_student(data), 'Dan')

    def test_value_string(self):
        data = {
            None: 'x',
            "Dan": 88,
            "Nathan": None,
            "Daniel": 65,
            "Tal": 95
        }
        self.assertEqual(questions.best_student(data), 'Tal')

    def test_key_not_str(self):
        data = {
            None: 'x',
            "Dan": 88,
            "Nathan": None,
            "Daniel": 65,
            "Tal": 95
        }
        self.assertEqual(questions.best_student(data), 'Tal')


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

    def test_empty_dict(self):
        dict1 = {}
        dict2 = {}
        self.assertEqual(questions.merge_dicts(dict1, dict2), {})

    def test_return_dict(self):
        dict1 = {}
        dict2 = {}
        self.assertIsInstance(questions.merge_dicts(dict1, dict2), dict)

    def test_arg_dict(self):
        dict1 = {}
        dict2 = 'xx'
        self.assertEqual(questions.merge_dicts(dict1, dict2), {})
        dict1 = 1
        dict2 = 2
        self.assertEqual(questions.merge_dicts(dict1, dict2), {})



class TestSevenBoom(unittest.TestCase):
    """
    1 Katas
    """

    class TestSevenBoom(unittest.TestCase):
        """
        1 Katas
        """

        def test_negative(self):
            n = -7
            self.assertEqual(questions.seven_boom(n), [-7])

        def test_positive_seven(self):
            n = 7
            self.assertEqual(questions.seven_boom(n), [7])

        def test_zero(self):
            n = 0
            self.assertEqual(questions.seven_boom(n), [])

        def test_numeric_string(self):
            n = '7'
            self.assertEqual(questions.seven_boom(n), [7])

        def test_negative_numeric_string(self):
            n = '-7'
            self.assertEqual(questions.seven_boom(n), [-7])

        def test_return_int_element(self):
            n = 7
            self.assertIsInstance(questions.seven_boom(n)[0], int)

        def test_return_list(self):
            n = 7
            self.assertIsInstance(questions.seven_boom(n), list)

        def test_none(self):
            self.assertEqual(questions.seven_boom(None), [])

        def test_tuple(self):
            n = (4, 4)
            self.assertEqual(questions.seven_boom(n), [])

        def test_list(self):
            n = [7, 7]
            self.assertEqual(questions.seven_boom(n), [])

        def test_dict(self):
            n = {4: 4}
            self.assertEqual(questions.seven_boom(n), [])

        def test_string(self):
            n = '7x'
            self.assertEqual(questions.seven_boom(n), [])


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
