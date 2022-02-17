#include <stdio.h> 
#define MIN_POWER 10 
#define CUTOFF
#define MAX_TOTAL_CREATED_TASKS = 64

long int getPower_iterative(int b, int p) { 
    long int result=1; 
    for(int i=0; i<p; i++) 
        result = result * b; 
    return result; 
} 
    
long int getPower_recursive(int b,int p, int contador_tareas) { 
    long int result;
     
    if(p<MIN_POWER) 
        result = getPower_iterative(b,p); 
    else
    {
        //si las tareas no llegan al límite hago tareas y en cada llamada incremento contador de tareas
        if ( contador_tareas < MAX_TOTAL_CREATED_TASKS )  
        {
            #pragma omp task shared (result1)
            result1 = getPower_recursive(b ,p/2, contador_tareas+1);
            #pragma omp task shared (result2)
            result2 = getPower_recursive(b ,p-p/2, contador_tareas+1); 
            #pragma taskwait
            
        }else{
            //ahora no incremento contador_tareas
            result1 = getPower_recursive(b ,p/2, contador_tareas);
            result2 = getPower_recursive(b ,p-p/2, contador_tareas); 
        }
        result = result1 * result2;
    }
    return result; 
} 

int main() { 
    int base, power; 
    long int result; 
    ... 
    #pragma omp parallel
    #pragma omp single
    result = getPower_recursive(base, power, 0); 
    ... 
}

//tree or leaf
