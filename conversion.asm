# conversion.asm program
# For CMPSC 64
#
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0
#
# int conv(int x, int y){
#   int z = 0;
#   for (int i = 0; i < 8; i++) {
#       z = z - 8*x + y;
#       if (x >= 2)
#       y -= 1;
#       x += 1;
#   }
#   return z;
# }
.text
conv:
    #t0 = z, $t1 = i, $t2 = 8, $a0 = x, $a1 = y
    li $t2, 8
startconvloop:
    bge $t1, $t2 exitconvloop # exit if $t1 >= $t2 <==> i >= 8 => exit loop
    sll $t3, $a0, 3 # put x * 8 -> t3
    sub $t0, $t0, $t3 # t0 - t3 == z - x*8
    add $t0, $t0, $a1 # t0 + a1 == z - x*8 + y
    # now, t3 == 2
    li $t3, 2
    blt $a0, $t3, convloopelse
    addi $a1, $a1, -1
convloopelse:
    addi $a0, $a0, 1
    addi $t1, $t1, 1
    j startconvloop
exitconvloop:
    move $v0, $t0
    jr $ra

main:  # DO NOT MODIFY THE MAIN SECTION
    li $a0, 5
    li $a1, 7

    jal conv

    move $a0, $v0
    li $v0, 1
    syscall

exit:
	li $v0, 10
    syscall
