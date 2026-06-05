import "dart:convert";
import "package:hive_ce/hive.dart";
import "package:http/http.dart" as http;
import "package:pokeflutter/pokemon_details_model.dart";
import "package:pokeflutter/pokemon_list_item.dart";

class PokeApiService {
  static final Box _pokemonList = Hive.box("pokemon_list");
  static final Box _pokemonDetails = Hive.box("pokemon_details");
  static final Box _favourites = Hive.box("favourites");

  static Future<List<PokemonListItem>> fetchPokemonList() async {
    const url = "https://pokeapi.co/api/v2/pokemon?limit=151";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Błąd API: ${response.statusCode}");
      }

      final data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];

      await _pokemonList.put("cache", results);

      return results
          .map((json) => PokemonListItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (_pokemonList.containsKey("cache")) {
        final List<dynamic> cachedList = _pokemonList.get("cache");
        return cachedList
            .map(
              (json) =>
                  PokemonListItem.fromJson(Map<String, dynamic>.from(json)),
            )
            .toList();
      }
      throw Exception("Couldn't fetch list: $e");
    }
  }

  static Future<PokemonDetailsModel> fetchPokemonDetails(String id) async {
    final url = "https://pokeapi.co/api/v2/pokemon/$id";
    final cacheKey = "cache_$id";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Błąd API: ${response.statusCode}");
      }

      final data = jsonDecode(response.body);

      await _pokemonDetails.put(cacheKey, data);

      return PokemonDetailsModel.fromJson(data);
    } catch (e) {
      if (_pokemonDetails.containsKey(cacheKey)) {
        final cachedData = _pokemonDetails.get(cacheKey);
        return PokemonDetailsModel.fromJson(
          Map<String, dynamic>.from(cachedData),
        );
      }

      throw Exception("Couldn't fetch details: $e");
    }
  }

  static bool isFavourite(String id) {
    return _favourites.containsKey(id);
  }

  static Future<void> toggleFavourite(PokemonListItem pokemon) async {
    if (isFavourite(pokemon.id)) {
      return await _favourites.delete(pokemon.id);
    }
    await _favourites.put(pokemon.id, {
      "name": pokemon.name.toLowerCase(),
      "url": "https://pokeapi.co/api/v2/pokemon/${pokemon.id}/",
    });
  }

  static List<PokemonListItem> getFavourites() {
    return _favourites.values
        .map(
          (json) =>
              PokemonListItem.fromJson(Map<String, dynamic>.from(json as Map)),
        )
        .toList();
  }
}
