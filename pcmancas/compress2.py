#!/usr/bin/env python3

import sys

input_file = "pcmanfont.bin" if len(sys.argv) <= 1 else sys.argv[1]
f = open("pcmanfont.bin", "rb")

byt = f.read()

length = len(byt)

width = 9

chunks = length // width
remainder = length % width
if remainder != 0:
    print(f"File {input_file} length {length} is not evenly divisible by {width}")

pile = []


def main():
    pile = []

    for chunk in range(chunks):
        data = byt[chunk * width : chunk * width + width]

        key = "0" + "h,0".join([f"{x:02x}" for x in data]) + "h"

        pile.append(idx2[key])

    print("; Consists of index into table 2 and # of repeats")
    print("font_tbl_1:")
    acc = 0
    last = None
    for i in pile:
        if i == last:
            acc += 1
        elif last is not None:
            print(f"\t\tdb\t{last},{acc}")
            last = i
            acc = 1
        else:
            last = i
            acc = 1
    if acc > 0:
        print(f"\t\tdb\t{last},{acc}")
    print("\t\tdb\t0,0")

    print("; 9-byte rows")
    print("font_tbl_2:")
    for k in idx2.keys():
        print(f"\t\tdb\t{k}")


idx = {
    "45 00 ": 0,
    "78 05 ": 1,
    "79 05 ": 2,
    "f7 05 ": 3,
    "62 82 03 ": 4,
    "71 af 03 ": 5,
    "71 c7 01 ": 6,
    "71 ef 03 ": 7,
    "72 cf 02 ": 8,
    "78 4c 00 ": 9,
    "78 4e 00 ": 10,
    "78 4f 00 ": 11,
    "78 a7 01 ": 12,
    "78 af 03 ": 13,
    "78 cf 03 ": 14,
    "78 ef 03 ": 15,
    "78 ff 03 ": 16,
    "81 47 00 ": 17,
    "91 c7 03 ": 18,
    "92 cf 04 ": 19,
    "b1 a7 03 ": 20,
    "b1 c7 03 ": 21,
    "b2 af 04 ": 22,
    "f2 ef 04 ": 23,
    "f8 cf 05 ": 24,
    "78 fb af 01 ": 25,
    "79 fb ef 01 ": 26,
    "81 2f ab 02 ": 27,
    "82 ff 3a 00 ": 28,
    "91 f7 2e 00 ": 29,
    "b1 f7 2f 00 ": 30,
    "e2 92 2c 00 ": 31,
    "f1 df ef 03 ": 32,
    "f2 b2 2c 00 ": 33,
    "f8 df ef 03 ": 34,
    "f8 df ff 03 ": 35,
    "81 cf f1 2a 00 ": 36,
    "91 af f8 2e 00 ": 37,
    "91 ef f9 2e 00 ": 38,
    "b1 ff fb 2f 00 ": 39,
    "f9 fe df ef 01 ": 40,
    "fb fe df ff 01 ": 41,
    "ff fe df ff 0c ": 42,
}

idx2 = {
    "003h,0ffh,0ffh,0cfh,0ffh,0ffh,000h,000h,000h": 0,  # 26 repeats
    "000h,000h,000h,000h,000h,000h,000h,000h,000h": 1,  # 15 repeats
    "003h,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,000h": 2,  # 10 repeats
    "0ffh,0ffh,0ffh,0ffh,000h,000h,000h,000h,000h": 3,  # 8 repeats
    "00fh,0ffh,0ffh,0ffh,03fh,0ffh,0ffh,0fch,000h": 4,  # 6 repeats
    "000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0c0h,000h": 5,  # 6 repeats
    "003h,0ffh,0ffh,0c0h,000h,000h,000h,000h,000h": 6,  # 5 repeats
    "003h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f0h,000h": 7,  # 4 repeats
    "003h,0ffh,0ffh,0cfh,0ffh,0fch,000h,000h,000h": 8,  # 4 repeats
    "00fh,0ffh,0fch,0ffh,0ffh,0cfh,0ffh,0fch,000h": 9,  # 3 repeats
    "003h,0ffh,0ffh,0ffh,0ffh,0f0h,000h,000h,000h": 10,  # 3 repeats
    "003h,0ffh,0ffh,0ffh,0ffh,0c0h,000h,000h,000h": 11,  # 3 repeats
    "000h,03fh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h": 12,  # 3 repeats
    "0ffh,0ffh,0fch,0ffh,0ffh,0cfh,0ffh,0ffh,0c0h": 13,  # 2 repeats
    "03fh,0ffh,0fch,0ffh,0ffh,0cfh,0ffh,0ffh,000h": 14,  # 2 repeats
    "003h,0ffh,0ffh,0ffh,0ffh,0fch,000h,000h,000h": 15,  # 2 repeats
    "003h,0ffh,0ffh,0ffh,03fh,0ffh,0ffh,0f0h,000h": 16,  # 2 repeats
    "000h,0ffh,0ffh,0ffh,0ffh,0f0h,000h,000h,000h": 17,  # 2 repeats
    "000h,03fh,0ffh,0ffh,0ffh,0f0h,000h,000h,000h": 18,  # 2 repeats
    "000h,00fh,0ffh,0ffh,0ffh,0ffh,0fch,000h,000h": 19,  # 2 repeats
    "000h,00fh,0ffh,0fch,00fh,0ffh,0fch,000h,000h": 20,  # 2 repeats
    "000h,003h,0ffh,0c0h,000h,0ffh,0f0h,000h,000h": 21,  # 2 repeats
    "000h,000h,0ffh,0ffh,0ffh,0ffh,0c0h,000h,000h": 22,  # 2 repeats
    "000h,000h,0fch,000h,000h,00fh,0c0h,000h,000h": 23,  # 2 repeats
    "000h,000h,003h,0ffh,0ffh,0f0h,000h,000h,000h": 24,  # 2 repeats
    "00fh,0ffh,0ffh,0ffh,000h,000h,000h,000h,000h": 25,  # no repeats
    "003h,0ffh,0ffh,0ffh,0ffh,000h,000h,000h,000h": 26,  # no repeats
    "003h,0ffh,0ffh,0ffh,0fch,000h,000h,000h,000h": 27,  # no repeats
    "003h,0ffh,0ffh,0ffh,0c0h,000h,000h,000h,000h": 28,  # no repeats
    "003h,0ffh,0ffh,0ffh,000h,000h,000h,000h,000h": 29,  # no repeats
    "000h,0ffh,0ffh,0ffh,0ffh,0fch,000h,000h,000h": 30,  # no repeats
    "000h,0ffh,0ffh,0cfh,0ffh,0fch,000h,000h,000h": 31,  # no repeats
    "000h,03fh,0ffh,0ffh,0ffh,0c0h,000h,000h,000h": 32,  # no repeats
    "000h,03fh,0ffh,0ffh,03fh,0ffh,0ffh,000h,000h": 33,  # no repeats
    "000h,00fh,0ffh,0ffh,0ffh,0c0h,000h,000h,000h": 34,  # no repeats
    "000h,00fh,0ffh,0f0h,003h,0ffh,0fch,000h,000h": 35,  # no repeats
    "000h,003h,0ffh,0ffh,0ffh,000h,000h,000h,000h": 36,  # no repeats
    "000h,003h,0ffh,000h,000h,03fh,0f0h,000h,000h": 37,  # no repeats
    "000h,000h,0ffh,0ffh,0fch,000h,000h,000h,000h": 38,  # no repeats
    "000h,000h,0ffh,000h,000h,03fh,0c0h,000h,000h": 39,  # no repeats
    "000h,000h,03fh,0ffh,0f0h,000h,000h,000h,000h": 40,  # no repeats
    "000h,000h,030h,000h,000h,003h,000h,000h,000h": 41,  # no repeats
    "000h,000h,00fh,0ffh,0c0h,000h,000h,000h,000h": 42,  # no repeats
}

main()
