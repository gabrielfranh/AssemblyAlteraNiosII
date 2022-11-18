.global ACENDE_APAGA

.equ ENDERECO_LED_VERMELHO, 0x10000000
.equ POSICAO_LED_VERMELHO, 0x1

ACENDE_APAGA:

    ldw r12, (sp)

    addi r13, r12, 0xFF

    movia r8, ENDERECO_LED_VERMELHO

    movia r10, POSICAO_LED_VERMELHO

    sll r10, r10, r11

    stwio r10, (r8)

    ret