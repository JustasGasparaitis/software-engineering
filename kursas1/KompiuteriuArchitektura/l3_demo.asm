; Programa testams
%include 'yasmmac.inc'          ; Pagalbiniai makrosai
;------------------------------------------------------------------------
org 100h                        	 ; visos COM programos prasideda nuo 100h

section .text                  		 ; kodas prasideda cia
	
	; Ivedamas isvedamu duomenu failo vardas
	macPutString 'Iveskite isvedamu duomenu failo varda: ', crlf, '$'
	mov al, 128                  ; ilgiausia eilutė
	mov dx, pavRasymoFailas
	call procGetStr              
	macNewLine
	
	; Paruosiamas isvesties failas
	mov dx, pavRasymoFailas 			; DX <- failo pavadinimas
	call procFCreateOrTruncate
	mov word [deskRasymoFailas], bx		; saugomas failo deskriptorius
	
	jnc isvedimas
	macPutString 'Klaida: isvesties failo atidarymas.', crlf, '$'
	exit
	
	isvedimas:
	; Rasome baita dvejetainiu pavidalu i faila
	mov bx, word [deskRasymoFailas]		; failo deskriptorius
	mov dx, buferis						; baito adresas
	mov cx, 94							; baitu kiekis
	mov ah, 0x40						; 0x40 funkcija
	int 0x21							; 0x21 pertraukimas
	
	jnc pabaiga
	macPutString 'Klaida: rasymas i isvesties faila.', crlf, '$'
	exit
	
; -------------------------------- Baigiame -----------------------------------
	pabaiga:
		macPutString 'Buferis sekmingai irasytas i faila!', '$'
		;call procPutUInt16
		;macNewLine
		
		exit
	
section .data						; duomenys
	
	buferis:
		db '"#%&\()*+,-/0123456789:$;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~', 0x0D, 0x0A

	pavRasymoFailas:
		times 255 db 00
		
	deskRasymoFailas:
		dw 0
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pagalbines funkcijos
%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;