# $s0: i; $s1: j;$s2: sum

.text
main:
    move $s2, $0     # sum = 0
    addi $v0, $0, 5
    syscall         # read i
    move $s0, $v0
    addi $v0, $0, 5
    syscall         # read j
    move $s1, $v0
    
    bltz $s0, revi  # if i < 0
    j endrevi
revi:
    sub $s0, $0, $s0    # i = -i
endrevi:

    bltz $s1, revj  # if j < 0
    j endrevj
revj:
    sub $s1, $0, $s1    # j = -j
endrevj:

    slt $t0, $s0, $s1   # if i < j, $t0 = 1
    beq $t0, $0, afterswap
swap:                   # swap i and j
    move $t0, $s0
    move $s0, $s1
    move $s1, $t0

afterswap:
    move $t0, $0    # temp = 0
for:
    slt $t1, $s1, $t0
    bne $t1, $0, endfor     # if j < temp, end for
    add $s2, $s2, $t0       # sum += temp
    addi $t0, $t0, 1        # ++temp
    j for
endfor:
    addi $v0, $0, 1
    move $a0, $s2
    syscall                 # print sum
    addi $v0, $0, 17
    addi $a0, $0, 0         # return 0
    syscall                 # exit
