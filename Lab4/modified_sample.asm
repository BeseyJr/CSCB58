# MIPS Assembly Program to add and subtract two user-entered integers
# Author: Mohamed Besey
# UTorID: beseymoh

.data
# Define prompts and result formats
promptA: .asciiz "Enter an int A: "
promptB: .asciiz "Enter an int B: "
resultAdd: .asciiz "A + B = "
resultSub: .asciiz "A - B = "
newline: .asciiz "\n"

.text
.globl main

main:
    # Print prompt for the first number
    li $v0, 4
    la $a0, promptA
    syscall

    # Read the first integer from the user
    li $v0, 5
    syscall
    move $t0, $v0    # Move the read value into $t0

    # Print prompt for the second number
    li $v0, 4
    la $a0, promptB
    syscall

    # Read the second integer from the user
    li $v0, 5
    syscall
    move $t1, $v0    # Move the read value into $t1

    # Calculate A + B
    add $t2, $t0, $t1

    # Calculate A - B
    sub $t3, $t0, $t1

    # Print result of addition
    li $v0, 4
    la $a0, resultAdd
    syscall
    li $v0, 1
    move $a0, $t2
    syscall

    # Print a newline
    li $v0, 4
    la $a0, newline
    syscall

    # Print result of subtraction
    li $v0, 4
    la $a0, resultSub
    syscall
    move $a0, $t3
    li $v0, 1
    syscall

    # Print a final newline
    li $v0, 4
    la $a0, newline
    syscall

    # Exit the program
    li $v0, 10
    syscall
