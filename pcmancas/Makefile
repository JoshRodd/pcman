all:	pcmannew.com pcmanexe.exe pcmannul.com

clean:
	rm -f pcmancom.com pcmantxt.bin pcmannul.bin pcmannew.com
	rm -f pcmannul.com pcmanexe.exe pcmancom.lst pcmantxt.lst
	rm -f pcmannul.lst pcmanexe.lst

pcmancom.com:	pcmancom.asm
	nasm pcmancom.asm -o pcmancom.com -l pcmancom.lst

pcmantxt.bin:	pcmantxt.asm
	nasm pcmantxt.asm -o pcmantxt.bin -l pcmantxt.lst

pcmannul.bin:	pcmannul.asm
	nasm pcmannul.asm -o pcmannul.bin -l pcmannul.lst

pcmannew.com:	pcmancom.com pcmantxt.bin pcmandata.bin
	cat pcmancom.com pcmantxt.bin pcmandata.bin > pcmannew.com
	cmp pcmannew.com images/pcman.com

pcmannul.com:	pcmancom.com pcmannul.bin pcmandata.bin
	cat pcmancom.com pcmannul.bin pcmandata.bin > pcmannul.com
#	cmp pcmannul.com images/pcman.com

pcmanexe.exe:	pcmanexe.asm
	uasm -mz pcmanexe.asm
