.3ds
.open "code.bin","out.bin",0x100000
.include "autosym.s"

.org _SYM_.Unit__LevelUp
.area 0x3d91c0-0x3d9054
; param r0 :: Unit *this
;; Stack: 2 sub args, 5 local state, 9 callee saves, 8 padding words
;; +60/-00 = old sp
;; +3c~5f stored r4-r11,lr
;; +28~3b padding?
;; +18~27 RNG state
;; +14~17 empty level attempt count
;; +08~13 padding??
;; +04~07 sub arg 6 (=0)
;; +00~03 sub arg 5 (=0)
;; +00/-60 = new sp

	stmdb	sp!,{r4-r11,lr}
	sub	sp,sp,#0x3c
	mov	r7,r0

	;; Initialize level-up RNG using seed stored with the Unit, then write
	;; back the seed to be used for the next level-up.

	; (void)Random::Initialize(sp+0x18, *(int *)(this + 0xc0))
	; sp+0x18~27 (4 words) contains RNG state
	ldr	r1,[r0,#0xc0]
	add	r0,sp,#0x18
	bl	_SYM_.Random__Initialize

	add	r0,sp,#0x18
	bl	_SYM_.Random__GetValue_void_
	ldrb	r1,[r7,#0xf1]
	str	r0,[r7,#0xc0]
	mov	r9,#0x0
	add	r0,r1,#0x1
	strb	r0,[r7,#0xf1]
	mov	r11,r9
	str	r9,[sp,#0x14]

@@retry_empty:
	mov	r6,#0x0
@@each_stat:
	mov	r1,r6
	mov	r0,r7
	bl	_SYM_.Unit__GetGrow
	subs	r4,r0,#0x0
	msr	cpsr_,#0
	ble	@@next_stat
	add	r10,r7,r6
	cmp	r4,#0x64
	ldrsb	r5,[r10,#0xc8]
	mov	r8,#0x0
	blt	@@chance_increase
@@must_increase:
	mov	r3,#0x0
	sub	r4,r4,#0x64
	mov	r2,r3
	mov	r1,r6
	mov	r0,r7
	str	r11,[sp,#0x0]
	str	r11,[sp,#0x4]
	bl	_SYM_.Unit__GetCapabilityImpl
	mov	r9,r0
	mov	r1,r6
	mov	r0,r7
	bl	_SYM_.Unit__GetLimit
	cmp	r9,r0
	addlt	r5,r5,#0x1
	add	r0,r7,#0xc8
	addlt	r8,r8,#0x1
	cmp	r4,#0x64
	mov	r9,#0x1
	strb	r5,[r0,r6]
	bge	@@must_increase
@@chance_increase:
	mov	r1,#0x64
	add	r0,sp,#0x18
	bl	_SYM_.Random__GetValue_int_
	cmp	r0,r4
	msr	cpsr_,#0
	bge	@@store_stat
	mov	r3,#0x0
	mov	r2,r3
	mov	r1,r6
	mov	r0,r7
	str	r11,[sp,#0x0]
	str	r11,[sp,#0x4]
	bl	_SYM_.Unit__GetCapabilityImpl
	mov	r4,r0
	mov	r1,r6
	mov	r0,r7
	bl	_SYM_.Unit__GetLimit
	cmp	r4,r0
	addlt	r5,r5,#0x1
	addlt	r8,r8,#0x1
	mov	r9,#0x1
@@store_stat:
	add	r0,r7,#0xc8
	strb	r5,[r0,r6]
	ldr	r0,[r7,#0x9c]
	ldrb	r1,[r7,#0x130]
	ldrsb	r0,[r0,#0x86]
	cmp	r1,r0
	ble	@@next_stat
	ldrb	r0,[r10,#0xe0]
	add	r1,r7,#0xe0
	add	r0,r0,r8
	strb	r0,[r1,r6]
@@next_stat:
	add	r6,r6,#0x1
	cmp	r6,#0x8
	blt	@@each_stat
	cmp	r9,#0x0
	bne	@@return
	ldr	r0,[sp,#0x14]
	add	r0,r0,#0x1
	cmp	r0,#0x4
	str	r0,[sp,#0x14]
	blt	@@retry_empty
@@return:
	add	sp,sp,#0x3c
	ldmia	sp!,{r4-r11,pc}
.endarea
.close
