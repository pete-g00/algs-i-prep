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

// Map<int, int> valueMap = {65:0, 67:1, 71:2, 84:3};

/// Compresses a file with ASCII characters using LZW compression.
String lzwCompression(String text) {
  // the trie
  final trie = _Trie();
  // the size of the trie
  var trieSize = 128;
  // the codeword length
  var codewordLength = 8;

  // the compressed file bitstring
  var compressed = StringBuffer();

  // the current node in the trie
  var current = trie.root;
  // the closest child to current with respect to the next character
  _Node child;
  // a temporary node used to create a new node
  _Node temp;
  // the index of the character in the text
  var i = 0;
  // the code to add to the compressed file
  String code;

  // until we've considered each character,
  while (i < text.length) {
    // try to find the closest child to text[i]
    child = current.findChild(text.codeUnitAt(i));
    
    // if the parent node is root, then go to the next character (even if the child node isn't present)
    if (current == trie.root || (child != null && child.value == text.codeUnitAt(i))) {
      // if there is no child, create a node for the character and attach it as firstChild
      if (child == null) {
        final temp = _Node(text.codeUnitAt(i), text.codeUnitAt(i));
        // final temp = _Node(text.codeUnitAt(i), valueMap[text.codeUnitAt(i)]);
        temp.sibling = current.firstChild;
        current.firstChild = temp;
        current = temp;
      }
      // if there is a mismatch, add it between child and child.sibling
      else if (child.value != text.codeUnitAt(i)) {
        final temp = _Node(text.codeUnitAt(i), text.codeUnitAt(i));
        // final temp = _Node(text.codeUnitAt(i), valueMap[text.codeUnitAt(i)]);
        temp.sibling = child.sibling;
        child.sibling = temp;
        current = temp;
      }
      // otherwise, just take the child node
      else {
        current = child;
      }
      // move to the next character
      i++;
    } 
    // otherwise, 
    else {
      // create a node for this character
      temp = _Node(text.codeUnitAt(i), trieSize);
      // if there is no child, create a node for the character and attach it as firstChild
      if (child == null) {
        temp.sibling = current.firstChild;
        current.firstChild = temp;
      }
      // otherwise, add it between child and child.sibling
      else {
        temp.sibling = child.sibling;
        child.sibling = temp;
      }

      // add to the compressed file the corresponding code (with 0's at the start)
      code = current.code.toRadixString(2);
      compressed.write('0'*(codewordLength - code.length));
      compressed.write(code);
      // print('0'*(codewordLength - code.length) + code);
      
      // increase the size of the trie and (if necessary) the codeword length
      trieSize++;
      if (trieSize > pow(2, codewordLength)) {
        codewordLength++;
      }

      // go back to the root
      current = trie.root;
    }
  }
  // the final code is yet to be added
  code = current.code.toRadixString(2);
  compressed.write('0'*(codewordLength - code.length));
  compressed.write(code);
  // print('0'*(codewordLength - code.length) + code);

  // return the compressed file
  return compressed.toString();
}

void main(List<String> args) {
  print(lzwCompression('GACGATACGATACG'));
}
