import "package:flutter/material.dart";
import "package:pokeflutter/pokemon_list.dart";

void main() {
  runApp(const Pokedex());
}

class Pokedex extends StatelessWidget {
  const Pokedex({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pokedex",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const PokemonList(),
    );
  }
}
