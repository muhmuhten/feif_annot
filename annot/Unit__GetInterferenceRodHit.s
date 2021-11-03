.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.Unit__GetInterferenceRodHit
	stmdb	sp!,{r4-r7,lr}
	mov	r4,r0
	movs	r0,r1
	sub	sp,sp,#12
	beq	@@done
	bl	_SYM_.unit__Item__GetHit
	mov	r1,r0
	ldr	r0,[r4,#0xa0]
	mov	r6,#0
	mov	r3,#1
	mov	r2,r3
	ldrsh	r0,[r0,#0x4c]
	str	r6,[sp,#0]
	add	r5,r0,r1
	mov	r1,r6
	mov	r0,r4
	bl	_SYM_.Unit__GetPowImpl
	mov	r7,r0
	mov	r3,#1
	mov	r2,r3
	mov	r1,#0
	mov	r0,r4
	str	r6,[sp,#0]
	bl	_SYM_.Unit__GetTechImpl
	add	r0,r0,r7
	add	r7,r0,r5
	mov	r0,#6
	bl	_SYM_.WeaponBonus__Get
	ldrb	r2,[r4,#0xee]
	mov	r6,r0
	mov	r0,r4
	mov	r1,#6
	mov	r5,sp
	str	r2,[sp,#0]
	bl	_SYM_.Unit__GetWeaponExpLimit
	ldr	r2,[sp,#0]
	add	r1,sp,#4
	str	r0,[sp,#4]
	cmp	r2,r0
	movgt	r5,r1
	ldr	r4,[r5,#0]
	bl	_SYM_.WeaponLevel__Get
	mov	r1,r4
	bl	_SYM_.WeaponLevel__GetLevel
	add	r0,r6,r0,lsl #1
	ldrsb	r0,[r0,#1]
	add	r0,r0,r7
	cmp	r0,#0
	movlt	r0,#0
@@done:
	add	sp,sp,#12
	ldmia	sp!,{r4-r7,pc}

.org _SYM_.Unit__GetInterferenceRodAvoid
	stmdb	sp!,{r3-r7,lr}
	mov	r3,#1
	mov	r6,#0
	mov	r4,r0
	mov	r5,r1
	mov	r2,r3
	str	r6,[sp,#0]
	bl	_SYM_.Unit__GetMdefImpl
	add	r7,r0,r0,lsl #1
	mov	r3,#1
	mov	r2,r3
	mov	r1,r5
	mov	r0,r4
	str	r6,[sp,#0]
	bl	_SYM_.Unit__GetLuckImpl
	add	r0,r0,r7
	mov	r0,r0,asr #1
	cmp	r0,#0
	movlt	r0,#0
	ldmia	sp!,{r3-r7,pc}
.close
