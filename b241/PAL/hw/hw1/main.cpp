#include <algorithm>
#include <functional>
#include <vector>
#include <iostream>
#include <numeric>
#include <queue>
#include <cmath>

using namespace std;

struct edge {
    int from;
    int to;
    int weight;

    edge(const int from, const int to, const int weight) : from(from), to(to), weight(weight) {
    }

    bool operator <(const edge &e) const {
        return weight < e.weight || (weight == e.weight && from < e.from) || (
                   weight == e.weight && from == e.from && to < e.to);
    }

    bool operator >(const edge &e) const {
        return weight > e.weight || (weight == e.weight && from > e.from) || (
                   weight == e.weight && from == e.from && to > e.to);
    }
};

struct uf_vertex {
    int parent;
    int rank;

    explicit uf_vertex(const int parent = -1, const int rank = -1) : parent(parent), rank(rank) {
    }

    uf_vertex &operator ++() {
        ++parent;
        return *this;
    }
};

int input(priority_queue<edge, vector<edge>, greater<>> &edges, int C);

int find(uf_vertex *connections, int Q);

int union_rank(uf_vertex *connections, int Q1, int Q2);

int kruskal(priority_queue<edge, vector<edge>, greater<>> &edges, int *minspan, const int *filter_tree, int Q, int C, int D, bool filter);

bool filterEdge(const int *connections, int Q1, int Q2, int Q, int D);

int makeGraph(vector<edge> &edges, int *graph, int Q);

int main() {
    int Q, C, D;

    int res = scanf("%d %d %d", &Q, &C, &D);
    if (res != 3) return -1;

    priority_queue<edge, vector<edge>, greater<>> edges;

    res = input(edges, C);
    if (res == -1) return -1;

    int minspan[Q], secspan[Q];

    const int price1 = kruskal(edges, minspan, secspan, Q, C, D, false);
    if (price1 == -1) return -1;

    const int price2 = kruskal(edges, secspan, minspan, Q, C, D, true);
    if (price2 == -1) return -1;

    printf("%d %d\n", price1, price2);
    return 0;
}

int input(priority_queue<edge, vector<edge>, greater<>> &edges, const int C) {
    int Q1, Q2, weight;

    for (int i = 0; i < C; i++) {
        const int res = scanf("%d %d %d", &Q1, &Q2, &weight);
        if (res != 3) return -1;

        edges.emplace(Q1 - 1, Q2 - 1, weight);
    }

    return 0;
}

int find(uf_vertex *connections, const int Q) {
    const int parent = connections[Q].parent;

    if (Q == parent) return Q;

    const int result = find(connections, parent);

    connections[Q].parent = result;

    return result;
}

int union_rank(uf_vertex *connections, const int Q1, const int Q2) {
    const int root1 = find(connections, Q1);
    const int root2 = find(connections, Q2);

    if (root1 == root2) return 1;

    const int rank1 = connections[root1].rank;
    const int rank2 = connections[root2].rank;

    if (rank1 < rank2) {
        connections[root1].parent = root2;
        return 0;
    }

    if (rank1 > rank2) {
        connections[root2].parent = root1;
        return 0;
    }

    connections[root1].parent = root2;
    connections[root2].rank += 1;

    return 0;
}

int kruskal(
    priority_queue<edge, vector<edge>, greater<>> &edges,
    int *minspan,
    const int *filter_tree,
    const int Q,
    const int C,
    const int D,
    const bool filter
) {
    priority_queue<edge, vector<edge>, greater<>> unused_edges;
    vector<edge> tree;

    uf_vertex connections[Q];

    iota(connections, connections + Q, uf_vertex(0, 0));

    int no_edges = 0;
    int price = 0;

    const int mod = static_cast<int>(pow(2, 16));

    while (no_edges < (Q - 1) || !edges.empty()) {
        edge e = edges.top();
        edges.pop();

        if (filter) {
            if (!filterEdge(filter_tree, e.from, e.to, Q, D)) continue;
        }

        const int res = union_rank(connections, e.from, e.to);

        if (res == 1) {
            unused_edges.emplace(e);
            continue;
        }

        tree.emplace_back(e);
        no_edges++;
        price += e.weight % mod;
        price %= mod;
    }

    if (!filter) makeGraph(tree, minspan, Q);
    edges = move(unused_edges);
    return price;
}

bool filterEdge(const int *connections, const int Q1, const int Q2, const int Q, const int D) {
    int distance[Q];
    fill_n(distance, Q, -1);

    distance[Q1] = 0;
    distance[Q2] = 0;

    int curr1 = Q1, curr2 = Q2;

    while (curr1 != curr2) {
        const int parent1 = connections[curr1];
        const int parent2 = connections[curr2];

        if (distance[parent1] != -1 && curr1 != parent1) {
            const int total_dist = distance[parent1] + distance[curr1] + 1;
            if (total_dist < D) return true;
            break;
        }

        if (curr1 != parent1) distance[parent1] = distance[curr1] + 1;

        if (distance[parent2] != -1 && curr2 != parent2) {
            const int total_dist = distance[parent2] + distance[curr2] + 1;
            if (total_dist < D) return true;
            break;
        }

        if (curr2 != parent2) distance[parent2] = distance[curr2] + 1;

        curr1 = parent1;
        curr2 = parent2;

        if (distance[curr1] == D || distance[curr2] == D) break;
    }

    return false;
}

int makeGraph(vector<edge> &edges, int *graph, const int Q) {
    queue<int> q;
    bool visited[Q];

    fill_n(visited, Q, false);

    q.emplace(0);
    visited[0] = true;
    graph[0] = 0;

    while (!q.empty()) {
        vector<edge>::iterator it;

        int curr = q.front();
        q.pop();

        it = find_if(edges.begin(), edges.end(), [&curr](const edge &e) {
            return e.from == curr || e.to == curr;
        });

        while (it != edges.end()) {
            int next = it->from == curr ? it->to : it->from;

            if (!visited[next]) {
                q.emplace(next);
                visited[next] = true;
                graph[next] = curr;
            };

            it = find_if(++it, edges.end(), [&curr](const edge &e) {
                return e.from == curr || e.to == curr;
            });
        }
    }

    return 0;
}
