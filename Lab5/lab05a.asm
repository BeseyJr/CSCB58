.data
promptA:    .asciiz "Enter coefficient a: "
promptB:    .asciiz "Enter coefficient b: "
promptC:    .asciiz "Enter coefficient c: "
delta: .word 0    # Variable to store the discriminant
solutions: .word 0    # Variable to store the number of solutions
deltaMsg:   .asciiz "The discriminant (delta) is: "
solutionsMsg: .asciiz "The number of real solutions is: "
newline:    .asciiz "\n"

.text
.globl main
main:
  # Prompt for coefficient a
  li $v0, 4
  la $a0, promptA
  syscall

  # Read coefficient a
  li $v0, 5
  syscall
  move $t0, $v0

  # Prompt for coefficient b
  li $v0, 4
  la $a0, promptB
  syscall

  # Read coefficient b
  li $v0, 5
  syscall
  move $t1, $v0

  # Prompt for coefficient c
  li $v0, 4
  la $a0, promptC
  syscall

  # Read coefficient c
  li $v0, 5
  syscall
  move $t2, $v0
  
  # Calculate b^2
  mul $t3, $t1, $t1
  
  # Calculate 4ac
  li $t5, 4
  mul $t4, $t0, $t2
  mul $t4, $t4, $t5
  
  # Calculate discriminant b^2 - 4ac and store it
  sub $t6, $t3, $t4
  sw $t6, delta

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
  # Store the number of solutions
  sw $t7, solutions

  # Print the number of solutions
  li $v0, 4
  la $a0, solutionsMsg
  syscall

  lw $a0, solutions
  li $v0, 1
  syscall

  li $v0, 4       # Print newline
  la $a0, newline
  syscall

  # Exit program
  li $v0, 10
  syscall
