#include <stdio.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <termios.h>
#include <string.h>

void print_help(path){
	printf("Syntax error!\n");
	printf("Try: %s -memory 512 -address \"date\"\n\n")
}

int main(int argc, char *argv[]){
	int shared_memory = 0;
	int shared_memory_size = 0;
	char shared_memory_name[1024] = {0};
	void *shared_memory_addr;

	for(int i=0; i<argc; i++){
		if(!strcmp(argv[i], "-memory")){
			i++;
			sscanf(argv[i], "%d", &shared_memory_size);
		}else if(!strcmp(argv[i], "-address")){
			i++;
			sprintf(shared_memory_name, "/tmp/poly-%s.pid", argv[i]);
		}
	}

	if(!shared_memory_size || !*shared_memory_name){
		print_help();
		return 3;
	}

	FILE *memory_addr_file = fopen(shared_memory_name, "w");
	if(memory_addr_file){
		shared_memory = shmget(IPC_PRIVATE, shared_memory_size, IPC_CREAT | 0644);
		if(shared_memory == -1) return 1;
		fwrite(&shared_memory, sizeof(int), 1, memory_addr_file);
		fclose(memory_addr_file);
	}else return 2;

	shared_memory_addr = shmat(shared_memory, 0, 0);
	bzero(shared_memory, shared_memory_size);

	return 0;
}
