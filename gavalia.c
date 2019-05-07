// wget www.inf.ufpr.br/bmuller/CI064/teste.c . 


#include <stdio.h>

main () {
	void *a,*b,*c,*d;
	
	init_aloc();
	
	a=( void * ) aloc_mem(100);
	 print_end();
	b=( void * ) aloc_mem(200);
	 print_end();
	c=( void * ) aloc_mem(300);
	 print_end();
	d=( void * ) aloc_mem(400);
	 print_end();
	free_mem(b);
	 print_end(); 
	
	b=( void * ) aloc_mem(50);
	 print_end();
	
	free_mem(c);
	 print_end(); 
	 
	printf("\nRunning Fusion!\n");
	heap_fus();
	 print_end(); 
	 
	free_mem(a);
	 print_end();
	free_mem(b);
	 print_end();
	 
	printf("\nRunning Fusion!\n");
	heap_fus();
	 print_end(); 
	 
	free_mem(d);
	 print_end();
	 
	printf("\nRunning Fusion!\n");
	heap_fus();
	 print_end(); 
}
