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
  print('Searching the string \'$substring\' in the string \'$string\' using KMP.');
  final m = substring.length;
  final n = string.length;

  // the index in string
  var i = 0;
  // the index in substring
  var j = 0;

  // create the border table  
  final borderTable = _createBorderTable(substring);
  print('Created the border table:');
  print(borderTable);

  print('-'*100);
  print('Aligning the substring at index ${i-j}');

  // until there is nowhere in the string to find the substring,
  while (i-j <= n-m) {
    print('Checking string[$i] = ${string[i]} and substring[$j] = ${substring[j]}');
    // if string[i] == substring[j], move to the next character
    if (string.codeUnitAt(i) == substring.codeUnitAt(j)) {
      print('The characters match!');
      i++;
      j++;

      // if we have come to the end of the substring, return the alignment index
      if (j == m) {
        print('The substring has been completely found in the string- returning ${i-j}');
        return i-j;
      }
      print('Moving on to the next character');
    } 
    // otherwise, the characters do not match
    else {
      print('The characters do not match!');
      print('We have borderTable[$j] = ${borderTable[j]}');
      // if the character has a border, go to that value
      if (borderTable[j] > 0) {
        j = borderTable[j];
        print('The value is non-zero, so setting j to $j');
      }
      // if the character has no border and this is the first position in substring, move to the string by 1 character
      else if (j == 0) {
        print('This was the first character in the substring, so move along to the next alignment by 1');
        i++;
      } 
      // otherwise, start from the start of the substring
      else {
        print('This wasn\'t the first character in the substring, so we move the substring to the start here');
        j = 0;
      }
      print('-'*100);
      if (i <= n-m) {
        print('Aligning the substring at index ${i-j}');
      }
    }
  }

  // otherwise, the substring wasn't found in the string
  print('The substring wasn\'t found in the string- returning -1');
  return -1;
}

void main(List<String> args) {
  kmp('abcaabit', 'caab');
}
