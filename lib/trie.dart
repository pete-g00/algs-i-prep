import 'sortedTrie.dart';

class TrieNode {
  final int value;
  bool isWord;
  TrieNode? firstChild;
  TrieNode? nextSibling;
  TrieNode? previousSibling;
  final TrieNode? parent;

  TrieNode(this.value, this.parent):isWord=false;

  @override
  String toString() {
    return '(${String.fromCharCode(value)})';
  }
}

abstract class Trie {
  factory Trie() => SortedTrie();

  TrieNode get root;

  /// Searches a word within the trie.
  /// 
  /// Returns `true` if the word is present, and `false` otherwise.
  bool search(String word); 

  /// Inserts a word into the trie.
  void insert(String word);

  /// Deletes a given character from the trie
  /// 
  /// Returns `true` if the word is present, and `false` otherwise.
  bool delete(String word);

  /// Extracts all the words present in the trie.
  List<String> extract();
}
