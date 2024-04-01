.data
# Space for array A, which will be dynamically filled based on user input
A:      .space 28    # Allocating space for 7 integers as an example; adjust if more space is needed
# Space for array B
B:      .space 28    # Matching space for array B to store processed data
# User prompt messages and formatting
arrayLengthPrompt: .asciiz "Enter the length of the array: "
inputPrompt: .asciiz "Enter number for A["
closingBracket: .asciiz "]: "
resultMsg:         .asciiz "Result in array B: "
newline:           .asciiz "\n"
space:             .asciiz " "

.text
.globl main

main:
    # Prompt the user to enter the length of the array
    li $v0, 4
    la $a0, arrayLengthPrompt
    syscall

    # Read the length of the array from user input
    li $v0, 5
    syscall
    move $t2, $v0         # Store the length of the array in $t2
    li $t3, 0             # Initialize the index i to 0

    # Ensure the user-provided length does not exceed the maximum allocated length
    li $t7, 7             # Set the maximum allowed length
    bgt $t2, $t7, exit    # If the user's length is greater, jump to exit

    # Prepare to read integers into array A from user input
    la $t0, A             # Load the base address of array A into $t0
    la $t1, B             # Load the base address of array B into $t1

input_loop:
    # Loop to fill array A with integers from user input
    # Check if we have reached the length of the array
    blt $t3, $t2, read_input  # Continue reading input if more elements are expected
    j process_array           # Jump to process the array after filling it

read_input:
    # Prompt for input at the current index of array A
    li $v0, 4
    la $a0, inputPrompt
    syscall

    # Output the current index
    move $a0, $t3
    li $v0, 1
    syscall

    # Output the closing bracket
    li $v0, 4
    la $a0, closingBracket
    syscall

    # Read the integer input from the user
    li $v0, 5
    syscall
    sw $v0, 0($t0)            # Store the input integer in array A at the current index

    # Update the index and array address for the next input
    addiu $t0, $t0, 4         # Move to the next word in array A
    addiu $t3, $t3, 1         # Increment the index i
    j input_loop              # Jump back to continue the input loop

process_array:
    # Reset the addresses of arrays A and B and the index i for processing
    la $t0, A                 # Load the base address of array A into $t0
    la $t1, B                 # Load the base address of array B into $t1
    li $t3, 0                 # Reset the index i to 0

    # Multiply each element of array A by 10 if even or by 5 if odd
    # Store the result in the corresponding element of array B
loop:
    bge $t3, $t2, exit  # Check if the end of the array is reached

    lw $t4, 0($t0)      # Load the current element of A into $t4

    andi $t5, $t4, 1    # Check if the element is odd (1) or even (0)
    beqz $t5, even      # If even, jump to 'even' label

odd:
    # If odd, multiply by 5
    li $t6, 5
    mul $t4, $t4, $t6   # Multiply the current element by 5
    j store_result

even:
    # If even, multiply by 10
    li $t6, 10
    mul $t4, $t4, $t6   # Multiply the current element by 10

store_result:
    sw $t4, 0($t1)      # Store the result in the corresponding element of B

        # Update pointers and index for the next iteration
    addiu $t0, $t0, 4   # Move to the next element in A
    addiu $t1, $t1, 4   # Move to the next element in B
    addiu $t3, $t3, 1   # Increment the index
    bge $t3, $t2, display_results  # If done with all elements, proceed to display results
    j loop              # Otherwise, continue the loop

# The 'j display_results' instruction is not needed here since we'll flow into 'display_results' naturally

display_results:
    li $v0, 4
    la $a0, resultMsg      # Introduce the results
    syscall

    la $t1, B              # Reset $t1 to point at the start of array B
    li $t3, 0              # Reset index i to 0 for the display loop

result_loop:
    bge $t3, $t2, exit     # Check if all results have been displayed

    lw $a0, 0($t1)         # Load and print each element of array B
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, space          # Print a space for separation
    syscall

    addiu $t1, $t1, 4      # Increment to the next element
    addiu $t3, $t3, 1
    j result_loop

exit:
    # Exit label and termination of the program
    li $v0, 10                # Load the code for exit syscall into $v0
    syscall                   # Execute the syscall to terminate the program
