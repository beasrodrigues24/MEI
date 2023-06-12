# Sistemas de Transição de Estados e Atomicidade

# Sistemas de Transição de Estados

Um dos modelos mais comuns da computação são os sistemas de transição de estados. Um sistema de transição de estados inclui:

- Um conjunto de estados S.
- Um conjunto de estados iniciais I⊆S.
- Uma relação de transição entre estados R⊆S×S.

Um comportamento (ou traço) do sistema é uma sequência de estados π=s0,s1,s2,… tal que s0∈I e ∀i∈N⋅(s_{i},s_{i+1})∈R. Para simplificar a semântica da lógica temporal que vamos usar para especificar as propriedades destes sistemas, é frequente assumir-se que todos os comportamentos possíveis são infinitos. Para tal exige-se que a relação R seja total, ou seja, ∀s∈S⋅∃s′∈S⋅R(s,s′).

# Semântica de algoritmos imperativos

Podemos dar semântica a algoritmos imperativos usando sistemas de 
transição de estados. Os estados possíveis correspondem a todas as 
possíveis valorações das variáveis usadas no algoritmo. No entanto, para se conseguir distinguir em que ponto da execução se encontra o algoritmo é necessário incluir uma variável extra por cada processo (um *program counter*) que distingue qual a instrução que vai ser executada a seguir. Para facilitar a especificação vamos etiquetar as instruções do algoritmo, 
tal como no seguinte algoritmo para calcular o valor absoluto.

```c
var r : integer = n;

0: if r < 0 then 
1:   r := -r
2:
```

Como o valor de `n` é arbitrário, para este algoritmo teremos um conjunto infinito de 
possíveis estados. Nem todos estes estados são acessíveis a partir de um estado inicial. Por exemplo, estados onde `n = 3` e `r = 10`não serão acessíveis. Ao desenhar o sistema de transição que modela um algoritmo vamos usualmente mostrar apenas os estados acessíveis a partir de estados iniciais, tal como no sistema de transição seguinte que modela o algoritmo acima. Note os lacetes nos estados terminais, por forma a cumprir o requisito de a relação de transição ser total: vamos assumir que após terminar a execução, o algoritmo fica num *livelock* no *program counter* final.

![Untitled](Sistemas%20de%20Transic%CC%A7a%CC%83o%20de%20Estados%20e%20Atomicidade/Untitled.png)

Como referido acima, no caso de algoritmos concorrentes será necessário um *program counter* por cada processo.

```c
   var x : integer = 0

   procedure increment;
   begin
0:   x := x + 1
1: end;

   increment || increment
```

![Untitled](Sistemas%20de%20Transic%CC%A7a%CC%83o%20de%20Estados%20e%20Atomicidade/Untitled%201.png)

**Exercício**: desenhe o sistema de transição de estados correspondente ao seguinte algoritmo concorrente.

```c
   var
     x : integer = 0;

   procedure increment;
   var
     y : integer = 0;
   begin
0:   y := x;
1:   x := y + 1
2: end;

   increment || increment
```

R:

![Untitled](Sistemas%20de%20Transic%CC%A7a%CC%83o%20de%20Estados%20e%20Atomicidade/Untitled%202.png)

**Exercício**: desenhe o sistema de transição de estados correspondente ao seguinte algoritmo concorrente.

```c
   var x : integer = 0

   procedure increment;
   begin
0:   x := x + 1
1: end;

   increment || increment || increment
```

R:

![Untitled](Sistemas%20de%20Transic%CC%A7a%CC%83o%20de%20Estados%20e%20Atomicidade/Untitled%203.png)

**Exercício**: quantos comportamentos possíveis tem este algoritmo? se em vez de 3 tivéssemos N processos quantos comportamentos possíveis haveria? 

<aside>
R: N!
</aside>

# Atomicidade

Para simplificar a modelação e análise estamos a assumir que todas as instruções de um processo executam de forma *atómica*, isto é sem interrupção de outros processos. Por exemplo, no algoritmo com duas threads assumimos que `x := x + 1` executa de forma atómica. De facto, isto não é garantido pois a  execução desta instrução implica uma leitura da memória do valor actual 
de `x` e uma posterior escrita de `x + 1`. Entre estas duas instruções máquina o processo poderia ser  interrompido, pelo que na prática a execução desta instrução é semelhante a executar as instruções `y := x; x := y+1` assumindo que `y` é uma variável local do processo.

Por vezes, para simplificar ainda mais a modelação e tornar a análise mais eficiente (porque o número de traços possíveis diminui significativamente) vamos agrupar várias instruções para executar de forma atómica. Para sinalizar isso iremos simplesmente reduzir o número de etiquetas no algoritmo e assumir que todas as instruções entre duas etiquetas executam de forma atómica. Note que em algoritmos concorrentes isto pode mascarar potenciais problemas e tal deve ser feito com muito cuidado. Em algoritmos distribuídos é mais frequente fazer isso, e assumir, por exemplo, que todo o código que processa uma determinada mensagem recebida executa de forma atómica.

Por exemplo, em vez de 3 podemos colocar apenas 2 etiquetas no algoritmo que calcula o valor absoluto, fazendo com que todo o 
condicional execute de forma atómica.

```c
   var r : integer = n;

0: if r < 0 then r := -r
1:
```

Neste caso o sistema de transição de estados que modela este algoritmo passaria a ser o seguinte.

![Untitled](Sistemas%20de%20Transic%CC%A7a%CC%83o%20de%20Estados%20e%20Atomicidade/Untitled%204.png)

Já no exemplo com 2 processos que incrementam uma variável partilhada, mas que primeiro fazem uma cópia da mesma para uma variável local, se executarmos as 2 atribuições de forma atómica passamos a ter um sistema de transição equivalente ao que modela a versão desse algoritmo sem cópia local.

```c
   var
     x : integer = 0;

   procedure increment;
   var
     y : integer = 0;
   begin
0:   y := x;
     x := y + 1
1: end;

   increment || increment
```

Considere a a seguinte versão do algoritmo de Peterson, onde usamos atomicidade para dividir a execução de cada processo em três fases: pedir para entrar na região crítica (etiqueta 0); esperar para entrar (etiqueta 1); e sair da região crítica (etiqueta 2).

```c
var 
     turn : 0..1;
     want0 : boolean = false;
     want1 : boolean = false;

   procedure process0;
   begin
     while true do                           
     begin
0:     (* idle *) 
       want0 := true; 
       turn := 1;  
1:     repeat until (not want1 or turn = 0);
       (* critical *) 
2:     want0 := false 
     end
   end;

   procedure process1;
   begin
     while true do                           
     begin
0:     (* idle *) 
       want1 := true; 
       turn := 0;  
1:     repeat until (not want0 or turn = 1);
       (* critical *) 
2:     want1 := false
     end 
   end;

   process0 || process1
```

Este algoritmo seria modelado pelo seguinte sistema de transição.

![Untitled](Sistemas%20de%20Transic%CC%A7a%CC%83o%20de%20Estados%20e%20Atomicidade/Untitled%205.png)

Como se pode ver neste exemplo, mesmo um sistema de transição finito pode ter um número infinito de comportamentos diferentes!

**Exercício**: desenhe o sistema de transição correspondente ao seguinte algoritmo de exclusão mútua que usa um semáforo para controlar o acesso à região crítica.

```c
var 
     sem : boolean = true;

   procedure process;
   begin
0:   while true do
     begin
       (* idle *)
1:     repeat until sem;
       sem := false;
       (* critical *)
2:     sem := true;
     end
   end;

   process || process
```
R: 

![Untitled](Sistemas%20de%20Transic%CC%A7a%CC%83o%20de%20Estados%20e%20Atomicidade/Untitled%206.png)