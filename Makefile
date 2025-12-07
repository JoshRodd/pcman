all:	pcmannew.com pcmantny.com pcmanexe.exe

pcmancom.com:	pcmancom.asm
	nasm pcmancom.asm -o pcmancom.com -l pcmancom.lst

pcmantxt.bin:	pcmantxt.asm
	nasm pcmantxt.asm -o pcmantxt.bin -l pcmantxt.lst

pcmannew.com:	pcmancom.com pcmantxt.bin pcmandata.bin
	cat pcmancom.com pcmantxt.bin pcmandata.bin > pcmannew.com
	cmp pcmannew.com images/pcman.com

pcmantny.com:	pcmancom.com pcmantny.bin pcmandata.bin
	cat pcmancom.com pcmantny.bin pcmandata.bin > pcmantny.com
	cmp pcmantny.com images/pcman.com

pcmanexe.exe:	pcmanexe.asm
	uasm -mz pcmanexe.asm
