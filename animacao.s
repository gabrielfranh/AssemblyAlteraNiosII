.global ANIMACAO

.equ ENDERECO_LED_VERMELHO, 0x10000000
.equ ENDERECO_CHAVE,0x10000040
.equ TEMPORIZADOR, 0x10002000
.equ PB_EDGE_CAPT, 0x5C
.equ IO_BASE,0x10000000 

# RTI
.org 0x20 
    addi  sp, sp, -4
    stw ra, (sp)

    rdctl et, ipending      # checa se ocorreu interrupção externa
    beq et, r0, RETORNO     # se et == 0, interrupção foi de software, retorna
    
    subi ea, ea, 4          # subtrai 4 do registrador de retorno (obrigatório)
    andi r13, et, 1         # checa se irq1 (TEMPORIZADOR) foi ativado

    andi r14, et, 2
    beq r14, r0, SEGUE_PROGRAMA

    movia r15, PAUSA_CRONOMETRO

    ldb r14, (r15)

    nor r14,r14,r14     # Negando o valor da flag pausa/retoma cronômetro

    stw r14, (r15)      # atualiando o valor da flag pausa/retoma cronômetro na memória

    movia r14,IO_BASE

    stwio r0, PB_EDGE_CAPT(r14)     # setando para zero a flag para não gerar interrupção do PB

SEGUE_PROGRAMA:
    beq r13, r0, RETORNO    # caso contrario retorna

    call IRQ_CRONOMETRO
    call ANIMACAO           # chama função que trata a interrupção do TEMPORIZADOR
RETORNO:
    ldw ra, (sp)
    addi  sp, sp, 4
eret

IRQ_CRONOMETRO:
    addi  sp, sp, -4
    stw ra, (sp)

    movia  r15,CRO_COUNTER      # Atribuindo ao registrador r15 o endereço do contador do cronômetro

    ldw r13, (r15)              # Atribuindo ao registrador r13 o valor contido no contador do cronômetro

    addi r13, r13, 1            # Adicionando 1 ao contador do contador do cronômetro

    movi et,5

    bne r13, et, CONTINUA_CRONOMETRO    # Verificando se o contador do cronômetro é igual a 5, para mudar o display de 7 segmentos de um em um segundo

    call CRONOMETRO             # Chama a sub rotina do Cronômetro

    movi r13,0                  # Zerando o contador do cronômetro

    CONTINUA_CRONOMETRO:
    movia  r15,CRO_COUNTER      # Atribuindo ao registrador r15 o endereço do contador do cronômetro
    stw r13,(r15)

    ldw ra, (sp)
    addi  sp, sp, 4
ret

ANIMACAO:
    movia r15, TEMPORIZADOR     # Movendo endereço do temporizador em r15
    movia r13, ENDERECO_CHAVE   # Movendo endereço da chave SW0 em r15
    stwio r0, (r15)         # set T0 = 0


    movia et, FLAG_ANIMACAO     # Movendo endereço da flag da animação dos leds
    ldb et, (et)

    bne et, r0, FIM_ECO     # Se a flag animação não for zero, irá para FIM_ECO

    ldwio r13,(r13)  # carregando as chaves

    andi r13,r13,0x1 # mascara da chave SW0

    movia r14, ESTADOS_LEDS     # Movendo endereço dos estados dos leds em r14

    ldw r15, (r14)              # Carregando o valor dos estados dos leds em r15

    beq r13, r0, SENTIDO_HORARIO    # Se o valor da chave SW0 for zero, a animação será no sentido horário

SENTIDO_ANTI_HORARIO:
    slli r15,r15,1

    movi r13,0x40000

    bne r15, r13, CONTINUA

    movi r15, 0x1   # Move 1 nos estados do led para realizar a animação

    br CONTINUA

    SENTIDO_HORARIO:

    srli r15,r15,1

    bne r15, r0, CONTINUA

    movi r15, 0x20000

    CONTINUA:

    stw r15, (r14)  # Grva os estados do led na memória 

    movia r8, ENDERECO_LED_VERMELHO

    stwio r15, (r8) # Grava os estados do led na parte de I/O da memória para efetuar a animação
FIM_ECO:

ret

ESTADOS_LEDS: .word 1

CRO_COUNTER: .word 0

.global PAUSA_CRONOMETRO
PAUSA_CRONOMETRO: .byte 0