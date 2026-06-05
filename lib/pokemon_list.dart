import "package:flutter/material.dart";
import "package:pokeflutter/poke_api_service.dart";
import "package:pokeflutter/pokemon_card.dart";
import "package:pokeflutter/pokemon_list_item.dart";
import "package:pokeflutter/favourites_list.dart";
import "package:pokeflutter/settings.dart";

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  late Future<List<PokemonListItem>> _pokemonList;

  @override
  void initState() {
    super.initState();
    _pokemonList = PokeApiService.fetchPokemonList();
  }

  Future<void> _refreshData() async {
    final refreshedList = PokeApiService.fetchPokemonList();
    setState(() {
      _pokemonList = refreshedList;
    });
    await refreshedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Pokédex"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavouritesList()),
              ).then((_) {
                setState(() {});
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),
        ],
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
                  "An error occured:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }

          final pokemons = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
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
            ),
          );
        },
      ),
    );
  }
}
