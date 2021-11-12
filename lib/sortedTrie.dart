class _Node {
  int value;
  bool isWord;
  _Node firstChild;
  _Node nextSibling;
  _Node previousSibling;
  _Node parent;

  _Node(this.value, this.parent):isWord=false;

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
        current = current.nextSibling;
      }
    }
    return prev;
  }

  @override
  String toString() {
    return '(${String.fromCharCode(value)})';
  }
}


/// The class Trie represents a collection of strings that are stored in a tree-like structure.
class Trie {
  final _Node _root;
  
  /// Creates an empty trie
  Trie():_root=_Node(null, null);

  /// Searches a word within the trie.
  /// 
  /// Returns `true` if the word is present, and `false` otherwise.
  bool search(String word) {
    // empty strings aren't present in a trie
    if (word.isEmpty) {
      return false;
    }

    // the current node in the trie
    var current = _root;

    // the closest child of current to the next character
    _Node child;

    // go through each character in the word
    for (final code in word.codeUnits) {
      // try to find the closest child for the given character
      child = current.findChild(code);
      // if it is not a match, return false
      if (child == null || child.value != code) {
        return false;
      }
      // move to the child node
      current = child;
    }

    // the node has to correspond to a word for it to be present
    return child.isWord;
  }

  /// Inserts a word into the trie.
  void insert(String word) {
    // the current node in the trie
    var current = _root;
    
    // the closest child of current to the next character
    _Node child;
    
    // a temporary node used to create new nodes
    _Node temp;

    // go through each character in the word
    for (final code in word.codeUnits) {
      // try to find the closest child for the given character
      child = current.findChild(code);

      // if child is null, create a node for this character and attach it to the parent
      if (child == null) {
        temp = _Node(code, current);
        if (current.firstChild != null) {
          temp.nextSibling = current.firstChild;
          current.firstChild.previousSibling = temp;
        }
        current.firstChild = temp;
        current = temp;
      } 
      // if the characters mismatch, create a node for this character and add it between child and child.nextSibling
      else if (child.value != code) {
        temp = _Node(code, current);
        temp.nextSibling = child.nextSibling;
        temp.previousSibling = child;
        child.nextSibling = temp;
        current = temp;
      }
      // if the characters match, just take that character
      else {
        current = child;
      }
    }
    
    // only the final node corresponds to a node
    current.isWord = true;
  }

  /// Deletes a given character from the trie
  /// 
  /// Returns `true` if the word is present, and `false` otherwise.
  bool delete(String word) {
    // the current node in the trie
    var current = _root;

    // the closest child node corresponding to the next character
    _Node child;

    // go through each character in word
    for (final code in word.codeUnits) {
      // try to find the closest child for the given character
      child = current.findChild(code);
      // if no mismatch, take that character
      if (child != null && child.value == code) {
        current = child;
      }
      // otherwise, this character isn't present in the trie -> nothing to delete
      else {
        return false;
      }
    }

    // if the final node isn't a word, then return false -> make absolutely no change
    if (!current.isWord) {
      return false;
    }

    // current is no longer a word
    current.isWord = false;

    // until we have nodes to remove -> node that has no children and don't correspond to word themselves, remove them
    while (current != _root && current.firstChild == null && !current.isWord) {
      if (current.previousSibling == null) {
        current.parent.firstChild = current.nextSibling;
      } else {
        current.previousSibling.nextSibling = current.nextSibling;
      }
      
      if (current.nextSibling != null) {
        current.nextSibling.previousSibling = current.previousSibling;
      }
		
      // move up one level
      current = current.parent;
    }
  
    return true;
  }

  void _extract(List<String> list, _Node node, String prefix) {
    if (node != null) {
      // create the corresponding word
      final word = prefix + String.fromCharCode(node.value);
      // add it if it is a word
      if (node.isWord) {
        list.add(word);
      }
      
      // extract on child with the extra character
      _extract(list, node.firstChild, word);
      
      // extract on sibling without the extra character
      _extract(list, node.nextSibling, prefix);
    }
  }

  /// Extracts all the words present in the trie.
  List<String> extract() {
    final list = <String>[];
    _extract(list, _root.firstChild, '');
    return list;
  }
}

void main(List<String> args) {
  final trie = Trie();
  trie.insert('word');
  trie.insert('alphabet');
  trie.insert('alpha');
  // print(trie.search('word'));
  // print(trie.delete('word'));
  // print(trie.search('word'));
  // print(trie.extract());
  // print(trie.delete('word'));
  // print(trie.delete('alphabet'));
  // print(trie.extract());
}
