import 'package:dart/auxiliary.dart';

Map<int, int> _createLastOcurrenceMap(String substring) {
  final lastOcurrence = <int, int>{};
  
  for (var i = 0; i < substring.length; i++) {
    // this is the most recent occurence of substring[i] in the substring
    lastOcurrence[substring.codeUnitAt(i)] = i;
  }

  return lastOcurrence;
}

/// Searches the [substring] in the [string] using the BM algorithm.
/// 
/// If the [substring] is present in the [string], returns the index in the [string] where the [substring] starts.
/// Otherwise, returns -1.
int bm(String string, String substring) {
  print('Searching the string \'$substring\' in the string \'$string\' using BM.');
  final m = substring.length;
  final n = string.length;

  // the index in string
  var i = m-1;
  // the index in substring
  var j = m-1;
  // the value in the last occurrence map
  int value;

  final lastOccurrence = _createLastOcurrenceMap(substring);
  print('Created the last occurrence map:');
  printCharMap(lastOccurrence);
  
  print('-'*100);
  print('Aligning the substring at index ${i-j}');

  // until there is a valid alignment,
  while (i-j <= n-m) {
    print('Checking string[$i] = ${string[i]} and substring[$j] = ${substring[j]}');
    // if characters match, consider the previous character
    if (string.codeUnitAt(i) == substring.codeUnitAt(j)) {
      print('The characters match!');
      i--;
      j--;

      // if we've gotten to the start of the substring, the substring was found in the string
      if (j < 0) {
        print('The substring has been completely found in the string- returning ${i-j}');
        return i-j;
      }
      print('Moving on to the next character');
    }
    // otherwise, consider the next valid character
    else {
      print('The characters do not match!');
      // find the last ocurrence of string[i] in the substring
      value = lastOccurrence[string.codeUnitAt(i)];
      // if the substring doesn't have the string, we move past all the characters before string[i]
      if (value == null) {
        print('Case 1: The character ${string[i]} is not present in the substring');
        print('\tWe realign just after i = $i');
        i += m;
      }
      // if the substring does have the string, but we're past it, we just start from the next character
      else if (j < value) {
        print('Case 2: The character ${string[i]} is present in the string, but we are past the last ocurrence in the substring');
        print('\tWe increment start = ${i-j}');
        i += m - j;
      } else {
        print('Case 3: The character ${string[i]} is present in the string, and we are not past the last ocurrence in the substring');
        print('\tWe fix substring[value] = ${substring[value]} to this index');
        i += m - value - 1;
      }
      // start += max(1, j-(lastOccurrence[string.codeUnitAt(i)] ?? -1));
      // i += m - min(j, 1+(lastOccurrence[string.codeUnitAt(i)] ?? -1));
      // i = m-1 + start;
      j = m-1;
      print('-'*100);
      print('Aligning the substring at index ${i-j}');
    }
  }

  // otherwise, the substring wasn't found in the string
  print('The substring wasn\'t found in the string- returning -1');
  return -1;
}

void main(List<String> args) {
  bm('abccaabacaababa', 'acaa');
}
