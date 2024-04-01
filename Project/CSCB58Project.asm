.data
BASE_ADDRESS: .word 0x10008000      # Base address for the bitmap display
PLAYER_COLOR: .word 0x00FF00        # Green for the player
PLATFORM_COLOR: .word 0xFFD700      # Gold for platforms
BACKGROUND_COLOR: .word 0x000000    # Black for background
PLAYER_POS_X: .word 32              # Player's initial X position (middle of the screen)
PLAYER_POS_Y: .word 16              # Player's initial Y position
PLAYER_WIDTH: .word 4               # Width of the player in units
PLAYER_HEIGHT: .word 4              # Height of the player in units
SCREEN_WIDTH_UNITS: .word 64        # Screen width in units (for a 256x256 screen with unit size 4x4 pixels)
SCREEN_HEIGHT_UNITS: .word 64       # Screen height in units
UNIT_SIZE: .word 4                  # Size of each unit in pixels (e.g., 4x4 pixels)
platform_data: .word 10, 20, 10, 30, 40, 20, 15, 25, 30  # Platforms data
NUM_PLATFORMS: .word 3              # Number of platforms

.text
.globl main

main:
    jal setup_display
    jal clear_screen
    jal draw_initial_state

# Main game loop
game_loop:
    jal handle_input
    jal clear_screen
    jal draw_player
    jal draw_platforms
    j game_loop

# Setup display - placeholder for any required initialization
setup_display:
    jr $ra

# Clear the entire screen
clear_screen:
    li $t0, 0x10008000         # Start of display memory
    li $t1, 0x1000F000         # End of display memory
    lw $t2, BACKGROUND_COLOR
clear_loop:
    sw $t2, 0($t0)             # Set pixel to background color
    addi $t0, $t0, 4           # Next pixel
    bne $t0, $t1, clear_loop
    jr $ra

draw_initial_state:
    jal draw_platforms
    jr $ra

# Handle player input for movement
handle_input:
    li $v0, 0xFFFF0000          # Keyboard status MMIO address
    lw $v1, 0($v0)              # Read keyboard status
    beqz $v1, end_input         # Skip handling if no key pressed
    lw $a0, 4($v0)              # Read key code
    li $t0, 'a'                 # ASCII code for 'a'
    li $t1, 'd'                 # ASCII code for 'd'
    li $t2, 4                   # Movement step size
    lw $t3, PLAYER_POS_X        # Load current X position
    
    beq $a0, $t0, move_left     # If 'a' is pressed
    beq $a0, $t1, move_right    # If 'd' is pressed
    j end_input

move_left:
    sub $t3, $t3, $t2           # Move left by reducing X position
    sw $t3, PLAYER_POS_X        # Store new X position
    j end_input

move_right:
    add $t3, $t3, $t2           # Move right by increasing X position
    sw $t3, PLAYER_POS_X        # Store new X position

end_input:
    jr $ra


# Draw the player character
draw_player:
    # Assume player is a single pixel for simplicity, adjust for size as needed
    lw $t0, PLAYER_POS_X
    lw $t1, PLAYER_POS_Y
    lw $t2, PLAYER_COLOR
    li $t3, 0x10008000         # Base address
    # Convert X,Y to address (simplified, assumes 256x256 screen with 4x4 pixels per unit)
    mul $t4, $t1, SCREEN_WIDTH_UNITS  # Y offset
    add $t4, $t4, $t0                 # Add X offset
    sll $t4, $t4, 2                   # Convert to byte offset
    add $t4, $t3, $t4                 # Add base address
    sw $t2, 0($t4)                    # Draw player
    jr $ra

# Draw platforms
draw_platforms:
    lw $t0, PLATFORM_COLOR       # Load platform color
    li $t1, 0                    # Index for current platform
    la $t2, platform_data        # Address of the first platform data
    
platforms_loop:
    lw $t3, 0($t2)               # StartX
    lw $t4, 4($t2)               # EndX
    lw $t5, 8($t2)               # Y
    addi $t2, $t2, 12            # Move to the next set of platform data
    
    # Calculate the start address for the platform
    mul $t6, $t5, SCREEN_WIDTH_UNITS  # Row offset
    add $t6, $t6, $t3                 # Adding StartX to row offset
    sll $t6, $t6, 2                   # Convert to byte offset
    add $t6, $t6, BASE_ADDRESS        # Adding base address
    
    # Drawing the platform from StartX to EndX at Y position
    sub $t7, $t4, $t3                 # Calculate the length of the platform
platform_draw_loop:
    bgez $t7, end_platform_draw       # If we've drawn the entire platform, go to the next
    sw $t0, 0($t6)                    # Set pixel to platform color
    addi $t6, $t6, 4                  # Move to the next pixel
    addi $t7, $t7, -1                 # Decrement length left
    j platform_draw_loop
    
end_platform_draw:
    addi $t1, $t1, 1                  # Increment the platform index
    lw $t8, NUM_PLATFORMS
    blt $t1, $t8, platforms_loop      # Loop until all platforms are processed
    jr $ra
