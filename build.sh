#!/usr/bin/env zsh

rm -f pcman.bin pcman.lst pcman.def pcman.sym pcman.err #bits.txt
#paste <(xxd -c1 pcman.img) <(xxd -c1 -b pcman.img) | sed -E s'/^0000([0-9a-f]{4}): ([0-9a-f]{2})  .\t[0-9a-f]{8}: ([01]{8})  (.)$$/l\1\t\tdb\t0\2h\t; \3b \4 \1 \2/' > bits.txt
uasm -Flpcman.lst -Fdpcman.def -bin -Fopcman.bin -Fspcman.sym pcman.asm 2>&1 || exit
size1=$(xz -d < pcman.img.xz | wc -c | tr -dc '0-9\n') || exit
size2=$(wc -c < pcman.bin | tr -dc '0-9\n') || exit
if [[ $size2 -gt $size1 ]]; then
	echo Image is too big: $size2 \> $size2
	exit 1
fi
size=$size1
cmp pcman.bin <(dd if=pcman.img bs=$size count=1 status=none)
rc=$?
if [[ $rc -ne 0 ]]; then
	diff --color=always -y --suppress-common-lines <(xz -d < pcman.img.xz | dd bs=1 count=$size status=none | xxd) <(xxd pcman.bin)
fi
