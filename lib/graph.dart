import 'dart:collection';

class Vertex {
  int index;
  Set<int> adjList;
  bool _visited;
  int pred;

  Vertex(this.index):adjList={}, _visited=false;

  void add(int j) {
    adjList.add(j);
  }  

  int get vertexDegree => adjList.length;

  @override
  String toString() {
    return 'v${index.toString()}';
  }
}

class Graph {
  List<Vertex> vertices;

  Graph(int n):vertices=List.generate(n, (index) => Vertex(index));

  int get size => vertices.length;

  void addEdge(int i, int j, [bool undirected=true]) {
    vertices[i].add(j);
    if (undirected) {
      vertices[j].add(i);
    }
  }

  void _dfsVisit(Vertex vertex, int j) {
    vertex._visited = true;
    vertex.pred = j;
    
    for (final vertexIndex in vertex.adjList) {
      if (!vertices[vertexIndex]._visited) {
        // print(vertexIndex);
        _dfsVisit(vertices[vertexIndex], vertex.index);
      }
    }
  }

  void dfs() {
    for (final vertex in vertices) {
      vertex._visited = false;
    }

    for (final vertex in vertices) {
      if (!vertex._visited) {
        // print(vertex.index);
        _dfsVisit(vertex, -1);
        // print('');
      }
    }
  }

  void _bfsVisit(Queue<Vertex> queue) {
    while (queue.isNotEmpty) {
      final vertex = queue.removeFirst();
      vertex._visited = true;

      for (final vertexIndex in vertex.adjList) {
        if (!vertices[vertexIndex]._visited) {
          // print(vertexIndex);
          queue.addLast(vertices[vertexIndex]);
        }
      }
      // print(queue);
    }
  }

  void bfs() {
    for (final vertex in vertices) {
      vertex._visited = false;
    }

    final queue = Queue<Vertex>();
    for (final vertex in vertices) {
      if (!vertex._visited) {
        queue.addLast(vertex);
        // print(vertex.index);
        _bfsVisit(queue);
        // print('');
      }
    }
  }
}

Graph _createGraph() {
  final graph = Graph(14);
  graph.addEdge(0, 1);
  graph.addEdge(0, 2);
  graph.addEdge(0, 3);
  graph.addEdge(1, 4);
  graph.addEdge(1, 5);
  graph.addEdge(1, 6);
  graph.addEdge(3, 7);
  graph.addEdge(4, 8);
  graph.addEdge(6, 9);

  graph.addEdge(10, 11);
  graph.addEdge(10, 12);
  graph.addEdge(12, 13);
  return graph;
}

void main(List<String> args) {
  final graph = _createGraph();
  graph.bfs();
}