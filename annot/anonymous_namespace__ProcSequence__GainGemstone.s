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

	cmp	r5,#1
	mov	r1,#1
	mov	r6,#2
	beq	@@coinflip1
	cmp	r5,#2
	mov	r2,#3
	beq	@@coinflip2
	cmp	r5,#3
	bne	@@keep1
	b	@@randcut45

@@coinflip1:
	cmp	r0,#50
	bge	@@give_resource
@@keep1:
	mov	r6,r1
@@give_resource:
	msr	cpsr_,#0
	bl	_SYM_.Castle__Get
	msr	cpsr_,#0
	msr	cpsr_,#0
	ldr	r0,[r0,#8]
	ldr	r0,[r0,#0]
	ldrb	r1,[r4,#48]
	mov	r2,r6
	bl	_SYM_.castle__CastleUserData__AddGemstoneNum
	mov	r0,#0
	msr	cpsr_,#0
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
	add	sp,sp,#16
	ldmia	sp!,{r4-r6,pc}
@@coinflip2:
	cmp	r0,#50
	blt	@@give_resource
	b	@@keep2
@@randcut45:
	cmp	r0,#45
	bge	@@rand4or5
@@keep2:
	mov	r6,r2
	b	@@give_resource
@@rand4or5:
	cmp	r0,#90
	movlt	r6,#4
	movge	r6,#5
	b	@@give_resource
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

	cmp	r5,#1
	mov	r1,#1
	mov	r6,#2
	beq	@@coinflip1
	cmp	r5,#2
	mov	r2,#3
	beq	@@coinflip2
	cmp	r5,#3
	bne	@@keep1
	b	@@randcut45

@@coinflip1:
	cmp	r0,#50
	bge	@@give_resource
@@keep1:
	mov	r6,r1
@@give_resource:
	msr	cpsr_,#0
	bl	_SYM_.Castle__Get
	msr	cpsr_,#0
	msr	cpsr_,#0
	ldr	r0,[r0,#8]
	ldr	r0,[r0,#0]
	ldrb	r1,[r4,#48]
	mov	r2,r6
	bl	_SYM_.castle__CastleUserData__AddFoodNum
	mov	r0,#0
	msr	cpsr_,#0
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
	add	sp,sp,#16
	ldmia	sp!,{r4-r6,pc}
@@coinflip2:
	cmp	r0,#50
	blt	@@give_resource
	b	@@keep2
@@randcut45:
	cmp	r0,#45
	bge	@@rand4or5
@@keep2:
	mov	r6,r2
	b	@@give_resource
@@rand4or5:
	cmp	r0,#90
	movlt	r6,#4
	movge	r6,#5
	b	@@give_resource
@@message:
	.sjis	"MID_MSG_材料入手"

.close
