/*
Grafo operacijos:

• Sukurti tuščią grafą.
createGraph(int maxVertices);
• Įdėti/išmesti viršūnę.
addVertex(char* name);
• Įdėti/išmesti briauną tarp viršūnių V1 ir V2.
addEdge(char* name1, char* name2);
• Sužinoti (rasti), ar yra kelias tarp viršūnių V1 ir V2.
hasExistingPath(v1, v2);
• Sužinoti (V1, V2) svorį.
getEdgeWeight(v1, v2);
• Pakeisti (V1, V2) svorį.
setEdgeWeight(v1, v2);
*/

struct AdjListNode
{
    int index;
    char* name;
    int weight;
    struct AdjListNode* next;
};
struct AdjList
{
    struct AdjListNode *head;
};
struct Graph
{
    int maxVertices;
    struct AdjList* adjListArray;
};

// Helpers
struct AdjListNode* newAdjListNode(int index, char* name, int weight) {
    struct AdjListNode* newNode = (struct AdjListNode*) malloc(sizeof(struct AdjListNode));
    newNode->index = index;
    newNode->name = name;
    newNode->weight = weight;
    newNode->next = NULL;
    return newNode;
}

// Functions
struct Graph* createGraph(int maxVertices) {
    struct Graph* graph = (struct Graph*) malloc(sizeof(struct Graph));
    graph->maxVertices = maxVertices;
    graph->adjListArray = (struct AdjList*) malloc(maxVertices * sizeof(struct AdjList));
    for (int i = 0; i < maxVertices; ++i) {
        graph->adjListArray[i].head = NULL;
    }
    return graph;
}

void addVertex(struct Graph* graph, int index, char* name) {
    struct AdjListNode* newNode = newAdjListNode(index, name, 0);
    for (int i = 0; i < graph->maxVertices; ++i) {
        if (graph->adjListArray[i].head == NULL) {
            graph->adjListArray[i].head = newNode;
            break;
        }
    }
}

void addEdge(struct Graph* graph, int index1, char* name1, int index2, char* name2, int weight) {
    // Add to first
    struct AdjListNode* edge1 = newAdjListNode(index2, name2, weight);
    for (int i = 0; i < graph->maxVertices; ++i) {
        struct AdjListNode* vertex = graph->adjListArray[i].head;
        if (vertex->index == index1) {
            while (vertex->next != NULL) {
                vertex = vertex->next;
            }
            vertex->next = edge1;
            break;
        }
    }

    // Add to second
    struct AdjListNode* edge2 = newAdjListNode(index1, name1, weight);
    for (int i = 0; i < graph->maxVertices; ++i) {
        struct AdjListNode* vertex = graph->adjListArray[i].head;
        if (vertex->index == index2) {
            while (vertex->next != NULL) {
                vertex = vertex->next;
            }
            vertex->next = edge2;
            break;
        }
    }
}
void destroyGraph(struct Graph** graph) {
    for (int i = 0; i < (*graph)->maxVertices; ++i) {
        struct AdjListNode* head = (*graph)->adjListArray[i].head;
        struct AdjListNode* temp = head;
        while (head != NULL) {
            temp = head;
            head = head->next;
            free(temp);
        }
        head = NULL;
    }
    free((*graph)->adjListArray);
    free(*graph);
}
