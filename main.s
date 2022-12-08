/*
    Arquivo principal  - Projeto Final de Microprocessadores II

    Gabriel F. Habermann
    Rodrigo 

    Registradores:
    r16 -> Endereço da UART DATA
    r17 -> Endereço da UART CONTROL
    r18 -> Conteúdo da UART DATA
    r19 -> Máscara para verificar valor RVALID
    r20 -> Registrador para armazenar o caractere lido
    r21 -> Buffer para armazenar os 10 caracteres lidos
    r22 -> Indice do buffer
    r23 -> Tecla ENTER
*/

/*
    FALTA FAZER:
    AJUSTAR R2 E R3 PARA SER USADO COMO PARAMETRO SOMENTE DETRO DA DIRETIVA ACENDE_APAGA

    LOAD NA FLAG FLAG_ANIMAÇÃO DENTRO DO ARQUIVO ANIMAÇÃO PARA VER SE VAI FAZER OU NÃO A ANIMAÇÃO
*/

.equ UARTDATA, 0x10001000
.equ UARTCONTROL, 0x10001004
.equ STACKPOINTER, 0x100000
.equ TEMPO, 10000000 # 200ms
.equ TEMPORIZADOR, 0x10002000

.global _start

_start:

movia r16, UARTDATA     # r8 <- &uartdata
movia r17, UARTCONTROL # r10 <- &uartcontrol
movia sp, STACKPOINTER

movia r9, TEMPORIZADOR
    movia r10, TEMPO

    andi r11, r10, 0xffff # low
    srli r12, r10, 16     # high    
    stwio r11, 8(r9)   # set counter start value (low)
    stwio r12, 12(r9)   # set counter start value (high)

    # habilitar a interrupção do key 1 e 2
    movi r14, 7           # r14 <- 7 (mascara para start cont e ito)
    stwio r14, 4(r9)     # habilita start cont e ito
    
    # habilitar a interrupção do temporizador no ienable
    movi r14, 1
    wrctl ienable, r14

    # habilitar o bit PIE do status
    wrctl status, r14  

br POLLING

PULA_ACENDE_APAGA:
    movia r23,FLAG_ANIMACAO
    movi r18,1
    stb r18,(r23)
    call ACENDE_APAGA
    mov r22, r0     # resetando o ponteiro para o  buffer de entrada

    br POLLING
    
PULA_ANIMACAO:
    movia r23,FLAG_ANIMACAO
    stb r3, (r23)
    mov r22, r0     # resetando o ponteiro para o  buffer de entrada

    br POLLING

PULA_CRONOMETRO:
    call CRONOMETRO
    mov r22, r0     # resetando o ponteiro para o  buffer de entrada

    br POLLING

SWITCH_COMMAND:
    movia r21, BUFFER_ENTRADA # resetando r21 para apontar para o primeiro elemento do vetor

    ldb r18,(r21)           # lendo o primeiro valor do buffer

    ldb r19,1(r21)          # lendo o segundo valor do buffer

    add r3, r19, r0

    addi r3,r3,-0x30

/*
    ldb  r20,3(r21)            # pegando o primeiro número do parâmetro

    ldb  r22,4(r21)            # pegando o segundo número do parâmetro

    addi r20, r20,-0x30           # subtraindo o código asc para se tornar um número

    slli r23,r20,3

    slli r20,r20,1

    add r20,r23,r20

    addi r22, r22,-0x30           # subtraindo o código asc para se tornar um número

    add r2, r20, r22            # Parâmetro da sub rotina
*/
    # addi r21, r21, 1          # apontando para o segundo elemento do ponteiro

    movi r19, '0'
    beq r18, r19, PULA_ACENDE_APAGA

    movi r19, '1'
    beq r18, r19, PULA_ANIMACAO

    movi r19, '2'
    beq r18, r19, PULA_CRONOMETRO 


POLLING:

    ldwio r18, (r16)          # carrega UART em r9     
    andi r19, r18, 0x8000    # mascara para os bits RVALID
    beq r19, r0, POLLING

    stwio r18,(r16)

    andi r20, r18, 0xff # separando o byte do caractere lido

    movi r23, 0x0A

    beq r20, r23, SWITCH_COMMAND # verificando se usuário apertou ENTER

    movia r21, BUFFER_ENTRADA
    add r21, r21, r22     # incrementando o buffer
    stb r20, (r21) # escrevendo no buffer
    addi r22, r22, 1    # incrementando indice do buffer
    br POLLING

.global BUFFER_ENTRADA
BUFFER_ENTRADA:
    .skip 10 # Máximo de 10 caracteres para tratar

.global FLAG_ANIMACAO

FLAG_ANIMACAO: .byte 1