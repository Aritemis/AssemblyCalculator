;Ariana Fairbanks

SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

segment .data 

   msg1 db "Enter the first number.", 0xA, 0xD 
   len1 equ $- msg1 

   msg2 db "Enter the second number.", 0xA, 0xD 
   len2 equ $- msg2 

   msg3 db "1:Add 2:Subtract 3:Multiply 4:Divide", 0xA, 0xD
   len3 equ $- msg3

   msg4 db "The result is "
   len4 equ $- msg4

   msg5 db ".", 0xA
   len5 equ $- msg5

segment .bss

   buffer: resb 3
   num1	   resb 4
   num2    resb 4
   type    resb 1 
   res     resb 4    

section .text
   
   global _start
        
_start:

first:

   mov eax, SYS_WRITE         
   mov ebx, STDOUT         
   mov ecx, msg1         
   mov edx, len1 
   int 0x80
                
   mov eax, SYS_READ 
   mov ebx, STDIN  
   mov ecx, buffer 
   mov edx, 4
   int 0x80            

   mov eax, [buffer]
   call cnvt
   mov [num1], eax   

second:

   mov eax, SYS_WRITE         
   mov ebx, STDOUT         
   mov ecx, msg2         
   mov edx, len2 
   int 0x80      
          
   mov eax, SYS_READ 
   mov ebx, STDIN  
   mov ecx, buffer 
   mov edx, 4
   int 0x80            

   mov eax, [buffer]
   call cnvt
   mov [num2], eax   

selectoperation:

   mov eax, SYS_WRITE         
   mov ebx, STDOUT         
   mov ecx, msg3         
   mov edx, len3 
   int 0x80          
      
   mov eax, SYS_READ 
   mov ebx, STDIN  
   mov ecx, type 
   mov edx, 1
   int 0x80           

   mov eax, SYS_WRITE         
   mov ebx, STDOUT         
   mov ecx, msg4         
   mov edx, len4 
   int 0x80    

   mov eax, [type]
   sub eax, 0x30
   mov [type], eax

   cmp eax, 1
   je op1
   cmp eax, 2
   je op2
   cmp eax, 3
   je op3
   cmp eax, 4
   je op4

op1:

   mov al, [num1]
   mov bl, [num2]
   add al, bl
   mov [res], al
   mov eax, [res]
   jmp result

op2:

   mov al, [num1]
   mov bl, [num2]
   sub al, bl
   mov [res], al
   mov eax, [res]
   jmp result

op3:

   mov al, [num1]
   mov bl, [num2]
   mul bl
   mov [res], ax
   mov eax, [res]
   jmp result

op4:

   xor edx, edx
   mov al, [num1]
   movzx eax, al
   mov bl, [num2]
   movzx ebx, bl
   div ebx
   mov [res], eax

result:

   mov eax, [res]
   call iprnt
   mov eax, SYS_WRITE
   mov ebx, STDOUT
   mov ecx, msg5
   mov edx, len5
   int 0x80

exit:    
   
   mov eax, SYS_EXIT   
   xor ebx, ebx 
   int 0x80

cnvt:

   mov esi, buffer
   mov eax, 0
   mltp:
   xor ebx, ebx
   movzx ebx, byte [esi]
   inc esi
   cmp ebx, 0xA
   je fn
   cmp ebx, 0x30
   mov edx, 10
   mul edx
   add eax, ebx
   jmp mltp
   fn:
   ret

iprnt:

   push eax
   push ecx
   push edx
   push esi
   mov ecx, 0
   dvdlp:
   inc ecx
   mov edx, 0
   mov esi, 10
   div esi
   add edx, 0x30
   push edx
   cmp eax, 0
   jnz dvdlp
   pdg:
   dec ecx
   mov eax, esp
   call sprnt
   pop eax
   cmp ecx, 0
   jnz pdg
   pop esi
   pop edx
   pop ecx
   pop eax
   ret

slen:

   push ebx
   mov ebx, eax
   nxt:
   cmp byte [eax], 0
   jz fin
   inc eax
   jmp nxt
   fin:
   sub eax, ebx
   pop ebx
   ret

sprnt:

   push edx
   push ecx
   push ebx
   push eax
   call slen
   mov edx, eax
   pop eax
   mov ecx, eax
   mov ebx, STDOUT
   mov eax, SYS_WRITE
   int 0x80
   pop ebx
   pop ecx
   pop edx
   ret

