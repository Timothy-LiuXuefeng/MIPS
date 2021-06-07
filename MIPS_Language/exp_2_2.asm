.data
    inputfile: .asciiz "./test.dat"
.text
    j main
knapsack_search:

    # save $ra and $sx

    addi $sp, $sp -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $ra, 12($sp)

    # val_max: $s0
    # weight: $s1
    # val: $s2

    li $s0, 0   # val_max = 0

    # state_cnt: $t0
    # 0x1 << item_num: $t1
    # for state_cnt = 0
    li $t0, 0
    li $t1, 1
    sllv $t1, $t1, $a0
for_state_cnt:

    # judge: for_state_cnt
    slt $t2, $t0, $t1
    beq $t2, $0, end_for_state_cnt

    # loop in for_state_vnt:

    li $s1, 0
    li $s2, 0

        # i: $t2
        # for i = 0
        li $t2, 0
    for_i:

        # judge in for_i
        slt $t3, $t2, $a0
        beq $t3, $0, end_for_i

        # loop in for_i

        # flag: $t3
        srav $t3, $t0, $t2
        andi $t3, $t3, 1
        bne $t3, $0, update_weight_and_val
        j end_update_weight_and_val

    update_weight_and_val:

        sll $t3, $t2, 3    # i * 8
        add $t3, $t3, $a1
        lw $t4, 0($t3)
        add $s1, $s1, $t4  # update weight
        lw $t4, 4($t3)
        add $s2, $s2, $t4   # update val

    end_update_weight_and_val:

        addi $t2, $t2, 1   # ++i
        j for_i
    end_for_i:

    # judge whether to update val_max

    slt $t2, $a2, $s1   # knap_cap < weight ?
    bne $t2, $0, end_update_val_max
    slt $t2, $s0, $s2
    beq $t2, $0, end_update_val_max

update_val_max:
    move $s0, $s2       # val_max = val
end_update_val_max:

    addi $t0, $t0, 1    # ++state_cnt
    j for_state_cnt
end_for_state_cnt:

    # return value
    move $v0, $s0

    # restore $ra and $sx

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp 16
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
    jal knapsack_search
    move $s0, $v0

    # print result

    move $a0, $s0
    li $v0, 1
    syscall

    # store the value into $v0

    move $v0, $s0

    # deallocate in_buffer

    addi $sp, $sp, 2048
