# Verificação de acessos ilegais ao array 

1. É necessário corrigir i <= LENGTH para i < LENGTH 
2. Adiciona-se __CPROVER_assume(u != NULL 
            && __CPROVER_OBJECT_SIZE(u) == sizeof(int) * size
            && size > 0 
            && size <= max_int);
 

# Teste de Invariantes
Adicionei isto ao ciclo 
        /* 1 - Fails
        int k = nondet_int();
        __CPROVER_assume(0 <= k && k <= i);
        assert(vec[k] <= vec[max]);
        */
        /* 2 - Fails
        int k = nondet_int();
        __CPROVER_assume(0 <= k && k < i);
        assert(vec[k] < vec[max]);
        */
        /* 3 - Passes
        int k = nondet_int();
        __CPROVER_assume(0 <= k && k < i);
        assert(vec[k] <= vec[max]);
        */
        /* 4 - Fails
        int k = nondet_int();
        __CPROVER_assume(0 <= k && k <= i);
        assert(vec[k] < vec[max]);
        */ 

