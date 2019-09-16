;default rel

; How to execute tests marked with TEST_IGNORE() in two_fer_test.c?
; I just commented out TEST_IGNORE() in two_fer_test.c

section .rodata

msg1: db "One for " 
msg1_len equ $-msg1

msg2: db ", one for me.",0
msg2_len equ $-msg2

msg_you: db "you"
msg_you_len equ $-msg_you

section .text

; parameters from C call
; 1st:    rdi=input
; 2nd:    rsi=output
; return: rax
;
; see page 21 https://www.uclibc.org/docs/psABI-x86_64.pdf
;
; called function is required to preserve: rbp, rbx, r12, r13, r14, r15.
;
global two_fer
two_fer:

    mov rax, rdi ; rax=input
    mov rdx, rsi ; rdx=output

    ;
    ; copy first part of string into output buffer
    ;
    cld               ; make sure that movsb copies forward
    mov rdi, rsi
    mov rsi, msg1
    mov rcx, msg1_len
    rep movsb         ; memcpy(rdi, rsi, rcx)

    cmp rax, 0
    jne copy_input

    ;
    ; copy "you" into output buffer
    ;
    mov rsi, msg_you
    mov rcx, msg_you_len
    rep movsb         ; memcpy(rdi, rsi, rcx)
    jmp done          ; skip copy input

    ;
    ; copy input string into output buffer
    ;
copy_input:
    mov rsi, rax
copy_loop:
    mov cl, [rsi]          
    cmp cl, 0
    je  done
    mov [rdi], cl
    inc rsi
    inc rdi
    jmp copy_loop
done:

    ;
    ; copy second part of string into output buffer
    ;
    mov rsi, msg2
    mov rcx, msg2_len
    rep movsb         ; memcpy(rdi, rsi, rcx)

    mov rax, rdx      ; return output buffer

    ret
