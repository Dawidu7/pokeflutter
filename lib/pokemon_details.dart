import "package:flutter/material.dart";
import "package:pokeflutter/poke_api_service.dart";
import "package:pokeflutter/pokemon_details_model.dart";
import "package:pokeflutter/pokemon_list_item.dart";

class PokemonDetails extends StatefulWidget {
  final PokemonListItem pokemon;

  const PokemonDetails({super.key, required this.pokemon});

  @override
  State<PokemonDetails> createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails> {
  late Future<PokemonDetailsModel> _pokemonDetails;

  @override
  void initState() {
    super.initState();
    _pokemonDetails = PokeApiService.fetchPokemonDetails(widget.pokemon.id);
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case "normal":
        return const Color(0xFFA8A878);
      case "fire":
        return const Color(0xFFF08030);
      case "water":
        return const Color(0xFF6890F0);
      case "electric":
        return const Color(0xFFF8D030);
      case "grass":
        return const Color(0xFF78C850);
      case "ice":
        return const Color(0xFF98D8D8);
      case "fighting":
        return const Color(0xFFC03028);
      case "poison":
        return const Color(0xFFA040A0);
      case "ground":
        return const Color(0xFFE0C068);
      case "flying":
        return const Color(0xFFA890F0);
      case "psychic":
        return const Color(0xFFF85888);
      case "bug":
        return const Color(0xFFA8B820);
      case "rock":
        return const Color(0xFFB8A038);
      case "ghost":
        return const Color(0xFF705898);
      case "dragon":
        return const Color(0xFF7038F8);
      case "dark":
        return const Color(0xFF705848);
      case "steel":
        return const Color(0xFFB8B8D0);
      case "fairy":
        return const Color(0xFFEE99AC);
      default:
        return Colors.grey;
    }
  }

  Widget _buildTypeChip(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: _getTypeColor(type),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        type.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              "$value",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value / 255,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonDetailsModel>(
      future: _pokemonDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Błąd")),
            body: Center(
              child: Text(
                "Wystąpił błąd:\n${snapshot.error}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final details = snapshot.data!;
        final primaryColor = _getTypeColor(details.types.first);

        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  color: primaryColor,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 200),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    top: 80,
                    left: 24,
                    right: 24,
                    bottom: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.pokemon.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.pokemon.index,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: details.types
                            .map((t) => _buildTypeChip(t))
                            .toList(),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoColumn("Waga", "${details.weight} KG"),
                          _buildInfoColumn("Wzrost", "${details.height} M"),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Statystyki (Base Stats)",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildStatRow("HP", details.hp, primaryColor),
                      _buildStatRow("ATK", details.atk, primaryColor),
                      _buildStatRow("DEF", details.def, primaryColor),
                      _buildStatRow("SATK", details.spAtk, primaryColor),
                      _buildStatRow("SDEF", details.spDef, primaryColor),
                      _buildStatRow("SPD", details.speed, primaryColor),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.network(
                      widget.pokemon.imageUrl,
                      height: 230,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
