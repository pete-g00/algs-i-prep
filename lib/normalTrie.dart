class _Node {
  int value;
  bool isWord;
  _Node firstChild;
  _Node nextSibling;
  _Node previousSibling;
  _Node parent;

  _Node(this.value, this.parent):isWord=false;

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

    // the outcome of the search
    var outcome = _Outcome.UNKNOWN;
    
    // the character we are looking at within the word
    var i = 0;

    // the current node in the trie
    var current = _root.firstChild;

    // until we know whether the value is present or not
    while (outcome == _Outcome.UNKNOWN) {
      // if there is no node to continue on checking, the word isn't present
      if (current == null) {
        outcome = _Outcome.ABSENT;
      } 
      // if the characters match,
      else if (current.value == word.codeUnitAt(i)) {
        // and this was the final character, the value is present
        if (i == word.length-1) {
          outcome = _Outcome.PRESENT;
        }
        // otherwise, look at the next character
         else {
          current = current.firstChild;
          i++;
        }
      }
    }

    // only return true if the trie contained the sequence of characters and the final node is a word
    return outcome == _Outcome.PRESENT && current.isWord;
  }

  /// Inserts a word into the trie.
  void insert(String word) {
    // the index of the character in word
    var i = 0;
    // the current node in the trie
    var current = _root;
    // a child node of current
    var child = _root.firstChild;

    // until we've added the last character within the word
    while (i < word.length) {
      // if child corresponds to the required node, descend to that node
      if (child != null && child.value == word.codeUnitAt(i)) {
        current = child;
        child = current.firstChild;
        i++;
      }
      // if the child is present, then consider its sibling
      else if (child != null) {
        child = child.nextSibling;
      } 
      // otherwise, there is no node for the given value -> create a node and make it the first child
      else {
        var x = _Node(word.codeUnitAt(i), current);
        if (current.firstChild != null) {
          x.nextSibling = current.firstChild;
          current.firstChild.previousSibling = x;
        }
        current.firstChild = x;
        current = x;

        // move to the next character
        child = current.firstChild;
        i++;
      }
    }
    // the final character represents a word
    current.isWord = true;
  }

  /// Deletes a given character from the trie
  /// 
  /// Returns `true` if the word is present, and `false` otherwise.
  bool delete(String word) {
    // the index of the character in word
    var i = 0;
    // the current node in the trie
    var current = _root;
    // a child node of current
    var child = _root.firstChild;

    // until we haven't gone to the end of the word
    while (i < word.length) {
      // if the child node matches in value with word[i], move to the next character
      if (child != null && child.value == word.codeUnitAt(i)) {
        current = child;
        child = current.firstChild;
        i++;
      }
      // if there are still searchable nodes, go to the sibling
       else if (child != null) {
        child = child.nextSibling;
      } 
      // otherwise, there is no node for word[i] -> return false
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
    
    // current corresponded to a word
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

enum _Outcome {
  PRESENT,
  ABSENT,
  UNKNOWN
}

void main(List<String> args) {
  final trie = Trie();
  trie.insert('word');
  trie.insert('alphabet');
  trie.insert('alpha');
  print(trie.extract());
  // print(trie.delete('word'));
  print(trie.delete('alphabet'));
  print(trie.extract());
}
