processor	16f877a
#include	<p16f877a.inc>   
	
ORG	    0x00 ;ORIGIN

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
		

	goto main
	
main:
    ; SELECT BANK 1 (01)
	bcf	STATUS,6			
	bcf	STATUS,5			
    ; PORTD IS CONFIGURED AS OUTPUT		
	clrf	PORTD
	
	bcf	STATUS,6			
	bsf	STATUS,5			 

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
	movlw   b'00000000'			
	movwf   PORTD
	goto    Exit

toggle: movlw   b'00000100'			
	movwf   PORTD 
	call	delay1
	movlw   b'00000000'			
	movwf   PORTD
	call	delay1
	goto	Exit
	
loop:	    decfsz	    COUNT1,1	   
	    goto	    loop	
	
delay1: 
	loop2 decfsz	number1,1    
	goto loop2                  
	    decfsz number2,1  
	    goto loop2             
return     

Delay:	   
	    movlw	    0x0A		
	    movwf	    COUNT1
	    
return	
	
	
Exit:
    goto    channel				
    
    end


