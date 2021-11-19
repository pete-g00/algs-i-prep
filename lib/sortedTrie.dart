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
    print('Searching the word \'$word\' in the trie.');

    // the current node in the trie
    var current = _root;

    // the closest child of current to the next character
    _Node child;
    print('-'*100);

    // go through each character in the word
    for (final code in word.codeUnits) {
      print('Searching the character ${String.fromCharCode(code)} in the trie.');
      // try to find the closest child for the given character
      child = current.findChild(code);
      // if it is not a match, return false
      if (child == null || child.value != code) {
        print('\tThe character isn\'t attached to the previous character- the string isn\'t present');
        return false;
      }
      print('\tThe character was found- checking the next character');
      // move to the child node
      current = child;
    }
    print('-'*100);

    // the node has to correspond to a word for it to be present
    if (child.isWord) {
      print('The characters were found and corresponds to a word!');
      return true;
    } else {
      print('The characters were found but doesn\'t correspond to a word!');
      return false;
    }
  }

  /// Inserts a word into the trie.
  void insert(String word) {
    print('Inserting the word \'$word\' into the trie.');

    // the current node in the trie
    var current = _root;
    
    // the closest child of current to the next character
    _Node child;
    
    // a temporary node used to create new nodes
    _Node temp;

    print('-'*100);
    // go through each character in the word
    for (final code in word.codeUnits) {
      print('Inserting the character ${String.fromCharCode(code)} into the trie.');
      // try to find the closest child for the given character
      child = current.findChild(code);

      // if child is null, create a node for this character and attach it to the parent
      if (child == null) {
        print('\tThe closest child to this character is null, so we create a node for this character and make it the first child of the parent.');
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
        print('\tThe closest child to this character is ${String.fromCharCode(child.value)}, so we create a node for this character and add it between this value and its sibling.');
        temp = _Node(code, current);
        temp.nextSibling = child.nextSibling;
        temp.previousSibling = child;
        child.nextSibling = temp;
        current = temp;
      }
      // if the characters match, just take that character
      else {
        print('\tThis character is a child, so we move on to the next character.');
        current = child;
      }
    }    

    // only the final node corresponds to a node
    current.isWord = true;
    print('-'*100);
    print('The string is now added to the trie, as a recognised word!');
  }

  /// Deletes a given character from the trie
  /// 
  /// Returns `true` if the word is present, and `false` otherwise.
  bool delete(String word) {
    print('Deleting the word \'$word\' into the trie.');

    // the current node in the trie
    var current = _root;

    // the closest child node corresponding to the next character
    _Node child;

    print('-'*100);
    // go through each character in word
    for (final code in word.codeUnits) {
      print('Searching the character ${String.fromCharCode(code)} in the trie.');
      // try to find the closest child for the given character
      child = current.findChild(code);
      // if no mismatch, take that character
      if (child != null && child.value == code) {
        print('\tThe character was found- searching the next character');
        current = child;
      }
      // otherwise, this character isn't present in the trie -> nothing to delete
      else {
        print('\tThe character isn\'t attached to the previous character- the string isn\'t present and there\'s nothing to delete.');
        return false;
      }
    }
    print('-'*100);
    
    // if the final node isn't a word, then return false -> make absolutely no change
    if (!current.isWord) {
      print('The final character doesn\'t correspond to a word, so there\'s nothing to delete.');
      return false;
    }

    // current is no longer a word
    current.isWord = false;

    // until we have nodes to remove -> node that has no children and don't correspond to word themselves, remove them
    while (current != _root && current.firstChild == null && !current.isWord) {
      print('The node ${String.fromCharCode(current.value)} represents a character, doesn\'t have a child and isn\'t a word- we can delete it!');
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
      print('\tMoving to the previous character.');
    }

    print('-'*100);
    print('All the nodes that can be deleted have now been removed!');
    return true;
  }

  void _extract(List<String> list, _Node node, String prefix) {
    if (node != null) {
      print('Encountered the node $node.');
      // create the corresponding word
      final word = prefix + String.fromCharCode(node.value);
      // add it if it is a word
      if (node.isWord) {
        print('Found the word $word!');
        list.add(word);
      }
      
      // extract on child with the extra character
      _extract(list, node.firstChild, word);
      print('-'*100);
      
      // extract on sibling without the extra character
      _extract(list, node.nextSibling, prefix);
    }
  }

  /// Extracts all the words present in the trie.
  List<String> extract() {
    print('Extracting the trie:');
    final list = <String>[];
    _extract(list, _root.firstChild, '');
    return list;
  }
}

void main(List<String> args) {
  final trie = Trie();
  trie.insert('alpha');
  print('');
  trie.insert('word');
  print('');
  trie.insert('alphabet');
  print('');
  // trie.search('word');
  // print('');
  trie.delete('word');
  print('');
  // trie.search('word');
  // print(trie.extract());
  trie.delete('word');
  print('');
  trie.delete('alphabet');
  // print(trie.extract());
}
