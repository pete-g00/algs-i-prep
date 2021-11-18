class WeightedNode {
  int index;
  int weight;

  WeightedNode(this.index, this.weight);
}

class WeightedVertex {
  int index;
  List<WeightedNode> adjList;
  int pred;

  WeightedVertex(this.index):adjList=[];

  void add(int index, int weight) {
    adjList.add(WeightedNode(index, weight));
  }  

  int get vertexDegree => adjList.length;

  @override
  String toString() {
    return 'v${index.toString()}';
  }
}

class Edge {
  int fromIndex;
  int toIndex;
  int weight;

  Edge(this.fromIndex, this.toIndex, this.weight);

  @override
  String toString() {
    return '(v$fromIndex -> v$toIndex {$weight})';
  }
}

class WeightedGraph {
  bool isDirected;
  List<WeightedVertex> vertices;
  
  WeightedGraph(int n, [this.isDirected=false]):vertices=List.generate(n, (index) => WeightedVertex(index));

  void addEdge(int i, int j, int weight) {
    vertices[i].add(j, weight);
    if (!isDirected) {
      vertices[j].add(i, weight);
    }
  }

  WeightedVertex _minVertex(Set<WeightedVertex> vertexSet){
    // the smallest node
    WeightedNode minNode;

    // for every vertex that a vertex in the set is connected to,
    for (final vertex1 in vertexSet) {
      for (var i=0; i<vertex1.adjList.length; i++) {
        // if the vertexSet doesn't have this vector and its distance is smallest, it is the smallest node
        if (!vertexSet.contains(vertices[vertex1.adjList[i].index]) && (minNode == null || vertex1.adjList[i].weight < minNode.weight)) {
          minNode = vertex1.adjList[i];
        }
      }
    }
    
    // return the vertex
    return vertices[minNode.index];
  }

  /// Given a vertex, finds the optimal weight distance from the given vertex to all the other vertices.
  /// 
  /// Returns a list, where the element in index i is the distance from the given vertex to the vertex with index i.
  List<int> dijkstra(WeightedVertex vertex1) {
    print('Applying the Dijkstra algorithm to find the minimum distance of vertices from $vertex1');
    // the set of vertices that have the optimal distance
    final vertexSet = {vertex1};
    // the weight from the given vertex to all the vertices
    final weights = List<int>.filled(vertices.length, null);

    print('Initialising the weights:');
    // initialise the weight of the vertex with itself and all its adjacent nodes
    weights[vertex1.index] = 0;
    for (final vertex2 in vertex1.adjList) {
      print('\tThe weight for the vertex v${vertex2.index} is ${vertex2.weight}');
      weights[vertex2.index] = vertex2.weight;
    }
    print('\tOther weights are null');
    
    // until we know the optimal distance for every vertex,
    while (vertexSet.length != vertices.length) {
      print('-'*100);
      // find the vertex not in vertexSet that is connected to a vertex in vertexSet with minimal weight and add it to the vertexSet
      final minVertex = _minVertex(vertexSet);
      vertexSet.add(minVertex);
      print('The vertex with the smallest weight is $minVertex, with weight ${weights[minVertex.index]}');
      print('Improving the weight of the other vertices:');
      // try to improve the weight of all the vertices connected to this vertex and not in vertexSet
      for (var i=0; i<minVertex.adjList.length; i++) {
        if (!vertexSet.contains(vertices[minVertex.adjList[i].index])) {
          if (weights[minVertex.adjList[i].index] == null || weights[minVertex.adjList[i].index] > weights[minVertex.index] + minVertex.adjList[i].weight) {
            print('\tThe optimal weight for the vertex v${minVertex.adjList[i].index} was ${weights[minVertex.adjList[i].index]}; it is now ${weights[minVertex.index] + minVertex.adjList[i].weight}');
            weights[minVertex.adjList[i].index] = weights[minVertex.index] + minVertex.adjList[i].weight;
          }
        }
      }
    }

    print('-'*100);
    print('The iteration is now over -> we have the following weights: $weights');
    return weights;
  }

  /// Finds the minimum spanning tree for the weighted graph using the Prim-Jarink algorithm.
  /// 
  /// Returns the list of edges in the minimum spanning tree.
  List<Edge> primJarnik() {
    print('Applying the Prim-Jarnik algorithm to the graph.');
    // at the start, the only tree vertex is the vertex with index 0
    final treeVertices = [0];
    // every other vertex is a non-tree vertex
    final nonTreeVertices = List.generate(vertices.length-1, (i) => i+1);
    // the edges in the minimum spanning tree
    final edges = <Edge>[];
    
    // the edge with smallest weight connecting a non-tree vertex to a tree vertex
    Edge minEdge;
    // the adjacency list for a given vertex
    List<WeightedNode> adjList;
    
    print('At the start, only v0 is a tree vertex.');
    // until there are no non-tree vertices,
    while (nonTreeVertices.isNotEmpty) {
      // find the edge with smallest weight connecting a non-tree vertex to a tree vertex
      for (var i=0; i<treeVertices.length; i++) {
        adjList = vertices[treeVertices[i]].adjList;
        for (var j=0; j<adjList.length; j++) {
          if (nonTreeVertices.contains(adjList[j].index) && (minEdge == null || adjList[j].weight < minEdge.weight)) {
            minEdge = Edge(treeVertices[i], adjList[j].index, adjList[j].weight);
          }
        }
      }
      print('In this iteration, we make the vertex v${minEdge.toIndex} a tree vertex. It is connected to the tree vertex v${minEdge.fromIndex} and has the smallest weight, namely ${minEdge.weight}');
      
      // make the new vertex a tree vertex and add the edge to the minimum spanning tree edges
      nonTreeVertices.remove(minEdge.toIndex);
      treeVertices.add(minEdge.toIndex);
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
    // at the start, the only tree vertex is the vertex with index 0
    final treeVertices = [0];
    print('At the start, only v0 is a tree vertex.');
    // every other vertex is a non-tree vertex
    final nonTreeVertices = List.generate(vertices.length-1, (i) => i+1);

    // the best edge for a non-tree vertex to a tree vertex
    final bestTreeVertex = <int, Edge>{};
    print('Initialising the best tree vertex for non-tree vertices:');
    // initialise the best tree vertex map
    for (var i=0; i<vertices[0].adjList.length; i++) {
      print('\tThe edge with the smallest weight with respect to the non-tree vertex v${vertices[0].adjList[i].index} is the one to v0, with weight ${vertices[0].adjList[i].weight}');
      bestTreeVertex[vertices[0].adjList[i].index] = Edge(0, vertices[0].adjList[i].index, vertices[0].adjList[i].weight);
    }
    print('\tThe other non-tree vertices do not have a best-tree vertex.');
    for (var i=1; i<vertices.length; i++) {
      bestTreeVertex.putIfAbsent(i, () => null);
    }

    // the edges in the minimum spanning tree
    final edges = <Edge>[];
    // the edge with smallest weight connecting a non-tree vertex to a tree vertex
    Edge minEdge;
    // the key node within the relevant adjacency list
    WeightedNode key;

    while (nonTreeVertices.isNotEmpty) {
      print('-'*100);
      // find the edge with smallest weight connecting a non-tree vertex to a tree vertex by going through the bestTreeVertex map
      for (var i=0; i<nonTreeVertices.length; i++) {
        if (bestTreeVertex[nonTreeVertices[i]] != null && (minEdge == null || bestTreeVertex[nonTreeVertices[i]].weight < minEdge.weight)) {
          minEdge = bestTreeVertex[nonTreeVertices[i]];
        }
      }
      print('In this iteration, we make the vertex v${minEdge.toIndex} a tree vertex. Its best tree vertex is v${minEdge.fromIndex} and the edge has weight ${minEdge.weight}');
      
      // make the new vertex a tree vertex and add the edge to the minimum spanning tree edges
      nonTreeVertices.remove(minEdge.toIndex);
      treeVertices.add(minEdge.toIndex);
      edges.add(minEdge);
      // remove it from the best tree vertex -> it is no longer a non-tree vertex
      bestTreeVertex.remove(minEdge.toIndex);

      print('Updating the best tree vertices for the non-tree vertices:');
      // change the bestTreeVertex for every non-tree vertex using this new tree vertex if possible
      for (var i = 0; i < vertices[minEdge.toIndex].adjList.length; i++) {
        key = vertices[minEdge.toIndex].adjList[i];
        if (bestTreeVertex.containsKey(key.index) && (bestTreeVertex[key.index] == null || key.weight < bestTreeVertex[key.index].weight)) {
          print('\tThe edge with the smallest weight with respect to the non-tree vertex v${key.index} is now the one to v${minEdge.toIndex}, with weight ${key.weight}.');
          if (bestTreeVertex[key.index] == null) {
            print('\t\tPreviously, the vertex had no best tree vertex.');
          } else {
            print('\t\tPreviously, the best tree vertex was v${bestTreeVertex[key.index].fromIndex}, with weight ${bestTreeVertex[key.index].weight}.');
          }
          bestTreeVertex[key.index] = Edge(minEdge.toIndex, key.index, key.weight);
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

  final graph = WeightedGraph(6);
  // graph.addEdge(0, 1, 4);
  // graph.addEdge(0, 2, 5);
  // graph.addEdge(0, 3, 7);
  graph.addEdge(5, 1, 4);
  graph.addEdge(5, 2, 5);
  graph.addEdge(5, 3, 7);

  graph.addEdge(1, 2, 5);
  graph.addEdge(1, 3, 6);

  graph.addEdge(2, 4, 4);
  // graph.addEdge(2, 5, 5);
  graph.addEdge(2, 0, 5);

  graph.addEdge(3, 4, 8);
  // graph.addEdge(3, 5, 6);
  graph.addEdge(3, 0, 6);

  // graph.addEdge(4, 5, 7);
  graph.addEdge(4, 0, 7);

  return graph;
}
void main(List<String> args) {
  final graph = _createGraph();
  graph.dijkstraRefinement();
}
