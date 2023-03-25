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
size: .word 0x10000

.globl main
main:
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.eqv BASE_ADDRESS 0x10008000

.text

li $t0, BASE_ADDRESS # $t0 stores the base address for display
li $t1, 0x10000 # save 256*256 pixels
li $t2, 0xffc0cb # $t1 stores the pink colour code for background
li $t3, 0x9a3f1d # $t2 stores the brown colour code for platforms
li $t4, 0x0000ff # $t3 stores the blue colour code

li $a0, 0	#background
add $a0, $a0, $t0
li $a1, 0
li $a2, 0xffc0cb
jal platforms

li $a0, 3712	#floor
add $a0, $a0, $t0
li $a1, 0
li $a2,  0x9a3f1d
jal platforms

li $a0, 2968	#platform 1
add $a0, $a0, $t0
li $a1, 0xFFEC
jal platforms

li $a0, 2184	#platform 2
add $a0, $a0, $t0
li $a1, 0xFFE4
jal platforms

li $a0, 1416	#platform 3
add $a0, $a0, $t0
li $a1, 0xFFE4
jal platforms

li $a0, 664	#platform 4
add $a0, $a0, $t0
li $a1, 0xFFEC
jal platforms

li $a0, 3256	#ladder 1
subi $a1, $a0, 128
add $a0, $a0, $t0
jal ladder_horizontal
add $a1, $a1, $t0
jal ladder_vertical

li $a0, 2456	#ladder 2
subi $a1, $a0, 128
add $a0, $a0, $t0
jal ladder_horizontal
add $a1, $a1, $t0
jal ladder_vertical

li $a0, 2520	#ladder 3
subi $a1, $a0, 128
add $a0, $a0, $t0
jal ladder_horizontal
add $a1, $a1, $t0
jal ladder_vertical

li $a0, 1720	#ladder 3
subi $a1, $a0, 128
add $a0, $a0, $t0
jal ladder_horizontal
add $a1, $a1, $t0
jal ladder_vertical

li $a0, 984	#ladder 4
subi $a1, $a0, 128
add $a0, $a0, $t0
jal ladder_horizontal
add $a1, $a1, $t0
jal ladder_vertical

j END 


platforms:
sw $a2, 0($a0) # load brown color onto stack at specific position
addi $a0, $a0, 4 # go to next address to color
addi $t1, $t1, -1	# decrease number of uncolored pixel
bgt $t1, $a1, platforms # repeat while there are still pixels left
li $t1, 0x10000 # save 256*256 pixels 
jr $ra

ladder_horizontal:
sw $a2, 0($a0) # load brown color onto stack at top step of ladder
sw $a2, 256($a0) # bottom step of ladder
addi $a0, $a0, 4 # go to next address to color
addi $t1, $t1, -1	# decrease number of uncolored pixel
bgt $t1, 0xFFFD, ladder_horizontal # repeat while there are still pixels left
li $t1, 0x10000 # save 256*256 pixels 
jr $ra

ladder_vertical:
sw $a2, 0($a1) # load brown color onto stack at specific position - left side of ladder
sw $a2, 12($a1) # right side of ladder
addi $a1, $a1, 128 # go to next address to color
addi $t1, $t1, -1	# decrease number of uncolored pixel
bgt $t1, 0xFFFA, ladder_vertical # repeat while there are still pixels left
li $t1, 0x10000 # save 256*256 pixels 
jr $ra

END:
li $v0, 10	# exit the program
syscall
























