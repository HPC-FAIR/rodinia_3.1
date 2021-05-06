LOCAL_CC = icc -g -O3 -Wall
CC = icc
CFLAGS = -lm -fopenmp -Wall


all : nn

clean :
	rm -rf *.o nn

nn : nn_openmp.c
	$(CC) -o $@ $< $(LDFLAGS) $(CFLAGS) 

hurricane_gen : hurricane_gen.c
	$(LOCAL_CC) -o $@ $< -lm

