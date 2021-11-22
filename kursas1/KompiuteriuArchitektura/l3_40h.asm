; Justas Gasparaitis, 1 kursas, 5 grupe
; 3 laboratorinis darbas, 9 uzduotis
; Uzduotis: 
; Parašykite rezidentinę programą, kuri pakeičia int 21h, 40h funkcijos
; veikimą taip, kad nurodytas buferis būtų rašomas 2-tainiu pavidalu.
;
; Kompiliuojame: yasm l3_40h.asm -fbin -o l3_40h.com
; 	 Paleidimas: l3_40h.com


%include 'yasmmac.inc'          ; Pagalbiniai makrosai
%define PERTRAUKIMAS 0x21
;------------------------------------------------------------------------
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia 
	Pradzia:
		jmp Nustatymas          ; Pirmas paleidimas, nustatome nauja pertraukima
	
	SenasPertraukimas:
		dw 00,00

	procRasyk:
		jmp rPradzia			; Praleidziame duomenis

	baitas:
		db 00
		
	bitai:
		times 8 db 00
		
	buferioKopija:
		times 8000 db 00
	
	; int 21h, 40h
	; AH = 40h
	; BX = file handle
	; CX = number of bytes to write, a zero value truncates/extends
	;      the file to the current file position
	; DS:DX = pointer to write buffer
	rPradzia:
	.bufKop:
		push es
		push cs
		pop es 					; (ES = CS)
		mov si, dx 				; AL <- DS:[SI] (DS:[DX])
		mov	di, buferioKopija	; ES:[DI] <- AL (CS:[buferioKopija])
		mov bx, 0
		
	.bufKopCiklas:
		cmp bx, cx
		je .bufKopPab
		lodsb	; AL <- DS:[SI] (DS:[DX])
		stosb	; ES:[DI] <- AL (CS:[buferioKopija])
		inc bx
		jmp .bufKopCiklas
	
	.bufKopPab:
		pop es			; ES = ES
		mov bx, bitai	; BX <- bitu buferis
		mov bp, 0		; BP = 0
	
	.decimalToBinary:
		cmp bp, cx
		je rPabaiga
		
		push cx		; Issaugomas CX (cl bus naudotas shr)
		
		; Is buferio nuskaitomas vienas baitas 
		mov al, [cs:buferioKopija+bp]	; AL <- [CS:buferioKopija+bp]
		mov byte [cs:baitas], al		; [baitas] <- AL
		
		; C prototipas: void byteToBits(char baitas, char bitai[8]);
		; Pirmas bitas (skaiciuojame nuo galo)
		mov al, [cs:baitas]
		and al, 1
		cmp al, 1
		je .vienas1
		.nulis1:
		mov byte [cs:bx+7], '0'
		jmp .toliau1
		.vienas1:
		mov byte [cs:bx+7], '1'
		
		; Antras bitas
		.toliau1:
		mov al, [cs:baitas]
		and al, 2
		mov cl, 1					; reikės „stumti“ al tiek kartų
		shr al, cl					; ... dešinėn
		cmp al, 1
		je .vienas2
		.nulis2:
		mov byte [cs:bx+6], '0'
		jmp .toliau2
		.vienas2:
		mov byte [cs:bx+6], '1'
		
		; Trecias bitas
		.toliau2:
		mov al, [cs:baitas]
		and al, 4
		mov cl, 2					; reikės „stumti“ al tiek kartų
		shr al, cl					; ... dešinėn
		cmp al, 1
		je .vienas3
		.nulis3:
		mov byte [cs:bx+5], '0'
		jmp .toliau3
		.vienas3:
		mov byte [cs:bx+5], '1'
		
		; Ketvirtas bitas
		.toliau3:
		mov al, [cs:baitas]
		and al, 8
		mov cl, 3					; reikės „stumti“ al tiek kartų
		shr al, cl					; ... dešinėn
		cmp al, 1
		je .vienas4
		.nulis4:
		mov byte [cs:bx+4], '0'
		jmp .toliau4
		.vienas4:
		mov byte [cs:bx+4], '1'
		
		; Penktas bitas
		.toliau4:
		mov al, [cs:baitas]
		and al, 16
		mov cl, 4					; reikės „stumti“ al tiek kartų
		shr al, cl					; ... dešinėn
		cmp al, 1
		je .vienas5
		.nulis5:
		mov byte [cs:bx+3], '0'
		jmp .toliau5
		.vienas5:
		mov byte [cs:bx+3], '1'
		
		; Sestas bitas
		.toliau5:
		mov al, [cs:baitas]
		and al, 32
		mov cl, 5					; reikės „stumti“ al tiek kartų
		shr al, cl					; ... dešinėn
		cmp al, 1
		je .vienas6
		.nulis6:
		mov byte [cs:bx+2], '0'
		jmp .toliau6
		.vienas6:
		mov byte [cs:bx+2], '1'
		
		; Septintas bitas
		.toliau6:
		mov al, [cs:baitas]
		and al, 64
		mov cl, 6					; reikės „stumti“ al tiek kartų
		shr al, cl					; ... dešinėn
		cmp al, 1
		je .vienas7
		.nulis7:
		mov byte [cs:bx+1], '0'
		jmp .toliau7
		.vienas7:
		mov byte [cs:bx+1], '1'
		
		; Astuntas bitas
		.toliau7:
		mov al, [cs:baitas]
		and al, 128
		mov cl, 7					; reikės „stumti“ al tiek kartų
		shr al, cl					; ... dešinėn
		cmp al, 1
		je .vienas8
		.nulis8:
		mov byte [cs:bx], '0'
		jmp .perrasykBuferi
		.vienas8:
		mov byte [cs:bx], '1'
		
		.perrasykBuferi:
		pop cx	; Atstatomas CX (buvo naudotas shr)
		push bx	; Issaugomi registrai
		push si
		push di
		push ds
		push es
		
		; DS = CS, SI = bitai
		; ES = DS, DI = DX
		push ds	
		pop es		; ES = DS
		
		push cs
		pop ds		; DS = CS
		
		mov si, bitai	; SI = bitai
		
		push ax
		push bx
		push dx
		mov di, dx	; DI = DX
		mov ax, bp
		mov bx, 9
		mul bx		; DX:AX = BP*8
		add di, ax	; DI = DX + bp*8
		pop dx
		pop bx
		pop ax
		
		mov bx, 0
		.perrasykBuferiCiklas:
			cmp bx, 8
			je .perrasykBuferiPab
			lodsb				; AL <- DS:[SI] (CS:[bitai])
			stosb				; ES:[DI] <- AL (DS:[DX])
			inc bx
			jmp .perrasykBuferiCiklas
		
		.perrasykBuferiPab:
		push ax			; prideti tarpa
		mov al, ' '
		stosb
		pop ax
		pop es ; Grazinami registrai
		pop ds
		pop di
		pop si
		pop bx
		inc bp
		jmp .decimalToBinary

	rPabaiga:
		mov ax, cx			; dauginame cx is 9
		mov cx, 9			; (vienas baitas sudaro 8 bitus) + space
		mul cx
		mov cx, ax
		ret                                          ; griztame is proceduros
;end procRasyk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
NaujasPertraukimas:                                      ; Doroklis prasideda cia
	cmp ah, 0x40
	jne .nToliau
	
	; Jei 40 funkcija
	.pushr:
	push ax			; Issaugome registrus, isskyrus CX - ji keisime
	push bx
	;push cx
	push dx
	push ds
	push es
	push si
	push di
	push bp
	
	call procRasyk	; Perrasome buferi i dvejetaini pavidala
	
	.popr:
	pop bp			; Atstatome registrus, isskyrus CX - ji pakeiteme
	pop di
	pop si
	pop es
	pop ds
	pop dx
	;pop cx
	pop bx
	pop ax
	
	; Vykdome modifikuota int 21,40 funkcija
	jmp far [cs:SenasPertraukimas]

	; Jei ne 40 funkcija
	.nToliau:
	pushf
	call far [cs:SenasPertraukimas] ; Vykdome kitas (ne 40) funkcijas
	iret

   

;
;
;  Rezidentinio bloko pabaiga
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  Nustatymo (po pirmo paleidimo) blokas: jis NELIEKA atmintyje
;
;


 
Nustatymas:
		push cs
		pop ds
        ; Gauname sena  vektoriu
		macPutString "Gaunamas senas pertraukimo vektorius...", crlf, '$'
        mov     ah, 0x35
        mov     al, PERTRAUKIMAS              ; gauname sena pertraukimo vektoriu
        int     21h

        
        ; Saugome sena vektoriu 
        mov     [cs:SenasPertraukimas], bx             ; issaugome seno doroklio poslinki    
        mov     [cs:SenasPertraukimas + 2], es         ; issaugome seno doroklio segmenta
        
        ; Nustatome nauja  vektoriu
		macPutString "Nustatome nauja pertraukimo vektoriu...", crlf, '$'
        mov     dx, NaujasPertraukimas
        mov     ah, 0x25
        mov     al, PERTRAUKIMAS                       ; nustatome pertraukimo vektoriu
        int     21h
        
        macPutString "OK ...",  '$'
        
        mov dx, Nustatymas + 1
        int     27h                       ; Padarome rezidentu

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys  


