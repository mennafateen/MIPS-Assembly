.data
	array: .space 40 #array of entered numbers
	array2: .space 40 #copy of array
	mssg: .asciiz "Enter a number: "
	mssg2: .asciiz "Enter the number to search for: "
	value: .word 0
	high: .word 9
	low: .word 0
	result: .word 0 # stores returned value of function - the index of the value in the array
	foundmssg: .asciiz "Number found at: "
	notfoundmssg: .asciiz "Number not found :("

.text
.globl main
main:
	add $t0, $t0, $0 #index counter
	while:
		li $v0, 4 #prompt for input
		la $a0, mssg
		syscall
		li $v0, 5 #get input
		syscall
		sw $v0, array($t0)
		addi $t0, $t0, 4 # increment counter
		beq $t0, 40, continue # if counter == 40 break loop
		j while # else continue looping
	continue:
		li $v0, 4 #prompt for value
		la $a0, mssg2
		syscall
		li $v0, 5 #enter value to search for
		syscall
		sw $v0, value #store user input in value
		la $a0, array #parameters for binary search
		lw $a1, value
		lw $a2, low
		lw $a3, high
		jal binarySearch
		sw $v0, result
		lw $a0, result
		beq $a0, -1, notfound
		li $v0, 4 #prints "value found at.."
		la $a0, foundmssg
		syscall
		li $v0, 1 #prints index of value
		lw $a0, result
		syscall
		li $v0, 10
		syscall
	notfound:
		li $v0, 4
		la $a0, notfoundmssg
		syscall

		li $v0, 10
		syscall
		
#---------------------------------------- end of main

binarySearch:
	addi $sp, $sp, -4 # ra
	sw $ra, 0($sp)
	
	addi $t2, $t2, 1 #counter
	add $t6, $0, $a0 #base address
	blt $a3, $a2, end #if high < low
	add $t1, $a2, $a3 #calculating midpoint
	div $t1, $t1, 2 #t1 = mid
	mul $t3, $t1, 4 #mulitply by 4 to get address
	add $t3, $t6, $t3 #t3 = address
	lw $t4, 0($t3) #t4 holds array[mid]
	bgt $t4, $a1, greater #if array[mid] > value
	blt $t4, $a1, less #if array[mid] < value
	addi $v0, $t1, 0 #return mid

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	# return mid
	
greater:
	# return bsearch(array, value, low, mid - 1)
	subi $t1, $t1, 1
	#move $s3, $a3
	addi $a3, $t1, 0 #last argument is mid - 1
	jal binarySearch
	j done
less:
	addi $t1, $t1, 1
	#move $s2, $a2
	addi $a2, $t1, 0 # 3rd arg is mid + 1 - all the rest are the same
	jal binarySearch
	j done

	
end:
	addi $v0, $0, -1
	done:
		lw $ra 0($sp)
		addi $sp, $sp, 4
		jr $ra
	
	
	
		
		