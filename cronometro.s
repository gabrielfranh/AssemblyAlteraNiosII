.global CRONOMETRO

.equ DISPLAY_7SEG,0x20
.equ PB_EDGE_CAPT,       0x5C
.equ PB_INTERRUPT,       0x58
.equ IO_BASE,0x10000000 

CRONOMETRO:
    movia r9, IO_BASE

    movia et, FLAG_CRONOMETRO
    ldb et, (et)

    bne et, r0, ZERAR_CRONOMETRO

/**
    O rótulo abaixo atualiza o contador de unidades de segundos,
    dezenas de segundos, unidades de minutos e dezenas de minutos.
    Cada vez que a unidade de segundo está em 9, ao somar adiciona uma dezena de segundo.
    A mesma coisa acontece nas unidade de minutos. Já a dezena de segundo faz esse processo
    ao ter valor 5 e somar 1
**/

    movia r13, PAUSA_CRONOMETRO
    ldb r14, (r13)

    bne r14, r0, FIM_CRONOMETRO


    ADICIONA_UNIDADE_SEGUNDO:
        movia r13, UNI_SEG
        ldw r14, (r13)
        addi r14,r14,1
        movi r15,10
        stw r14,(r13)
        bne r14,r15, FIM_CRONOMETRO

        movi r14,0
        stw r14, (r13)
        

        movia r13, DEZ_SEG
        ldw r14, (r13)
        addi r14,r14,1
        movi r15,6
        stw r14,(r13)
        bne r14,r15, FIM_CRONOMETRO

        movi r14,0
        stw r14, (r13)

        movia r13, UNI_MIN
        ldw r14, (r13)
        addi r14,r14,1
        movi r15,10
        stw r14,(r13)
        bne r14,r15, FIM_CRONOMETRO

        movi r14,0
        stw r14, (r13)

        movia r13, DEZ_MIN
        ldw r14, (r13)
        addi r14,r14,1
        movi r15,10
        stw r14,(r13)
        bne r14,r15, FIM_CRONOMETRO

ZERAR_CRONOMETRO:
    movia r13, UNI_SEG      
    stw r0,(r13)        # Zerando unidade de segundo de display de 7 segmentos

    movia r13, DEZ_SEG
    stw r0,(r13)        # Zerando dezena de segundo de display de 7 segmentos

    movia r13, UNI_MIN
    stw r0,(r13)        # Zerando unidade de minuto de display de 7 segmentos

    movia r13, DEZ_MIN
    stw r0,(r13)        # Zerando dezena de minuto de display de 7 segmentos

FIM_CRONOMETRO:

# visualição

movia r13, UNI_SEG
ldw  r13, (r13)

movia r14, TABELA_7SEG

add   r14, r14, r13

ldb   r13, (r14)

movia r14, IO_BASE

stbio r13, DISPLAY_7SEG(r14)

movia r13, DEZ_SEG
ldw  r13, (r13)

movia r14, TABELA_7SEG

add   r14, r14, r13

ldb   r13, (r14)

movia r14, IO_BASE

stbio r13, DISPLAY_7SEG+1(r14)

movia r13, UNI_MIN
ldw  r13, (r13)

movia r14, TABELA_7SEG

add   r14, r14, r13

ldb   r13, (r14)

movia r14, IO_BASE

stbio r13, DISPLAY_7SEG+2(r14)

movia r13, DEZ_MIN
ldw  r13, (r13)

movia r14, TABELA_7SEG

add   r14, r14, r13

ldb   r13, (r14)

movia r14, IO_BASE

stbio r13, DISPLAY_7SEG+3(r14)
      
ret

UNI_SEG: .word 0
DEZ_SEG: .word 0
UNI_MIN: .word 0
DEZ_MIN: .word 0

TABELA_7SEG:
.byte   0b0111111       # 0
.byte   0b0000110       # 1
.byte   0b1011011       # 2
.byte   0b1001111       # 3
.byte   0b1100110       # 4
.byte   0b1101101       # 5
.byte   0b1111101       # 6
.byte   0b0000111       # 7
.byte   0b1111111       # 8
.byte   0b1101111       # 9