import 'trie.dart';

TrieNode? findChild(TrieNode node, int letter) {
  var current = node.firstChild;
  TrieNode? prev;
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

/// The class SortedTrie represents a collection of strings that are stored in a tree-like structure.
class SortedTrie implements Trie {
  final TrieNode _root;
  
  /// Creates an empty SortedTrie
  SortedTrie():_root=TrieNode(0, null);

  @override
  TrieNode get root => _root;

  @override
  bool search(String word) {
    // empty strings aren't present in a SortedTrie
    if (word.isEmpty) {
      return false;
    }
    print('Searching the word \'$word\' in the SortedTrie.');

    // the current node in the SortedTrie
    var current = _root;

    // the closest child of current to the next character
    TrieNode? child;
    print('-'*100);

    // go through each character in the word
    for (final code in word.codeUnits) {
      print('Searching the character ${String.fromCharCode(code)} in the SortedTrie.');
      // try to find the closest child for the given character
      child = findChild(current, code);
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
    if (child!.isWord) {
      print('The characters were found and corresponds to a word!');
      return true;
    } else {
      print('The characters were found but doesn\'t correspond to a word!');
      return false;
    }
  }

  @override
  void insert(String word) {
    print('Inserting the word \'$word\' into the SortedTrie.');

    // the current node in the SortedTrie
    var current = _root;
    
    // the closest child of current to the next character
    TrieNode? child;
    
    // a temporary node used to create new nodes
    TrieNode? temp;

    print('-'*100);
    // go through each character in the word
    for (final code in word.codeUnits) {
      print('Inserting the character ${String.fromCharCode(code)} into the SortedTrie.');
      // try to find the closest child for the given character
      child = findChild(current, code);

      // if child is null, create a node for this character and attach it to the parent
      if (child == null) {
        print('\tThe closest child to this character is null, so we create a node for this character and make it the first child of the parent.');
        temp = TrieNode(code, current);
        if (current.firstChild != null) {
          temp.nextSibling = current.firstChild;
          current.firstChild!.previousSibling = temp;
        }
        current.firstChild = temp;
        current = temp;
      } 
      // if the characters mismatch, create a node for this character and add it between child and child.nextSibling
      else if (child.value != code) {
        print('\tThe closest child to this character is ${String.fromCharCode(child.value)}, so we create a node for this character and add it between this value and its sibling.');
        temp = TrieNode(code, current);
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
    print('The string is now added to the SortedTrie, as a recognised word!');
  }

  @override
  bool delete(String word) {
    print('Deleting the word \'$word\' into the SortedTrie.');

    // the current node in the SortedTrie
    var current = _root;

    // the closest child node corresponding to the next character
    TrieNode? child;

    print('-'*100);
    // go through each character in word
    for (final code in word.codeUnits) {
      print('Searching the character ${String.fromCharCode(code)} in the SortedTrie.');
      // try to find the closest child for the given character
      child = findChild(current, code);
      // if no mismatch, take that character
      if (child != null && child.value == code) {
        print('\tThe character was found- searching the next character');
        current = child;
      }
      // otherwise, this character isn't present in the SortedTrie -> nothing to delete
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
        current.parent!.firstChild = current.nextSibling;
      } else {
        current.previousSibling!.nextSibling = current.nextSibling;
      }
      
      if (current.nextSibling != null) {
        current.nextSibling!.previousSibling = current.previousSibling;
      }
		
      // move up one level
      current = current.parent!;
      print('\tMoving to the previous character.');
    }

    print('-'*100);
    print('All the nodes that can be deleted have now been removed!');
    return true;
  }

  void _extract(List<String> list, TrieNode? node, String prefix) {
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

  /// Extracts all the words present in the SortedTrie.
  @override
  List<String> extract() {
    print('Extracting the SortedTrie:');
    final list = <String>[];
    _extract(list, _root.firstChild, '');
    return list;
  }
}

void main(List<String> args) {
  final sortedTrie = SortedTrie();
  sortedTrie.insert('alpha');
  print('');
  sortedTrie.insert('word');
  print('');
  sortedTrie.insert('alphabet');
  print('');
  // sortedTrie.search('word');
  // print('');
  sortedTrie.delete('word');
  print('');
  // sortedTrie.search('word');
  // print(SortedTrie.extract());
  sortedTrie.delete('word');
  print('');
  sortedTrie.delete('alphabet');
  // print(sortedTrie.extract());
}
