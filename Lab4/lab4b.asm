# lab4b.asm
# Prompts the user for A, B, and C, outputs A + B + C.
# Author: Mohamed Abdi Besey
# UtorID: beseymoh

.data
promptA: .asciiz "Enter integer A: "
promptB: .asciiz "Enter integer B: "
promptC: .asciiz "Enter integer C: "
resultABC: .asciiz "A + B + C = "
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
    
    # Prompt for C
    li $v0, 4
    la $a0, promptC
    syscall
    
    # Read C
    li $v0, 5
    syscall
    move $t2, $v0 # Store C in $t2
    
    # Compute A + B + C
    add $t3, $t0, $t1
    add $t3, $t3, $t2
    
    # Print A + B + C
    li $v0, 4
    la $a0, resultABC
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    
    # Exit
    li $v0, 10
    syscall
