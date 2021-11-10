class _Node {
  int value;
  bool isWord;
  _Node firstChild;
  _Node sibling;

  _Node(this.value):isWord=false;

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

class Trie {
  final _Node _root;

  Trie():_root=_Node(null);

  bool search(String word) {
    if (word.isEmpty) {
      return false;
    }

    var current = _root;
    _Node child;

    for (final code in word.codeUnits) {
      child = current.findChild(code);
      if (child == null || child.value != code) {
        return false;
      }
    }
    return child.isWord;
  }

  void insert(String word) {
    var current = _root;
    _Node child;
    _Node temp;
    for (final code in word.codeUnits) {
      child = current.findChild(code);
      if (child == null) {
        temp = _Node(code);
        temp.sibling = current.firstChild;
        current.firstChild = temp;
        current = temp;
      } else if (child.value != code) {
        temp = _Node(code);
        temp.sibling = child.sibling;
        child.sibling = temp;
        current = temp;
      } else {
        current = child;
      }
    }
    current.isWord = true;
  }

  // TODO: This method could be more involved
  bool delete(String word) {
    var current = _root;
    _Node child;
    for (final code in word.codeUnits) {
      child = current.findChild(code);
      if (child != null && child.value == code) {
        current = child;
      } else {
        return false;
      }
    }
    current.isWord = false;
    return true;
  }

  void _extract(List<String> list, _Node node, String prefix) {
    if (node != null) {
      final word = prefix + String.fromCharCode(node.value);
      if (node.isWord) {
        list.add(word);
      }

      _extract(list, node.firstChild, word);
      _extract(list, node.sibling, prefix);
    }
  }

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
  print(trie.extract());
}