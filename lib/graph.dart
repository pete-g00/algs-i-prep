import 'dart:collection';

import 'package:dart/auxiliary.dart';

class Vertex {
  int index;
  List<int> adjList;
  bool _visited;
  String? label;

  Vertex(this.index):adjList=[], _visited=false;

  void add(int j) {
    adjList.add(j);
  }  

  int get vertexDegree => adjList.length;

  @override
  String toString() {
    return label ?? 'v${index.toString()}';
  }
}

class Edge {
  Vertex? from;
  Vertex to;

  Edge(this.from, this.to);

  @override
  String toString() {
    return '($from -> $to)';
  }
}

class Graph {
  bool isDirected;
  List<Vertex> vertices;

  Graph(int n, [this.isDirected=false]):vertices=List.generate(n, (index) => Vertex(index));

  factory Graph.fromLabels(List<String> labels, [bool isDirected=false]) {
    final graph = Graph(labels.length, isDirected);
    for (var i = 0; i < labels.length; i++) {
      graph.vertices[i].label = labels[i];
    }

    return graph;
  }

  int get size => vertices.length;

  void addEdge(int i, int j) {
    vertices[i].add(j);
    if (!isDirected) {
      vertices[j].add(i);
    }
  }

  void _dfsVisit(Vertex? pred, Vertex next, void Function(Vertex? pred, Vertex next) fn) {
    // this vertex has been visited
    next._visited = true;
    fn(pred, next);
    
    // visit the vertices this vertex is incident to and has not yet been visited
    for (final vertexIndex in next.adjList) {
      if (!vertices[vertexIndex]._visited) {
        print('Visiting the vertex ${vertices[vertexIndex]} through the vertex $next');
        _dfsVisit(next, vertices[vertexIndex], fn);
      }
    }
  }

  /// Visits all the vertices using depth-first search
  void dfs(void Function(Vertex? pred, Vertex next) fn) {
    // unvisit every vertex
    for (final vertex in vertices) {
      vertex._visited = false;
    }

    print('Visiting all the vertices in the graph using Depth-First Search');
    // visit vertices until they are all visited
    for (final vertex in vertices) {
      if (!vertex._visited) {
        print('Starting this iteration from the vertex $vertex');
        _dfsVisit(null, vertex, fn);
        print('-'*100);
      }
    }
  }

  List<Edge> dfsSpanningTree() {
    print('Finding the spanning tree of the graph using DFS.');
    final edges = <Edge>[];
    dfs((pred, next) { 
      if (pred != null) {
        print('\tAdding the edge from $pred to $next');
        edges.add(Edge(pred, next));
      }
    });
    print('Found the tree: it contains the following edges: $edges');
    return edges;
  }

  void _bfsVisit(Queue<Edge> queue, void Function(Vertex? pred, Vertex next) fn) {
    // until the queue is empty,
    while (queue.isNotEmpty) {
      // remove the first element from the queue
      final edge = queue.removeFirst();
      final vertex = vertices[edge.to.index];
      // visit the vertex if it hasn't been visited
      if (!vertex._visited) {
        print('Visiting the vertex $vertex');
        if (edge.from != null) {
        fn(vertices[edge.from!.index], vertices[edge.to.index]);
        } else {
          fn(null, vertices[edge.to.index]);
        }
        
        // this vertex has been visited
        vertex._visited = true;

        // visit the vertices this vertex is incident to and has not yet been visited
        for (final vertexIndex in vertex.adjList) {
          if (!vertices[vertexIndex]._visited) {
            // add it to the end of the queue to be visited
            print('Added the vertex ${vertices[vertexIndex]} to the queue');
            queue.addLast(Edge(vertex, vertices[vertexIndex]));
          }
        }
        print('-'*100);
      }
    }
  }

  /// Visits all the vertices using breadth-first search
  void bfs(void Function(Vertex? pred, Vertex next) fn, [Vertex? start]) {
    // unvisit every vertex
    for (final vertex in vertices) {
      vertex._visited = false;
    }

    print('Visiting all the vertices in the graph using Breadth-First Search');
    // visit vertices until they are all visited
    final queue = Queue<Edge>();
    // if a starting vertex is given, start by visiting that vertex
    if (start != null) {
      queue.addLast(Edge(null, start));
      _bfsVisit(queue, fn);
    }
    for (final vertex in vertices) {
      // if the vertex hasn't been visited, add it to the end of the queue and visit the vertex
      if (!vertex._visited) {
        queue.addLast(Edge(null, vertex));
        print('Starting this iteration the vertex $vertex');
        _bfsVisit(queue, fn);
      }
    }
  }

  List<Edge> bfsSpanningTree() {
    print('Finding the spanning tree of the graph using BFS.');
    final edges = <Edge>[];
    bfs((pred, next) { 
      if (pred != null) {
        print('\tAdding the edge from $pred to $next');
        edges.add(Edge(pred, next));
      }
    });
    print('Found the tree: it contains the following edges: $edges');
    return edges;
  }

  /// Computes the distance from the given [vertex] to all the other vertices
  /// 
  /// Returns a list, where the distance from [vertex] to the vertex i is at index i
  List<int> distance(int i) {
    final vertex = vertices[i];
    print('Finding the distance from $vertex to all the vertices.');
    // initialise the distance list
    final dist = List<int>.filled(vertices.length, 0);
    // visit the vertices using breadth first search
    bfs((pred, next) {
      // if there was no previous edge (i.e. next == vertex) -> distance = 0
      if (pred == null) {
        print('\tThe distance of $next from $vertex is 0!');
        dist[next.index] = 0;
      }
      // otherwise, the distance is previous + 1
      else {
        dist[next.index] = dist[pred.index] + 1;
        print('\tThe distance of $next from $vertex is ${dist[next.index]}, and the closest approach to $vertex is through $pred.');
      }
    }, vertex);
    return dist;
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
    final count = List<int?>.filled(vertices.length, null);
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
        print('The vertex ${vertices[i]} is a source vertex.');
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
      print('Labelling vertex ${vertices[i]} with value ${order.length}');
      order.add(i);
      
      // decrement the in-degree of all the vertices that are incident to this vertex
      for (var j=0; j<vertices[i].adjList.length; j++) {
        count[vertices[i].adjList[j]] = count[vertices[i].adjList[j]]! - 1;
        
        // if any of them become source vertices, add them to the queue
        if (count[vertices[i].adjList[j]] == 0) {
          print('The vertex ${vertices[vertices[i].adjList[j]]} is now a source vertex.');
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

  void toLatexString() {
    final vertices = StringBuffer();
    final edges = StringBuffer();
    List<int> adjList;

    for (var i = 0; i < this.vertices.length; i++) {
      vertices.write(writeVertex(this.vertices[i].toString()));
      vertices.write('\n');
      adjList = this.vertices[i].adjList;
      for (var j = 0; j < adjList.length; j++) {
        edges.write(writeEdge(this.vertices[i].toString(), this.vertices[adjList[j]].toString(), isDirected));
        edges.write('\n');
      }
    }
    print(vertices);
    print(edges);
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

  // final graph = Graph(9, true);
  // graph.addEdge(0, 1);
  // graph.addEdge(0, 2);
  
  // graph.addEdge(1, 2);
  // graph.addEdge(1, 4);
  // graph.addEdge(1, 6);
  // // graph.addEdge(6, 1);

  // graph.addEdge(2, 3);
  
  // graph.addEdge(3, 5);

  // graph.addEdge(4, 5);
  // // graph.addEdge(4, 6);
  // graph.addEdge(4, 7);

  // graph.addEdge(5, 8);

  // graph.addEdge(6, 7);

  // graph.addEdge(7, 8);

  // final graph = Graph(8);
  // graph.addEdge(0, 1);
  
  // graph.addEdge(1, 2);
  // graph.addEdge(1, 4);
  
  // graph.addEdge(2, 3);
  // graph.addEdge(2, 5);

  // graph.addEdge(3, 5);

  // graph.addEdge(4, 5);
  // graph.addEdge(4, 6);

  // graph.addEdge(6, 7);

  // return graph;

  final graph = Graph.fromLabels(['u', 'v', 'w', 'x', 'y', 'z'], true);

  graph.addEdge(0,1);
  graph.addEdge(0,2);
  graph.addEdge(0,5);
  graph.addEdge(1,2);
  graph.addEdge(1,4);
  graph.addEdge(1,5);
  graph.addEdge(2,3);
  graph.addEdge(2,4);
  graph.addEdge(2,5);
  graph.addEdge(3,4);
  graph.addEdge(3,5);
  graph.addEdge(4,5);

  return graph;
}

void main(List<String> args) {
  final graph = _createGraph();
  graph.topSort();
  // graph.toLatexString();
}
