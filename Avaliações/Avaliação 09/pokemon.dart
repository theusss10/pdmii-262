
class Pokemon {
  final int id;
  final String nome;
  final String imagem;
  final List<String> tipos;

  Pokemon({
    required this.id,
    required this.nome,
    required this.imagem,
    required this.tipos,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      nome: json['name'],
      imagem: json['sprites']['front_default'] ?? '',
      tipos: (json['types'] as List)
          .map((tipo) => tipo['type']['name'] as String)
          .toList(),
    );
  }
}
