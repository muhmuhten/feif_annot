.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

;; param r0 : some proc state
;; r4 = initial r0
;; r5 = saved building level?
;; r6 = resource count
.org _SYM_.anonymous_namespace__ProcSequence__GainGemstone
	stmdb	sp!,{r4-r6,lr}
	sub	sp,sp,#16
	ldr	r1,[r0,#52]
	mov	r4,r0
	mov	r0,sp
	bl	_SYM_.Random__Initialize
	ldrb	r5,[r4,#49]
	mov	r0,sp
	mov	r1,#100
	bl	_SYM_.Random__GetValue

	cmp	r5,#3
	movcs	r5,#0
	moveq	r2,#45
	movne	r2,#50

@@loop_count:
	subs	r0,r0,r2
	addge	r5,r5,#1
	bgt	@@loop_count

	movs	r6,r5
	moveq	r6,#1

	bl	_SYM_.Castle__Get
	ldr	r0,[r0,#8]
	ldr	r0,[r0,#0]
	ldrb	r1,[r4,#48]
	mov	r2,r6
	stmdb	sp!,{r0-r2}

	mov	r5,#11
@@loop_each:
	cmp	r1,r5
	movne	r2,#1
	mov	r1,r5
	bl	_SYM_.castle__CastleUserData__AddGemstoneNum
	subs	r5,r5,#1
	ldmgeia	sp,{r0-r2}
	bge	@@loop_each

	mov	r0,#0
	bl	_SYM_.Mess__GetArgumentBuffer
	ldrb	r1,[r4,#48]
	msr	cpsr_,#0
	bl	_SYM_.GameFont__AddGemstone
	mov	r1,r6
	mov	r0,#1
	bl	_SYM_.Mess__SetArgument_int_int_
	adr	r0,@@message
	msr	cpsr_,#0
	bl	_SYM_.Mess__Get
	mov	r1,r0
	mov	r0,r4
	bl	_SYM_.GameMessage__CreateBind
	ldr	r1,[r0,#80]
	orr	r1,r1,#2
	str	r1,[r0,#80]
	mov	r0,#1
	bl	_SYM_.castle__CastleSound__PlayJingle
	add	sp,sp,#28
	ldmia	sp!,{r4-r6,pc}

	.skip 44
@@message:
	.sjis	"MID_MSG_材料入手"

.org _SYM_.anonymous_namespace__ProcSequence__GainFood
	stmdb	sp!,{r4-r6,lr}
	sub	sp,sp,#16
	ldr	r1,[r0,#52]
	mov	r4,r0
	mov	r0,sp
	bl	_SYM_.Random__Initialize
	ldrb	r5,[r4,#49]
	mov	r0,sp
	mov	r1,#100
	bl	_SYM_.Random__GetValue

	cmp	r5,#3
	movcs	r5,#0
	moveq	r2,#45
	movne	r2,#50

@@loop_count:
	subs	r0,r0,r2
	addge	r5,r5,#1
	bgt	@@loop_count

	movs	r6,r5
	moveq	r6,#1

	bl	_SYM_.Castle__Get
	ldr	r0,[r0,#8]
	ldr	r0,[r0,#0]
	ldrb	r1,[r4,#48]
	mov	r2,r6
	stmdb	sp!,{r0-r2}

	mov	r5,#11
@@loop_each:
	cmp	r1,r5
	movne	r2,#1
	mov	r1,r5
	bl	_SYM_.castle__CastleUserData__AddFoodNum
	subs	r5,r5,#1
	ldmgeia	sp,{r0-r2}
	bge	@@loop_each

	mov	r0,#0
	bl	_SYM_.Mess__GetArgumentBuffer
	ldrb	r1,[r4,#48]
	msr	cpsr_,#0
	bl	_SYM_.GameFont__AddFood
	mov	r1,r6
	mov	r0,#1
	bl	_SYM_.Mess__SetArgument_int_int_
	adr	r0,@@message
	msr	cpsr_,#0
	bl	_SYM_.Mess__Get
	mov	r1,r0
	mov	r0,r4
	bl	_SYM_.GameMessage__CreateBind
	ldr	r1,[r0,#80]
	orr	r1,r1,#2
	str	r1,[r0,#80]
	mov	r0,#1
	bl	_SYM_.castle__CastleSound__PlayJingle
	add	sp,sp,#28
	ldmia	sp!,{r4-r6,pc}

	.skip 44
@@message:
	.sjis	"MID_MSG_材料入手"

.close
