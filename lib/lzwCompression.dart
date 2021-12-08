import 'dart:math';

class _Node {
  int value;
  _Node firstChild;
  _Node sibling;
  int code;

  _Node(this.value, this.code);

  _Node findChild(int letter) {
    // the current child of the node
    var current = firstChild;
    // the previous child of the node (needed when the current node is null)
    _Node prev;
    
    // until there are no siblings to check,
    while (current != null) {
      // if we are past the character wrt lexicographic order, the node doesn't exist and should go between current.previousSibling = prev and current
      if (current.value > letter) {
        return prev;
      }
      // if the characters match, return the matching node
      else if (current.value == letter) {
        return current;
      } 
      // otherwise, move to the next node
      else {
        prev = current;
        current = current.sibling;
      }
    }
    
    // we past the last sibling -> return the last node
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
  print('Compressing the text \'$text\' using LZW compression.');
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
    print('We are looking at the text from index $i');
    // try to find the closest child to text[i]
    child = current.findChild(text.codeUnitAt(i));
    
    // if the parent node is root, then go to the next character (even if the child node isn't present)
    if (current == trie.root || (child != null && child.value == text.codeUnitAt(i))) {
      print('The current node has a child with letter ${text[i]}. Move onto the next character and descend the trie.');
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
      print('The current child doesn\'t have a child with letter ${text[i]}. Move back to the root node and start back from this character.');
      // create a node for this character
      temp = _Node(text.codeUnitAt(i), trieSize);
      print('Created a node for the letter ${text[i]} and code $trieSize');
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
      print('Written ${'0'*(codewordLength - code.length) + code} to the compressed file');
      
      // increase the size of the trie and (if necessary) the codeword length
      trieSize++;
      print('Incrmented the trie size: it now has $trieSize elements!');
      if (trieSize > pow(2, codewordLength)) {
        codewordLength++;
        print('Incrmented the codeword length: it is now $codewordLength.');
      }

      // go back to the root
      current = trie.root;
      print('-'*100);
    }
  }
  // the final code is yet to be added
  code = current.code.toRadixString(2);
  compressed.write('0'*(codewordLength - code.length));
  compressed.write(code);
  print('Written ${'0'*(codewordLength - code.length) + code} to the compressed file');
  print('-'*100);

  // print('0'*(codewordLength - code.length) + code);
  print('The text is now compressed: $compressed');

  // return the compressed file
  return compressed.toString();
}

void main(List<String> args) {
  final str = 'ab'*50;
  final cfile = lzwCompression(str);
  print(cfile.length);
}
