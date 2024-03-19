class Sport {
  String name;
  String league_code;
  int id;
  String term;

  Sport(
      {required this.name,
      required this.league_code,
      required this.id,
      required this.term});

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      name: json['name'],
      league_code: json['league_code'],
      id: json['id'],
      term: json['term'],
    );
  }
}
