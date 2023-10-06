import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'text.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const serverIP = '';
  static const serverPort = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
          colorScheme: const ColorScheme.dark().copyWith(
              primary: Colors.white, background: const Color(0xFFFFB96C)),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'Preslav', color: Colors.black),
            displayMedium:
                TextStyle(fontFamily: 'Preslav', color: Colors.black),
            displaySmall: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          )),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        // set system navigation bar color to transparent
        SystemUiOverlayStyle.dark
            .copyWith(systemNavigationBarColor: Theme.of(context).colorScheme.background));

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constrains) {
      final notificationBarHeight = MediaQuery.of(context).viewPadding.top;
      final availableHeight = constrains.maxHeight -
          notificationBarHeight -
          MediaQuery.of(context).viewPadding.bottom;
      final statusHeight = availableHeight / 6;
      final todayHeight = 2 * availableHeight / 6 + statusHeight;
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        // bottomNavigationBar: NavigationBar(
        //   onDestinationSelected: (int index) {
        //   },
        //   backgroundColor: Colors.white,
        //   indicatorColor: Colors.white,
        //   indicatorShape: const CircleBorder(),
        //   labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        //   destinations: const <Widget>[
        //     NavigationDestination(
        //       icon: Icon(Icons.favorite_border, color: Color(0xfffeba6c),),
        //       label: 'Favourite',
        //     ),
        //     NavigationDestination(
        //       icon: Icon(Icons.add, color: Color(0xfffeba6c),),
        //       label: 'Add',
        //     ),
        //     NavigationDestination(
        //       icon: Icon(Icons.settings_outlined, color: Color(0xfffeba6c),),
        //       label: 'Settings',
        //     ),
        //   ],
        // ),
        body: Padding(
          padding: EdgeInsets.only(top: notificationBarHeight),
          child: Column(
            children: [
              SizedBox(
                width: constrains.maxWidth,
                height: statusHeight / 2,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: formatHeadline(
                      context,
                      Theme.of(context).textTheme.displayMedium!.copyWith(),
                      'Закрома'
                  )
                ),
              ),
              SizedBox(
                width: constrains.maxWidth,
                height: statusHeight,
                child: const Placeholder(),
              ),
              SizedBox(
                width: constrains.maxWidth,
                height: statusHeight,
                child: const Placeholder(),
              ),
              SizedBox(
                width: constrains.maxWidth,
                height: todayHeight,
                child: const Placeholder(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: constrains.maxWidth,
                  height: statusHeight / 2,
                  child: const Placeholder(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
