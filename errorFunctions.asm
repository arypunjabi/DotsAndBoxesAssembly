.data
	displayAddress:	.word	0x10008000
	instructions: .asciiz "Welcome to Dots and Boxes! In order to draw your line, simply print the row_column of the start and row_column of the end point. For example, the input '11 21'\n"
	openSpace: .asciiz " "
	errorMessage1: .asciiz "Sorry, but the points you entered aren't valid. Try again.\n"
	repeatErrorMessage: .asciiz "Sorry, but the value you entered has already been entered. Try again \n"
	playerDrawBox: .asciiz "Player 1 drew a box! New Score: "
	compDrawBox: .asciiz "Player 2 drew a box! New Score is "
	newLine: .asciiz "\n"
	space: .asciiz " "
	printScorePlayer: "Player1: "
	printScoreComp: "Player2: "
	gameOverMessagePlayer: "Game Over! Winner is Player 1"
	gameOverMessageComp: "Game Over! Winner is Player 2"
	

.text

.globl ErrorMessageMain
.globl RepeatError
.globl IsRepeat
.globl IsValidBounds
.globl IsValidDistance

ErrorMessageMain:
	la $a0, errorMessage1
	li $v0, 4
	syscall
	
	beq $s4, 0, Comp1
	j TakeInValueP1
	Comp1:
		j TakeInValueP2
		
RepeatError:
	li $v0, 4
	la $a0, repeatErrorMessage
	syscall
	beq $s4, 0, Comp
	j TakeInValueP1
	Comp:
		j TakeInValueP2
	

IsRepeat:
	beq $a0, $a2, ItIsHoriz
	ItIsVert:
		lw $t7, 256($t0)
		beq $t7, 0x00ff00, Yes
		j IsNot
	ItIsHoriz:
		lw $t7, 4($t0)
		beq $t7, 0x00ff00, Yes
	IsNot:
		jr $ra
	Yes:
		j RepeatError
		
IsValidBounds:

	
	
	blt $a0, 1, Lacking
	blt $a1, 1, Lacking
	blt $a2, 1, Lacking
	blt $a3, 1, Lacking
	bgt $a0, 6, Lacking
	bgt $a2, 6, Lacking
	bgt $a1, 8, Lacking
	bgt $a3, 8, Lacking
	beq $a0, $a2, SameRow
	beq $a1, $a3, SameCol
	
	jr $ra
	
	SameRow:
		beq $a1, $a3, Lacking
		jr $ra
	SameCol:
		beq $a0, $a2, Lacking
		jr $ra
	
	Lacking:
		beq $s4, 0, Comp2
		j ErrorMessageMain
		Comp2:
			j TakeInValueP2
		
		
IsValidDistance:

	li $s0, 1
	li $s1, -1
	li $s3, 0	#validity
	sub $s2, $a0, $a2
	beq $s2, $s0, ValidRow
	beq $s2, $s1, ValidRow
	beq $s2, $zero, ValidRow
	move $v0, $s3
	jr $ra
	
	ValidRow:
	sub $s4, $a1, $a3
	beq $s4, $s0, ValidCol
	beq $s4, $s1, ValidCol
	beq $s4, $zero, ValidCol
	move $v0, $s3
	jr $ra
	
	ValidCol:
	beq $s2, $zero, Valid
	beq $s4, $zero, Valid
	move $v0, $s3
	jr $ra
	
	Valid:
	addi $s3, $s3, 1
	move $v0, $s3
	jr $ra
