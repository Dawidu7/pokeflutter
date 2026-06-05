import "package:flutter/material.dart";
import "package:hive_ce_flutter/hive_flutter.dart";
import "package:pokeflutter/pokemon_list.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("pokemon_list");
  await Hive.openBox("pokemon_details");
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
