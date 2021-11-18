import 'dart:collection';

class Vertex {
  int index;
  List<int> adjList;
  bool _visited;

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

  void _dfsVisit(Vertex vertex) {
    // this vertex has been visited
    vertex._visited = true;
    
    // visit the vertices this vertex is incident to and has not yet been visited
    for (final vertexIndex in vertex.adjList) {
      if (!vertices[vertexIndex]._visited) {
        print('Visiting the vertex ${vertices[vertexIndex]} through the vertex $vertex');
        _dfsVisit(vertices[vertexIndex]);
      }
    }
  }

  /// Visits all the vertices using depth-first search
  void dfs() {
    // unvisit every vertex
    for (final vertex in vertices) {
      vertex._visited = false;
    }

    print('Visiting all the vertices in the graph using Depth-First Search');
    // visit vertices until they are all visited
    for (final vertex in vertices) {
      if (!vertex._visited) {
        print('Starting this iteration from the vertex $vertex');
        _dfsVisit(vertex);
        print('-'*100);
      }
    }
  }

  void _bfsVisit(Queue<Vertex> queue) {
    // until the queue is empty,
    while (queue.isNotEmpty) {
      // remove the first element from the queue
      final vertex = queue.removeFirst();
      // visit the vertex if it hasn't been visited
      if (!vertex._visited) {
        // this vertex has been visited
        vertex._visited = true;
        print('Visiting the vertex $vertex');

        // visit the vertices this vertex is incident to and has not yet been visited
        for (final vertexIndex in vertex.adjList) {
          if (!vertices[vertexIndex]._visited) {
            // add it to the end of the queue to be visited
            print('Added the ${vertices[vertexIndex]} to the queue');
            queue.addLast(vertices[vertexIndex]);
          }
        }
        print('-'*100);
      }
    }
  }

  /// Visits all the vertices using breadth-first search
  void bfs() {
    // unvisit every vertex
    for (final vertex in vertices) {
      vertex._visited = false;
    }

    print('Visiting all the vertices in the graph using Depth-First Search');
    // visit vertices until they are all visited
    final queue = Queue<Vertex>();
    for (final vertex in vertices) {
      // if the vertex hasn't been visited, add it to the end of the queue and visit the vertex
      if (!vertex._visited) {
        queue.addLast(vertex);
        print('Starting this iteration the vertex $vertex');
        _bfsVisit(queue);
      }
    }
  }

  /// Topologically sort the graph.
  /// 
  /// The graph must be a directed acyclic graph. If it is not, then raises a [StateError].
  /// 
  /// Returns the indices of the vertices, starting from the one labelled 0.
  List<int> topSort() {
    if (!isDirected) {
      throw StateError('Cannot topologically sort an undirected graph.');
    }

    // the in-degree of a vertex with respect to the vertices still unlabelled
    final count = List.filled(vertices.length, 0);
    // the queue containing source vertices with respect to the vertices still unlabelled
    final sourceQueue = Queue<int>();
    // the order of the vertices
    final order = <int>[];
    // the adjacency list of a vertex
    List<int> adjList;

    print('Topologically sorting the graph.');
    
    // initialise the count- compute the in-degree of a vertex
    for (var i=0; i<vertices.length; i++) {
      adjList = vertices[i].adjList;
      for (var j=0; j<adjList.length; j++) {
        count[adjList[j]] = (count[adjList[j]] ?? 0) + 1;
      }
    }
    print('Initialised the count for all indices:');
    print('\t$count');

    // add all the source vertices to the queue
    for (var i=0; i<vertices.length; i++) {
      if (count[i] == 0) {
        print('The vertex v$i is a source vertex.');
        sourceQueue.addLast(i);
      }
    }
    // the index of the removed source vertex
    int i;
    // until the source queue is empty,
    while (sourceQueue.isNotEmpty) {
      print('-'*100);
      // remove a source vertex and label it
      i = sourceQueue.removeFirst();
      print('Labelling vertex v$i with value ${order.length}');
      order.add(i);
      
      // decrement the in-degree of all the vertices that are incident to this vertex
      for (var j=0; j<vertices[i].adjList.length; j++) {
        count[vertices[i].adjList[j]] --;
        
        // if any of them become source vertices, add them to the queue
        if (count[vertices[i].adjList[j]] == 0) {
          print('The vertex v${vertices[i].adjList[j]} is now a source vertex.');
          sourceQueue.addLast(vertices[i].adjList[j]);
        }
      }
      print('The count for the indices is:');
      print('\t$count');
    }

    // the list order has all the vertices if and only if it is a DAG
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
  graph.topSort();
}
