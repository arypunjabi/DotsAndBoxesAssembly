
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

.globl IsGameOver
.globl GameOver
.globl CheckBoxes
.globl Reorder
.globl SplitInteger

#check if the game is over
IsGameOver:						
	add $t1, $s5, $s6				#add individual scores
	beq $t1, 35, GameIsOver				#if scores are equal to 35, which is the max number of boxes which can be made, game is over
	jr $ra						#return if not
	GameIsOver:
		j GameOver				#end game

#end game
GameOver:
	
	bgt $s5, $s6, PlayerWin				#register s5 holds player score and s6 holds the computer score. If s5>s6, then player wins
	la $a0, gameOverMessageComp			#gameover message for computer winning
	li $v0, 4
	syscall
	
	la $a0, newLine					#new line
	li $v0, 4
	syscall
	
	jal PrintScore					#print the final scores
	j Exit
	
	PlayerWin:					#if the player wins
	
		la $a0, gameOverMessagePlayer		#game over message for player winning
		li $v0, 4
		syscall
		
		la $a0, newLine				#new line
		li $v0, 4
		syscall
	
		jal PrintScore				#print final scores
		j Exit					#end program

#checks to see if any boxes have been made by the newest line
CheckBoxes:
	li $t4, 0				#counts number of lines to the left/above the line being made depending on orientation
	li $t6, 0				#counts number of lines to the right/below the line being made depending on orientation
	li $t5, 0x5A5A5A			#color of background
	li $t8, 0x0000FF			#blue for testing
	beq $t9, 1, VertCheck			#t9 is 1 if the newly created line is vertical and 0 if horizontal
	
	HorizCheck:				#a newly horizontal line can only complete a box directly above and/or below it.
		lw $t7 -256($t0)		#check for a colored pixel in a line perpendicular to the left side of the newly drawn line
		bne $t7, $t5, Add1		#if there is a colored pixel, add one to t4
		j Else1				#if not, then skip to next checker. Maybe i can get rid of the else statements and make it leave this section because it cant have a box with a missing line
		Add1:
			#sw   $t8, -256($t0)
			addi $t4, $t4, 1	#add one to $t4
		Else1:	
		lw $t7 -1528($t0)		#check for a colored pixel in a line parallel and abovethe newly drawn line
		bne $t7, $t5, Add2
		j Else2
		Add2:
			#sw   $t8, -1528($t0)
			addi $t4, $t4, 1
		Else2:
		lw $t7 4($t0)			#add one for the newly drawn line itself
		bne $t7, $t5, Add3
		j Else3
		Add3:
			#sw   $t8, 4($t0)
			addi $t4, $t4, 1
		Else3:
		lw $t7 -224($t0)		#check for a colored pixel in a line perpendicular to the left side of the newly drawn line
		bne $t7, $t5, Add4
		j Else4
		Add4:
			#sw   $t8, -224($t0)
			addi $t4, $t4, 1
		
		#now were looking directly below the newly drawn line and adding to $t6
		Else4:
		lw $t7 4($t0)			#add one for the newly drawn line itself
		bne $t7, $t5, Add5
		j Else5
		Add5:
			#sw   $t8, 4($t0)
			addi $t6, $t6, 1
		Else5:
		lw $t7 256($t0)			#check for line perpendicular and to the left
		bne $t7, $t5, Add6
		j Else6
		Add6:
			#sw   $t8, 256($t0)
			addi $t6, $t6, 1
		Else6:
		lw $t7 1540($t0)		#check for parallel and below
		bne $t7, $t5, Add7
		j Else7
		Add7:
			#sw   $t8, 1540($t0)
			addi $t6, $t6, 1
		Else7:
		lw $t7 288($t0)			#check for perpendicular and to the right
		bne $t7, $t5, Add8
		j Else8
		Add8:
			#sw   $t8, 288($t0)
			addi $t6, $t6, 1
		Else8:
		move $v0, $t4 			#return vals
		move $v1, $t6 			
		jr $ra
		
	#if line is vertical, only the left and/or right boxes can be completed by line
	VertCheck:				#left box first
		lw $t7 -4($t0)			#check for the line perpendicular to the top side of the new line
		bne $t7, $t5, Add1V
		j Else1V
		Add1V:
			#sw   $t8, -4($t0)
			addi $t4, $t4, 1
		Else1V:
		lw $t7 224($t0)	
		bne $t7, $t5, Add2V
		j Else2V
		Add2V:
			#sw   $t8, 224($t0)
			addi $t4, $t4, 1
		Else2V:
		lw $t7 256($t0)
		bne $t7, $t5, Add3V
		j Else3V
		Add3V:
			#sw   $t8, 256($t0)
			addi $t4, $t4, 1
		Else3V:
		lw $t7 1532($t0)
		bne $t7, $t5, Add4V
		j Else4V
		Add4V:
			#sw   $t8, 1532($t0)
			addi $t4, $t4, 1
			
		Else4V:
		lw $t7 4($t0)
		bne $t7, $t5, Add5V
		j Else5V
		Add5V:
			#sw   $t8, 4($t0)
			addi $t6, $t6, 1
		Else5V:
		lw $t7 256($t0)
		bne $t7, $t5, Add6V
		j Else6V
		Add6V:
			#sw   $t8, 256($t0)
			addi $t6, $t6, 1
		Else6V:
		lw $t7 1540($t0)
		bne $t7, $t5, Add7V
		j Else7V
		Add7V:
			#sw   $t8, 1540($t0)
			addi $t6, $t6, 1
		Else7V:
		lw $t7 288($t0)
		bne $t7, $t5, Add8V
		j Else8V
		Add8V:
			#sw   $t8, 288($t0)
			addi $t6, $t6, 1
		Else8V:
		move $v0, $t4 #box left is v0
		move $v1, $t6 #box right is v1
		jr $ra

#helps with reordering the points so that they are easier to work with
Reorder:				
	beq $t4, $t2, SameRowReorder	#reorder left to right for the same row
	beq $t3, $t1, SameColReorder	#reorder top to bottom for the same column
	j NoReorder			#leave if not needed
	
	SameRowReorder:
		blt $t3, $t1, NoReorder
		move $s7, $t1
		move $t1, $t3
		move $t3, $s7
		j NoReorder		#leave since not needed anymore
	SameColReorder:
		blt $t4, $t2, NoReorder
		move $s7, $t2
		move $t2, $t4
		move $t4, $s7
		j NoReorder
	NoReorder:
		jr $ra
		

#splits the user entered integer into 4 values representing rows and columns of endpoints
SplitInteger:	
	beq $a0, -1, Exit		#if its a negative one, you can terminate the program
	blt $a0, 1112, ErrorSplit	#if its too low, then point not valid
	bgt $a0, 6867, ErrorSplit	#if its too high, then point not valid
	
	
	#use modulus to isolate the ones place and store it. Then divide by 10 to 
	#remove the ones place and make the old tens place the new ones place
	#repeat to get the next digit. So on and so forth
	li $t0, 10			
	
	div $a0, $t0
	mfhi $t1
	mflo $a0
	
	div $a0, $t0
	mfhi $t2
	mflo $a0
	
	div $a0, $t0
	mfhi $t3
	mflo $a0
	
	div $a0, $t0
	mfhi $t4
	mflo $a0
	
	move $t5, $ra
	jal Reorder
	move $ra, $t5
	
	
	jr $ra
	
	ErrorSplit:			#point not valid
		j ErrorMessageMain
