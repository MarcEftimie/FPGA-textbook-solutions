n = 16
f = open("hdl/rom.txt", "a")
address_vals = []
for num1 in range(0, n):
    for num2 in range(num1, n):
        sum = num1 + num2
        address_vals.append([f'{num1:04b}{num2:04b}', f'{sum:08b}'])
address_vals.sort()
print(address_vals)
for val in address_vals:
    f.write(f'{val[1]}\n')
