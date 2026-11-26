
import 'package:flutter/material.dart';
import 'pokemon.dart';
import 'api_service.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minha Pokédex',
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        useMaterial3: true,
      ),
      home: const TelaPokemons(),
    );
  }
}

class TelaPokemons extends StatefulWidget {
  const TelaPokemons({super.key});

  @override
  State<TelaPokemons> createState() => _TelaPokemonsState();
}

class _TelaPokemonsState extends State<TelaPokemons> {
  late Future<List<Pokemon>> pokemons;

  @override
  void initState() {
    super.initState();
    pokemons = ApiService.buscarPokemons();
  }

  Future<void> atualizarPokemons() async {
    setState(() {
      pokemons = ApiService.buscarPokemons();
    });

    await pokemons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minha Pokédex',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: FutureBuilder<List<Pokemon>>(
        future: pokemons,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 10),
                  const Text('Erro ao carregar os Pokémon.'),
                  ElevatedButton(
                    onPressed: atualizarPokemons,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final lista = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: atualizarPokemons,
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final pokemon = lista[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      pokemon.imagem,
                      width: 65,
                      height: 65,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.catching_pokemon);
                      },
                    ),

                    title: Text(
                      pokemon.nome.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      'Nº ${pokemon.id}  |  Tipo: ${pokemon.tipos.join(', ')}',
                    ),

                    trailing: const Icon(
                      Icons.catching_pokemon,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
