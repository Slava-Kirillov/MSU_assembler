;MSU task 6, assembler 

comment*
��� �������� ����� (������������������ �����), ���������� �� ����� 100 ���������, �
������ � �������� �������� ����� ������.
���������:
� ������ � ���������� ������ ����� � �������� ��� � ������ ���;
� ����������, �������� �� ���� ����� �������� ���������: ����� ������������ ��������� ��������� ������, ������� ������ �� ����������� �
������. 
� ������������� ����� �� ������� 1, ���� �� �������� �������� ���������.
������� 1: �������� ������ ��������� ����� �� ��������������� �� �� ����������� ������ �������� ����� ���������� �������� (1 > a, 2 > b � �.�.). 
� ������������� ����� �� ������� 2, ���� �� �� �������� �������� ���������.
������� 2: ����������� �����, �� ��������� �������������� ������. 
*

include console.inc

.data
		x db 100 dup (?)

.code

input proc											;��������� ����� ������
		lea edi, x
		xor ecx,ecx      
	icycle:
		inchar al
		cmp al,'.'
		je doneinput								;���� �������
		inc ecx
		cmp ecx,100
		je toolong									;����� ������ ������ 100 ��������
		mov [edi], al
		inc edi
		jmp icycle
	toolong:
		outstrln "������� ����� 100 ��������"   	;����� ��������� �� ������
		mov eax,1            						;eax=1 - ������
		ret
	doneinput:
		cmp ecx,0
		je tooshort        							;������ ������
		dec edi
		xor eax,eax           						;eax=0 - ������ ���
		ret
	tooshort:
		outstrln "������� ������ ������"
		mov eax,1            						;eax=1 - ������
		ret
	input endp

printtext proc										;��������� ������ ������ �� �����
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

check proc											;��������� �������� ���������� ����� �� ������������ ��������
		mov edx, [edi]
		cmp edx, 'A'
		jl fail
		cmp edx, 'Z'
		jg fail
		lea esi, x
		mov eax, [edi]
	pcycle2:
		mov edx, [esi]
		inc esi
		cmp dl, al
		je fail
		cmp esi, edi
		jl pcycle2
		mov eax, 0
		ret	
	fail:
		mov eax, 1 
		ret
check endp

rule1 proc											;��������� �������������� ������ �� ������� 1
		lea esi, x
	pcycle3:
		mov dl, [esi]
		cmp dl, '1'
		jl nonum
		cmp dl, '9'
		jg nonum
		add dl, 48
		mov [esi], dl
	nonum:
		inc esi
		cmp esi, edi
		jl pcycle3
		ret
rule1 endp

rule2 proc											;��������� �������������� ������ �� ������� 2
		lea esi, x
		mov ecx, edi
	pcycle4:
		mov al,[ecx]
		mov bl,[esi]
		mov [esi],al
		mov [ecx],bl
		inc esi
		dec ecx
		cmp esi, ecx
		jb pcycle4	
		ret
rule2 endp

start:
		outstr "������� �������, �� ����� 100: "
		call input      							;���� ������
		cmp eax, 1
		je finish
		newline
		outstr "�������� �����: "
		call printtext   							;����� ���������� ������
		call check      							;�������� ��������
	
		cmp eax, 0
		je rule_1
	
		cmp eax, 1
		je rule_2
	
	rule_1:	
		call rule1									;��������� ������ 1
		jmp finish1
	
	rule_2:
		call rule2									;��������� ������ 2
		jmp finish2
	

	finish:
		exit
	finish1:
		outstr "��������������� �����: "
		call printtext
		outstrln "������������ ������� 1"
		newline
		exit
	finish2:
		outstr "��������������� �����: "
		call printtext
		outstrln "������������ ������� 2"
		newline
		exit
end start
