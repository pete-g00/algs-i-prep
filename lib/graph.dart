import 'dart:collection';

class Vertex {
  int index;
  List<int> adjList;
  bool _visited;
  int pred;

  Vertex(this.index):adjList=[], _visited=false;

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
  bool isDirected;
  List<Vertex> vertices;

  Graph(int n, [this.isDirected=false]):vertices=List.generate(n, (index) => Vertex(index));

  int get size => vertices.length;

  void addEdge(int i, int j) {
    vertices[i].add(j);
    if (!isDirected) {
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

  List<int> topSort() {
    if (!isDirected) {
      throw StateError('Cannot topologically sort an undirected graph.');
    }

    final count = <int, int>{};
    final sourceQueue = Queue<int>();
    final order = <int>[];
    List<int> adjList;
    
    for (var i=0; i<vertices.length; i++) {
      adjList = vertices[i].adjList;
      for (var j=0; j<adjList.length; j++) {
        count[adjList[j]] = (count[adjList[j]] ?? 0) + 1;
      }
    }
    
    for (var i=0; i<vertices.length; i++) {
      if (!count.containsKey(i)) {
        sourceQueue.addLast(i);
      }
    }

    int i;
    while (sourceQueue.isNotEmpty) {
      i = sourceQueue.removeFirst();
      order.add(i);
      
      for (var j=0; j<vertices[i].adjList.length; j++) {
        count[vertices[i].adjList[j]] --;

        if (count[vertices[i].adjList[j]] == 0) {
          sourceQueue.addLast(vertices[i].adjList[j]);
        }
      }
    }

    if (order.length != vertices.length) {
      throw StateError('Not a directed acyclic graph!');
    }

    return order;
  }
}

Graph _createGraph() {
  // final graph = Graph(14);
  // graph.addEdge(0, 1);
  // graph.addEdge(0, 2);
  // graph.addEdge(0, 3);
  // graph.addEdge(1, 4);
  // graph.addEdge(1, 5);
  // graph.addEdge(1, 6);
  // graph.addEdge(3, 7);
  // graph.addEdge(4, 8);
  // graph.addEdge(6, 9);

  // graph.addEdge(10, 11);
  // graph.addEdge(10, 12);
  // graph.addEdge(12, 13);

  final graph = Graph(9, true);
  graph.addEdge(0, 1);
  graph.addEdge(0, 2);
  
  graph.addEdge(1, 2);
  graph.addEdge(1, 4);
  graph.addEdge(1, 6);
  // graph.addEdge(6, 1);

  graph.addEdge(2, 3);
  
  graph.addEdge(3, 5);

  graph.addEdge(4, 5);
  // graph.addEdge(4, 6);
  graph.addEdge(4, 7);

  graph.addEdge(5, 8);

  graph.addEdge(6, 7);

  graph.addEdge(7, 8);

  return graph;
}

void main(List<String> args) {
  final graph = _createGraph();
  print(graph.topSort());
}