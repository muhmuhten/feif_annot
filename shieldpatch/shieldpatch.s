.3ds
.open "code.bin","out.bin",0x100000
.include "autosym.s"

.org _SYM_.unit__util__NormalizeForCastleJoinGuest
	stmdb	sp!,{r3-r5,lr}
	mov	r4,r0

	bl	_SYM_.Unit__DeleteEquipSkillUnknownAndEnemyOnlyWithPool

	adr	r0,@@s_BID_MyUnitArmy
	bl	_SYM_.Belong__Get
	ldr	r0,[r0,#0]
	strb	r0,[r4,#0x131]

	ldr	r1,[r4,#8]
	mov	r0,r4
	orr	r1,r1,#0x10000000
	eor	r1,r1,#0x10000000
	str	r1,[r4,#8]
	bl	_SYM_.Unit__UpdateLimitOffset

	ldr	r0,[r4,#0x9c]
	cmp	r0,#0
	ldrneh	r0,[r0,#0x90]
	cmpne	r0,#0
	beq	@@ret

	bl	_SYM_.Item__TryGet
	movs	r5,r0
	beq	@@ret
	
	adr	r0,@@s_ISID_CannotRemove
	bl	_SYM_.ItemSkill__Get
	mov	r2,r0
	mov	r0,#1
	ldr	r2,[r2,#0]
	mov	r1,#0
	; XXX jump to unlabelled helper function
	bl	.+8 + 4*(readu32("code.bin", orga()) | ~0xffffff)
	ldrd	r2,[r5,#0]
	and	r0,r0,r2
	and	r1,r1,r3
	orrs	r0,r0,r1
	ldrneh	r2,[r5,#20]
	movne	r0,#0
	beq	@@ret

@@loop:
	add	r1,r4,r0,lsl #2
	add	r1,r1,#0x108
	ldrh	r1,[r1,#0]
	cmp	r1,r2
	beq	@@ret

	add	r0,r0,#1
	cmp	r0,#5
	blt	@@loop

	mov	r0,sp
	mov	r1,r5
	bl	_SYM_.unit__Item__New
	mov	r1,sp
	mov	r0,r4
	bl	_SYM_.Unit__ItemAdd
	mvn	r1,#0
	mov	r0,r4
	bl	_SYM_.Unit__ItemEquip

@@ret:
	ldmia	sp!,{r3-r5,pc}

@@s_BID_MyUnitArmy:
	.sjis "BID_マイユニット軍"
	.align 4

@@s_ISID_CannotRemove:
	.sjis "ISID_外せない"
	.align 4
.close
