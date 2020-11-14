import sys
from fractions import Fraction

# !!DON'T FORGET COMMENT THOSE SYS.ARGVS!!
sys.argv[0] = 'input.txt'
with open(sys.argv[0], 'r') as file:
# with open(sys.argv[1], 'r') as file:
    lines = file.readlines()

p1 = lines[0].strip().split()
p2 = lines[1].strip().split()


def multiplication(p1, p2):
    p1 = list(reversed(p1))
    p2 = list(reversed(p2))
    result = [0] * (len(p1) + len(p2) - 1)
    for d1, n1 in enumerate(p1, start=0):
        for d2, n2 in enumerate(p2, start=0):
            result[d1 + d2] += n1 * n2
    return list(reversed(result))


def division(p1, p2):
    p1 = list(map(Fraction, p1))
    p2 = list(map(Fraction, p2))
    d1 = len(p1) - 1
    d2 = len(p2) - 1
    result = [0] * (d1 - d2 + 1)

    while True:
        if d1 < d2:
            break
        temp = d1 - d2
        temp2 = p1[d1] / p2[d2]
        result[temp] = temp2
        temp3 = [0] * temp
        temp3.append(temp2)
        temp4 = multiplication(temp3, p2)
        for d, n in enumerate(temp4, start=0):
            p1[d] = p1[d] - n
        while True:
            if p1[-1] == 0 and d1 != 0:
                del p1[-1]
                d1 = len(p1) - 1
            else: break
    return [result, p1]


tmp = division(p1, p2)

row1 = ''
row2 = ''
for n in tmp[0]:
    row1 += str(n) + ' '
for n in tmp[1]:
    row2 += str(n) + ' '
print(row1[0:-1])
print(row2[0:-1])
