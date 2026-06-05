import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:hive_ce_flutter/hive_flutter.dart";
import "package:pokeflutter/firebase_options.dart";
import "package:pokeflutter/pokemon_list.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await Hive.initFlutter();
  await Hive.openBox("pokemon_list");
  await Hive.openBox("pokemon_details");
  await Hive.openBox("favourites");
  runApp(const Pokedex());
}

class Pokedex extends StatelessWidget {
  const Pokedex({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pokédex",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const PokemonList(),
    );
  }
}
