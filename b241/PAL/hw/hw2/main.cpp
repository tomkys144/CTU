#include <algorithm>
#include <iostream>
#include <stack>
#include <vector>

using namespace std;

struct SCC
{
  vector<int> nodes;
  vector<int> children;
  vector<int> parents;
  int root{};
};

struct Lake
{
  vector<int> children;
  int scc{ -1 };
};

int
input(Lake Lakes[], int LA, int CA);

void
findScc(Lake Lakes[], int LA, int CA, vector<SCC>& components);

void
findSccHelper(int lake,
              Lake Lakes[],
              int LA,
              int CA,
              vector<SCC>& components,
              int* low,
              int* dist,
              bool* inStack,
              stack<int>& lakeStack);

void
topoSort(vector<SCC>& components, int source, vector<int>& sorting);

void
topoSortHelper(int comp,
               vector<SCC>& components,
               bool* visited,
               stack<int>& comStack);

u_int
longestPath(int end, vector<SCC>& components, vector<int>& sorting);

int
main()
{
  int LA, CA, DO;

  int res = scanf("%d %d %d", &LA, &CA, &DO);
  if (res != 3) return -1;

  Lake Lakes[LA];

  res = input(Lakes, LA, CA);
  if (res < 0) return res;

  vector<SCC> Components;

  findScc(Lakes, LA, CA, Components);

  const int source = Lakes[DO].scc;
  vector<int> sorting;
  u_int result = Components[source].nodes.size();

  for (const int parent : Components[source].parents) {
    topoSort(Components, parent, sorting);
    const u_int foundPath = longestPath(source, Components, sorting);

    if (foundPath > result) result = foundPath;

    sorting.clear();
  }

  printf("%d\n", result);

  return 0;
}

int
input(Lake Lakes[], const int LA, const int CA)
{
  for (size_t i = 0; i < CA; i++) {
    int L1, L2;

    const int res = scanf("%d %d", &L1, &L2);
    if (res != 2) return -1;
    if (L1 > LA || L2 > LA) return -2;

    Lakes[L1].children.push_back(L2);
  }
  return 0;
}

void
findScc(Lake Lakes[], const int LA, const int CA, vector<SCC>& components)
{
  int low[LA];
  int dist[LA];
  bool inStack[LA];
  stack<int> lakeStack;

  for (int i = 0; i < LA; i++) {
    low[i] = dist[i] = -1;
    inStack[i] = false;
  }

  for (int i = 0; i < LA; i++) {
    if (dist[i] == -1) {
      findSccHelper(i,
                    Lakes,
                    LA,
                    CA,
                    components,
                    low,
                    dist,
                    inStack,
                    lakeStack);
    }
  }
}

void
findSccHelper(const int lake,
              Lake Lakes[],
              const int LA,
              const int CA,
              vector<SCC>& components,
              int* low,
              int* dist,
              bool* inStack,
              stack<int>& lakeStack)
{
  static int currDist = 0;
  static vector<pair<int, int> > conns;

  low[lake] = dist[lake] = ++currDist;
  lakeStack.push(lake);
  inStack[lake] = true;

  for (const int child : Lakes[lake].children) {
    // child isn't visited
    if (low[child] == -1) {
      findSccHelper(child,
                    Lakes,
                    LA,
                    CA,
                    components,
                    low,
                    dist,
                    inStack,
                    lakeStack);
      low[lake] = min(low[lake], low[child]);
    }
    // child visited, but probably in the current scc
    else if (inStack[child]) {
      low[lake] = min(low[lake], dist[child]);
    }

    // If child is not in stack, mark down cross-edge
    if (!inStack[child]) {
      int neighbour = Lakes[child].scc;
      conns.emplace_back(neighbour, lake);
    }
  }

  if (low[lake] == dist[lake]) {
    SCC newScc;
    int newSccIndex = static_cast<int>(components.size());

    newScc.root = lake;

    int node;
    do {
      node = lakeStack.top();
      lakeStack.pop();

      inStack[node] = false;

      newScc.nodes.push_back(node);

      Lakes[node].scc = newSccIndex;
    } while (node != lake);

    sort(newScc.nodes.begin(), newScc.nodes.end());

    for (u_int i = conns.size(); i > 0; i--) {
      if (find(newScc.nodes.begin(), newScc.nodes.end(), conns[i - 1].second) !=
          newScc.nodes.end()) {
        newScc.children.push_back(conns[i - 1].first);
        components[conns[i - 1].first].parents.push_back(newSccIndex);
        conns.erase(conns.begin() + i - 1);
      }
    }

    components.push_back(newScc);
  }
}

void
topoSort(vector<SCC>& components, const int source, vector<int>& sorting)
{
  stack<int> comStack;
  bool visited[components.size()];

  for (int i = 0; i < components.size(); i++) {
    visited[i] = false;
  }

  topoSortHelper(source, components, visited, comStack);

  while (!comStack.empty()) {
    sorting.push_back(comStack.top());
    comStack.pop();
  }
}

void
topoSortHelper(const int comp,
               vector<SCC>& components,
               bool* visited,
               stack<int>& comStack)
{
  visited[comp] = true;

  for (const int child : components[comp].children) {
    if (visited[child]) continue;

    topoSortHelper(child, components, visited, comStack);
  }

  comStack.push(comp);
}

u_int
longestPath(const int end, vector<SCC>& components, vector<int>& sorting)
{
  vector<u_int> maxDist(components.size(), 0);
  bool firstJump = true;

  for (const int comp : sorting) {

    u_int longestPath = 0;

    for (const int parent : components[comp].parents) {
      if (maxDist[parent] == 0) continue;

      if (comp == end && parent == sorting[0] && firstJump) {
        firstJump = false;
        continue;
      }

      longestPath = max(longestPath, maxDist[parent]);
    }

    maxDist[comp] = longestPath + components[comp].nodes.size();
  }

  return maxDist[end];
}