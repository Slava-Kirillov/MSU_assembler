;MSU task 6, assembler 

comment *
Дан непустой текст (последовательность литер), содержащий не более 100 элементов, с
точкой в качестве признака конца текста.
Требуется:
— ввести с клавиатуры данный текст и записать его в память ЭВМ;
— определить, обладает ли этот текст заданным свойством: текст оканчивается заглавной латинской буквой, которая больше не встречается в
тексте. 
— преобразовать текст по правилу 1, если он обладает заданным свойством.
Правило 1: заменить каждую ненулевую цифру на соответствующую ей по порядковому номеру строчную букву латинского алфавита (1 > a, 2 > b и т.д.). 
— преобразовать текст по правилу 2, если он не обладает заданным свойством.
Правило 2: Перевернуть текст, не используя дополнительную память. 
comment *

include console.inc

.data
		x db 100 dup (?)

.code

input proc											;процедура ввода текста
		lea edi, x
		xor ecx,ecx      
	icycle:
		inchar al
		cmp al,'.'
		je doneinput								;ввод окончен
		inc ecx
		cmp ecx,100
		je toolong									;длина строки больше 100 символов
		mov [edi], al
		inc edi
		jmp icycle
	toolong:
		outstrln "Введено более 100 символов"   	;вывод сообщения об ошибке
		mov eax,1            						;eax=1 - ошибка
		ret
	doneinput:
		cmp ecx,0
		je tooshort        							;пустая строка
		dec edi
		xor eax,eax           						;eax=0 - ошибки нет
		ret
	tooshort:
		outstrln "Введена пустая строка"
		mov eax,1            						;eax=1 - ошибка
		ret
	input endp

printtext proc										;процедура вывода текста на экран
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

check proc											;процедура проверки введенного слова на определенное свойство
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

rule1 proc											;процедура преобразования текста по правилу 1
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

rule2 proc											;процедура преобразования текста по правилу 2
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
		outstr "Введите символы, не более 100: "
		call input      							;ввод текста
		cmp eax, 1
		je finish
		newline
		outstr "Исходный текст: "
		call printtext   							;вывод введенного текста
		call check      							;проверка свойства
	
		cmp eax, 0
		je rule_1
	
		cmp eax, 1
		je rule_2
	
	rule_1:	
		call rule1									;применяем првило 1
		jmp finish1
	
	rule_2:
		call rule2									;применяем првило 2
		jmp finish2
	

	finish:
		exit
	finish1:
		outstr "Преобразованный текст: "
		call printtext
		outstrln "Использовано правило 1"
		newline
		exit
	finish2:
		outstr "Преобразованный текст: "
		call printtext
		outstrln "Использовано правило 2"
		newline
		exit
end start
