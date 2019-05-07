all:
		as testePrintf.s -o assembly.o -g
		gcc avalia.c -c -o avalia.o -g
		gcc avalia.o assembly.o -o programa -g
clean:
		rm *.o programa
