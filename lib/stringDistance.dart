import 'dart:math';

/// Given two strings [word1] and [word2], computes the distance between them with respect to 3 basic string operations:
/// * insertion of a character;
/// * deletion of a character; and
/// * substitution of a character
int stringDistance(String word1, String word2) {
  // initialise the table with base case
  final table = List.generate(word1.length+1, (i) => List.generate(word2.length+1, (j) => i+j));

  for (var i=1; i<=word1.length; i++) {
    for (var j=1; j<=word2.length; j++) {
      // if word1[i-1] == word2[j-1], we take the diagonal entry
      if (word1.codeUnitAt(i-1) == word2.codeUnitAt(j-1)) {
        table[i][j] = table[i-1][j-1];
      // otherwise, we take the smallest of the three values and increment it
      } else {
        table[i][j] = 1 + min(table[i-1][j-1], min(table[i-1][j], table[i][j-1]));
      }
    }
  }

  print(table);
  // the distance of the string is in the last cell
  return table[word1.length][word2.length];
}

void main(List<String> args) {
  stringDistance('saturday', 'sunday');
}
