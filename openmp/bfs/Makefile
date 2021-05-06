# C compiler
CC = g++
ICC = icc
CC_FLAGS = -g -fopenmp -O2
CLANG = clang++
CLANG_FLAGS = -g -fopenmp -fopenmp-targets=nvptx64-nvidia-cuda -Xopenmp-target -march=sm_70

all: bfs bfs_offload

bfs: bfs.cpp 
	$(ICC) $(CC_FLAGS) bfs.cpp -o bfs

bfs_offload: bfs.cpp
	$(ICC) $(CC_FLAGS) -DOMP_OFFLOAD bfs.cpp -o bfs_offload

clean:
	rm -f bfs bfs_offload result.txt
