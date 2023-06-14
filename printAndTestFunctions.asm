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

.globl PrintMessage
.globl PrintInt
.globl BoxDrawnMessage
.globl PrintScore

PrintMessage:
	li $v0, 4
	syscall
	jr $ra
	
PrintInt:
	li $v0, 1
	syscall
	jr $ra

BoxDrawnMessage:
	move $s1, $ra
	beq $s4, 1, IsPlayer
	la $a0, compDrawBox
	jal PrintMessage
	jal PrintScore
	la $a0, newLine
	jal PrintMessage
	
	move $ra, $s1
	jr $ra
	
	IsPlayer:
		la $a0, playerDrawBox
		jal PrintMessage
		jal PrintScore
		la $a0, newLine
		jal PrintMessage
		
	move $ra, $s1
	jr $ra

PrintScore:
	la $a0, printScorePlayer
	li $v0, 4
	syscall
	
	move $a0, $s5
	li $v0, 1
	syscall
	
	la $a0, space
	li $v0, 4
	syscall
	
	la $a0, printScoreComp
	li $v0, 4
	syscall
	
	move $a0, $s6
	li $v0, 1
	syscall
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	jr $ra
