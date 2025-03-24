// https://opendsa-server.cs.vt.edu/ODSA/Books/Everything/html/Splay.html
#include <iostream>

struct Node {
    int key;
    Node *left;
    Node *right;
    Node *parent;

    explicit Node(int k) {
        key = k;
        left = nullptr;
        right = nullptr;
        parent = nullptr;
    }
};

class SplayTree {
    Node *root;

    bool zigOnly;

    void zig(Node *);

    void zig_zig(Node *);

    void zig_zag(Node *);

    void splay(Node *);

    Node *find_min(Node *);

    Node *find_max(Node *);

public:
    SplayTree(bool);

    explicit SplayTree(Node *, bool);

    Node *find(int);

    void insert(int);

    void remove(int);

    int calcDepth(Node *);
};

void SplayTree::zig(Node *A) {
    Node *B = A->parent;

    // R rotation
    if (A == B->left) {
        Node *A_right = A->right;

        A->parent = B->parent;
        A->right = B;

        B->parent = A;
        B->left = A_right;

        if (A->parent != nullptr) {
            if (A->parent->left == B)
                A->parent->left = A;
            else
                A->parent->right = A;
        } else
            this->root = A;

        if (A_right != nullptr)
            A_right->parent = B;
    }
    // L rotation
    else {
        Node *A_left = A->left;

        A->parent = B->parent;
        A->left = B;

        B->parent = A;
        B->right = A_left;

        if (A->parent != nullptr) {
            if (A->parent->left == B)
                A->parent->left = A;
            else
                A->parent->right = A;
        } else
            this->root = A;

        if (A_left != nullptr)
            A_left->parent = B;
    }
}

void SplayTree::zig_zig(Node *A) {
    Node *B = A->parent;
    Node *C = B->parent;

    // R-R rotation
    if (A == B->left) {
        Node *A_right = A->right;
        Node *B_right = B->right;

        A->parent = C->parent;
        A->right = B;

        B->parent = A;
        B->left = A_right;
        B->right = C;

        C->parent = B;
        C->left = B_right;

        if (A->parent != nullptr) {
            if (A->parent->left == C)
                A->parent->left = A;
            else
                A->parent->right = A;
        } else
            this->root = A;

        if (A_right != nullptr)
            A_right->parent = B;

        if (B_right != nullptr)
            B_right->parent = C;
    }
    // L-L rotation
    else {
        Node *A_left = A->left;
        Node *B_left = B->left;

        A->parent = C->parent;
        A->left = B;

        B->parent = A;
        B->right = A_left;
        B->left = C;

        C->parent = B;
        C->right = B_left;

        if (A->parent != nullptr) {
            if (A->parent->left == C)
                A->parent->left = A;
            else
                A->parent->right = A;
        } else
            this->root = A;

        if (A_left != nullptr)
            A_left->parent = B;

        if (B_left != nullptr)
            B_left->parent = C;
    }
}


void SplayTree::zig_zag(Node *B) {
    Node *A = B->parent;
    Node *C = A->parent;

    // L-R rotation
    if (B == A->right) {
        Node *B_left = B->left;
        Node *B_right = B->right;

        B->parent = C->parent;
        B->left = A;
        B->right = C;

        A->parent = B;
        A->right = B_left;

        C->parent = B;
        C->left = B_right;

        if (B->parent != nullptr) {
            if (B->parent->left == C)
                B->parent->left = B;
            else
                B->parent->right = B;
        } else
            this->root = B;

        if (B_left != nullptr)
            B_left->parent = A;

        if (B_right != nullptr)
            B_right->parent = C;
    }
    // R-L rotation
    else {
        Node *B_left = B->left;
        Node *B_right = B->right;

        B->parent = C->parent;
        B->right = A;
        B->left = C;

        A->parent = B;
        A->left = B_right;

        C->parent = B;
        C->right = B_left;

        if (B->parent != nullptr) {
            if (B->parent->left == C)
                B->parent->left = B;
            else
                B->parent->right = B;
        } else
            this->root = B;

        if (B_left != nullptr)
            B_left->parent = C;

        if (B_right != nullptr)
            B_right->parent = A;
    }
}

void SplayTree::splay(Node *A) {
    while (A->parent != nullptr) {
        Node *B = A->parent;

        if (B->parent == nullptr || this->zigOnly) {
            zig(A);
            continue;
        }

        Node *C = B->parent;

        if (C->left == B && B->left == A)
            zig_zig(A);
        else if (C->right == B && B->right == A)
            zig_zig(A);
        else
            zig_zag(A);
    }
    this->root = A;
}

Node *SplayTree::find_min(Node *r) {
    Node *currNode = r;
    while (currNode->left != nullptr)
        currNode = currNode->left;
    return currNode;
}

Node *SplayTree::find_max(Node *r) {
    Node *currNode = r;
    while (currNode->right != nullptr)
        currNode = currNode->right;
    return currNode;
}

SplayTree::SplayTree(bool zigOnly) {
    this->root = nullptr;
    this->zigOnly = zigOnly;
}

SplayTree::SplayTree(Node *r, bool zigOnly) {
    this->root = r;
    this->zigOnly = zigOnly;
}

Node *SplayTree::find(int key) {
    Node *res = nullptr;
    Node *currNode = this->root;
    Node *prevNode = nullptr;

    while (currNode != nullptr) {
        prevNode = currNode;
        if (key < currNode->key)
            currNode = currNode->left;
        else if (key > currNode->key)
            currNode = currNode->right;
        else {
            res = currNode;
            break;
        }
    }

    if (res != nullptr)
        splay(res);
    else if (prevNode != nullptr)
        splay(prevNode);

    return res;
}

void SplayTree::insert(int key) {
    if (this->root == nullptr) {
        root = new Node(key);
        return;
    }

    Node *currNode = this->root;
    while (currNode != nullptr) {
        if (key < currNode->key) {
            if (currNode->left == nullptr) {
                Node *newNode = new Node(key);
                currNode->left = newNode;
                newNode->parent = currNode;
                splay(newNode);
                return;
            }
            currNode = currNode->left;
        } else if (key > currNode->key) {
            if (currNode->right == nullptr) {
                Node *newNode = new Node(key);
                currNode->right = newNode;
                newNode->parent = currNode;
                splay(newNode);
                return;
            }
            currNode = currNode->right;
        }
    }
    if (currNode != nullptr)
        splay(currNode);
}

void SplayTree::remove(int key) {
    Node *delNode = find(key);

    if (delNode == nullptr)
        return;

    Node *leftChild = delNode->left;
    Node *rightChild = delNode->right;

    if (leftChild == nullptr && rightChild == nullptr) {
        this->root = nullptr;
    } else if (leftChild == nullptr) {
        this->root = rightChild;
        rightChild->parent = nullptr;
    } else if (rightChild == nullptr) {
        Node *newRoot = find_max(leftChild);
        splay(newRoot);
    } else {
        Node *newRoot = find_max(leftChild);
        splay(newRoot);
        newRoot->right = rightChild;
        rightChild->parent = newRoot;
    }

    if (delNode->parent != nullptr) {
        if (delNode->parent->left == delNode)
            delNode->parent->left = nullptr;
        if (delNode->parent->right == delNode)
            delNode->parent->right = nullptr;
    }


    delete delNode;
}

int SplayTree::calcDepth(Node *n = nullptr) {
    if (n == nullptr)
        n = this->root;

    int res = 0;

    if (n->left != nullptr) {
        int l = this->calcDepth(n->left);
        if (l + 1 > res)
            res = l + 1;
    }

    if (n->right != nullptr) {
        int r = this->calcDepth(n->right);
        if (r + 1 > res)
            res = r + 1;
    }

    return res;
}

int main() {
    SplayTree *tree = new SplayTree(false);
    SplayTree *treeZig = new SplayTree(true);

    int numOperations;
    int r = scanf("%d \n", &numOperations);

    if (r != 1)
        return EXIT_FAILURE;

    while (numOperations--) {
        int operation;
        r = scanf("%d", &operation);

        if (r != 1)
            return EXIT_FAILURE;

        if (operation > 0) {
            tree->insert(operation);
            treeZig->insert(operation);
        } else if (operation < 0) {
            tree->remove(-operation);
            treeZig->remove(-operation);
        }
    }

    int res = tree->calcDepth();
    int resZig = treeZig->calcDepth();

    printf("%d %d\n", res, resZig);

    return EXIT_SUCCESS;
}
