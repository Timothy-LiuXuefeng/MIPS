# $s0: i;   $s1: infile;    $s1: outile;    $s1: id
# $s2: max_num;     $s3: buffer

.data
    in_file: .asciiz "./a.in"
    out_file: .asciiz "./a.out"
.text
    move $s2, $0        # max_num = 0
    li $a0, 8     # new 8 bytes
    li $v0, 9     # new
    syscall
    move $s3, $v0   # save the address into buffer

    li $v0, 13    # open file
    la $a0, in_file
    li $a1, 0       # read flag
    li $s2, 0       # ignored
    syscall
    move $s1, $v0   # save id
    move $a0, $s1   # load infile id
    move $a1, $s3
    li $a2, 8     # maximum bytes to read
    li $v0, 14
    syscall         # read
    li $v0, 16
    move $a0, $s1
    syscall         # close file

    li $v0, 5
    syscall
    move $s0, $v0   # input i

    move $s2, $s0   # max_num = i
    li $s1, 0       # id = 0

for:
    slti $t0, $s1, 2    # id < 2
    beq $0, $t0, endfor
    sll $t0, $s1, 2     # id * 2
    add $t0, $s3, $t0   # buffer + id * 4
    lw $t0, 0($t0)      # get buffer[id]
    slt $t1, $s2, $t0   # max_num < buffer[id]
    beq $t1, $0, endupdate  # if above is false, goto endupdate
    update:
        move $s2, $t0
    endupdate:
    addi $s1, $s1, 1
    j for
endfor:
    sw $s2, 0($s3)      # save max_num into buffer[0]
    move $a0, $s2
    li $v0, 1
    syscall             # print buffer[0]

    li $v0, 13
    la $a0, out_file
    li $a1, 1           # write flag
    li $a2, 0           # ignored
    syscall
    move $s1, $v0       # save file id

    move $a0, $s1       # write to file
    move $a1, $s3
    li $a2, 4
    li $v0, 15
    syscall

    move $a0, $s1
    li $v0, 16
    syscall             # close out file
    addi $v0, $0, 17
    addi $a0, $0, 0         # return 0
    syscall                 # exit
