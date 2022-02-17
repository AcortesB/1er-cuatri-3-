EJERCICIO 1

//Funcion que calcula a^n
function powRec(a, n)

{

    numIter++;

    if (n===0) {

        return 1;

       } else {

        return a * powRec(a, n-1);

                     }

}


a) Hazla recursiva pero aún secuencial, sin paralelizar
function powRec(a, n)
{
    int res;
    numIter++;

    if (n<=0) {
        return 1;
    } else {
        res1 = a * powRec(a, n-1);
        res2 = a * powRec(a, n-2);
        res = res1 * res2;
     }
     return res;
}

-----------------------------------------------------------------------------------------------------------

b) Paraleliza el código usando Leaf o Tree strategy
function powRec(a, n)
{
    int res;
    numIter++;

    if (n<=0) {
        return 1;
    } else {
        #pragma omp task shared(res1)
        res1 = a * powRec(a, n-1);
        #pragma omp task shared(res2)
        res2 = a * powRec(a, n-2);
        #omp taskwait

        res = res1 * res2;
     }
     return res;

}

//en el main se la llamaría de esta manera
int main(){

...
#pragma omp parallel
#pragma omp single
powRec(2,3);
...

}

He escogido la estrategia tree, ya que con la estrategia leaf se nos crean las tareas secuencialmente y con la tree se generan las tareas paralelamente. Cuantas más tareas más paralelizable será nuestro código.

EJERCICIO 2:

int X[n][n], COEFF[n];

...

for (int i = 1; i < n-1; i++) {

for (int k = 1; k < n-1; k++) {

       int tmp = X[i][k] + X[i][k-1] - X[i-1][k] - COEFF[k];

      X[i][k] = tmp/4;

                   }

}

apartado a
a) En un sistema de memoria compartida, lo queremos paralelizar mediante OpenMP de manera que cada iteración del bucle más interno de i, k sea una tarea con #pragma omp task. Ten en cuenta la dependencia entre tareas y resuélvelo como creas más conveniente.

    int X[n][n], COEFF[n];

    ...

    for (int i = 1; i < n-1; i++) {
        for (int k = 1; k < n-1; k++) {
            #pragma omp task depend (out: X[i][k])
            {
                 int tmp = X[i][k] + X[i][k-1] - X[i-1][k] - COEFF[k];
                 X[i][k] = tmp/4;
            }
        }
    }
    
b) Queremos paralelizar mediante #pragma omp taskloop el bucle de las i de manera que cada procesador realice n/P iteraciones.

int X[n][n], COEFF[n];

...
#pragma omp taskloop
for (int i = 1; i < n-1; i++) {
    //asi cada uno hace n/P iteraciones
    int num_procesador = omp_get_thread_num();
    int num_de_procesadores = omp_get_num_threads();
    int i_start = num_procesador * (n/num_de_procesadores);
    int i_end = i_start + (n/num_de_procesadores);
    //si el procesador es el últimom diremos que i_end es n para que no se pase
    if (num_procesador == num_de_procesadores-1) i_end = n;
    for (int ii = i_start; ii < i_end; ii++;)
         for (int k = 1; k < n-1; k++) {

          int tmp = X[ii][k] + X[ii][k-1] - COEFF[k];

          X[ii][k] = tmp/4;

           }

}


EJERCICIO 3

int X[n][n], COEFF[n];

int nblocksi=4;

int nblocksk=4;

 for (int blocki=0; blocki<nblocksi; ++blocki)

 {

      int i_start=blocki * (n/ nblocksi);

      int i_end = (blocki+1) * (n/ nblocksi);

      for (int blockk=0; blockk<nblocksk; ++blockk)

       {

        int k_start = blockk * (n/ nblocksk);

        int k_end = (blockk+1) * (n/ nblocksk);

       for (int i=max(1, i_start); i<min(n-1, i_end); i++)

          {

              for (int k=max(1, k_start); k<min(n-1, k_end); k++)

                {

                  int tmp = X[i][k] + X[i][k-1] - X[i-1][k] - COEFF[k];

                    X[i][k] = tmp/4;

                   }

            }

        }

}

a) Realiza una paralelización de manera que cada iteración del bucle blocki, blockk sea una tarea (#pragma omp task). Ten en cuenta dependencia entre tareas con depend.
int X[n][n], COEFF[n];

    int nblocksi=4;

    int nblocksk=4;

    for (int blocki=0; blocki<nblocksi; ++blocki)
    {
        int i_start=blocki * (n/ nblocksi);
        int i_end = (blocki+1) * (n/ nblocksi);
        for (int blockk=0; blockk<nblocksk; ++blockk)
        #pragma omp task firstprivate(blocki, i_start, i_end)
        {
            int k_start = blockk * (n/ nblocksk);
            int k_end = (blockk+1) * (n/ nblocksk);
            for (int i=max(1, i_start); i<min(n-1, i_end); i++)
            {
                for (int k=max(1, k_start); k<min(n-1, k_end); k++)
                {
                    int tmp = X[i][k] + X[i][k-1] - X[i-1][k] - COEFF[k];
                    X[i][k] = tmp/4;
                }
            }
        }
        #pragma omp taskwait
    }
