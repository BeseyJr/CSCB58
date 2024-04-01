.data
promptA: .asciiz "Enter coefficient a: "
promptB: .asciiz "Enter coefficient b: "
promptC: .asciiz "Enter coefficient c: "
# Storage for discriminant and number of solutions
delta: .word 0
solutions: .word 0
# Output messages
deltaMsg: .asciiz "The discriminant (\u0394) is: "
solutionsMsg: .asciiz "The number of real solutions is: "
newline: .asciiz "\n"

.text
.globl main

# Main program entry point
main:
    # Prompt for coefficient a
    li $v0, 4
    la $a0, promptA
    syscall

    # Read coefficient a
    li $v0, 5
    syscall
    move $t0, $v0   # Move the read value to $t0

    # Prompt for coefficient b
    li $v0, 4
    la $a0, promptB
    syscall

    # Read coefficient b
    li $v0, 5
    syscall
    move $t1, $v0   # Move the read value to $t1

    # Prompt for coefficient c
    li $v0, 4
    la $a0, promptC
    syscall

    # Read coefficient c
    li $v0, 5
    syscall
    move $t2, $v0   # Move the read value to $t2
  
    # Calculate discriminant b^2 - 4ac
    mul $t3, $t1, $t1   # t3 = b^2
    li $t5, 4
    mul $t4, $t0, $t2   # t4 = 4 * a * c
    mul $t4, $t4, $t5
    sub $t6, $t3, $t4   # t6 = b^2 - 4ac
    sw $t6, delta       # Store discriminant

    # Print the discriminant
    li $v0, 4
    la $a0, deltaMsg
    syscall
    lw $a0, delta
    li $v0, 1
    syscall
    li $v0, 4       # Print newline
    la $a0, newline
    syscall

    # Determine and print the number of solutions
    # if discriminant > 0 then 2 real solutions, = 0 then 1 solution, < 0 then no real solutions
    blez $t6, discriminant_non_positive
    li $t7, 2
    j store_solution_count

discriminant_non_positive:
    bltz $t6, no_real_solutions
    li $t7, 1
    j store_solution_count

no_real_solutions:
    li $t7, 0

store_solution_count:
    sw $t7, solutions
    li $v0, 4
    la $a0, solutionsMsg
    syscall
    lw $a0, solutions
    li $v0, 1
    syscall
    li $v0, 4       # Print newline
    la $a0, newline
    syscall

    # Exit the program
    li $v0, 10
    syscall

# Function: do_addition
# Calling Convention: Register-based
# Arguments: a - $a0, b - $a1, c - $a2
# Return: Sum - $v0
do_addition:
    # Add the values of a, b, and c
    add $v0, $a0, $a1
    add $v0, $v0, $a2
    jr $ra             # Return to the caller

# Function: n_solutions
# Calling Convention: Stack-based
# Arguments: a, b, c on the stack
# Return: Number of real solutions - $v0
n_solutions:
    # Access arguments from the stack
    lw $a0, 0($sp)     # a
    lw $a1, 4($sp)     # b
    lw $a2, 8($sp)     # c
    # Calculate the discriminant
    mul $t0, $a1, $a1  # t0 = b^2
    li $t1, 4
    mul $t2, $a0, $
