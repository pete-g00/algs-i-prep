import 'dart:math';

class WeightedNode {
  int index;
  int weight;
}

class WeightedVertex {
  int index;
  List<WeightedNode> adjList;
  int pred;

  WeightedVertex(this.index):adjList=[];

  void add(WeightedNode node) {
    adjList.add(node);
  }  

  int get vertexDegree => adjList.length;
}

class WeightedGraph {
  List<WeightedVertex> vertices;
  
  WeightedGraph(int n):vertices=List.generate(n, (index) => WeightedVertex(index));

  // TODO: Complete
  int dijkstra(WeightedVertex vertex1) {
    final vertexSet = {vertex1};
    final weights = List.filled(vertices.length, -1);
    weights[vertex1.index] = 0;

    while (vertexSet.length != vertices.length) {
      final minVertex = _minVertex(vertexSet);
      vertexSet.add(minVertex);

      for (final vertex2 in vertices) {
        if (!vertexSet.contains(vertex2) && vertex1.adjList.map((node) => node.index).contains(vertex2.index)) {
          weights[vertex2.index] = min(weights[vertex2.index], weights[vertex1.index]);
        }
      }
    }
  }

  // TODO: Fix
  WeightedVertex _minVertex(Set<WeightedVertex> vertexSet) => vertexSet.reduce((value, element) => value);
}