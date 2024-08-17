import 'package:flutter/material.dart';

import 'create/create_droplet.dart';
import 'home/home_screen.dart';
import 'settings/setting_screen.dart';
import 'update/update_droplet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Droplet Manager",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late ValueNotifier<int> _currentTabNotifier;
  late PageController _pageController;

  @override
  void initState() {
    _currentTabNotifier = ValueNotifier<int>(0);
    _pageController = PageController();
    super.initState();
  }

  List<Widget> pages = [
    const HomeScreen(),
    const CreateDropletScreen(),
    const UpdateDropletScreen(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.red,
        body: PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          itemBuilder: (context, index) {
            return pages[index];
          },
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
            valueListenable: _currentTabNotifier,
            builder: (context, value, child) {
              return BottomNavigationBar(
                // backgroundColor: Colors.red,
                currentIndex: value,
                selectedItemColor: Colors.blue[900],
                unselectedItemColor: Colors.blue[200],
                showUnselectedLabels: true,
                onTap: (current) {
                  _pageController.jumpToPage(
                    current,
                  );
                  _currentTabNotifier.value = current;
                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    backgroundColor: Colors.blue[50],
                    label: "Home",
                    icon: const Icon(Icons.home),
                    activeIcon: const Icon(
                      Icons.home,
                    ),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.blue[50],
                    label: "Create",
                    icon: const Icon(Icons.add),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.blue[50],
                    label: "Update",
                    icon: const Icon(Icons.edit),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.blue[50],
                    label: "Setting",
                    icon: const Icon(Icons.settings),
                  ),
                ],
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    _currentTabNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
