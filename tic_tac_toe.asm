# Dates: 5/22/2013



#################################################
#					 	#
#     	 	data segment			#
#						#
#################################################

	.data

grid:		.word 0,0,0,0,0,0,0,0,0   #initialize the array of 						    #grid
op_line:		.asciiz "\n" 
op_2line:		.asciiz "\n\n"                                 
op_userX:	  	.asciiz "user X please select the next square (1-9)"
op_userO:		.asciiz "user O please select the next square (1-9)"
op_invalid:		.asciiz "Invalid move! The square is already occupied; please select again (1-9)"
op_select: 		.asciiz "Select X or O (1-2)"
op_x:			.asciiz "X"
op_o:			.asciiz "O"
op_null:		.asciiz "-"
op_winX:		.asciiz "Congraduations, X WINS!"
op_winO:		.asciiz "Congraduations, O WINS!"
op_draw:		.asciiz "GAME DRAW"
op_newgame:		.asciiz "New game or Ending the Game(1-2)"


#################################################
#					 	#
#		text segment	  		#
#						#
#################################################
.globl main			# leave this here for the moment

	.text	

main:	
	la $a0, op_select    	#print string op_select
	li $v0,4
	syscall
		
	la $s3, grid          # load base address of array grid 					# into register $s3
	lw $t3, 0($s3)        # $t3 = grid[0]
	
	li $v0, 5			# load the input value into $v0	
	syscall
	
	move $t1, $v0 		# $t1 = $v0
	
	add $t2,$0,$0 		# $t2 = i = 0, the counter
	add $t0,$s3,$0

	add $t7,$0,$0		# counter $t7 = x = 0	
	Loop_initial_array:   # this is used for re-play the game
					# this loop re-initialize grid's 					# elements into 0s

		beq $t7,9,Next	# if x = 9, end the loop
		addi $t7,$t7,1	# x ++
	     	sw $0,($s3)	# grid[x] = 0
		add $s3,$s3,4	# go to next element
		j Loop_initial_array	#loop back
			

	Next:
		la $s3, grid          # reload base address of array 							# grid into register $s3
		beq $t1,1,loop1    	# if the user chooses 1 (play 							# X), then computer plays 								# first
		beq $t1,2,loop2		# else if user chooses 2(play 							#O)
						# then he/she plays first
	#add $t2,$0,$0 			# $t2 = i = 0, the counter

loop1: 
	  jal print		# go to print
	  li $s1,1	  	# $s1 = 1 if human player is X
	  li $s4,2		# $s4 = 2 if computers plays O
	  beq $t2,9,DRAW  	# if i = 9, game draws. By the time i = 9, both players played all the turns without winning; thus this statement runs when no one wins, thus DRAW.
	  li $s0,1		# it's X's turn when $s0 = 1
	  jal user		# jump to user

	  jal whichState #Check game state, whether someone won

	  addi $t2,$t2,1		# i++
	  
	  beq $t2,9,DRAW  	# if i = 9, game draws. By the time i = 9, both players played all the turns without winning; thus this statement runs when no one wins, thus DRAW.
	  li $s0,2		# it's O's turn when $s0 = 2
	  jal computer			# go to computer

	  jal whichState #Check game state, whether someone won

	  addi $t2,$t2,1		# i++
	  j loop1

loop2: 
	  li $s1,2  	     # $s1 = 2 if human player is O
	  li $s4,1			# $s4 = 1 if computers plays X
	  beq $t2,9,DRAW		# if i = 9, game draws. By the time i = 9, both players played all the turns without winning; thus this statement runs when no one wins, thus DRAW.

	  li $s0,1		# it's X's turn when $s0 = 1
	  jal computer			# jump to computer
	  jal whichState #Check game state, whether someone won

	  addi $t2,$t2,1		# i++
	  jal print	# go to print
	  beq $t2,9,DRAW  	# if i = 9, game draws. By the time i = 9, both players played all the turns without winning; thus this statement runs when no one wins, thus DRAW.

	  li $s0,2		# it's O's turn when $s0 = 2
	  jal user			# go to user
	  jal whichState #Check game state, whether someone won


	  addi $t2,$t2,1		# i++
	  j loop2

computer:
	 add $t4,$0,$0   	# $t4 = i = 0, is the counter#########################the strategy we design has three steps. first check if computer will win within one next step, 
	                                                    ##################    then check if user will win within one next step. if both thing can't happen, then computer choose the optimal choice.
	                                                    
	                                                  
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 #################################################here we start to check if there exist two consecutive computer's spot. if so, check if the third one is empty,  if also true, put computer input there.
	 #################################check all possibilities that computer could win by just one next move. if not, then computer made his own optimal move.
	checkcom1:
	 lw $t5,16($s3)
	 lw $t6,24($s3)
	 bne $t5,$s4,checkcom2 ##goto check another situation
	 bne $t6,$s4,checkcom2
	 lw $t7,8($s3)
	 bne $t7,0,checkcom2
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,8($s3)
	 j continuecomputer

	checkcom2:	 	  
	 lw $t5,4($s3)
	 lw $t6,8($s3)
	 bne $t5,$s4,checkcom3 ##goto check another situation
	 bne $t6,$s4,checkcom3
	 lw $t7,($s3)
	 bne $t7,0,checkcom3
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,($s3)
	 j continuecomputer

	checkcom3:
	 lw $t5,12($s3)
	 lw $t6,16($s3)
	 bne $t5,$s4,checkcom4 ##goto check another situation
	 bne $t6,$s4,checkcom4
	 lw $t7,20($s3)
	 bne $t7,0,checkcom4
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,20($s3)
	 j continuecomputer

	checkcom4:
	 lw $t5,16($s3)
	 lw $t6,20($s3)
	 bne $t5,$s4,checkcom5 ##goto check another situation
	 bne $t6,$s4,checkcom5
	 lw $t7,12($s3)
	 bne $t7,0,checkcom5
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,12($s3)
	 j continuecomputer

	checkcom5:
	 lw $t5,24($s3)
	 lw $t6,28($s3)
	 bne $t5,$s4,checkcom6 ##goto check another situation
	 bne $t6,$s4,checkcom6
	 lw $t7,32($s3)
	 bne $t7,0,checkcom6
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,32($s3)	
	 j continuecomputer 

	checkcom6:
	 lw $t5,28($s3)
	 lw $t6,32($s3)
	 bne $t5,$s4,checkcom7 ##goto check another situation
	 bne $t6,$s4,checkcom7
	 lw $t7,24($s3)
	 bne $t7,0,checkcom7
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,24($s3)
	 j continuecomputer

	checkcom7:
	 lw $t5,($s3)
	 lw $t6,12($s3)
	 bne $t5,$s4,checkcom8 ##goto check another situation
	 bne $t6,$s4,checkcom8
	 lw $t7,24($s3)
	 bne $t7,0,checkcom8
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,24($s3)
	 j continuecomputer

	checkcom8:
	 lw $t5,4($s3)
	 lw $t6,16($s3)
	 bne $t5,$s4,checkcom9 ##goto check another situation
	 bne $t6,$s4,checkcom9
	 lw $t7,28($s3)
	 bne $t7,0,checkcom9
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,28($s3)
	 j continuecomputer

	checkcom9:
	 lw $t5,8($s3)
	 lw $t6,20($s3)
	 bne $t5,$s4,checkcom10 ##goto check another situation
	 bne $t6,$s4,checkcom10
	 lw $t7,32($s3)
	 bne $t7,0,checkcom10
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,32($s3)
	 j continuecomputer

	checkcom10:
	 lw $t5,12($s3)
	 lw $t6,24($s3)
	 bne $t5,$s4,checkcom11 ##goto check another situation
	 bne $t6,$s4,checkcom11
	 lw $t7,($s3)
	 bne $t7,0,checkcom11
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,($s3)
	 j continuecomputer

	checkcom11:
	 lw $t5,16($s3)
	 lw $t6,28($s3)
	 bne $t5,$s4,checkcom12 ##goto check another situation
	 bne $t6,$s4,checkcom12
	 lw $t7,4($s3)
	 bne $t7,0,checkcom12
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,4($s3)
	 j continuecomputer

	checkcom12:
	 lw $t5,20($s3)
	 lw $t6,32($s3)
	 bne $t5,$s4,checkcom13 ##goto check another situation
	 bne $t6,$s4,checkcom13
	 lw $t7,8($s3)
	 bne $t7,0,checkcom13
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,8($s3)
	 j continuecomputer

	checkcom13:
	 lw $t5,($s3)
	 lw $t6,24($s3)
	 bne $t5,$s4,checkcom14 ##goto check another situation
	 bne $t6,$s4,checkcom14
	 lw $t7,12($s3)
	 bne $t7,0,checkcom14
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,12($s3)
	 j continuecomputer

	checkcom14:
	 lw $t5,4($s3)
	 lw $t6,28($s3)
	 bne $t5,$s4,checkcom15 ##goto check another situation
	 bne $t6,$s4,checkcom15
	 lw $t7,16($s3)
	 bne $t7,0,checkcom15
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,16($s3)
	 j continuecomputer

	checkcom15:
	 lw $t5,8($s3)
	 lw $t6,32($s3)
	 bne $t5,$s4,checkcom16 ##goto check another situation
	 bne $t6,$s4,checkcom16
	 lw $t7,20($s3)
	 bne $t7,0,checkcom16
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,20($s3)
	 j continuecomputer

	checkcom16:
	 lw $t5,($s3)
	 lw $t6,8($s3)
	 bne $t5,$s4,checkcom17 ##goto check another situation
	 bne $t6,$s4,checkcom17
	 lw $t7,4($s3)
	 bne $t7,0,checkcom17
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,4($s3)
	 j continuecomputer

	checkcom17:
	 lw $t5,12($s3)
	 lw $t6,20($s3)
	 bne $t5,$s4,checkcom18 ##goto check another situation
	 bne $t6,$s4,checkcom18
	 lw $t7,16($s3)
	 bne $t7,0,checkcom18
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,16($s3)
	 j continuecomputer

	checkcom18:
	 lw $t5,24($s3)
	 lw $t6,32($s3)
	 bne $t5,$s4,checkcom19 ##goto check another situation
	 bne $t6,$s4,checkcom19
	 lw $t7,28($s3)
	 bne $t7,0,checkcom19
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,28($s3)
	 j continuecomputer

	checkcom19:
	 lw $t5,($s3)
	 lw $t6,16($s3)
	 bne $t5,$s4,checkcom20 ##goto check another situation
	 bne $t6,$s4,checkcom20
	 lw $t7,32($s3)
	 bne $t7,0,checkcom20
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,32($s3)
	 j continuecomputer

	checkcom20:
	 lw $t5,16($s3)
	 lw $t6,32($s3)
	 bne $t5,$s4,checkcom21 ##goto check another situation
	 bne $t6,$s4,checkcom21
	 lw $t7,($s3)
	 bne $t7,0,checkcom21
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,($s3)
	 j continuecomputer

	checkcom21:
	 lw $t5,($s3)
	 lw $t6,32($s3)
	 bne $t5,$s4,checkcom22##goto check another situation
	 bne $t6,$s4,checkcom22
	 lw $t7,16($s3)
	 bne $t7,0,checkcom22
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,16($s3)
	 j continuecomputer

	checkcom22:
	 lw $t5,8($s3)
	 lw $t6,16($s3)
	 bne $t5,$s4,checkcom23 ##goto check another situation
	 bne $t6,$s4,checkcom23
	 lw $t7,24($s3)
	 bne $t7,0,checkcom23
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,24($s3)
	 j continuecomputer

	checkcom23:
	 lw $t5,8($s3)
	 lw $t6,24($s3)
	 bne $t5,$s4,checkcom24 ##goto check another situation
	 bne $t6,$s4,checkcom24
	 lw $t7,16($s3)
	 bne $t7,0,checkcom24
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,16($s3)
	 j continuecomputer

	checkcom24:
	 lw $t5,16($s3)
	 lw $t6,24($s3)
	 bne $t5,$s4,checkopponent ##goto check another situation
	 bne $t6,$s4,checkopponent
	 lw $t7,8($s3)
	 bne $t7,0,checkopponent
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,8($s3)
	 j continuecomputer
	 
	 ####### here we start to check if user can win in one next step .in each check, we  check if two consective place was user's input, then check the third one, if it's empty, then put one there
	 ###################################################################

	 
	 checkopponent: 
	 lw $t5,($s3)   
	 lw $t6,4($s3)
	 bne $t5,$s1,checkop2 ##goto check another situation  
	 bne $t6,$s1,checkop2
	 lw $t7,8($s3)
	 bne $t7,0,checkop2
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,8($s3)
	 j continuecomputer
	 
	 checkop2:
	  lw $t5,4($s3)
	 lw $t6,8($s3)
	 bne $t5,$s1,checkop3 ##goto check another situation
	 bne $t6,$s1,checkop3
	 lw $t7,($s3)
	 bne $t7,0,checkop3
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,($s3)
	 j continuecomputer

	checkop3:
	 lw $t5,12($s3)
	 lw $t6,16($s3)
	 bne $t5,$s1,checkop4 ##goto check another situation
	 bne $t6,$s1,checkop4
	 lw $t7,20($s3)
	 bne $t7,0,checkop4
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,20($s3)
	 j continuecomputer

	checkop4:
	 lw $t5,16($s3)
	 lw $t6,20($s3)
	 bne $t5,$s1,checkop5 ##goto check another situation
	 bne $t6,$s1,checkop5
	 lw $t7,12($s3)
	 bne $t7,0,checkop5
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,12($s3)
	 j continuecomputer

	checkop5:
	 lw $t5,24($s3)
	 lw $t6,28($s3)
	 bne $t5,$s1,checkop6 ##goto check another situation
	 bne $t6,$s1,checkop6
	 lw $t7,32($s3)
	 bne $t7,0,checkop6
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,32($s3)	
	 j continuecomputer 

	checkop6:
	 lw $t5,28($s3)
	 lw $t6,32($s3)
	 bne $t5,$s1,checkop7 ##goto check another situation
	 bne $t6,$s1,checkop7
	 lw $t7,24($s3)
	 bne $t7,0,checkop7
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,24($s3)
	 j continuecomputer

	checkop7:
	 lw $t5,($s3)
	 lw $t6,12($s3)
	 bne $t5,$s1,checkop8 ##goto check another situation
	 bne $t6,$s1,checkop8
	 lw $t7,24($s3)
	 bne $t7,0,checkop8
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,24($s3)
	 j continuecomputer

	checkop8:
	 lw $t5,4($s3)
	 lw $t6,16($s3)
	 bne $t5,$s1,checkop9 ##goto check another situation
	 bne $t6,$s1,checkop9
	 lw $t7,28($s3)
	 bne $t7,0,checkop9
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,28($s3)
	 j continuecomputer

	checkop9:
	 lw $t5,8($s3)
	 lw $t6,20($s3)
	 bne $t5,$s1,checkop10 ##goto check another situation
	 bne $t6,$s1,checkop10
	 lw $t7,32($s3)
	 bne $t7,0,checkop10
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,32($s3)
	 j continuecomputer

	checkop10:
	 lw $t5,12($s3)
	 lw $t6,24($s3)
	 bne $t5,$s1,checkop11 ##goto check another situation
	 bne $t6,$s1,checkop11
	 lw $t7,($s3)
	 bne $t7,0,checkop11
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,($s3)
	 j continuecomputer

	checkop11:
	 lw $t5,16($s3)
	 lw $t6,28($s3)
	 bne $t5,$s1,checkop12 ##goto check another situation
	 bne $t6,$s1,checkop12
	 lw $t7,4($s3)
	 bne $t7,0,checkop12
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,4($s3)
	 j continuecomputer

	checkop12:
	 lw $t5,20($s3)
	 lw $t6,32($s3)
	 bne $t5,$s1,checkop13 ##goto check another situation
	 bne $t6,$s1,checkop13
	 lw $t7,8($s3)
	 bne $t7,0,checkop13
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,8($s3)
	 j continuecomputer

	checkop13:
	 lw $t5,($s3)
	 lw $t6,24($s3)
	 bne $t5,$s1,checkop14 ##goto check another situation
	 bne $t6,$s1,checkop14
	 lw $t7,12($s3)
	 bne $t7,0,checkop14
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,12($s3)
	 j continuecomputer

	checkop14:
	 lw $t5,4($s3)
	 lw $t6,28($s3)
	 bne $t5,$s1,checkop15 ##goto check another situation
	 bne $t6,$s1,checkop15
	 lw $t7,16($s3)
	 bne $t7,0,checkop15
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,16($s3)
	 j continuecomputer

	checkop15:
	 lw $t5,8($s3)
	 lw $t6,32($s3)
	 bne $t5,$s1,checkop16 ##goto check another situation
	 bne $t6,$s1,checkop16
	 lw $t7,20($s3)
	 bne $t7,0,checkop16
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,20($s3)
	 j continuecomputer

	checkop16:
	 lw $t5,($s3)
	 lw $t6,8($s3)
	 bne $t5,$s1,checkop17 ##goto check another situation
	 bne $t6,$s1,checkop17
	 lw $t7,4($s3)
	 bne $t7,0,checkop17
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,4($s3)
	 j continuecomputer

	checkop17:
	 lw $t5,12($s3)
	 lw $t6,20($s3)
	 bne $t5,$s1,checkop18 ##goto check another situation
	 bne $t6,$s1,checkop18
	 lw $t7,16($s3)
	 bne $t7,0,checkop18
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,16($s3)
	 j continuecomputer

	checkop18:
	 lw $t5,24($s3)
	 lw $t6,32($s3)
	 bne $t5,$s1,checkop19 ##goto check another situation
	 bne $t6,$s1,checkop19
	 lw $t7,28($s3)
	 bne $t7,0,checkop19
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,28($s3)
	 j continuecomputer

	checkop19:
	 lw $t5,($s3)
	 lw $t6,16($s3)
	 bne $t5,$s1,checkop20 ##goto check another situation
	 bne $t6,$s1,checkop20
	 lw $t7,32($s3)
	 bne $t7,0,checkop20
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,32($s3)
	 j continuecomputer

	checkop20:
	 lw $t5,16($s3)
	 lw $t6,32($s3)
	 bne $t5,$s1,checkop21 ##goto check another situation
	 bne $t6,$s1,checkop21
	 lw $t7,($s3)
	 bne $t7,0,checkop21
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,($s3)
	 j continuecomputer

	checkop21:
	 lw $t5,($s3)
	 lw $t6,32($s3)
	 bne $t5,$s1,checkop22##goto check another situation
	 bne $t6,$s1,checkop22
	 lw $t7,16($s3)
	 bne $t7,0,checkop22
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,16($s3)
	 j continuecomputer

	checkop22:
	 lw $t5,8($s3)
	 lw $t6,16($s3)
	 bne $t5,$s1,checkop23 ##goto check another situation
	 bne $t6,$s1,checkop23
	 lw $t7,24($s3)
	 bne $t7,0,checkop23
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,24($s3)
	 j continuecomputer

	checkop23:
	 lw $t5,8($s3)
	 lw $t6,24($s3)
	 bne $t5,$s1,checkop24 ##goto check another situation
	 bne $t6,$s1,checkop24
	 lw $t7,16($s3)
	 bne $t7,0,checkop24
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,16($s3)
	 j continuecomputer

	checkop24:
	 lw $t5,16($s3)
	 lw $t6,24($s3)
	 bne $t5,$s1,computeroptimalchoice##goto check another situation
	 bne $t6,$s1,computeroptimalchoice
	 lw $t7,8($s3)
	 bne $t7,0,checkcom1
	 add $t7,$0,$0
	 add $t7,$t7,$s4
	 sw $t7,8($s3)
	 j continuecomputer
	
	 
	                             
	 computeroptimalchoice: 
	    lw $t6,16($s3)  ##check the central point
	    bne $t6,0,checkcornor1 ##goto check cornor
	    add $t6,$t6,$s4 ##set the value
	    sw $t6,16($s3) ##store the vaule into central point
	    j continuecomputer
	    
	    
	    checkcornor1:
	    lw $t6,($s3) ##check first cornor
	    bne $t6,0, checkcornor2     ##goto check second cornor
	    add $t6,$t6,$s4 ##set the value
	    sw $t6,($s3) ###store the value in grid
	    j continuecomputer
	    checkcornor2:
	    lw $t6,8($s3) ##check first cornor
	    bne $t6,0, checkcornor3     ##goto check third cornor
	    add $t6,$t6,$s4 ##set the value
	    sw $t6,8($s3) ###store the value in grid
	    j continuecomputer
	    checkcornor3:
	    lw $t6,24($s3) ##check first cornor
	    bne $t6,0, checkcornor4     ##goto check last cornor
	    add $t6,$t6,$s4 ##set the value
	    sw $t6,24($s3) ###store the value in grid
	    j continuecomputer
	    checkcornor4:
	    lw $t6,32($s3) ##check first cornor
	    bne $t6,0, regular     ##goto regular step
	    add $t6,$t6,$s4 ##set the value
	    sw $t6,32($s3) ###store the value in grid
	    j continuecomputer
	    
	    
	    
	 regular:   
	    
		sll $t5,$t4,2 	# $t5 = 4*i
		add $t5,$t5,$s3	# $t5 = address of grid[i]
		lw  $t6,($t5)	# $t6 = grid[i]
		addi $t4,$t4,1	# i++
		bne $t6,0,regular # if t6 != 0, go back to loopc
		add  $t6,$t6,$s4 	# set $t6 = $s4
		sw  $t6,($t5)	# store $t6's value into grid[i]							# (t5)
		continuecomputer:
		jr $ra
		
		

user:
	  la $a0,op_2line     # print out two empty lines to 						# create a gap for good looking
	  li $v0,4	
	  syscall	
       
	  beq $s1,2,userO		#if user is O, then go to 							#op_userO

	  la $a0, op_userX		#print string op_user   
       li $v0, 4		      
	  syscall  		
	  j continue

	  userO:la $a0, op_userO 	#print string op_user   
       		li $v0, 4		      
	  		syscall  		

	  
	 continue: li $v0, 5         	# take input value and put in $v0
	  syscall
	  loopuser:
			move $s2,$v0 	# $s2 = input value
	 		sub $s2,$s2,1	# $s2 =- 1
			sll $s2,$s2,2   # $s2 = 4*[input-1]
			add $s2,$s2,$s3 # $s2 = address grid[input-1]
			lw $t8,0($s2)# $t8 = grid[input-1]
			bne $t8,0,error # if t8 != 0, go to error
			add $t8,$t8,$s1  	# else, t8 = s1
			sw $t8,0($s2)	# store t8's value(2) into 							# grid[input-1]
			jr $ra		# go back to $ra (loop1/loop2)
	   error:  la $a0,op_invalid # print op_invalid when the 							  #spot is already occupied 
			li $v0, 4		      
			syscall  
	
			li $v0, 5 	#take input value and put in $v0
			syscall 
    			j loopuser #go back to loopuser


print:
	la $a0,op_line     	#print out an empty line
	li $v0,4		
	syscall		
### for (i = 1; i < 10; i++)
	li $t9,1               #set i = 1
	Loop: 
		 sll $s7,$t9,2    #$s7 = 4*i
		 add $s7,$s7,$s3	  #$s7 = address grid[i]		 
		 sub $s7,$s7,4    #$s7 = address grid[i-1]
		 lw $s6,($s7)     #$s6 = grid[i-1]
		 slt $s5,$t9,10   #if  i < 10, s5 = 1
					  #else s5 = 0
		 beq $s5,$0,goback   #if $s5 = 0, which means $t9 is 					     #not less than 10, then go to 					     #goback
				 	 
		 beq $s6,1, PrintX        #if grid[i-1] = 1, go t PrintX
		 j Next_print 		    #go to Next_print	
		 PrintX:			    #print "X"
			   la $a0,op_x
			   li $v0,4
			   syscall
			   j whetherNextLine	
		
		 Next_print:
		 	beq $s6,2, PrintO   #if grid[i-1] = 2
		 	j Next_next_print   #go to Next_next_print
		 PrintO:		
			   la $a0,op_o	    #print "O"
			   li $v0,4
			   syscall
			   j whetherNextLine	
	
		 Next_next_print:
			 beq $s6,0,PrintNull      #if grid[i-1] = 0
		 PrintNull:               #print '-'
			    la $a0,op_null
			    li $v0,4
			    syscall
			    j whetherNextLine	

		 whetherNextLine:	
		 	beq $t9,3,NextLine	#change line before A[3]
		 	beq $t9,6 NextLine	#change line line before 							#A[6]
			add $t9,$t9,1    	#i++

		 	j Loop
		 	NextLine:
				add $t9,$t9,1    	#i++
				la $a0,op_line     	#print out an empty 									#line
				li $v0,4	
				syscall	
			
				j Loop
				goback:		# go back to main 
							# program after 									# printing the status
					jr $ra
		 		

whichState:  #contains all state; mainly determine whether WIN or CONTINUE (DRAW, CONTINUE, WIN-X, WIN-Y)

## Check Diagonals for Winning
			  add $a1,$ra,$0 #load Return Address $ra to $a1
  			  
#check if grid[2]==grid[4]==grid[6],see Check
			  li $t5,8 
			  li $t7,16 
	 		  li $s6,24
			  jal Check
					
#check if grid[0]==grid[4]==grid[8],see Check
			  li $t5,0
			  li $t7,16 
	 		  li $s6,32
			  jal Check
	
## Check Rows for Winning
#check if grid[0]==grid[1]==grid[2],see Check      
			  li $t5,0
			  li $t7,4 
	 		  li $s6,8
			  jal Check

#check if grid[3]==grid[4]==grid[5],see Check
			  li $t5,12
			  li $t7,16 
	 		  li $s6,20
			  jal Check
	
#check if grid[6]==grid[7]==grid[8],see Check
			  li $t5,24
			  li $t7,28 
	 		  li $s6,32
			  jal Check
	
## Check Columns for Winning
#check if grid[0]==grid[3]==grid[6],see Check
			  li $t5,0
			  li $t7,12
	 		  li $s6,24
			  jal Check

#check if grid[1]==grid[4]==grid[7],see Check
			  li $t5,4
			  li $t7,16 
	 		  li $s6,28
			  jal Check
	
#check if grid[2]==grid[5]==grid[8],see Check
			  li $t5,8
			  li $t7,20 
	 		  li $s6,32
			  jal Check						   

	CONTINUES:       #CONTINUES state; this is before player takes all the spots, and if no one wins at the turn, game continue.
			jr $a1     #jump back to the main Loops

	
	DRAW: # DRAW state; all the spots are taken (i = 9), and no one wins at this moment, thus DRAW.
				jal print			#print game status
				la $a0,op_2line		#print two empty lines
				li $v0,4
				syscall
		
				la $a0,op_draw		#print out op_draw
				li $v0,4
				syscall
			
				j exit			#end the game


 	Check:	#function Check with parameters ($t5,$t7,$s6),is used to check whether someone wins

			add $s5,$s3,$t5 #$s5 = address of the 1st  element in the LINE
			add $s7,$s3,$t7	#$s7 = address of the 2nd element in the LINE
			add $t9,$s3,$s6	#$t9 = address of the 3rd element in the LINE
			lw $s5,($s5)	#$s5=the 1st element in the LINE
			lw $s7,($s7)	#$s7=the 2nd element in the LINE
			lw $t9,($t9)	#$t9=the 3rd element in the LINE
	
			beq $0,$s5,return #if any element = 0, jump back and check the next row, column, or diagonal
			beq $0,$s7,return
			beq $0,$s7,return
			beq $s5,$s7,Check_Next #if 1st = 2nd, then go to check_next
	 		return:	jr $ra
	 	 
	 Check_Next:			     	 #check if 2nd = 3rd
			beq $s5,$t9,WIN		 #if 2nd = 3rd, go to WIN
			jr $ra			 #else, jump back and check the next row, column, or diagonal
			
	 WIN:	

			beq $s5,1,WinX	# if X wins, go to WinX
			beq $s5,2,WinO	# if O wins, go to WinO
			
			WinO:		# WinO State

				jal print			#print game status
				la $a0,op_2line		#print two empty lines
				li $v0,4
				syscall

				la $a0,op_winO	# else: O wins, and print out winO
				li $v0,4
				syscall

				j exit		# end the game
			WinX: 	# WinX State
				jal print			#print game status
				la $a0,op_2line		#print two empty lines
				li $v0,4
				syscall

				la $a0,op_winX	# X wins, and print 									# out winX
				li $v0,4
				syscall
				j exit		# end the game
	jr $ra		#Jump back; this is another Continue because no one wins.

	exit: 		
		la $a0,op_2line		#print two empty lines
		li $v0,4
		syscall
		
		la $a0,op_newgame	#ask player whether to play a 						#new game
		li $v0,4
		syscall

		li $v0, 5			# load the input value into 						# $v0	
		syscall
		add $t7,$v0,0		# set $t7 to the input value
		
		beq $t7,1,main		# if $t7 is 1, go back to main 						# and re-play the game
		li $v0,10			# end the program
		syscall

	
