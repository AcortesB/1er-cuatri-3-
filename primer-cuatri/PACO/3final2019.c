#define MAX_ELEM 1024*1024
#define HIST_SIZE 250
unsigned int numbers[MAX_ELEM];
unsigned int frequency[HIST_SIZE];
void ReadNumbers (int * input, int * size);

void FindBounds(int * input, int size, int * min, int * max) {
    #pragma omp parallel reduction(min:min) reduction(max:max)
    {
        //vemos el numero de thread que somos
        int my_id = omp_get_thread_num();
        //vemos cuantos threads estan participando
        int howmany = omp_get_num_threads();
        //hacemos los bucles sumandole el numero de procesadores cada vez
        for (int i=my_id; i<size; i += howmany)
            if (input[i]>(*max)) (*max)=input[i];
        for (int i=my_id; i<size; i += howmany)
            if (input[i]<(*min)) (*min)=input[i];
    }
}

void FindFrequency(int * input, int size , int * histogram, int min, int max) {
    
    int tmp;
    #pragma omp parallel private(tmp)
    {
        //coge su num de thread
        int myid = omp_get_thread_num();
        //mira cuantos threads participan
        int numprocs = omp_get_num_threads();
        //el tamaño de la matriz / numero de procesadores = tamaño de bloque
        //para ponernos donde toca: numero de thread * tamaño de bloque
        int i_start = myid * (HIST_SIZE/numprocs);
        //definimos el final del bloque indicando que dura desde i_start a (MATSIZE/numprocs)
        int i_end = i_start + (HIST_SIZE/numprocs);
        
        //si el numero de thread es uno menos que el numero de procesadores
        //especifica que el final de ese bloque será el HIST_SIZE ( el tamaño de la matriz )
        if (myid == numprocs-1) i_end = HIST_SIZE;
        
        for (int i=0; i<size; i++) {
            tmp = ((input[i] - min) * HIST_SIZE / (max - min - 1);
            if ( tmp >= i_start && tmp < i_end )
            {
                histogram[tmp]++;
            }
        }
    }
}

void FindFrequency(int * input, int size , int * histogram, int min, int max) {
    
    int tmp;
    #pragma omp parallel private(tmp)
    {
        int myid = omp_get_thread_num();
        int numprocs = omp_get_num_threads();
        int i_start = myid * (HIST_SIZE/numprocs);
        int i_end = i_start + (HIST_SIZE/numprocs);
        
        int rem = HIST_SIZE % numprocs;
        if (rem != 0) {
            if (myid < rem) {
                i_start += myid;
                i_end += (myid+1);
            } else {
                i_start += rem;
                i_end += rem;
            }
        }
        
        for (int i=0; i<size; i++) {
            tmp = ((input[i] - min) * HIST_SIZE / (max - min - 1);
            if ( tmp >= i_start && tmp < i_end )
            {
                histogram[tmp]++;
            }
        }
    }
}

void main() {
int num_elem, max, min;
	ReadNumbers(numbers, &num_elem); // read input numbers
	max=min=numbers[0];
	FindBounds(numbers, num_elem, &min, &max); // returns the upper and lower
// values for the histogram
	FindFrequency(numbers, num_elem, frequency, min, max); // compute histogram
}
