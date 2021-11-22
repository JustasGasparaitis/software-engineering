/**
Sukurti tuščią eilę
struct QueueNode* newQueue = NULL;

Patikrinti, ar eilė tuščia
isQueueEmpty(newQueue);

Įdėti (angl. enqueue) naują elementą į eilę
enqueue(&newQueue, data);

Išimti (angl. dequeue) elementą iš eilės
dequeue(&newQueue);

Gauti pirmo eilės elemento duomenis, neišimant jo iš eilės
head->data;

Gauti eilės elementų skaičių (nebūtina operacija)
getQueueSize(newQueue);

Sunaikinti eilę
destroyQueue(&newQueue);
*/

struct QNode {
    int data;
    struct QNode* next;
};

struct Queue {
    struct QNode *_front, *_rear;
};

struct QNode* newNode(int data) {
    struct QNode* temp = (struct QNode*)malloc(sizeof(struct QNode));
    temp->data = data;
    temp->next = NULL;
    return temp;
}

struct Queue* createQueue() {
    struct Queue* q = (struct Queue*)malloc(sizeof(struct Queue));
    q->_front = q->_rear = NULL;
    return q;
}

int isQueueEmpty(struct Queue* q) {
    return ((q->_front == NULL) && (q->_rear == NULL));
}

void enqueue(struct Queue** q, int data) {
    struct QNode* temp = newNode(data);

    if ((*q)->_rear == NULL) {
        (*q)->_front = (*q)->_rear = temp;
        return;
    }

    (*q)->_rear->next = temp;
    (*q)->_rear = temp;
}

void dequeue(struct Queue** q) {
    if ((*q)->_front == NULL)
        return;

    struct QNode* temp = (*q)->_front;

    (*q)->_front = (*q)->_front->next;

    if ((*q)->_front == NULL)
        (*q)->_rear = NULL;

    free(temp);
}

void destroyQueue(struct Queue** q) {
    while (!isQueueEmpty(*q)) {
        dequeue(q);
    }
}
