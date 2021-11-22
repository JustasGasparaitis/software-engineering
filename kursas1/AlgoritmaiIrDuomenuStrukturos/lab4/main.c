/*
Duotas lėktuvų skrydžių sąrašas: miestas, miestas, išskridimo laikas, skrydžio trukmė.
Rasti greičiausio skrydžio iš vieno duoto miesto į kitą duotą miestą maršrutą ir jo laiką
(pradinis išskridimo laikas yra nesvarbus).
Numatyti atvejį, kad toks maršrutas neegzistuoja.
Grafo realizacija paremta kaimynystės sąrašais.
*/
#include <stdio.h>
#include <stdlib.h>
#include "graph.h"
#include "priorityqueue.h"
#define INT_MAX 2147483647

struct Graph* initGraph(int maxVertices);
void dijkstra(struct Graph* graph, int vertexCount, int startIndex, int dist[], int prev[]);
void findShortestPath(struct Graph* graph, int vertexCount, int startIndex, int endIndex, int dist[], int index[]);
void printShortestPath(struct Graph* graph, int vertexCount, int endIndex, int index[], int dist[]);
int main()
{
    int vertexCount = 5; // city count
    int index[vertexCount]; // index of each city
    int dist[vertexCount]; // distances between city and other cities
    struct Graph* graph = initGraph(vertexCount);

    int startIndex = 0; // flight origin
    int endIndex = 4; //  flight destination

    findShortestPath(graph, vertexCount, startIndex, endIndex, dist, index);
    printShortestPath(graph, vertexCount, endIndex, index, dist);

    destroyGraph(&graph);
    return 0;
}
struct Graph* initGraph(int maxVertices) {
    struct Graph* graph = createGraph(maxVertices);
    addVertex(graph, 0, "Vilnius");
    addVertex(graph, 1, "Kaunas");
    addVertex(graph, 2, "Klaipeda");
    addVertex(graph, 3, "Siauliai");
    addVertex(graph, 4, "Londonas");
    addEdge(graph, 0, "Vilnius", 1, "Kaunas", 20);
    addEdge(graph, 1, "Kaunas", 2, "Klaipeda", 30);
    addEdge(graph, 0, "Vilnius", 2, "Klaipeda", 135);
    addEdge(graph, 2, "Klaipeda", 3, "Siauliai", 20);
    return graph;
}
void dijkstra(struct Graph* graph, int vertexCount, int startIndex, int dist[], int prev[]) {
    int vis[vertexCount]; // visited
    int index;
    int minValue;
    int newDist;
    struct PQ* pq = createPQ();
    for (int i = 0; i < vertexCount; ++i) {
        vis[i] = 0;
        dist[i] = INT_MAX;
        prev[i] = -1;
    }
    dist[startIndex] = 0;
    enqueue(&pq, startIndex, 0);
    while (!isPQEmpty(pq)) {
        index = pq->_front->priority;
        minValue = pq->_front->data;
        dequeue(&pq);
        vis[index] = 1;
        if (dist[index] < minValue) {
            continue;
        }
        struct AdjListNode* edge = graph->adjListArray[index].head;
        while (edge != NULL) {
            if (vis[edge->index]) {
                edge = edge->next;
                continue;
            }
            newDist = dist[index] + edge->weight;
            if (newDist < dist[edge->index]) {
                prev[edge->index] = index;
                dist[edge->index] = newDist;
                enqueue(&pq, edge->index, newDist);
            }
            edge = edge->next;
        }
    }
    destroyPQ(&pq);
}
void findShortestPath(struct Graph* graph, int vertexCount, int startIndex, int endIndex, int dist[], int index[]) {
    int size = 0;
    int result[vertexCount];
    int prev[vertexCount];
    dijkstra(graph, vertexCount, startIndex, dist, prev);
    for (int i = 0; i < vertexCount; ++i) {
        index[i] = 0;
        result[i] = -1;
    }
    if (dist[endIndex] == INT_MAX) {
        for (int i = 0; i < vertexCount; ++i)
            index[i] = -1;
        return;
    }
    for (int i = endIndex; i >= 0; i = prev[i]) {
        result[size] = i;
        size++;
    }
    for (int i = 0; i < vertexCount; ++i) {
        index[i] = result[vertexCount - i - 1];
    }
}
void printShortestPath(struct Graph* graph, int vertexCount, int endIndex, int index[], int dist[]) {
    if (index[vertexCount - 1] == -1) {
        printf("Marsrutas neegzistuoja.");
    } else {
        printf("Marsrutas: ");
        for (int i = 0; i < vertexCount; ++i) {
            if (index[i] != -1) {
                printf("%s", graph->adjListArray[index[i]].head->name);
                if (i != vertexCount - 1 && index[i] != -1) printf("->");
            }
        }
        printf("\nTrukme: %d min.\n", dist[endIndex]);
    }
}
