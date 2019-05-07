	.section .data
	stringAloca:
		.string "Aloca\n"
	stringLibera:
		.string "Libera\n"
	stringImprime:
		.string "Imprime\n"
	.section .text
	.globl	main
main:
#	pushq	%rbp
	movq	%rsp, %rbp
	movq	$13, %rax
#	popq	%rbp
	call meuAlocaMem
	call meuLiberaMem
	call imprMapa
	ret

.globl meuAlocaMem:
	movq	$stringAloca, %rdi
	call	printf
	ret

.globl meuLiberaMem:
	movq	$stringLibera, %rdi
	call	printf
	ret

.globl imprMapa:
	movq	$stringImprime, %rdi
	call	printf
	ret

# meuLiberaMem
# meuAlocaMem
# imprMapa
