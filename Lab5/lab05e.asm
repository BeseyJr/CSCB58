.data
# Define prompts and messages to be displayed to the user
prompt: .asciiz "Enter a non-negative integer n: "
resultMsg: .asciiz "The result is: "

.text
.globl main

# The main function starts here
main:
    # Print the prompt to the console
    li $v0, 4                  # Set system call for print_string
    la $a0, prompt             # Load address of prompt message into $a0
    syscall                    # System call to print the prompt

    # Read an integer from the user
    li $v0, 5                  # Set system call for read_int
    syscall                    # System call to read an integer
    move $a0, $v0              # Move the read integer into $a0 for mystery function

    # Call the mystery function
    jal mystery                # Jump and link to mystery function

    # Print the result message
    move $a1, $v0              # Move result of mystery into $a1 for printing
    li $v0, 4                  # Set system call for print_string
    la $a0, resultMsg          # Load address of result message into $a0
    syscall                    # System call to print the result message

    # Print the result of the mystery function
    li $v0, 1                  # Set system call for print_int
    move $a0, $a1              # Move result into $a0 for printing
    syscall                    # System call to print the integer

    # Exit the program
    li $v0, 10                 # Set system call for exit
    syscall                    # System call to exit

# The recursive mystery function
mystery:
    # Save context on stack
    addi $sp, $sp, -8          # Allocate stack space for $ra and $a0
    sw $ra, 4($sp)             # Save return address $ra
    sw $a0, 0($sp)             # Save current argument $a0

    # Base case check: if n == 0, return 0
    beqz $a0, base_case        # If $a0 is 0, jump to base_case

    # Recursive case
    addi $a0, $a0, -1          # Decrement n ($a0) by 1
    jal mystery                # Recursive call to mystery with n-1
    lw $a0, 0($sp)             # Restore original n ($a0) after recursion
    li $t0, 2
    mul $t1, $a0, $t0          # Calculate 2 * n and store in $t1
    add $v0, $v0, $t1          # Add 2*n to result of mystery(n-1)
    addi $v0, $v0, -1          # Subtract 1 to complete calculation: 2*n - 1 + mystery(n-1)

    # Restore context and return
    lw $ra, 4($sp)             # Restore return address $ra
    addi $sp, $sp, 8           # Deallocate stack space
    jr $ra                     # Return to caller

# Handle the base case for n == 0
base_case:
    li $v0, 0                  # Set return value to 0 for base case
    lw $ra, 4($sp)             # Restore return address $ra
    addi $sp, $sp, 8           # Deallocate stack space
    jr $ra                     # Return to caller
