PROCESSOR 16F877A

#include <xc.inc>

; CONFIGURATION WORD PG 144 datasheet

CONFIG CP=OFF ; PFM and Data EEPROM code protection disabled
CONFIG DEBUG=OFF ; Background debugger disabled
CONFIG WRT=OFF
CONFIG CPD=OFF
CONFIG WDTE=OFF ; WDT Disabled; SWDTEN is ignored
CONFIG LVP=ON ; Low voltage programming enabled, MCLR pin, MCLRE ignored
CONFIG FOSC=XT
CONFIG PWRTE=ON
CONFIG BOREN=OFF
PSECT udata_bank0

max:
DS 1 ;reserve 1 byte for max

tmp:
DS 1 ;reserve 1 byte for tmp
PSECT resetVec,class=CODE,delta=2

resetVec:
    PAGESEL INISYS ;jump to the main routine
    goto INISYS

PSECT code

INISYS:
    ;Cambio a Banco N1
    BCF STATUS, 6
    BSF STATUS, 5 ; Bank1
    ; Modificar TRIS
    BSF TRISB, 1    ;  entrada S
    BSF TRISB, 2    ;  entrada S
    BSF TRISB, 3    ;  entrada S
    BSF TRISB, 4    ;  entrada S
    BSF TRISB, 5    ;  entrada S
    ;------------------------------------------
    BCF TRISD, 0    ;  salida MDA
    BCF TRISD, 1    ;  salida MIA
    BCF TRISD, 2    ;  salida MDR
    BCF TRISD, 3    ;  salida MIR
    BCF TRISD, 4    ;  salida LEDROJ
    BCF TRISD, 5    ;  salida LDADER
    BCF TRISD, 6    ;  salida LDAIZ
    ; Regresar a banco 
    BCF STATUS, 5 ; Bank0

Main:
    MOVF PORTB,0  ; Asignar un valor a W 
    MOVWF 30             ; Mover a w al registro 30
                          
   
    ;ENTRADAS............ 
    
    
    ;SENSORES 
     
    ;===================================================
    
     ; B1 = S                                           
     
    MOVF 30,0              ;"00000100"
    ANDLW 0b00001000   ; AND
    MOVWF 31               ; REGISTRO = W
    RRF 31,1                ; UN BIT A LA DERECHA  
    RRF 31,1 
    RRF 31,1 
    MOVF 31,0              ; W = REGISTRO 27
    ANDLW 0b00000001   ; AND ENTRE W Y "00000001"
    MOVWF 31              ; REGISTRO = W
    
    
    ; !B1 = !S 
   
    MOVF 30,0                         
    ANDLW 0b00001000
    MOVWF 32
    RRF 32,1
    RRF 32,1
    RRF 32,1
    COMF 32 
    MOVF 32,0
    ANDLW 0b00000001
    MOVWF 32
    ;--------------
   
    ;==================================================
   
    ; B2 = S
    
    MOVF   30,0     
    ANDLW  0b00000010
    MOVWF  33 
   RRF 33,1
    MOVF   33,0           
    ANDLW  0b00000001
    MOVWF  33       ;
    
    ; !B2 = S
    
    MOVF 30,0
    ANDLW 0b00000010
    MOVWF 34
    RRF 34,1
    COMF 34 
    MOVF 34,0
    ANDLW 0b00000001
    MOVWF 34
   ;==================================================
    
   ;B3 = SD2 
   
    MOVF   30,0     
    ANDLW  0b00000100
    MOVWF  35 
    RRF    35,1
    RRF    35,1
    MOVF   35,0           
    ANDLW  0b00000001
    MOVWF  35       ;
    
    ; !B3 = !SD2
    
    MOVF 30,0
    ANDLW 0b00000100
    MOVWF 36
    RRF 36,1
    RRF 36,1
    COMF 36 
    MOVF 36,0
    ANDLW 0b00000001
    MOVWF 36
   
  ;===================================================
   
    ;B4 = SI2 
    
    MOVF 30,0            
    ANDLW 0b00010000
    MOVWF 0X28
    RRF 37,1
    RRF 37,1
    RRF 37,1
    RRF 37,1
    MOVF 37,0
    ANDLW 0b00000001
    MOVWF 37
    
    ; !B4 = !SI2
    
    MOVF 30,0
    ANDLW 0b00010000
    MOVWF 38
    RRF 38,1
    RRF 38,1
    RRF 38,1
    RRF 38,1
    COMF 38
    MOVF 38,0
    ANDLW 0b00000001
    MOVWF 38
    
 ;===================================================   
   
 
   ; B5 = SI1 
   
    MOVF 30,0              
    ANDLW 0b00100000
    MOVWF 39
    RRF 39,1
    RRF 39,1
    RRF 39,1
    RRF 39,1
    RRF 39,1
    MOVF 39,0
    ANDLW 0b00000001
    MOVWF 39
    ;-----------------
   
    ; !B5 = !SI1
    
    MOVF 30,0                
    ANDLW 0b00100000
    MOVWF 40
    RRF 40,1
    RRF 40,1
    RRF 40,1
    RRF 40,1
   RRF 40,1
   COMF 40
    MOVF 40,0
    ANDLW 0b00000001
    MOVWF 40
 
    ;===================================================
     ;==========================
     ; SM= 31
    
     ; !SM= 32
     
     ; SD1= 33 
     
     ; !SD1= 34
     
     ; SD2= 35 
     
     ; !SD2= 36
     
     ; SI2= 37
     
     ; !SI2= 38
     
     ; SI1= 39
     
     ; !SI1= 40
     ;==================================
   ;==================================================
    
    
    ; Funcion del Motor 1 MDA 
    ;                          ( !SM SI2 + !SM SI1+ SM !SI1 )
    
    CLRF PORTD
    ; Multiplicar 2 registros 
    MOVF 32,0
    ANDWF 37,0
    MOVWF 41 ; !SM SI2
    ; --------------
    MOVF 32,0
    ANDWF 39,0
    MOVWF 42 ; (!SM SI1)
    
    
    
    ; Suma de LOS 2 REGISTROS ANTERIORES 
    MOVF 41,0
    IORWF 42,0
    MOVWF 43 ; 
    
    ; Multiplicar 2 registros
    MOVF  31,0
    ANDWF 40,0
    MOVWF 44 ;--> (SM !SI1)
  
    ; Suma de LOS 2 REGISTROS ANTERIORES 	
     MOVF 43,0
    IORWF 44,0
    MOVWF 46; --> FUNCION MDA
    
    ; VEROIFICAR MOTOR 1
    BTFSC 46,0	;PARA M1
    BSF PORTD,0		;PARA M1
    
  ;==========================================================
  
    ; Funcion del motor 2 MIA 
        ;          ( !SM SD1 + SD2 !SD1 +SM !SI1)                                  
    ; M2---------
    
    MOVF 32,0
    ANDWF 33,0
    MOVWF 47 ;--> (!SM SD1)
    ;------------
    MOVF 35,0
    ANDWF 34,0
    MOVWF 48 ;--> (SD2 !SD1)
    ;SUMA DE LOS 2 ANTERIORES REGISTROS 
    MOVF 47,0
    IORWF 48,0
    MOVWF 49 ;
    ; MULTIPLICAR 2 REGISTROS	
    MOVF 31,0
    ANDWF 40,0
    MOVWF 50 ;--> SM !SI1 -------------------   R 
    ;-----
 
    
    ; SUMA DE LOS 2 ANTERIORES REGISTROS 
    MOVF 49,0
    IORWF 50,0
    MOVWF 52 ;-->  FUNCION 
    ; VERIFICAR MOTOR 2
    BTFSC 52,0	
    BSF PORTD,1	
    
    ;================================================================
    
    
    ; FUNCION DEL MOTOR 1 MDR "REVERSA" --> 
    ;                                       ( !SM !SI1 !SI2 !SD2)
    
    ; M1R -------
    MOVF 32,0
    ANDWF 40,0
    MOVWF 53 ;--> (!SM !SI1)
    ; ----------
    ; MULTIPLICAR 2 REGISTROS
    MOVF 38,0
    ANDWF 36,0
    MOVWF 54 ;--> (!SI2 !SD2) 
    ;--------
    MOVF 53,0
    ANDWF 54,0
    MOVWF 57 
    ;---------
    
    
   
    ; VERIFICAR MOTOR M1R
    BTFSC 57,0	 
    BSF PORTD,2		
    ;==========================================================================
    
    ; FUNCION DEL MOTOR 2 MIR "REVERSA --> 
    ; M2R -------                           ( !SM !SI1 !SI2 !SD2 !SD1+ SI1 !SI2) 
    ; MULTIPLICAR 5 REGISTROS
    MOVF 32,0
    ANDWF 40,0
    ANDWF 38,0
    ANDWF 36,0
    ANDWF 34,0
    MOVWF 58 ;--> (!SM !SI1 !SI2 !SD2 !SD1)
    ;-----
     MOVF 39,0
    ANDWF 38,0
    MOVWF 59 ;--> (SI1 !SI2 )
    ;-----
   
    
    ; SUMAR EL REGISTRO 58 Y 59 --> 
    MOVF 58,0
    IORWF 59,0
    MOVWF 62 ;-->  FUNCION
    ; VERIFICAR MOTOR M2R
    BTFSC 62,0	
    BSF PORTD,3	
    ;=====================================================================
    
    
    ; FUNCIO DEL LED AM IZQUIERDO   
    ;                               ( !SM SI2 + !SM SI1)
    ; LED.I ---------
    MOVF 32,0
    ANDWF 37,0
    MOVWF 63  ;--> (!SM SI2)	
    ; ------------
    MOVF 32,0
    ANDWF 39,0
    MOVWF 64 ;--> (!SM SI1)
    ;---------
 
    ; SUMAR LOS 2 REGISTROS 
    MOVF 63,0
    IORWF 64,0
 
     MOVWF 67 ;-->  FUNCION 
    ; VERIFICAR LED.I
    BTFSC 67,0
    BSF PORTD,6	
     ;--------------
    ;=============================================================
     
    ; FUNCION DEL LED AM DERECHO  ---> 
    ;                                     ( SD2 !SD1 + !SM SD1  )
    ; LED.D 
    MOVF 35,0
    ANDWF 34,0
    MOVWF 68 ; --> ( SD2 !SD1)
    ; ------------
    MOVF 32,0
    ANDWF 33,0
    MOVWF 69 ; --> (!SM SD1)
    ;----------------
 
    ; SUMAR LOS 2 REGISTROS 
    MOVF 68,0
    IORWF 69,0
   
    MOVWF 72 ; --> ( FUNCION )
   
    BTFSC 72,0
    
    BSF PORTD,5		
     ;============================================================
    
    ; FUNCION DEL LED ROJO  ---->
    ;                        
    ;                           SI1 SD1 + !SM !SI2 !SD2 !SI1 !SD1 
    ; LED.C
    MOVF 32,0
    ANDWF 40,0
     ANDWF 38,0
      ANDWF 36,0
       ANDWF 34,0
    MOVWF 73 ; ---> ( !SM !SI1 !SI2 !SD2 !SD1)
    ;--------------
     MOVF 39,0
    ANDWF 33,0
    MOVWF 74 ; --->( SI1 SD1 )
    ;----------------
   
    ;------------SUMA 2 REGISTROS
     
     MOVF 73,0
    IORWF 74,0
    MOVWF 75 ; --> ( FUNCION )
    ;------------
     
    BTFSC 75,0	
    BSF PORTD,4		
    ;--------------
   
;==================================================================
    
    GOTO Main
    END resetVec
	
