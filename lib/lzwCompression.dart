import 'dart:math';

class _Node {
  int value;
  _Node firstChild;
  _Node sibling;
  int code;

  _Node(this.value, this.code);

  _Node findChild(int letter) {
    var current = firstChild;
    _Node prev;
    while (current != null) {
      if (current.value > letter) {
        return prev;
      } else if (current.value == letter) {
        return current;
      } else {
        prev = current;
        current = current.sibling;
      }
    }
    return prev;
  }
}

class _Trie {
  _Node root;

  _Trie():root=_Node(null, null);
}

Map<int, int> valueMap = {65:0, 67:1, 71:2, 84:3};

String lzwCompression(String text) {
  final trie = _Trie();
  var trieSize = 4;
  var codewordLength = 2;

  var compressed = StringBuffer();

  var current = trie.root;

  var i = 0;
  while (i < text.length) {
    var node = current.findChild(text.codeUnitAt(i));
    if (current == trie.root || (node != null && node.value == text.codeUnitAt(i))) {
      if (node == null) {
        // final temp = _Node(text.codeUnitAt(i), text.codeUnitAt(i));
        final temp = _Node(text.codeUnitAt(i), valueMap[text.codeUnitAt(i)]);
        temp.sibling = current.firstChild;
        current.firstChild = temp;
        current = temp;
      } else if (node.value != text.codeUnitAt(i)) {
        // final temp = _Node(text.codeUnitAt(i), text.codeUnitAt(i));
        final temp = _Node(text.codeUnitAt(i), valueMap[text.codeUnitAt(i)]);
        temp.sibling = node.sibling;
        node.sibling = temp;
        current = temp;
      } else {
        current = node;
      }
      i++;
    } else {
      final temp = _Node(text.codeUnitAt(i), trieSize);
      if (node == null) {
        temp.sibling = current.firstChild;
        current.firstChild = temp;
      } else {
        temp.sibling = node.sibling;
        node.sibling = temp;
      }

      var code = current.code.toRadixString(2);
      compressed.write('0'*(codewordLength - code.length));
      compressed.write(code);
      print('0'*(codewordLength - code.length) + code);

      trieSize++;
      if (trieSize > pow(2, codewordLength)) {
        codewordLength++;
      }
      current = trie.root;
    }
  }
  var code = current.code.toRadixString(2);
  compressed.write('0'*(codewordLength - code.length));
  compressed.write(code);
  print('0'*(codewordLength - code.length) + code);

  return compressed.toString();
}

void main(List<String> args) {
  print(lzwCompression('GACGATACGATACG'));
}