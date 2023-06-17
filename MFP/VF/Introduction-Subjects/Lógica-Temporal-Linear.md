# Lógica Temporal Linear

# Definição

Para especificar propriedades de algoritmos reativos, concorrentes ou distribuídos, é frequente usar-se lógica temporal linear (*Linear Temporal Logic*). A ideia de especificar propriedades de algoritmos desta natureza usando lógica temporal deve-se a [Amir Pnueli](https://en.wikipedia.org/wiki/Amir_Pnueli), ideia pela qual recebeu um prémio Turing em 1996. Ao contrário das 
asserções usadas na lógica de Hoare, cuja validade é verificada num estado do algoritmo, as asserções em lógica temporal linear são verificadas em comportamentos do algoritmo, ou seja, sequências de estados possíveis. Um algoritmo satisfaz uma asserção em lógica temporal sse esta for válida em todos os seus possíveis comportamentos. Para além das conectivas usuais da lógica proposicional, na versão mais simples da lógica temporal temos as conectiva temporais □ (*always*) e ◯ (*next* ou *after*), que, quando aplicada a uma proposição, verificam se esta é válida em todos os estados de um comportamento ou no estado seguinte, respetivamente. A gramática desta lógica é então definida como

<aside>
💡 formula≐predicate
          ∣¬formula
          ∣formula∧formula
          ∣◯ formula
          ∣□ formula

</aside>

onde predicate é um predicado arbitrário envolvendo as variáveis do algoritmo.

A semântica da lógica temporal linear é definida sobre sistemas de transição de estados. Uma fórmula é válida num sistema de transição sse for válida em todos os seus comportamentos. O facto de uma fórmula F ser válida num comportamento s0,s1,… é denotado por s0,s1,…⊨F. Esta noção de validade pode ser definida recursivamente na estrutura das fórmulas da seguinte forma (F e G representam fórmulas arbitrárias e P um predicado arbitrário).

<aside>
💡 s0,s1,…⊨P       ≡ s0⊨P
s0,s1,…⊨¬F     ≡ s0,s1,…⊭F
s0,s1,…⊨F∧G ≡ s0,s1,…⊨F∧s0,s1,…⊨G
s0,s1,…⊨◯F     ≡ s1,s2,…⊨F
s0,s1,…⊨□F     ≡ ∀i≥0⋅si,si+1,…⊨F

</aside>

Usando estas conectivas podemos definir alguns operadores derivados, por exemplo, F∨G≐¬(¬F∧¬G) ou F⇒G≐¬F∨G. Temos também o operador derivado ◊ (*eventually*), que se define como ◊F≐¬□¬F. Também podemos definir diretamente a semântica deste operador da seguinte forma.

<aside>
💡 s0,s1,…⊨◊F ≡ ∃i≥0⋅si,si+1,…⊨F

</aside>

Alguns exemplos de fórmulas LTL e a respetiva semântica informal (onde P e Q representam predicados arbitrários):

- P, o predicado P é verdade em todos os estados iniciais.
- □P, o predicado P é verdade em todos os estados de todos os comportamentos.
- ◊P, o predicado P será inevitavelmente verdade nalgum estado de todos os comportamentos.
- □(P⇒◊Q), sempre que P é verdade Q terá que inevitavelmente ser verdade depois.
- ◊□P, em todos os comportamentos vai-se atingir um estado onde a partir do qual P é sempre verdade.
- □◊P, o predicado P é recorrentemente verdade em todos os comportamentos.

As duas propriedades fundamentais do algoritmo de exclusão mútua de Peterson podem ser expressas da seguinte forma:

- □¬(pc0=2∧pc1=2), os dois processos nunca estão na região critica ao mesmo tempo (*mutual exclusion*).
- □(pc0=1⇒◊(pc0=2))∧□(pc1=1⇒◊(pc1=2)), sempre que um processo pretende aceder à região crítica irá conseguir (*no starvation*).

**Exercício**: como poderia especificar que o este algoritmo não tem um *deadlock*?

Relembre o seguinte algoritmo que multiplica um inteiro não negativo `a` por `b`, colocando o resultado em `r`:

```c
var 
     r : integer = 0;
     n : integer = 0;

0: while n < a do
   begin
1:   n := n + 1;
2:   r := r + b
   end
3:
```

<aside>
💡 ◊(pc = 3)

</aside>

**Exercício**: especifique as seguintes propriedades deste algoritmo.

- No estado inicial `n` e `r` têm o valor 0.

<aside>
💡 n = 0 /\ r = 0

</aside>

- A variável `n` nunca tem um valor negativo.

<aside>
💡 □(n ≥ 0)

</aside>

- O algoritmo termina sempre.

<aside>
💡 ◊(pc = 3)

</aside>

- Se inicialmente `a` for não negativo, no final da execução a variável `r` tem o produto de `a` e `b`.

<aside>
💡 □(pc = 3 ⇒ r = a * b)

</aside>

- O predicado `r = n * b` é um invariante do ciclo.

<aside>
💡 □(pc = 0 ⇒ r = n*b)

</aside>

Considere o seguinte algoritmo.

```c
var 
     r : integer = 0;
     n : integer;

0: while n >= 0 do
   begin
     n := n - 1;
     r := mod (r + 1) 2
   end
1:
```

**Exercício**: especifique as seguintes propriedades deste algoritmo.

- Se inicialmente `n` for não negativo o algoritmo termina.

<aside>
💡 □(n ≥ 0 ⇒ ◊(pc = 1))
- safety

</aside>

- Se inicialmente `n` for negativo o valor de `r` será recorrentemente `0` e recorrentemente `1`.

<aside>
💡 n < 0 ⇒ □◊(r = 0 || r = 1 )
- liveness

</aside>

- Se inicialmente `n` for par então quando o algoritmo termina `r` é `0`.

<aside>
💡 n%2 == 0 ⇒ □(pc = 1 ⇒ r = 0)
- safety

</aside>

- Enquanto o `n` for não negativo o valor de `r` está sempre a oscilar entre `0` e `1`.

<aside>
💡□(n ≥ 0 ⇒ ((r=0 ⇒ ◯(r=1))/\ (r=1 ⇒ ◯(r=0)) 
- liveness

</aside>

- O algoritmo termina logo que o `n` seja negativo.

<aside>
💡 □(n < 0 ⇒ ◯(pc = 1)) - liveness

</aside>

# Safety vs. Liveness

Considere mais uma vez as duas propriedades fundamentais do algoritmo de exclusão mútua de Peterson:

- □¬(pc0=2∧pc1=2), os dois processos nunca estão na região critica ao mesmo tempo.
- □(pc0=1⇒◊(pc0=2))∧□(pc1=1⇒◊(pc1=2)), sempre que um processo pretende aceder à região crítica irá conseguir.

Estas duas propriedades são de uma natureza bastante diferente:

- A primeira é uma propriedade de *safety* que proíbe certos estados “maus” de acontecerem (neste caso os estados onde ambos os processos estão na região crítica). Um contra-exemplo para esta propriedade teria um prefixo que termina num estado “mau”, não importando o que acontece depois (qualquer comportamento com o mesmo prefixo será um contra-exemplo).
- A segunda é uma propriedade de *liveness* que força certos estados “bons” a acontecerem em certas condições (neste caso um estado onde um dos processos está na região crítica). Um contra-exemplo para esta propriedade tem que ser um comportamento completo onde o estado “bom” nunca chega a acontecer.

**Exercício**: classifique todas as propriedades anteriores como sendo de *safety* ou *liveness*;
 para tal pense se, para encontrar os respetivos contra-exemplos, apenas basta apresentar um prefixo finito de um comportamento, ou se teremos que apresentar todo o comportamento.

<aside>
💡 Anotados acima

</aside>

# Model checking explícito

O *model checking* é uma técnica para verificar automaticamente se uma fórmula em lógica temporal é válida num modelo de um algoritmo (um sistema de transição de estados). Para que tal seja possível, o sistema de transição de estados tem que ser finito. Um *model checker* tenta encontrar um contra-exemplo para a fórmula, e se não o encontrar então a fórmula é válida.

No caso das propriedades de *safety* basta encontrar um prefixo que leva a um estado “mau”, logo a técnica de model checking é muito simples: basta fazer uma travessia no grafo e ver se esse estado “mau” é alcançável a partir de um estado inicial. Se quisermos garantir que é mostrado o contra-exemplo mais curto possível basta usar uma travessia *breadth first*. Assim, a verificação de uma propriedade de *safety* pode ser feita em tempo linear no tamanho do sistema de transição.

Para encontrar um contra-exemplo para uma propriedade de liveness temos que encontrar um comportamento completo (infinito) onde o estado “bom” nunca acontece. Obviamente, se quisermos mostrar esse contra-exemplo ao utilizador, ele terá que ser representado de forma finita: um prefixo finito de estados seguido de um segmento finito que se repete para sempre (um traço com um ciclo). Note que nem todos os comportamentos de um sistema de transição podem ser representados de forma finita, mas um dos resultados mais importantes da lógica temporal é que se uma fórmula não é válida então terá que ter pelo menos um contra-exemplo que pode ser representado de forma finita, pelo que o model checking pode restringir a sua procura a este tipo de comportamentos. Na prática, para encontrar contra-exemplos temos que encontrar ciclos no sistema de transição onde o estado “bom” nunca acontece.

Considere, por exemplo, a propriedade de liveness ◊P. Uma forma eficiente de encontrar contra-exemplos para esta propriedade (comportamentos com um ciclo onde todos os estados satisfazem ¬P) consiste em usar a seguinte técnica:

- Restringir o sistema de transição apenas aos estados que satisfazem ¬P.
- Calcular os componentes fortemente ligados deste sistema de transição restrito.
- Usar uma única travessia para ver se algum dos componentes fortemente ligados não triviais (componentes com mais de um estado ou com apenas um estado com um lacete) é acessível a partir de um estado inicial (a travessia é feita no grafo invertido começando nos estados dentro dos componentes fortemente ligados não triviais).
- Se tal for possível então temos um contra-exemplo, pois dentro de um componente fortemente ligado não trivial conseguimos ter um ciclo infinito.

Esta técnica pode ser generalizada para verificar qualquer fórmula em lógica temporal linear e pode ser executada em tempo linear devido ao algoritmo de calculo de componentes fortemente ligados inventado por Robert Tarjan, pelo qual recebeu um prémio Turing em 1986 (entre outros algoritmos). A ideia de usar este algoritmo para fazer model checking eficiente de fórmulas em lógica temporal deve-se a Edmund Clarke, Ernerst Emerson e Joseph Sifakis, pela qual também receberam um prémio Turing em 2007.

Esta técnica de model checking designa-se de explícita, porque constrói explicitamente o sistema de transição em memória (o espaço de memória que consome é linear). Como o número de estados cresce exponencialmente com o número de variáveis usados num algoritmo, esta técnica pode não conseguir analisar certos algoritmos. Existe uma técnica alternativa, designada de model checking simbólico, onde o sistema de transição não é construído explicitamente, mas representado implicitamente através de fórmulas.

**Exercício**: no seguinte sistemas de transição dê 
exemplos de comportamentos que podem ser representados de forma finita e
 comportamentos que não podem ser representados de forma finita.

![Untitled](Lo%CC%81gica%20Temporal%20Linear/Untitled.png)

R: 

**Exercício**: como pode ser adaptada a técnica acima apresentada para encontrar contra-exemplos para a fórmula □(P⇒◊Q)?

R: 

**Exercício**: use essa adaptação para verificar se a propriedade de *no starvation* é válida para algoritmos de exclusão mútua de Peterson e com semáforos.

R:
