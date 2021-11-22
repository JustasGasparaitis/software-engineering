struct PQNode {
    int data;
    int priority;
    struct PQNode* next;
};

struct PQ {
    struct PQNode *_front, *_rear;
};

struct PQNode* newPQNode(int priority, int data) {
    struct PQNode* temp = (struct PQNode*)malloc(sizeof(struct PQNode));
    temp->priority = priority;
    temp->data = data;
    temp->next = NULL;
    return temp;
}

struct PQ* createPQ() {
    struct PQ* q = (struct PQ*) malloc(sizeof(struct PQ));
    q->_front = q->_rear = NULL;
    return q;
}

int isPQEmpty(struct PQ* q) {
    return q->_front == NULL;
}

void enqueue(struct PQ** q, int priority, int data) {
    struct PQNode* newNode = newPQNode(priority, data);

    // If the queue is empty
    if ((*q)->_rear == NULL) {
        (*q)->_front = (*q)->_rear = newNode;
        return;
    }

    // Else
    struct PQNode* currNode = (*q)->_front;
    struct PQNode* prevNode = NULL;
    while (currNode != NULL && currNode->priority < priority) {
        prevNode = currNode;
        currNode = currNode->next;
    }

    if (prevNode == NULL) {
        (*q)->_front = newNode;
        newNode->next = currNode;
    } else {
        prevNode->next = newNode;
        newNode->next = currNode;
        if (newNode->next == NULL) {
            (*q)->_rear->next = newNode;
            (*q)->_rear = newNode;
        }
    }
}

void dequeue(struct PQ** q) {
    if ((*q)->_front == NULL)
        return;

    struct PQNode* temp = (*q)->_front;

    (*q)->_front = (*q)->_front->next;

    if ((*q)->_front == NULL) {
        (*q)->_rear = NULL;
    }

    free(temp);
}

void destroyPQ(struct PQ** q) {
    while (!isPQEmpty(*q)) {
        dequeue(q);
    }
    free(*q);
}
