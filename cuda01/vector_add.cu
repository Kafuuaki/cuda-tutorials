#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#define Length 10000000

// why this code can not pass assertion?

void host_add(float *a, float *b, float *c, int n)
{
    for (int i = 0; i < n; i++)
    {
        c[i] = a[i] + b[i];
    }
}

__global__ void device_add(float *a, float *b, float *c)
{
    for (int i = 0; i < Length; i++)
    {
        c[i] = a[i] + b[i];
    }
}

void sum_assertion(float *a, float *b, float *c, int n)
{
    for (int i = 0; i < n; i++)
    {
        assert(c[i] == a[i] + b[i]);
    }

    printf("Sum Assertion passed\n");
}

int main()
{
    float *a, *b, *c;
    float *d_a, *d_b, *d_c;

    // Allocate memory
    // should we use int here?
    // size_t actually
    size_t mem_size = Length * sizeof(float);

    a = (float *)malloc(mem_size);
    b = (float *)malloc(mem_size);
    c = (float *)malloc(mem_size);

    cudaMalloc((void **)&d_a, mem_size);
    cudaMalloc((void **)&d_b, mem_size);
    cudaMalloc((void **)&d_c, mem_size);

    // Initialize the arrays
    for (int i = 0; i < Length; i++)
    {
        a[i] = i;
        b[i] = Length - i;
    }

    cudaMemcpy(d_a, a, mem_size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, mem_size, cudaMemcpyHostToDevice);

    // host_add(a, b, c, Length);

    device_add<<<1, Length>>>(d_a, d_b, d_c);

    // c is not ?
    cudaMemcpy(c, d_c, mem_size, cudaMemcpyDeviceToHost);

    // sum_assertion(a, b, c, Length);

    // for (int i = 0; i < Length; i++)
    // {
    //     printf("%f", c[i]);
    // }

    free(a);
    free(b);
    free(c);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}