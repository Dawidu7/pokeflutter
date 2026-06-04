import "dart:convert";
import "package:http/http.dart" as http;
import 'package:pokeflutter/pokemon_list_item.dart';

class PokeApiService {
  Future<List<PokemonListItem>> fetchPokemonList() async {
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
      throw Exception(
        "Brak połączenia z internetem i brak zapisanych danych. Spróbuj ponownie później.",
      );
    }
  }
}
