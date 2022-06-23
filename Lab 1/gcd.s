.data
n1: .word 4
n2: .word 8
 str1: .string "GCD value of "
 str2: .string " and "
 str3: .string " is "

 .text
 main:
    lw a1, n1
    lw a2, n2
    jal ra, gcd
# Print the result to console
    lw a1, n1
    lw a2, n2
    jal ra, printResult
# Exit program
    li a7, 10
    ecall
gcd:
    addi sp, sp, -12
    sw ra, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)

    beq a2, zero, ngcd
    rem a3, a1, a2
    mv a1, a2
    mv a2, a3
    jal gcd

    lw a2, 0(sp)
    lw a1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12
    jr ra

ngcd:
    mv a3, a1
    addi sp, sp, 12
    jr ra
printResult:
    mv t0, a1
    mv t1, a2
    mv t2, a3

    la a0, str1
    li a7, 4
    ecall

    mv a0, t0
    li a7, 1
    ecall

    la a0, str2
    li a7, 4
    ecall

    mv a0, t1
    li a7, 1
    ecall 

    la a0, str3
    li a7, 4
    ecall

    mv a0, t2
    li a7, 1
    ecall