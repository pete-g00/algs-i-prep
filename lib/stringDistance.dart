import 'dart:math';
import 'auxiliary.dart';

/// Given two strings [word1] and [word2], computes the distance between them with respect to 3 basic string operations:
/// * insertion of a character;
/// * deletion of a character; and
/// * substitution of a character
int stringDistance(String word1, String word2) {
  print('Computing the distance between word1: $word1 and word2: $word2');
  // initialise the table with base case
  final table = List.generate(word1.length+1, (i) => List.generate(word2.length+1, (j) => (i == 0 || j == 0) ? i+j : 0));
  print('Table created with base cases: ');
  printTable(table);
  print('-'*100);

  for (var i=1; i<=word1.length; i++) {
    print('Iteration $i');
    print('-'*100);
    for (var j=1; j<=word2.length; j++) {
      print('Checking word1[${i-1}] = ${word1[i-1]} with word2[${j-1}] = ${word2[j-1]}');
      // if word1[i-1] == word2[j-1], we take the diagonal entry
      if (word1.codeUnitAt(i-1) == word2.codeUnitAt(j-1)) {
        print('Characters match, so taking the diagonal entry ${table[i-1][j-1]}');
        table[i][j] = table[i-1][j-1];
      // otherwise, we take the smallest of the three values and increment it
      } else {
        print('Characters do not match, so incrementing the smallest of: diagonal entry ${table[i-1][j-1]}, vertical entry ${table[i-1][j]} and horizontal entry ${table[i][j-1]}');
        table[i][j] = 1 + min(table[i-1][j-1], min(table[i-1][j], table[i][j-1]));
      }
    }
    print('Table is now: ');
    printTable(table);
    print('-'*100);
  }

  print('Computed all the values. Returning the value in the last cell- ${table[word1.length][word2.length]}');
  // the distance of the string is in the last cell

  // print(listToTable(table));
  return table[word1.length][word2.length];
}

void main(List<String> args) {
  stringDistance('sunday', 'saturday');
}
