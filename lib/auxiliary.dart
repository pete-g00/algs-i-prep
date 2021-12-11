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

/// Converts a list of list of integers into a latex table body
String listToTable(List<List<int>> list) {
  final string = StringBuffer();
  for (var i = 0; i < list.length; i++) {
    for (var j = 0; j < list[i].length; j++) {
      string.write(' ');
      string.write(list[i][j]);
      string.write(' ');
      if (j == list[i].length-1) {
        string.write('\\\\');
      } else {
        string.write('&');
      }
    }
    string.write('\n');
  }

  return string.toString();
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

String writeEdge(String from, String to, bool isDirected, [int? weight]) {
  if (isDirected && weight != null) {
    return '\\draw[->] ($from) to node[below] {$weight} ($to);';
  } else if (isDirected) {
    return '\\draw[->] ($from) to ($to);';
  } else if (!isDirected && weight != null) {
    return '\\draw[] ($from) to node[below] {$weight} ($to);';
  } else {
    return '\\draw[] ($from) to ($to);';
  }
}

String writeVertex(String label) => '\\node[circle, draw] ($label) at (0, 0) {$label};';