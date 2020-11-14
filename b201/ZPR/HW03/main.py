import string
import sys

alpha_string = string.ascii_letters
error = None

with open(sys.argv[1], 'r') as file:
    original = list(file.readline().strip())
    template = list(file.readline().strip())


def compare(a: list, b: list):
    same = 0
    for i in range(len(a)):
        if a[i] == b[i]:
            same += 1
    return same


def shift(a, step):
    output = list()
    for letter in a:
        if letter in alpha_string:
            index = alpha_string.index(letter) + step
            if index >= len(alpha_string):
                index -= len(alpha_string)
            output.append(alpha_string[index])
    return output


def input_checker(a, b):
    global error
    for letter in a:
        if letter not in alpha_string:
            print('Error: Chybny vstup!')
            return False
    if len(a) != len(b):
        print('Error: Chybna delka vstupu!')
        return False
    else:
        return True


def caesar(a, b):
    if not input_checker(a, b):
        return False
    output = list()
    matching = 0
    for step in range(len(alpha_string)):
        temp = shift(a, step)
        temp2 = compare(temp, b)
        if temp2 > matching:
            output.clear()
            output = temp
            matching = temp2
    return output


result = caesar(original, template)
if result != False:
    answer = ''

    for letter in result:
        answer += letter

    with open('output.txt', 'w') as output:
        output.write(answer)