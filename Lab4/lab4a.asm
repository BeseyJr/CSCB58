# lab4a.asm
# Prompts the user for A and B, outputs A + 42 and B - A.
# Author: Mohamed Abdi Besey
#UtorID: beseymoh

.data
promptA: .asciiz "Enter integer A: "
promptB: .asciiz "Enter integer B: "
resultA: .asciiz "A + 42 = "
resultB: .asciiz "B - A = "
newline: .asciiz "\n"

.text
.globl main

main:
    # Prompt for A
    li $v0, 4
    la $a0, promptA
    syscall
    
    # Read A
    li $v0, 5
    syscall
    move $t0, $v0 # Store A in $t0
    
    # Prompt for B
    li $v0, 4
    la $a0, promptB
    syscall
    
    # Read B
    li $v0, 5
    syscall
    move $t1, $v0 # Store B in $t1
    
    # Compute A + 42
    addi $t2, $t0, 42
    
    # Compute B - A
    sub $t3, $t1, $t0
    
    # Print A + 42
    li $v0, 4
    la $a0, resultA
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    
    # Print B - A
    li $v0, 4
    la $a0, resultB
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    
    # Exit
    li $v0, 10
    syscall
