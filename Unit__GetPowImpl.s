.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.Unit__GetPowImpl
.area 0x52ac98 - 0x52a98c
	stmdb	sp!,{r4-r12,lr}
	mov	r5,r0	; unit pointer
	mov	r4,r1
	mov	r8,r2
	mov	r9,r3

	ldr	r11,[@@Lookup_buf]
	ldr	r6,[sp,#40]
	ldr	r0,[r11,#292]
	tst	r0,#1
	bne	@@Done_MagPlus2
	add	r0,r11,#292
	blx	_SYM_.__cxa_guard_acquire
	cmp	r0,#0
	beq	@@Done_MagPlus2
	adr	r0,@@SEID_MagPlus2
	bl	_SYM_.EquipSkill__Get
	ldrh	r0,[r0,#16]
	strh	r0,[r11,#12]
	add	r0,r11,#292
	mov	r0,r0

@@Done_MagPlus2:
	ldr	r0,[r11,#288]
	tst	r0,#1
	bne	@@Done_Magtaker
	ldr	r0,[@@Lock_Magtaker]
	blx	_SYM_.__cxa_guard_acquire
	cmp	r0,#0
	msr	cpsr_,#0
	beq	@@Done_Magtaker
	adr	r0,@@SEID_Magtaker
	bl	_SYM_.EquipSkill__Get
	ldrh	r0,[r0,#16]
	strh	r0,[r11,#14]
	ldr	r0,[@@Lock_Magtaker]
	mov	r0,r0

@@Done_Magtaker:
	ldr	r0,[r11,#284]
	tst	r0,#1
	bne	@@Done_GoodDrugs
	ldr	r0,[@@Lock_GoodDrugs]
	blx	_SYM_.__cxa_guard_acquire
	cmp	r0,#0
	msr	cpsr_,#0
	beq	@@Done_GoodDrugs
	adr	r0,@@SEID_GoodDrugs
	bl	_SYM_.EquipSkill__Get
	ldrh	r0,[r0,#16]
	strh	r0,[r11,#16]
	ldr	r0,[@@Lock_GoodDrugs]
	mov	r0,r0

@@Done_GoodDrugs:
	cmp	r4,#0
	beq	@@with_equipped_item

@@with_item_is_arg2:
	mov	r0,r4
	bl	_SYM_.unit__Item__ToData
	mov	r7,r0
	msr	cpsr_,#0
	b	@@Done_Item

@@with_equipped_item:
	cmp	r8,#0
	beq	@@with_no_item

	mov	r0,r5
	bl	_SYM_.Unit__GetItemIndexEquipped
	cmp	r0,#0
	msr	cpsr_,#0
	blt	@@with_no_item

	add	r0,r5,r0,lsl #2
	adds	r4,r0,#264
	bne	@@with_item_is_arg2

@@with_no_item:
	mov	r7,#0

@@Done_Item:
	ldr	r0,[r5,#156]	; person pointer?
	mov	r1,#2
	ldrsb	r4,[r0,#58]	; personal base
	mov	r0,r5
	bl	_SYM_.Unit__GetLimit
	mov	r10,r0

	ldr	r0,[r5,#176]
	cmp	r0,#0
	beq	@@with_static_unit

	mov	r1,#2
	bl	_SYM_.unit__Edit__GetCapability
	add	r4,r4,r0

@@with_static_unit:
	ldr	r0,[r5,#160]	; class pointer?
	ldr	r2,[r5,#8]
	ldrsb	r1,[r5,#202]	; growth result
	ldrsb	r0,[r0,#30]	; class base
	tst	r2,#0x40000000
	add	r0,r0,r4
	add	r4,r1,r0
	ldrnesb	r0,[r5,#226]
	subne	r4,r4,r0
	cmp	r4,#0
	movlt	r4,#0
	blt	@@Done_Capability

	; clamp to cap
	cmp	r10,r4
	movlt	r4,r10

@@Done_Capability:
	cmp	r8,#0
	beq	@@Return_clamped

	cmp	r9,#0
	beq	@@Done_Half

	ldrb	r0,[r5,#40]
	tst	r0,#0x80
	addne	r0,r4,r4,lsr #31
	subne	r4,r4,r0,asr #1

@@Done_Half:
	tst	r2,#0x200000
	ldrd	r2,[r5,#8]
	mov	r0,#2
	mov	r1,#0
	movne	r0,#4
	and	r0,r0,r2
	and	r1,r1,r3
	orrs	r0,r0,r1
	ldrne	r0,[r5,#168]
	cmpne	r0,#0
	beq	@@Done_Double

	mov	r2,r5
	mov	r1,#2
	bl	_SYM_.Unit__GetDoubleCapability
	add	r4,r4,r0

@@Done_Double:
	ldrsh	r1,[r11,#12]
	mov	r0,r5
	bl	_SYM_.Unit__IsEquipSkill
	cmp	r0,#0
	ldrsh	r1,[r11,#14]
	addne	r4,r4,#2
	mov	r0,r5
	bl	_SYM_.Unit__IsEquipSkill
	cmp	r0,#0
	ldrnesb	r0,[r5,#49]
	addne	r4,r4,r0

	cmp	r6,#24
	add	r0,r5,#40
	beq	@@do_Add4
	ldrb	r0,[r0,#3]
	tst	r0,#1
	beq	@@Done_Add4
@@do_Add4:
	add	r4,r4,#4

@@Done_Add4:
	cmp	r6,#31
	add	r0,r5,#40
	beq	@@do_add2
	ldrb	r0,[r0,#3]
	tst	r0,#0x80
	beq	@@Done_Add2
@@do_Add2:
	add	r4,r4,#2

@@Done_Add2:
	cmp	r6,#10
	add	r0,r5,#40
	beq	@@do_Drug
	ldrb	r0,[r0,#1]
	tst	r0,#4
	beq	@@Done_Drug

@@do_Drug:
	ldrsh	r1,[r11,#16]
	add	r4,r4,#2
	mov	r0,r5
	bl	_SYM_.Unit__IsEquipSkill
	cmp	r0,#0
	addne	r4,r4,#1

@@Done_Drug:
	cmp	r6,#17
	add	r0,r5,#40
	beq	@@do_Condition
	ldrb	r0,[r0,#2]
	tst	r0,#2
	beq	@@Done_Condition
@@do_Condition:
	add	r4,r4,#4

@@Done_Condition:
	ldrb	r0,[r5,#44]
	mov	r1,#2
	tst	r0,#0x40
	addne	r4,r4,#2
	tst	r0,#0x80
	subne	r4,r4,#1
	cmp	r7,#0
	ldrnesb	r0,[r7,#58]
	addne	r4,r4,r0
	mov	r0,r5
	bl	_SYM_.anonymous_namespace__GetEnhanceHave
	cmp	r9,#0
	add	r4,r4,r0
	ldrnesb	r0,[r5,#57]
	subne	r4,r4,r0

@@Return_clamped:
	cmp	r4,#0
	movlt	r4,#0
	blt	@@ret
	cmp	r4,#99
	movgt	r4,#99
@@ret:
	mov	r0,r4
	ldmia	sp!,{r4-r12,pc}

@@Lookup_buf:
	.skip 4
@@SEID_MagPlus2:
	.sjis "SEID_魔力+2"
	.align 4
@@Lock_Magtaker:
	.skip 4
@@SEID_Magtaker:
	.sjis "SEID_魔力の吸収"
	.align 4
@@Lock_GoodDrugs:
	.skip 4
@@SEID_GoodDrugs:
	.sjis "SEID_よく効く薬"
	.align 4
.endarea
.close
