import 'dart:math';

List<int> radixSort(List<int> list, int m, int b) {
  final numIterations = m~/b;
  final numBuckets = pow(2, b);

  final buckets = List.generate(numBuckets, (i) => <int>[]);
  var list_copy = list;

  for (var i=numIterations; i>=1; i--) {
    for (var j=0; j<numBuckets; j++) {
      buckets[j].clear();
    }

    for (var k=0; k<list_copy.length; k++) {
      var binary = list_copy[k].toRadixString(2);
      binary = '0'*(m-binary.length) + binary;
      var j = int.parse(binary.substring(b*(i-1), b*i), radix: 2);
      buckets[j].add(list_copy[k]);
    }

    list_copy = buckets.reduce((value, element) => value + element);
  }
  return list_copy;
}

void main(List<String> args) {
  final list = [15, 43, 5, 27, 60, 18, 26, 2];
  radixSort(list, 6, 2);
}