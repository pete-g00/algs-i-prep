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

List<int> _createBorderTable(String substring) {
  final borderTable = List.filled(substring.length, 0);
  var i;
  
  for (var j=2; j<substring.length; j++) {
    i = borderTable[j-1];
    while (substring.codeUnitAt(i) != substring.codeUnitAt(j-1) && i > 0) {
      i = borderTable[i];
    }

    if (substring.codeUnitAt(i) != substring.codeUnitAt(j-1) && i == 0) {
      borderTable[j] = 0;
    } else {
      borderTable[j] = i+1;
    }
  }

  return borderTable;
}

int kmp(String string, String substring) {
  final m = substring.length;
  final n = string.length;

  var i = 0;
  var j = 0;
  
  final borderTable = _createBorderTable(substring);

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

Map<int, int> _createLastOcurrenceMap(String substring) {
  final lastOcurrence = <int, int>{};
  
  for (var i = 0; i < substring.length; i++) {
    lastOcurrence[substring.codeUnitAt(i)] = i;
  }

  return lastOcurrence;
}

int bm(String string, String substring) {
  final m = substring.length;
  final n = string.length;

  var start = 0;
  var i = m-1;
  var j = m-1;

  final lastOccurrence = _createLastOcurrenceMap(substring);

  while (start <= n-m && j >= 0) {
    // print('i: $i, j: $j');
    // print('string: ' + string[i] + ', substring: ' + substring[j]);
    if (string.codeUnitAt(i) == substring.codeUnitAt(j)) {
      i--;
      j--;
    } else {
      // print(lastOccurrence[string.codeUnitAt(i)] ?? -1);
      start += max(1, j-(lastOccurrence[string.codeUnitAt(i)] ?? -1));
      i += m - min(j, 1+(lastOccurrence[string.codeUnitAt(i)] ?? -1));
      // print('start: $start, i: $i');
      j = m-1;
    }
    // print('');
  }

  if (j < 0) {
    return start;
  } else {
    return -1;
  }
}

void main(List<String> args) {
  print(bm('bacbabababacaab', 'ababaca'));
}