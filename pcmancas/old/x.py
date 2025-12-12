#!/usr/bin/env python3
import sys

# ANSI colors
MAGENTA = "\033[95m"  # Bright magenta
RED = "\033[91m"  # Bright red
WHITE = "\033[97m"  # Bright white
BLACK = "\033[40m"  # Black background (or just no color)
RESET = "\033[0m"

BLOCK = "█"

# Color mapping: lower 2 bits of each byte → color
COLORS = {
    0: BLACK + " ",  # Black
    1: MAGENTA + BLOCK,  # Bright Magenta
    2: RED + BLOCK,  # Bright Red
    3: WHITE + BLOCK,  # Bright White
}


def view_cga_27px_file(filename, width):
    with open(filename, "rb") as f:
        data = f.read()

    bytes_per_line = width
    num_lines = len(data) // bytes_per_line

    print(f"File size: {len(data)} bytes")
    print(f"Lines detected: {num_lines} (at {width} bytes per line)\n")

    #    if num_lines > 100:
    #        num_lines = 100

    for line_num in range(num_lines):
        start = line_num * bytes_per_line
        line_bytes = data[start : start + bytes_per_line]

        # Should have exactly width bytes
        if len(line_bytes) < width:
            print("Incomplete line, stopping.")
            break

        # Print line number
        #        print(f"{line_num:4d}: ", end="")

        # Print hex bytes (width of them)
        hex_str = " ".join(f"{b:02X}" for b in line_bytes)
        #        print(hex_str)

        for byte in line_bytes:
            pixel = (byte >> 6) & 0b11  # Only lower 2 bits matter
            print(f"{COLORS[pixel]}{RESET}", end="")
            pixel = (byte >> 4) & 0b11  # Only lower 2 bits matter
            print(f"{COLORS[pixel]}{RESET}", end="")
            pixel = (byte >> 2) & 0b11  # Only lower 2 bits matter
            print(f"{COLORS[pixel]}{RESET}", end="")
            pixel = (byte >> 0) & 0b11  # Only lower 2 bits matter
            print(f"{COLORS[pixel]}{RESET}", end="")
        print(RESET)  # End of line + reset color


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python cga27_view.py <filename.bin> <width>")
        print("Expects: 27 pixels wide, 2 bits per pixel,")
        print(
            "         stored as 27 bytes per scanline (one byte per pixel, low 2 bits used)"
        )
        sys.exit(1)

    view_cga_27px_file(sys.argv[1], int(sys.argv[2]))
