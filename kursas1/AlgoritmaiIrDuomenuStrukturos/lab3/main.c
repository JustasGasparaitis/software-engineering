#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "stekas.h"
#include "eile.h"

// Global variables
int CLIENT_CHANCE;
int SANDWICH_COUNT;
int SANDWICH_FREQUENCY;
int SANDWICH_EXPIRATION_TIME;
int SANDWICH_PRICE;
int WORK_DAY_LENGTH;

void getParams(
    int* CLIENT_CHANCE,
    int* SANDWICH_COUNT,
    int* SANDWICH_FREQUENCY,
    int* SANDWICH_EXPIRATION_TIME,
    int* SANDWICH_PRICE,
    int* WORK_DAY_LENGTH);

void fillStackHolder(struct StackNode** sandwichHolder,
                     int sandwichCount,
                     int time,
                     int* sandwichHolderCount);

void fillQueueHolder(struct Queue** sandwichHolder,
                     int sandwichCount,
                     int time,
                     int* sandwichHolderCount);

void takeFromStackHolder(struct StackNode** sandwichHolder,
                         int* sandwichHolderCount);

void takeFromQueueHolder(struct Queue** sandwichHolder,
                         int* sandwichHolderCount);

int takeOutOldSandwichesFromStackHolder(struct StackNode** sandwichHolder,
                                        int currentTime);

int takeOutOldSandwichesFromQueueHolder(struct Queue** sandwichHolder,
                                        int currentTime);

void simulateDayOfWorkWithTwoStackHolders(struct Queue** clientQueue,
                                          struct StackNode** sandwichStackHolder1,
                                          int* sandwichStackHolder1Count,
                                          struct StackNode** sandwichStackHolder2,
                                          int* sandwichStackHolder2Count,
                                          int* oldTwoStackSandwichCount,
                                          int currentDay);

void simulateDayOfWorkWithOneQueueHolder(struct Queue** clientQueue,
                                         struct Queue** sandwichQueueHolder,
                                         int* sandwichQueueHolderCount,
                                         int* oldOneQueueSandwichCount,
                                         int currentDay);

void simulateDayOfWorkWithTwoQueueHolders(struct Queue** clientQueue,
                                          struct Queue** sandwichQueueHolder1,
                                          int* sandwichQueueHolder1Count,
                                          struct Queue** sandwichQueueHolder2,
                                          int* sandwichQueueHolder2Count,
                                          int* oldTwoQueueSandwichCount,
                                          int currentDay);

int main()
{
    // Parameters
    srand(time(NULL)); // for random numbers
    getParams(&CLIENT_CHANCE,
              &SANDWICH_COUNT,
              &SANDWICH_FREQUENCY,
              &SANDWICH_EXPIRATION_TIME,
              &SANDWICH_PRICE,
              &WORK_DAY_LENGTH);

    // Two stack holders
    struct StackNode* sandwichStackHolder1 = NULL;
    int sandwichStackHolder1Count = 0;
    struct StackNode* sandwichStackHolder2 = NULL;
    int sandwichStackHolder2Count = 0;
    int oldTwoStackSandwichCount = 0;

    // One queue holder
    struct Queue* sandwichQueueHolder = createQueue();
    int sandwichQueueHolderCount = 0;
    int oldOneQueueSandwichCount = 0;

    // Two queue holders
    struct Queue* sandwichQueueHolder1 = createQueue();
    int sandwichQueueHolder1Count = 0;
    struct Queue* sandwichQueueHolder2 = createQueue();
    int sandwichQueueHolder2Count = 0;
    int oldTwoQueueSandwichCount = 0;

    // Client queue
    struct Queue* clientQueue = createQueue();

    // Week of work with two stack sandwich holders
    for (int i = 0; i < 7; ++i) {
        simulateDayOfWorkWithTwoStackHolders(&clientQueue,
                                         &sandwichStackHolder1,
                                         &sandwichStackHolder1Count,
                                         &sandwichStackHolder2,
                                         &sandwichStackHolder2Count,
                                         &oldTwoStackSandwichCount,
                                         i);
        destroyQueue(&clientQueue);
    }
    destroyQueue(&clientQueue);
    destroyStack(&sandwichStackHolder1);
    destroyStack(&sandwichStackHolder2);

    // Week of work with one queue sandwich holder
    for (int i = 0; i < 7; ++i) {
        simulateDayOfWorkWithOneQueueHolder(&clientQueue,
                                         &sandwichQueueHolder,
                                         &sandwichQueueHolderCount,
                                         &oldOneQueueSandwichCount,
                                         i);
        destroyQueue(&clientQueue);
    }
    destroyQueue(&sandwichQueueHolder);
    destroyQueue(&clientQueue);

    // Week of work with two queue sandwich holders
    for (int i = 0; i < 7; ++i) {
        simulateDayOfWorkWithTwoQueueHolders(&clientQueue,
                                         &sandwichQueueHolder1,
                                         &sandwichQueueHolder1Count,
                                         &sandwichQueueHolder2,
                                         &sandwichQueueHolder2Count,
                                         &oldTwoQueueSandwichCount,
                                         i);
        destroyQueue(&clientQueue);
    }
    destroyQueue(&sandwichQueueHolder1);
    destroyQueue(&sandwichQueueHolder2);
    destroyQueue(&clientQueue);

    // Print results
    printf("With 2 stack sandwich holders, expenses are: %d eur\n", oldTwoStackSandwichCount * SANDWICH_PRICE);
    printf("With 1 queue sandwich holder, expenses are: %d eur\n", oldOneQueueSandwichCount * SANDWICH_PRICE);
    printf("With 2 queue sandwich holders, expenses are: %d eur\n", oldTwoQueueSandwichCount * SANDWICH_PRICE);
    return 0;
}

void getParams(int* CLIENT_CHANCE,
               int* SANDWICH_COUNT,
               int* SANDWICH_FREQUENCY,
               int* SANDWICH_EXPIRATION_TIME,
               int* SANDWICH_PRICE,
               int* WORK_DAY_LENGTH) {

    FILE *fp = fopen("params.txt", "r");

    char tempString[101];

    fscanf(fp, "%d", CLIENT_CHANCE); // read integer
    fgets(tempString, 100, fp); // ignore rest of line

    fscanf(fp, "%d", SANDWICH_COUNT);
    fgets(tempString, 100, fp);

    fscanf(fp, "%d", SANDWICH_FREQUENCY);
    fgets(tempString, 100, fp);

    fscanf(fp, "%d", SANDWICH_EXPIRATION_TIME);
    fgets(tempString, 100, fp);

    fscanf(fp, "%d", SANDWICH_PRICE);
    fgets(tempString, 100, fp);

    fscanf(fp, "%d", WORK_DAY_LENGTH);
    fgets(tempString, 100, fp);

    fclose(fp);
}

void fillStackHolder(struct StackNode** sandwichHolder,
                     int sandwichCount,
                     int time,
                     int* sandwichHolderCount) {
    for (int i = 0; i < sandwichCount; ++i) {
        pushToStack(sandwichHolder, time);
        ++*sandwichHolderCount;
    }
}

void fillQueueHolder(struct Queue** sandwichHolder,
                     int sandwichCount,
                     int time,
                     int* sandwichHolderCount) {
    for (int i = 0; i < sandwichCount; ++i) {
        enqueue(sandwichHolder, time);
        ++*sandwichHolderCount;
    }
}

void takeFromStackHolder(struct StackNode** sandwichHolder,
                         int* sandwichHolderCount) {
    if (!isStackEmpty(*sandwichHolder)) {
        popFromStack(sandwichHolder);
        --*sandwichHolderCount;
    }
}

void takeFromQueueHolder(struct Queue** sandwichHolder,
                         int* sandwichHolderCount) {
    if (!isQueueEmpty(*sandwichHolder)) {
        dequeue(sandwichHolder);
        --*sandwichHolderCount;
    }
}

int takeOutOldSandwichesFromStackHolder(struct StackNode** sandwichHolder,
                                        int currentTime) {
    int prevSandwichCount = 0;
    int newSandwichCount = 0;
    struct StackNode* tempStack = NULL;
    while (!isStackEmpty(*sandwichHolder)) {
        int sandwichTime = popFromStack(sandwichHolder);
        pushToStack(&tempStack, sandwichTime);
        ++prevSandwichCount;
        //printf("sTime: %d | sExp: %d\n", (currentTime - sandwichTime), SANDWICH_EXPIRATION_TIME);
    }
    //printf("==================================================\n");
    while (!isStackEmpty(tempStack)) {
        int sandwichTime = popFromStack(&tempStack);
        if ((currentTime - sandwichTime) < SANDWICH_EXPIRATION_TIME) {
            pushToStack(sandwichHolder, sandwichTime);
            ++newSandwichCount;
            //printf("sTime: %d | sExp: %d\n", (currentTime - sandwichTime), SANDWICH_EXPIRATION_TIME);
        }
    }
    //printf("s: %d\n", (prevSandwichCount - newSandwichCount));
    return (prevSandwichCount - newSandwichCount);
}

int takeOutOldSandwichesFromQueueHolder(struct Queue** sandwichHolder,
                                        int currentTime) {
    int oldSandwichCount = 0;
    while (!isQueueEmpty(*sandwichHolder)) {
        int sandwichTime = (*sandwichHolder)->_front->data;
        if ((currentTime - sandwichTime) >= SANDWICH_EXPIRATION_TIME) {
            //printf("sTime: %d | sExp: %d\n", (currentTime - sandwichTime), SANDWICH_EXPIRATION_TIME);
            dequeue(sandwichHolder);
            ++oldSandwichCount;
        } else break;
    }
    //printf("s: %d\n", oldSandwichCount);
    return oldSandwichCount;
}

void simulateDayOfWorkWithTwoStackHolders(struct Queue** clientQueue,
                                          struct StackNode** sandwichStackHolder1,
                                          int* sandwichStackHolder1Count,
                                          struct StackNode** sandwichStackHolder2,
                                          int* sandwichStackHolder2Count,
                                          int* oldTwoStackSandwichCount,
                                          int currentDay) {
    int errors = 0;
    int timePassed = WORK_DAY_LENGTH * currentDay;

    // Main simulation
    while (!errors && (timePassed < (WORK_DAY_LENGTH * (currentDay + 1)))) {
        // New sandwiches are put on the holder
        if (!(timePassed % SANDWICH_FREQUENCY)) {
            if (*sandwichStackHolder1Count <= *sandwichStackHolder2Count) {
                fillStackHolder(sandwichStackHolder1,
                                SANDWICH_COUNT,
                                timePassed,
                                sandwichStackHolder1Count);
            } else {
                fillStackHolder(sandwichStackHolder2,
                                SANDWICH_COUNT,
                                timePassed,
                                sandwichStackHolder2Count);
            }
        }

        // Client stands in queue to take a sandwich, if they want to
        int clientRandom = (rand() % 100) + 1;
        if (clientRandom <= CLIENT_CHANCE) {
            enqueue(clientQueue, timePassed);
        }

        // Clients, waiting in queue, take sandwiches, if there are any
        //printf("%d %d\n", clientRandom, holderRandom);
        while (!isQueueEmpty(*clientQueue)) {
            int holderRandom = (rand() % 2) + 1;
            if (holderRandom == 1 && !isStackEmpty(*sandwichStackHolder1)) {
                takeFromStackHolder(sandwichStackHolder1, sandwichStackHolder1Count);
            } else {
                if (isStackEmpty(*sandwichStackHolder2)) break;
                takeFromStackHolder(sandwichStackHolder2, sandwichStackHolder2Count);
            }
            dequeue(clientQueue);
        }
        ++timePassed; // a minute has passed
    }

    *oldTwoStackSandwichCount += takeOutOldSandwichesFromStackHolder(sandwichStackHolder1, timePassed);
    *oldTwoStackSandwichCount += takeOutOldSandwichesFromStackHolder(sandwichStackHolder2, timePassed);
}

void simulateDayOfWorkWithOneQueueHolder(struct Queue** clientQueue,
                                         struct Queue** sandwichQueueHolder,
                                         int* sandwichQueueHolderCount,
                                         int* oldOneQueueSandwichCount,
                                         int currentDay) {
    int errors = 0;
    int timePassed = WORK_DAY_LENGTH * currentDay;

    // Main simulation
    while (!errors && (timePassed < (WORK_DAY_LENGTH * (currentDay + 1)))) {
        // New sandwiches are put on the holder
        if (!(timePassed % SANDWICH_FREQUENCY)) {
            fillQueueHolder(sandwichQueueHolder,
                            SANDWICH_COUNT,
                            timePassed,
                            sandwichQueueHolderCount);
        }

        // Client stands in queue to take a sandwich, if they want to
        int clientRandom = (rand() % 100) + 1;
        if (clientRandom <= CLIENT_CHANCE) {
            enqueue(clientQueue, timePassed);
        }

        // Clients, waiting in queue, take sandwiches, if there are any
        //printf("%d %d\n", clientRandom, holderRandom);
        while (!isQueueEmpty(*clientQueue)) {
            if (isQueueEmpty(*sandwichQueueHolder)) break;
            takeFromQueueHolder(sandwichQueueHolder, sandwichQueueHolderCount);
            dequeue(clientQueue);
        }
        ++timePassed; // a minute has passed
    }

    *oldOneQueueSandwichCount += takeOutOldSandwichesFromQueueHolder(sandwichQueueHolder, timePassed);
}

void simulateDayOfWorkWithTwoQueueHolders(struct Queue** clientQueue,
                                          struct Queue** sandwichQueueHolder1,
                                          int* sandwichQueueHolder1Count,
                                          struct Queue** sandwichQueueHolder2,
                                          int* sandwichQueueHolder2Count,
                                          int* oldTwoQueueSandwichCount,
                                          int currentDay) {
    int errors = 0;
    int timePassed = WORK_DAY_LENGTH * currentDay;

    // Main simulation
    while (!errors && (timePassed < (WORK_DAY_LENGTH * (currentDay + 1)))) {
        // New sandwiches are put on the holder
        if (!(timePassed % SANDWICH_FREQUENCY)) {
            if (*sandwichQueueHolder1Count <= *sandwichQueueHolder2Count) {
                fillQueueHolder(sandwichQueueHolder1,
                                SANDWICH_COUNT,
                                timePassed,
                                sandwichQueueHolder1Count);
            } else {
                fillQueueHolder(sandwichQueueHolder2,
                                SANDWICH_COUNT,
                                timePassed,
                                sandwichQueueHolder2Count);
            }
        }

        // Client stands in queue to take a sandwich, if they want to
        int clientRandom = (rand() % 100) + 1;
        if (clientRandom <= CLIENT_CHANCE) {
            enqueue(clientQueue, timePassed);
        }

        // Clients, waiting in queue, take sandwiches, if there are any
        //printf("%d %d\n", clientRandom, holderRandom);
        while (!isQueueEmpty(*clientQueue)) {
            int holderRandom = (rand() % 2) + 1;
            if (holderRandom == 1 && !isQueueEmpty(*sandwichQueueHolder1)) {
                takeFromQueueHolder(sandwichQueueHolder1, sandwichQueueHolder1Count);
            } else {
                if (isQueueEmpty(*sandwichQueueHolder2)) break;
                takeFromQueueHolder(sandwichQueueHolder2, sandwichQueueHolder2Count);
            }
            dequeue(clientQueue);
        }
        ++timePassed; // a minute has passed
    }

    *oldTwoQueueSandwichCount += takeOutOldSandwichesFromQueueHolder(sandwichQueueHolder1, timePassed);
    *oldTwoQueueSandwichCount += takeOutOldSandwichesFromQueueHolder(sandwichQueueHolder2, timePassed);
}
