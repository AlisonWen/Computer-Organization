.data 
n: .word 4
arr:  .word 5, 3, 6, 7
arr_size:  .byte 16
str1: .string "Array "
str2: .string "Sorted "
_space: .string " "
newline: .string "\n"
.text
main:

    la a0, str1
    li a7, 4
    ecall
    jal ra, printArray
    
		jal ra, bubble_sort
    
    la a0, str2
    li a7, 4
    ecall

		jal ra, printArray
		li a7, 10                         
    ecall     
bubble_sort:
		addi sp, sp, -16
		sw ra, 0(sp)
		la a0, arr
    lw a5, n
    mv t1, zero
    mv t2, a5
    # t1 = i, t2 = j
    outerloop:
        beq t1, a5, endLoop # i < n
        addi t2, t1, -1 # j = i - 1
        addi t1, t1, 1 # i++

        innerloop:
            blt t2, zero, outerloop # j >= 0
            
            slli t3, t2, 2
            add t4, a0, t3
            
            addi t2, t2, 1 # j++

            slli t5, t2, 2
            add t6, a0, t5

            addi t2, t2, -1 # j--
						# load a2 = arr[i], a3 = arr[i + 1]
            lw a2, 0(t4)
            lw a3, 0(t6)

            addi t2, t2, -1 # j--

            bge a3, a2, innerloop
						# swap
            sw a3, 0(t4)
            sw a2, 0(t6)

            jal s0, innerloop
    endLoop:
    		lw ra, 0(sp)
    		addi sp, sp, 16
        jr ra
printArray:
		lw t6, arr_size
    lb t3, arr_size
    la t1, arr
		addi sp, sp, -16
		sw ra, 0(sp)
	# let t6 be the counter of times and t0 be the printing index
    for:
        lw a0, 0(t1)
        li a7, 1
        ecall
				addi t2, t2, 4

				la a0, _space
				li a7, 4
				ecall
        addi t1, t1, 4
				addi t3, t3, -4
        bne t3, zero, for
	EndLoop:
        la a0, newline
        li a7, 4
        ecall

		lw ra, 0(sp)
		addi sp, sp, 16
		jr ra