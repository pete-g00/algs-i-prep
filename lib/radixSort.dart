import 'dart:math';

Iterable<int> radixSort(List<int> list, int m, int b) {
  final numIterations = m~/b;
  final numBuckets = pow(2, b);

  final buckets = List.generate(numBuckets, (i) => <String>[]);
  var binary_list = list.map((value){
    var binary = value.toRadixString(2);
    return '0'*(m-binary.length) + binary;
  });

  for (var i=numIterations; i>=1; i--) {
    for (var j=0; j<numBuckets; j++) {
      buckets[j].clear();
    }

    for (final binary in binary_list) {
      var j = int.parse(binary.substring(b*(i-1), b*i), radix: 2);
      buckets[j].add(binary);
    }

    binary_list = buckets.reduce((value, element) => value + element);
  }
  return binary_list.map((binary) => int.parse(binary, radix: 2));
}

void main(List<String> args) {
  final list = [15, 43, 5, 27, 60, 18, 26, 2];
  radixSort(list, 6, 2);
}