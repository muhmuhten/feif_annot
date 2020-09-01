.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.castle__BuildingRefineShop__Visit
	stmdb	sp!,{r4-r8,lr}
	sub	sp,sp,#8
	mov	r4,r0
	mov	r8,r1
	mov	r5,r2

	bl	_SYM_.Castle__Get
	bl	_SYM_.Castle__GetData
	ldr	r0,[r0,#0]
	mov	r6,#1
	ldrb	r0,[r0,#800]
	cmp	r0,#0
	beq	@@endif
	cmp	r0,#1
	moveq	r6,#2
	beq	@@endif
	cmp	r0,#2
	moveq	r6,#3

@@endif:
	ldr	r0,[r4,#24]
	bl	_SYM_.castle__CastleBuilding__GetDataByUniqueIndex
	ldrb	r7,[r0,#2]
	mov	r1,#0
	mov	r0,r4
	bl	_SYM_.castle__BuildingDispos__Data__GetClerk
	mov	r2,r0
	mov	r3,r7
	mov	r1,r6
	mov	r0,r8
	strd	r4,[sp,#0]
	bl	_SYM_.RefineSequence__Create
	add	sp,sp,#8
	ldmia	sp!,{r4-r8,pc}
.close
