#include <algorithm>
#include <cmath>
#include <iostream>
#include <vector>
#include <tuple>

using namespace std;

bool containsQPU(tuple<int, int, int> e, int qpu) {
    bool first = get<1>(e) == qpu;
    bool second = get<2>(e) == qpu;
    return first || second;
}

int input(vector<tuple<int, int,int>>& edges, int C) {
    int c1, c2, p;
    for (int i = 0; i < C; i++) {
        int res = scanf("%d %d %d", &c1, &c2, &p);
        if (res != 3) {
            return -1;
        }

        edges.push_back(make_tuple(p, c1, c2));
    }

    return 0;
}

int prim(vector<tuple<int, int,int>>& edges, int  Q, vector<tuple<int, int,int>>& minspan) {
    vector<int> connected = {1};
    vector<tuple<int, int, int>> connections;
    vector<int> used_conns;
    make_heap(connections.begin(), connections.end(), greater<>{});
    int price = 0;

            vector<tuple<int, int, int>>::iterator it;
    while (connected.size() < Q) {
        for (int qpu : connected) {
            it = find_if(edges.begin(), edges.end(), [&qpu](const tuple<int, int, int>& e) {return containsQPU(e, qpu);});

            while (it != edges.end()) {
                int pos = it - edges.begin();
                if (find(used_conns.begin(), used_conns.end(), pos) == used_conns.end()) {
                    used_conns.push_back(pos);
                    connections.push_back(*it);
                    push_heap(connections.begin(), connections.end(), greater<>{});
                }

                it = find_if(++it, edges.end(), [&qpu](const tuple<int, int, int>& e) {return containsQPU(e, qpu);});
            }
        }
        bool success = false;
        while (!success && !connections.empty()) {
            pop_heap(connections.begin(), connections.end(), greater<>{});
            tuple<int, int, int> edge = connections.back();
            connections.pop_back();

            if (find(connected.begin(), connected.end(), get<1>(edge)) == connected.end()) {
                success = true;
                minspan.push_back(edge);
                connected.push_back(get<1>(edge));
                price += get<0>(edge);
            } else if (find(connected.begin(), connected.end(), get<2>(edge)) == connected.end()) {
                success = true;
                minspan.push_back(edge);
                connected.push_back(get<2>(edge));
                price += get<0>(edge);
            }
        }
    }
    return price;
}

int secondary(vector<tuple<int, int,int>>& edges, vector<tuple<int, int,int>>& minspan,vector<tuple<int, int, int>>& secondary_net, int D, int Q) {
    vector<tuple<int, int, int>> connections;
    sort(edges.begin(), edges.end());
    sort(minspan.begin(), minspan.end());
    set_difference(edges.begin(), edges.end(),minspan.begin(), minspan.end(),inserter(connections, connections.end()));

    make_heap(connections.begin(), connections.end(), greater<>{});

    int price = 0;

    bool success = false;
    vector<int> neighbours;
    vector<int> new_neighbours;
    vector<tuple<int, int>> connected;
    vector<tuple<int, int, int>>::iterator it;

    while (!connections.empty()) {
        success = false;

        pop_heap(connections.begin(), connections.end(), greater<>{});
        tuple<int, int, int> edge = connections.back();
        connections.pop_back();

        neighbours.push_back(get<1>(edge));

        for (int i = 0; i < D-1; i++) {
            new_neighbours = neighbours;
            for (int qpu : neighbours) {
                it = find_if(minspan.begin(), minspan.end(), [&qpu](const tuple<int, int, int>& e) {return containsQPU(e, qpu);});

                while (it != minspan.end()) {
                    int neigbour = get<1>(*it) == qpu ? get<2>(*it) : get<1>(*it);
                    if (neigbour == get<2>(edge)) {
                        success = true;
                        goto search_finished;
                    }
                    if (find(new_neighbours.begin(), new_neighbours.end(), neigbour) == new_neighbours.end()) {
                        new_neighbours.push_back(neigbour);
                    }

                    it = find_if(++it, minspan.end(), [&qpu](const tuple<int, int, int>& e) {return containsQPU(e, qpu);});
                }
            }

            neighbours = new_neighbours;
        }
        search_finished:
        neighbours.clear();

        if (!success) {
            continue;
        }

        vector<tuple<int, int>>::iterator iter1;
        vector<tuple<int, int>>::iterator iter2;

        iter1 = find_if(connected.begin(), connected.end(), [&edge](const tuple<int, int>& e) {return get<1>(edge) == get<1>(e);});
        iter2 = find_if(connected.begin(), connected.end(), [&edge](const tuple<int, int>& e) {return get<2>(edge) == get<1>(e);});

        if (iter1 == connected.end() && iter2 == connected.end()) {
            connected.push_back({get<1>(edge), get<1>(edge)});
            connected.push_back({get<1>(edge), get<2>(edge)});
            secondary_net.push_back(edge);
            price += get<0>(edge);
            continue;
        }

        if (get<0>(*iter1) == get<0>(*iter2)) {
            continue;
        }

        if (iter1 != connected.end() && iter2 != connected.end()) {
            vector<tuple<int, int>>::iterator iter = connected.begin();
            int parent1 = get<0>(*iter1);
            int parent2 = get<0>(*iter2);
            iter = find_if(connected.begin(), connected.end(), [&parent2](const tuple<int, int>& e){return get<0>(e) == parent2;});

            while (iter != connected.end()) {
                connected[iter - connected.begin()] = {parent1, get<1>(*iter)};

                iter = find_if(++iter, connected.end(), [&parent2](const tuple<int, int>& e){return get<0>(e) == parent2;});
            }

            secondary_net.push_back(edge);
            price += get<0>(edge);

            continue;
        }

        if (iter1 != connected.end()) {
            connected.push_back({get<0>(*iter1), get<2>(edge)});
            secondary_net.push_back(edge);
            price += get<0>(edge);
            continue;
        }

        if (iter2 != connected.end()) {
            connected.push_back({get<0>(*iter2), get<1>(edge)});
            secondary_net.push_back(edge);
            price += get<0>(edge);
        }
    }

    return price;
}

int main() {
    int Q, C, D;

    int res = scanf("%d %d %d", &Q, &C, &D);
    if (res != 3) {
        return -1;
    }

    vector<tuple<int, int, int>> edges;

    input(edges, C);

    vector<tuple<int, int, int>> minspan;
    int first_res = prim(edges, Q, minspan);

    vector<tuple<int, int, int>> secondary_net;
    int second_res = secondary(edges, minspan, secondary_net,D,Q);

    printf("%d %d\n", first_res % (int) pow(2, 16), second_res % (int) pow(2, 16));
    return 0;
}