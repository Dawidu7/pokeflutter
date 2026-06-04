import "dart:convert";
import "package:http/http.dart" as http;
import "package:pokeflutter/pokemon_details_model.dart";
import 'package:pokeflutter/pokemon_list_item.dart';

class PokeApiService {
  static Future<List<PokemonListItem>> fetchPokemonList() async {
    const url = "https://pokeapi.co/api/v2/pokemon?limit=151";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Błąd API: ${response.statusCode}");
      }

      final data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];

      return results
          .map((json) => PokemonListItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Nie udało się pobrać listy: $e");
    }
  }

  static Future<PokemonDetailsModel> fetchPokemonDetails(String id) async {
    final url = "https://pokeapi.co/api/v2/pokemon/$id";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Błąd API: ${response.statusCode}");
      }

      final data = jsonDecode(response.body);
      return PokemonDetailsModel.fromJson(data);
    } catch (e) {
      throw Exception("Nie udało się pobrać szczegółów: $e");
    }
  }
}
