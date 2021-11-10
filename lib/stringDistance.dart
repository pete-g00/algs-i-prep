import 'dart:math';

int stringDistance(String word1, String word2) {
  final table = List.generate(word1.length+1, (i) => List.generate(word2.length+1, (j) => i+j));

  for (var i=1; i<=word1.length; i++) {
    for (var j=1; j<=word2.length; j++) {
      if (word1.codeUnitAt(i-1) == word2.codeUnitAt(j-1)) {
        table[i][j] = table[i-1][j-1];
      } else {
        table[i][j] = 1 + min(table[i-1][j-1], min(table[i-1][j], table[i][j-1]));
      }
    }
  }

  print(table);
  return table[word1.length][word2.length];
}

void main(List<String> args) {
  stringDistance('saturday', 'sunday');
}