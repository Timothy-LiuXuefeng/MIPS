# $s0: a;   $s1: n;     $t0: i;
.data
    space: .asciiz " "
.text
    li $v0, 5   # read n
    syscall
    move $s1, $v0

    sll $a0, $s1, 2 # a0 = n * 4
    li $v0, 9       # heap alloc
    syscall
    move $s0, $v0

    li $t0, 0       # for i = 0
    move $t3, $s0   # save the address of a into $t3
input:
    slt $t2, $t0, $s1
    beq $t2, $0, endinput

    li $v0, 5       # read a[i]
    syscall
    sw $v0, 0($t3)
    
    addi $t3, $t3, 4
    addi $t0, $t0, 1
    j input
endinput:

    li $t0, 0       # for i = 0
    move $t3, $s0   # save the address of a into t3
    addi $t4, $s1, -1   # calculate n - 1
    sll $t4, $t4, 2      # calculate (n - 1) * 4
    add $t4, $s0, $t4   # save the address of a[n - 1] into $t4
    srl $t5, $s1, 1 # save n / 2 into t5
exchange:
    slt $t1, $t0, $t5   # i < n / 2
    beq $t1, $0, endexchange

    lw $t1, 0($t3)  # t = a[i]
    lw $t2, 0($t4)  # get a[n - i - 1]
    sw $t2, 0($t3)  # a[i] = a[n - i - 1]
    sw $t1, 0($t4)  # a[n - i - 1] = t

    addi $t4, $t4, -4
    addi $t3, $t3, 4 
    addi $t0, $t0, 1
    j exchange
endexchange:

    li $t0, 0       # for i = 0
    move $t3, $s0   # save the address of a into t3
print:
    slt $t2, $t0, $s1
    beq $t2, $0, endprint

    lw $a0, 0($t3)  # print %d
    li $v0, 1
    syscall

    la $a0, space
    li $v0, 4
    syscall

    addi $t3, $t3, 4
    addi $t0, $t0, 1
    j print
endprint:
    li $v0, 17
    li $a0, 0           # return 0
    syscall             # exit
