#include <algorithm>
#include <iostream>
#include <tuple>
#include <unordered_set>
#include <vector>
#include <set>
#include <queue>

using namespace std;

int input(vector<tuple<int, int, int> > &edges, int C);

int unionFind(int *connections, int Q, int Q1, int Q2);

int kruskal(vector<tuple<int, int, int> > &edges, vector<tuple<int, int, int> > &minspan, int Q, int C);

int countItems(int *arr, int n);

int filterEdges(vector<tuple<int, int, int> > &edges, vector<tuple<int, int, int> > &minspan, int Q, int D);

bool containsQpu(tuple<int, int, int> e, int qpu);

int main() {
    vector<tuple<int, int, int> > edges;
    vector<tuple<int, int, int> > minspan;
    vector<tuple<int, int, int> > secondary_minspan;

    int Q, C, D;

    int res = scanf("%d %d %d", &Q, &C, &D);
    if (res != 3) return -1;

    res = input(edges, C);
    if (res == -1) return -1;

    make_heap(edges.begin(), edges.end(), greater<>());

    int price1 = kruskal(edges, minspan, Q, C);

    if (price1 == -1) return -1;

    filterEdges(edges, minspan, Q, D);

    make_heap(edges.begin(), edges.end(), greater<>());

    int price2 = kruskal(edges, secondary_minspan, Q, edges.size());

    printf("%d %d\n", price1, price2);

    return 0;
}

int input(vector<tuple<int, int, int> > &edges, const int C) {
    int Q1, Q2, p;
    for (int i = 0; i < C; i++) {
        int res = scanf("%d %d %d", &Q1, &Q2, &p);
        if (res != 3) {
            return -1;
        }

        edges.emplace_back(p, Q1, Q2);
    }

    return 0;
}

int unionFind(int *connections, int Q, int Q1, int Q2) {
    if (Q < Q1 || Q < Q2) return -1;

    int parent1 = connections[Q1 - 1];
    int parent2 = connections[Q2 - 1];

    // none of the vertices is connected
    if (parent1 == -1 && parent2 == -1) {
        connections[Q1 - 1] = Q1;
        connections[Q2 - 1] = Q1;
        return 0;
    }

    // both are in the same set
    if (parent1 == parent2) return 1;

    // Q1 is not connected
    if (parent1 == -1) {
        connections[Q1 - 1] = parent2;
        return 0;
    }

    // Q2 is not connected
    if (parent2 == -1) {
        connections[Q2 - 1] = parent1;
        return 0;
    }

    // Q1 and Q2 are in disjoint set
    for (int i = 0; i < Q; i++) {
        if (connections[i] == parent2) {
            connections[i] = parent1;
        }
    }
    return 0;
}

int kruskal(vector<tuple<int, int, int> > &edges, vector<tuple<int, int, int> > &minspan, int Q, int C) {
    vector<tuple<int, int, int> > unused_edges;
    tuple<int, int, int> edge;

    int connected[Q];
    fill_n(connected, Q, -1);
    int price = 0;

    if (C < Q * Q / 2) {
        for (int i = 0; i < C; i++) {
            pop_heap(edges.begin(), edges.end(), greater<>());
            edge = edges.back();
            edges.pop_back();

            int res = unionFind(connected, Q, get<1>(edge), get<2>(edge));

            if (res == -1) return -1;
            if (res == 1) {
                unused_edges.emplace_back(edge);
                continue;
            }

            minspan.emplace_back(edge);
            price += get<0>(edge);
        }

        edges = unused_edges;

        return price;
    }

    bool finished = false;
    while (finished == false) {
        pop_heap(edges.begin(), edges.end(), greater<>());
        edge = edges.back();
        edges.pop_back();

        int res = unionFind(connected, Q, get<1>(edge), get<2>(edge));

        if (res == -1) return -1;
        if (res == 1) {
            unused_edges.emplace_back(edge);
            continue;
        }

        minspan.emplace_back(edge);
        price += get<0>(edge);

        if (countItems(connected, Q) == 1 || edges.empty() == true) {
            finished = true;
        }
    }

    edges = unused_edges;

    return price;
}

int countItems(int *arr, int n) {
    unordered_set<int> s;

    int res = 0;

    for (int i = 0; i < n; i++) {
        if (s.find(arr[i]) == s.end()) {
            s.insert(arr[i]);
            res++;
        }
    }

    return res;
}

int filterEdges(vector<tuple<int, int, int> > &edges, vector<tuple<int, int, int> > &minspan, int Q, int D) {
    tuple<int, int, int> edge;
    vector<tuple<int, int, int> > secondary_minspan;

    bool visited[Q];
    queue<int> q;

    vector<tuple<int, int, int> >::iterator it;
    bool success;
    int current;

    while (!edges.empty()) {
        success = false;
        edge = edges.back();
        edges.pop_back();

        fill_n(visited, Q, false);

        visited[get<1>(edge) - 1] = true;

        q.push(get<1>(edge));

        int i = 0;
        while (!q.empty() && i < D - 1) {
            current = q.front();
            q.pop();

            it = find_if(minspan.begin(), minspan.end(), [&current](const tuple<int, int, int> &e) {
                return containsQpu(e, current);
            });

            while (it != minspan.end()) {
                int adj = get<1>(*it) == current ? get<2>(*it) : get<1>(*it);

                if (adj == get<2>(edge)) {
                    success = true;
                    goto search_finished;
                }

                if (visited[adj - 1] == false) {
                    visited[adj - 1] = true;
                    q.push(adj);
                }

                it = find_if(++it, minspan.end(), [&current](const tuple<int, int, int> &e) {
                    return containsQpu(e, current);
                });
            }
            ++i;
        }

    search_finished:
        queue<int> empty;
        swap(q, empty);
        if (success == false) {
            continue;
        }

        secondary_minspan.emplace_back(edge);
    }

    edges = secondary_minspan;
    return 0;
}

bool containsQpu(tuple<int, int, int> e, int qpu) {
    bool first = get<1>(e) == qpu;
    bool second = get<2>(e) == qpu;
    return first || second;
}
