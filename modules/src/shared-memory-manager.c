#include <stdio.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <termios.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>

void print_help(){
	printf("\nUsage: shm MEMORY_REF <OPTIONS <VALUE>> \n\n");

	printf("Shared memory manager\n\n");

	printf("Options:\n");
	printf("--alloc   | -a <SIZE_T>       Alloc shared memory.\n");
	printf("--exists  | -e                Return 1 if memory is allocated and 0 if not.\n");
	printf("--free    | -f                Free shared memory.\n");
	printf("--read    | -r                Read value in shared memory.\n");
	printf("--write   | -w <VALUE>        Write text value in shared memory.\n");
	printf("--pointer | -p                Return memory address in number format.\n");
	printf("--list    | -l                List alloced memories.\n\n");
}

int shared_memory_from_file(const char *);
int memory_alloc(int);
int memory_free(int);
void *memory_addr(int);

int main(int argc, char *argv[]){
	int shared_memory_size = 0;
	char shared_memory_name[1024] = {0};
	const char *writeValue = 0;

	char property = 0;

	for(int i=0; i<argc; i++){
		if(!strcmp(argv[i], "--alloc") || !strcmp(argv[i], "-a")){
			i++;
			property = 'a';
			sscanf(argv[i], "%d", &shared_memory_size);
		}else if(!strcmp(argv[i], "--exists") || !strcmp(argv[i], "-e")){
			property = 'e';
		}else if(!strcmp(argv[i], "--free") || !strcmp(argv[i], "-f")){
			property = 'f';
		}else if(!strcmp(argv[i], "--read") || !strcmp(argv[i], "-r")){
			property = 'r';
		}else if(!strcmp(argv[i], "--pointer") || !strcmp(argv[i], "-p")){
			property = 'p';
		}else if(!strcmp(argv[i], "--list") || !strcmp(argv[i], "-l")){
			property = 'l';
		}else if(!strcmp(argv[i], "--write") || !strcmp(argv[i], "-w")){
			i++;
			property = 'w';
			writeValue = argv[i];
		}else{
			sprintf(shared_memory_name, "/tmp/shm-%s.shm", argv[i]);
		}
	}

	int shared_memory = 0;
	void *shared_memory_addr;
	switch (property){
	case 'a':
		FILE *memory_addr_file = fopen(shared_memory_name, "w");
		if(memory_addr_file){
			shared_memory = memory_alloc(shared_memory_size);
			fwrite(&shared_memory, sizeof(int), 1, memory_addr_file);
			fclose(memory_addr_file);
		}else return 2;
		break;
	case 'f':
		shared_memory = shared_memory_from_file(shared_memory_name);
		if(!shared_memory) return 2;
		memory_free(shared_memory);
		int r = remove(shared_memory_name);
		break;
	case 'w':
		shared_memory = shared_memory_from_file(shared_memory_name);
		if(!shared_memory) return 2;
		shared_memory_addr = memory_addr(shared_memory);
		strcpy(shared_memory_addr, writeValue);
		break;
	case 'r':
		shared_memory = shared_memory_from_file(shared_memory_name);
		if(!shared_memory) return 2;
		shared_memory_addr = memory_addr(shared_memory);
		char *character = shared_memory_addr;
		while((*character) != 0){
			printf("%c", *(character));
			character+=1;
		}
		break;
	case 'p':
		shared_memory = shared_memory_from_file(shared_memory_name);
		if(!shared_memory) return 2;
		shared_memory_addr = memory_addr(shared_memory);
		printf("%p", shared_memory_addr);
		break;
	case 'e':
		if(access(shared_memory_name, F_OK) == 0){
			printf("1");
		}else{
			printf("0");
		}

		break;
	case 'l':
		DIR *dir;
		struct dirent *entity;
		dir = opendir("/tmp");

		while((entity = readdir(dir)) != NULL){
			char* name = entity->d_name;
			if(!strncmp("shm-", name, 4) && !strncmp(".shm", name + strlen(name) - 4, 4)){
				name[strlen(name)-4] = '\0';
				printf("%s\n",name+4);
			}
		}

		closedir(dir);
		
		break;
	default:
		print_help();
		return 1;
	}

	return 0;
}

int shared_memory_from_file(const char *shared_memory_name){
	FILE *memory_addr_file = fopen(shared_memory_name, "r");
	int shared_memory = 0;
	if(memory_addr_file){
		fread(&shared_memory, sizeof(int), 1, memory_addr_file);
		fclose(memory_addr_file);
	}

	return shared_memory;
}

int memory_alloc(int shared_memory_size){
	int shared_memory = 0;
	void *shared_memory_addr;

	shared_memory = shmget(IPC_PRIVATE, shared_memory_size, IPC_CREAT | 0644);
	if(shared_memory == -1) return 1;

	shared_memory_addr = shmat(shared_memory, 0, 0);
	bzero(shared_memory_addr, shared_memory_size-1);

	return shared_memory;
}

int memory_free(int shared_memory){
	void *shared_memory_addr = shmat(shared_memory, 0, 0);
	shmctl(shared_memory, IPC_RMID, NULL);
	shmdt(shared_memory_addr);

	return 0;
}

void *memory_addr(int shared_memory){
	return shmat(shared_memory, 0, 0);
}
