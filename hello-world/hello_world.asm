default rel                 ; what is this?

section .rodata             ; presumably read-only data
msg: db "Hello, World!", 0  ; msg is label for null-terminated string

section .text               ; executable portion of code
global hello                ; export symbol hello?
hello:
    lea rax, [msg]          ; put address of label msg into RAX. 
    ret                     ; is RAX how C func return value?
