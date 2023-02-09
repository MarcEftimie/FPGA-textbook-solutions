n = 16
f = open("hdl/rom.txt", "a")
for num1 in range(0, n):
    for num2 in range(num1, n):
        sum = num1 + num2

        print(f'{sum:05b}')
        f.write(f'{sum:05b}\n')
