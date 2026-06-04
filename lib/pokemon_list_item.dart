class PokemonListItem {
  final String name;
  final String id;
  final String imageUrl;

  PokemonListItem({
    required this.name,
    required this.id,
    required this.imageUrl,
  });

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    final rawName = json["name"].toString();
    final name = rawName[0].toUpperCase() + rawName.substring(1);

    final urlSegments = json['url'].split('/');
    final id = urlSegments[urlSegments.length - 2];
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return PokemonListItem(name: name, id: id, imageUrl: imageUrl);
  }
}
