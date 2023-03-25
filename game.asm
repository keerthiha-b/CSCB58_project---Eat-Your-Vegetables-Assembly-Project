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
li $t6, BASE_ADDRESS # $t0 stores the base address for display
li $t1, 0x10000 # save 256*256 pixels
li $t8, 0x10000 # save 256*256 pixels

li $t2, 0xffc0cb # $t1 stores the pink colour code for background
li $t3, 0x9a3f1d # $t2 stores the brown colour code for platforms
li $t4, 0x0000ff # $t3 stores the blue colour code


background:
sw $t2, 0($t0) # load pink color onto stack at current address
addi $t0, $t0, 4 # go to next address to color
addi $t1, $t1, -1	# decrease number of uncolored pixel
bgtz $t1, background # repeat while there are still pixels left

platform:
sw $t3, 3584($t6) # load brown color onto stack at 3584
addi $t6, $t6, 4 # go to next address to color
addi $t8, $t8, -1	# decrease number of uncolored pixel
bgtz $t8, platform # repeat while there are still pixels left


li $v0, 10	# exit the program
syscall
























