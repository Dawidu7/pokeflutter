class PokemonListItem {
  final String name;
  final String id;
  final String index;
  final String imageUrl;

  PokemonListItem({
    required this.name,
    required this.id,
    required this.index,
    required this.imageUrl,
  });

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    final rawName = json["name"].toString();
    final name = rawName[0].toUpperCase() + rawName.substring(1);

    final urlSegments = json['url'].split('/');
    final String id = urlSegments[urlSegments.length - 2];
    final index = "#${id.padLeft(4, '0')}";
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return PokemonListItem(
      name: name,
      id: id,
      index: index,
      imageUrl: imageUrl,
    );
  }
}
