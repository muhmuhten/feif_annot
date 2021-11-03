.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.map__anonymous_namespace__Transporter__BuildAttribute + 0x37b400 - 0x37b390
	ldr	r0,[_SYM_.map__anonymous_namespace__Transporter__BuildAttribute + 0x37b738 - 0x37b390]
.org _SYM_.map__anonymous_namespace__Transporter__BuildAttribute + 0x37b738 - 0x37b390
	.word	readu32("code.bin", _SYM_.Unit__HasDanceSkill + 0x52eca0 - 0x52ebe4 - 0x100000)

.close
