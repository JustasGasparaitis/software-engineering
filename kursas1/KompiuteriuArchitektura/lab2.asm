; Justas Gasparaitis, 1 kursas, 5 grupe
; 2 laboratorinis darbas, 9 uzduotis
; Kompiliuojame: yasm lab2.asm -fbin -o lab2.com
; 	 Paleidimas: lab2.com failo_pavadinimas

%include 'yasmmac.inc'          ; Pagalbiniai makrosai
;------------------------------------------------------------------------
org 100h                        	 ; visos COM programos prasideda nuo 100h

section .text                  		 ; kodas prasideda cia
	nuskaitymas:
	push ax
	mov ax, duom
	mov ax, ketvirtasLaukasEilute
	mov ax, ketvirtasLaukasReiksme
	pop ax
	; Nuskaitomas komandines eilutes parametras (pradiniu duomenu failo vardas)
		call skaitykArgumenta
		
		jnc .nuskaitymasTesinys
		macPutString 'Klaida: blogai nuskaitytas argumentas. Ar ivedete pradiniu duomenu failo varda?', crlf, '$'
		jmp pabaiga
	
		.nuskaitymasTesinys:
		; Isvedamas vardas, pavarde, kursas ir grupe
			macPutString 'Justas Gasparaitis, 1 kursas, 5 grupe', crlf, '$'
			macNewLine
			
		; Ivedamas isvedamu duomenu failo vardas
			macPutString 'Iveskite isvedamu duomenu failo varda: ', crlf, '$'
			mov al, 128                  ; ilgiausia eilutė
			mov dx, pavRasymoFailas
			call procGetStr              
			macNewLine
	
	; Uzdavinio sprendimas
	sprendimas:
	; Ivesties failas paruosiamas skaitymui
		mov dx, pavSkaitymoFailas 			; DX <- failo pavadinimas
		call procFOpenForReading
		mov word [deskSkaitymoFailas], bx	; saugomas failo deskriptorius
		
		jnc .isvestiesFailoAtidarymas
		macPutString 'Klaida: ivesties failo atidarymas.', crlf, '$' 
		jmp pabaiga
		
	; Paruosiamas isvesties failas
	.isvestiesFailoAtidarymas:
		mov dx, pavRasymoFailas 			; DX <- failo pavadinimas
		call procFCreateOrTruncate
		mov word [deskRasymoFailas], bx		; saugomas failo deskriptorius
		
		jnc .skaitymas
		macPutString 'Klaida: isvesties failo atidarymas.', crlf, '$'
		jmp pabaiga
	
	; Skaitomi duomenys
	.skaitymas:
	mov bx, [deskSkaitymoFailas]		; BX <- failo deskriptorius
	mov di, duom						; DI <- duomenu buferio adresas
	cld									; nuvalomas flegas
	
	; Pirmosios duomenu eilutes nesaugosime, tik tikrinsime, ar nera klaidos.
	.pirmaEilute:
		call procFGetChar				; CL <- baitas (Jei EOF, ax == 0; jei klaida CF == 1)
		
		jnc .kitasPirmosEilutesSimbolis
		macPutString 'Klaida: ivesties failo skaitymas.', crlf, '$'
		jmp pabaiga
		
		.kitasPirmosEilutesSimbolis:
		cmp cl, 0x0A					; 0x0A == endline character
		jne .pirmaEilute
	
	; Visus simbolius, be pirmosios eilutes, saugosime.
	.kitaEilute:
		.kitasSimbolis:
			call procFGetChar				; CL <- baitas (Jei EOF, ax == 0; jei klaida CF == 1)
			
			.arKlaida:
			jnc .arFailoPabaiga
			macPutString 'Klaida: ivesties failo skaitymas.', crlf, '$'
			jmp pabaiga
			
			.arFailoPabaiga:
			cmp ax, 0x00					; 0x00 == EOF
			je .skaitymoPabaiga
			
			.simbolioIrasymas:
			mov al, cl						; AL <- baitas
			stosb							; buferis "duom" <- baitas
			
			.arNaujaEilute:
			cmp cl, 0x0A					; 0x0A == endline
			je .kitaEilute

			jmp .kitasSimbolis
	
	; Uzdarome ivesties faila, nes jau nuskaiteme is jo duomenis.
	.skaitymoPabaiga:
		mov [duomPabaigosAdresas], di		; buferis <- DI (saugome duomenu buferio pabaigos adresa)
		mov bx, [deskSkaitymoFailas]		; BX <- skaitymo failo deskriptorius
		call procFClose
		
		jnc .ketvirtoLaukoSkaitymas
		macPutString 'Klaida: ivesties failo uzdarymas.', crlf, '$'
		jmp pabaiga
	
	; Kai baigiamas skaitymas is duomenu failo, galime paruosti ketvirto lauko duomenis rikiavimui.
	.ketvirtoLaukoSkaitymas:
		mov si, duom								; SI <- duomenu buferio adresas
		mov cx, 0
		sub cx, 1
		.ketvKitaEilute:
			add cx, 1				; saugome dabartines eilutes numeri
			mov word [kelintasLaukas], 1			; nauja eilute prasideda pirmu lauku
			.ketvKitaIteracija:
				lodsb								; AL <- [SI]
				
				.ketvArBuferioPabaiga:
				cmp si, [duomPabaigosAdresas]
				jae .rikiavimas
				
				.ketvArNaujaEilute:
				cmp al, 0x0A						; 0x0A == endline
				je .ketvKitaEilute
				
				.ketvArKabliataskis:
				cmp al, ';'							; ';' == naujas laukas
				jne .ketvArKetvirtasLaukas
				inc byte [kelintasLaukas]
				jmp .ketvKitaIteracija
				
				.ketvArKetvirtasLaukas:
				cmp byte [kelintasLaukas], 4
				jne .ketvKitaIteracija
				mov di, skaicius					; DI <- ASCII formato skaiciaus talpinimas
				.ketvNuskaitykSkaiciu:
					cmp al, ';'						; iki ketvirto lauko pabaigos ...
					je .ketvKitasLaukas
					stosb							; ... talpinkime i buferi skaiciu po viena bituka
					lodsb							; pakraukime dar viena bituka tikrinimui
					jmp .ketvNuskaitykSkaiciu
				.ketvKitasLaukas:
				inc byte [kelintasLaukas]
				
				mov di, 0
				mov ax, cx
				mul word [daugiklis]						; AX * daugiklis
				mov bx, ax									; BX <- (kelintaEilute * 2)
				mov word [inkrementas], bx					; buferis <- BX
				mov ax, cx									; AX <- kelintaEilute
				mov word [ketvirtasLaukasEilute+bx], ax		; 0000 (eil. nr.) <- kelintaEilute
				
				
				mov dx, skaicius							; DX <- ASCII formato skaiciaus adresas
				call procParseInt16							; AX <- int16 formato skaicius
				mov bx, word [inkrementas]					; BX <- inkrementas
				mov word [ketvirtasLaukasReiksme+bx], ax	; 0000 (4 lauko reiksme) <- AX
				
				mov word [skaicius+0], ' '
				mov word [skaicius+1], ' '
				mov word [skaicius+2], ' '
				mov word [skaicius+3], ' '
				
				jmp .ketvKitaIteracija
				
	; Rikiuojamos duomenu eilutes
; 	C kalboje:
;	void rikiavimas(int x[], int y[], int n);
;		int temp;
;		for (int i = 0; i < n; i++)
;		{
;			for (int j = 0; j < n; j++)
;			{
;				if (x[i] > x[j])
;				{
;					temp = x[i];
;					x[i] = x[j];
;					x[j] = temp;
;					
;					temp = y[i];
;					y[i] = y[j];
;					y[j] = temp;
;				}
;			}
;		}
	.rikiavimas:
		mov word [kelintaEilute], cx
		mov si, ketvirtasLaukasReiksme
		mov di, ketvirtasLaukasReiksme
		mov word [i], 0
		.ciklas1:
			mov si, ketvirtasLaukasReiksme
			add si, word [i]
			mov di, ketvirtasLaukasReiksme
			mov cx, word [i]
			cmp cx, word [inkrementas]
			ja isvedimas
			add word [i], 2
			mov word [j], 0
			
			.ciklas2:
				.arciklo2Pabaiga:
					mov dx, word [j]
					cmp dx, word [inkrementas]				; tikriname, ar ciklo pabaiga
					ja .ciklas1
					add word [j], 2
					
				.lyginameElementus:
					cmpsw
					jl .apkeiciameElementus
					sub si, 2								; atslenkame SI
					jmp .ciklas2
					
				.apkeiciameElementus:
					; Apkeiciame reiksmes
					sub si, 2
					sub di, 2
					mov ax, [si]
					mov bx, [di]
					mov [si], bx
					mov [di], ax
					
					; Apkeiciame eiluciu numerius
					mov bx, si
					sub bx, ketvirtasLaukasReiksme
					mov cx, ketvirtasLaukasEilute
					add cx, bx						; CX <- SI d2b6e
					mov word [tarpSI], cx			; tarpSI <- SI
					
					mov bx, di
					sub bx, ketvirtasLaukasReiksme
					mov dx, ketvirtasLaukasEilute
					add dx, bx						; DX <- DI
					mov word [tarpDI], dx			; tarpDI <- DI
					
					mov bp, word [tarpSI]
					mov bx, word [tarpDI]
					mov ax, [bp]
					mov cx, [bx]
					mov [bp], cx
					mov [bx], ax
					
					add si, 2
					add di, 2
					
					sub si, 2						; atslenkame SI
					jmp .ciklas2
					
	isvedimas:
		mov si, duom
		mov bp, 0
		mov cx, 0
		sub bp, 2
		sub cx, 1
		mov bx, [deskRasymoFailas]					; bx - failo deskriptorius, al - rašomas baitas
		mov ax, 0
		.isvedimasPradzia:
		.isvedimasArNeBuferioPabaiga:
		cmp si, word [duomPabaigosAdresas]
		je pabaiga
		mov si, duom
		add bp, 2
		mov cx, -1
		.isvedimasKitaEilute:
			add cx, 1
			.isvedimasKitaIteracija:
				lodsb								; AL <- [SI]
				mov byte [baitas], al
				
				.isvedimasArNePabaiga:
				cmp cx, word [kelintaEilute]
				jg pabaiga
				
				
				.isvedimasArTaEilute:
				cmp word [ketvirtasLaukasEilute+bp], cx
				jne .isvedimasArNaujaEilute
				;macPutString 'Kazkas vyksta', crlf, '$'
				
				call procFPutChar
				;jnc .isvedimasIsveskEilute
				;macPutString 'Klaida: rasymas i isvesties faila.', crlf, '$'
				;jmp pabaiga
					.isvedimasIsveskEilute:
						lodsb
						mov byte [baitas], al
						call procFPutChar
						
						jnc .arBaigesiEilute
						macPutString 'Klaida: rasymas i isvesties faila.', crlf, '$'
						jmp pabaiga
						
						.arBaigesiEilute:
						cmp byte [baitas], 0x0A
						je .isvedimasPradzia

						jmp .isvedimasIsveskEilute
				
				.isvedimasArNaujaEilute:
				cmp byte [baitas], 0x0A						; 0x0A == endline
				je .isvedimasKitaEilute
				
				jmp .isvedimasKitaIteracija 

; -------------------------------- Baigiame -----------------------------------
	pabaiga:
		exit
	
section .data						; duomenys
		
	duom:
		times 25000 db 00			; ~1000 eil.
		
	ketvirtasLaukasEilute:
		times 1000 dw 0 			; ~1000 eil.: 0000 <- eilutes nr.
		
	ketvirtasLaukasReiksme:
		times 1000 dw 0 			; ~1000 eil.: 0000 <- 4 lauko reiksme

	pavSkaitymoFailas:
		times 20 db 00
		
	pavRasymoFailas:
		times 20 db 00
		
	deskSkaitymoFailas:
		dw 0000
		
	deskRasymoFailas:
		dw 0000
		
	komEilIlgis:
		db 00
	
	kelintasLaukas:
		db 00
	
	kelintaEilute:
		dw 0
		
	daugiklis:
		dw 2
	
	inkrementas:
		dw 0
		
	temp:
		dw 0
		
	i:
		dw 0
		
	j:
		dw 0
		
	tarpSI:
		dw 0
		
	tarpDI:
		dw 0
	
	baitas:
		db 00
		
	duomPabaigosAdresas:
		dw 0
		
	skaicius:
		dw 32, 32, 32, 32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pagalbines funkcijos
%include 'yasmlib.asm'

skaitykArgumenta:
	 ; nuskaito ir paruosia argumenta
	 ; jeigu jo nerasta, tai CF <- 1, prisingu atveju - 0

	 push bx
	 push di
	 push si 
	 push ax

	 xor bx, bx
	 xor si, si
	 xor di, di

	 mov bl, [80h]         ;
	 mov [komEilIlgis], bl
	 mov si, 0081h  
	 mov di, pavSkaitymoFailas
	 push cx
	 mov cx, bx
	 mov ah,00
	 cmp cx, 0000
	 jne .pagalVisus
	 stc 
	 jmp .pab

	 .pagalVisus:
	 mov al, [si]     ;
	 cmp al, ' '
	 je .toliau
	 cmp al, 0Dh
	 je .toliau
	 cmp al, 0Ah
	 je .toliau
	 mov [di],al
	 ; call rasykSimboli  
	 mov ah, 01                  ; ah - pozymis, kad buvo bent vienas "netarpas"
	 inc di     
	 jmp .kitasZingsnis
	 .toliau:
	 cmp ah, 01                  ; gal jau buvo "netarpu"?  
	 je .isejimas 
	 .kitasZingsnis:
	 inc si
 
	 loop .pagalVisus
	 .isejimas: 
	 cmp ah, 01                  ; ar buvo "netarpu"?  
	 je .pridetCSV
	 stc                         ; klaida!   
	 jmp .pab 
	 .pridetCSV:
	 mov [di], byte '.'
	 mov [di+1], byte 'C'
	 mov [di+2], byte 'S'
	 mov [di+3], byte 'V'
	 clc                         ; klaidos nerasta
	 .pab:
	 pop cx
	 pop ax
	 pop si
	 pop di 
	 pop dx
	 ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;