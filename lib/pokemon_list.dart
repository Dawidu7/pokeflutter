import "package:flutter/material.dart";
import "package:pokeflutter/poke_api_service.dart";
import "package:pokeflutter/pokemon_card.dart";
import "package:pokeflutter/pokemon_list_item.dart";

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  late Future<List<PokemonListItem>> _pokemonList;
  final PokeApiService _apiService = PokeApiService();

  @override
  void initState() {
    super.initState();
    _pokemonList = _apiService.fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Pokédex"),
      ),
      body: FutureBuilder<List<PokemonListItem>>(
        future: _pokemonList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Wystąpił błąd:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Brak danych"));
          }

          final pokemons = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              final pokemon = pokemons[index];
              return PokemonCard(pokemon: pokemon);
            },
          );
        },
      ),
    );
  }
}
