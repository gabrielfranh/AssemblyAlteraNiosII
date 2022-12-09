.global ANIMACAO

.equ ENDERECO_LED_VERMELHO, 0x10000000
.equ ENDERECO_CHAVE,0x10000040
.equ TEMPORIZADOR, 0x10002000

# RTI
.org 0x20 
    addi  sp, sp, -4
    stw ra, (sp)

    rdctl et, ipending      # checa se ocorreu interrupção externa
    beq et, r0, RETORNO     # se et == 0, interrupção foi de software, retorna
    
    subi ea, ea, 4          # subtrai 4 do registrador de retorno (obrigatório)
    andi r13, et, 1         # checa se irq1 (TEMPORIZADOR) foi ativado
    beq r13, r0, RETORNO    # caso contrario retorna

    call IRQ_CRONOMETRO
    call ECO           # chama função que trata a interrupção do TEMPORIZADOR
RETORNO:
    ldw ra, (sp)
    addi  sp, sp, 4
eret

IRQ_CRONOMETRO:
    addi  sp, sp, -4
    stw ra, (sp)

    movia  r15,CRO_COUNTER

    ldw r13, (r15)

    addi r13, r13, 1

    movi et,5

    bne r13, et, CONTINUA_CRONOMETRO

    call CRONOMETRO

    movi r13,0

    CONTINUA_CRONOMETRO:
    stw r13,(r15)

    ldw ra, (sp)
    addi  sp, sp, 4
ret

ECO:
    movia r15, TEMPORIZADOR
    movia r13, ENDERECO_CHAVE
    stwio r0, (r15)         # set T0 = 0


    movia et, FLAG_ANIMACAO
    ldb et, (et)

    bne et, r0, FIM_ECO     

    ldwio r13,(r13)  # carregando as chaves

    andi r13,r13,0x1 # mascara da chave SW0

    movia r14, ESTADOS_LEDS

    ldw r15, (r14)

    beq r13, r0, SENTIDO_HORARIO

SENTIDO_ANTI_HORARIO:
    slli r15,r15,1

    movi r13,0x40000

    bne r15, r13, CONTINUA

    movi r15, 0x1

    br CONTINUA

    SENTIDO_HORARIO:

    srli r15,r15,1

    bne r15, r0, CONTINUA

    movi r15, 0x20000

    CONTINUA:

    stw r15, (r14)

    movia r8, ENDERECO_LED_VERMELHO

    stwio r15, (r8)
FIM_ECO:

ret

ESTADOS_LEDS: .word 1

CRO_COUNTER: .word 0