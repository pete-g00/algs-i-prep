import 'package:collection/collection.dart';

abstract class _Node implements Comparable<_Node> {
  int get frequency;

  @override
  int compareTo(_Node other) {
    return frequency.compareTo(other.frequency);
  }

  void addCode(bool isLeftChild);
}

class _CharNode extends _Node {
  String code;
  
  @override
  int frequency;

  _CharNode():code='', frequency=1;
  
  @override
  void addCode(bool isLeftChild) {
    if (isLeftChild) {
      code = '0' + code;
    } else {
      code = '1' + code;
    }
  }

  @override
  String toString() {
    return code;
  }
}

class _NonCharNode extends _Node {
  _Node left;
  _Node right;

  @override
  int frequency;


  _NonCharNode(this.left, this.right):frequency=left.frequency+right.frequency;

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
  // the map that takes a character code to its node
  final charMap = <int, _CharNode>{};

  // for each character in text,
  for (final code in text.codeUnits) {
    // if the map contains the corresponding node, increase its frequency
    if (charMap.containsKey(code)) {
      charMap[code].frequency++;
    }
    // otherwise, create a node for it (frequency defaults to 1)
    else {
      charMap[code] = _CharNode();
    }
  }

  // construct the minheap with all the character nodes
  final heap = PriorityQueue<_Node>();
  heap.addAll(charMap.values);

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
  }
  
  // // Compute the weighted path length
  // var wpl = 0;
  // charMap.forEach((key, value){
  //   wpl += value.frequency*value.code.length;
  // });
  // print(wpl);

  // the bitstring corresponding to the compressed file
  final compressed = StringBuffer();

  // for each character in the text,
  for (final code in text.codeUnits) {
    // write the corresponding code into the compressed file
    compressed.write(charMap[code].code);
  }

  // return the compressed file
  return compressed.toString();
}

void main(List<String> args) {
  final text = ' '*15 + 'e'*11 + 'a'*9 + 't'*8 + 'i'*7 + 's'*7 + 'r'*7 + 'o'*6 + 'n'*4 + 'u'*3 + 'h'*2 + 'cd';
  print(huffmanCompression(text));
}
