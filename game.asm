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
# - Milestone 1,2 and 3
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Health/score - 2 marks
# 2. Fail condition - 1 mark
# 3. Win condition - 1 mark
# 4. Moving objects - enemy and final cookie - 2 marks
# 5. Different levels - 2 marks
# 6. Start menu - 1 mark
#
# Link to video demonstration for final submission:
# - https://play.library.utoronto.ca/watch/596b0575a48c6becebec50a99d902e45 

#
# Are you OK with us sharing the video with people outside course staff?
# - yes 
#
# Any additional information that the TA needs to know:
# My game: EAT YOUR VEGETABLES
## Description: Cookie monster has been eating a little too much cookies...
## 		He's gotten so obsessed that he's even eaten our friends when they tried to stop him!!
##		That's why we need your help CarrotPerson! Please save our friend!
##		Please use your carrot powers to eliminate all the cookies before cookie monster finds out!
## 		Remember! If he sees you, he will eat you!!
##		You only have 3 lives so be careful!
#
#####################################################################
.data
size:	.word 0x10000					# number of pixels
num_cookies: .word 5					# number of cookies
cookie_positions: .word 10600, 7724, 4960, 2176, 13520
FOUND: .word 0:5
B: .word 0:65536					# array to hold background
pink: .word 0xffc0cb					# pink colour for background
yellow: .word 0xDBBE3D
str6: .asciiz "e\n"
brown: .word 0x9a3f1d					# brown colour for platforms
blue: .word 0x4587C0					# blue colour for cookie monster
ladder_colour: .word 0x37969D				# ladder color
lives: .word 3						# number of lives
.text

.globl main
main:
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4
# - Unit height in pixels: 4
# - Display width in pixels: 256
# - Display hefight in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.eqv BASE_ADDRESS 0x10008000
.eqv COOKIE1 13512					# cookie locations
.eqv COOKIE2 10600		
.eqv COOKIE3 7724
.eqv COOKIE4 4960
.eqv COOKIE5 2176
.eqv INITIAL_PLAYER 12552				# player and monster start locations (different for different levels)
.eqv INITIAL_PLAYER_2 1300
.eqv INITIAL_MONSTER 1300
.eqv INITIAL_MONSTER_2 6932
.eqv INITIAL_MONSTER_3 9748


li $t0, BASE_ADDRESS 					# $t0 stores the base address for display
li $t1, 0x10000 					# save 256*256 pixels
li $s0, INITIAL_PLAYER					# player location at start
li $s6, INITIAL_MONSTER					# cookie monster location at start
li $t2, 184 						# this is the furthest the monster will move right
la $t3, lives						
lw $t3, 0($t3)						# number of lives throughout the game
li $s7, 1	
li $t4, 60						# current level
li $s4, COOKIE1						# moving cookie
li $s5, 0						# moving cookie distance - furthest 

jal set_background					# set the background - line 79
j start_page						# display the start page - line 1038

set_background:
	addi $sp, $sp, -4				# save return address
	sw $ra, 0($sp)

	li $a0, 0					# create the background using platform function (creates rectangles)
	add $a0, $a0, $t0
	li $a1, 0
	li $a2, 0xffc0cb
	jal platforms					# platform function - line 1634

	li $a0, 14848					# create floor		
	add $a0, $a0, $t0
	li $a1, 0
	li $a2,  0x9a3f1d
	jal platforms

	li $a0, 0					# upper border
	add $a0, $a0, $t0
	li $a1, 65472
	li $a2,  0x9a3f1d
	jal platforms
	li $a0, 256	
	add $a0, $a0, $t0
	li $a1, 65472
	li $a2,  0xffc0cb
	jal platforms
	li $a0, 1024					# calling platform again to make border less thick
	add $a0, $a0, $t0
	li $a1, 65472
	li $a2,  0x9a3f1d
	jal platforms
	li $a0, 1280	
	add $a0, $a0, $t0
	li $a1, 65472
	li $a2,  0xffc0cb
	jal platforms

	li $a0, 0					# side border
	add $a0, $a0, $t0
	li $a1, 65472
	li $a2,  0x9a3f1d
	jal side_border

	li $a0, 252					# side border
	add $a0, $a0, $t0
	li $a1, 65472
	li $a2,  0x9a3f1d
	jal side_border

	li $a2,  0x9a3f1d
	li $a0, 12052					# platform 1 - bottom most
	add $a0, $a0, $t0
	li $a1, 65480
	jal platforms

	li $a0, 9260					# platform 2 - second from bottom
	add $a0, $a0, $t0
	li $a1, 65495
	jal platforms

	li $a0, 6444					# platform 3 - 3rd from bottom
	add $a0, $a0, $t0
	li $a1, 65495
	jal platforms

	li $a0, 3604					# platform 4 - top most
	add $a0, $a0, $t0
	li $a1, 65480
	jal platforms

	lw $ra, 0($sp)					# get return address
	addi $sp, $sp, 4

	jr $ra


initialize_game:
	jal set_background
	li $a2, 0x37969D
	li $a0, 12416					#ladder 1
	subi $a1, $a0, 256
	add $a0, $a0, $t0
	jal ladder_horizontal
	add $a1, $a1, $t0
	jal ladder_vertical

	li $a0, 9540					#ladder 2
	subi $a1, $a0, 256
	add $a0, $a0, $t0
	jal ladder_horizontal
	add $a1, $a1, $t0
	jal ladder_vertical

	li $a0, 9632					#ladder 3
	subi $a1, $a0, 256
	add $a0, $a0, $t0
	jal ladder_horizontal
	add $a1, $a1, $t0
	jal ladder_vertical

	li $a0, 6776					#ladder 4
	subi $a1, $a0, 256
	add $a0, $a0, $t0
	jal ladder_horizontal
	add $a1, $a1, $t0
	jal ladder_vertical

	li $a0, 4000					#ladder 5
	subi $a1, $a0, 256
	add $a0, $a0, $t0
	jal ladder_horizontal
	add $a1, $a1, $t0
	jal ladder_vertical
	
	li $a1, 0xA77C38
	li $a2, 0x5D1A0F

	li $a0, COOKIE1  				# cookie 1
	addi $a0, $a0, BASE_ADDRESS
	jal cookie

	li $a0, COOKIE2  				# cookie 2
	addi $a0, $a0, BASE_ADDRESS
	jal cookie

	li $a0, COOKIE3  				# cookie 3
	addi $a0, $a0, BASE_ADDRESS
	jal cookie

	li $a0, COOKIE4  				# cookie 4
	addi $a0, $a0, BASE_ADDRESS
	jal cookie

	li $a0, COOKIE5  				# cookie 5
	addi $a0, $a0, BASE_ADDRESS
	jal cookie
	
	
	li $a1, 464					# mini carrot life 1
	addi $a1, $a1, BASE_ADDRESS
	jal mini_carrot

	li $a1, 476					# mini carrot life 2
	addi $a1, $a1, BASE_ADDRESS
	jal mini_carrot

	li $a1, 488					# mini carrot life 3
	addi $a1, $a1, BASE_ADDRESS
	jal mini_carrot
	
	add $a1, $zero, $t0				# display level number
	addi $a1, $a1, 15216	
	jal level_display

							# store the original layout on stack
	la $a0, B					# $a0 holds address of array B
	li $a1, BASE_ADDRESS 				# $t0 stores the base address for display
	li $a2, 0x10000 				# save 256*256 pixels

	
	jal load_background				# save background array
	

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
	
	j game_loop

level_three_initialize_game:
	jal set_background
	li $a2, 0x37969D
	li $a0, 12416					#ladder 1
	subi $a1, $a0, 256
	add $a0, $a0, $t0
	jal ladder_horizontal
	add $a1, $a1, $t0
	jal ladder_vertical

	li $a0, 9540					#ladder 2
	subi $a1, $a0, 256
	add $a0, $a0, $t0
	jal ladder_horizontal
	add $a1, $a1, $t0
	jal ladder_vertical

	li $a0, 6776					#ladder 3
	subi $a1, $a0, 256
	add $a0, $a0, $t0
	jal ladder_horizontal
	add $a1, $a1, $t0
	jal ladder_vertical

	li $a0, 4000					#ladder 4
	subi $a1, $a0, 256
	add $a0, $a0, $t0
	jal ladder_horizontal
	add $a1, $a1, $t0
	jal ladder_vertical
	
	
	li $a1, 464					# mini carrot life 1
	addi $a1, $a1, BASE_ADDRESS
	jal mini_carrot

	li $a1, 476					# mini carrot life 2
	addi $a1, $a1, BASE_ADDRESS
	jal mini_carrot

	li $a1, 488					# mini carrot life 3
	addi $a1, $a1, BASE_ADDRESS
	jal mini_carrot
	
	add $a1, $zero, $t0				# display level number
	addi $a1, $a1, 15216	
	jal level_display

							# store the original layout on stack
	la $a0, B					# $a0 holds address of array B
	li $a1, BASE_ADDRESS 				# $t0 stores the base address for display
	li $a2, 0x10000 				# save 256*256 pixels

	
	jal load_background				# save background array
	

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
	
	li $a1, 0xA77C38
	li $a2, 0x5D1A0F  
	add $a0, $s4, $zero				# moving cookie
	addi $a0, $a0, BASE_ADDRESS
	jal cookie
	
	
	j game_loop

game_loop:
	jal move_monster				# move the monster
	jal check_monster_player_location		# check if the monster is touching the player
	jal remove_carrot
	beq $s7, 3, level_three_round			# if we should be doing level three stuff
	jal cookie_one					# check if the player is touching a cookie and if so, add to the display
	jal cookie_two
	jal cookie_three
	jal cookie_four
	jal cookie_five
	jal check_winner				# check if all 5 cookies have been earned
level_three_round:
	bne $s7, 3, all_levels
	jal move_cookie
	jal check_level_three_winner			# check if the player won level three - the whole game
	
all_levels:
	li $t9, 0xffff0000				# get keypress from keyboard input
	lw $t8, 0($t9)
	beq $t8, 1, keypress
	j game_loop

keypress:	
	li	$v0, 32					# syscall sleep
	addi	$a0, $zero, 60				# 60 ms
	syscall
	
	lw $t5, 4($t9)
	beq	$t5, 100, d_pressed			# if key press = 'd' branch to moveright
	beq	$t5, 97, a_pressed			# else if key press = 'a' branch to moveLeft
	beq	$t5, 119, w_pressed			# if key press = 'w' branch to moveUp
	beq	$t5, 115, s_pressed			# else if key press = 's' branch to moveDown
	beq	$t5, 112, p_pressed			# restart game if key press = 'p'
	j next_move
	
l_pressed:
	# jal level_two
	 #jal level_three
	jal initialize_game				# l from start screen
	
w_pressed:
	
	addi  $s3, $zero, -256				# -256 moves player up by 1 pixel
	add $a3, $s0, $s3
	la $a2, B
	la $t8, brown
	lw $t8, 0($t8)					# brown color
	add $a1, $t8, $zero
	jal check_above					# check if there is a platform above
	beq $v1, 1, next_move				# if there is a platform above (check_above returns 1), then do nothing and go to next move
	
	la $a0, B					# $a0 holds address of array B - background array
	li $a1, BASE_ADDRESS 				# $t0 stores the base address for display
	add $a1, $a1, $s0  				# $a1 gets players position on display
	add $a0, $a0, $s0  				# $a0 gets players position in background array
	add $s0, $s3, $s0				# update player position

	jal clean_up					# recolor pixels player was just on to background color
							# initial player creation onto next spot after moving
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player
	
	j next_move 	

s_pressed:
	addi $s3, $zero, 256				# 256 moves player down by 1 pixel
		
	add $a3, $s0, $s3
	la $a2, B
	la $t8, brown
	lw $t8, 0($t8)					# brown color
	add $a1, $t8, $zero
	jal check_down
	beq $v1, 1, next_move
	
	la $a0, B					# $a0 holds address of array B - background array
	li $a1, BASE_ADDRESS 				# $t0 stores the base address for display
	add $a1, $a1, $s0  				# $a1 gets players position on display
	add $a0, $a0, $s0  				# $a0 gets players position in background array
	add $s0, $s3, $s0				# update player position

	jal clean_down					# recolor old spot back to background colors
	
							# create player one downwards
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player

	
	j next_move 
	
a_pressed:
	addi $s3, $zero, -4				# make player go one back
	
		
	add $a3, $s0, $s3
	la $a2, B
	la $t8, brown
	lw $t8, 0($t8)					# brown color
	add $a1, $t8, $zero
	jal check_left
	beq $v1, 1, next_move
	
	la $a0, B					# $a0 holds address of array B - background array
	li $a1, BASE_ADDRESS 				# $t0 stores the base address for display
	add $a1, $a1, $s0  				# $a1 gets players position on display
	add $a0, $a0, $s0  				# $a0 gets players position in background array
	add $s0, $s3, $s0				# update player position

	
	jal clean_left					# change pixels back to background color
							# create player 1 to left
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player

	
	j next_move 
	
d_pressed:
	addi  $s3, $zero, 4				# make player be 1 pixel to the right

	
	add $a3, $s0, $s3
	la $a2, B
	la $t8, brown
	lw $t8, 0($t8)					# brown color
	add $a1, $t8, $zero
	jal check_right
	beq $v1, 1, next_move
	
	la $a0, B					# $a0 holds address of array B - background array
	li $a1, BASE_ADDRESS 				# $t0 stores the base address for display
	add $a1, $a1, $s0  				# $a1 gets players position on display
	add $a0, $a0, $s0  				# $a0 gets players position in background array
	add $s0, $s3, $s0				# update player position

	
	jal clean_right					# clean pixels player used to be on to background color
							# create player 1 to the right
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player
	
	j next_move 
	
p_pressed:
							
	la $a0, B					# $a0 holds address of array B
	li $a1, BASE_ADDRESS 				# base address
	li $a2, 0x10000 				# save 256*256 pixels

	jal clear_background				# set background back to plain
	addi $s0, $zero, 12544

							# put player back
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player

	j main						# start over


next_move:
	jal check_monster_player_location		# do next move after checking if player earned a cookie or touched monster
	jal check_gravity_needed
	li $t9, COOKIE1
	jal check_cookie_player_location
	li $t9, COOKIE2
	jal check_cookie_player_location
	li $t9, COOKIE3
	jal check_cookie_player_location
	li $t9, COOKIE4
	jal check_cookie_player_location
	li $t9, COOKIE5
	jal check_cookie_player_location
	j 	game_loop				# loop back to beginning on full game loop


check_cookie_player_location:				# checks if player and cookie collided anywhere - player earns point
	addi $t7, $t9, 16				# get points to compare in cookie and player - if same location, then check if cookie already found before
	addi $t8, $s0, 768
	beq $t8, $t7, is_it_found
	addi $t8, $s0, 820
	beq $t8, $t9, is_it_found
	jr $ra


is_it_found:
	add $a0, $zero, $t9				# if the pixel is background color and color of player hair, then the cookie has already been earned
	addi $a0, $a0, BASE_ADDRESS
	addi $a1, $zero, BASE_ADDRESS
	lw $t7, 8($a0)
	la $a2, pink
	lw $a2, 0($a2)
	bne $a2, $t7, case_two
	jr $ra
case_two:
	la $a2, yellow
	lw $a2, 0($a2)
	bne $a2, $t7, found_a_cookie
	jr $ra
		
found_a_cookie:						
	la $a0, B					# background array
	li $a1, BASE_ADDRESS 				# $t0 stores the base address for display
	li $a2, 0x10000 				# save 256*256 pixels
	jal clear_background
	la $a1, pink					# get pink
	la $a2, pink
	lw $a1, 0($a1)					# color old spot with cookie on it to a pink cookie over the old cookie
	lw $a2, 0($a2)
	add $a0, $zero, $t9
	addi $a0, $a0, BASE_ADDRESS
	jal cookie
	la $a0, B
	li $a1, BASE_ADDRESS 				# $t0 stores the base address for display
	li $a2, 0x10000 				# save 256*256 pixels
	jal load_background				# refresh background after changes
							# create player over refreshed background
	li $a2, 0xFFE6C4				
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player
	j end_loop

end_loop:						# go back to looping
	j game_loop

check_winner:						# check if all 5 cookies have been earned 
	li $t9, COOKIE1					# if cookie 1 location is now pink, then go to cookie 2 check
	li $a3, 0
	add $a0, $zero, $t9
	addi $a0, $a0, BASE_ADDRESS
	addi $a1, $zero, BASE_ADDRESS
	lw $t7, 4($a0)
	la $a2, pink
	lw $a2, 0($a2)
	bne $a2, $t7, continue
	li $t9, COOKIE2					# if cookie 2 location is now pink, then go to cookie 3 check
	add $a0, $zero, $t9
	addi $a0, $a0, BASE_ADDRESS
	lw $t7, 4($a0)
	bne $a2, $t7, continue
	li $t9, COOKIE3					# if cookie 3 location is now pink, then go to cookie 4 check
	add $a0, $zero, $t9
	addi $a0, $a0, BASE_ADDRESS
	lw $t7, 4($a0)
	bne $a2, $t7, continue	
	li $t9, COOKIE4					# if cookie 4 location is now pink, then go to cookie 5 check
	add $a0, $zero, $t9
	addi $a0, $a0, BASE_ADDRESS
	lw $t7, 4($a0)
	bne $a2, $t7, continue
	li $t9, COOKIE5					# if cookie 5 location is now pink, then winner or next level
	add $a0, $zero, $t9
	addi $a0, $a0, BASE_ADDRESS
	lw $t7, 4($a0)
	bne $a2, $t7, continue
	li $a0, 0					# background
	addi $a0, $a0, BASE_ADDRESS
	li $t1, 0x10000 				# save 256*256 pixels
	li $a1, 0
	li $a2, 0xffc0cb
	beq $s7, 1, level_two
	beq $s7, 2, level_three
	j winner_page
	
level_two:						# next level - set values to what u want it to be for level 2
	li $s7, 2
	li $t0, BASE_ADDRESS 				# $t0 stores the base address for display
	li $t1, 0x10000 				# save 256*256 pixels
	li $s0, INITIAL_PLAYER			
	li $s6, INITIAL_MONSTER_2			# new monster location
	li $t2, 184 						
	la $t3, lives						
	lw $t3, 0($t3)	
	li $t4, 60		
	jal set_background				# reset
	j initialize_game		
	
level_three:						# next level - set values to what u want it to be this level
	li $s7, 3
	li $t0, BASE_ADDRESS 					# $t0 stores the base address for display
	li $t1, 0x10000 					# save 256*256 pixels
	li $s0, INITIAL_PLAYER_2				# new player address
	li $s6, INITIAL_MONSTER_3				# new monster address				# get location of cookies throughout the game
	li $t2, 184 						# this is the furthest the monster will move right
	la $t3, lives						
	lw $t3, 0($t3)	
	li $t4, 15	
	li $s4, COOKIE1
	jal set_background
	j level_three_initialize_game				# reset to start of level 3


cookie_one:						# check if cookie 1 is already found or not and if it is not, then add a point
	li $t9, COOKIE1
	li $a3, 0
	add $a0, $zero, $t9
	addi $a0, $a0, BASE_ADDRESS
	addi $a1, $zero, BASE_ADDRESS
	lw $t7, 4($a0)
	la $a2, pink
	lw $a2, 0($a2)
	bne $a2, $t7, continue				# check if the cookie is already found
	addi $a0, $zero, BASE_ADDRESS
	addi $a0, $a0, 264
	j mini_cookie
	jr $ra
cookie_two:						# check if cookie is already found or not and if it is not, then add a point
	li $t9, COOKIE2
	li $a3, 0
	add $a0, $zero, $t9
	addi $a0, $a0, BASE_ADDRESS
	addi $a1, $zero, BASE_ADDRESS
	lw $t7, 4($a0)
	la $a2, pink
	lw $a2, 0($a2)
	bne $a2, $t7, continue				# check if the cookie is already found
	addi $a0, $zero, BASE_ADDRESS
	addi $a0, $a0, 276
	j mini_cookie
	jr $ra
cookie_three:						
	li $t9, COOKIE3					# check if cookie is already found or not and if it is not, then add a point
	li $a3, 0
	add $a0, $zero, $t9
	addi $a0, $a0, BASE_ADDRESS
	addi $a1, $zero, BASE_ADDRESS
	lw $t7, 4($a0)
	la $a2, pink
	lw $a2, 0($a2)
	bne $a2, $t7, continue				# check if the cookie is already found
	addi $a0, $zero, BASE_ADDRESS
	addi $a0, $a0, 288
	j mini_cookie
	jr $ra
cookie_four:						# check if cookie is already found or not and if it is not, then add a point
	li $t9, COOKIE4
	li $a3, 0
	add $a0, $zero, $t9
	addi $a0, $a0, BASE_ADDRESS
	addi $a1, $zero, BASE_ADDRESS
	lw $t7, 4($a0)
	la $a2, pink
	lw $a2, 0($a2)
	bne $a2, $t7, continue				# check if the cookie is already found
	addi $a0, $zero, BASE_ADDRESS
	addi $a0, $a0, 300
	j mini_cookie
	jr $ra	
cookie_five:						# check if cookie is already found or not and if it is not, then add a point
	li $t9, COOKIE5	
	li $a3, 0
	add $a0, $zero, $t9
	addi $a0, $a0, BASE_ADDRESS
	addi $a1, $zero, BASE_ADDRESS
	lw $t7, 4($a0)
	la $a2, pink		
	lw $a2, 0($a2)
	bne $a2, $t7, continue				 # check if the cookie is already found
	addi $a0, $zero, BASE_ADDRESS
	addi $a0, $a0, 312
	j mini_cookie
	jr $ra
	
check_gravity_needed:					# check if the player is on a platform - if not then they need gravity to fall down
	la $a1, pink
	lw $a1, 0($a1)
	la $a2, B
	la $a3, ladder_colour
	lw $a3, 0($a3)
	add $t9, $a2, $s0
	
	lw $t8, 0($t9)
	beq $a3, $t8, continue
	lw $t8, 32($t9)
	beq $a3, $t8, continue
	lw $t8, 2064($t9)
	beq $a3, $t8, continue
	lw $t8, 1808($t9)
	beq $a3, $t8, continue
	lw $t8, 1552($t9)
	beq $a3, $t8, continue
	
	lw $t8, 2316($t9)
	beq $a1, $t8, first_leg_off
	jr $ra

continue:						# skip code and go to return address stored
	jr $ra

first_leg_off:						# if the first leg is off, check if second leg is also in air
	lw $t8, 2324($t9)				# only fall if both feet in the air 
	beq $a1, $t8, gravity
	j continue

gravity:
	li	$v0, 32					# syscall sleep
	addi	$a0, $zero, 60				# 60 ms
	syscall
	addi $s3, $zero, 256				# s3 = make player be 256 lower
		
	add $a3, $s0, $s3
	la $a2, B
	la $t8, brown
	lw $t8, 0($t8)					# brown color
	add $a1, $t8, $zero
	jal check_down					# check if falling and if not then go to next move
	beq $v1, 1, next_move
	
	la $a0, B					# $a0 holds address of array B
	li $a1, BASE_ADDRESS 				
	add $a1, $a1, $s0  				
	add $a0, $a0, $s0  				
	add $s0, $s3, $s0					

	jal clean_down					# clean pixels for going down
	
							# player creation one step down
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player
	j next_move

check_level_three_winner:				# check if the player beat level three
							
	beq $s4, $s0, check_winner			# check different points to see if cookie and player at same location
	add $t8, $zero, $s4
	addi $t7, $s0, 768
	addi $t8, $t8, 4
	beq $t8, $t7, check_winner
	addi $t8, $t8, 4
	beq $t8, $t7, check_winner
	addi $t8, $t8, 4
	beq $t8, $t7, check_winner
	addi $t8, $t8, 4
	beq $t8, $t7, check_winner
	addi $t8, $t8, 4
	beq $t8, $t7, check_winner
							# head top
	add $t8, $zero, $s4
	addi $t7, $s0, 768
	addi $t7, $t7, 4
	beq $t8, $t7, check_winner
	addi $t7, $t7, 4
	beq $t8, $t7, check_winner
	addi $t7, $t7, 4
	beq $t8, $t7, check_winner
	addi $t7, $t7, 4
	beq $t8, $t7, check_winner
	addi $t7, $t7, 4
	beq $t8, $t7, check_winner
							# approaching her legs
	add $t8, $zero, $s4
	add $t7, $zero, $s0
	addi $t7, $t7, 2060				# two human legs address
	addi $t6, $t8, 2068
	beq $t8, $t7, check_winner			# check if player is touching feet
	beq $t6, $t8, check_winner
	addi $t7, $t7, 4
	beq $t8, $t7, check_winner
	beq $t6, $t8, check_winner
	addi $t7, $t7, 4
	beq $t8, $t7, check_winner
	beq $t6, $t8, check_winner
	addi $t7, $t7, 4
	beq $t8, $t7, check_winner
	beq $t6, $t8, check_winner
	addi $t7, $t7, 4
	beq $t8, $t7, check_winner
	beq $t6, $t8, check_winner
	addi $t7, $t7, 4
	beq $t8, $t7, check_winner
	beq $t6, $t8, check_winner
	addi $t7, $t7, 4
	beq $t8, $t7, check_winner
	beq $t6, $t8, check_winner
							# along right side of cookie
	beq $s4, $s0, check_winner
	add $t8, $zero, $s4
	addi $t8, $t8, 16
	add $t7, $zero, $s0
	addi $t8, $t8, 256
	beq $t8, $t7, check_winner
	addi $t8, $t8, 256
	beq $t8, $t7, check_winner
	addi $t8, $t8, 256
	beq $t8, $t7, check_winner
	addi $t8, $t8, 256
	beq $t8, $t7, check_winner
							# along left side of cookie
	beq $s4, $s0, check_winner
	add $t8, $zero, $s4
	add $t7, $zero, $s0
	addi $t8, $t8, 256
	beq $t8, $t7, check_winner
	addi $t8, $t8, 256
	beq $t8, $t7, check_winner
	addi $t8, $t8, 256
	beq $t8, $t7, check_winner
	addi $t8, $t8, 256
	beq $t8, $t7, check_winner
	
	jr $ra

take_a_life:
	li $a1, BASE_ADDRESS 				# $t0 stores the base address for display
	li $t8, 0xA77C38
	sw $t8, 16($a1)					# write back into memory into B
	j decrease_lives				# send values to decrease lives

decrease_lives:
	addi $t3, $t3, -1				# remove a carrot from display
	jal remove_carrot
	beqz $t3, your_dead				# if zero carrots, your dead
	j send_to_start					# send back to start for losing a life

your_dead:
	beq $s7, 3, your_dead_part_two
	jal cookie_one					# check if the player is touching a cookie and if so, add to the display of end screen
	jal cookie_two
	jal cookie_three
	jal cookie_four
	jal cookie_five
your_dead_part_two:
	li $a0, 1280					# background
	addi $a0, $a0, BASE_ADDRESS
	li $t1, 0x10000 				# save 256*256 pixels
	li $a1, 1280
	li $a2, 0xffc0cb
	j end_scene


remove_carrot:						# check numbr of carrots removed and removes carrot 
	li $a1, BASE_ADDRESS
	la $a0, B
	la $t8, pink
	lw $t8, 0($t8)
	beq $t3, 3, continue
	beq $t3, 2, remove_carrot_one
	beq $t3, 1, remove_carrot_two
	sw $t8, 488($a0)
	sw $t8, 744($a0)
	sw $t8, 1000($a0)
	

remove_carrot_two:
	sw $t8, 476($a0)				# if 2nd carrot has to be removed
	sw $t8, 732($a0)
	sw $t8, 988($a0)

remove_carrot_one:					# if 1st carrot has to be removed
	sw $t8, 464($a0)
	sw $t8, 720($a0)
	sw $t8, 976($a0)
	jr $ra

send_to_start:
							# store the original layout on stack
	la $a0, B					# $a0 holds address of array B
	li $a1, BASE_ADDRESS 				
	li $a2, 0x10000 				# save 256*256 pixels

	jal clear_background				# clear background and resave background and draw her again
	beq $s7, 3, reset_two
	addi $s0, $zero, INITIAL_PLAYER
		# initial player creation
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player

	j next_move					# next move

reset_two:						# reset at a different location
	addi $s0, $zero, INITIAL_PLAYER_2
							# initial player creation for new level
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	addi $a1, $a1, BASE_ADDRESS
	jal player

	j next_move

move_cookie:
	li	$v0, 32					# syscall sleep
	add	$a0, $zero, $t4				# 60 ms
	syscall
	
	addi $sp, $sp, -4				# move cookie left when val in s5 < 0 and right when val is > 0 
	sw $ra, 0($sp)					# reset to 184 for -184 reached
	bgtz $s5, cookie_right
	blez $s5, cookie_left
	
cookie_right:
	la $a0, B					# $a0 holds address of array B
	li $a1, BASE_ADDRESS				# store cookie address
	add $a1, $a1, $s4  			
	add $a0, $a0, $s4 				 
	
	jal clean_cookie_left				# change pixels it was on to background color
	
	addi $s4, $s4, 4
	addi $s5, $s5, -4	

	li $a1, 0xA77C38				# redraw cookie 
	li $a2, 0x5D1A0F  
	add $a0, $s4, $zero				
	addi $a0, $a0, BASE_ADDRESS
	jal cookie
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


cookie_left:
	la $a0, B					
	li $a1, BASE_ADDRESS 				
	add $a1, $a1, $s4  				
	add $a0, $a0, $s4  				
		
	jal clean_cookie_right				# recolor pixels to background color
			
	addi $s4, $s4, -4
	addi $s5, $s5, -4	

	li $a1, 0xA77C38				# draw cookie one to the left
	li $a2, 0x5D1A0F  
	add $a0, $s4, $zero			
	addi $a0, $a0, BASE_ADDRESS	
	jal cookie
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	beq $s5, -184, reset_cookie_movement

	jr $ra
	
reset_cookie_movement:					# reset cookie movement counter to 184
	addi $s5, $zero, 184
	jr $ra

clean_cookie_right:
	lw $t8, 12($a0)					# clean old spot that cookie was in along its right side points
	sw $t8, 12($a1)					
	lw $t8, 272($a0)
	sw $t8, 272($a1)				
	lw $t8, 528($a0)
	sw $t8, 528($a1)				
	lw $t8, 784($a0)
	sw $t8, 784($a1)				
	lw $t8, 1036($a0)	
	sw $t8, 1036($a1)				
	jr $ra

clean_cookie_left:
	lw $t8, 4($a0)					# clean old spot that cookie was in along its left side points
	sw $t8, 4($a1)					
	lw $t8, 256($a0)
	sw $t8, 256($a1)				
	lw $t8, 512($a0)
	sw $t8, 512($a1)				 
	lw $t8, 768($a0)
	sw $t8, 768($a1)				
	lw $t8, 1028($a0)
	sw $t8, 1028($a1)				
	jr $ra


check_monster_player_location:				# Check if the monster and player are at the same location along various points around monster and player
							# on top of her
	beq $s6, $s0, take_a_life
	add $t8, $zero, $s6
	add $t7, $zero, $s0
	addi $t8, $t8, 4
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 4
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 4
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 4
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 4
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 4
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 4
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 4
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 4
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 4
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 4
	beq $t8, $t7, take_a_life
							# she is on top of him
	add $t8, $zero, $s6
	add $t7, $zero, $s0
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
							# approaching her headtop
	add $t8, $zero, $s6
	add $t7, $zero, $s0
	addi $t8, $t8, 2048				# check if 2 monster legs touch her
	addi $t6, $t8, 16
	beq $t8, $t7, take_a_life
	beq $t6, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t7, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t7, take_a_life
							# approaching her legs
	add $t8, $zero, $s6
	add $t7, $zero, $s0
	addi $t7, $t7, 2060 				# two human legs
	addi $t6, $t8, 2068
	beq $t8, $t7, take_a_life
	beq $t6, $t8, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t8, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t8, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t8, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t8, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t8, take_a_life
	addi $t7, $t7, 4
	beq $t8, $t7, take_a_life
	beq $t6, $t8, take_a_life
							# along right side of monster
	beq $s6, $s0, take_a_life
	add $t8, $zero, $s6
	add $t7, $zero, $s0
	addi $t8, $t8, 288
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
							# along left side of monster
	beq $s6, $s0, take_a_life		
	add $t8, $zero, $s6
	add $t7, $zero, $s0
	addi $t8, $t8, -8
	addi $t7, $t7, -44
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	addi $t8, $t8, 256
	beq $t8, $t7, take_a_life
	
	jr $ra





move_monster:
	li	$v0, 32					# syscall sleep
	add	$a0, $zero, $t4				# 60 ms
	syscall
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	bgtz $t2, monster_right				# if value in t2 is greater than zero move right, or else move left
	blez $t2, monster_left				# reset value to 184 if reached -184


monster_right:
	la $a0, B					# $a0 holds address of array B
	li $a1, BASE_ADDRESS 				# $a1 stores monster address
	add $a1, $a1, $s6  				
	add $a0, $a0, $s6  				# $a0 holds monster address in background array
	
	jal clean_monster_right				# if monster goes right, then clean pixels it was just on
	
	addi $s6, $s6, 4				# move monster position by one and decrease monster movement counter
	addi $t2, $t2, -4	
							# cookie monster creation to the right by one 
	li $a2, 0x4587C0
	add $a1, $s6, $zero
	add $a1, $a1, $t0
	jal cookie_monster
	addi $a0, $a1, 284
	li $a1, 0xA77C38
	li $a2, 0x5D1A0F
	jal cookie
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra


monster_left:
	la $a0, B					# $a0 holds address of array B
	li $a1, BASE_ADDRESS 				
	add $a1, $a1, $s6  				# $a1 stores monster address
	add $a0, $a0, $s6  				# $a0 holds monster address in background array

	jal clean_monster_left				# clean pixels monster was just on
	
	addi $s6, $s6, -4				# decrease monster movement counter and position of monster
	addi $t2, $t2, -4		
							# cookie monster creation to the left
	li $a2, 0x4587C0
	add $a1, $s6, $zero
	add $a1, $a1, $t0
	jal cookie_monster
	addi $a0, $a1, 284
	li $a1, 0xA77C38
	li $a2, 0x5D1A0F
	jal cookie
	lw $ra, 0($sp)

	addi $sp, $sp, 4
	beq $t2, -184, reset_monster_movement

	jr $ra

reset_monster_movement:
	addi $t2, $zero, 184				# reset monster movement counter to 184
	jr $ra

clean_monster_left:
	lw $t8, 16($a0)					# clean along all the points on the monsters left side 
	sw $t8, 16($a1)					
	lw $t8, 272($a0)
	sw $t8, 272($a1)		
	lw $t8, 296($a0)
	sw $t8, 296($a1)		
	lw $t8, 528($a0)
	sw $t8, 528($a1)		
	lw $t8, 556($a0)
	sw $t8, 556($a1)		
	lw $t8, 784($a0)
	sw $t8, 784($a1)		
	lw $t8, 812($a0)
	sw $t8, 812($a1)	
	lw $t8, 1068($a0)
	sw $t8, 1068($a1)		
	lw $t8, 1320($a0)
	sw $t8, 1320($a1)		
	lw $t8, 1300($a0)
	sw $t8, 1300($a1)		
	lw $t8, 1556($a0)
	sw $t8, 1556($a1)		
	lw $t8, 1812($a0)
	sw $t8, 1812($a1)		
	lw $t8, 2064($a0)
	sw $t8, 2064($a1)		
	lw $t8, 2048($a0)
	sw $t8, 2048($a1)		
	jr $ra

clean_monster_right:					# clean along all the points on the monsters right side 
	lw $t8, 0($a0)
	sw $t8, 0($a1)		
	lw $t8, 256($a0)
	sw $t8, 256($a1)		
	lw $t8, 288($a0)
	sw $t8, 288($a1)	
	lw $t8, 512($a0)
	sw $t8, 512($a1)		
	lw $t8, 540($a0)
	sw $t8, 540($a1)		
	lw $t8, 768($a0)
	sw $t8, 768($a1)		
	lw $t8, 1016($a0)
	sw $t8, 1016($a1)		
	lw $t8, 796($a0)
	sw $t8, 796($a1)		
	lw $t8, 1312($a0)
	sw $t8, 1312($a1)		
	lw $t8, 1276($a0)
	sw $t8, 1276($a1)		
	lw $t8, 1532($a0)
	sw $t8, 1532($a1)		
	lw $t8, 1788($a0)
	sw $t8, 1788($a1)		
	lw $t8, 2048($a0)
	sw $t8, 2048($a1)		
	lw $t8, 2064($a0)
	sw $t8, 2064($a1)		

	jr $ra

check_above:						# check above player's head to see if the girl touched a platform
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

check_left:						# check left of player to see if the girl touched a platform
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

check_right:						# check right of player to see if the girl touched a platform
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

check_down:
	add $t8, $a2, $a3				# check down of player to see if the girl touched a platform - her feet
	lw $t8, 2060($t8)
	beq $t8, $a1, yes_platform
	add $t8, $a2, $a3
	lw $t8, 2068($t8)
	beq $t8, $a1, yes_platform
	addi $v1, $zero, 0
	jr $ra

yes_platform:
	addi $v1, $zero, 1				# if platform then send signal to say this and do not move
	jr $ra

clean_up:
	lw $t8, 1024($a0)				# recolor pixels above players head to background color
	sw $t8, 1024($a1)				
	lw $t8, 1284($a0)
	sw $t8, 1284($a1)		
	lw $t8, 1800($a0)
	sw $t8, 1800($a1)		
	lw $t8, 2060($a0)
	sw $t8, 2060($a1)		
	lw $t8, 1808($a0)
	sw $t8, 1808($a1)		
	lw $t8, 2068($a0)
	sw $t8, 2068($a1)		
	lw $t8, 1816($a0)
	sw $t8, 1816($a1)	
	lw $t8, 1308($a0)
	sw $t8, 1308($a1)	
	lw $t8, 1312($a0)
	sw $t8, 1312($a1)		
	lw $t8, 2084($a0)
	sw $t8, 2084($a1)		
	lw $t8, 2088($a0)
	sw $t8, 2088($a1)		
	lw $t8, 2092($a0)
	sw $t8, 2092($a1)	
	lw $t8, 1328($a0)
	sw $t8, 1328($a1)		

	jr $ra

clean_down:						# recolor pixels below player to background color
	lw $t8, 256($a0)
	sw $t8, 256($a1)		
	lw $t8, 4($a0)
	sw $t8, 4($a1)		
	lw $t8, 8($a0)
	sw $t8, 8($a1)		
	lw $t8, 12($a0)
	sw $t8, 12($a1)		
	lw $t8, 16($a0)
	sw $t8, 16($a1)		
	lw $t8, 20($a0)
	sw $t8, 20($a1)		
	lw $t8, 24($a0)
	sw $t8, 24($a1)		
	lw $t8, 28($a0)
	sw $t8, 28($a1)		
	lw $t8, 288($a0)
	sw $t8, 288($a1)		
	lw $t8, 548($a0)
	sw $t8, 548($a1)		
	lw $t8, 556($a0)
	sw $t8, 556($a1)		
	lw $t8, 1064($a0)
	sw $t8, 1064($a1)		
	lw $t8, 812($a0)
	sw $t8, 812($a1)		
	lw $t8, 804($a0)
	sw $t8, 804($a1)		
	lw $t8, 1328($a0)
	sw $t8, 1328($a1)	
	jr $ra

clean_left:						# recolor pixels left of player to background color
	lw $t8, 28($a0)
	sw $t8, 28($a1)		
	lw $t8, 288($a0)
	sw $t8, 288($a1)		
	lw $t8, 544($a0)
	sw $t8, 544($a1)		
	lw $t8, 812($a0)
	sw $t8, 812($a1)		
	lw $t8, 804($a0)
	sw $t8, 804($a1)		
	lw $t8, 1068($a0)
	sw $t8, 1068($a1)		
	lw $t8, 1328($a0)
	sw $t8, 1328($a1)		
	lw $t8, 1580($a0)
	sw $t8, 1580($a1)		
	lw $t8, 1836($a0)
	sw $t8, 1836($a1)		
	lw $t8, 2092($a0)
	sw $t8, 2092($a1)		

clean_right:						# recolor pixels right of player to background color
	lw $t8, 4($a0)
 	sw $t8, 4($a1)			
	lw $t8, 256($a0)
	sw $t8, 256($a1)		
	lw $t8, 512($a0)
	sw $t8, 512($a1)		
	lw $t8, 768($a0)
	sw $t8, 768($a1)		
	lw $t8, 1024($a0)
	sw $t8, 1024($a1)		
	lw $t8, 2068($a0)
	sw $t8, 2068($a1)		
	lw $t8, 2060($a0)
	sw $t8, 2060($a1)		
	lw $t8, 2068($a0)
	sw $t8, 2068($a1)		
	lw $t8, 1816($a0)
	sw $t8, 1816($a1)		
	lw $t8, 1560($a0)
	sw $t8, 1560($a1)		

	lw $t8, 1284($a0)
	sw $t8, 1284($a1)		
	lw $t8, 1544($a0)
	sw $t8, 1544($a1)		
	lw $t8, 1800($a0)
	sw $t8, 1800($a1)		
	lw $t8, 2060($a0)
	sw $t8, 2060($a1)		
	lw $t8, 2068($a0)
	sw $t8, 2068($a1)		

	lw $t8, 2084($a0)
	sw $t8, 2084($a1)		
	lw $t8, 1828($a0)
	sw $t8, 1828($a1)	
	lw $t8, 1572($a0)
	sw $t8, 1572($a1)		
	lw $t8, 812($a0)
	sw $t8, 812($a1)

	jr $ra

clear_background:					# recolour background to colors stored in background array
	lw $t8, 0($a0)					
	sw $t8, 0($a1)					# write back into memory into B
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	add $a2, $a2, -1
	bgt $a2, $zero, clear_background 		# repeat while there are still pixels left
	jr $ra


load_background:					# reload background array to accomodate for changes made to array
	lw $t8, 0($a1)
	sw $t8, 0($a0)					# write back into memory into B
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	add $a2, $a2, -1
	bgt $a2, $zero, load_background 		# repeat while there are still pixels left
	jr $ra




# PAGE CREATIONS

start_page:						# start page creation
	addi $a1, $zero, BASE_ADDRESS
	addi $a1, $a1, 1848
	li $t9, 0x000000 

							# eat - e
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)	
	sw $t9, 1032($a1)
							# eat - a
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1032($a1)
							# eat - t
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 260($a1)	
	sw $t9, 516($a1)	
	sw $t9, 772($a1)	
	sw $t9, 1028($a1)

	la $t9, blue
	lw $t9, 0($t9) 
							# your - y
	addi $a1, $a1, 28
	sw $t9, 0($a1)	
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)
	sw $t9, 516($a1)	
	sw $t9, 772($a1)	
	sw $t9, 1028($a1)
							# your - o
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)
							# your - u
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)
							# your - r
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1032($a1)

	li $t9, 0x000000 
							# vegetables - v
	addi $a1, $a1, 2656
	sw $t9, 0($a1)	
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)
	sw $t9, 512($a1)
	sw $t9, 520($a1)	
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1028($a1)
							# vegetables - e
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)	
	sw $t9, 1032($a1)
							# vegetables - g
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)	
	sw $t9, 512($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)	
	sw $t9, 776($a1)
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)	
	sw $t9, 1032($a1)
							# vegetables - e
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)	
	sw $t9, 1032($a1)
							# vegetables - t
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 260($a1)	
	sw $t9, 516($a1)	
	sw $t9, 772($a1)	
	sw $t9, 1028($a1)
							# vegetables - a
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1032($a1)
							# vegetables - b
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)
							# vegetables - l
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 256($a1)	
	sw $t9, 512($a1)			
	sw $t9, 768($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)
							# vegetables - e
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)	
	sw $t9, 1032($a1)
							# vegetables - s
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 520($a1)			
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)	
	sw $t9, 1032($a1)
							# carrot
	addi $a1, $a1, 20
	addi $a1, $a1, -1056
	jal carrot

							# player creation
	li $a2, 0xFFE6C4
	li $t8, 9748
	add $a1, $t8, $t0
	jal player

							# cookie monster creation
	li $a2, 0x4587C0
	li $t8, 7100
	add $a1, $t8, $t0
	jal cookie_monster
	addi $a0, $a1, 284
	li $a1, 0xA77C38
	li $a2, 0x5D1A0F
	jal cookie

	li, $a1, 13076
	add $a1, $a1, $t0

	la $t9, blue
	lw $t9, 0($t9) 
							# quotes - '
	sw $t9, 8($a1)	
	sw $t9, 264($a1)
							# l
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 256($a1)	
	sw $t9, 512($a1)			
	sw $t9, 768($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)
							# quotes - '
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 256($a1)

	li $t9, 0x000000 
							# to - t
	addi $a1, $a1, 28
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 260($a1)	
	sw $t9, 516($a1)	
	sw $t9, 772($a1)	
	sw $t9, 1028($a1)
							# to - o
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)

							# start - s
	addi $a1, $a1, 36
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 520($a1)			
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)	
	sw $t9, 1032($a1)
							# start - t
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 260($a1)	
	sw $t9, 516($a1)	
	sw $t9, 772($a1)	
	sw $t9, 1028($a1)
							# start - a
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1032($a1)
							# start - r
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 516($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1032($a1)
							# start - t
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 260($a1)	
	sw $t9, 516($a1)	
	sw $t9, 772($a1)	
	sw $t9, 1028($a1)


	li $t9, 0xffff0000				# get keypress from keyboard input
	lw $t8, 0($t9)
	beq $t8, 1, keypress_start
	j start_page


keypress_start:
	lw $t5, 4($t9)

	li	$v0, 32					# syscall sleep
	addi	$a0, $zero, 60				# 60 ms
	syscall		
	
	lw $t5, 4($t9)
	beq	$t5, 108, l_pressed

	j start_page

winner_page:						# winner page creation
	sw $a2, 0($a0) 					# load brown color onto stack at specific position
	sw $a2, 256($a0) 				# load brown color onto stack at specific position
	addi $a0, $a0, 4 				# go to next address to color
	addi $t1, $t1, -1				# decrease number of uncolored pixel

	bgt $t1, $a1, winner_page 			# repeat while there are still pixels left

	li $t1, 0x10000 				# save 256*256 pixels 

							# initial player creation
	li $a2, 0xFFE6C4
	add $a1, $s0, $zero
	add $a1, $a1, $t0
	jal player
	
	addi $a1, $zero, BASE_ADDRESS
	addi $a1, $a1, 6160
	li $t9, 0x000000 
	
							# you - y
	addi $a1, $a1, 28
	sw $t9, 0($a1)	
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)
	sw $t9, 516($a1)	
	sw $t9, 772($a1)	
	sw $t9, 1028($a1)
							# you - o
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)
							# you - u
	addi $a1, $a1, 20
	sw $t9, 0($a1)	
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)

							# win - w
	addi $a1, $a1, 40
	sw $t9, 0($a1)	
	sw $t9, 8($a1)
	sw $t9, 16($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)
	sw $t9, 272($a1)
	sw $t9, 512($a1)
	sw $t9, 520($a1)
	sw $t9, 528($a1)	
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 784($a1)		
	sw $t9, 1024($a1)
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)
	sw $t9, 1036($a1)
	sw $t9, 1040($a1)
							# win - i
	addi $a1, $a1, 28
	sw $t9, 4($a1)
	sw $t9, 260($a1)
	sw $t9, 516($a1)
	sw $t9, 772($a1)
	sw $t9, 1028($a1)
							# win - n
	addi $a1, $a1, 20
	sw $t9, 0($a1)
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 256($a1)
	sw $t9, 264($a1)	
	sw $t9, 512($a1)
	sw $t9, 520($a1)			
	sw $t9, 768($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1032($a1)

							# carrot
	addi $a1, $a1, 20
	addi $a1, $a1, -1056
	jal carrot

	
	j END
	
end_scene:						# loser screen
	sw $a2, 0($a0) 					# load brown color onto stack at specific position
	sw $a2, 256($a0) 				# load brown color onto stack at specific position
	addi $a0, $a0, 4 				# go to next address to color
	addi $t1, $t1, -1				# decrease number of uncolored pixel

	bgt $t1, $a1, end_scene 			# repeat while there are still pixels left
	li $t1, 0x10000 				# save 256*256 pixels 
		
							# initial cookie monster creation
	li $a2, 0x4587C0
	addi $a1, $zero, 1300
	add $a1, $a1, $t0
	jal cookie_monster
	addi $a0, $a1, 284
	li $a1, 0xA77C38
	li $a2, 0x5D1A0F
	jal cookie

	addi $a1, $zero, BASE_ADDRESS
	addi $a1, $a1, 6160
	li $t9, 0x000000 
							# each 4 lines is 1 square

							#bye - b

	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 256($a1)
	sw $t9, 260($a1)
		
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 768($a1)
	sw $t9, 772($a1)

	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1280($a1)
	sw $t9, 1284($a1)

	sw $t9, 1032($a1)
	sw $t9, 1036($a1)
	sw $t9, 1288($a1)
	sw $t9, 1292($a1)

	sw $t9, 1040($a1)
	sw $t9, 1044($a1)
	sw $t9, 1296($a1)
	sw $t9, 1300($a1)

	sw $t9, 1296($a1)
	sw $t9, 1300($a1)
	sw $t9, 1552($a1)
	sw $t9, 1556($a1)
	sw $t9, 1808($a1)
	sw $t9, 1812($a1)

	sw $t9, 1536($a1)
	sw $t9, 1540($a1)
	sw $t9, 1792($a1)
	sw $t9, 1796($a1)

	sw $t9, 2048($a1)
	sw $t9, 2052($a1)
	sw $t9, 2304($a1)
	sw $t9, 2308($a1)

	sw $t9, 2056($a1)
	sw $t9, 2060($a1)
	sw $t9, 2312($a1)
	sw $t9, 2316($a1)

	sw $t9, 2064($a1)
	sw $t9, 2068($a1)
	sw $t9, 2320($a1)
	sw $t9, 2324($a1)

							# bye - y
	addi $a1, $a1, 40

	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 256($a1)
	sw $t9, 260($a1)
		
	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 768($a1)
	sw $t9, 772($a1)

	sw $t9, 1032($a1)
	sw $t9, 1036($a1)
	sw $t9, 1288($a1)
	sw $t9, 1292($a1)

	sw $t9, 1040($a1)
	sw $t9, 1044($a1)
	sw $t9, 1296($a1)
	sw $t9, 1300($a1)

	sw $t9, 1048($a1)
	sw $t9, 1052($a1)
	sw $t9, 1304($a1)
	sw $t9, 1308($a1)

	sw $t9, 800($a1)
	sw $t9, 804($a1)
	sw $t9, 544($a1)
	sw $t9, 548($a1)

	sw $t9, 288($a1)
	sw $t9, 292($a1)
	sw $t9, 32($a1)
	sw $t9, 36($a1)

	sw $t9, 1552($a1)
	sw $t9, 1556($a1)
	sw $t9, 1808($a1)
	sw $t9, 1812($a1)

	sw $t9, 2064($a1)
	sw $t9, 2068($a1)
	sw $t9, 2320($a1)
	sw $t9, 2324($a1)

							# bye - e
	addi $a1, $a1, 52


	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 256($a1)
	sw $t9, 260($a1)
		
	sw $t9, 8($a1)	
	sw $t9, 12($a1)
	sw $t9, 264($a1)
	sw $t9, 268($a1)

	sw $t9, 16($a1)	
	sw $t9, 20($a1)
	sw $t9, 272($a1)
	sw $t9, 276($a1)

	sw $t9, 512($a1)
	sw $t9, 516($a1)
	sw $t9, 768($a1)
	sw $t9, 772($a1)

	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1280($a1)
	sw $t9, 1284($a1)

	sw $t9, 1032($a1)
	sw $t9, 1036($a1)
	sw $t9, 1288($a1)
	sw $t9, 1292($a1)

	sw $t9, 1040($a1)
	sw $t9, 1044($a1)
	sw $t9, 1296($a1)
	sw $t9, 1300($a1)

	sw $t9, 1536($a1)
	sw $t9, 1540($a1)
	sw $t9, 1792($a1)
	sw $t9, 1796($a1)

	sw $t9, 2048($a1)
	sw $t9, 2052($a1)
	sw $t9, 2304($a1)
	sw $t9, 2308($a1)

	sw $t9, 2056($a1)
	sw $t9, 2060($a1)
	sw $t9, 2312($a1)
	sw $t9, 2316($a1)

	sw $t9, 2064($a1)
	sw $t9, 2068($a1)
	sw $t9, 2320($a1)
	sw $t9, 2324($a1)

							# sad face
	addi $a1, $a1, 52
	addi $a1, $a1, 1024
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1280($a1)
	sw $t9, 1284($a1)

	sw $t9, 1032($a1)
	sw $t9, 1036($a1)
	sw $t9, 1288($a1)
	sw $t9, 1292($a1)

	sw $t9, 1040($a1)
	sw $t9, 1044($a1)
	sw $t9, 1296($a1)
	sw $t9, 1300($a1)

	sw $t9, 1556($a1)
	sw $t9, 1560($a1)
	sw $t9, 1816($a1)
	sw $t9, 1812($a1)

	sw $t9, 1536($a1)
	sw $t9, 1532($a1)
	sw $t9, 1788($a1)
	sw $t9, 1792($a1)

	addi $a0, $a1, -1036				# cookie - eyes
	li $a1, 0xA77C38
	li $a2, 0x5D1A0F
	jal cookie

	addi $a0, $a0, 32
	jal cookie

	j END

# OBJECT CREATIONS
	
side_border:
	sw $a2, 0($a0) 					# load brown color onto stack at specific position
	addi $a0, $a0, 256 				# go to next address to color
	addi $t1, $t1, -1				# decrease number of uncolored pixel
	bgt $t1, $a1, side_border 			# repeat while there are still pixels left
	li $t1, 0x10000 				# save 256*256 pixels 
	jr $ra

platforms:
	sw $a2, 0($a0) 					# load brown color onto stack at specific position
	sw $a2, 256($a0) 				# load brown color onto stack at specific position
	addi $a0, $a0, 4 				# go to next address to color
	addi $t1, $t1, -1				# decrease number of uncolored pixel
	bgt $t1, $a1, platforms 			# repeat while there are still pixels left
	li $t1, 0x10000 				# save 256*256 pixels 
	jr $ra

ladder_horizontal:
	sw $a2, -256($a0) 				# load brown color onto stack at top step of ladder
	sw $a2, 0($a0) 					# load brown color onto stack at top step of ladder
	sw $a2, 768($a0) 				# bottom step of ladder
	sw $a2, 1536($a0) 				# bottom step of ladder
	addi $a0, $a0, 4 				# go to next address to color
	addi $t1, $t1, -1				# decrease number of uncolored pixel
	bgt $t1, 65528, ladder_horizontal 		# repeat while there are still pixels left
	li $t1, 0x10000 				# save 256*256 pixels 
	jr $ra

ladder_vertical:
	sw $a2, 0($a1) 					# load brown color onto stack at specific position - left side of ladder
	sw $a2, 28($a1) 				# right side of ladder
	addi $a1, $a1, 256 				# go to next address to color
	addi $t1, $t1, -1				# decrease number of uncolored pixel
	bgt $t1, 65525, ladder_vertical 		# repeat while there are still pixels left
	li $t1, 0x10000 				# save 256*256 pixels 
	jr $ra

cookie_monster:						# cookie monster creation - drawing pixels
	li $t9, 0x000000 
	sw $t9, 0($a1)					
	sw $t9, 4($a1)
	sw $t9, 256($a1)
	sw $t9, 260($a1)
	sw $t9, 12($a1)
	sw $t9, 16($a1)
	sw $t9, 268($a1)
	sw $t9, 272($a1)
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
	addi $a1, $a1, 1020
	sw $a2, 0($a1)					
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

cookie:							# cookie creation - drawing pixels
	sw $a1, 4($a0)
	sw $a1, 8($a0)
	sw $a2, 12($a0)
	sw $a1, 256($a0) 				
	sw $a2, 260($a0)
	sw $a1, 264($a0)
	sw $a1, 268($a0)
	sw $a2, 272($a0)
	sw $a1, 512($a0) 				
	sw $a1, 516($a0)
	sw $a1, 520($a0)
	sw $a2, 524($a0)
	sw $a1, 528($a0)
	sw $a2, 768($a0) 			
	sw $a1, 772($a0)
	sw $a2, 776($a0)
	sw $a1, 780($a0)
	sw $a1, 784($a0)
	sw $a1, 1028($a0)
	sw $a1, 1032($a0)
	sw $a2, 1036($a0)
	jr $ra
	
player:							# player creation - drawing pixels
	li $t9, 0xDBBE3D 				# yellow
	li $t8, 0xE70007 				# red
	li $t5, 0x000000 				# black


	sw $t9, 4($a1) 					#player 
	sw $t9, 8($a1) 					#player
	sw $t9, 12($a1) 				#player
	sw $t9, 16($a1) 				#player
	sw $t9, 20($a1) 				#player
	sw $t9, 24($a1) 				#player
	sw $t9, 28($a1) 				#player

	sw $t9, 256($a1) 				# player 
	sw $t9, 260($a1) 				# player
	sw $t9, 264($a1) 				# player
	sw $t9, 268($a1) 				# player
	sw $t9, 272($a1) 				# player
	sw $t9, 276($a1) 				# player
	sw $t9, 280($a1) 				# player
	sw $t9, 284($a1) 				# player
	sw $t9, 288($a1) 				# player
	sw $t9, 512($a1) 				# player
	sw $t9, 516($a1) 				# player
	sw $t9, 768($a1) 				# player
	sw $t9, 772($a1) 				# player
	sw $t9, 1024($a1) 				# player
	sw $t9, 1028($a1) 				# player
	sw $t9, 540($a1) 				# player
	sw $t9, 544($a1) 				# player
	sw $t9, 796($a1) 				# player
	sw $t9, 800($a1) 				# player
	sw $t9, 1052($a1) 				# player
	sw $t9, 1056($a1) 				# player

	sw $a2, 520($a1) 				# skin
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

	sw $t5, 780($a1) 				# eyes
	sw $t5, 788($a1)

	sw $t8, 1288($a1) 				# upper body
	sw $t8, 1544($a1) 				# body
	sw $t8, 1800($a1) 				# body
	sw $t8, 1292($a1) 				# body
	sw $t8, 1548($a1) 				# body
	sw $t8, 1804($a1) 				# body
	sw $t8, 1296($a1) 				# body
	sw $t8, 1552($a1) 				# body
	sw $t8, 1808($a1) 				# body
	sw $t8, 1300($a1) 				# body
	sw $t8, 1556($a1) 				# body
	sw $t8, 1812($a1) 				# body
	sw $t8, 1304($a1) 				# body
	sw $t8, 1560($a1) 				# body
	sw $t8, 1816($a1) 				# body

	sw $t8, 1556($a1) 				# body legs
	sw $t8, 1812($a1) 				# body
	sw $t8, 2068($a1) 				# body
	sw $t8, 1548($a1) 				# body
	sw $t8, 1804($a1) 				# body
	sw $t8, 2060($a1) 				# body

	sw $t8, 1284($a1) 				# body arms
	sw $t8, 1308($a1) 				# body

carrot:
	li $t7, 0x00AE00 				# green
	li $t6, 0xFF9000 				# orange
	sw $t6, 1312($a1)  				# carrot
	sw $t6, 1316($a1) 				# carrot
	sw $t6, 1320($a1) 				# carrot
	sw $t6, 1324($a1) 				# carrot
	sw $t6, 1328($a1) 				# carrot
	sw $t6, 1572($a1)				# carrot
	sw $t6, 1576($a1) 				# carrot
	sw $t6, 1580($a1) 				# carrot
	sw $t6, 1832($a1)   				# carrot
	sw $t6, 1828($a1) 				# carrot
	sw $t6, 1832($a1) 				# carrot
	sw $t6, 1836($a1) 				# carrot
	sw $t6, 2084($a1) 				# carrot
	sw $t6, 2088($a1) 				# carrot
	sw $t6, 2092($a1) 				# carrot
	sw $t7, 1064($a1) 				# leaf
	sw $t7, 804($a1) 				# leaf
	sw $t7, 812($a1) 				# leaf
	sw $t7, 1060($a1) 				# leaf
	sw $t7, 1068($a1) 				# leaf
	jr $ra

mini_carrot:
	li $t7, 0x00AE00 				# green
	li $t6, 0xFF9000 				# orange

	sw $t7, 0($a1) 					# carrot
	sw $t6, 256($a1) 				# carrot
	sw $t6, 512($a1) 				# carrot

	add $v1, $a1, $zero				# store address

	jr $ra

mini_cookie:
	li $a1, 0xA77C38				# mini point count cookie
	li $a2, 0x5D1A0F
	sw $a1, 0($a0)
	sw $a1, 260($a0)
	sw $a2, 4($a0)
	sw $a2, 256($a0)
	j continue

level_display:						# display level number 
	la $t9, blue
	lw $t9, 0($t9)
	beq $s7, 1, l1
	beq $s7, 2, l2
	beq $s7, 3, l3

l1:
	sw $t9, 0($a1)					# level one - write L1
	sw $t9, 256($a1)	
	sw $t9, 512($a1)			
	sw $t9, 768($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)

	addi $a1, $a1, 24
	sw $t9, 4($a1)
	sw $t9, 260($a1)
	sw $t9, 516($a1)
	sw $t9, 772($a1)
	sw $t9, 1028($a1)
	jr $ra

l2:							# level two - write L2
	sw $t9, 0($a1)	
	sw $t9, 256($a1)	
	sw $t9, 512($a1)			
	sw $t9, 768($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)

	addi $a1, $a1, 28
	sw $t9, 0($a1)
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 264($a1)
	sw $t9, 516($a1)
	sw $t9, 512($a1)
	sw $t9, 520($a1)
	sw $t9, 768($a1)
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)
	jr $ra

l3:							# level three - write L3
	sw $t9, 0($a1)	
	sw $t9, 256($a1)	
	sw $t9, 512($a1)			
	sw $t9, 768($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)
	addi $a1, $a1, 28
	sw $t9, 0($a1)	
	sw $t9, 4($a1)
	sw $t9, 8($a1)
	sw $t9, 264($a1)	
	sw $t9, 516($a1)
	sw $t9, 520($a1)
	sw $t9, 776($a1)	
	sw $t9, 1024($a1)
	sw $t9, 1028($a1)
	sw $t9, 1032($a1)
	jr $ra


END:				
	li $v0, 10					# exit the program
	syscall
