import "package:cached_network_image/cached_network_image.dart";
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

  void _retryFetch() {
    setState(() {
      _pokemonDetails = PokeApiService.fetchPokemonDetails(widget.pokemon.id);
    });
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
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          SizedBox(
            width: 40,
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              PokeApiService.isFavourite(widget.pokemon.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            onPressed: () async {
              await PokeApiService.toggleFavourite(widget.pokemon);
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<PokemonDetailsModel>(
        future: _pokemonDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Oh no! The wild Pokémon fled.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Please check your internet connection and try again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _retryFetch,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Try Again"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final details = snapshot.data!;
          final primaryColor = _getTypeColor(details.types.first);

          return SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  color: primaryColor,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 220),
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
                          _buildInfoColumn("Weight", "${details.weight} kg"),
                          _buildInfoColumn("Height", "${details.height} m"),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Stats",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildStatRow("HP", details.hp, primaryColor),
                      _buildStatRow("Attack", details.atk, primaryColor),
                      _buildStatRow("Defense", details.def, primaryColor),
                      _buildStatRow(
                        "Special Attack",
                        details.spAtk,
                        primaryColor,
                      ),
                      _buildStatRow(
                        "Special Defense",
                        details.spDef,
                        primaryColor,
                      ),
                      _buildStatRow("Speed", details.speed, primaryColor),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: widget.pokemon.imageUrl,
                      height: 230,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
