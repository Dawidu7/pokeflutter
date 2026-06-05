import "package:flutter/material.dart";
import "package:pokeflutter/poke_api_service.dart";
import "package:pokeflutter/pokemon_card.dart";
import "package:pokeflutter/pokemon_list_item.dart";

class FavouritesList extends StatefulWidget {
  const FavouritesList({super.key});

  @override
  State<FavouritesList> createState() => _FavouritesListState();
}

class _FavouritesListState extends State<FavouritesList> {
  List<PokemonListItem> _favourites = [];

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  void _loadFavourites() {
    setState(() {
      _favourites = PokeApiService.getFavourites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite Pokémon"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _favourites.isEmpty
          ? const Center(
              child: Text(
                "No favourite pokemon found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: _favourites.length,
              itemBuilder: (context, index) {
                final pokemon = _favourites[index];
                return PokemonCard(pokemon: pokemon);
              },
            ),
    );
  }
}
