/// Searches the [substring] in the [string] using brute force.
/// 
/// If the [substring] is present in the [string], returns the index in the [string] where the [substring] starts.
/// Otherwise, returns -1.
int bruteForce(String string, String substring) {
  print('Searching the string \'$substring\' in the string \'$string\' using brute force.');
  final m = substring.length;
  final n = string.length;

  // the index in string
  var i = 0;
  // the index in substring
  var j = 0;
  
  print('-'*100);
  print('Aligning the substring at index ${i-j}');
  
  // until there is a possible alignment of string and substring, 
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
    // otherwise, checkout the next alignment and start searching from the start
    else {
      print('The characters do not match!');
      i = 1+i-j;
      j = 0;
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
  bruteForce('bacbabababacaab', 'caab');
}
