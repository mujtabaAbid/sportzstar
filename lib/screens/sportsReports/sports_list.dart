import 'package:flutter/material.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/screens/sportsReports/basketball_report.dart';
import 'package:sportzstar/screens/sportsReports/football_report.dart';
import 'package:sportzstar/screens/sportsReports/handball_report.dart';
import 'package:sportzstar/screens/sportsReports/hockey_report.dart';
import 'package:sportzstar/screens/sportsReports/rugby_report.dart';
import 'package:sportzstar/screens/sportsReports/volleyball_report.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'baseball_report.dart';

class SportsList extends StatelessWidget {
  const SportsList({super.key});

  @override
  Widget build(BuildContext context) {
    final sports = [
      {
        "title": "Baseball",
        "icon": Icons.sports_baseball,
        "widget": const BaseballWidgetScreen(),
      },
      {
        "title": "Basketball",
        "icon": Icons.sports_basketball,
        "widget": const BasketballWidget(),
      },
      {
        "title": "Football",
        "icon": Icons.sports_football,
        "widget": const FootballWidget(),
      },
      {
        "title": "Handball",
        "icon": Icons.sports_handball,
        "widget": const HandballWidget(),
      },
      {
        "title": "Hockey",
        "icon": Icons.sports_hockey,
        "widget": const HockeyWidget(),
      },
      {
        "title": "Rugby",
        "icon": Icons.sports_rugby,
        "widget": const RugbyWidget(),
      },
      {
        "title": "Volleyball",
        "icon": Icons.sports_volleyball,
        "widget": const VolleyballWidget(),
      },
    ];

    return MainLayoutWidget(
      isLoading: false,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Sports Reports',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        // color: Colors.amber,
        padding: const EdgeInsets.all(12.0),
        child: ListView.separated(
          itemCount: sports.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final sport = sports[index];
            return Card(
              color: const Color.fromARGB(141, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: ListTile(
                leading: Icon(
                  sport["icon"] as IconData,
                  color: Palette.facebookColor,
                  size: 30,
                ),
                title: Text(
                  sport["title"].toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Palette.facebookColor,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => sport["widget"] as Widget,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
