n = 16
f = open("rom.txt", "a")
address_vals = []
for num1 in range(0, n):
    for num2 in range(0, n):
        sum = num1 + num2
        f.write(f'{sum:08b}\n')
        print(f'{sum:08b}\n')
