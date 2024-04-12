#include <stdio.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <termios.h>
#include <string.h>

void print_help(path){
	printf("Syntax error!\n");
	printf("Try: %s -address \"date\"\n\n")
}

int main(int argc, char *argv[]){
	int shared_memory = 0;
	char shared_memory_name[1024] = {0};
	void *shared_memory_addr;

	for(int i=0; i<argc; i++){
		if(!strcmp(argv[i], "-address")){
			i++;
			sprintf(shared_memory_name, "/tmp/poly-%s.pid", argv[i]);
		}
	}

	if(!*shared_memory_name){
		print_help();
		return 3;
	}

	FILE *memory_addr_file = fopen(shared_memory_name, "r");
	if(memory_addr_file){
		fread(&shared_memory, sizeof(int), 1, memory_addr_file);
		fclose(memory_addr_file);
	}else return 2;

	shmctl(shared_memory, IPC_RMID, NULL);
	shmdt(shmat(shared_memory, 0, 0));

	return 0;
}
