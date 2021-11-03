.3ds
.open "code.bin","out.bin",0x100000
.include "autosym.s"

.org _SYM_.Unit__ItemUse + 720
	add	r1,r0,r1

.org _SYM_.Unit__LevelUp
.area 0x3d91c0 - 0x3d9054
.area _SYM_.Unit__DoubleOn - .
;; Local callee-saved variables:
;; r4 = current gains in stat
;; r5 = maximum gains to reach stat cap
;; r6 = which stat
;; r7 = this :: Unit
;; r8 = this + 0xc8 :: start of personal stats array (+ access to high offsets)
;; r9 = this + 0xe0 :: PvP handicaps(!)
Unit__LevelUp:
	stmdb	sp!,{r4-r11,lr}
	mov	r7,r0
	add	r8,r0,#0xc8
	add	r9,r0,#0xe0
	
	; since all entries leave the level in r1 anyway, we can skip the load
	;ldrb	r1,[r7,#0xf1]
	ldr	r2,[r7,#0x9c]	; Unit+0x9c Person pointer
	add	r1,r1,#1
	mov	r6,#7
	strb	r1,[r7,#0xf1]

@@stat_loop:
	ldrb	r4,[r8,r6]	; current gains

	mov	r3,#0
	mov	r2,#0
	mov	r1,r6
	mov	r0,r7
	bl	_SYM_.Unit__GetCapabilityImpl
	sub	r5,r0,r4	; stat - gains ~= base

	mov	r1,r6
	mov	r0,r7
	bl	_SYM_.Unit__GetLimit
	sub	r5,r0,r5	; limit - base = cur gains + (limit - stat) = max gains

	mov	r1,r6
	mov	r0,r7
	bl	_SYM_.Unit__GetGrow

	ldrsb	r3,[r9,r6]
	add	r3,r3,r0
	cmp	r3,#50
	addge	r4,r4,#1
	subge	r3,r3,#100
	bgt	.-12
	cmp	r4,r5
	movgt	r4,r5
	strb	r3,[r9,r6]
	strb	r4,[r8,r6]

@@stat_next:
	subs	r6,r6,#1
	bge	@@stat_loop

	ldmia	sp!,{r4-r11,pc}
.skip 148
.endarea
.endarea
.close
