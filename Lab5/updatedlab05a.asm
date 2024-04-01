.data
a:      .word 1              # Coefficient 'a' of the quadratic equation
b:      .word -5             # Coefficient 'b' of the quadratic equation
c:      .word 6              # Coefficient 'c' of the quadratic equation
delta:  .word 0              # Variable to store the discriminant
solutions: .word 0           # Variable to store the number of solutions
newLine: .asciiz "\n"
aMsg:   .asciiz "Coefficient a: "
bMsg:   .asciiz "Coefficient b: "
cMsg:   .asciiz "Coefficient c: "
solMsg: .asciiz "The number of real solutions is: "

.text
.globl main
main:
  # Print coefficient a
  li $v0, 4
  la $a0, aMsg
  syscall
  
  lw $a0, a
  li $v0, 1
  syscall
  
# New line after solution count
  li $v0, 4
  la $a0, newLine
  syscall
  
  # Print coefficient b
  li $v0, 4
  la $a0, bMsg
  syscall

  lw $a0, b
  li $v0, 1
  syscall
  
# New line after solution count
  li $v0, 4
  la $a0, newLine
  syscall
  
  # Print coefficient c
  li $v0, 4
  la $a0, cMsg
  syscall

  lw $a0, c
  li $v0, 1
  syscall
  
# New line after solution count
  li $v0, 4
  la $a0, newLine
  syscall
  
  # Load coefficients into registers
  lw $t0, a
  lw $t1, b
  lw $t2, c

  # Calculate b^2
  mul $t3, $t1, $t1
  
  # Calculate 4ac
  li $t5, 4
  mul $t4, $t0, $t2
  mul $t4, $t4, $t5
  
  # Calculate discriminant b^2 - 4ac and store it
  sub $t6, $t3, $t4
  sw $t6, delta

  # Determine the number of solutions based on the discriminant
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

  # Print the number of solutions
  li $v0, 4
  la $a0, solMsg
  syscall

  lw $a0, solutions
  li $v0, 1
  syscall

  # New line after solution count
  li $v0, 4
  la $a0, newLine
  syscall

  # Exit program
  li $v0, 10
  syscall
