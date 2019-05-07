.data
msg:
    .asciz "Begin Heap value: %d - Head Heap value: %d | Heap Size: %d!\n"
heapmapmsg:
    .asciz "Heap map:|"
alocmsg:
    .asciz "\nValue to alocate: %d!\n"
dealocmsg:
    .asciz "\nValue to dealocate: %d!\n"
fusionmsg:
    .asciz "\nRunning free nodes fusion!\n"
managerformat:
    .asciz "#%d"
ocupformat:
    .asciz "+%d|"
freeformat:
    .asciz "-%d|"
jumplineformat:
    .asciz "\n"
heapbegin: 
    .quad 0
heaphead: 
    .quad 0
heapsize: 
    .quad 0
alocsize:
    .quad 0
alocentry:
    .quad 0
A:
    .quad 0
B: 
    .quad 0
C: 
    .quad 0
.extern printf
.extern flush
.extern puts
.text
.global init_aloc
.global aloc_mem
.global free_mem
.global print_end
.global heap_fus

    
init_aloc:
    movq $0, %rdi
    movq $12, %rax
    syscall
    movq %rax, heapbegin
    movq %rax, heaphead
    ret
    
aloc_mem:
    movq %rdi, %rsi
    addq $16, %rsi #aloc value
    movq $2048, %rbx
    lupe:
        cmpq %rsi, %rbx
        jl double
        jmp ready
        double:
            addq $2048, %rbx
            jmp lupe
    ready:
    movq %rbx, alocsize #save it in aloc global
    movq %rsi, alocentry #save it in aloc global
    movq $alocmsg, %rdi
    xorq  %rax, %rax
    call printf
    movq alocentry, %rsi #aloc value
    movq heapbegin, %rcx #begin address
    movq heaphead, %rdx #head address
    if:
        cmpq %rcx, %rdx #if head=begin then aloc is needed
        jle else
        loop:
            movq 0(%rcx), %rdi
            movq 8(%rcx), %rdi
            cmpq $1, 0(%rcx) #if actual node is in use, go to next
            jne fim_loop
            addq 8(%rcx), %rcx #increase to the next node
            jmp if #go check it again
        fim_loop:
            cmpq %rsi, 8(%rcx) #if actual node size not fits, go to next
            jl fim_loop2
        return_loop:
            movq %rcx, %rdx
            movq $1, 0(%rdx) #set this node in use
            #movq 0(%rdx), %rdi
            movq alocentry, %rsi #aloc value
            movq %rsi, 8(%rdx) #set node size
            #movq 8(%rdx), %rdi
            movq %rdx, %rcx
            quest:
                addq 8(%rcx), %rcx
                cmpq $1, 0(%rcx) #verify if next node is in use
                jne fluxe
                jmp quest
            fluxe:
                movq $0, 0(%rcx) #certify it's zero if not in use
                subq %rsi, %rdi
                cmpq $0, %rdi
                je hard
                movq %rdi, 8(%rcx)
                jmp fim_if
                hard:
                    movq heaphead, %rax 
                    subq %rcx, %rax
                    movq %rax, 8(%rcx)
                    jmp fim_if
                #movq $100, %rdi
                #movq %rdi, 16(%rdx)
                jmp fim_if
            fim_loop2:
                cmpq $0, 8(%rcx) #if tam is 0, means it wasn't used before
                je return_loop
                movq 8(%rcx), %rdi
                addq 8(%rcx), %rcx #increase to the next node
                jmp if #go check it again
        jmp fim_if
    else:
        movq alocsize, %rsi #aloc value
        movq heaphead, %rdi #current head
        movq %rdi, %rdx #save current head
        addq %rsi, %rdi #increase head
        movq $12, %rax #brk code
        syscall
        movq %rax, heaphead #set new head
        movq $1, 0(%rdx) #set this node in use
        movq 0(%rdx), %rdi
        movq alocentry, %rsi #aloc value
        movq %rsi, 8(%rdx) #set node size
        movq 8(%rdx), %rdi
        movq 16(%rdx), %rdi
        movq %rdx, %rcx
        addq 8(%rcx), %rcx
        movq $0, 0(%rcx)
        movq heaphead, %rax #
        subq %rcx, %rax
        movq %rax, 8(%rcx)
        #movq $100, %rdi
        #movq %rdi, 16(%rdx)
    fim_if:
        movq %rdx, %rax #return begin of new allocated node
        ret
    
free_mem:
    movq %rdi, %rsi #node address
    movq $0, 0(%rsi) #set as unused node
    movq $dealocmsg, %rdi
    xorq  %rax, %rax
    call printf
    xorq  %rdi, %rdi
    ret
    
heap_fus:
    pushq %rbp
    movq %rsp, %rbp
    movq 16(%rbp), %rbx
    movq heaphead, %rdx
    luup:
        cmpq %rbx, %rdx
        jle fim_luup
        cmpq $0, 0(%rbx)
        jne gotonext
        movq %rbx, %rcx
        addq 8(%rcx), %rcx
        cmpq %rcx, %rdx
        jle fim_luup
        cmpq $0, 0(%rcx)
        jne gotonext
        movq 8(%rbx), %rax
        addq 8(%rcx), %rax
        movq %rax, 8(%rbx) #if finds two consecutives free nodes, fusion
        pushq %rbx
        call heap_fus
        popq %rbx
        jmp fim_luup
        gotonext:
            movq 8(%rbx), %rax
            addq %rax, %rbx
            jmp luup
    fim_luup:
    popq %rbp
    ret
    
print_end:
    movq heaphead, %rdx
    movq heapbegin, %rsi
    movq %rdx, %rcx
    subq %rsi, %rcx
    movq %rcx, heapsize
    movq $msg, %rdi
    xorq  %rax, %rax
    call printf #print heap begin, head and size
    movq $heapmapmsg, %rdi
    xorq  %rax, %rax
    call printf
    movq heapbegin, %rbx
    loope:
        movq heaphead, %r8
        cmpq %rbx, %r8
        jle fim_loope
        movq $managerformat, %rdi
        movq 0(%rbx), %rsi
        xorq  %rax, %rax
        call printf #print ocuppied byte
        movq $managerformat, %rdi
        movq 8(%rbx), %rsi
        xorq  %rax, %rax
        call printf #print size byte
            cmpq $1, 0(%rbx)
            jne free_byte
            movq 16(%rbx), %rsi
            movq $ocupformat, %rdi #print content byte
            xorq  %rax, %rax
            call printf
            jmp fim_check
        free_byte:
            movq 16(%rbx), %rsi
            movq $freeformat, %rdi #print content byte
            xorq  %rax, %rax
            call printf
        fim_check:
        addq 8(%rbx), %rbx
        jmp loope
    fim_loope:
    movq $jumplineformat, %rdi
    xorq  %rax, %rax
    call printf
    ret
    
