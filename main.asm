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
	lw $t0, displayAddress	# display address
	li $t1, 0xff0000	# red
	li $t2, 0x00ff00	# green
	li $t3, 0x0000ff	# blue
	li $t4, 0xffff00	#yellow
	
	
.globl main
.globl Exit
.globl TakeInValueP1
.globl TakeInValueP2

main:
	jal FillScreen					#fill screen background
	lw $t0, displayAddress				#load display into $t0
	jal DrawBoard					#draw board dots
	
	drawLines:					#begin the loop of drawing lines
		la $a0, instructions
		jal PrintMessage			#print instructions
	
	TakeInValueP1:					#take in user input value
		li $s4, 1					
		#get into register
		li $v0, 5
		syscall
		move $a0, $v0
		
		jal SplitInteger			#split value into rows and columns of endpoints of line
	
		move $a0, $t4				#store resulting split in arguments for future functions
		move $a1, $t3
		move $a2, $t2
		move $a3, $t1
		jal IsValidDistance			#check to see if the line is valid length
		jal IsValidBounds			#check to see if end points are within bounds
	
		bgt $v0, $zero, ContinueP1		#check for -1 exit
		blt $v0, $zero, Exit
		li $s4, 1				#if all else fails, print error message
		jal ErrorMessageMain
		
	
	ContinueP1:
		move $a0, $t4				#in case argument variables are changed, reinstantiate them as endpoint values
		move $a1, $t3
		move $a2, $t2
		move $a3, $t1
		li $s1, 0x00ff00			#user line color
		jal FindPixel				#set game iterator to the beginning dot of line
		jal IsRepeat				#check to see if proposed line has already been made
		jal PaintLine				#draw line
		jal FindPixel				#return iterator to beginning of line
		li $s4, 1	#it is user		#$s4 holds the status of the game player. If it is 1, then user is playing. If 0, then computer
		jal CheckBoxes				#check to see if new line closed a box
		li $s1, 0x013220			#color of closed box
		li $s4, 1	#it is user		
		jal ValidateBoxes			#draw all new closed boxes and print messages
		jal IsGameOver				#check if game is over
		
		j TakeInValueP2				#give control to player 2

		j Exit					#if all else fails, exit
		
	TakeInValueP2:
			
		li $s4, 0	#it is comp		#game is controlled by computer now
		
		#get into register			#syscall 42 enters a random integer. These lines create a random line by computer
		li $v0, 42
		li $a1, 6
		syscall
		addi $a0, $a0, 1
		move $t4, $a0
		
		li $v0, 42
		li $a1, 8
		syscall
		addi $a0, $a0, 1
		move $t3, $a0

		li $v0, 42
		li $a1, 6
		syscall
		addi $a0, $a0, 1
		move $t2, $a0

		li $v0, 42
		li $a1, 8
		syscall
		addi $a0, $a0, 1
		move $t1, $a0
	
		move $a0, $t4				#store endpoints
		move $a1, $t3
		move $a2, $t2
		move $a3, $t1
		jal IsValidDistance			#check for valid line
		jal IsValidBounds
	
		bgt $v0, $zero, ContinueP2		#check for -1 exit
		blt $v0, $zero, Exit
		li $s4, 0				
		#jal ErrorMessageMain			#if all else fails, redo point
		
	
	ContinueP2:
		move $a0, $t4				#restore endpoints
		move $a1, $t3
		move $a2, $t2
		move $a3, $t1
		li $s1, 0xffff00			#color of computer lines
		jal FindPixel				#same as player 1
		jal IsRepeat
		jal PaintLine
		jal FindPixel
		li $s4, 0	#it is computer
		jal CheckBoxes
		li $s1, 0xFFA500			#color of computer box
		li $s4, 0	#it is computer
		jal ValidateBoxes
		jal IsGameOver	
			
		j TakeInValueP1				#control is given to the player

		j Exit
	
Exit:
	li $v0, 10
	syscall
