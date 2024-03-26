class Standing {
  int tableNum;
  int wins;
  int losses;
  int ties;
  int points;
  String school_name;
  String school_abbr;
  String logo;
  int sportID;

  Standing({
    required this.tableNum,
    required this.wins,
    required this.losses,
    required this.ties,
    required this.points,
    required this.school_name,
    required this.school_abbr,
    required this.logo,
    required this.sportID,
  });

  factory Standing.fromJson(Map<String, dynamic> json) {
    return Standing(
      tableNum: json['table_num'],
      wins: json['wins'],
      losses: json['losses'],
      ties: json['ties'],
      points: json['points'],
      school_name: json['school_name'],
      school_abbr: json['abbreviation'],
      logo: json['logo_dir'],
      sportID: json['sport_id'],
    );
  }
}
