; Maze implementation in Z80 Assembler
; by HWR0 aka @r0_hw
; Code bits from libg800
; Sept '2021
; Assembled with z88dk
; ------------------------------------

    ORG 0x100
home_screen:
    ld A, 0x40
	out (0x40), A
; clear vvram
maze_start:
    call vclear
    ld A, R
	ld H, A
	ld A, R
	ld L, A
	call randomize
; draw the box (42=0x2e, 142=0x8e)
box_draw:
    ld DE, 0x0000
	ld BC, 0x008e
    call line
    ld DE, 0x008e
	ld BC, 0x2e8e
    call line
    ld DE, 0x2e8e
	ld BC, 0x2e00
    call line
    ld DE, 0x2e00
	ld BC, 0x0000
    call line

main_loop:
    ld E, 0x8c
lp1:
    ld D, 0x2c
lp2:
    push de
        push de
        push de
            call vaddress
            or (HL)
            ld (HL), A ; pointset(x,y)
            pop de
while: 
        call prng
            or a ; instead of cp 0 (-> save 1 byte and 3 T-states)
            jp Z, c1
            dec a ; instead of cp 1 ; changes a! (-> save 1 byte and 3 T-states) 
            jp Z, c2
            dec a ; instead of cp 1 ; changes a! (-> save 1 byte and 3 T-states) 
            jp Z, c3
            dec a ; instead of cp 1 ; changes a! (-> save 1 byte and 3 T-states) 
            jp Z, c1
next:
;   ld DE, 0x0000
;	ld BC, 0x2f8f
;	call vupdate
    pop de
    dec d
    dec d
    jp NZ, lp2
    
    dec e
    dec e
    jp NZ, lp1
    jp maze_update

c1:
    pop de
    dec e
    call vaddress
    push af
    and (hl)
    pop af
    jp NZ, while
    or (HL)
    ld (HL), A ; pointset(x,y-1)
    jp next 
c2:
    pop de
    inc e
    call vaddress
    push af
    and (hl)
    pop af
    jp NZ, while
    or (HL)
    ld (HL), A ; pointset(x,y+1)
    jp next 
c3:
    pop de
    inc d
    call vaddress
    push af
    and (hl)
    pop af
    jp NZ, while
    or (HL)
    ld (HL), A ; pointset(x+1,y)
    jp next 


;final screen update
maze_update:
    ; ld D, 0x0
    ; ld E, 0x0
    ; call vaddress
    ld DE, 0x0000
	ld BC, 0x2f8f
	call vupdate
    ; ld A, 0x40
	; out (0x40), A
getchr:   
    call INKEY
    cp 'Q' ; actually, the [ON] Key without translation matrix
    jp NZ, getchr
	ret

;
; Display the contents of virtual VRAM
;
; Input
; C:update area x-coordinate
; B:update area y-coordinate
; E:update area x coordinate
; D:update region y-coordinate
;
; Output
; BC,DE,HL:Destruction
;
vupdate:
	ld A, 0x40
	out (0x40), A

	; Find the start and end ROW
	srl B
	srl B
	srl B
	srl D
	srl D
	srl D
	ld A, B
	sub D
	jr NC, skip1
	ld D, B
	neg
skip1:
	add D
	ld L, A

	; Find the starting x-coordinate and length.
	ld A, C
	sub E
	ld B, A
	ld A, C
	cp E
	jr NC, skip2
	ld A, E
	sub C
	ld B, A
	ld E, C
skip2:
	inc B
	ld C, L

	; Find the starting virtual VRAM
	push BC
	ld B, 0
	ld C, E
	ld HL, vram
	add HL, BC
	ld C, WIDTH
	ld A, D
	or A
loop6:
	jr Z, skip3
	add HL, BC
	dec A
	jr loop6
skip3:
	pop BC

loop1:
	; Set the drawing ROW
	push BC
	ld C, 0x40
	ld A, D
	or 0xb0
loop2:
	in B, (C)
	rlc B
	jr C, loop2
	out (C), A

	; Set the drawing COL(L)
	ld A, E
	and 0x0f
loop3:
	in B, (C)
	rlc B
	jr C, loop3
	out (C), A

	; Set the drawing COL(H)
	ld A, E
	rra
	rra
	rra
	rra
	and 0x0f
	or 0x10
loop4:
	in B, (C)
	jr C, loop4
	out (C), A
	pop BC

	; Draw one line
	push BC
	push HL
loop5:
	ld A, (HL)
	inc HL
	out (0x41), A
	djnz loop5
	pop HL
	ld BC, WIDTH
	add HL, BC
	pop BC

	; Moving on to the next ROW
	inc D
	ld A, C
	sub D
	jr NC, loop1

	ret
;
; Erase virtual VRAM
;
; No input
;
; Output
; BC, DE, HL: Destruction
;

vclear:
	ld DE, vram
	ld BC, WIDTH
	ld HL, blank
	ldir
	ld BC, WIDTH
	ld HL, vram
	ldir
	ld BC, WIDTH * 2
	ld HL, vram
	ldir
	ld BC, WIDTH * 2
	ld HL, vram
	ldir
	ret
blank:
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0

;
; Get the address on the virtual VRAM
;
; Input
; D:y-coordinate
; E:x-coordinate
;
; Output
; A:Mask HL:Address
; F,DE:Destruction
;
vaddress:
	push BC

	ld A, D
	and 0x07
	ld B, 0
	ld C, A
	ld HL, vmask_table
	add HL, BC
	ld A, (HL)
vaddress0:
	ld HL, vram
	ld BC, WIDTH
	srl D
	srl D
	srl D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	rst 0x30
vaddress_skip1:
	add HL, DE
	pop BC
	ret
vmask_table:
	db 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80

;
; Draw a line segment
;
; Input
; D:y-coordinate of line segment start point
; E:Line segment start point x-coordinate
; B:Line endpoint y-coordinate
; C:Line endpoint x-coordinate
;
; Output
; AF,BC,DE,HL,AF':Destruction
;
line:
	; dx = abs(x2 - x1)
	ld A, C
	sub E
	jr NC, skip_dx
	ld A, E
	sub C
skip_dx:
	; if dx == 0 goto vert
	jr Z, vert
	ld L, A
	; dy = abs(y2 - y1)
	ld A, B
	sub D
	jr NC, skip_dy
	ld A, D
	sub B
skip_dy:
	; if dy == 0 goto horiz
	jr Z, horiz
	ld H, A
	; if dx > dy goto gentle else goto steep
	ld A, L
	cp H
	jr C, steep
	jr gentle

; Draw a vertical line segment.
vert:
	; if y1 > y2 then swap(y1,y2)
	ld A, B
	sub D
	jr NC, skip_swap_y1_y2
	ld D, B
	neg
skip_swap_y1_y2:
	ld B, A
	inc B
	call vaddress
loop_horiz:
	; pset(x,y)
	ld C, A
	or (HL)
	ld (HL), A
	ld A, C
	; y++
	rlc A
	jr NC, skip6
	ld DE, WIDTH
	add HL, DE
skip6:
	; if y != y2 goto loop_horiz
	djnz loop_horiz
	ret

; Draw a horizontal line segment.
horiz:
	; if x1 > x2 then swap(x1,y2)
	ld A, C
	sub E
	jr NC, skip_swap_x1_x2
	ld E, C
	neg
skip_swap_x1_x2:
	ld B, A
	inc B
	call vaddress
loop_vert:
	; pset(x,y)
	ld C, A
	or (HL)
	ld (HL), A
	ld A, C
	; x++, if x != x2 goto loop_vert
	inc HL
	djnz loop_vert
	ret
gentle:
steep:
; not implemented

; Output : A = Random Number from 0-3
prng:
    ;push HL
    ld HL, (rand_value16)
	  ld B, H
	  ld C, L
	  add HL, HL
	  add HL, HL
	  add HL, BC
	  inc HL
	  ld A, H
    add A, C
    ld H, A
	  ld (rand_value16), HL
    and 3 
	;inc a 
    ;pop HL
    ;ld (HL),a
	ret
randomize:
	ld (rand_value16), HL
	ret

rand_value16:
	db 0xf0
rand_value8:
	db 0xf1

G850    equ 1
COLS    equ 24
ROWS    equ 6
WIDTH   equ 144
HEIGHT  equ 48
HWR0    equ 1

INKEY equ 0x0BE53

;
; virtual VRAM
;
vram:
vram0:
	ds 144
vram1:
	ds 144
vram2:
	ds 144
vram3:
	ds 144
vram4:
	ds 144
vram5:
	ds 144
