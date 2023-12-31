import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habbit_tracker/controller/bindings.dart';
import 'package:habbit_tracker/controller/local/db_controller.dart';
import 'package:habbit_tracker/model/habit_model.dart';
import 'package:habbit_tracker/view/pages/add_habit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'assets/assets.dart';
import 'controller/cloud/profile_controller.dart';
import 'controller/cloud/signin_controller.dart';
import 'controller/cloud/signup_controller.dart';
import 'controller/local/db_constants.dart';
import 'view/pages/mobile_login.dart';
import 'view/pages/otp_page.dart';
import 'view/pages/reauth.dart';
import 'view/pages/signin.dart';
import 'view/pages/signup.dart';
import 'view/pages/update_profile.dart';
import 'view/tabs/user.dart';
import 'view/tabs/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controller/cloud/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(HabitModelAdapter());
  box = await Hive.openBox(BoxConstants.boxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => SignUpAuth()),
        ChangeNotifierProvider(create: (context) => SignInAuth()),
        ChangeNotifierProvider(create: (context) => MyWidgets())
      ],
      child: GetMaterialApp(
        initialBinding: ControllerBinding(),
        routes: {
          '/': (p0) => const MyHomePage(),
          '/user': (p0) => const UserProfile(),
          '/add-habit': (p0) => const AddHabit(),
          '/mobile': (p0) => const MobileLogin(),
          '/otppage': (p0) => const OTPPage(),
          '/profile': (p0) => const UpdateProfile(),
          '/signin': (p0) => const SignIn(),
          '/signup': (p0) => const SignUp(),
          '/reauth': (p0) => const ReAuthenticate()
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
  DbController dbController = Get.find();

  final List<Tab> _tabs = [
    const Tab(text: 'Home'),
    const Tab(text: 'Me'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);
    if (box.get(BoxConstants.startDateKey) == null) {
      box.put(BoxConstants.startDateKey,
          DbController.habbitListKey(DateTime.now()));
    }
    _getList();
    super.initState();
  }

  _getList() async {
    List localList = await box
            .get(BoxConstants.habitListKeyText +
                DbController.habbitListKey(DateTime.now()))
            .map((e) => e as HabitModel)
            .toList() ??
        <HabitModel>[];

    setState(() {
      dbController.habitList = localList.cast<HabitModel>();
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    var device = MediaQuery.of(context).size;
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [MyHomeTab(), UserProfile()],
      ),
      bottomNavigationBar: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: ShapeDecoration(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: scheme.primary),
        tabs: _tabs,
        indicatorPadding:
            EdgeInsets.symmetric(vertical: 4, horizontal: device.width * 0.13),
        controller: _tabController,
        labelColor: scheme.onPrimary,
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () => Get.toNamed('/add-habit'),
        tooltip: 'Create a Habbit',
        child: const Icon(Icons.add_task_rounded),
      ),
    );
  }
}
