import 'dart:math';

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

  List<int> dijkstra(WeightedVertex vertex1) {
    final vertexSet = {vertex1};
    final weights = List<int>.filled(vertices.length, null);
    weights[vertex1.index] = 0;

    for (final vertex2 in vertex1.adjList) {
      weights[vertex2.index] = vertex2.weight;
    }

    while (vertexSet.length != vertices.length) {
      final minVertex = _minVertex(vertexSet);
      vertexSet.add(minVertex);
      print(minVertex);

      for (var i=0; i<minVertex.adjList.length; i++) {
        print(vertices[minVertex.adjList[i].index]);
        if (!vertexSet.contains(vertices[minVertex.adjList[i].index])) {
          if (weights[minVertex.adjList[i].index] == null || weights[minVertex.adjList[i].index] > weights[minVertex.index] + minVertex.adjList[i].weight) {
            weights[minVertex.adjList[i].index] = weights[minVertex.index] + minVertex.adjList[i].weight;
          }
        }
        print('');
      }
    }

    return weights;
  }

  WeightedVertex _minVertex(Set<WeightedVertex> vertexSet){
    WeightedNode minNode;

    for (final vertex1 in vertexSet) {
      for (var i=0; i<vertex1.adjList.length; i++) {
        if (!vertexSet.contains(vertices[vertex1.adjList[i].index]) && (minNode == null || vertex1.adjList[i].weight < minNode.weight)) {
          minNode = vertex1.adjList[i];
        }
      }
    }
    return vertices[minNode.index];
  }
}

WeightedGraph _createGraph() {
  // final graph = WeightedGraph(6, true);
  final graph = WeightedGraph(6);
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
  
  graph.addEdge(0, 1, 8);
  graph.addEdge(0, 2, 2);
  graph.addEdge(0, 3, 4);

  graph.addEdge(1, 2, 7);
  graph.addEdge(1, 4, 2);

  graph.addEdge(2, 3, 1);
  graph.addEdge(2, 4, 3);
  graph.addEdge(2, 5, 9);

  graph.addEdge(3, 5, 5);
  return graph;
}
void main(List<String> args) {
  final graph = _createGraph();
  print(graph.dijkstra(graph.vertices[0]));  
}