.global ACENDE_APAGA

.equ ENDERECO_LED_VERMELHO, 0x10000000
.equ POSICAO_LED_VERMELHO, 0x1

ACENDE_APAGA:

    movia r12, STATUS_LEDS

    ldw r11,(r12)   # carregando o estado dos leds

    movia r8, ENDERECO_LED_VERMELHO

    movia r10, POSICAO_LED_VERMELHO

    movi r13, '1'

    sll r10, r10, r2

    beq r3, r13, APAGA_LED

ACENDE_LED:
    or r11, r11, r10    # guardando os estados dos leds
    br SALVA_LED

APAGA_LED:
    nor r10,r10,r10     
    and r11,r11,r10     # guardando os estados dos leds

SALVA_LED:
    stwio r11, (r8)

    stw r11,(r12)

    ret

 STATUS_LEDS: .word 0   # guardando os status dos leds
