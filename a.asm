;6 задание
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
    je doneinput       ;ввод окончен

    inc ecx
    cmp ecx,100
    je toolong         ;длина строки больше 100 символов

    mov [edi], al
    inc edi
    jmp icycle

toolong:
    outstrln "¬ведено более 100 символов"              ;вывод сообщени€ об ошибке
    mov eax,1            ;eax=1 - ошибка
    ret

doneinput:
    cmp ecx,0
    je tooshort        ;пуста€ строка
    dec edi
    xor eax,eax           ;eax=0 - ошибки нет
    ret

tooshort:
    outstrln "¬ведена пуста€ строка"
    mov eax,1            ;eax=1 - ошибка
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
	call islat
	
	lea esi, x
pcycle2:
	mov edx, [esi]
	inc esi
	cmp edx, [edi]
	je equal
	cmp esi, edi
	jl pcycle2
	ret	
equal:
	outstrln "Equal"
	ret
check endp

islat proc
	cmp edx, 'A'
	jl notlat
	cmp edx, 'Z'
	jg notlat
	xor eax, eax
	ret
notlat:
	mov eax, 1 ; eax = 1 ошибка
	ret
islat endp
	

start:
	outstrln "¬ведите символы, не более 100:"
	
	call input      ;ввод текста
	cmp eax, 1
	je finish
    
	call printtext   ;вывод введенного текста
    call check      ;проверка свойства
	
	cmp eax, 1
	je finish
	outstrln "Latin"
	jmp finish

	comment*
    cmp ax,0
    je .rule2

.rule1:
    call rule1      ;преобразование по правилу 1
    jmp .output

.rule2:
    call rule2      ;преобразование по правилу 2
    jmp .output

.output:
    lea dx,strresult
    call printstr
*
temp:
	;outstrln "Equal"
finish:
	exit
	end start
