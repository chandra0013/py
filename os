1)
#include <stdio.h>
#include <pthread.h>

int balance = 0;
pthread_mutex_t lock;

void deposit(int amount) {
    pthread_mutex_lock(&lock);
    balance += amount;
    printf("Person X deposited %d\n", amount);
    printf("Current balance: %d\n", balance);
    pthread_mutex_unlock(&lock);
}

void withdraw(int amount) {
    pthread_mutex_lock(&lock);
    if (balance >= amount) {
        balance -= amount;
        printf("Person Y withdrew %d\n", amount);
        printf("Current balance: %d\n", balance);
    } else {
        printf("Insufficient balance for withdrawal.\n");
    }
    pthread_mutex_unlock(&lock);
}

void *personX(void *arg) {
    int depositAmount = 1000;
    deposit(depositAmount);
    return NULL;
}

void *personY(void *arg) {
    int withdrawAmount = 500;
    withdraw(withdrawAmount);
    return NULL;
}

int main() {
    int initialBalance;
    printf("Enter the initial balance for the bank account: ");
    scanf("%d", &initialBalance);

    balance = initialBalance;
    pthread_t threadX, threadY;

    pthread_mutex_init(&lock, NULL);

    pthread_create(&threadX, NULL, personX, NULL);
    pthread_create(&threadY, NULL, personY, NULL);

    pthread_join(threadX, NULL);
    pthread_join(threadY, NULL);

    pthread_mutex_destroy(&lock);

    return 0;
}


2)#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define NUM_READERS 4
#define NUM_WRITERS 1

sem_t mutex, wrt;
int read_count = 0;

void *reader(void *arg) {
    int id = *((int *)arg);

    while (1) {
        sem_wait(&mutex);
        read_count++;
        if (read_count == 1) {
            sem_wait(&wrt);
        }
        sem_post(&mutex);

        // Reading the file (critical section for reading)
        printf("Reader %d is reading the file\n", id);
        sleep(1); // Simulating reading process

        sem_wait(&mutex);
        read_count--;
        if (read_count == 0) {
            sem_post(&wrt);
        }
        sem_post(&mutex);

        sleep(2); // Reader's waiting time before accessing the file again
    }
}

void *writer(void *arg) {
    int id = *((int *)arg);

    while (1) {
        sem_wait(&wrt);

        // Writing to the file (critical section for writing)
        printf("Writer %d is updating the file\n", id);
        sleep(2); // Simulating writing process

        sem_post(&wrt);

        sleep(3); // Writer's waiting time before accessing the file again
    }
}

int main() {
    pthread_t readers[NUM_READERS], writers[NUM_WRITERS];
    int reader_ids[NUM_READERS], writer_ids[NUM_WRITERS];

    sem_init(&mutex, 0, 1);
    sem_init(&wrt, 0, 1);

    // Create reader threads
    for (int i = 0; i < NUM_READERS; i++) {
        reader_ids[i] = i + 1;
        pthread_create(&readers[i], NULL, reader, &reader_ids[i]);
    }

    // Create writer threads
    for (int i = 0; i < NUM_WRITERS; i++) {
        writer_ids[i] = i + 1;
        pthread_create(&writers[i], NULL, writer, &writer_ids[i]);
    }

    // Join reader threads
    for (int i = 0; i < NUM_READERS; i++) {
        pthread_join(readers[i], NULL);
    }

    // Join writer threads
    for (int i = 0; i < NUM_WRITERS; i++) {
        pthread_join(writers[i], NULL);
    }

    sem_destroy(&mutex);
    sem_destroy(&wrt);

    return 0;
}


3)
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#define NUM_PHILOSOPHERS 5

typedef enum { THINKING, HUNGRY, EATING } state_t;

pthread_mutex_t monitor_mutex;
pthread_cond_t cond_vars[NUM_PHILOSOPHERS];
state_t philosophers[NUM_PHILOSOPHERS];

void test(int phil_id) {
    if (philosophers[phil_id] == HUNGRY &&
        philosophers[(phil_id + 1) % NUM_PHILOSOPHERS] != EATING &&
        philosophers[(phil_id + 4) % NUM_PHILOSOPHERS] != EATING) {
        philosophers[phil_id] = EATING;
        printf("Philosopher %d is eating\n", phil_id);
        pthread_cond_signal(&cond_vars[phil_id]);
    }
}

void take_forks(int phil_id) {
    pthread_mutex_lock(&monitor_mutex);
    philosophers[phil_id] = HUNGRY;
    printf("Philosopher %d is hungry\n", phil_id);
    test(phil_id);
    if (philosophers[phil_id] != EATING) {
        pthread_cond_wait(&cond_vars[phil_id], &monitor_mutex);
    }
    pthread_mutex_unlock(&monitor_mutex);
}

void put_forks(int phil_id) {
    pthread_mutex_lock(&monitor_mutex);
    philosophers[phil_id] = THINKING;
    printf("Philosopher %d is thinking\n", phil_id);
    test((phil_id + 1) % NUM_PHILOSOPHERS);
    test((phil_id + 4) % NUM_PHILOSOPHERS);
    pthread_mutex_unlock(&monitor_mutex);
}

void *philosopher(void *arg) {
    int phil_id = *((int *)arg);

    while (1) {
        sleep(rand() % 3 + 1);
        take_forks(phil_id);
        sleep(rand() % 3 + 1);
        put_forks(phil_id);
    }

    return NULL;
}

int main() {
    pthread_t threads[NUM_PHILOSOPHERS];
    int phil_ids[NUM_PHILOSOPHERS];

    pthread_mutex_init(&monitor_mutex, NULL);
    for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
        pthread_cond_init(&cond_vars[i], NULL);
        phil_ids[i] = i;
        pthread_create(&threads[i], NULL, philosopher, &phil_ids[i]);
    }

    for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
        pthread_join(threads[i], NULL);
        pthread_cond_destroy(&cond_vars[i]);
    }

    pthread_mutex_destroy(&monitor_mutex);

    return 0;
}



Bankers)
#include <stdio.h>  
int main()  
{  
    // P0, P1, P2, P3, P4 are the Process names here  
  
    int n, m, i, j, k;  
    n = 5;                         // Number of processes  
    m = 3;                         // Number of resources  
    int alloc[5][3] = {{1, 1, 2},  // P0 // Allocation Matrix  
                       {2, 1, 2},  // P1  
                       {3, 0, 1},  // P2  
                       {0, 2, 0},  // P3  
                       {1, 1, 2}}; // P4  
  
    int max[5][3] = {{5, 4, 4},  // P0 // MAX Matrix  
                     {4, 3, 3},  // P1  
                     {9, 1, 3},  // P2  
                     {8, 6, 4},  // P3  
                     {2, 2, 3}}; // P4  
  
    int avail[3] = {3,2,1}; // Available Resources  

    
    printf("2) Available vector\n");
    for(int i=0;i<3;i++){
        printf("%d ",avail[i]);
    }
    printf("\n");
    
  
    int f[n], ans[n], ind = 0;  
    for (k = 0; k < n; k++)  
    {  
        f[k] = 0;  
    }  
    int need[n][m];  
    for (i = 0; i < n; i++)  
    {  
        for (j = 0; j < m; j++)  
            need[i][j] = max[i][j] - alloc[i][j];  
    }  
    int y = 0;  
    for (k = 0; k < 5; k++)  
    {  
        for (i = 0; i < n; i++)  
        {  
            if (f[i] == 0)  
            {  
                int flag = 0;  
                for (j = 0; j < m; j++)  
                {  
                    if (need[i][j] > avail[j])  
                    {  
                        flag = 1;  
                        break;  
                    }  
                }  
                if (flag == 0)  
                {  
                    ans[ind++] = i;  
                    for (y = 0; y < m; y++)  
                        avail[y] += alloc[i][y];  
                    f[i] = 1;  
                }  
            }  
        }  
    }  
        printf("1) Need Matrix : \n");
    for(int i=0;i<5;i++){
        for(int j=0;j<3;j++){
            printf("%d ",need[i][j]);
        }
        printf("\n");
    }
    printf("\n");
    
    int flag = 1;  
    for (int i = 0; i < n; i++)  
    {  
        if (f[i] == 0)  
        {  
            flag = 0;  
            printf("The following system is not safe");  
            break;  
        }  
    }  
    if (flag == 1)  
    {  
        printf("Following is the SAFE Sequence\n");  
        for (i = 0; i < n - 1; i++)  
            printf(" S%d ->", ans[i]);  
        printf(" S%d", ans[n - 1]);  
    }  
    return (0);  
}  



lab8)
Write a c program to implement dynamic memory allocation techniques for the given memory partition sizes 20kb,100kb,40kb,200kb and 10kb.For the various processes of size 90kb,50kb,30kb & 40kb.Display the allocation of all the processes by applying the algorithm on the screen.

#include <stdio.h>
#include <stdlib.h>

// Structure to represent a memory partition
struct Partition {
    int size; // Size of the partition
    int allocated; // Flag to indicate if it's allocated (1) or free (0)
};

// Function to allocate memory for a process
void allocateMemory(struct Partition partitions[], int numPartitions, int processSize) {
    for (int i = 0; i < numPartitions; i++) {
        if (!partitions[i].allocated && partitions[i].size >= processSize) {
            partitions[i].allocated = 1;
            printf("Allocated %d KB for process of size %d KB\n", partitions[i].size, processSize);
            break;
        }
    }
}

// Function to display memory layout
void displayMemory(struct Partition partitions[], int numPartitions) {
    printf("\nMemory Layout:\n");
    for (int i = 0; i < numPartitions; i++) {
        printf("%d KB %s | ", partitions[i].size, partitions[i].allocated ? "Process" : "Free");
    }
    printf("\n");
}

int main() {
    // Given memory partition sizes
    int numPartitions = 5;
    struct Partition partitions[] = {
        {20, 0}, // 20 KB
        {100, 0}, // 100 KB
        {40, 0}, // 40 KB
        {200, 0}, // 200 KB
        {10, 0} // 10 KB
    };

    // Given process sizes
    int processSizes[] = {90, 15, 30, 40};

    // Allocate memory for each process
    for (int i = 0; i < 4; i++) {
        allocateMemory(partitions, numPartitions, processSizes[i]);
    }

    // Display final memory layout
    displayMemory(partitions, numPartitions);

    return 0;
}







lab8 draft2)
#include<stdio.h>
#include<stdlib.h>

int main()
{
    int memory[5][2]={{20,0},{100,0},{40,0},{200,0},{10,0}};
    int memory1[4][2]={{20,0},{100,0},{40,0},{200,0}};
    int process[4]={90,50,30,40};
    int process1[4]={90,50,30,40};
    int memory2[4][2]={{20,0},{100,0},{40,0},{200,0}};
    int process2[4]={90,50,30,40};
    
    int i,j,k=0;
    //first fit
    printf("\n FIRST FIT\n");
    for(i=0;i<4;i++)
    {
        for(j=0;j<4;j++)
        {
            k=k%4;
            if(memory[k][0]>=process[i] && process[i]>0 && memory[k][1]==0)
            {
                memory[k][1]=process[i];
                process[i]=0;
                break;
            }
            
            k++;
        }
    }
    
    for(i=0;i<5;i++)
    {
        printf("\n%d\t%d",memory[i][0],memory[i][1]);
    }
    
    int temp=0;
    
    //best fit
    k=0;
    printf("\n\n\n BEST FIT\n");
    for(i=0;i<4;i++)
    {
        for(j=0;j<4;j++)
        {
            k=k%4;
            if(memory2[k][0]>=process2[i] && process2[i]>0 && memory2[k][1]==0)
            {
                memory2[k][1]=process2[i];
                process2[i]=0;
                break;
            }
            
            k++;
        }
    }
    
    for(i=0;i<5;i++)
    {
        printf("\n%d\t%d",memory2[i][0],memory2[i][1]);
    }
    






    //worst fit
    printf("\n\n\nWORST FIT");
    for(i=0;i<5;i++)
    {
        for(j=i+1;j<5;j++)
        {
            if(memory1[i][0]<memory1[j][0])
            {
                temp=memory1[i][0];
                memory1[i][0]=memory1[j][0];
                memory1[j][0]=temp;
            }
        }
    }
    k=0;
    for(i=0;i<4;i++)
    {
        for(j=0;j<4;j++)
        {
            k=k%4;
            if(memory1[k][0]>=process1[i] && process1[i]>0 && memory1[k][1]==0)
            {
                memory1[k][1]=process1[i];
                process1[i]=0;
                break;
            }
            
            k++;
        }
    }

    for(i=0;i<5;i++)
    {
        printf("\n%d\t%d",memory1[i][0],memory1[i][1]);
    }

}
