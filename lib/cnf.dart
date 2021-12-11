class boolVar {
  bool? value;
  String name;

  boolVar(this.name);

  @override
  String toString() {
    return name;
  }
}

class boolInstance {
  boolVar variable;
  bool negated;

  boolInstance(this.variable, [this.negated=false]);

  bool get value => negated ? !variable.value! : variable.value!;

  @override
  String toString() {
    return negated ? '¬$variable' : '$variable';
  }

}

class Clause {
  Iterable<boolInstance> variables;

  Clause(this.variables);

  bool get value =>  variables.any((variable) => variable.value);

  @override
  String toString() {
    return '(' + variables.join(' ∨ ') + ')';
  }
}

class CNF {
  Iterable<Clause> clauses;

  CNF(this.clauses);

  bool get value {
    print(state);
    return clauses.every((clause) => clause.value);
  }

  @override
  String toString() {
    return clauses.join(' ∧ ');
  }

  Set<boolVar> get variables {
    final variables = <boolVar>{};
    clauses.forEach((clause) {
      clause.variables.forEach((variable) {
        variables.add(variable.variable);
      });
    });

    return variables;
  }

  String get state {
    final string = StringBuffer();
    for (final variable in variables) {
      string.write(variable);
      string.write(': ');
      string.write(variable.value);
      string.write(' ');
    }
    
    return string.toString();
  }

  bool _checkSATBruteForce(List<boolVar> variables) {
    if (variables.isEmpty) {
      return value;
    }
    
    final variable = variables[0];
    final nextVars = variables.sublist(1);
    
    variable.value = false;
    final first = _checkSATBruteForce(nextVars);
    if (first) {
      return true;
    }
    
    variable.value = true;
    final second = _checkSATBruteForce(nextVars);
    if (second) {
      return true;
    }

    return false;
  }

  bool SATBruteForce() {
    return _checkSATBruteForce(variables.toList());
  }
}

void main(List<String> args) {
  final var1 = boolVar('a1');
  final var2 = boolVar('a2');
  // final var3 = boolVar('a3');

  final clause1 = Clause([boolInstance(var1), boolInstance(var2)]);
  final clause2 = Clause([boolInstance(var1, true), boolInstance(var2)]);
  // final clause3 = Clause([boolInstance(var1), boolInstance(var2, true)]);
  final clause4 = Clause([boolInstance(var1, true), boolInstance(var2, true)]);

  final cnf = CNF([clause1, clause2, clause4]);
  print(cnf);
  print(cnf.SATBruteForce());
}
