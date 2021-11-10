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
  int value;
  String code;
  
  @override
  int frequency;

  _CharNode(this.value):code='', frequency=1;
  
  @override
  void addCode(bool isLeftChild) {
    if (isLeftChild) {
      code = '0' + code;
    } else {
      code = '1' + code;
    }
  }

  @override
  bool operator ==(covariant _CharNode other) {
    return value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

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

String huffmanCompression(String text) {
  final charMap = <int, _CharNode>{};
  for (final code in text.codeUnits) {
    if (charMap.containsKey(code)) {
      charMap[code].frequency++;
    } else {
      charMap[code] = _CharNode(code);
    }
  }

  final heap = PriorityQueue<_Node>();
  heap.addAll(charMap.values);

  for (var i=1; i<charMap.length; i++) {
    final left = heap.removeFirst();
    final right = heap.removeFirst();

    final parent = _NonCharNode(left, right);
    left.addCode(true);
    right.addCode(false);

    heap.add(parent);
  }
  
  // var wpl = 0;
  // charMap.forEach((key, value){
  //   wpl += value.frequency*value.code.length;
  // });
  // print(wpl);

  final compressed = StringBuffer();
  for (final code in text.codeUnits) {
    compressed.write(charMap[code].code);
  }
  return compressed.toString();
}

void main(List<String> args) {
  final text = ' '*15 + 'e'*11 + 'a'*9 + 't'*8 + 'i'*7 + 's'*7 + 'r'*7 + 'o'*6 + 'n'*4 + 'u'*3 + 'h'*2 + 'cd';
  print(huffmanCompression(text));
}