f = open("rom_c.txt", "a")
f.truncate(0)
celsius_range = 100
for celsius in range(0, celsius_range + 1):
    farenheit = round((9/5) * celsius + 32)
    f.write(f'{farenheit:08b}\n')
    print(f'{farenheit:08b}\n')
f.close()

f = open("rom_f.txt", "a")
f.truncate(0)
farenheit_range = 212
for farenheit in range(0, farenheit_range + 1):
    if (farenheit < 33):
        f.write(f'{0:08b}\n')
        continue
    celsius = round((farenheit - 32) * (5/9))
    f.write(f'{celsius:08b}\n')
    print(f'{celsius:08b}\n')
    print(farenheit)
    print(celsius)
f.close()
