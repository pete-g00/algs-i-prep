import 'auxiliary.dart';

class WeightedNode {
  int index;
  int weight;

  WeightedNode(this.index, this.weight);
}

class WeightedVertex {
  int index;
  List<WeightedNode> adjList;
  String? label;

  WeightedVertex(this.index):adjList=[];

  void add(int index, int weight) {
    adjList.add(WeightedNode(index, weight));
  }  

  int get vertexDegree => adjList.length;

  @override
  String toString() {
    return label ?? 'v${index.toString()}';
  }
}

class Edge {
  WeightedVertex? from;
  WeightedVertex to;
  int weight;

  Edge(this.from, this.to, this.weight);

  @override
  String toString() {
    return '($from -> $to {$weight})';
  }
}

class WeightedGraph {
  bool isDirected;
  List<WeightedVertex> vertices;
  
  WeightedGraph(int n, [this.isDirected=false]):vertices=List.generate(n, (index) => WeightedVertex(index));

  factory WeightedGraph.fromLabels(List<String> labels, [bool isDirected=false]) {
    final graph = WeightedGraph(labels.length, isDirected);
    for (var i = 0; i < labels.length; i++) {
      graph.vertices[i].label = labels[i];
    }

    return graph;
  }


  void addEdge(int i, int j, int weight) {
    vertices[i].add(j, weight);
    if (!isDirected) {
      vertices[j].add(i, weight);
    }
  }

  int _minVertex(List<int?> weights, List<bool> inS) {
    // the index of the smallest vertex
    int? minVertex;

    // for all the weights, find the vertex[i] not in vertexSet with minimum weight
    for (var i=0; i<weights.length; i++) {
      if (!inS[i] && weights[i] != null && (minVertex == null || weights[i]! < weights[minVertex]!)) {
        minVertex = i;
      }
    }

    return minVertex!;
  }

  /// Given a vertex index [i], finds the optimal weight distance from the given vertex to all the other vertices.
  /// 
  /// Returns a list, where the element in index j is the distance from the given vertex to the vertex with index j.
  List<int> dijkstra(int i) {
    final vertex1 = vertices[i];
    print('Applying the Dijkstra algorithm to find the minimum distance of vertices from $vertex1');
    
    // a list that keeps track of the elements in S
    final inS = List<bool>.filled(vertices.length, false);
    // at the start, the only vertex in S is the vertex with index 0; every other vertex is not in S
    inS[0] = true;
    // the number of elements in S
    var countInS = 1;
    // the weight from the given vertex to all the vertices
    final weights = List<int>.filled(vertices.length, -1);
    // a node connected to a vertex
    WeightedNode node;
    
    print('Initialising the weights:');
    // initialise the weight of the vertex with itself and all its adjacent nodes
    weights[vertex1.index] = 0;
    for (final vertex2 in vertex1.adjList) {
      print('\tThe weight for the vertex ${vertices[vertex2.index]} is ${vertex2.weight}');
      weights[vertex2.index] = vertex2.weight;
    }
    print('\tOther weights are -1');
    print('The optimal list of weights is: $weights');
    
    // until we know the optimal distance for every vertex,
    while (countInS != vertices.length) {
      print('-'*100);
      // find the vertex not in vertexSet that is connected to a vertex in vertexSet with minimal weight and add it to the vertexSet
      final minVertex = _minVertex(weights, inS);
      inS[minVertex] = true;
      countInS++;

      print('The vertex with the smallest weight is ${vertices[minVertex]}, with weight ${weights[minVertex]}');
      print('Improving the weight of the other vertices:');
      // try to improve the weight of all the vertices connected to this vertex and not in vertexSet
      for (var i=0; i<vertices[minVertex].adjList.length; i++) {
        node = vertices[minVertex].adjList[i];
        if (!inS[node.index]) {
          if (weights[node.index] == -1 || weights[node.index] > weights[minVertex] + node.weight) {
            print('\tThe optimal weight for the vertex ${vertices[node.index]} was ${weights[node.index]}; it is now ${weights[minVertex] + node.weight}');
            weights[node.index] = weights[minVertex] + node.weight;
          }
        }
      }
      print('The optimal list of weights is now: $weights');
    }

    print('-'*100);
    print('The iteration is now over. Returning the weights!');
    return weights;
  }

  /// Finds the minimum spanning tree for the weighted graph using the Prim-Jarink algorithm.
  /// 
  /// Returns the list of edges in the minimum spanning tree.
  List<Edge> primJarnik() {
    print('Applying the Prim-Jarnik algorithm to the graph.');
    // a list that keeps track of the tree and non-tree vertices
    final isTreeVertex = List<bool>.filled(vertices.length, false);
    // at the start, the only tree vertex is the vertex with index 0; every other vertex is a non-tree vertex
    isTreeVertex[0] = true;
    // the number of tree vertices
    var countTreeVertices = 1;
    // the edges in the minimum spanning tree
    final edges = <Edge>[];
    
    // the edge with smallest weight connecting a non-tree vertex to a tree vertex
    Edge? minEdge;
    // the adjacency list for a given vertex
    List<WeightedNode> adjList;
    
    print('At the start, only ${vertices[0]} is a tree vertex.');
    // until every vertex is a tree vertex,
    while (countTreeVertices != vertices.length) {
      // find the edge with smallest weight connecting a non-tree vertex to a tree vertex
      for (var i=0; i<vertices.length; i++) {
        if (isTreeVertex[i]) {
          adjList = vertices[i].adjList;
          for (var j=0; j<adjList.length; j++) {
            if (!isTreeVertex[adjList[j].index] && (minEdge == null || adjList[j].weight < minEdge.weight)) {
              minEdge = Edge(vertices[i], vertices[adjList[j].index], adjList[j].weight);
            }
          }
        }
      }
      print('In this iteration, we make the vertex ${minEdge!.to} a tree vertex. It is connected to the tree vertex ${minEdge.from} and has the smallest weight, namely ${minEdge.weight}');
      
      // make the new vertex a tree vertex and add the edge to the minimum spanning tree edges
      isTreeVertex[minEdge.to.index] = true;
      countTreeVertices ++;
      edges.add(minEdge);
      minEdge = null;
    }
    
    print('We have now found the minimum spanning tree!');
    print('The following are the edges in the minimum spanning tree: $edges');
    var totalWeight = edges.fold<int>(0, (previousValue, element) => previousValue + element.weight);
    print('The total weight of the edges is $totalWeight.');

    return edges;
  }

  /// Finds the minimum spanning tree for the weighted graph using Dijkstra's Refinement.
  /// 
  /// Returns the list of edges in the minimum spanning tree.
  List<Edge> dijkstraRefinement() {
    print('Applying the Dijkstra\'s Refinement algorithm to the graph.');
    // a list that keeps track of the tree and non-tree vertices
    final isTreeVertex = List<bool>.filled(vertices.length, false);
    // at the start, the only tree vertex is the vertex with index 0; every other vertex is a non-tree vertex
    isTreeVertex[0] = true;
    // the number of tree vertices
    var countTreeVertices = 1;
    print('At the start, only ${vertices[0]} is a tree vertex.');

    // the best edge for a non-tree vertex to a tree vertex
    final bestTreeVertex = List<Edge?>.filled(vertices.length, null);
    print('Initialising the best tree vertex for non-tree vertices:');
    // initialise the best tree vertex map
    for (var i=0; i<vertices[0].adjList.length; i++) {
      print('\tThe edge with the smallest weight with respect to the non-tree vertex ${vertices[vertices[0].adjList[i].index]} is the one to ${vertices[0]}, with weight ${vertices[0].adjList[i].weight}');
      bestTreeVertex[vertices[0].adjList[i].index] = Edge(vertices[0], vertices[vertices[0].adjList[i].index], vertices[0].adjList[i].weight);
    }
    print('\tThe other non-tree vertices do not have a best-tree vertex.');

    // the edges in the minimum spanning tree
    final edges = <Edge>[];
    // the edge with smallest weight connecting a non-tree vertex to a tree vertex
    Edge? minEdge;
    // the key node within the relevant adjacency list
    WeightedNode key;

    // until every vertex is a tree vertex,
    while (countTreeVertices != vertices.length) {
      print('-'*100);
      // find the edge with smallest weight connecting a non-tree vertex to a tree vertex by going through the bestTreeVertex map
      for (var i=0; i<vertices.length; i++) {
        if (!isTreeVertex[i] && bestTreeVertex[i] != null && (minEdge == null || bestTreeVertex[i]!.weight < minEdge.weight)) {
          minEdge = bestTreeVertex[i];
        }
      }
      print('In this iteration, we make the vertex ${minEdge!.to} a tree vertex. Its best tree vertex is ${minEdge.from} and the edge has weight ${minEdge.weight}');
      
      // make the new vertex a tree vertex and add the edge to the minimum spanning tree edges
      isTreeVertex[minEdge.to.index] = true;
      countTreeVertices ++;
      edges.add(minEdge);

      print('Updating the best tree vertices for the non-tree vertices:');
      // change the bestTreeVertex for every non-tree vertex using this new tree vertex if possible
      for (var i = 0; i < vertices[minEdge.to.index].adjList.length; i++) {
        key = vertices[minEdge.to.index].adjList[i];
        if (!isTreeVertex[key.index] && (bestTreeVertex[key.index] == null || key.weight < bestTreeVertex[key.index]!.weight)) {
          print('\tThe edge with the smallest weight with respect to the non-tree vertex ${vertices[key.index]} is now the one to ${minEdge.to}, with weight ${key.weight}.');
          if (bestTreeVertex[key.index] == null) {
            print('\t\tPreviously, the vertex had no best tree vertex.');
          } else {
            print('\t\tPreviously, the best tree vertex was ${vertices[bestTreeVertex[key.index]!.from!.index]}, with weight ${bestTreeVertex[key.index]!.weight}.');
          }
          bestTreeVertex[key.index] = Edge(minEdge.to, vertices[key.index], key.weight);
        }
      }
      minEdge = null;
    }
    
    print('-'*100);
    print('We have now found the minimum spanning tree!');
    print('The following are the edges in the minimum spanning tree: $edges');
    var totalWeight = edges.fold<int>(0, (previousValue, element) => previousValue + element.weight);
    print('The total weight of the edges is $totalWeight.');

    return edges;
  }

  
  void toLatexString() {
    final vertices = StringBuffer();
    final edges = StringBuffer();
    List<WeightedNode> adjList;

    for (var i = 0; i < this.vertices.length; i++) {
      vertices.write(writeVertex(this.vertices[i].toString()));
      vertices.write('\n');
      adjList = this.vertices[i].adjList;
      for (var j = 0; j < adjList.length; j++) {
        edges.write(writeEdge(this.vertices[i].toString(), this.vertices[adjList[j].index].toString(), isDirected, adjList[j].weight));
        edges.write('\n');
      }
    }
    print(vertices);
    print(edges);
  }
}

WeightedGraph _createGraph() {
  // final graph = WeightedGraph(6, true);
  // graph.addEdge(0, 1, 2);
  // graph.addEdge(0, 2, 8);
  
  // graph.addEdge(1, 2, 3);
  // graph.addEdge(1, 3, 4);
  // graph.addEdge(1, 4, 9);
  
  // graph.addEdge(2, 4, 7);
  // graph.addEdge(2, 3, 2);
  
  // graph.addEdge(3, 4, 1);
  // graph.addEdge(3, 5, 6);
  
  // graph.addEdge(4, 5, 4);
  
  // final graph = WeightedGraph(6);
  // graph.addEdge(0, 1, 8);
  // graph.addEdge(0, 2, 2);
  // graph.addEdge(0, 3, 4);

  // graph.addEdge(1, 2, 7);
  // graph.addEdge(1, 4, 2);

  // graph.addEdge(2, 3, 1);
  // graph.addEdge(2, 4, 3);
  // graph.addEdge(2, 5, 9);

  // graph.addEdge(3, 5, 5);

  // final graph = WeightedGraph(6);
  // // graph.addEdge(0, 1, 4);
  // // graph.addEdge(0, 2, 5);
  // // graph.addEdge(0, 3, 7);
  // graph.addEdge(5, 1, 4);
  // graph.addEdge(5, 2, 5);
  // graph.addEdge(5, 3, 7);

  // graph.addEdge(1, 2, 5);
  // graph.addEdge(1, 3, 6);

  // graph.addEdge(2, 4, 4);
  // // graph.addEdge(2, 5, 5);
  // graph.addEdge(2, 0, 5);

  // graph.addEdge(3, 4, 8);
  // // graph.addEdge(3, 5, 6);
  // graph.addEdge(3, 0, 6);

  // // graph.addEdge(4, 5, 7);
  // graph.addEdge(4, 0, 7);

  final graph = WeightedGraph.fromLabels(['u', 'v', 'w', 'x', 'y', 'z']);

  graph.addEdge(0,1,5);
  graph.addEdge(0,2,10);
  graph.addEdge(0,5,8);
  graph.addEdge(1,2,3);
  graph.addEdge(1,4,9);
  graph.addEdge(1,5,2);
  graph.addEdge(2,3,6);
  graph.addEdge(2,4,8);
  graph.addEdge(2,5,8);
  graph.addEdge(3,4,1);
  graph.addEdge(3,5,10);
  graph.addEdge(4,5,5);

  return graph;
}
void main(List<String> args) {
  final graph = _createGraph();
  graph.dijkstra(0);
  // graph.toLatexString();
}
