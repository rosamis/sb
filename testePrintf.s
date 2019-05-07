string:
	.string "Hello World\n"
	.text
	.globl	main
main:
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movq	$string, %rdi
	movq	$0, %rax
	call	printf
# Coloca 0 no reg que define a saída do programa
	movq	$0, %rax
	syscall
