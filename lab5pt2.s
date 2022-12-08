/*
    1. habilitar o bit 2 do interrupt mask do PB
    2. habilitar o bit 2 no ienable
    3. habilitar o bit PIE do processador
 */  

.equ CHAVES,             0x40
.equ LEDVERDE,           0x10
.equ PB_EDGE_CAPT,       0x5C
.equ PB_INTERRUPT,       0x58
.equ DISPLAY_7SEG,        0x20
.equ IO_BASE,            0x10000000 
 
.org 0x20

    rdctl   et, ipending                # carregando interrupção no registrador temporario
    beq     et, r0, GO_BACK             # caso et seja == 0, nao é interrupção de hardware
    subi    ea, ea, 4                   # regra (sempre que for hardware, o retorno vai pra proxima interrupcao, para voltar, subtrair 4)

    andi    r13, et, 2                  # r13 recebe bit do pushbtn_1
    beq     r13, r0, GO_BACK            # se for zero nao é interrupcao do pushbtn
    call    TRATA_PB

GO_BACK: 

    eret                                # sai da interrupcao, volta pro _start

TRATA_PB:
    ldwio   r13, PB_EDGE_CAPT(r9)       # carrega PB em r13
    andi    r13, r13, 2                 # apenas bit key1 de PB
    beq     r13, r0, MOSTRA_DISPLAY

    ldwio r11, CHAVES(r9)               # valor = leitura chave
    andi r11,  r11, 0b11111111          # isolando os 8 primeiros bits do led
    add r8, r8, r11                     # acumulador += valor

    stwio r8, LEDVERDE(r9)              # printando acumulador nos leds verdes

    br FIM_TRATA_PB
MOSTRA_DISPLAY: 

    movia   r11, TABELA_7SEG            # endereço da tabela    
    
    # apresenta o primeiro display 
    andi    r12, r8, 0x0F               
    add     r11, r11, r12               # indexa a tabela
    ldb     r11, (r11)
    stbio   r11, DISPLAY_7SEG(r9)         

    movia   r11, TABELA_7SEG            # endereço da tabela    

    # apresenta o segundo display 
    srli    r12, r8, 4
    andi    r12, r12, 0x0F
    add     r11, r11, r12               # indexa a tabela
    ldb     r11, (r11)
    stbio   r11, DISPLAY_7SEG+1(r9)    

FIM_TRATA_PB:
    
    stwio r0, PB_EDGE_CAPT(r9)          # zerando a flag
    ret

.global _start
_start:

    movia r9, IO_BASE

    movi  r10, 6                     # valor utilizado para atualizar apenas o key1 e key2
    stwio r10, PB_INTERRUPT(r9)      # habilitando interrupção do key1

    wrctl ienable, r10               # habilitando o PB no ienable (ctl3)

    movi  r10, 1

    wrctl status, r10                # habilitando o bit PIE do registrador status (ctl0)   

    mov   r8, r0                   
    mov   r12, r0  

    LACO:
    br  LACO
    


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

.end