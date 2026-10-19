	.file	"asgn5.c"
	.text
	.section	.rodata
.LC0:					#here we start the label for the printf string
	.string	"%d "		#here we store the printf format string for an int followed by a space
	.text
	.globl	main
	.type	main, @function
main:					#obviously our start of main
.LFB0:					# a compiler lable for the start of main
	.cfi_startproc
	endbr64				# marks a valid indirect call/jump target
	pushq	%rbp		#saves the caller's 64 bit frame pointer and rsp decreases by 8
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#set rbp to the current stack pointer rsp as the frame base for main
	.cfi_def_cfa_register 6
	subq	$48, %rsp		#Reserves 48 bytes of stack space for main
	movq	%fs:40, %rax	#now we load the 8 byte stack canary into rax
	movq	%rax, -8(%rbp)	# we save that same canary at rbp-8
	xorl	%eax, %eax		#and then we clear 32 bit eax to zero which also clears rax.
	movl	$-3, -32(%rbp)	#myarr[0] = -3
	movl	$0, -28(%rbp)	#myarr[1] = 0
	movl	$2, -24(%rbp)	#myarr[2] = 2
	movl	$4, -20(%rbp)	#myarr[3] = 4
	movl	$5, -16(%rbp)	#myarr[4] = 5
	movl	$0, -40(%rbp)	#initilize a 4 byte loop index i = 0
	jmp	.L2					#checks condition before entering loop
.L3:						#this is the start of the squaring loop body
	movl -40(%rbp), %eax       		# Load 32-bit loop index i into eax
    cltq                      		# Sign-extend i from 32-bit eax to 64-bit rax
    leaq 	0(,%rax,4), %rdx      	# rdx = i * 4, the byte offset
    leaq 	-32(%rbp), %rax       	# rax = address of myarr[0]
    addq 	%rdx, %rax         		# rax = address of myarr[i]
    movl 	(%rax), %edx       		# Load the 4-byte myarr[i] value into edx
	movl	-40(%rbp), %eax			# load the 32-bit loop index i into eax
	cltq							# sign-extend i from 32-bit eax into 64-bit rax
	leaq	0(,%rax,4), %rcx		# rcx = i * 4, the byte offset
	leaq	-32(%rbp), %rax			# rax = address of myarr[0]
	addq	%rcx, %rax				# rax = address of myarr[i]
	movl	(%rax), %eax			# load the 4-byte myarr[i] value into eax
	movl	-40(%rbp), %ecx			# load the 32-bit loop index i into ecx
	movslq	%ecx, %rcx				# sign-extend i from 32-bit ecx into 64-bit rcx
	leaq	0(,%rcx,4), %rsi		# rsi = i * 4, the byte offset
	leaq	-32(%rbp), %rcx			# rcx = address of myarr[0]
	addq	%rsi, %rcx				# rcx = address of myarr[i], where the square will be stored
	imull	%edx, %eax				# multiply the two 32-bit copies of myarr[i]; eax holds the square
	movl	%eax, (%rcx)			# store the 4-byte square back into myarr[i]
	addl	$1, -40(%rbp)			# increment the 4-byte squaring loop index i by 1
.L2:								# the squaring loop condition
	cmpl	$4, -40(%rbp)			#compare the 32 bit i with 4
	jle	.L3							#executes the body if i <=4
	movl	$0, -36(%rbp)			# initialize the 4-byte printing loop index i = 0
	jmp	.L4							# go to the printing loop condition before entering the body
.L5:								# this is the start of the printing loop body
	movl	-36(%rbp), %eax			# load the 32-bit printing loop index i into eax
	cltq							# sign-extend i from 32-bit eax into 64-bit rax
	movl	-32(%rbp,%rax,4), %eax	# load 4-byte myarr[i] from rbp - 32 + i * 4 into eax
	movl	%eax, %esi				# put myarr[i] in esi as the second argument to printf
	leaq	.LC0(%rip), %rax		# load the 64-bit address of the printf format string into rax
	movq	%rax, %rdi				# put the format string address in rdi as the first printf argument
	movl	$0, %eax				# set eax to 0 because printf receives no vector-register arguments
	call	printf@PLT				# call printf to print the current integer followed by a space
	addl	$1, -36(%rbp)			# increment the 4-byte printing loop index i by 1
.L4:								# this is the printing loop condition
	cmpl	$4, -36(%rbp)			# compare the 32-bit printing loop index i with 4
	jle	.L5							# repeat the printing loop body while i <= 4
	movl	$10, %edi				# put newline character code 10 in edi as the first putchar argument
	call	putchar@PLT				# print the newline; GCC uses putchar for the C newline printf
	movl	$0, %eax				# set the 32-bit return value of main to 0
	movq	-8(%rbp), %rdx			# load the saved 8-byte stack canary into rdx
	subq	%fs:40, %rdx			# subtract the current canary from the saved one; zero means they match
	je	.L7							# go to the normal return if the stack canary is unchanged
	call	__stack_chk_fail@PLT	# report stack corruption and stop if the canary changed
.L7:								# normal function exit after the canary check
	leave							# set rsp to rbp, then pop the saved 64-bit caller frame pointer into rbp
	.cfi_def_cfa 7, 8
	ret								# pop the 8-byte return address and return control to the caller
	.cfi_endproc
.LFE0:								# compiler label for the end of main
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
