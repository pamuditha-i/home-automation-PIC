


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
		
		
	
maind:
    ; SELECT BANK 1 (01)
	bcf	STATUS,6			
	bcf	STATUS,5			
    ; PORTD IS CONFIGURED AS OUTPUT		
	clrf	PORTD
	
	bcf	STATUS,6			
	bsf	STATUS,5
	GOTO ldr
ldr:	
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
	
	
step1:	
	movlw	d'102'	; assigning 250 to w 
	movwf	number3
	movf	NUM,0
	subwf	number3,0	; substracting W from the NUM and depositing it in w		 
	btfss	STATUS,0			
	goto    $+2	
	goto	toggled
	movlw   b'00000000'			
	movwf   PORTD
	goto    Exitd

toggled: movlw   b'00001000'			
	movwf   PORTD 
	;call	delay1d
	;movlw   b'00000000'			
	;movwf   PORTD
	;call	delay1d
	goto	Exitd
	
loop3d:	    decfsz	    COUNT1,1	   
	    goto	    loop3d	
	
delay1d: 
	loop4 decfsz	number1,1    
	goto loop4                  
	    decfsz number2,1  
	    goto loop4             
return     

Delayd:	   
	    movlw	    0x0A		
	    movwf	    COUNT1
	    
return	
	
	
Exitd:
    goto    channeld				
    
    end


