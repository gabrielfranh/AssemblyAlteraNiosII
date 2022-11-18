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

.equ UARTDATA, 0x10001000
.equ UARTCONTROL, 0x10001004
.equ so, 0x100000

.global _start

_start:

movia r16, UARTDATA     # r8 <- &uartdata
movia r17, UARTCONTROL # r10 <- &uartcontrol

br POLLING

PULA_ACENDE_APAGA:
    call ACENDE_APAGA
    mov r22, r0

    br POLLING
    
PULA_ANIMACAO:
    call ANIMACAO
    mov r22, r0

    br POLLING

PULA_CRONOMETRO:
    call CRONOMETRO 
    mov r22, r0

    br POLLING

SWITCH_COMMAND:
    movia r21, BUFFER_ENTRADA # resetando r21 para apontar para o primeiro elemento do vetor
    ldw r23, (r21)            # lendo o primeiro byte do vetor de caracteres

    andi r18, r23, 0xFF

    addi r21, r21, 1          # apontando para o segundo elemento do ponteiro

    stw r23, (sp)

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

    andi r20, r18, 0xff # separando o byte do caractere lido

    movi r23, 0x0A

    beq r20, r23, SWITCH_COMMAND # verificando se usuário apertou ENTER

    movia r21, BUFFER_ENTRADA
    add r21, r21, r22     # incrementando o buffer
    stb r20, (r21) # escrevendo no buffer
    addi r22, r22, 1    # incrementando indice do buffer
    br POLLING

BUFFER_ENTRADA:
    .skip 10 # Máximo de 10 caracteres para tratar