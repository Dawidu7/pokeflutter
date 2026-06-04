class PokemonDetailsModel {
  final double weight;
  final double height;
  final List<String> types;
  final int hp;
  final int atk;
  final int def;
  final int spAtk;
  final int spDef;
  final int speed;

  PokemonDetailsModel({
    required this.weight,
    required this.height,
    required this.types,
    required this.hp,
    required this.atk,
    required this.def,
    required this.spAtk,
    required this.spDef,
    required this.speed,
  });

  factory PokemonDetailsModel.fromJson(Map<String, dynamic> json) {
    final double weightKg = (json["weight"]) / 10;
    final double heightM = (json["height"]) / 10;

    final List<dynamic> types = json["types"];
    final List<String> typeNames = types.map((t) {
      final String rawType = t["type"]["name"].toString();
      return rawType[0].toUpperCase() + rawType.substring(1);
    }).toList();

    final List<dynamic> stats = json["stats"];
    int getStat(String statName) {
      final stat = stats.firstWhere((s) => s["stat"]["name"] == statName);
      return stat["base_stat"];
    }

    return PokemonDetailsModel(
      weight: weightKg,
      height: heightM,
      types: typeNames,
      hp: getStat("hp"),
      atk: getStat("attack"),
      def: getStat("defense"),
      spAtk: getStat("special-attack"),
      spDef: getStat("special-defense"),
      speed: getStat("speed"),
    );
  }
}
