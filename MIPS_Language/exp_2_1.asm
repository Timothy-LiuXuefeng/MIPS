.data
    inputfile: .asciiz "./test.dat"
.text
    j main
knapsack_dp_loop:

    # save $ra and $sn
    subi $sp, $sp, 16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    # cache_ptr: $s0
    # weight: $s1
    # val: $s2

    # allocate space for cache_ptr

    subi $sp, $sp, 256
    move $s0, $sp

    # set cache_ptr to 0
    # for (i = 0; i < 64; ++i)
    #   cache_ptr[i] = 0

    # i: $t0
    li $t0, 0
set_cache_ptr_zero_for:
    # compare of for-loop
    slti $t1, $t0, 64
    beq $t1, $0, end_set_cache_ptr_zero_for

    # loop: set to zero
    sll $t1, $t0, 2
    add $t1, $t1, $s0
    sw $0, 0($t1)

    addi $t0, $t0, 1
    j set_cache_ptr_zero_for
end_set_cache_ptr_zero_for:

    # i: $t0
    # j: $t1
    li $t0, 0
for_i:
    # for_i: judge

    slt $t2, $t0, $a0
    beq $t2, $0, end_for_i

    # for_i: loop

    sll $t2, $t0, 3     # i * 8
    add $t2, $t2, $a1
    lw $s1, 0($t2)      # get $s1: weight
    lw $s2, 4($t2)      # get $s2: val

    # store the address of cache_ptr[j] in $t3
    # and cache[j - weight] in $t4

    sll $t3, $a2, 2     # knap_cap * 4
    add $t3, $t3, $s0

    sub $t4, $a2, $s1   # knap_cap - weight
    sll $t4, $t4, 2
    add $t4, $t4, $s0

    # j = knapsack_capacity
move $t1, $a2
for_j:
    # for_j: judge

    slt $t2, $t1, $0
    bne $t2, $0, end_for_j

    # loop_j

    # if (j >= weight)
    slt $t2, $t1, $s1
    bne $t2, $0, end_if_j_geq_weight

    lw $t5, 0($t3)      # cache_ptr[j]
    lw $t6, 0($t4)      # cache_ptr[j - weight]
    add $t6, $t6, $s2   # cache_ptr[j - weight] + val

    slt $t7, $t6, $t5
    beq $t7, $0, put_tsix_to_j
    j end_put_tsix_to_j
put_tsix_to_j:
    sw $t6, 0($t3)
end_put_tsix_to_j:

end_if_j_geq_weight:

    # for_j: --j
    addi $t3, $t3, -4
    addi $t4, $t4, -4
    addi $t1, $t1, -1
    j for_j
end_for_j:

    # for_i: ++i
    addi $t0, $t0, 1
    j for_i
end_for_i:

    # return value

    sll $v0, $a2, 2
    add $v0, $v0, $s0
    lw $v0, 0($v0)

    # destruct cache_ptr
    addi $sp, $sp, 256

    # restore $ra and $sn

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16

    jr $ra

# ====================================================

main:
    # infile: $s0
    # in_buffer: $s1
    # item_num: $s2

    # alloc for in_buffer on stack

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
    jal knapsack_dp_loop
    move $s0, $v0

    # print result

    move $a0, $s0
    li $v0, 1
    syscall

    # store the value into $v0

    move $v0, $s0

    # restore stack

    addi $sp, $sp, 2048
