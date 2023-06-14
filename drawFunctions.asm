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

.globl PaintLine
.globl FindPixel
.globl PaintPixel
.globl DrawBoard
.globl FillScreen
.globl ValidateBoxes

	
#draw all newly made boxes with a different color to show that box has been made
ValidateBoxes:
	beq $t9, 1, VertValidate					#$t9 holds whether the line drawn is vertical or horizontal. 1 if vertical 0 if horizontal
	HorizValidate:							#if horizontal
		beq $v0, 4, TopVal					#if v0 is 4, then there is a box above the newly drawn line
		j BottomVal						#if not, then check if there is a box below the newly drawn line
		
		#move the display pointer to different corners of the box and alter the endpoints of the line to utilize the paintline function and paint over
		#the box with a new color.
		TopVal:		
			beq $s4, $zero, IsComp1				#add one point to whoever completed the box
			addi $s5, $s5, 1	#s5 is user score
			j Cont1
			IsComp1:
				addi $s6, $s6, 1#Comp Score
			Cont1:
			move $s0, $ra					#store return address
			jal PaintLine
			subi $t0, $t0, 1572				#move pointer
			jal PaintLine
			subi $t0, $t0, 36	
			subi $a0, $a0, -1				#alter structure of line to vertical
			subi $a3, $a3, -1
			jal PaintLine
			subi $t0, $t0, 1760
			jal PaintLine
			move $ra, $s0
			
			move $s0, $ra
			jal BoxDrawnMessage				#alert user that box has been drawn
			move $ra, $s0
			
		#repeat the same thing for a box below, if there is one. This is checked usingn v1
		BottomVal:

			bne $v1, 4, EndFunct
			
			beq $s4, $zero, IsComp2				#add one to the score of whoever closed the box
			addi $s5, $s5, 1	#s5 is user score
			j Cont2
			IsComp2:
				addi $s6, $s6, 1#Comp Score
			Cont2:
			move $s0, $ra
			jal PaintLine
			addi $t0, $t0, 1500
			jal PaintLine
			subi $t0, $t0, 1572
			subi $a0, $a0, -1
			subi $a3, $a3, -1
			jal PaintLine
			subi $t0, $t0, 1760
			jal PaintLine
			move $ra, $s0
			
			move $s0, $ra
			jal BoxDrawnMessage				#alert the user
			move $ra, $s0
	
	#this works extremely similar to how the horizontal one worked. It moves the display pointer to the four corners of the drawn box. For the horizontal
	#lines that need to be drawn, it alters the endpoints for the line to make it work with paintline
	VertValidate:
		beq $v0, 4, LeftVal
		j RightVal
		LeftVal:
			beq $s4, $zero, IsComp3
			addi $s5, $s5, 1	#s5 is user score
			j Cont3
			IsComp3:
				addi $s6, $s6, 1#Comp Score
			Cont3:
			move $s0, $ra
			jal PaintLine
			subi $t0, $t0, 1824
			jal PaintLine
			subi $t0, $t0, 256
			move $a0, $a2
			jal PaintLine
			subi $t0, $t0, 1572
			jal PaintLine
			move $ra, $s0
			
			move $s0, $ra
			jal BoxDrawnMessage
			move $ra, $s0
			
		RightVal:

			bne $v1, 4, EndFunct
			
			beq $s4, $zero, IsComp4
			addi $s5, $s5, 1	#s5 is user score
			j Cont4
			IsComp4:
				addi $s6, $s6, 1#Comp Score
			Cont4:
			
			move $s0, $ra
			jal PaintLine
			subi $t0, $t0, 1760
			jal PaintLine
			subi $t0, $t0, 1824
			move $a0, $a2
			jal PaintLine
			addi $t0, $t0, 1500
			jal PaintLine
			move $ra, $s0
			
			move $s0, $ra
			jal BoxDrawnMessage
			move $ra, $s0
			

	EndFunct:
		jr $ra

#this fills the screen with a dark gray color to have a board color
FillScreen:
	la $t8, 0x5A5A5A					#background color
	la $t4, 256						#length of a row
	la $t5, 0						#iterate through rows and columns
	la $t6, 0						#iterate through rows and columns
	la $t7, 45						# 45 rows
	LoopScreen:
		sw   $t8, ($t0)
		addi $t0, $t0, 4
		addi $t5, $t5, 4
		bge $t5, $t4, EndRowScreen
		j LoopScreen
	EndRowScreen:
		addi $t6, $t6, 1
		beq $t6, $t7, EndLoopScreen
		subi  $t5, $t5, 256
		j LoopScreen
	EndLoopScreen:
		jr $ra


#draw red dots in a 6 row by 8 column shape 
DrawBoard:
	la $t4, 248
	la $t6, 1000
	la $t5, 0
	la $t6, 0
	la $t7, 6
	Loop:
		sw   $t1, 524($t0)
		addi $t0, $t0, 32
		addi $t5, $t5, 32
		bge $t5, $t4, EndRow
		j Loop
	EndRow:
		addi $t6, $t6, 1
		beq $t6, $t7, EndLoop
		addi $t0, $t0, 1280
		subi  $t5, $t5, 256
		j Loop
	EndLoop:
		jr $ra



		


PaintLine: 
	move $t1, $s1
	li $t2, 9
	li $t3, 7
	beq $a0, $a2, ifHorizontal
	ifVertical:
		la $t9, 1
		vertLoop:
			sw   $t1, ($t0)
			addi $t0, $t0, 256
			subi $t3, $t3, 1
			ble $t3, $zero, EndLine
			j vertLoop
	ifHorizontal:
		la $t9, 0
		horizLoop:
			sw   $t1, ($t0)
			addi $t0, $t0, 4
			subi $t2, $t2, 1
			ble $t2, $zero, EndLine
			j horizLoop
	EndLine:
		jr $ra
		
FindPixel:
	lw $t0, displayAddress
	addi $t0, $t0, 524
	la $t5, 1
	la $t6, 1
	Loop3:
		beq $t5, $a0, InnerLoop3
		addi $t0, $t0, 1536
		addi $t5, $t5, 1
		j Loop3
	InnerLoop3:
		beq $t6, $a1, ExitLoop3
		addi $t0, $t0, 32
		addi $t6, $t6, 1
		j InnerLoop3
	ExitLoop3:
		jr $ra

PaintPixel:
	lw $t0, displayAddress
	addi $t0, $t0, 524
	la $t5, 1
	la $t6, 1
	Loop2:
		beq $t5, $a0, InnerLoop2
		addi $t0, $t0, 1536
		addi $t5, $t5, 1
		j Loop2
	InnerLoop2:
		beq $t6, $a1, ExitLoop2
		addi $t0, $t0, 32
		addi $t6, $t6, 1
		j InnerLoop2
	ExitLoop2:
		sw $a3, ($t0)
		jr $ra
