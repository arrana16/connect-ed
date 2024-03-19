class Game {
  String homeTeam;
  String homeabbr;
  String homeLogo;
  String awayTeam;
  String awayabbr;
  String awayLogo;
  String date;
  String time;
  String homeScore;
  String awayScore;
  int sportsID;
  String sportsName;

  Game({
    required this.homeTeam,
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
  });

  @override
  String toString() {
    return "Game: $sportsName Home: $homeTeam, Away: $awayTeam, Date: $date, Time: $time, Home Score: $homeScore, Away Score: $awayScore";
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      homeTeam: json['home_name'] ?? '',
      homeabbr: json['home_abbr'] ?? '',
      homeLogo: json['home_logo'] ?? '',
      awayTeam: json['away_name'] ?? '',
      awayabbr: json['away_abbr'] ?? '',
      awayLogo: json['away_logo'] ?? '',
      date: json['game_date'] ?? '',
      time: json['game_time'] ?? '',
      homeScore: json['home_score'] ?? '',
      awayScore: json['away_score'] ?? '',
      sportsID: json['sports_id'] ?? 0,
      sportsName: json['sports_name'] ?? "",
    );
  }
}
