;MSU task 7, assembler

comment *
Äàíà ïîñëåäîâàòåëüíîñòü îò 1 äî 20 ñëîâ, êàæäîå èç êîòîðûõ ñîäåðæèò îò 1 äî 8 çàãëàâíûõ 
ëàòèíñêèõ áóêâ (ñîñåäíèå ñëîâà ðàçäåëåíû çàïÿòîé, çà ïîñëåäíèì ñëîâîì ñëåäóåò òî÷êà.)

-Âíóòðåííåå ïðåäñòàâëåíèå ïîñëåäîâàòåëüíîñòè ñëîâ:
	Ñïèñîê ñëîâ, óïîðÿäî÷åííûõ ïî àëôàâèòó.
	
-Êàêèå ñëîâà è â êàêîì ïîðÿäêå ïå÷àòàòü:
	Âñå ñëîâà, âõîäÿùèå â ïîñëåäîâàòåëüíîñòü òîëüêî îäèí ðàç.
	
-Äîïîëíèòåëüíàÿ èíôîðìàöèÿ î ñëîâå:
	Ïîðÿäêîâûé íîìåð ñëîâà â ïîñëåäîâàòåëüíîñòè.
	
Òðåáóåòñÿ ââåñòè ýòó ïîñëåäîâàòåëüíîñòü è ïðåîáðàçîâàòü åå âî âíóòðåííåå ïðåäñòàâëåíèå,
à çàòåì íàïå÷àòàòü ïî àëôàâèòó îïðåäåëåííûå ñëîâà ñ äîïîëíèòåëüíîé èíôîðìàöèåé î êàæäîì èç íèõ.
*

include console.inc

Element struc
		Word_ db 8 dup (?)
		Next 	 dd ?
		Num_char dd ?
		Index	 dd ?
		Flag	 dd 0
		Freq	 dd 0
Element ends

.data
		List 	  dd nil
		List1 	  dd nil
		Temp1     db ?
		Temp2 	  db 8 dup (?)
		Num_char  dd ?
		Index_w	  dd ?
		In_word   db 8 dup (?)
		Comp_word dd 0
		Rem_ind	  dd ?
.code
	

;Ïðîöåäóðà äîáàâëåíèÿ ñëîâ â ñïèñîê
InList proc uses eax ebx ecx edx esi edi, @List:dword, @N:byte
		mov  	ebx, @List
		new  	sizeof Element
		mov 	esi, 0
		mov  	ecx, Num_char
	@Fill_word:
		mov 	dl,  Temp2[esi]
		mov  	[eax].Element.Word_[esi],dl
		cmp  	ecx, 0
		je 		@Fill_elem
		dec 	ecx
		inc 	esi
		jmp 	@Fill_word
	@Fill_elem:
		mov  	[eax].Element.Next,nil
		mov 	ecx, Num_char
		mov  	[eax].Element.Num_char, ecx
		mov		ecx, Index_w
		mov  	[eax].Element.Index, ecx
		xor 	ecx, ecx
		xor 	edx, edx
		mov 	cl,[eax].Element.Word_[edx]
		cmp  	dword ptr [ebx],nil
		jne  	@Add_list;          
		mov  	[ebx], eax;     
		jmp  	@FINISH
	@Add_list:
		mov  	ebx,[ebx]
		mov  	[eax].Element.Next, ebx
		mov  	edi,@List
		mov  	[edi],eax;	
	@FINISH:
		ret
InList endp


;Ïðîöåäóðà îïðåäåëåíèÿ äëèíû äëÿ ñðàâíåíèÿ ñëîâ
Leght_loop proc uses ecx
		xor		ecx,ecx
		xor 	esi,esi
		mov 	ecx, [ebx].Element.Num_char
		cmp 	Num_char, ecx
		jge 	@Next
		mov 	esi, Num_char
		jmp 	@End
	@Next:
		mov 	esi, [ebx].Element.Num_char
	@End:
		ret
Leght_loop endp

;Ïðîöåäóðà ñðàâíåíèÿ ñëîâ
Compare_char proc uses ecx edx ebx esi edi
		xor  	edx,edx
		xor 	ecx,ecx
		xor 	esi,esi
		xor		edi,edi
		mov 	edi, [ebx].Element.Num_char
		mov     Comp_word, 0
		call 	Leght_loop
	@Comp:
		mov  	cl, In_word[edx]
		cmp		[ebx].Element.Word_[edx],cl
		jg		@Larger
		cmp		[ebx].Element.Word_[edx],cl
		jl		@FINISH
		cmp		edx, esi
		je		@Larger
		inc		edx
		jmp		@Comp	
	@Larger:
		mov     Comp_word, 1
	@FINISH:	
		ret
Compare_char endp

;Ïðîöåäóðà ñîðòèðîâêè
SortList proc uses eax ebx ecx edx esi edi, @List:dword, @List1:dword
		mov  	ebx,@List
	@Find_Vsp_w :
		cmp 	[ebx].Element.Flag,1
		je 		@Next_elem
		mov 	esi, 0
		mov  	ecx, [ebx].Element.Num_char
		mov		Num_char, ecx
		mov     eax, [ebx].Element.Index
		mov 	Index_w,eax
	@Fill_w:
		mov 	dl, [ebx].Element.Word_[esi]
		mov  	In_word [esi],dl
		cmp  	ecx, 0
		je 		@Cursor
		dec 	ecx
		inc 	esi
		jmp 	@Fill_w		
	@Next_elem:
		cmp  	[ebx].Element.Next,nil
		je		@Empty_list
		mov  	edi,[ebx].Element.Next
		mov  	ebx,edi
		jmp		@Find_Vsp_w	
	@Empty_list:
		jmp 	@FINISH
	@Cursor:
		mov	    Rem_ind, ebx
		xor		ebx, ebx
		mov  	ebx,@List
		jmp		@Search	
	@In_word :
		cmp 	[ebx].Element.Flag,1
		je 		@Next_elem
		mov	    Rem_ind, ebx
		mov 	esi, 0
		mov  	ecx, [ebx].Element.Num_char
		mov		Num_char, ecx
		mov     eax, [ebx].Element.Index
		mov 	Index_w,eax
	@Fill_w1:
		mov 	dl, [ebx].Element.Word_[esi]
		mov  	In_word [esi],dl
		cmp  	ecx, 0
		je 		@Next
		dec 	ecx
		inc 	esi
		jmp 	@Fill_w1	
	@Next:
		cmp  	[ebx].Element.Next,nil
		je		@Add
		mov  	edi,[ebx].Element.Next
		mov  	ebx,edi
		jmp		@Search 	
	@Search:
		cmp 	[ebx].Element.Flag,1
		je		@Next
		call  	Compare_char	
		cmp 	Comp_word,1	
		je  	@In_word
		jmp 	@Next	
	@Add:
		mov		ebx, Rem_ind
		mov		[ebx].Element.Flag,1
		mov  	ebx,@List1
		new  	sizeof Element
		mov  	ecx, Num_char
		mov     esi, Index_w
		mov		[eax].Element.Index,esi
		mov 	esi, 0
	@Fill_word:
		mov 	dl, In_word[esi]
		mov  	[eax].Element.Word_[esi],dl
		cmp  	ecx, 0
		je 		@Fill_elem
		dec 	ecx
		inc 	esi
		jmp 	@Fill_word
	@Fill_elem:
		mov  	[eax].Element.Next,nil
		mov 	ecx, Num_char
		mov  	[eax].Element.Num_char, ecx
		mov		ecx, Index_w
		mov  	[eax].Element.Index, ecx
		xor 	ecx, ecx
		xor 	edx, edx
		mov 	cl,[eax].Element.Word_[edx]
		cmp  	dword ptr [ebx],nil
		jne  	@Add_list;          
		mov  	[ebx],eax;     
		jmp  	@Continue
	@Add_list:
		mov  	ebx,[ebx]
		mov  	[eax].Element.Next, ebx
		mov  	edi,@List1
		mov  	[edi],eax;	
	@Continue:	
		xor		ebx, ebx
		mov  	ebx,@List
		jmp 	@Find_Vsp_w
	@FINISH:
		ret
SortList endp

;Âûâîä èñõîäíîãî ñïèñêà
OutList proc uses ecx ebx esi, @List:dword
		mov  	ebx,@List;      
	assume 		ebx:ptr Element
		cmp  	ebx,nil
		jne  	@L1
		outstr "Ñïèñîê ïóñò" 
		jmp  	@FINISH 
	@L4:
		cmp  	ebx,nil
		je   	@FINISH
		outchar ','
	@L1:
		mov 	esi, 0
		mov 	ecx, [ebx].Element.Num_char
	@L3:	
		outchar [ebx].Element.Word_[esi]
		cmp 	ecx, 0
		je 		@L2
		dec 	ecx
		inc 	esi
		jmp 	@L3
	@L2: 
		mov  	ebx,[ebx].Next
		jmp  	@L4
	assume ebx:NOTHING
	@FINISH:
		outchar '.'
		newline
		ret
OutList endp

;Âûâîä îòñîðòèðîâàííîãî ñïèñêà ñ ïîðÿäêîâûì íîìåðîì
OutList2 proc uses ecx ebx esi, @List1:dword
		mov  	ebx,@List1
	assume 		ebx:ptr Element
		cmp  	ebx,nil
		jne  	@L1
		outstr  'Ñïèñîê ïóñò' 
		jmp  	@FINISH 
	@L4:
		cmp  	ebx,nil
		je   	@FINISH
		outchar ','
	@L1:
		mov 	esi, 0
		mov 	ecx, [ebx].Element.Num_char
	@L3:	
		outchar [ebx].Element.Word_[esi]
		cmp 	ecx, 0
		je 		@L2
		dec 	ecx
		inc 	esi
		jmp 	@L3
	@L2: 
		outstr  ' - '
		outint  [ebx].Element.Index
		mov  	ebx,[ebx].Next
		jmp  	@L4
	assume ebx:NOTHING
	@FINISH:
		outchar '.'
		newline
		ret
OutList2 endp

Leght_loop1 proc uses ecx
		xor		ecx,ecx
		xor 	esi,esi
		mov 	ecx, [eax].Element.Num_char
		cmp 	[ebx].Element.Num_char, ecx
		je 		@Next
		mov		esi, -1
		jmp 	@End
	@Next:
		mov 	esi, [ebx].Element.Num_char
	@End:
		ret
Leght_loop1 endp

Compare_char1 proc uses ecx edx ebx esi eax
		xor  	edx,edx
		xor 	ecx,ecx
		xor 	esi,esi
		call 	Leght_loop1
		cmp		esi, -1
		je		@FINISH
	@Comp:
		mov  	cl, [eax].Element.Word_[edx]
		cmp		[ebx].Element.Word_[edx],cl
		jne		@FINISH
		cmp		edx, esi
		je		@Equal
		inc		edx
		jmp		@Comp	
	@Equal:
		inc     [ebx].Element.Freq
	@FINISH:	
		ret
Compare_char1 endp

Repeat_word proc uses ecx eax esi, @List:dword
		mov  	eax,@List
	assume 		eax:ptr Element
	@L4:
		cmp  	eax,nil
		je  	@FINISH 
		call	Compare_char1
		mov  	eax,[eax].Next
		jmp  	@L4
	assume ebx:NOTHING
	@FINISH:
		ret
Repeat_word endp

;Âûâîä ñëîâ, êîòîðûå âõîäÿò â ñïèñîê òîëüêî îäèí ðàç
OutList3 proc uses ecx ebx esi, @List:dword
		mov  	ebx,@List
	assume 		ebx:ptr Element
		cmp  	ebx,nil
		jne  	@L1
		outstr  'Ñïèñîê ïóñò' 
		jmp  	@FINISH 
	@L4:
		cmp  	ebx,nil
		je   	@FINISH
	@L1:
		invoke  Repeat_word,List
		cmp		[ebx].Element.Freq, 1
		jg		@L5
		mov 	esi, 0
		mov 	ecx, [ebx].Element.Num_char
	@L3:	
		outchar [ebx].Element.Word_[esi]
		cmp 	ecx, 0
		je 		@L2
		dec 	ecx
		inc 	esi
		jmp 	@L3
	@L2: 
		outchar  ' '
	@L5:
		mov  	ebx,[ebx].Next
		jmp  	@L4
	assume ebx:NOTHING
	@FINISH:
		newline
		ret
OutList3 endp

	Limit_exc:
		outstrln 'Ñëîâ áîëüøå 20-òè!'
		jmp 	FINISH	
	Wrong_char:
		outstrln 'Ñëîâî ñîäåðæèò íåâåðíûé ñèìâîë!'
		jmp 	FINISH
	Wrong_num_char:
		outstrln 'Â ñëîâå íåâåðíîå êîëè÷åñòâî ñèìâîëîâ!'
		jmp 	FINISH
		
Start:
		clrscr
		newline
		outstrln "Ââåäèòå îò 1 äî 20 ñëîâ, ðàçäåëÿÿ ñëîâà çàïÿòûìè, â êîíöå òî÷êà."
		outstrln "Â ñëîâå îò 1 äî 8 çàãëàâíûõ ëàòèíñêèõ ñèìâîëà."
		xor 	edi, edi
	Enter_:
		cmp 	edi, 20
		jge		Limit_exc
		xor 	esi, esi
		xor 	eax, eax
	L1:	
		inchar  Temp1
		cmp 	Temp1, '.'
		je 		End_enter
		cmp 	Temp1, ','
		je 		End_word
		cmp		esi, 8
		jge		Wrong_num_char
		cmp 	Temp1, 'A'
		jl 		Wrong_char
		cmp 	Temp1, 'Z'
		jg 		Wrong_char
		mov 	al, Temp1
		mov 	Temp2[esi], al
		inc 	esi
		jmp 	L1
	End_word:
		dec 	esi
		inc		edi
		mov 	Num_char, esi
		mov		Index_w, edi
		invoke  InList,offset List, Temp2 ;ïîìåùàåì ñëîâî â ñïèñîê
		jmp 	Enter_
	End_enter:
		cmp esi, 0
		je Wrong_num_char
		dec 	esi
		inc		edi
		mov 	Num_char, esi
		mov		Index_w, edi
		invoke  InList,offset List, Temp2 ;ïîìåùàåì ïîñëåäíåå ñëîâî â ñïèñîê	
		newline
		invoke 	SortList,List,offset List1
		outstrln "Ñëîâà, óïîðÿäî÷åííûå ïî àëôàâèòó."
		invoke  OutList,List1
		newline
		outstrln "Ïîðÿäêîâûé íîìåð ñëîâà â ïîñëåäîâàòåëüíîñòè."
		invoke  OutList2,List
		newline
		outstrln "Ñëîâà, âõîäÿùèå â ïîñëåäîâàòåëüíîñòü îäèí ðàç:"
		invoke  OutList3,List	
		newline
	FINISH:
		exit
end Start
