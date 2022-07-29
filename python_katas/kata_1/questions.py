def sum_of_element(elements):
    """
    1 Kata

    :param elements: list of integers
    :return: Return int - the sum of all elements.
    """
    return sum(elements)


def verbing(word):
    """
    1 Kata

    Given a string 'word', if its length is at least 3, add 'ing' to its end.
    Unless it already ends in 'ing', in which case add 'ly' instead.
    If the string length is less than 3, leave it unchanged.

    e.g.
    teach -> teaching
    do -> do
    swimming -> swimmingly

    :param word: str
    :return: Return the resulting string.
    """
    if len(word) >= 3:
        if not word.endswith('ing'):
            word += 'ing'
        else:
            word += 'ly'
    return word


def words_concatenation(words):
    """
    1 Kata

    Given a list of words, write a program that concatenates the words.

    For example:
    words_concatenation(['take', 'me', 'home']) returns 'take me home'

    :param words: list of str
    :return: Return the resulting string.
    """
    space = ' '
    return_string = ""
    for i, word in enumerate(words):
        if i != (len(words) - 1):
            return_string = return_string + word + space
        else:
            return_string += word
    return return_string


def reverse_words_concatenation(words):
    """
    1 Kata

    Given a list of words, write a program that concatenates the words in a reverse way

    For example:
    reverse_words_concatenation(['take', 'me', 'home']) returns 'home me take'

    :param words: list of str
    :return: Return the resulting string.
    """
    return words_concatenation(list(reversed(words)))


def is_unique_string(some_str):
    """
    2 Kata

    Given a string, the function returns True if all characters in the string are unique, False otherwise

    e.g
    'abcd' -> True
    'aaabcd' -> False
    '' -> True      (empty string)

    :param some_str:
    :return: bool
    """
    if some_str == '' or some_str is None:
        return True
    else:
        return len(set(some_str)) >= len(some_str)


def list_diff(elements):
    """
    1 Kata

    Given a list of integers as an input, return the "diff" list - each element is
    reduces by its previous one. The first element should be None

    e.g.
    [1, 2, 3, 4, 7, 11] -> [None, 1, 1, 1, 3, 4]
    [] -> []
    [1, 5, 0, 4, 1, 1, 1] -> [None, 4, -5, 4, -3, 0, 0]

    :param elements: list of integers
    :return: the diff list
    """
    diff = []
    for i, element in enumerate(elements):
        if element is None:
            elements[i] = element = 0
        if i == 0:
            diff.append(None)
        else:
            diff.append(element - elements[i - 1])
    return diff


def prime_number(num):
    """
    1 Kata

    Check if the given number is prime or not.

    hint: use the built-in function "range"
    :param num: the number to check
    :return: bool. True if prime, else False
    """
    if num is None:
        return False
    prime = False
    if num == 1:
        return prime
    else:
        for i in range(2, num):
            if num % i == 0:
                prime = True
                break
    return prime


def palindrome_num(num):
    """
    1 Kata

    Check whether a number is palindrome or not

    e.g.
    1441 -> True
    123 -> False

    :param num: int
    :return: bool. True is palindrome, else False
    """
    return list(str(num)) == list(reversed(str(num)))


def pair_match(men, women):
    """
    3 Kata

    This function gets two dictionaries of the type:
    {
        "<name>": <age>
    }

    Where <name> is a string name, and <age> is an integer representing the age
    The function returns a pair of names (tuple), of from men dict, the other from women dict,
    where their absolute age differences is the minimal

    e.g.
    men = {"John": 20, "Abraham": 45}
    women = {"July": 18, "Kim": 26}

    The returned value should be a tuple ("John", "July") since:

    abs(John - Kim) = abs(20 - 26) = abs(-6) = 6
    abs(John - July) = abs(20 - 18) = abs(2) = 2
    abs(Abraham - Kim) = abs(45 - 26) = abs(19) = 19
    abs(Abraham - July) = abs(45 - 18) = abs(27) = 27

    :param men: dict mapping name -> age
    :param women: dict mapping name -> age
    :return: tuple (men_name, women_name) such their age absolute difference is the minimal
    """
    for value in list(men.values()):
        try:
            men[list(men.keys())[list(men.values()).index(value)]] = int(value)
        except:
            men[list(men.keys())[list(men.values()).index(value)]] = 0
    for value in list(women.values()):
        try:
            women[list(women.keys())[list(women.values()).index(value)]] = int(value)
        except:
            women[list(women.keys())[list(women.values()).index(value)]] = 0
    diff = abs(list(women.values())[0] - list(men.values())[0])
    out = (list(men.keys())[0], list(women.keys())[0])
    for women_key, women_value in women.items():
        for men_key, men_value in men.items():
            if abs(men_value - women_value) < diff:
                out = (men_key, women_key)

    return out
def bad_average(a, b, c):
    """
    1 Kata

    This function gets 3 numbers and calculates the average.
    There is a mistake in the following implementation, you are required to fix it

    :return:
    """
    return int((a + b + c) / 3)


def best_student(grades):
    """
    1 Kata

    This function gets a dict of students -> grades mapping, and returns the student with the highest grade

    e.g.
    {
        "Ben": 78,
        "Hen": 88,
        "Natan": 99,
        "Efraim": 65,
        "Rachel": 95
    }

    will return "Natan"

    :param grades: dict of name -> grade mapping
    :return: str. some key from the dict
    """
    for value in list(grades.values()):
        try:
            grades[list(grades.keys())[list(grades.values()).index(value)]] = int(value)
        except:
            grades[list(grades.keys())[list(grades.values()).index(value)]] = 0
    print(grades)
    return max(grades, key=grades.get)


def print_dict_as_table(some_dict):
    """
    1 Kata

    Prints dictionary keys and values as the following format. For:
    {
        "Ben": 78,
        "Hen": 88,
        "Natan": 99,
        "Efraim": 65,
        "Rachel": 95
    }

    The output will be:

    Key     Value
    -------------
    Ben     78
    Hen     88
    Natan   99
    Efraim  65
    Rachel  95

    :param some_dict:
    :return:
    """
    sign = '-'
    white_space = ' '
    number_signs = 13
    max_number_digits_value = 3
    out = ('\033[3m' + 'Key ' + white_space * (
                number_signs - len('Key') - len('Value') - 2) + ' Value\n' + sign * number_signs + '\n')

    for key, value in some_dict.items():
        out += key.strip() + (white_space * (number_signs - len(key) - max_number_digits_value - 2)) + str(value) + '\n'
    return out


def merge_dicts(dict1, dict2):
    """
    1 Kata

    This functions merges dict2's keys and values into dict1, and returns dict1

    e.g.
    dict1 = {'a': 1}
    dict2 = {'b': 2}

    The results will by
    dict1 = {'a': 1, 'b': 2}

    :param dict1:
    :param dict2:
    :return:
    """
    return dict1 | dict2


def seven_boom(n):
    """
    1 Kata

    This functions returns a list of all "Booms" for a 7-boom play starting from 1 to n

    e.g. For n = 30
    The return value will be [7, 14, 17, 21, 27, 28]

    :param n: int. The last number for count for a 7-boom play
    :return: list of integers
    """
    booms = []
    if n is None:
        return booms
    for i in range(1, n):
        if '7' in str(i) or i % 7 == 0:
            booms.append(i)
    return booms


def caesar_cipher(str_to_encrypt):
    """
    2 Kata

    This function encrypts the given string according to caesar cipher (a - d, b - e, ..., y - b, z - c etc...).
    Spaces remain as they are. You can assume the string contain a-z and A-Z chars only.

    e.g.
    Fly Me To The Moon -> Iob Ph Wr Wkh Prrq

    :return:
    """
    import string
    set = string.ascii_lowercase
    set += 'a' + 'b' + 'c'
    str_to_encrypt = 'Fly Me To The Moon'
    encrypted = ''
    for char in str_to_encrypt:
        if char == ' ':
            encrypted += char
            continue
        if char.isupper():
            encrypted += set[set.index(char.lower()) + 3].upper()
        else:
            encrypted += set[set.index(char.lower()) + 3]
    return encrypted


def sum_of_digits(digits_str):
    """
    1 Kata

    Calculates the sum of digits in a string (you can assume the input is a string containing numeric digits only)

    e.g.
    '2524' -> 13
    '' -> 0
    '00232' -> 7


    :param digits_str: str of numerical digits only
    :return: int representing the sum of digits
    """
    return sum(list(map(int, digits_str)))


if __name__ == '__main__':
    print('\nsum_of_element:\n--------------------')
    print(sum_of_element([1, 2, 3, 4, 5, 6]))

    print('\nverbing:\n--------------------')
    print(verbing('walk'))
    print(verbing('swimming'))
    print(verbing('do'))

    print('\nwords_concatenation:\n--------------------')
    print(words_concatenation(['take', 'me', 'home']))

    print('\nreverse_words_concatenation:\n--------------------')
    print(reverse_words_concatenation(['take', 'me', 'home']))

    print('\nis_unique_string:\n--------------------')
    print(is_unique_string(''))
    print(is_unique_string('a'))

    print('\nlist_diff:\n--------------------')
    print(list_diff([1, 2, 3, 8, 77, 0]))

    print('\nprime_number:\n--------------------')
    print(prime_number(5))
    print(prime_number(22))

    print('\npalindrome_num:\n--------------------')
    print(palindrome_num(12221))
    print(palindrome_num(577))

    print('\npair_match:\n--------------------')
    print(pair_match(
        {
            "John": '20',
            "Abraham": '100'
        },
        {
            "July": 18,
            "Kim": 26
        }
    ))
    print(type(pair_match(
        {
            "John": 20,
            "Abraham": 45
        },
        {
            "July": 18,
            "Kim": 26
        }
    )))

    print('\nbad_average:\n--------------------')
    print(bad_average(1, 2, 3))

    print('\nbest_student:\n--------------------')
    print(best_student({
        "Ben": 78,
        "Dan": 88,
        "Nathan": None,
        "Daniel": 65,
        "Tal": 95
    }))

    print('\nprint_dict_as_table:\n--------------------')
    print(print_dict_as_table({
        "Ben": 78,
        "Dan": 88,
        "Nathan": 99,
        "Daniel": None,
        "Tal": 95
    }))

    print('\nmerge_dicts:\n--------------------')
    print(merge_dicts({None: None}, {'b': 2}))

    print('\nseven_boom:\n--------------------')
    print(seven_boom(None))

    print('\ncaesar_cipher:\n--------------------')
    print(caesar_cipher('Fly Me To The Moon'))

    print('\nsum_of_digits:\n--------------------')
    print(sum_of_digits('1223432'))
