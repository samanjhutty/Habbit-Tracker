import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habbit_tracker/controller/binding.dart';
import 'package:habbit_tracker/model/habit_model.dart';
import 'package:habbit_tracker/view/pages/add_habit.dart';
import 'package:habbit_tracker/view/pages/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controller/local/db_constants.dart';
import 'view/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitModelAdapter());
  box = await Hive.openBox<List<HabitModel>>(BoxConstants.boxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBinding(),
      routes: {
        '/': (p0) => const MyHomePage(),
        '/user': (p0) => const UserProfile(),
        '/add-habit': (p0) => const AddHabit()
      },
      title: 'Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFE5A75), secondary: Colors.grey[350]),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFE5A75),
            brightness: Brightness.dark,
            secondary: Colors.grey[850]),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> _tabs = [
    const Tab(text: 'Home'),
    const Tab(text: 'Me'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    var device = MediaQuery.of(context);
    return Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: const [MyHomeTab(), UserProfile()],
        ),
        bottomNavigationBar: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: scheme.primaryContainer),
          tabs: _tabs,
          indicatorPadding: EdgeInsets.symmetric(
              vertical: 4, horizontal: device.size.width * 0.13),
          controller: _tabController,
          labelColor: scheme.onPrimaryContainer,
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        ));
  }
}
