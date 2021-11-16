void printTable<E>(List<List<E>> list) {
  for (var i=0; i<list.length; i++) {
    if (i == 0) {
      print('\t[' + list.first.toString() + ',');
    } else if (i == list.length-1) {
      print('\t' + list[list.length-1].toString() + ']');
    } else {
      print('\t' + list[i].toString() + ',');
    }
  }
}

void printCharMap<V>(Map<int, V> map) {
  var i = 0;
  for (final entry in map.entries) {
    if (i == 0) {
      print('\t{' + String.fromCharCode(entry.key) + ': ${entry.value}, ');
    } else if (i == map.length-1) {
      print('\t' + String.fromCharCode(entry.key) + ': ${entry.value}}');
    } else {
      print('\t' + String.fromCharCode(entry.key) + ': ${entry.value}, ');
    }
    i++;
  }
}