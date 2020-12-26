.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.Unit__GetStrImpl
.area 0x52b01c - 0x52ac98
	stmdb	sp!,{r4-r12,lr}
	mov	r5,r0
	mov	r4,r1
	mov	r8,r2
	mov	r9,r3

	ldr	r11,[@@Lookup_buf]
	ldr	r6,[sp,#40]
	ldr	r0,[r11,#280]
	tst	r0,#1
	bne	@@Done_StrPlus2
	add	r0,r11,#280
	blx	_SYM_.__cxa_guard_acquire
	cmp	r0,#0
	beq	@@Done_StrPlus2
	adr	r0,@@SEID_StrPlus2
	bl	_SYM_.EquipSkill__Get
	ldrh	r0,[r0,#16]
	strh	r0,[r11,#4]
	add	r0,r11,#280
	mov	r0,r0

@@Done_StrPlus2:
	ldr	r0,[r11,#276]
	tst	r0,#1
	bne	@@Done_HeavyBlade
	ldr	r0,[@@Lock_HeavyBlade]
	blx	_SYM_.__cxa_guard_acquire
	cmp	r0,#0
	msr	cpsr_,#0
	beq	@@Done_HeavyBlade
	adr	r0,@@SEID_HeavyBlade
	bl	_SYM_.EquipSkill__Get
	ldrh	r0,[r0,#16]
	strh	r0,[r11,#6]
	ldr	r0,[@@Lock_HeavyBlade]
	mov	r0,r0

@@Done_HeavyBlade:
	ldr	r0,[r11,#272]
	tst	r0,#1
	bne	@@Done_Strtaker
	ldr	r0,[@@Lock_Strtaker]
	blx	_SYM_.__cxa_guard_acquire
	cmp	r0,#0
	msr	cpsr_,#0
	beq	@@Done_Strtaker
	adr	r0,@@SEID_Strtaker
	bl	_SYM_.EquipSkill__Get
	ldrh	r0,[r0,#16]
	strh	r0,[r11,#8]
	ldr	r0,[@@Lock_Strtaker]
	mov	r0,r0

@@Done_Strtaker:
	ldr	r0,[r11,#268]
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
	strh	r0,[r11,#10]
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
	ldr	r0,[r5,#156]
	mov	r1,#1
	ldrsb	r4,[r0,#57]
	mov	r0,r5
	bl	_SYM_.Unit__GetLimit
	mov	r10,r0

	ldr	r0,[r5,#176]
	cmp	r0,#0
	beq	@@with_static_unit

	mov	r1,#1
	bl	_SYM_.unit__Edit__GetCapability
	add	r4,r4,r0

@@with_static_unit:
	ldr	r0,[r5,#160]
	ldr	r2,[r5,#8]
	ldrsb	r1,[r5,#201]
	ldrsb	r0,[r0,#29]
	tst	r2,#0x40000000
	add	r0,r0,r4
	add	r4,r1,r0
	ldrnesb	r0,[r5,#225]
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
	tst	r0,#0x40
	addne	r0,r4,r4,lsr #31
	subne	r4,r4,r0,asr #1

@@Done_Half:
	tst	r2,#0x200000
	ldrd	r2,[r5,#8]
	mov	r0,#2
	movne	r0,#4
	mov	r1,#0
	and	r2,r2,r0
	and	r0,r3,r1
	orrs	r0,r0,r2
	ldrne	r0,[r5,#168]
	cmpne	r0,#0
	beq	@@Done_Double

	mov	r2,r5
	mov	r1,#1
	bl	_SYM_.Unit__GetDoubleCapability
	add	r4,r4,r0

@@Done_Double:
	ldrsh	r1,[r11,#4]
	mov	r0,r5
	bl	_SYM_.Unit__IsEquipSkill
	cmp	r0,#0
	ldrsh	r1,[r11,#6]
	addne	r4,r4,#2
	mov	r0,r5
	bl	_SYM_.Unit__IsEquipSkill
	cmp	r0,#0
	ldrsh	r1,[r11,#8]
	addne	r4,r4,#3
	mov	r0,r5
	bl	_SYM_.Unit__IsEquipSkill
	cmp	r0,#0
	ldrnesb	r0,[r5,#48]
	addne	r4,r4,r0

	cmp	r6,#23
	add	r0,r5,#40
	beq	@@do_Add4
	ldrb	r0,[r0,#2]
	tst	r0,#0x80
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
	cmp	r6,#32
	add	r0,r5,#40
	beq	@@do_add1
	ldrb	r0,[r0,#4]
	tst	r0,#1
	beq	@@Done_Add1
@@do_Add1:
	add	r4,r4,#1

@@Done_Add1:
	cmp	r6,#9
	add	r0,r5,#40
	beq	@@do_Drug
	ldrb	r0,[r0,#1]
	tst	r0,#2
	beq	@@Done_Drug
@@do_Drug:
	ldrsh	r1,[r11,#10]
	add	r4,r4,#2
	mov	r0,r5
	bl	_SYM_.Unit__IsEquipSkill
	cmp	r0,#0
	addne	r4,r4,#1

@@Done_Drug:
	cmp	r6,#16
	add	r0,r5,#40
	beq	@@do_Condition
	ldrb	r0,[r0,#2]
	tst	r0,#1
	beq	@@Done_Condition
@@do_Condition:
	add	r4,r4,#4

@@Done_Condition:
	ldrb	r0,[r5,#44]
	mov	r1,#1
	tst	r0,#16
	addne	r4,r4,#2
	tst	r0,#32
	subne	r4,r4,#1
	cmp	r7,#0
	ldrnesb	r0,[r7,#57]
	addne	r4,r4,r0
	mov	r0,r5
	bl	_SYM_.anonymous_namespace__GetEnhanceHave
	cmp	r9,#0
	add	r4,r4,r0
	ldrnesb	r0,[r5,#56]
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
@@SEID_StrPlus2:
	.sjis "SEID_力+2"
	.align 4
@@Lock_HeavyBlade:
	.skip 4
@@SEID_HeavyBlade:
	.sjis "SEID_剛剣"
	.align 4
@@Lock_Strtaker:
	.skip 4
@@SEID_Strtaker:
	.sjis "SEID_力の吸収"
	.align 4
@@Lock_GoodDrugs:
	.skip 4
@@SEID_GoodDrugs:
	.sjis "SEID_よく効く薬"
	.align 4
.endarea
.close
