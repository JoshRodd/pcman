#!/usr/bin/env zsh

rm -f pcman.bin pcman.lst pcman.def pcman.sym pcman.err #bits.txt
#paste <(xxd -c1 pcman.img) <(xxd -c1 -b pcman.img) | sed -E s'/^0000([0-9a-f]{4}): ([0-9a-f]{2})  .\t[0-9a-f]{8}: ([01]{8})  (.)$$/l\1\t\tdb\t0\2h\t; \3b \4 \1 \2/' > bits.txt
uasm -Flpcman.lst -Fdpcman.def -bin -Fopcman.bin -Fspcman.sym pcman.asm -Zg 2>&1 || exit
/opt/martypc/martypc --config_file /opt/martypc/pcman.toml --mount fd:0:/Users/shelli/src/pcmandis/pcman.bin
exit 0
size1=$(xz -d < pcman.img.xz | wc -c | tr -dc '0-9\n') || exit
size2=$(wc -c < pcman.bin | tr -dc '0-9\n') || exit
if [[ $size2 -gt $size1 ]]; then
	echo Image is too big: $size2 \> $size1
fi
size=$size1
output=$(cmp pcman.bin <(xz -d < pcman.img.xz | dd bs=1 count=$size status=none))
rc=$?
if [[ $rc -ne 0 ]]; then
	index=$(printf "%s\n" "$output" | sed -E s'/^.*char ([0-9]+),.*$/\1/')
	index=$[$index - 1]
	printf "Error at: 0%x\n" "$index"
	diff --color=always -y -W $COLUMNS --suppress-common-lines <(xz -d < pcman.img.xz | dd bs=1 count=$size status=none | xxd) <(xxd pcman.bin) | sed -E s'/ \|\t/\n/'
else
	printf "Build is identical\n"
fi
