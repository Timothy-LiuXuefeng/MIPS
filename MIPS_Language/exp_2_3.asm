.data
    inputfile: .asciiz "./test.dat"
.text
    j main

knapsack_dp_recursion:
    
    # save $ra and $sx

    addi, $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $ra, 20($sp)

    # copy params
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2

    # val_out: $s3
    # val_in: $s4

    li $v0, 0       # if item_num == 0
    beq $a0, $0, return

    li $t0, 1       # if item_num == 1
    beq $a0, $t0, return_one

    j end_return_one
return_one:
    lw $t0, 0($s1)
    slt $t0, $s2, $t0
    li $v0, 0       # return0
    beqz $t0, return_item_list_zero
    j return
return_item_list_zero:
    lw $v0, 4($s1)  # return item_list[0]
    j return
end_return_one:

    # val_out
    move $a2, $s2
    addi $a1, $s1, 8
    addi $a0, $s0, -1
    jal knapsack_dp_recursion
    move $s3, $v0

    # val_in
    lw $a2, 0($s1)
    sub $a2, $s2, $a2
    addi $a1, $s1, 8
    addi $a0, $s0, -1
    jal knapsack_dp_recursion
    lw $s4, 4($s1)
    add $s4, $s4, $v0

    move $v0, $s3   # val out may be more likely to be returned
    lw $t0, 0($s1)
    slt $t0, $s2, $t0
    bnez $t0, return  # if knapsack_capacity < item_list[0].weight

    slt $t0, $s4, $s3   # if val_in < val_out
    bnez $t0, return

return_val_in:

    move $v0, $s4
    
return:

    # restore $ra and $sx

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24

    jr $ra

# ===========================================

main:
    # infile: $s0
    # in_buffer: $s1

    # allocate for in_buffer on stack

    addi $sp, $sp, -2048
    move $s1, $sp

    #open file

    la $a0, inputfile
    li $a1, 0
    li $a2, 0
    li $v0, 13
    syscall
    move $s0, $v0

    # read from file

    move $a0, $s0
    move $a1, $s1
    li $a2, 2048
    li $v0, 14
    syscall

    # close file

    move $a0, $s0
    li $v0, 16
    syscall

    # call knapsack_dp_loop

    lw, $a2, 0($s1)
    addi, $a1, $s1, 8
    lw, $a0, 4($s1)
    jal knapsack_dp_recursion
    move $s0, $v0

    # print result

    move $a0, $s0
    li $v0, 1
    syscall

    # store the value into $v0

    move $v0, $s0

    # deallocate in_buffer

    addi $sp, $sp, 2048
