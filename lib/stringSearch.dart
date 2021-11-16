import 'dart:math';

/// Searches the [substring] in the [string] using brute force.
/// 
/// If the [substring] is present in the [string], returns the index in the [string] where the [substring] starts.
/// Otherwise, returns -1.
int bruteForce(String string, String substring) {
  final m = substring.length;
  final n = string.length;

  // the index where we have aligned the string and the substring
  var start = 0;
  // the index in string
  var i = 0;
  // the index in substring
  var j = 0;

  // until there is a possible alignment of string and substring, and the substring hasn't been fully matched
  while (start <= n-m && j < m) {
    // if string[i] == substring[j], move to the next character
    if (string.codeUnitAt(i) == substring.codeUnitAt(j)) {
      i++;
      j++;
    }
    // otherwise, checkout the next alignment and start searching from the start
    else {
      j = 0;
      start++;
      i = start;
    }
  }

  // if the substring was fully matched, return the alignment index
  if (j == m) {
    return start;
  } 
  // otherwise, the substring wasn't found
  else {
    return -1;
  }
}

List<int> _createBorderTable(String substring) {
  // initialise the border table
  final borderTable = List.filled(substring.length, 0);
  // the previous value of the border table
  var i;
  
  // find the correct value in border table for indices 2, 3, ..
  for (var j=2; j<substring.length; j++) {
    // the first possible length of border table is the previous one + 1
    i = borderTable[j-1];

    // until the next character of the previous border table and substring matches (and we can find a match)
    while (substring.codeUnitAt(i) != substring.codeUnitAt(j-1) && i > 0) {
      // keep consider the border table of the index
      i = borderTable[i];
    }

    // if there never was a match, there is no border around this character
    if (substring.codeUnitAt(i) != substring.codeUnitAt(j-1) && i == 0) {
      borderTable[j] = 0;
    }
    // otherwise, increment the previous border table by 1
    else {
      borderTable[j] = i+1;
    }
  }

  return borderTable;
}

/// Searches the [substring] in the [string] using the KMP algorithm.
/// 
/// If the [substring] is present in the [string], returns the index in the [string] where the [substring] starts.
/// Otherwise, returns -1.
int kmp(String string, String substring) {
  final m = substring.length;
  final n = string.length;

  // the index in string
  var i = 0;
  // the index in substring
  var j = 0;

  // create the border table  
  final borderTable = _createBorderTable(substring);

  // until there is nowhere in the string to find the substring,
  while (i <= n) {
    // if string[i] == substring[j], move to the next character
    if (string.codeUnitAt(i) == substring.codeUnitAt(j)) {
      i++;
      j++;
      // if we have come to the end of the substring, return the alignment index
      if (j == m) {
        return i-j;
      }
    } 
    // otherwise, the characters do not match
    else {
      // if the character has a border, go to that value
      if (borderTable[j] > 0) {
        j = borderTable[j];
      }
      // if the character has no border and this is the first position in substring, move to the string by 1 character
      else if (j == 0) {
        i++;
      } 
      // otherwise, start from the start of the substring
      else {
        j = 0;
      }
    }
  }

  return -1;
}

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
  final m = substring.length;
  final n = string.length;

  // the index where we have aligned the string and the substring
  var start = 0;
  // the index in string
  var i = m-1;
  // the index in substring
  var j = m-1;

  final lastOccurrence = _createLastOcurrenceMap(substring);

  // until there is a valid alignment and we've gotten to the start of the substring
  while (start <= n-m && j >= 0) {
    // print('i: $i, j: $j');
    // print('string: ' + string[i] + ', substring: ' + substring[j]);
    // if characters match, consider the previous character
    if (string.codeUnitAt(i) == substring.codeUnitAt(j)) {
      i--;
      j--;
    }
    // otherwise, consider the next valid character
    else {
      // print(lastOccurrence[string.codeUnitAt(i)] ?? -1);
      start += max(1, j-(lastOccurrence[string.codeUnitAt(i)] ?? -1));
      i += m - min(j, 1+(lastOccurrence[string.codeUnitAt(i)] ?? -1));
      // print('start: $start, i: $i');
      j = m-1;
    }
    // print('');
  }

  // if we've gotten to the start of the substring, the substring was found in the string
  if (j < 0) {
    return start;
  } 
  // otherwise, the substring wasn't found in the string
  else {
    return -1;
  }
}

void main(List<String> args) {
  print(bm('bacbabababacaab', 'ababaca'));
}
