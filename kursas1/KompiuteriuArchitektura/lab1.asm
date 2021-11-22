; Justas Gasparaitis, 1 kursas, 5 grupe
; 1 laboratorinis darbas 31 - 5, 7, 6 uzduotys
; Kompiliuojame: yasm lab1.asm -fbin -o lab1.com
; 	 Paleidimas: lab1.com
;------------------------------------------------------------------------
org 100h                        	 ; visos COM programos prasideda nuo 100h

section .text                  		 ; kodas prasideda cia 
	nuskaitymas:					 ; nuo cia vykdomas kodas
		; isvedamas prisistatymas
		mov ah, 09
		mov dx, prisistatymas
		int 0x21
		
		; paprasoma ivesti tekstine eilute
		mov ah, 09
		mov dx, tekstoIvestis
		int 0x21		
		
		; talpinama tekstine eilute
		mov ah, 0x0A
		mov dx, buf_txt
		int 0x21
		call procNewLine			; spausdinama nauja eilute	
		
		; talpinami skaiciai a, b, c
		mov ah, 09					;
		mov dx, skaiciuIvedimas		;
		int 0x21					;
		call procGetUInt16			; i AX ivedamas 1 skaicius
		mov [buf_a], ax 			; 1 skaicius talpinamas
		call procNewLine			; spausdinama nauja eilute
		call procGetUInt16			; i AX ivedamas 2 skaicius
		mov [buf_b], ax 			; 2 skaicius talpinamas
		call procNewLine			; spausdinama nauja eilute
		call procGetUInt16			; i AX ivedamas 3 skaicius
		mov [buf_c], ax 			; 3 skaicius talpinamas
		call procNewLine			; spausdinama nauja eilute
	
	; atliekama antra uzduotis
	antraUzduotis:
		
		mov ah, 09
		mov dx, antrasAtsakymas
		int 0x21
		
		; randame teksto ilgi
		mov bx, 0
		mov bl, [buf_txt+1]
		mov [buf_txtIlgis], bx
		
		; skaiciuojame kiekvieno baito 1, 5, 6 bitu bendra suma
		mov ax, 0						; nuliname ax
		mov bx, 0						; nuliname bx
		mov dx, 0						; nuliname dx
		.pradineDalis:
			mov dl, [buf_txt+bx+2]
			and dl, 0x02				; lieka nepakeistas tik 1-as bitas 
			mov cl, 1					; reikės „stumti“ dl tiek kartų
			shr dl, cl					; ... dešinėn
			add ax, dx					; didiname atsakymą

			mov dl, [buf_txt+bx+2]
			and dl, 0x20				; lieka nepakeistas tik 5-as bitas 
			mov cl, 5					; reikės „stumti“ dl tiek kartų
			shr dl, cl					; ... dešinėn
			add ax, dx					; didiname atsakymą

			mov dl, [buf_txt+bx+2]
			and dl, 0x40				; lieka nepakeistas tik priespaskutinis bitas 
			mov cl, 6					; reikės „stumti“ dl tiek kartų
			shr dl, cl					; ... dešinėn
			add ax, dx					; didiname atsakymą
			
			call procPutUInt16			; isvedame suma
			call procNewLine			; nauja eilute
			
			add word [buf_suma], ax		; didiname suma
			mov ax, 0
			inc bx
			cmp bx, [buf_txtIlgis]		; vykdome cikla, kol baigiasi tekstas
			jle .pradineDalis
		
		; spausdiname antros uzduoties gauta bitu suma
		mov ah, 09
		mov dx, antrasAtsakymasSuma
		int 0x21
		
		mov ax, word [buf_suma]
		call procPutUInt16
		call procNewLine
		
	; atliekama pirma uzduotis
	pirmaUzduotis:
		; keiciama eilute
		mov ah, [buf_txt+4]				; ah <- 3 simbolis
		mov al, [buf_txt+6]				; al <- 5 simbolis
		mov [buf_txt+4], al				; 3 simbolis <- 5 simbolis
		mov [buf_txt+6], ah				; 5 simbolis <- 3 simbolis
		mov al, 0x5E					; irasomas '^'
		mov [buf_txt+5], al				; 4 simbolis <- '^'
		
		; isvedama pakeista eilute
		mov bx, 0
		mov bl, [buf_txt+1]           	; bx <- kiek įvedėme baitų
		mov byte [buf_txt+bx+3], 0x0a	; pridedame gale LF (CR jau ten yra) 
		mov byte [buf_txt+bx+4], '$' 	; pridedame gale '$' tam, kad 9-ą funkcija galėtų atspausdinti  
		
		mov ah, 09
		mov dx, pirmasAtsakymas
		int 0x21
		
		mov ah, 09
		mov dx, buf_txt+2
		int 0x21
		
	; atliekama trecia uzduotis
	treciaUzduotis:					;
		
		mov ah, 09
		mov dx, treciasAtsakymas
		int 0x21
		
		mov ax, 0
		mov bx, 0
		mov cx, 0
		mov dx, 0					; dx nunulinamas
		mov ax, [buf_a]				; a ikeliamas i ax
		mov bx, 3					;
		div bx						;
		mov [buf_sk1], ax			; buf_sk1 talpinamas (a / 3)
		
		mov dx, 0					; dx nunulinamas
		mov ax, [buf_c]				; c ikeliamas i ax
		mov bx, 20					;
		div bx						;
		mov [buf_sk2], dx			; buf_sk2 talpinamas (c % 20)
		
		mov dx, 0					; dx nunulinamas
		mov ax, [buf_b]				;
		mov bl, 2					;
		div bx						;
		add ax, 1					;
		mov [buf_sk3], ax			; buf_sk3 talpinamas (b / 2 + 1)
		mov ax, 23					;
		mov [buf_sk4], ax			; buf_sk4 talpinamas 23
		
		mov ax, [buf_sk1]			; 1 skaicius i ax
		mov bx, [buf_sk2]			; 2 skaicius i bx
		cmp ax, bx					;
		jge .axDidesnis				; jei ax didesnis sokti
		mov cx, ax
		jmp .antraPora				; einame prie antros poros skaiciu
		.axDidesnis:
			mov cx, bx				; mazesnis pereina i cx
		
		.antraPora:
		mov dx, 0
		mov ax, [buf_sk3]				; 3 skaicius i ax
		mov bx, [buf_sk4]				; 4 skaicius i bx
		cmp ax, bx
		jbe .axMazesnis				; jei ax mazesnis sokti
		mov dx, ax
		jmp .isvedimas				; einame prie isvedimo
		.axMazesnis:
			mov dx, bx				; didesnis pereina i dx
			
		.isvedimas:
		add cx, dx					; min(a / 3, c % 20) + max(b / 2 + 1, 23)
		mov ax, cx
		call procPutUInt16


	
	pabaiga:
	mov ah, 0x4c                  ; baigiama programa
	int 0x21
   
section .data                     ; duomenys

	prisistatymas:
	db 'Justas Gasparaitis, 1 kursas, 5 grupe', 0x0D, 0x0A, '$'
	
	tekstoIvestis:
	db 'Iveskite tekstine eilute nuo 8 iki 80 simboliu: ', 0x0D, 0x0A, '$'
	
	skaiciuIvedimas:
	db 'Iveskite tris neneigiamus skaicius nuo 0 iki 65535: ', 0x0D, 0x0A, '$'
	
	pirmasAtsakymas:
	db 'Pirmos uzduoties atsakymas: ', 0x0D, 0x0A, '$'
	
	antrasAtsakymas:
	db 'Antros uzduoties atsakymas: ', 0x0D, 0x0A, '$'
	
	antrasAtsakymasSuma:
	db 'Antros uzduoties atsakymo bendra suma: ', 0x0D, 0x0A, '$'
	
	treciasAtsakymas:
	db 'Trecios uzduoties atsakymas min(a / 3, c % 20) + max(b / 2 + 1, 23): ', 0x0D, 0x0A, '$'
	
	buf_suma:
	dw 00
	
	buf_txt:
	db 82, 0x00, '                                                                                               '
	
	buf_txtIlgis:
	dw 00
	
	buf_a:
    dw 00
	
	buf_b:
    dw 00
	
	buf_c:
    dw 00
	
	buf_sk1:
	dw 00
	
	buf_sk2:
    dw 00
	
	buf_sk3:
    dw 00
	
	buf_sk4:
    dw 00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pagalbines funkcijos
%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;