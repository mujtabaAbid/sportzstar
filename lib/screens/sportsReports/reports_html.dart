import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

class BaseballGamesScreen extends StatefulWidget {
  const BaseballGamesScreen({super.key});

  @override
  State<BaseballGamesScreen> createState() => _BaseballGamesScreenState();
}

class _BaseballGamesScreenState extends State<BaseballGamesScreen> {
  List games = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    final response = await http.get(
      Uri.parse("https://v1.basketball.api-sports.io/games?date=2025-08-21"),
      headers: {"x-apisports-key": "42a10dd9641d44738f11510755906690"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        games = data["response"];
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: loading,
      appBar: AppBar(
        title: const Text(
          "Baseball Games",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body:
      // loading
      //     ? const Center(child: CircularProgressIndicator())
      //     :
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: EdgeInsets.all(12),
        child: ListView(children: _buildLeagueSections()),
      ),
    );
  }

  List<Widget> _buildLeagueSections() {
    // group by league
    Map<String, List> leagues = {};
    for (var g in games) {
      String league = g["league"]["name"] ?? "Unknown League";
      leagues.putIfAbsent(league, () => []);
      leagues[league]!.add(g);
    }

    List<Widget> sections = [];
    leagues.forEach((league, leagueGames) {
      sections.add(
        Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            "🇺🇸 $league",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

      for (var game in leagueGames) {
        sections.add(_buildGameRow(game));
      }
    });

    return sections;
  }

  Widget _buildGameRow(dynamic game) {
    final home = game["teams"]["home"];
    final away = game["teams"]["away"];
    final status = game["status"]["short"]; // "FT", "NS", etc.
    final scores = game["scores"];

    final homeScore = scores?["home"]?["total"];
    final awayScore = scores?["away"]?["total"];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Text(
              status,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _teamRow(
                  home["name"],
                  homeScore,
                  isWinner: (homeScore ?? 0) > (awayScore ?? 0),
                ),
                _teamRow(
                  away["name"],
                  awayScore,
                  isWinner: (awayScore ?? 0) > (homeScore ?? 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamRow(
    String teamName,
    dynamic totalScore, {
    bool isWinner = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              teamName,
              style: TextStyle(
                fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            totalScore?.toString() ?? "-",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
