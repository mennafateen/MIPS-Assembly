.data
	array: .space 40
	beginmssg: .asciiz "Enter 10 numbers: "
	sortedmssg: .asciiz "Sorted numbers: "
	size: .word 10
	space: .asciiz " "
	endl: .asciiz "\n"

.text
.globl main
#---------------------------------------
main:
	li $v0, 4 # prints "Enter 10 numbers: "
	la $a0, beginmssg
	syscall 
	
	addi $t0, $t0, 0 # loop counter
	while:
		li $v0, 5
		syscall
		sw $v0, array($t0) # store user number in array[i]
		addi $t0, $t0, 4 # increment i by 4 bc int
		beq $t0, 40, continue # if counter == 40 get out of loop
		j while # else go to while again
	continue:
		la $a0, array #load parameters for selectionSort
		lw $a1, size
		jal selectionSort
		#-------- called function
	printArray:
	
		li $v0, 4
		la $a0, sortedmssg #print "Sorted numbers: "
		syscall
		addi $t0, $0, 0 # loop counter again, i
		print:
			li $v0, 1
			lw $a0, array($t0) #print array[i]
			syscall
			
			li $v0, 4 # print a space  
			la $a0, space
			syscall
			
			addi $t0, $t0, 4
			beq $t0, 40, exit
			j print
		
		exit:
		li $v0, 10
		syscall
		
#------------------------------------------------------- end of main

selectionSort: #takes two parameters, a0 = address of array, a1 = size of array
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#------------
	
	addi $s1, $0, 0 #holds index of max
	addi $s3, $0, 0 #for loop
	mul $s7, $a1, 4 # s7 = size * 4
	for:
		beq $s3, $s7 , exit2 # if i == s0 exit
		add $s5, $a0, $s1 # arr[max] address
		lw $t5, 0($s5) #get number from address
		add $s4, $a0, $s3 # arr[i]
		lw $t4, 0($s4) # get number from address
		bgt $t4, $t5, greater # if arr[i] > arr[max]
		addi $s3, $s3, 4 #increment
		j for
		greater:
			addi $s1, $s3, 0 # max = i
			addi $s3, $s3, 4 #increment
			j for
	exit2:	

	subi $s6, $a1, 1 # t6 = size - 1
	sll $s6, $s6, 2 # multiply by 4 to get size - 1 (using the cool indirect way lol)
	add $s6, $a0, $s6 # add to base address to get actual address
	#sll $s1, $s1, 2 # same for max
	add $s1, $a0, $s1 # same
	
	li $s0, 0
	li $s2, 0

	lw $s0, 0($s1) # temp = arr[max] 
	lw $s2, 0($s6) # temp2 = arr[size - 1]
	
	sw $s2, 0($s1)
	sw $s0, 0($s6)
	
	ble $a1, 1 go
	#-----------
	addi $a1, $a1, -1
	jal selectionSort
	go: 
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	 

	
	
		
		
