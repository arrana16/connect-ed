class Game {
  String homeTeam;
  String homeabbr;
  String homeLogo;
  String awayTeam;
  String awayabbr;
  String awayLogo;
  DateTime date;
  String time;
  String homeScore;
  String awayScore;
  int sportsID;
  String sportsName;
  String term;
  String leagueCode;

  Game(
      {required this.homeTeam,
      required this.homeabbr,
      required this.homeLogo,
      required this.awayTeam,
      required this.awayabbr,
      required this.awayLogo,
      required this.date,
      required this.time,
      required this.homeScore,
      required this.awayScore,
      required this.sportsID,
      required this.sportsName,
      required this.term,
      required this.leagueCode});

  @override
  String toString() {
    return "Game: $sportsName Home: $homeTeam, Away: $awayTeam, Date: $date, Time: $time, Home Score: $homeScore, Away Score: $awayScore";
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    // ignore: non_constant_identifier_names
    DateTime game_date;
    String homeScore = json['home_score'] ?? '';
    homeScore = homeScore.split("(")[0];
    String awayScore = json['away_score'] ?? '';
    awayScore = awayScore.split("(")[0];

    if (homeScore == "Missing Score" || homeScore == "Missing") {
      homeScore = "";
    }
    if (awayScore == "Missing Score" || awayScore == "Missing") {
      awayScore = "";
    }
    try {
      game_date = DateTime.parse(json['game_date']);
    } catch (e) {
      game_date = DateTime.parse("2024-09-08");
    }
    return Game(
      homeTeam: json['home_name'] ?? '',
      homeabbr: json['home_abbr'] ?? '',
      homeLogo: json['home_logo'] ?? '',
      awayTeam: json['away_name'] ?? '',
      awayabbr: json['away_abr'] ?? '',
      awayLogo: json['away_logo'] ?? '',
      date: game_date,
      time: json['game_time'] ?? '',
      homeScore: homeScore,
      awayScore: awayScore,
      sportsID: json['sports_id'] ?? 0,
      sportsName: json['sports_name'] ?? "",
      term: json['term'] ?? "",
      leagueCode: json['league_code'] ?? "",
    );
  }
}
