# swap_case.asm program
# For CMPSC 64
#
# Data Area
.data
    buffer: .space 100
    input_prompt:   .asciiz "Enter string:\n"
    output_prompt:   .asciiz "Output:\n"
    convention: .asciiz "Convention Check\n"
    newline:    .asciiz "\n"
    

.text

#
# DO NOT MODIFY THE MAIN PROGRAM 
#       OR ANY OF THE CODE BELOW, WITH 1 EXCEPTION!!!
# YOU SHOULD ONLY MODIFY THE SwapCase FUNCTION 
#       AT THE BOTTOM OF THIS CODE
#
main:
    la $a0, input_prompt    # prompt user for string input
    li $v0, 4
    syscall

    li $v0, 8       # take in input
    la $a0, buffer
    li $a1, 100
    syscall
    move $s0, $a0   # save string to s0

    ori $s1, $0, 0
    ori $s2, $0, 0
    ori $s3, $0, 0
    ori $s4, $0, 0
    ori $s5, $0, 0
    ori $s6, $0, 0
    ori $s7, $0, 0

    move $a0, $s0
    jal SwapCase

    add $s1, $s1, $s2
    add $s1, $s1, $s3
    add $s1, $s1, $s4
    add $s1, $s1, $s5
    add $s1, $s1, $s6
    add $s1, $s1, $s7
    add $s0, $s0, $s1

    la $a0, output_prompt    # give Output prompt
    li $v0, 4
    syscall

    move $a0, $s0
    jal DispString

    j Exit

DispString:
    addi $a0, $a0, 0
    li $v0, 4
    syscall
    jr $ra

ConventionCheck:
    addi    $t0, $0, -1
    addi    $t1, $0, -1
    addi    $t2, $0, -1
    addi    $t3, $0, -1
    addi    $t4, $0, -1
    addi    $t5, $0, -1
    addi    $t6, $0, -1
    addi    $t7, $0, -1
    ori     $v0, $0, 4
    la      $a0, convention
    syscall
    addi    $v0, $zero, -1
    addi    $v1, $zero, -1
    addi    $a0, $zero, -1
    addi    $a1, $zero, -1
    addi    $a2, $zero, -1
    addi    $a3, $zero, -1
    addi    $k0, $zero, -1
    addi    $k1, $zero, -1
    jr      $ra
    
Exit:
    ori     $v0, $0, 10
    syscall

# COPYFROMHERE - DO NOT REMOVE THIS LINE

# YOU CAN ONLY MODIFY THIS FILE FROM THIS POINT ONWARDS:
printCharWithNewline:
    # a0 is chrachter
    li $v0, 11
    syscall
    la $a0, newline
    li $v0, 4
    syscall
    jr $ra

SwapCase:
    #TODO: write your code here, $a0 stores the address of the string
    # we only need one saved register for the actual address, otherwise we don't care, so only preserve s0 and ra
    addiu $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    # address of the string is now stored in s0 to avoid Convention Check issues - ra is also there
    # Return address accessible at $sp + 4
    # s0 accessible at $sp
    # s0 contains string address
    move $s0, $a0
swapCaseLoopStart:
    # use $t0 as current char / ubyte
    # t1 is watching out for newline
    li $t1, 10
    lbu $t0, 0($s0)
    beq $t0, $t1, swapCaseLoopEnd # end when newline
    
    # if is upper then print
    # isupper(t0) == 65 <= t0 <= 90 == 64 < t0 < 91
    # 64 < t0
    li $t1, 64
    slt $t1, $t1, $t0 # t1 = t1 < t0 == 64 < t0
    # t0 < 91
    li $t2, 91
    slt $t2, $t0, $t2 # t2 = t0 < t2 == t0 < 91

    and $t1, $t1, $t2 # t1 = t1 & t2 == t1 < t0 & t0 < t2 == 64 < t0 & t0 < 91 == isupper(t0)
    beq $t1, $0, swapCaseCharIsNotUpper
    # executes if and only if t0 is an uppercase letter
    #print normal
    move $a0, $t0
    jal printCharWithNewline
    # swap case
    addiu $t0, $t0, 32
    move $a0, $t0
    jal printCharWithNewline
    sb $t0, 0($s0) #store it
    jal ConventionCheck
    j swapCaseLoopIterate
swapCaseCharIsNotUpper:
    # check if is lower case char
    # islower(t0) == 97 <= t0 <= 122 == 96 < t0 < 123
    # 96 < t0
    li $t1, 96
    slt $t1, $t1, $t0 # t1 = t1 < t0 == 96 < t0
    # t0 < 123
    li $t2, 123
    slt $t2, $t0, $t2 # t2 = t0 < t2 == t0 < 123

    and $t1, $t1, $t2 # t1 = t1 & t2 == t1 < t0 & t0 < t2 == 96 < t0 & t0 < 123 == islower(t0)
    beq $t1, $0, swapCaseLoopIterate # skip if is not a letter
    #print normal
    move $a0, $t0
    jal printCharWithNewline
    # swap case
    addiu $t0, $t0, -32
    move $a0, $t0
    jal printCharWithNewline
    sb $t0, 0($s0)
    jal ConventionCheck
swapCaseLoopIterate:
    addiu $s0, $s0, 1
    j swapCaseLoopStart
swapCaseLoopEnd:
    # load back s0 and ra
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addiu $sp, $sp, 8

    # Do not remove the "jr $ra" line below!!!
    # It should be the last line in your function code!
    jr $ra
