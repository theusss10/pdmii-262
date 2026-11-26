import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// MODELO DE PRODUTO
class Produto {
  final String nome;
  final double preco;

  Produto({required this.nome, required this.preco});
}

// GERENCIAMENTO DO CARRINHO
class CarrinhoProvider extends ChangeNotifier {
  final Map<Produto, int> _itens = {};

  Map<Produto, int> get itens => _itens;

  int get quantidadeTotal {
    return _itens.values.fold(0, (total, qtd) => total + qtd);
  }

  double get valorTotal {
    double total = 0;

    _itens.forEach((produto, quantidade) {
      total += produto.preco * quantidade;
    });

    return total;
  }

  void adicionar(Produto produto) {
    _itens[produto] = (_itens[produto] ?? 0) + 1;
    notifyListeners();
  }

  void remover(Produto produto) {
    if (!_itens.containsKey(produto)) return;

    if (_itens[produto]! > 1) {
      _itens[produto] = _itens[produto]! - 1;
    } else {
      _itens.remove(produto);
    }

    notifyListeners();
  }

  void limparCarrinho() {
    _itens.clear();
    notifyListeners();
  }
}

// LISTA DE PRODUTOS
final List<Produto> produtos = [
  Produto(nome: 'Notebook', preco: 2500.00),
  Produto(nome: 'Mouse', preco: 80.00),
  Produto(nome: 'Teclado', preco: 150.00),
  Produto(nome: 'Headset', preco: 200.00),
];

// INICIALIZAÇÃO
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CarrinhoProvider(),
      child: const MeuApp(),
    ),
  );
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carrinho de Compras',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const TelaProdutos(),
    );
  }
}

// TELA DE PRODUTOS
class TelaProdutos extends StatelessWidget {
  const TelaProdutos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          Consumer<CarrinhoProvider>(
            builder: (context, carrinho, child) {
              return IconButton(
                icon: Badge(
                  label: Text('${carrinho.quantidadeTotal}'),
                  child: const Icon(Icons.shopping_cart),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaCarrinho()),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.shopping_bag, size: 35),
              title: Text(produto.nome),
              subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
              trailing: ElevatedButton(
                onPressed: () {
                  context.read<CarrinhoProvider>().adicionar(produto);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${produto.nome} adicionado!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text('Adicionar'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// TELA DO CARRINHO
class TelaCarrinho extends StatelessWidget {
  const TelaCarrinho({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Carrinho')),
      body: Consumer<CarrinhoProvider>(
        builder: (context, carrinho, child) {
          if (carrinho.itens.isEmpty) {
            return const Center(child: Text('Seu carrinho está vazio!'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: carrinho.itens.entries.map((item) {
                    final produto = item.key;
                    final quantidade = item.value;

                    return ListTile(
                      title: Text(produto.nome),
                      subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
                      leading: Text(
                        '${quantidade}x',
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              carrinho.remover(produto);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              carrinho.adicionar(produto);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Quantidade: ${carrinho.quantidadeTotal}'),
                    const SizedBox(height: 10),
                    Text(
                      'Total: R\$ ${carrinho.valorTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        carrinho.limparCarrinho();
                      },
                      child: const Text('Limpar carrinho'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
