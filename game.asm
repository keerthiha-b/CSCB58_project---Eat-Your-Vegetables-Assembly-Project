#####################################################################
#
# CSCB58 Winter 2023 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Keerthiha, 1008205014, baskar94, keerthiha.baskaran@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3 (choose the one the applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################
.data
size:	.word 0x10000
player_position:  .word 12552
monster_position: .word 1300
B: .word 0:65536

.text

.globl main
main:
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display hefight in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.eqv BASE_ADDRESS 0x10008000

li $t0, BASE_ADDRESS # $t0 stores the base address for display
li $t1, 0x10000 # save 256*256 pixels
li $t2, 0xffc0cb # $t2 stores the pink colour code for background
li $t3, 0x9a3f1d # $t3 stores the brown colour code for platforms
li $t4, 0x4587C0 # $t3 stores the blue colour monster code
li $s4, 0x37969D	#ladder color
la $s0, player_position		# get address of player
lw $s0, 0($s0)		# load value of player
la $s6, monster_position		# get address of monster
lw $s6, 0($s6)		# load value of monster
la $s2, B			# $t9 holds address of array A

li $a0, 0	#background
add $a0, $a0, $t0
li $a1, 0
li $a2, 0xffc0cb
jal platforms

li $a0, 14848	#floor
add $a0, $a0, $t0
li $a1, 0
li $a2,  0x9a3f1d
jal platforms

li $a0, 0	#upper border
add $a0, $a0, $t0
li $a1, 65472
li $a2,  0x9a3f1d
jal platforms
li $a0, 256	
add $a0, $a0, $t0
li $a1, 65472
li $a2,  0xffc0cb
jal platforms

li $a0, 1024	#upper second border
add $a0, $a0, $t0
li $a1, 65472
li $a2,  0x9a3f1d
jal platforms
li $a0, 1280	
add $a0, $a0, $t0
li $a1, 65472
li $a2,  0xffc0cb
jal platforms

li $a0, 0	#side border
add $a0, $a0, $t0
li $a1, 65472
li $a2,  0x9a3f1d
jal side_border

li $a0, 252	#side border
add $a0, $a0, $t0
li $a1, 65472
li $a2,  0x9a3f1d
jal side_border

li $a2,  0x9a3f1d
li $a0, 12052	#platform 1
add $a0, $a0, $t0
li $a1, 65480
jal platforms

li $a0, 9256	#platform 2
add $a0, $a0, $t0
li $a1, 65491
jal platforms

li $a0, 6440	#platform 3
add $a0, $a0, $t0
li $a1, 65491
jal platforms

li $a0, 3604	#platform 4
add $a0, $a0, $t0
li $a1, 65480
jal platforms

li $a2, 0x37969D
li $a0, 12416	#ladder 1
subi $a1, $a0, 256
add $a0, $a0, $t0
jal ladder_horizontal
add $a1, $a1, $t0
jal ladder_vertical

li $a0, 9548	#ladder 2
subi $a1, $a0, 256
add $a0, $a0, $t0
jal ladder_horizontal
add $a1, $a1, $t0
jal ladder_vertical

li $a0, 9652	#ladder 3
subi $a1, $a0, 256
add $a0, $a0, $t0
jal ladder_horizontal
add $a1, $a1, $t0
jal ladder_vertical

li $a0, 6784	#ladder 4
subi $a1, $a0, 256
add $a0, $a0, $t0
jal ladder_horizontal
add $a1, $a1, $t0
jal ladder_vertical

li $a0, 4020	#ladder 5
subi $a1, $a0, 256
add $a0, $a0, $t0
jal ladder_horizontal
add $a1, $a1, $t0
jal ladder_vertical

li $a1, 0xA77C38
li $a2, 0x5D1A0F
li $a0, 13520  #5 cookies
addi $a0, $a0, BASE_ADDRESS
jal cookie

li $a0, 2176
addi $a0, $a0, BASE_ADDRESS
jal cookie

li $a0, 4192
addi $a0, $a0, BASE_ADDRESS
jal cookie

li $a0, 7728
addi $a0, $a0, BASE_ADDRESS
jal cookie

li $a0, 10652
addi $a0, $a0, BASE_ADDRESS
jal cookie

		# store the original layout on stack
la $a0, B	# $a0 holds address of array B
li $a1, BASE_ADDRESS # $t0 stores the base address for display
li $a2, 0x10000 # save 256*256 pixels

jal load_background


		# initial player creation
li $a2, 0xFFE6C4
add $a1, $s0, $zero
add $a1, $a1, $t0
jal player

		# initial cookie monster creation
li $a2, 0x4587C0
add $a1, $s6, $zero
add $a1, $a1, $t0
jal cookie_monster
addi $a0, $a1, 284
li $a1, 0xA77C38
li $a2, 0x5D1A0F
jal cookie


game_loop:
	li $t9, 0xffff0000		# get keypress from keyboard input
	lw $t8, 0($t9)
	beq $t8, 1, keypress
	j game_loop

keypress:	
	li	$v0, 32			# syscall sleep
	addi	$a0, $zero, 60		# 60 ms
	syscall
	
	lw $t5, 4($t9)
	beq	$t5, 100, d_pressed	# if key press = 'd' branch to moveright
	beq	$t5, 97, a_pressed	# else if key press = 'a' branch to moveLeft
	beq	$t5, 119, w_pressed	# if key press = 'w' branch to moveUp
	beq	$t5, 115, s_pressed	# else if key press = 's' branch to moveDown=
	beq	$t5, 112, p_pressed	# restart game if key press = 'p'
	
w_pressed:
	
	addi  $s3, $zero, -256		# s3 = make player be 256 higher
	add $a3, $s0, $s3
	la $a2, B
	add $a1, $t3, $zero
	jal check_platform_above
	beq $v1, 1, next_move
	
	la $a0, B	# $a0 holds address of array B
	li $a1, BASE_ADDRESS # $t0 stores the base address for display
	add $a1, $a1, $s0  # $t0 stores the base address for display
	add $a0, $a0, $s0  # $t0 stores the base address for display
	add $s0, $s3, $s0		# update player position

	jal clean_up
		# initial player creation
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player
	
	#add $a3, $s0, $zero
	#la $a2, B
	#jal check_flying
	
	j next_move 	

s_pressed:
	addi $s3, $zero, 256		# s3 = make player be 256 higher
		
	add $a3, $s0, $s3
	la $a2, B
	add $a1, $t3, $zero
	jal check_platform_down
	beq $v1, 1, next_move
	
	la $a0, B	# $a0 holds address of array B
	li $a1, BASE_ADDRESS # $t0 stores the base address for display
	add $a1, $a1, $s0  # $t0 stores the base address for display
	add $a0, $a0, $s0  # $t0 stores the base address for display
	add $s0, $s3, $s0		# update player position

	jal clean_down
	
		# initial player creation
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player

	
	j next_move 
	
a_pressed:
	addi $s3, $zero, -4		# s3 = make player be 256 higher
	
		
	add $a3, $s0, $s3
	la $a2, B
	add $a1, $t3, $zero
	jal check_platform_left
	beq $v1, 1, next_move
	
	la $a0, B	# $a0 holds address of array B
	li $a1, BASE_ADDRESS # $t0 stores the base address for display
	add $a1, $a1, $s0  # $t0 stores the base address for display
	add $a0, $a0, $s0  # $t0 stores the base address for display
	add $s0, $s3, $s0		# update player position

	
	jal clean_left
		# initial player creation
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player

	
	j next_move 
	
d_pressed:
	addi  $s3, $zero, 4		# s3 = make player be 256 higher

	
	add $a3, $s0, $s3
	la $a2, B
	add $a1, $t3, $zero
	jal check_platform_right
	beq $v1, 1, next_move
	
	la $a0, B	# $a0 holds address of array B
	li $a1, BASE_ADDRESS # $t0 stores the base address for display
	add $a1, $a1, $s0  # $t0 stores the base address for display
	add $a0, $a0, $s0  # $t0 stores the base address for display
	add $s0, $s3, $s0		# update player position

	
	jal clean_right
		# initial player creation
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player

	
	j next_move 
	
p_pressed:
		# store the original layout on stack
la $a0, B	# $a0 holds address of array B
li $a1, BASE_ADDRESS # $t0 stores the base address for display
li $a2, 0x10000 # save 256*256 pixels

jal clear_background
addi $s0, $zero, 12544

		# initial player creation
li $a2, 0xFFE6C4
add $a1, $s0, $zero
addi $a1, $a1, BASE_ADDRESS
jal player

j next_move




next_move:
li $a0, 4192
addi $a0, $a0, BASE_ADDRESS
beq $s0, $a0, eat_cookie

j 	game_loop		# loop back to beginning







eat_cookie:
	
	li $a1, 0xffc0cb
	li $a2, 0xffc0cb
	jal cookie
	
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player
	
	j game_loop
	

check_flying:
add $t8, $a2, $a3
lw $t8, 2316($t8)
beq $t8, 0xffc0cb, gravity
lw $t8, 2324($t8)
beq $t8, 0xffc0cb, gravity

jr $ra


gravity:
addi $s3, $zero, 256		# s3 = make player be 256 higher
		
la $a0, B	# $a0 holds address of array B
li $a1, BASE_ADDRESS # $t0 stores the base address for display
add $a1, $a1, $s0  # $t0 stores the base address for display
add $a0, $a0, $s0  # $t0 stores the base address for display
	
add $s0, $s3, $s0		# update player position

jal clean_down
	
		# initial player creation
li $a2, 0xFFE6C4
add $a1, $s0, $zero
addi $a1, $a1, BASE_ADDRESS
jal player

j check_flying


check_platform_above:
add $t8, $a2, $a3
lw $t8, 4($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 8($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 12($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 16($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 20($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 24($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 28($t8)
beq $t8, $a1, yes_platform
addi $v1, $zero, 0
jr $ra

check_platform_left:
add $t8, $a2, $a3
lw $t8, 0($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 256($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 512($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 768($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 1024($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 1280($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 1536($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 1792($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 2048($t8)
beq $t8, $a1, yes_platform
addi $v1, $zero, 0
jr $ra

check_platform_right:
add $t8, $a2, $a3
lw $t8, 32($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 288($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 544($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 800($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 1312($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 1568($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 1824($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 2080($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 1328($t8)
beq $t8, $a1, yes_platform
addi $v1, $zero, 0
jr $ra

check_platform_down:
add $t8, $a2, $a3
lw $t8, 2060($t8)
beq $t8, $a1, yes_platform
add $t8, $a2, $a3
lw $t8, 2068($t8)
beq $t8, $a1, yes_platform
addi $v1, $zero, 0
jr $ra

yes_platform:
addi $v1, $zero, 1
jr $ra

clean_up:
lw $t8, 1024($a0)
sw $t8, 1024($a1)		# write back into memory into B
lw $t8, 1284($a0)
sw $t8, 1284($a1)		# write back into memory into B
lw $t8, 1800($a0)
sw $t8, 1800($a1)		# write back into memory into B
lw $t8, 2060($a0)
sw $t8, 2060($a1)		# write back into memory into B
lw $t8, 1808($a0)
sw $t8, 1808($a1)		# write back into memory into B
lw $t8, 2068($a0)
sw $t8, 2068($a1)		# write back into memory into B
lw $t8, 1816($a0)
sw $t8, 1816($a1)		# write back into memory into B
lw $t8, 1308($a0)
sw $t8, 1308($a1)		# write back into memory into B
lw $t8, 1312($a0)
sw $t8, 1312($a1)		# write back into memory into B
lw $t8, 2084($a0)
sw $t8, 2084($a1)		# write back into memory into B
lw $t8, 2088($a0)
sw $t8, 2088($a1)		# write back into memory into B
lw $t8, 2092($a0)
sw $t8, 2092($a1)		# write back into memory into B
lw $t8, 1328($a0)
sw $t8, 1328($a1)		# write back into memory into B

jr $ra

clean_down:
lw $t8, 256($a0)
sw $t8, 256($a1)		# write back into memory into B
lw $t8, 4($a0)
sw $t8, 4($a1)		# write back into memory into B
lw $t8, 8($a0)
sw $t8, 8($a1)		# write back into memory into B
lw $t8, 12($a0)
sw $t8, 12($a1)		# write back into memory into B
lw $t8, 16($a0)
sw $t8, 16($a1)		# write back into memory into B
lw $t8, 20($a0)
sw $t8, 20($a1)		# write back into memory into B
lw $t8, 24($a0)
sw $t8, 24($a1)		# write back into memory into B
lw $t8, 28($a0)
sw $t8, 28($a1)		# write back into memory into B
lw $t8, 288($a0)
sw $t8, 288($a1)		# write back into memory into B
lw $t8, 548($a0)
sw $t8, 548($a1)		# write back into memory into B
lw $t8, 556($a0)
sw $t8, 556($a1)		# write back into memory into B
lw $t8, 1064($a0)
sw $t8, 1064($a1)		# write back into memory into B
lw $t8, 812($a0)
sw $t8, 812($a1)		# write back into memory into B
lw $t8, 804($a0)
sw $t8, 804($a1)		# write back into memory into B
lw $t8, 1328($a0)
sw $t8, 1328($a1)		# write back into memory into B
jr $ra

clean_left:
lw $t8, 28($a0)
sw $t8, 28($a1)		# write back into memory into B
lw $t8, 288($a0)
sw $t8, 288($a1)		# write back into memory into B
lw $t8, 544($a0)
sw $t8, 544($a1)		# write back into memory into B
lw $t8, 812($a0)
sw $t8, 812($a1)		# write back into memory into B
lw $t8, 804($a0)
sw $t8, 804($a1)		# write back into memory into B
lw $t8, 1068($a0)
sw $t8, 1068($a1)		# write back into memory into B
lw $t8, 1328($a0)
sw $t8, 1328($a1)		# write back into memory into B
lw $t8, 1580($a0)
sw $t8, 1580($a1)		# write back into memory into B
lw $t8, 1836($a0)
sw $t8, 1836($a1)		# write back into memory into B
lw $t8, 2092($a0)
sw $t8, 2092($a1)		# write back into memory into B

clean_right:
lw $t8, 4($a0)
sw $t8, 4($a1)		# write back into memory into B
lw $t8, 256($a0)
sw $t8, 256($a1)		# write back into memory into B
lw $t8, 512($a0)
sw $t8, 512($a1)		# write back into memory into B
lw $t8, 768($a0)
sw $t8, 768($a1)		# write back into memory into B
lw $t8, 1024($a0)
sw $t8, 1024($a1)		# write back into memory into B
lw $t8, 2068($a0)
sw $t8, 2068($a1)		# write back into memory into B
lw $t8, 2060($a0)
sw $t8, 2060($a1)		# write back into memory into B
lw $t8, 2068($a0)
sw $t8, 2068($a1)		# write back into memory into B
lw $t8, 1816($a0)
sw $t8, 1816($a1)		# write back into memory into B
lw $t8, 1560($a0)
sw $t8, 1560($a1)		# write back into memory into B

lw $t8, 1284($a0)
sw $t8, 1284($a1)		# write back into memory into B
lw $t8, 1544($a0)
sw $t8, 1544($a1)		# write back into memory into B
lw $t8, 1800($a0)
sw $t8, 1800($a1)		# write back into memory into B
lw $t8, 2060($a0)
sw $t8, 2060($a1)		# write back into memory into B
lw $t8, 2068($a0)
sw $t8, 2068($a1)		# write back into memory into B

lw $t8, 2084($a0)
sw $t8, 2084($a1)		# write back into memory into B
lw $t8, 1828($a0)
sw $t8, 1828($a1)		# write back into memory into B
lw $t8, 1572($a0)
sw $t8, 1572($a1)		# write back into memory into B
lw $t8, 812($a0)
sw $t8, 812($a1)		# write back into memory into B

jr $ra

clear_background:
lw $t8, 0($a0)
sw $t8, 0($a1)		# write back into memory into B
addi $a0, $a0, 4
addi $a1, $a1, 4
add $a2, $a2, -1
bgt $a2, $zero, clear_background # repeat while there are still pixels left
jr $ra


load_background:
lw $t8, 0($a1)
sw $t8, 0($a0)		# write back into memory into B
addi $a0, $a0, 4
addi $a1, $a1, 4
add $a2, $a2, -1
bgt $a2, $zero, load_background # repeat while there are still pixels left
jr $ra


# OBJECT CREATIONS
side_border:
sw $a2, 0($a0) # load brown color onto stack at specific position
addi $a0, $a0, 256 # go to next address to color
addi $t1, $t1, -1	# decrease number of uncolored pixel
bgt $t1, $a1, side_border # repeat while there are still pixels left
li $t1, 0x10000 # save 256*256 pixels 
jr $ra

platforms:
sw $a2, 0($a0) # load brown color onto stack at specific position
sw $a2, 256($a0) # load brown color onto stack at specific position
addi $a0, $a0, 4 # go to next address to color
addi $t1, $t1, -1	# decrease number of uncolored pixel
bgt $t1, $a1, platforms # repeat while there are still pixels left
li $t1, 0x10000 # save 256*256 pixels 
jr $ra

ladder_horizontal:
sw $a2, -256($a0) # load brown color onto stack at top step of ladder
sw $a2, 0($a0) # load brown color onto stack at top step of ladder
sw $a2, 768($a0) # bottom step of ladder
sw $a2, 1536($a0) # bottom step of ladder
addi $a0, $a0, 4 # go to next address to color
addi $t1, $t1, -1	# decrease number of uncolored pixel
bgt $t1, 65528, ladder_horizontal # repeat while there are still pixels left
li $t1, 0x10000 # save 256*256 pixels 
jr $ra

ladder_vertical:
sw $a2, 0($a1) # load brown color onto stack at specific position - left side of ladder
sw $a2, 28($a1) # right side of ladder
addi $a1, $a1, 256 # go to next address to color
addi $t1, $t1, -1	# decrease number of uncolored pixel
bgt $t1, 65525, ladder_vertical # repeat while there are still pixels left
li $t1, 0x10000 # save 256*256 pixels 
jr $ra

cookie_monster:
li $t9, 0x000000 
sw $t9, 0($a1)	#eyes
sw $t9, 4($a1)
sw $t9, 256($a1)
sw $t9, 260($a1)
sw $t9, 12($a1)
sw $t9, 16($a1)
sw $t9, 268($a1)
sw $t9, 272($a1)
sw $a2, 8($a1)	#head
sw $a2, 264($a1)
sw $a2, 512($a1)
sw $a2, 516($a1)
sw $a2, 520($a1)
sw $a2, 524($a1)
sw $a2, 528($a1)
sw $a2, 768($a1)
sw $a2, 772($a1)
sw $a2, 776($a1)
sw $a2, 780($a1)
sw $a2, 784($a1)
addi $a1, $a1, 1020
sw $a2, 0($a1)	#body
sw $a2, 4($a1)
sw $a2, -4($a1)
sw $a2, 28($a1)
sw $a2, 256($a1)
sw $a2, 260($a1)
sw $a2, 12($a1)
sw $a2, 16($a1)
sw $a2, 268($a1)
sw $a2, 272($a1)
sw $a2, 8($a1)	
sw $a2, 264($a1)
sw $a2, 512($a1)
sw $a2, 516($a1)
sw $a2, 520($a1)
sw $a2, 524($a1)
sw $a2, 528($a1)
sw $a2, 768($a1)
sw $a2, 772($a1)
sw $a2, 776($a1)
sw $a2, 780($a1)
sw $a2, 784($a1)
sw $a2, 20($a1)
sw $a2, 24($a1)
sw $a2, 276($a1)
sw $a2, 280($a1)
sw $a2, 532($a1)
sw $a2, 536($a1)
sw $a2, 792($a1)
sw $a2, 788($a1)
sw $a2, 1028($a1)
sw $a2, 1044($a1)
subi $a1, $a1, 1020

jr $ra

cookie:
sw $a1, 4($a0)
sw $a1, 8($a0)
sw $a2, 12($a0)
sw $a1, 256($a0) #cookie
sw $a2, 260($a0)
sw $a1, 264($a0)
sw $a1, 268($a0)
sw $a2, 272($a0)
sw $a1, 512($a0) #cookie
sw $a1, 516($a0)
sw $a1, 520($a0)
sw $a2, 524($a0)
sw $a1, 528($a0)
sw $a2, 768($a0) #cookie
sw $a1, 772($a0)
sw $a2, 776($a0)
sw $a1, 780($a0)
sw $a1, 784($a0)
sw $a1, 1028($a0)
sw $a1, 1032($a0)
sw $a2, 1036($a0)
jr $ra

player:
li $t9, 0xDBBE3D #yellow
li $t8, 0xE70007 #red
li $t7, 0x00AE00 #green
li $t6, 0xFF9000 #orange
li $t5, 0x000000 #black


sw $t9, 4($a1) #player hair
sw $t9, 8($a1) #player
sw $t9, 12($a1) #player
sw $t9, 16($a1) #player
sw $t9, 20($a1) #player
sw $t9, 24($a1) #player
sw $t9, 28($a1) #player

sw $t9, 256($a1) #player hair
sw $t9, 260($a1) #player
sw $t9, 264($a1) #player
sw $t9, 268($a1) #player
sw $t9, 272($a1) #player
sw $t9, 276($a1) #player
sw $t9, 280($a1) #player
sw $t9, 284($a1) #player
sw $t9, 288($a1) #player
sw $t9, 512($a1) #player
sw $t9, 516($a1) #player
sw $t9, 768($a1) #player
sw $t9, 772($a1) #player
sw $t9, 1024($a1) #player
sw $t9, 1028($a1) #player
sw $t9, 540($a1) #player
sw $t9, 544($a1) #player
sw $t9, 796($a1) #player
sw $t9, 800($a1) #player
sw $t9, 1052($a1) #player
sw $t9, 1056($a1) #player

sw $a2, 520($a1) #skin
sw $a2, 524($a1)
sw $a2, 528($a1)
sw $a2, 532($a1)
sw $a2, 536($a1)
sw $a2, 776($a1)
sw $a2, 780($a1)
sw $a2, 784($a1)
sw $a2, 788($a1)
sw $a2, 792($a1)
sw $a2, 1032($a1)
sw $a2, 1036($a1)
sw $a2, 1040($a1)
sw $a2, 1044($a1)
sw $a2, 1048($a1)

sw $t5, 780($a1) # eyes
sw $t5, 788($a1)

sw $t8, 1288($a1) #upper body
sw $t8, 1544($a1) #body
sw $t8, 1800($a1) #body
sw $t8, 1292($a1) #body
sw $t8, 1548($a1) #body
sw $t8, 1804($a1) #body
sw $t8, 1296($a1) #body
sw $t8, 1552($a1) #body
sw $t8, 1808($a1) #body
sw $t8, 1300($a1) #body
sw $t8, 1556($a1) #body
sw $t8, 1812($a1) #body
sw $t8, 1304($a1) #body
sw $t8, 1560($a1) #body
sw $t8, 1816($a1) #body

sw $t8, 1556($a1) #body legs
sw $t8, 1812($a1) #body
sw $t8, 2068($a1) #body
sw $t8, 1548($a1) #body
sw $t8, 1804($a1) #body
sw $t8, 2060($a1) #body

sw $t8, 1284($a1) #body arms
sw $t8, 1308($a1) #body

sw $t6, 1312($a1) #carrot
sw $t6, 1316($a1) #carrot
sw $t6, 1320($a1) #carrot
sw $t6, 1324($a1) #carrot
sw $t6, 1328($a1) #carrot
sw $t6, 1572($a1) #carrot
sw $t6, 1576($a1) #carrot
sw $t6, 1580($a1) #carrot
sw $t6, 1832($a1) #carrot
sw $t6, 1828($a1) #carrot
sw $t6, 1832($a1) #carrot
sw $t6, 1836($a1) #carrot
sw $t6, 2084($a1) #carrot
sw $t6, 2088($a1) #carrot
sw $t6, 2092($a1) #carrot
sw $t7, 1064($a1) #leaf
sw $t7, 804($a1) #leaf
sw $t7, 812($a1) #leaf
sw $t7, 1060($a1) #leaf
sw $t7, 1068($a1) #leaf

add $v1, $a1, $zero	#store address

jr $ra


END:
li $v0, 10	# exit the program
syscall











