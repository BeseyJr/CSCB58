.data
prompt1: .asciiz "Enter the first positive integer: "
prompt2: .asciiz "Enter the second positive integer: "
result: .asciiz "The GCD of the two numbers is: "
newline: .asciiz "\n"

.text
.globl main
main:
  # Prompt and read the first number
  li $v0, 4
  la $a0, prompt1
  syscall
  li $v0, 5
  syscall
  move $t8, $v0  # Store the first number in $t8

  # Prompt and read the second number
  li $v0, 4
  la $a0, prompt2
  syscall
  li $v0, 5
  syscall
  move $t9, $v0  # Store the second number in $t9

  # Start Euclid's algorithm
  j euclids_algorithm

euclids_algorithm:
  beq $t8, $t9, end_loop  # If a == b, GCD is found

  # If a > b, subtract b from a
  slt $t1, $t9, $t8  # Set $t1 to 1 if $t9 < $t8
  beq $t1, $zero, subtract_b_from_a
  sub $t8, $t8, $t9
  j euclids_algorithm

subtract_b_from_a:
  # If b > a, subtract a from b
  sub $t9, $t9, $t8
  j euclids_algorithm

end_loop:
  # The GCD is now in $t8 (and $t9 since they are equal)
  # Print the result
  li $v0, 4
  la $a0, result
  syscall

  move $a0, $t8  # Move the GCD result into $a0 for printing
  li $v0, 1
  syscall

  # Print newline
  li $v0, 4
  la $a0, newline
  syscall

  # Terminate the program
  li $v0, 10
  syscall
