class _Node {
  int value;
  bool isWord;
  _Node firstChild;
  _Node sibling;

  _Node(int value):value=value, isWord=false;
}

class Trie {
  final _Node _root;

  Trie():_root=_Node(0);

  bool search(String word) {
    if (word.isEmpty) {
      return false;
    }

    var outcome = _Outcome.UNKNOWN;
    var i = 0;

    var current = _root.firstChild;

    while (outcome == _Outcome.UNKNOWN) {
      if (current == null) {
        outcome = _Outcome.ABSENT;
      } else if (current.value == word.codeUnitAt(i)) {
        if (i == word.length-1) {
          outcome = _Outcome.PRESENT;
        } else {
          current = current.firstChild;
          i++;
        }
      }
    }

    return outcome == _Outcome.PRESENT && current.isWord;
  }

  void insert(String word) {
    var i = 0;
    var current = _root;
    var next = _root.firstChild;

    while (i < word.length) {
      if (next != null && next.value == word.codeUnitAt(i)) {
        current = next;
        next = current.firstChild;
        i++;
      } else if (next != null) {
        next = next.sibling;
      } else {
        var x = _Node(word.codeUnitAt(i));
        x.sibling = current.firstChild;
        current.firstChild = x;
        current = x;
        next = current.firstChild;
        i++;
      }
    }
    current.isWord = true;
  }

  bool delete(String word) {
    var i = 0;
    var current = _root;
    var next = _root.firstChild;

    while (i < word.length) {
      if (next != null && next.value == word.codeUnitAt(i)) {
        current = next;
        next = current.firstChild;
      } else if (next != null) {
        next = next.sibling;
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

enum _Outcome {
  PRESENT,
  ABSENT,
  UNKNOWN
}

void main(List<String> args) {
  final trie = Trie();
  trie.insert('word');
  trie.insert('words');
  print(trie.extract());
}