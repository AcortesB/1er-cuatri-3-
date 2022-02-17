#define CUTOFF 3

void fractal(int x1, int y1, int x2, int y2, int x3, int y3,  int n, int depth)
{
    if (n == 0)
    {
        //caso base 
        dibujar_triangulo(int x1, int y1, int x2, int y2, int x3, int y3)
    } else {
        //caso recursivo
        int pm1x = (x1 + x2) / 2;
        int pm1y = (y1 + y2) / 2;
        int pm2x = (x1 + x3) / 2;
        int pm2y = (y1 + y3) / 2;
        int pm3x = (x2 + x3) / 2;
        int pm3y = (y2 + y3) / 2;
        
        if ( !omp_in_final() ) {
            #pragma omp task final(depth >= CUTOFF)
            fractal(x1, y1, pm1x, pm1y, pm2x, pm2y, n - 1, depth+1);
            #pragma omp task final(depth >= CUTOFF)
            fractal(pm1x, pm1y, x2, y2, pm3x, pm3y, n - 1, depth+1);
            #pragma omp task final(depth >= CUTOFF)
            fractal(pm2x, pm2y, pm3x, pm3y, x3, y3, n - 1, depth+1);
            #pragma omp taskwait
        } else {
            fractal(x1, y1, pm1x, pm1y, pm2x, pm2y, n - 1, depth+1);
            fractal(pm1x, pm1y, x2, y2, pm3x, pm3y, n - 1, depth+1);
            fractal(pm2x, pm2y, pm3x, pm3y, x3, y3, n - 1, depth+1);
        }
    }
}

main () {
…
#pragma omp parallel
#pragma omp single
fractal (X1, Y1, X2, Y2, X3, Y3, N, 0);

…
}

//tree es más eficiente
