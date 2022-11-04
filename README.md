(PT_BR)

Programa com o intuito de aplicar os conceitos aprendidos na disciplina de Microprocessadores II. Semelhante à um parser muito simplificado, o programa usa a técnica de polling para esperar um código de I/O através do console. Segue os códigos:
  00 xx -> O programa irá acender os x-ésimos leds vermelhos da placa Altera Nios II.
  01 xx -> Apagar x-ésimo led vermelho
  10 -> Animacão com os leds vermelhos dada pelo estado da chave SW0: se para baixo, no sentido horario; se para cima, sentido anti-horário. A animação consiste em acender um led vermelho por 200ms, apaga-lo e então acender seu vizinho (direita ou esquerda, dependendo do estado da chave SW0). Este processo deve ser continuado repetidamente para todos os leds vermelhos.
  11 -> Parar animação dos leds vermelhos
  20 -> Inicia cronometro de segundos, utilizando 4 displays de 7 segmentos. Adicionalmente, o botão KEY1 deve controlar a pausa do cronometro: se contagem em andamento, deve ser pausada; se pausada, contagem deve ser resumida.
  21 -> Cancela cronômetro
  
  (EN)
  
  Program with the aim to apply the concepts learned in Microprocessor II lecture. Similar to a simplify parser, the program uses polling to await the I/O input in the program console. They are:
    00 xx -> Turn on xx red led light
    01 xx -> Turn off xx red light
    10 -> Animation with the red LEDs given by the status of the SW0 switch: if down, clockwise; if up, counterclockwise. The animation consists of turning on a red LED for 200ms, turning it off and then turning on its neighbor (right or left, depending on the state of the SW0 switch). This process must be continued repeatedly for all red LEDs.
    11 -> Stop red light animation
    20 -> Starts a second timer, using 4 7-segment displays. Additionally, the KEY1 button must control the stopwatch pause: if counting in progress, it must be paused; if paused, the count should be resumed. 
    21 -> Cancel timer
