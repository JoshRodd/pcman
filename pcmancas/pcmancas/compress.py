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

lookup_tbl = {
    0x03: 0 + 8,
    0x0F: 1 + 8,
    0xF0: 2 + 8,
    0x3F: 3 + 8,
    0xC0: 4 + 8,
    0xCF: 5 + 8,
    0xFC: 6 + 8,
    0xFF: 7 + 8,
    0x30: 6,
}

pile = []


def main():
    global num_zeroes
    global num_ffs
    global accum
    global text

    for chunk in range(chunks):
        data = byt[chunk * width : chunk * width + width]
        num_zeroes = 0
        num_ffs = 0

        # print(",".join([f"{x:02x}" for x in data]))

        accum = ""
        text = ""

        def emit(symbol, repeats):
            global accum
            global text
            if symbol == 0:
                if repeats > 5:
                    raise Exception("Cannot encode 0 with more than 5 repeats")
                output = repeats
            elif symbol == 255 and repeats == 3:
                output = 7
            else:
                if repeats != 1:
                    raise Exception(f"Cannot encode {symbol} with other than 1 repeat")
                output = lookup_tbl[symbol]
            nibble = f"{output:01x}"
            if accum == "":
                if nibble != "0":
                    accum = nibble
                else:
                    text += "00 "
            else:
                accum = f"{nibble}{accum}"
                text += f"{accum} "
                accum = ""

        def dump_zeroes():
            global num_zeroes
            while num_zeroes >= 5:
                emit(0, 5)
                num_zeroes -= 5
            if num_zeroes > 0:
                emit(0, num_zeroes)
            num_zeroes = 0

        def dump_ffs():
            global num_ffs
            while num_ffs >= 3:
                num_ffs -= 3
                emit(255, 3)
            if num_ffs == 2:
                emit(255, 1)
                emit(255, 1)
            elif num_ffs == 1:
                emit(255, 1)
            num_ffs = 0

        for by in data:
            if by != 0 and num_zeroes > 0:
                dump_zeroes()
            if by != 255 and num_ffs > 0:
                dump_ffs()
            if by == 0:
                num_zeroes += 1
            elif by == 255:
                num_ffs += 1
            else:
                emit(by, 1)

        if num_zeroes > 0:
            dump_zeroes()
        if num_ffs > 0:
            dump_ffs()

        emit(0, 0)

        pile.append(idx[text])

    last = None

    print("; Consists of index into table 2 and # of repeats")
    print("font_tbl_1\tlabel\tbyte")
    acc = 0
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

    offsets = {}
    offset = 0
    for k, v in idx.items():
        offsets[v] = offset
        offset += len(k) // 3

    print("; Consists of offset into table 3")
    print("font_tbl_2\tlabel\tbyte")
    for k, v in offsets.items():
        print(f"\t\tdb\t{v}")

    print("; 9-byte rows")
    print("font_tbl_3\tlabel\tbyte")
    for k, v in idx.items():
        db = "0" + "h,0".join(k.strip().split(" ")) + "h"
        print(f"\t\tdb\t{db}")


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

main()
