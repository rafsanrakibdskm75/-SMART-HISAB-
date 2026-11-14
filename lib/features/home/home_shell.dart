import 'package:flutter/material.dart';
import '../collection/today_collection_screen.dart';
import '../daily/daily_hisab_screen.dart';
import '../daily/daily_history_screen.dart';
import '../modules/services_hub_screen.dart';
import '../persons/person_list_screen.dart';

/// Bottom-navigation shell (DESIGN.md: 88px bottom clearance, center action).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  static const _pages = [
    DailyHisabScreen(),
    PersonListScreen(),
    TodayCollectionScreen(),
    ServicesHubScreen(),
    DailyHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.book), label: 'দৈনিক হিসাব'),
          NavigationDestination(icon: Icon(Icons.people), label: 'ব্যক্তি'),
          NavigationDestination(icon: Icon(Icons.collections_bookmark), label: 'আদায়'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'সেবা'),
          NavigationDestination(icon: Icon(Icons.history), label: 'ইতিহাস'),
        ],
      ),
    );
  }
}
