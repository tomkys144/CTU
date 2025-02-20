#include <algorithm>
#include <iostream>
#include <queue>
#include <set>
#include <stack>
#include <vector>

using namespace std;

u_int nodeIDx = 0;

struct Node
{
  u_int idx;
  vector<Node*> children;
  int scc;

  Node()
  {
    this->idx = nodeIDx++;
    this->scc = -1;
  }
};

struct SCC
{
  vector<int> nodes;
  vector<int> children;
  vector<int> parents;
  set<int> visitedBy;
  int root;
};

int
input(Node nodes[], int starts[], int M, int A);

set<int>
findMeetingPoints(Node nodes[], vector<SCC>& sccs, int starts[], int A);

void
findScc(Node nodes[], vector<SCC>& sccs, int N);

void
topoSort(vector<SCC>& components, int source, vector<int>& sorting);

int
findLength(const vector<SCC>& sccs,
           const set<int>& meetingPoints,
           int end);

int
main()
{
  u_int N, M, A, P;

  int r = scanf("%i %i %i %i", &N, &M, &A, &P);

  if (r != 4)
    return EXIT_FAILURE;
  P--;

  Node nodes[N];
  int starts[A];

  r = input(nodes, starts, M, A);
  if (r == EXIT_FAILURE)
    return EXIT_FAILURE;

  vector<SCC> sccs;
  findScc(nodes, sccs, N);

  set<int> meetingPoints = findMeetingPoints(nodes, sccs, starts, A);

  if (meetingPoints.empty())
    return EXIT_FAILURE;

  int len = findLength(sccs, meetingPoints, nodes[P].scc);

  if (len < 1)
    return EXIT_FAILURE;

  printf("%d\n", len);

  return EXIT_SUCCESS;
}

int
input(Node nodes[], int starts[], int M, int A)
{
  int s;
  for (int i = 0; i < A; i++) {
    if (scanf("%i", &s) != 1)
      return EXIT_FAILURE;
    starts[i] = s - 1;
  }

  int S, T;
  for (int i = 0; i < M; i++) {
    int res = scanf("%i %i", &S, &T);

    if (res != 2)
      return EXIT_FAILURE;

    nodes[S - 1].children.push_back(&nodes[T - 1]);
  }

  return EXIT_SUCCESS;
}

set<int>
findMeetingPoints(Node nodes[],
                  vector<SCC>& sccs,
                  int starts[],
                  const int A)
{
  queue<pair<int, int> > q;
  set<int> res = {};
  for (int i = 0; i < A; i++)
    q.emplace(nodes[starts[i]].scc, i);

  while (!q.empty()) {
    auto currPoint = q.front();
    q.pop();
    auto r = sccs[currPoint.first].visitedBy.emplace(currPoint.second);

    if (sccs[currPoint.first].visitedBy.size() == A)
      res.emplace(currPoint.first);

    if (r.second)
      for (int i = 0; i < sccs[currPoint.first].children.size(); i++) {
        q.emplace(sccs[currPoint.first].children[i],
                  currPoint.second);
      }
  }

  return res;
}

void
findSccHelper(const int node,
              Node nodes[],
              vector<SCC>& sccs,
              const int N,
              int* low,
              int* dist,
              bool* inStack,
              stack<int>& s)
{
  static int currDist = 0;
  static vector<pair<int, int> > conns;

  low[node] = dist[node] = ++currDist;
  s.push(node);
  inStack[node] = true;

  for (const Node* child : nodes[node].children) {
    int childIdx = child->idx;

    if (low[childIdx] == -1) {
      findSccHelper(childIdx, nodes, sccs, N, low, dist, inStack, s);
      low[node] = min(low[node], low[childIdx]);
    } else if (inStack[childIdx]) {
      low[node] = min(low[node], dist[childIdx]);
    }

    if (!inStack[childIdx]) {
      int neighbor = nodes[childIdx].scc;
      conns.emplace_back(neighbor, node);
    }
  }

  if (low[node] == dist[node]) {
    SCC newSCC;
    int newSCCIdx = static_cast<int>(sccs.size());

    newSCC.root = node;

    int site;
    do {
      site = s.top();
      s.pop();

      inStack[site] = false;

      newSCC.nodes.push_back(site);

      nodes[site].scc = newSCCIdx;
    } while (site != node);

    sort(newSCC.nodes.begin(), newSCC.nodes.end());

    for (u_int i = conns.size(); i > 0; i--) {
      if (find(newSCC.nodes.begin(),
               newSCC.nodes.end(),
               conns[i - 1].second) !=
          newSCC.nodes.end()) {
        newSCC.children.push_back(conns[i - 1].first);
        sccs[conns[i - 1].first].parents.push_back(newSCCIdx);
        conns.erase(conns.begin() + i - 1);
      }
    }

    sccs.push_back(newSCC);
  }
}

void
findScc(Node nodes[], vector<SCC>& sccs, const int N)
{
  int low[N];
  int dist[N];
  bool inStack[N];
  stack<int> s;

  for (int i = 0; i < N; i++) {
    low[i] = dist[i] = -1;
    inStack[i] = false;
  }

  for (int i = 0; i < N; i++) {
    if (dist[i] == -1)
      findSccHelper(i, nodes, sccs, N, low, dist, inStack, s);
  }
}

void
topoSortHelper(const int comp,
               const vector<SCC>& components,
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

void
topoSort(const vector<SCC>& components,
         const int source,
         vector<int>& sorting)
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

u_int
findLengthHelper(const vector<SCC>& sccs,
                 const int start,
                 const int end,
                 const vector<int>& sorting)
{
  if (start == end)
    return sccs[start].nodes.size();

  vector<u_int> maxDist(sccs.size(), 0);

  for (const int comp : sorting) {
    u_int longestPath = 0;

    for (const int parent : sccs[comp].parents) {
      if (maxDist[parent] == 0)
        continue;

      longestPath = max(longestPath, maxDist[parent]);
    }

    maxDist[comp] = longestPath + sccs[comp].nodes.size();
  }

  return maxDist[end];
}

int
findLength(const vector<SCC>& sccs,
           const set<int>& meetingPoints,
           const int end)
{
  int res = 0;

  for (const int start : meetingPoints) {
    vector<int> sorting;

    topoSort(sccs, start, sorting);

    int len = findLengthHelper(sccs, start, end, sorting);

    if (len > res)
      res = len;
  }

  return res;
}