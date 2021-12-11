import 'package:collection/collection.dart';
import 'auxiliary.dart';

abstract class _Node implements Comparable<_Node> {
  int get frequency;
  List<int> get values;

  @override
  int compareTo(_Node other) {
    return frequency.compareTo(other.frequency);
  }

  void addCode(bool isLeftChild);

  @override
  String toString() {
    return '(frequency: $frequency, value(s): ${String.fromCharCodes(values)})';
  }
}

class _CharNode extends _Node {
  String code;
  
  @override
  int frequency;
  @override
  List<int> values;

  _CharNode(int value):code='', frequency=1, values=[value];
  
  @override
  void addCode(bool isLeftChild) {
    if (isLeftChild) {
      code = '0' + code;
    } else {
      code = '1' + code;
    }
  }
}

class _NonCharNode extends _Node {
  _Node left;
  _Node right;

  @override
  int frequency;
  @override
  List<int> values;

  _NonCharNode(this.left, this.right):frequency=left.frequency+right.frequency, values=left.values + right.values;

  @override
  void addCode(bool isLeftChild) {
    left.addCode(isLeftChild);
    right.addCode(isLeftChild);
  }
}

/// Give a text, produces the bit string corresponds to the Huffman compression for the text
/// 
/// Does not include the relevant bits to decompress the text
String huffmanCompression(String text) {
  print('Compressing the text "$text" using Huffman compression');
  // the map that takes a character code to its node
  final charMap = <int, _CharNode>{};

  // for each character in text,
  for (final code in text.codeUnits) {
    // if the map contains the corresponding node, increase its frequency
    if (charMap.containsKey(code)) {
      charMap[code]!.frequency++;
    }
    // otherwise, create a node for it (frequency defaults to 1)
    else {
      charMap[code] = _CharNode(code);
    }
  }
  print('Initialised frequency table:');
  printCharMap(charMap);
  print('-'*100);

  // construct the minheap with all the character nodes
  final heap = PriorityQueue<_Node>();
  heap.addAll(charMap.values);
  print('Added all the values to the min-heap');
  
  // the left child of a huffman node
  _Node left;
  // the right child of a huffman node
  _Node right;
  // the parent node
  _Node parent;

  // until the heap has precisely one element, i.e. n-1 iterations
  for (var i=1; i<charMap.length; i++) {
    // remove the left and the right children from the heap
    left = heap.removeFirst();
    right = heap.removeFirst();
    
    // create the parent node
    parent = _NonCharNode(left, right);

    // add the corresponding code to the two children
    left.addCode(true);
    right.addCode(false);

    // add the parent to the heap
    heap.add(parent);
    print('Iteration $i: Removed the left child: $left and the right child: $right, and added the parent: $parent');
  }
  print('-'*100);

  // Compute the weighted path length
  var wpl = 0;
  print('The weighted path length is:');
  charMap.forEach((key, value){
    print('\t ${String.fromCharCodes(value.values)} \t ${value.frequency} * ${value.code.length}');
    wpl += value.frequency*value.code.length;
  });
  print('\t \t = $wpl');

  // the bitstring corresponding to the compressed file
  print('-'*100);
  print('Constructing the compressed file');
  final compressed = StringBuffer();

  // for each character in the text,
  for (final code in text.codeUnits) {
    print('Writing ${String.fromCharCode(code)} as its code: ${charMap[code]!.code}');
    // write the corresponding code into the compressed file
    compressed.write(charMap[code]!.code);
  }

  print('The file is now compressed: $compressed');
  // return the compressed file
  return compressed.toString();
}

void main(List<String> args) {
  final text = 'a simple string to be encoded using a minimal number of bits';
  huffmanCompression(text);
}
