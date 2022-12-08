.global ACENDE_APAGA

.equ ENDERECO_LED_VERMELHO, 0x10000000
.equ POSICAO_LED_VERMELHO, 0x1

ACENDE_APAGA:

    movia r21, BUFFER_ENTRADA # resetando r21 para apontar para o primeiro elemento do vetor

    ldb  r20,3(r21)            # pegando o primeiro número do parâmetro

    ldb  r22,4(r21)            # pegando o segundo número do parâmetro

    addi r20, r20,-0x30           # subtraindo o código asc para se tornar um número

    slli r23,r20,3

    slli r20,r20,1

    add r20,r23,r20

    addi r22, r22,-0x30           # subtraindo o código asc para se tornar um número

    add r2, r20, r22            # Parâmetro da sub rotina

    movia r12, STATUS_LEDS

    ldw r11,(r12)   # carregando o estado dos leds

    movia r8, ENDERECO_LED_VERMELHO

    movia r10, POSICAO_LED_VERMELHO

    movi r13, 1

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
