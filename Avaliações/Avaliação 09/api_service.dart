
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon.dart';

class ApiService {
  static const String url =
      'https://pokeapi.co/api/v2/pokemon?limit=20';

  static Future<List<Pokemon>> buscarPokemons() async {
    try {
      final resposta = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        final List resultados = dados['results'];

        final pokemons = await Future.wait(
          resultados.map((pokemon) async {
            final detalhe = await http
                .get(Uri.parse(pokemon['url']))
                .timeout(const Duration(seconds: 15));

            if (detalhe.statusCode != 200) {
              throw Exception('Erro ao buscar Pokémon');
            }

            return Pokemon.fromJson(
              jsonDecode(detalhe.body),
            );
          }),
        );

        return pokemons;
      } else {
        throw Exception('Erro ao consultar a API');
      }
    } catch (erro) {
      throw Exception('Não foi possível carregar os Pokémon: $erro');
    }
  }
}
