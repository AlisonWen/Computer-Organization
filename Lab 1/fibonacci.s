.data
argument: .word 7 # Number to find the factorial value of
str1: .string " the number in the Fibonacci sequence is "

.text
main:
        lw       a0, argument     
        lw       a1, argument              
        jal      ra, Fibonacci                       

        # Print the result to console
        mv       a1, a0                         
        lw       a0, argument                   
        jal      ra, printResult                

        # Exit program
        li       a7, 10                         
        ecall                                  
Fibonacci:
	mv t2, a1
    addi t2, t2, -2
	bge t2, zero, nFibonacci

	mv a0, a1
	jr ra
nFibonacci:
	addi sp, sp, -12
	sw ra, 4(sp)
	sw a1, 0(sp)

	addi a1, a1, -1
	jal Fibonacci
	
	lw a1, 0(sp)
	sw a0, 8(sp)

	addi a1, a1, -2
	jal Fibonacci

	lw t0, 8(sp)
	add a0, a0, t0

	lw ra, 4(sp)
	addi sp, sp, 12
	jr ra
printResult:
	mv t0, a0
	mv t1, a1

	mv a0, t0
	li a7, 1
	ecall

	la a0, str1
	li a7, 4
	ecall

	mv a0, t1
	li a7, 1
	ecall
	ret