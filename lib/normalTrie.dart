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
    print('Searching the word \'$word\' in the trie.');

    // the character we are looking at within the word
    var i = 0;

    // the current node in the trie
    var current = _root.firstChild;
    print('-'*100);
    print('Searching the character ${word[i]} in the trie.');
      
    // until we have a character to check
    while (i < word.length) {
      // if there is no node to continue on checking, the word isn't present
      if (current == null) {
        print('There is no (further) node to search- the word isn\'t present.');
        return false;
      } 

      // if the characters match,
      else if (current.value == word.codeUnitAt(i)) {
        print('Character found!');
        // and this was the final character, the value is present
        if (i == word.length-1) {
          if (current.isWord) {
            print('\tThis was the last character in the word, and it represents a word!');
            return true;
          } else {
            print('\tThis was the last character in the word, but it doesn\'t represent a word!');
            return false;
          }
        }
        // otherwise, look at the next character
         else {
          print('\tMoving on to the next character!');
          current = current.firstChild;
          i++;
          print('-'*100);
          print('Searching the character ${word[i]} in the trie.');
        }
      } 
      // otherwise, move on to the next node
      else {
        print('The current character is ${String.fromCharCode(current.value)}, which doesn\'t match ${word[i]}. So, we move on to its sibling!');
        current = current.nextSibling;
      }
    }
    
    // the function never comes here
    return false;
  }

  /// Inserts a word into the trie.
  void insert(String word) {
    print('Inserting the word \'$word\' into the trie.');

    // the index of the character in word
    var i = 0;
    // the current node in the trie
    var current = _root;
    // a child node of current
    var child = _root.firstChild;

    print('-'*100);
    print('Inserting the character ${word[i]} into the trie.');
    // until we've added the last character within the word
    while (i < word.length) {
      // if child corresponds to the required node, descend to that node
      if (child != null && child.value == word.codeUnitAt(i)) {
        print('The character was already present, so we move on to the next character!');
        current = child;
        child = current.firstChild;
        i++;
        print('-'*100);
        if (i < word.length) {
          print('Inserting the character ${word[i]} into the trie.');
        }
      }
      // if the child is present, then consider its sibling
      else if (child != null) {
        print('Found character ${String.fromCharCode(child.value)}, which doesn\'t match ${word[i]}. So, we move on to the next sibling!');
        child = child.nextSibling;
      } 
      // otherwise, there is no node for the given value -> create a node and make it the first child
      else {
        print('No (further) characters at this level- creating a node for this character.');
        var x = _Node(word.codeUnitAt(i), current);
        if (current.firstChild != null) {
          x.nextSibling = current.firstChild;
          current.firstChild.previousSibling = x;
        }
        current.firstChild = x;
        current = x;
        print('Node created! Moving on to the next character.');

        // move to the next character
        child = current.firstChild;
        i++;
        print('-'*100);
        if (i < word.length) {
          print('Inserting the character ${word[i]} into the trie.');
        }
      }
    }
    print('Making this character a word. The word is now inserted into the trie!');
    // the final character represents a word
    current.isWord = true;
  }

  /// Deletes a given character from the trie
  /// 
  /// Returns `true` if the word is present, and `false` otherwise.
  bool delete(String word) {
    print('Deleting the word \'$word\' into the trie.');
    // the index of the character in word
    var i = 0;
    // the current node in the trie
    var current = _root;
    // a child node of current
    var child = _root.firstChild;

    print('-'*100);
    print('Finding the character ${word[i]} in the trie.');
    // until we haven't gone to the end of the word
    while (i < word.length) {
      // if the child node matches in value with word[i], move to the next character
      if (child != null && child.value == word.codeUnitAt(i)) {
        print('The character has been found, so we move on to the next character.');
        current = child;
        child = current.firstChild;
        i++;

        print('-'*100);
        if (i < word.length) {
          print('Finding the character ${word[i]} in the trie.');
        }
      }
      // if there are still searchable nodes, go to the sibling
       else if (child != null) {
         print('Found character ${String.fromCharCode(child.value)}, so we move on to the next sibling.');
        child = child.nextSibling;
      } 
      // otherwise, there is no node for word[i] -> return false
      else {
        print('There is no node for ${word[i]}- there is nothing to delete!');
        return false;
      }
    }

    // if the final node isn't a word, then return false -> make absolutely no change
    if (!current.isWord) {
      print('The final node doesn\'t correspond to a word- there is nothing to delete!');
      return false;
    }
    
    // current is no longer a word
    current.isWord = false;
    print('Removing the nodes that can be removed.');
    print('-'*100);
    print('Trying to remove ${String.fromCharCode(current.value)}');

    // until we have nodes to remove -> node that has no children and don't correspond to word themselves, remove them
    while (current != _root && current.firstChild == null && !current.isWord) {
      print('The character ${String.fromCharCode(current.value)} can be removed, so we remove it!');
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
      if (current.value != null) {
        print('Trying to remove ${String.fromCharCode(current.value)}');
      }
    }
    
    print('-'*100);
    print('All the possible nodes were deleted!');
    // current corresponded to a word
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
  trie.insert('word');
  trie.insert('alphabet');
  trie.insert('alpha');
  trie.delete('alpha');
  trie.search('alpha');
  trie.search('word');
  // trie.extract();
}
