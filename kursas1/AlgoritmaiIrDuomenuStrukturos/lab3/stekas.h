/**
Steko sukurimas:
struct StackNode* newStack = NULL;

Tikrinama, ar stekas tuscias:
isStackEmpty(newStack);

Ideti nauja elementa i steka:
pushToStack(&newStack);

Pirmo elemento duomenys:
newStack->data

Steko dydis:
getStackSize(newStack);

Isimti elementa is steko:
popFromStack(&newStack);

Sunaikinti steka:
destroyStack(&newStack);
*/

// Steko elementas
struct StackNode {
    int data;
    struct StackNode* next;
};

// Tikrinama, ar stekas tuscias
int isStackEmpty(struct StackNode* root) {
    return !root;
}

// Ideti nauja elementa i steka
void pushToStack(struct StackNode** root, int data) {
    struct StackNode* stackNode = (struct StackNode*) malloc(sizeof(struct StackNode));
    stackNode->data = data;
    stackNode->next = *root;
    *root = stackNode;
}

// Isimti elementa is steko
int popFromStack(struct StackNode** root) {
    struct StackNode* temp = *root;
    *root = (*root)->next;
    int node = temp->data;
    free(temp);
    return node;
}

// Sunaikinamas stekas
void destroyStack(struct StackNode** root) {
    while (!isStackEmpty(*root)) {
        popFromStack(root);
    }
    *root = NULL;
}
