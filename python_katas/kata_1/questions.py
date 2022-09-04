def sum_of_element(elements):
    """
    1 Kata

    :param elements: list of integers
    :return: Return int - the sum of all elements.
    """
    s = 0
    for num in elements:
        s = s + num

    return s


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
    if(len(word) >= 3) :
        last3char = word [-3]
        if (last3char == "ing") :
           new_word = word+"ly"
        if(len(word) >= 3) :
            new_word = word+"ing"
    if(len(word)  <= 3) :
        new_word = word
    return new_word
result1 = verbing("swim")
result2 = verbing("tea")
result3 = verbing("smoothly")
print ("result1:" , result1)
print ("result2:" , result2)
print ("result3:" , result3)


def words_concatenation(words):
    """
    1 Kata

    Given a list of words, write a program that concatenates the words.

    For example:
    words_concatenation(['take', 'me', 'home']) returns 'take me home'

    :param words: list of str
    :return: Return the resulting string.
    """
    phrase=[]
    phrase=" ".join(words)
    return phrase
result4 = words_concatenation(['take', 'me', 'home','now'])
print ("result4:" , result4)

def reverse_words_concatenation(words):
    """
    1 Kata

    Given a list of words, write a program that concatenates the words in a reverse way

    For example:
    reverse_words_concatenation(['take', 'me', 'home']) returns 'home me take'

    :param words: list of str
    :return: Return the resulting string.
    
    """
    new_words = list(reversed(words))
    result_words = " ".join(new_words)
    return result_words
result5 = reverse_words_concatenation(['take', 'me', 'home','now','please'])
print ("result5:" , result5)

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
    char_dict = {}
    
    if len(some_str)==0: 
        return False
    else : 
        some_str_list = [*some_str]
    for char in some_str_list:
        if char in char_dict.keys():
            return False
        else:
            char_dict[char]=1
    return True
is_unique_string1 = is_unique_string("")
is_unique_string2 = is_unique_string("abcd")
is_unique_string3 = is_unique_string("abcccd")
print ("is_unique_string1", is_unique_string1)
print ("is_unique_string2", is_unique_string2)
print ("is_unique_string3", is_unique_string3)


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
    i = 0
    if len(elements) == 0 :
        diff_list = []
        return diff_list
    else :
        diff_list = ['None']
        while i < len(elements) -1 : 
            num = elements[i+1] - elements[i]
            diff_list .append(num)
            i += 1
            
    return diff_list
list_diff1 = list_diff([])
print ("list_diff1", list_diff1)
list_diff2 = list_diff([1, 5, 0, 4, 1, 1, 1])
print ("list_diff2", list_diff2)
list_diff3 = list_diff([1, 2, 3, 4, 7, 11])
print ("list_diff3", list_diff3)


def prime_number(num):
    """
    1 Kata

    Check if the given number is prime or not.

    hint: use the built-in function "range"
    :param num: the number to check
    :return: bool. True if prime, else False
    3/3
    3/1
    
    """
    for i in range(2,num):
        if (num%i) == 0:
            return False
    return True
prime_number1 = prime_number(59)       
print (" Is prime num : 59" , prime_number1)
prime_number2 = prime_number(97)
print (" Is prime num : 97" , prime_number2)
prime_number3 = prime_number(100)
print (" Is prime num : 100" , prime_number3)

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
    
    num_reversed = int(str(num)[::-1])
    if num== num_reversed :
        return True
    return False

palindrome_num1=palindrome_num(1441)
print("1441 is Palindrome : ",palindrome_num1)
palindrome_num2=palindrome_num(123)
print("123 is Palindrome : ",palindrome_num2)
palindrome_num3=palindrome_num(8765115678)
print("8765115678 is Palindrome : ",palindrome_num3)

def pair_match(mens, womens):
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
    result_tuple = []
    for men in mens : 
       men_name = men 
       men_age = mens[men]
       for woman in womens :
           woman_name = woman
           woman_age = womens[woman]
           age_diff = int(men_age) - int(woman_age)
           if age_diff < 0 :
                diff_age = age_diff * -1
           else: 
                diff_age = age_diff
           string4add = f'abs({men_name} - {woman_name}) = abs ({men_age} - {woman_age}) = abs({age_diff}) ={diff_age}'
           result_tuple.append(string4add)
           
    return result_tuple

mens = {"John": 20, "Abraham": 45}
womens = {"July": 18, "Kim": 26}
pair_match1= pair_match(mens, womens)
print ("pair_match result is : " ,pair_match1)

def bad_average(a, b, c):
    """
    1 Kata

    This function gets 3 numbers and calculates the average.
    There is a mistake in the following implementation, you are required to fix it

    :return:
    
    """
    return (a + b + c) / 3

bad_average1= bad_average(1,2,3)
print ("bad_average1",bad_average1)


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
    best_student_Name = list(grades.keys())[0]
    best_student_Grade = list(grades.values())[0]
    for student_name ,student_grade  in grades.items() : 
        if int(student_grade) > int(best_student_Grade) : 
            best_student_Name = student_name 
            best_student_Grade = student_grade
    print(f'Best stuendt name is : {best_student_Name} with a grade : {best_student_Grade}')
    return best_student_Name
grades = {
        "Ben": 78,
        "Hen": 88,
        "Natan": 99,
        "Efraim": 65,
        "Rachel": 95
    }
best_student1 = best_student(grades)
print("best_student1 : " , best_student1)

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
    
    print("{:<10} {:<10}".format('Key','Value'))
    print("-------------")
    for k,v in some_dict.items() :
        Key= k
        Value = v
        print("{:<10} {:<10}".format(Key,Value))
    
    return None

some_dict= {
        "Ben": 78,
        "Hen": 88,
        "Natan": 99,
        "Efraim": 65,
        "Rachel": 95
    }
print_dict_as_table(some_dict)



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
    temp_dict = dict1.copy()
    temp_dict.update(dict2)
    
    return temp_dict

dict1 = {'a': 1}
dict2 = {'b': 2} 
merge_dicts1 = merge_dicts(dict1, dict2)
print("merge_dicts1 is :" , merge_dicts1)

def seven_boom(n):
    """
    1 Kata

    This functions returns a list of all "Booms" for a 7-boom play starting from 1 to n

    e.g. For n = 30
    The return value will be [7, 14, 17, 21, 27, 28]

    :param n: int. The last number for count for a 7-boom play
    :return: list of integers
    """
    Booms=[]
    BoomNum = 7
    for i in range (1,n,1):
         if (i/BoomNum).is_integer() or i/BoomNum==0  : 
            Booms.append(i)
         else:
            number= [int(d) for d in str(i)]
            for dig in number : 
                if str(dig) == str(BoomNum) :
                    Booms.append(i)
                
    
        
    
    return Booms

n = 30
seven_boom1= seven_boom(n)
print ("Seven_boom result is : ",seven_boom1)

def caesar_cipher(str_to_encrypt):
    import string
    a_z_lower = list(string.ascii_lowercase)
    A_Z_Upper= list(string.ascii_uppercase)
    encryption_offset = 3
    encrypted_string = []
    """
    2 Kata

    This function encrypts the given string according to caesar cipher (a - d, b - e, ..., y - b, z - c etc...).
    Spaces remain as they are. You can assume the string contain a-z and A-Z chars only.

    e.g.
    Fly Me To The Moon -> Iob Ph Wr Wkh Prrq

    :return:
    """
    for char_str in str_to_encrypt:
        if char_str.isspace() :
            char4add = char_str
        if char_str.isupper() :
            char_index= A_Z_Upper.index(char_str)
            if (char_index + encryption_offset) > len(A_Z_Upper) :
                char_index = (char_index + encryption_offset) - len(A_Z_Upper)
            else : 
                char_index = char_index + encryption_offset
            char4add= A_Z_Upper[char_index]
        if char_str.islower() :
            char_index= a_z_lower.index(char_str)
            if (char_index + encryption_offset) > len(a_z_lower) : 
                char_index = (char_index + encryption_offset) - len(a_z_lower)
            else : 
                char_index = char_index + encryption_offset            
            char4add = a_z_lower[char_index]
            
        encrypted_string.append(char4add)
    encrypted_string= ''.join(encrypted_string)
    return encrypted_string

str_to_encrypt="Fly Me To The Moon"
caesar_cipher1= caesar_cipher(str_to_encrypt)
print("caesar_cipher1 resiult : ",caesar_cipher1)

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
    summ = 0
    if digits_str == "":
        return summ
    else: 
        for i in digits_str:
            summ+=int(i)
        
    return summ
digits_str1 = '2524'
digits_str2 = ''
digits_str3 = '00232'

sum_of_digits1 = sum_of_digits(digits_str1)
sum_of_digits2 = sum_of_digits(digits_str2)
sum_of_digits3 = sum_of_digits(digits_str3)
print ("sum_of_digits1", sum_of_digits1)
print ("sum_of_digits2", sum_of_digits2)
print ("sum_of_digits3", sum_of_digits3)

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
    print(is_unique_string('aasdssdsederd'))
    print(is_unique_string('12345tgbnh'))

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
            "John": 20,
            "Abraham": 45
        },
        {
            "July": 18,
            "Kim": 26
        }
    ))

    print('\nbad_average:\n--------------------')
    print(bad_average(1, 2, 3))

    print('\nbest_student:\n--------------------')
    print(best_student({
        "Ben": 78,
        "Dan": 88,
        "Nathan": 99,
        "Daniel": 65,
        "Tal": 95
    }))

    print('\nprint_dict_as_table:\n--------------------')
    print(print_dict_as_table({
        "Ben": 78,
        "Dan": 88,
        "Nathan": 99,
        "Daniel": 65,
        "Tal": 95
    }))

    print('\nmerge_dicts:\n--------------------')
    print(merge_dicts({'a': 1}, {'b': 2}))

    print('\nseven_boom:\n--------------------')
    print(seven_boom(30))

    print('\ncaesar_cipher:\n--------------------')
    print(caesar_cipher('Fly Me To The Moon'))

    print('\nsum_of_digits:\n--------------------')
    print(sum_of_digits('1223432'))

