.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.GameBackup__GetFileName
.area 0x178ce4 - 0x178c50
	cmp	r0,#9
	ldrcc	pc,[pc,r0,lsl #2]
	b	@@case_default

.word	@@case_default
.word	@@case_1, @@case_2, @@case_3, @@case_4
.word	@@case_5, @@case_6, @@case_7, @@case_8

@@case_1:
	adr	r0,@data_Global
@@ret1:
	bx	lr

@@case_2:
	adr	r0,@data_Exchange
	bx	lr

@@case_3:
	cmp	r1,#9
	ldrlt	r0,[@table_Chapter]
	ldrlt	r0,[r0,r1,lsl #2]
	blt	@@ret1
	b	@@case_default

@@case_5:
	adr	r0,@ext_Temporary
	bx	lr

@@case_6:
	adr	r0,@ext_Fate
	bx	lr

@@case_4:
	cmp	r1,#2
	ldrlt	r0,[@table_Map]
	bge	@@case_default
@@ret2:
	ldr	r0,[r0,r1,lsl #2]
	bx	lr

@@case_7:
	cmp	r1,#5
	ldrlt	r0,[@table_Versus]
	blt	@@ret2

@@case_default:
	mov	r0,#0
	bx	lr

@@case_8:
	adr	r0,@data_Rating
	bx	lr
.endarea

.org _SYM_.GameBackup__GetFileName + 0x178ce4 - 0x178c50
@data_Global:
.dh 100,97,116,97,58,47,71,108,111,98,97,108,0,0
@data_Exchange:
.dh 100,97,116,97,58,47,69,120,99,104,97,110,103,101,0,0
@table_Chapter:
.skip 4
@ext_Temporary:
.dh 101,120,116,58,47,84,101,109,112,111,114,97,114,121,46,98,97,107,0,0
@ext_Fate:
.dh 101,120,116,58,47,70,97,116,101,46,98,97,107,0
@table_Map:
.skip 4
@table_Versus:
.skip 4
@data_Rating:
.dh 100,97,116,97,58,47,82,97,116,105,110,103,0,0

.close
