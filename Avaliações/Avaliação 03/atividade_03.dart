import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;

  String dbPath = p.join(Directory.current.path, 'alunos.db');

  Database? db;

  try {
    print('Abrindo/Criando o banco de dados em: $dbPath');

    db = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          print('Criando tabela "tb_alunos"...');
          await db.execute('''
            CREATE TABLE tb_alunos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              idade INTEGER NOT NULL
            )
          ''');
          print('Tabela "tb_alunos" criada com sucesso!');
        },
      ),
    );

    await inserirAlunos(db);

    await listarAlunos(db);
  } catch (e, stackTrace) {
    print('Ocorreu um erro na execução principal do banco de dados: $e');
    print(stackTrace);
  } finally {
    if (db != null && db.isOpen) {
      await db.close();
      print('Conexão com o banco de dados fechada.');
    }
  }
}

Future<void> inserirAlunos(Database db) async {
  try {
    print('\n--- Inserindo Alunos ---');

    List<Map<String, dynamic>> novosAlunos = [
      {'nome': 'Ana Silva', 'idade': 20},
      {'nome': 'Carlos Oliveira', 'idade': 22},
      {'nome': 'Beatriz Souza', 'idade': 19},
    ];

    for (var aluno in novosAlunos) {
      int id = await db.insert('tb_alunos', aluno);
      print('Aluno inserido com sucesso! ID: $id | Nome: ${aluno['nome']}');
    }
  } catch (e) {
    print('Erro ao inserir alunos no banco de dados: $e');
    rethrow;
  }
}

Future<void> listarAlunos(Database db) async {
  try {
    print('\n--- Listando Alunos ---');

    List<Map<String, dynamic>> registros = await db.query('tb_alunos');

    if (registros.isEmpty) {
      print('Nenhum aluno encontrado.');
      return;
    }

    for (var linha in registros) {
      print(
        'ID: ${linha['id']} | Nome: ${linha['nome']} | Idade: ${linha['idade']}',
      );
    }
  } catch (e) {
    print('Erro ao consultar a tabela tb_alunos: $e');
    rethrow;
  }
}
