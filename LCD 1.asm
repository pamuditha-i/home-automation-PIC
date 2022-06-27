     
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;/// CODE IN ASSEMBLER TO PRINT CHARACTERS IN AN LCD
;/// USING PIC16f877A
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
LIST P=16f877A 
 INCLUDE "P16F877A.INC"
 __CONFIG _CP_OFF& _DEBUG_OFF& _WRT_OFF& _CPD_OFF& _LVP_OFF& _BODEN_OFF& _PWRTE_ON& _WDT_OFF& _XT_OSC
 
 
 ;  DEFINING VARIABLES
	
STATUS		equ	03h            
ADCON0		equ     1Fh	       
ADCON1		equ	9Fh            
ADRESH		equ	1Eh            
ADRESL		equ	9Eh	       
PORTD		equ	08h            
TRISD		equ	88h	       
NUM		equ	32h	       
COUNT1		equ	31h  
number1		equ	20h            
number2		equ	21h
number3		equ	22h
 
ORG 0x00 
		
		
	BCF STATUS,RP1 ; Selection of memory bank 1
	BSF STATUS,RP0 
	CLRF TRISB ; Configuration of PORT B as output (Data pins LCD)
	CLRF TRISD ; Configuration of PORT D as output (RD0-R/S, RD1-E)

	MOVLW b'00000111'
	MOVWF OPTION_REG ; Configuration of Option Register (TMR0 Rate = 1:256)

	BCF STATUS,RP0 ; Selection of memory bank 0
	CLRF PORTB ; Setting PORTB to "0000000"
	CLRF PORTD ; Setting PORTD to "0000000"
	
	
	CALL InitiateLCD
	
	CALL PRINTCHAR
	
; Darsha 
    
darsha:
    ; SELECT BANK 1 (01)
	bcf	STATUS,6			
	bcf	STATUS,5			
    ; PORTD IS CONFIGURED AS OUTPUT		
	;clrf	PORTD
	
	bcf	STATUS,6			
	bsf	STATUS,5
	GOTO	ldrr
ldrr:	
;/////////////////////////////////////////////////////////////////////
; LEFT JUSTIFICATION(0)	
	bcf	ADCON1,7			

	; ANALOG & DIGITAL PINS 
	bsf	ADCON1,0		
	bsf	ADCON1,1			
	bcf	ADCON1,2			
	bsf	ADCON1,3		

	movlw	0x00			
	movwf	TRISD	; configure as output pins 			

	movlw	0xFF			
	movwf	TRISA	; configure as input pins 		
	
	; GOTO BANK 0	
	bcf	STATUS,5		
	; CLOCK SELECT (10)
	bsf	ADCON0,7			
	bcf	ADCON0,6			
	
	goto	channeld
channeld:	
	bsf	ADCON0,0 ;A/D on
	
	bsf	ADCON0,3	;--
	bcf	ADCON0,4	;--->	Analog chanel select 	
	bcf	ADCON0,5	;--	
	
	call	Delayd		
	BSF	ADCON0,0 ;A/D on			
	BSF	ADCON0,2 ; starts the A/D conversion			
	
	goto loop1d
	
loop1d:	btfsc ADCON0,2							 
	    goto loop1d			
				
	
	movf	ADRESH,0		
	movwf	NUM
	
	
step1d:	
	movlw	d'102'	; assigning 250 to w 
	movwf	number3
	movf	NUM,0
	subwf	number3,0	; substracting W from the NUM and depositing it in w		 
	btfss	STATUS,0			
	goto    $+2	
	goto	toggled
	;movlw   b'00000000'			
	;movwf   PORTD
	bcf	PORTD,3
	goto    Exitd

toggled: ;movlw   b'00001000'			
	;movwf   PORTD 
	bsf	PORTD,3
	;call	delay1d
	;movlw   b'00000000'			
	;movwf   PORTD
	;call	delay1d
	goto	Exitd
	
loop3d:	    decfsz	    COUNT1,1	   
	    goto	    loop3d	
    

Delayd:	   
	    movlw	    0x0A		
	    movwf	    COUNT1
	    
return	
	
	
Exitd:
    goto    main				
    
    ;end
    
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	;goto main
	
	;goto darsha
 
;LOOP2	CALL PRINTCHAR
 
;	GOTO LOOP2
 
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;///// LCD Routine ////////////////////////////////////////////////////////////////////////////////////////////////
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
InitiateLCD 
	BCF PORTD,RD0 ; Setting RS as 0 (Sends commands to LCD)

	CALL DELAY_5ms
 
	MOVLW b'00000001' ; Clearing display
	 MOVWF PORTB 
	 CALL Enable
	 CALL DELAY_5ms
 
	MOVLW b'00111000' ; Funtion set
	 MOVWF PORTB 
	 CALL Enable
	 CALL DELAY_5ms
 
	MOVLW b'00001111' ; Display on off
	 MOVWF PORTB
	 CALL Enable
	 CALL DELAY_5ms

	MOVLW b'00000110' ; Entry mod set
	 MOVWF PORTB
	 CALL Enable
	 CALL DELAY_5ms 

	 RETURN
 
PRINTCHAR 
	BCF PORTD,RD0 ; Setting RS as 0 (Sends commands to LCD)

       MOVLW b'00000010' ; Set cursor home
	MOVWF PORTB 
	CALL Enable
	CALL DELAY_5ms 
	BSF PORTD,RD0 ; Setting RS as 1 (Sends information to LCD)

	CALL DELAY_5ms

	MOVLW d'72' ; Print character "H"
	MOVWF PORTB
	CALL Enable
	CALL DELAY_1ms

	MOVLW d'101' ; Print character "e"
	MOVWF PORTB
	CALL Enable
	CALL DELAY_1ms 

	MOVLW d'108' ; Print character "l"
	MOVWF PORTB
	CALL Enable
	CALL DELAY_1ms 

	MOVLW d'108' ; Print character "l"
	MOVWF PORTB
	CALL Enable
	CALL DELAY_1ms 

	MOVLW d'111' ; Print character "o"
	MOVWF PORTB
	CALL Enable
	CALL DELAY_1ms 

	MOVLW d'0' ; Print caracter " "
	MOVWF PORTB
	CALL Enable
	CALL DELAY_1ms

       MOVLW d'87' ; Print caracter "W"
	MOVWF PORTB
	CALL Enable
	CALL DELAY_1ms 

	MOVLW d'111' ; Print character "o"
	MOVWF PORTB
	CALL Enable
	CALL DELAY_1ms 

	MOVLW d'114' ; Print character "r"
	MOVWF PORTB
	CALL Enable
	CALL DELAY_1ms 

	MOVLW d'108' ; Print character "l"
	MOVWF PORTB
	CALL Enable
	CALL DELAY_1ms 

	MOVLW d'100' ; Print character "d"
	MOVWF PORTB
	CALL Enable
	CALL DELAY_1ms 

	MOVLW b'00000001' ; Clearing display
	MOVWF PORTB 
	CALL Enable
	CALL DELAY_5ms

	RETURN
 
Enable 
	BSF PORTD,1 ; E pin is high, (LCD is processing the incoming data)
	;NOP
	BCF PORTD,1 ; E pin is low, (LCD does not care what is happening)
	RETURN
 
DELAY_5ms 
	MOVLW .5 ; Delay of 5 ms
	MOVWF TMR0
 
DELAY_1ms 
	MOVLW .1 ; Delay of 1 ms
	MOVWF TMR0
 
LOOP			    ; isuru
	BTFSS INTCON,2
	GOTO LOOP
	BCF INTCON,2
	RETURN
 
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
main:
    ; SELECT BANK 1 (01)
	bcf	STATUS,6			
	bcf	STATUS,5			
    ; PORTD IS CONFIGURED AS OUTPUT		
	;clrf	PORTD
	
	bcf	STATUS,6			
	bsf	STATUS,5
	GOTO	sumudu
	
	

;/////////////////////////////////////////////////////////////////////
sumudu:	
    
    
    
; LEFT JUSTIFICATION(0)	
	bcf	ADCON1,7			

	; ANALOG & DIGITAL PINS 
	bsf	ADCON1,0		
	bsf	ADCON1,1			
	bcf	ADCON1,2			
	bsf	ADCON1,3		

	movlw	0x00			
	movwf	TRISD	; configure as output pins 			

	movlw	0xFF			
	movwf	TRISA	; configure as input pins 		
	
	; GOTO BANK 0	
	bcf	STATUS,5		
	; CLOCK SELECT (10)
	bsf	ADCON0,7			
	bcf	ADCON0,6			
	
	goto	channel
channel:	
	bsf	ADCON0,0 ;A/D on
	
	bcf	ADCON0,3	;--
	bcf	ADCON0,4	;--->	Analog chanel select 	
	bcf	ADCON0,5	;--	
	
	call	Delay		
	BSF	ADCON0,0 ;A/D on			
	BSF	ADCON0,2 ; starts the A/D conversion			
	
	goto loop1
	
loop1:	btfsc ADCON0,2							 
	    goto loop1			
				
	
	movf	ADRESH,0		
	movwf	NUM
	
	
step1:	movlw	d'250'	; assigning 250 to w 	 
	subwf	NUM,0	; substracting W from the NUM and depositing it in w		 
	btfss	STATUS,0			
	goto    $+2	
	goto	toggle
	;movlw   b'00000000'			
	;movwf   PORTD
	bcf	PORTD,2
	goto    Exit

toggle: ;movlw   b'00000100'			
	;movwf   PORTD
	bsf	PORTD,2
	call	delay1
	;movlw   b'00000000'			
	;movwf   PORTD
	bcf	PORTD,2
	call	delay1
	goto	Exit
	
loop3:	    decfsz	    COUNT1,1	   
	    goto	    loop3	
	
delay1: 
	loop4 decfsz	number1,1    
	goto loop4                  
	    decfsz number2,1  
	    goto loop4             
return     

Delay:	   
	    movlw	    0x0A		
	    movwf	    COUNT1
	    
return	
	
	
Exit:
    goto    darsha				
    
    end
 
;//////////////////////////////////////////////////////////////////



END
