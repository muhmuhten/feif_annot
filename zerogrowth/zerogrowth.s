.3ds
.open "code.bin","out.bin",0x100000
.include "autosym.s"

.org _SYM_.Unit__LevelUp + 208
	b .+64
.close
