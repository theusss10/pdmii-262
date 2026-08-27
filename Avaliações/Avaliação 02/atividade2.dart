import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome
    };
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes': _dependentes
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': _nomeProjeto,
      'funcionarios': _funcionarios
    };
  }
}

void main() {
  
  Dependente dependente1 = Dependente("João");
  Dependente dependente2 = Dependente("Maria");
  Dependente dependente3 = Dependente("Pedro");
  Dependente dependente4 = Dependente("Ana");
  Dependente dependente5 = Dependente("Lucas");
  Dependente dependente6 = Dependente("Julia");
  Dependente dependente7 = Dependente("Gabriel");
  Dependente dependente8 = Dependente("Beatriz");

  Funcionario funcionario1 = Funcionario(
    "Carlos",
    [dependente1, dependente2]
  );

  Funcionario funcionario2 = Funcionario(
    "Marcos",
    [dependente3, dependente4]
  );

  Funcionario funcionario3 = Funcionario(
    "Rafael",
    [dependente5, dependente6]
  );

  Funcionario funcionario4 = Funcionario(
    "Fernanda",
    [dependente7, dependente8]
  );

  List<Funcionario> funcionarios = [
    funcionario1,
    funcionario2,
    funcionario3,
    funcionario4
  ];

  EquipeProjeto equipeProjeto = EquipeProjeto(
    "Sistema Escolar",
    funcionarios
  );

  print(jsonEncode(equipeProjeto));
}
