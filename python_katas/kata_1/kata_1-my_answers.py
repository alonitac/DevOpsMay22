def sum_of_element(elements):
    """
    Ex 1 - DONE
    1 Kata

    :param elements: list of integers
    :return: Return int - the sum of all elements.
    """
    if elements == []:
        return "List is Blank"

    s = 0
    for num in elements:
        s = s + num

    return s


def verbing(word):
    """
    Ex 2 - DONE
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
    if word == "" or word == " ":
        return "The word is Blank"

    if len ( word ) < 3:
        return word

    if word[-3:] == 'ing':
        return word + 'ly'

    return word + 'ing'


def words_concatenation(words):
    """
    Ex 3 - DONE
    1 Kata

    Given a list of words, write a program that concatenates the words.

    For example:
    words_concatenation(['take', 'me', 'home']) returns 'take me home'

    :param words: list of str
    :return: Return the resulting string.
    """
    if words == []:
        return "List is Blank"

    concat_words = ''

    for word in words:
        if len ( word ) > 0:
            concat_words += (word + ' ')

    if len ( concat_words ) > 0:
        concat_words = concat_words.rstrip ()

    return concat_words


def reverse_words_concatenation(words):
    """
    Ex 4 - DONE
    1 Kata

    Given a list of words, write a program that concatenates the words in a reverse way

    For example:
    reverse_words_concatenation(['take', 'me', 'home']) returns 'home me take'

    :param words: list of str
    :return: Return the resulting string.
    """
    concat_words = ''

    for word in words[::-1]:
        concat_words += word + ' '

    concat_words = concat_words.rstrip ()

    return concat_words


def is_unique_string(some_str):
    """
    Ex 5 - DONE
    2 Kata

    Given a string, the function returns True if all characters in the string are unique, False otherwise

    e.g
    'abcd' -> True
    'aaabcd' -> False
    '' -> True      (empty string)

    :param some_str:
    :return: bool
    """
    char_list = []

    for char in some_str:
        if char in char_list:
            return False

        char_list.append ( char )

    return True


def list_diff(elements):
    """
    Ex 6 - DONE
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
    if len ( elements ) == 0:
        return diff

    diff.append ( None )

    for i in range ( 1, len ( elements ) ):
        diff.append ( elements[i] - elements[i - 1] )

    return diff


def prime_number(num):
    """
    Ex 7 - DONE
    1 Kata

    Check if the given number is prime or not.

    hint: use the built-in function "range"
    :param num: the number to check
    :return: bool. True if prime, else False
    """

    if num < 1:
        return False

    if num == 1:
        return True

    for i in range ( 2, num ):
        if (num % i) == 0:
            return False

    return True


def palindrome_num(num):
    """
    Ex 8 - Done
    1 Kata

    Check whether a number is palindrome or not

    e.g.
    1441 -> True
    123 -> False

    :param num: int
    :return: bool. True is palindrome, else False
    """
    temp = num
    rev = 0
    while num > 0:
        dig = num % 10
        rev = rev * 10 + dig
        num = num // 10
    if temp == rev:
        return True
    else:
        return False


def pair_match(men, women):
    """
    Ex 9 - Done
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
    mindif = 1000
    mywoman = ""
    myman = ""
    for x, y in men.items ():
        for z, t in women.items ():
            dif = abs ( y - t )
            if dif < mindif:
                mindif = dif
                mywoman = z
                myman = x
                pair = (myman, mywoman)
    return pair


def bad_average(a, b, c):
    """
    Ex. 10 - Done
    1 Kata

    This function gets 3 numbers and calculates the average.
    There is a mistake in the following implementation, you are required to fix it

    :return:
    """
    num_avg = (a + b + c) // 3
    return num_avg


def best_student(grades):
    """
    Ex. 11 - Done
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
    highestGrade = -1
    # for student in grades:
    for student in grades.keys ():
        g = grades[student]
        if g > highestGrade:
            highestGrade = g
            bestStudent = student

    return bestStudent


def print_dict_as_table(some_dict):
    """
    Ex. 12 - Done
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

    # def print_dict_as_table(some_dict):
    max_len = 0

    for k in some_dict:
        if len ( str ( k ) ) > max_len:
            max_len = len ( str ( k ) )

    max_len += 5

    to_return = 'Key'
    for i in range ( max_len - 3 ):
        to_return += ' '
    to_return += 'Value\n'

    for i in range ( max_len + 5 ):
        to_return += '-'
    to_return += '\n'

    for k in some_dict:
        to_return += str ( k )
        for l in range ( max_len - len ( str ( k ) ) ):
            to_return += ' '
        to_return += str ( some_dict[k] ) + '\n'

    return to_return


def merge_dicts(dict1, dict2):
    """
    Ex. 13
    1 Kata - Done

    This functions merges dict2's keys and values into dict1, and returns dict1

    e.g.
    dict1 = {'a': 1}
    dict2 = {'b': 2}

    The results will be
    dict1 = {'a': 1, 'b': 2}

    :param dict1:
    :param dict2:
    :return:
        for key in dict2:
            # add pair from dict2 if key in dict1 not exists; update value in dict1 from dict2 if key in dict1 exists
            #dict1[key] = dict2[key]
            dict1.update(dict2(key))
    """
    # add pair from dict2 if key in dict1 not exists; update value in dict1 from dict2 if key in dict1 exists
    dict1.update ( dict2 )
    return dict1


def seven_boom(n):
    """
    Ex. 14 - Done
    1 Kata

    This functions returns a list of all "Booms" for a 7-boom play starting from 1 to n

    e.g. For n = 30
    The return value will be [7, 14, 17, 21, 27, 28]

    :param n: int. The last number for count for a 7-boom play
    :return: list of integers
    """
    listofint = []
    for i in range ( 1, n + 1 ):
        i_str = str ( i )
        if "7" in i_str or i % 7 == 0:
            listofint.append ( i )
    return listofint


def caesar_cipher(cstr_to_encrypt):
    """
    #14 - Done
    2 Kata

    This function encrypts the given string according to caesar cipher (a - d, b - e, ..., y - b, z - c etc...).
    Spaces remain as they are. You can assume the string contain a-z and A-Z chars only.

    e.g.
    Fly Me To The Moon -> Iob Ph Wr Wkh Prrq

    :return:
    """
    result = ''
    shift = 3

    # traverse text
    for char in cstr_to_encrypt:
        asc_char = ord(char)
        if not char.isspace():
            if (asc_char not in range(65, 91)) and (asc_char not in range(97, 123)):
                return "You wrote illegal symbol in string"
        # Encrypt uppercase characters
        if char.isupper():
            result += chr((asc_char + shift - 65) % 26 + 65)
        # Do not encrypt spaces
        elif char.isspace():
            result += ' '
        # Encrypt lowercase characters
        else:
            result += chr((asc_char + shift - 97) % 26 + 97)

    return result


def sum_of_digits(digits_str):
    """
    Ex #15 - Done
    1 Kata

    Calculates the sum of digits in a string (you can assume the input is a string containing numeric digits only)

    e.g.
    '2524' -> 13
    '' -> 0
    '00232' -> 7

    :param digits_str: str of numerical digits only
    :return: int representing the sum of digits
    """
    result = 0
    for i in digits_str:
        result = int ( i ) + result
    return result


if __name__ == '__main__':
    print ( '\nsum_of_element:\n--------------------' )
    print ( sum_of_element ( [1, 2, 3, 4, 5, 6] ) )

    print ( '\nverbing:\n--------------------' )
    print ( verbing ( 'walk' ) )
    print ( verbing ( 'swimming' ) )
    print ( verbing ( 'do' ) )
    print ( verbing ( '' ) )

    print ( '\nwords_concatenation:\n--------------------' )
    print ( words_concatenation ( ['take', 'me', 'home'] ) )

    print ( '\nreverse_words_concatenation:\n--------------------' )
    print ( reverse_words_concatenation ( ['take', 'me', 'home'] ) )

    print ( '\nis_unique_string:\n--------------------' )
    print ( is_unique_string ( 'aasdssdsederd' ) )
    print ( is_unique_string ( '12345tgbnh' ) )

    print ( '\nlist_diff:\n--------------------' )
    print ( list_diff ( [1, 2, 3, 8, 77, 0] ) )

    print ( '\nprime_number:\n--------------------' )
    print ( prime_number ( 5 ) )
    print ( prime_number ( 22 ) )

    print ( '\npalindrome_num:\n--------------------' )
    print ( palindrome_num ( 12221 ) )
    print ( palindrome_num ( 577 ) )

    print ( '\npair_match:\n--------------------' )
    print ( pair_match (
        {
            "John": 20,
            "Abraham": 45
        },
        {
            "July": 18,
            "Kim": 26
        }
    ) )

    print ( '\nbad_average:\n--------------------' )
    print ( bad_average ( 1, 2, 3 ) )

    print ( '\nbest_student:\n--------------------' )
    print ( best_student ( {
        "Ben": 78,
        "Dan": 88,
        "Nathan": 99,
        "Daniel": 65,
        "Tal": 95
    } ) )

    print ( '\nprint_dict_as_table:\n--------------------' )
    print ( print_dict_as_table ( {
        "Ben": 78,
        "Dan": 88,
        "Nathan": 99,
        "Daniel": 65,
        "Tal": 95
    } ) )

    print ( '\nmerge_dicts:\n--------------------' )
    print ( merge_dicts ( {'a': 1}, {'b': 2} ) )

    print ( '\nseven_boom:\n--------------------' )
    print ( seven_boom ( 30 ) )

    print ( '\ncaesar_cipher:\n--------------------' )
    print ( caesar_cipher ( 'Fly Me To The Moon' ) )

    print ( '\nsum_of_digits:\n--------------------' )
    print ( sum_of_digits ( '1223432' ) )
