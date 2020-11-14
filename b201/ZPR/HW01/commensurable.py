import sys

def highestDivisor(a:int, b:int):
    if a == 0 | b == 0:
        return 0
    elif a == b:
        return a
    elif a<b:
        if (b % a) == 0:
            return a
        else:
            return highestDivisor(a, b % a)
    else:
        if (a % b) == 0:
            return b
        else:
            return highestDivisor(b, a % b)

def isCommensurable(a:int, b:int):
    if highestDivisor(a, b) > 1:
        return True
    else:
        return False

def tableCreator(k:int):
    table = ''
    # Wrong variant previously used: if k <= 0 | k > 99:
    if k <= 0 or k > 99:
        return 'ERROR'
    else:
        m, n = 1, 1
        row = ''
        for i in range(k * 2 - 1):
            row += '-'
        while n < k:
            while m < k:
                if isCommensurable(n, m) == True:
                    table += 'x|'
                else:
                    table += ' |'
                m += 1
            if isCommensurable(n, m) == True:
                table += 'x\n'+row+'\n'
            else:
                table += ' \n' + row + '\n'
            n += 1
            m = 1
        while m < k:
            if isCommensurable(n, m) == True:
                table += 'x|'
            else:
                table += ' |'
            m += 1
        if isCommensurable(n, m) == True:
            table += 'x'
        else:
            table += ' '
        return table

try:
    print(tableCreator((int(sys.argv[1]))))
except:
    print('ERROR')