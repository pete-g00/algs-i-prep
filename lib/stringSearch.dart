import 'dart:math';

int bruteForce(String string, String substring) {
  final m = substring.length;
  final n = string.length;

  var start = 0;
  var i = 0;
  var j = 0;

  while (start <= n-m && j < m) {
    if (string.codeUnitAt(i) == substring.codeUnitAt(j)) {
      i++;
      j++;
    } else {
      j = 0;
      start++;
      i = start;
    }
  }

  if (j == m) {
    return start;
  } else {
    return -1;
  }
}

int kmp(String string, String substring) {
  final m = substring.length;
  final n = string.length;

  var i = 0;
  var j = 0;
  
  // TODO: Create border table
  final borderTable = <int>[];

  while (i <= n) {
    if (string.codeUnitAt(i) == substring.codeUnitAt(j)) {
      i++;
      j++;
      if (j == m) {
        return i-j;
      }
    } else {
      if (borderTable[j] > 0) {
        j = borderTable[j];
      } else if (j == 0) {
        i++;
      } else {
        j = 0;
      }
    }
  }

  return -1;
}

int bm(String string, String substring) {
  final m = substring.length;
  final n = string.length;

  var start = 0;
  var i = m-1;
  var j = m-1;

  // TODO: Create last occurrence
  final lastOccurrence = <int, int>{};

  while (start <= n-m && j >= 0) {
    if (string.codeUnitAt(i) == substring.codeUnitAt(j)) {
      i--;
      j--;
    } else {
      start = max(i, j-lastOccurrence[string.codeUnitAt(i)]);
      i += m - min(j, i+lastOccurrence[string.codeUnitAt(i)]);
      j = m-1;
    }
  }

  if (j < 0) {
    return start;
  } else {
    return -1;
  }
}