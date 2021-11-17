import 'dart:math';

/// Sorts a list of positive integers [list] using radix sort given
/// * the factor [m] of bit length and 
/// * the bucket size [b].
Iterable<int> radixSort(List<int> list, int m, int b) {
  print('Sorting the list $list using radix sort, where m = $m and b = $b');
  // the number of iterations
  final numIterations = m~/b;
  // the number of buckets
  final numBuckets = pow(2, b);

  // initialise the buckets
  final buckets = List.generate(numBuckets, (i) => <String>[]);
  print('Empty buckets initialised!');
  
  // convert the list to binary (string)
  var binaryList = list.map((value){
    var binary = value.toRadixString(2);
    return '0'*(m-binary.length) + binary;
  });
  print('Converted the numbers to binary -> $binaryList');

  // iterate through each m-chunk of binary
  for (var i=numIterations; i>=1; i--) {
    print('-'*100);
    print('Iteration ${numIterations-i+1} of $numIterations');
    print('Looking from indices b*(i-1) = ${b*(i-1)} (inclusive) to b*i = ${b*i} (exclusive)');
    
    // clear the buckets
    for (var j=0; j<numBuckets; j++) {
      buckets[j].clear();
    }

    // for every bitstring, add it to the bucket depending on the relevant substring
    for (final binary in binaryList) {
      var j = int.parse(binary.substring(b*(i-1), b*i), radix: 2);
      print('The number ${int.parse(binary, radix:2)} = $binary goes into bucket $j');
      buckets[j].add(binary);
    }

    // concatenate all the buckets (in order)
    binaryList = buckets.reduce((value, element) => value + element);
    print('At the end of the iteration, the list (in binary) is: $binaryList and (in decimal) is: ${binaryList.map((binary) => int.parse(binary, radix: 2))}');
  }
  
  // return as integers
  final sortedList = binaryList.map((binary) => int.parse(binary, radix: 2));
  print('The list is now sorted!');
  return sortedList;
}

void main(List<String> args) {
  final list = [15, 43, 5, 27, 60, 18, 26, 2];
  radixSort(list, 6, 2);
}
