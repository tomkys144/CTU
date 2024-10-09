#include <algorithm>
#include <cmath>
#include <iostream>
#include <tuple>
#include <unordered_set>
#include <vector>
#include <set>
#include <queue>

using namespace std;

int input(vector<tuple<int, int, int> > &edges, int C);

int unionFind(pair<int, int> *connections, int Q, int Q1, int Q2);

int kruskal(
    vector<tuple<int, int, int> > &edges,
    pair<int, int> *minspan,
    int Q,
    int C,
    int D,
    bool filter,
    pair<int, int> *filter_tree
);

int countItems(const pair<int, int> *arr, int n);

int filterEdge(int Q1, int Q2, const pair<int, int> *minspan, int Q, int D);

bool containsQpu(tuple<int, int, int> e, int qpu);

int main() {
    int Q, C, D;

    int res = scanf("%d %d %d", &Q, &C, &D);
    if (res != 3) return -1;

    vector<tuple<int, int, int> > edges;
    pair<int, int> minspan[Q];
    pair<int, int> secondary_minspan[Q];

    res = input(edges, C);
    if (res == -1) return -1;

    make_heap(edges.begin(), edges.end(), greater<>());

    const int price1 = kruskal(edges, minspan, Q, C, D, false, nullptr);

    if (price1 == -1) return -1;

    make_heap(edges.begin(), edges.end(), greater<>());

    const int price2 = kruskal(edges, secondary_minspan, Q, static_cast<int>(edges.size()), D, true, minspan);

    if (price2 == -1) return -1;

    printf("%d %d\n", price1, price2);

    return 0;
}

int input(vector<tuple<int, int, int> > &edges, const int C) {
    int Q1, Q2, p;
    for (int i = 0; i < C; i++) {
        const int res = scanf("%d %d %d", &Q1, &Q2, &p);
        if (res != 3) {
            return -1;
        }

        edges.emplace_back(p, Q1, Q2);
    }

    return 0;
}

int unionFind(pair<int, int> *connections, int Q, int Q1, int Q2) {
    if (Q < Q1 || Q < Q2) return -1;

    pair<int, int> parent1 = connections[Q1 - 1];
    pair<int, int> parent2 = connections[Q2 - 1];

    // none of the vertices is connected
    if (parent1.first == -1 && parent2.first == -1) {
        connections[Q1 - 1] = {Q1 - 1, Q1 - 1};
        connections[Q2 - 1] = {Q1 - 1, Q1 - 1};
        return 0;
    }

    // both are in the same set
    if (parent1.first == parent2.first) return 1;

    // Q1 is not connected
    if (parent1.first == -1) {
        connections[Q1 - 1] = {parent2.first, Q2 - 1};
        return 0;
    }

    // Q2 is not connected
    if (parent2.first == -1) {
        connections[Q2 - 1] = {parent1.first, Q1 - 1};
        return 0;
    }

    // Q1 and Q2 are in disjoint set
    int parent = parent1.second;
    int current = Q1 - 1;
    int root = parent1.first;
    int new_parent = 0;

    while (current != root) {
        new_parent = connections[parent].second;
        connections[parent].second = current;

        current = parent;
        parent = new_parent;
    }

    parent = parent2.second;
    current = Q2 - 1;
    root = parent2.first;

    while (current != root) {
        new_parent = connections[parent].second;
        connections[parent].second = current;

        current = parent;
        parent = new_parent;
    }

    connections[Q2 - 1].second = Q1 - 1;
    connections[Q1 - 1].second = Q1 - 1;

    for (int i = 0; i < Q; i++) {
        if (connections[i].first == parent1.first || connections[i].first == parent2.first) {
            connections[i].first = Q1 - 1;
        }
    }


    return 0;
}

int kruskal(vector<tuple<int, int, int> > &edges,
            pair<int, int> *minspan,
            int Q,
            int C,
            int D,
            bool filter,
            pair<int, int> *filter_tree
) {
    vector<tuple<int, int, int> > unused_edges;
    tuple<int, int, int> edge;

    fill_n(&minspan[0], Q, make_pair(-1, -1));

    int price = 0;

    if (C < Q * Q / 2) {
        for (int i = 0; i < C; i++) {
            pop_heap(edges.begin(), edges.end(), greater<>());
            edge = edges.back();
            edges.pop_back();

            int res;

            if (filter) {
                res = filterEdge(get<1>(edge), get<2>(edge), filter_tree, Q, D);
                
                if (res == 1) continue;
            }

            res = unionFind(minspan, Q, get<1>(edge), get<2>(edge));

            if (res == -1) return -1;
            if (res == 1) {
                unused_edges.emplace_back(edge);
                continue;
            }

            price += get<0>(edge);
        }

        swap(edges, unused_edges);

        return price % static_cast<int>(pow(2, 16));
    }

    bool finished = false;
    while (finished == false) {
        pop_heap(edges.begin(), edges.end(), greater<>());
        edge = edges.back();
        edges.pop_back();

        int res;

        if (filter) {
            res = filterEdge(get<1>(edge), get<2>(edge), filter_tree, Q, D);

            if (res == 1) continue;
        }

        res = unionFind(minspan, Q, get<1>(edge), get<2>(edge));

        if (res == -1) return -1;
        if (res == 1) {
            unused_edges.emplace_back(edge);
            continue;
        }
        price += get<0>(edge);

        if (countItems(minspan, Q) == 1 || edges.empty() == true) {
            finished = true;
        }
    }

    swap(edges, unused_edges);

    return price % static_cast<int>(pow(2, 16));
}

int countItems(const pair<int, int> *arr, const int n) {
    unordered_set<int> s;

    int res = 0;

    for (int i = 0; i < n; i++) {
        if (s.find(arr[i].first) == s.end()) {
            s.insert(arr[i].first);
            res++;
        }
    }

    return res;
}

int filterEdge(const int Q1, const int Q2, const pair<int, int> *minspan, const int Q, const int D) {
    int distance[Q];
    fill_n(distance, Q, -1);

    distance[Q1 - 1] = 0;
    distance[Q2 - 1] = 0;

    int curr1 = Q1-1;
    int curr2 = Q2-1;

    int parent1, parent2;

    while(curr1 != curr2) {
        parent1 = minspan[curr1].second;
        parent2 = minspan[curr2].second;

        if (distance[parent1] != -1 && curr1 != parent1) {
            int total_dist = distance[parent1] + distance[curr1] + 1;
            if (total_dist < D) {
                return 0;
            }
            break;
        }

        if (curr1 != parent1) distance[parent1] = distance[curr1] + 1;

        if (distance[parent2] != -1 && curr2 != parent2) {
            int total_dist = distance[parent2] + distance[curr2] + 1;
            if (total_dist < D) {
                return 0;
            }
            break;
        }

        if (curr2 != parent2) distance[parent2] = distance[curr2] + 1;

        curr1 = parent1;
        curr2 = parent2;

        if (distance[curr1] == D || distance[curr2] == D) break;
    }


    return 1;
}

bool containsQpu(tuple<int, int, int> e, int qpu) {
    bool first = get<1>(e) == qpu;
    bool second = get<2>(e) == qpu;
    return first || second;
}
