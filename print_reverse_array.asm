# print_array.asm program
# For CMPSC 64
#
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0

.data
	array: # Write the definition here
		.word 3 41 4 5 6 9 10 31 3 1
	cout:  # Write the definition here
		.asciiz "The contents of the array are:\n"
	newline:
		.asciiz "\n"

.text
printArr:
	#t1 = a[] + al - 1 (arr + size - 1), $t0 = a (terminating ptr)
	move $t0, $a0
	sll $a1, $a1, 2 # account for bytes - al *= 4
	addiu $a1, $a1, -4
	addu $t1, $a0, $a1 # t1 is i, t0 is 0
printArrLoopStart:
	blt $t1, $t0, printArrLoopEnd
	lw $a0, 0($t1)
	li $v0, 1
	syscall
	la $a0, newline
	li $v0, 4
	syscall
	addiu $t1, $t1, -4
	j printArrLoopStart
printArrLoopEnd:
	jr $ra


main:  # DO NOT MODIFY THE MAIN SECTION
	li $v0, 4
	la $a0, cout
	syscall

	la $a0, array
	li $a1, 10

	jal printArr

exit:
	li $v0, 10
	syscall

