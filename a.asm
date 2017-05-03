include console.inc

.data
	x db 100 dup (?)

.code

input proc
    lea edi, x
    xor ecx,ecx
      
icycle:
    inchar al
    cmp al,'.'
    je doneinput       ;���� �������

    inc ecx
    cmp ecx,100
    je toolong         ;����� ������ ������ 100 ��������

    mov [edi], al
    inc edi
    jmp icycle

toolong:
    outstrln "������� ����� 100 ��������"              ;����� ��������� �� ������
    mov eax,1            ;eax=1 - ������
    ret

doneinput:
    cmp ecx,0
    je tooshort        ;������ ������
    dec edi
    xor eax,eax           ;eax=0 - ������ ���
    ret

tooshort:
    outstrln "������� ������ ������"
    mov eax,1            ;eax=1 - ������
    ret

input endp

printtext proc
	lea esi, x
pcycle:
	mov al, [esi]
	outchar al
	inc esi
	cmp esi, edi
	jle pcycle
	newline
	ret
printtext endp

check proc
	mov edx, [edi]
	call islatin

	ret
ise:
	outstrln "�������� E"
	ret
check endp

islatin 
	

start:
	outstrln "������� �������, �� ����� 100:"
	
	call input      ;���� ������
    cmp eax,0
    jne finish
  	
	;lea dx,strtxt ; �������� �����
    call printtext   ;����� ���������� ������

    call check      ;�������� ��������
comment*
    cmp ax,0
    je .rule2

.rule1:
    call rule1      ;�������������� �� ������� 1
    jmp .output

.rule2:
    call rule2      ;�������������� �� ������� 2
    jmp .output

.output:
    lea dx,strresult
    call printstr
*

finish:
	exit
	end start
