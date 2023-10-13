import 'package:flutter/material.dart';
import 'zakroma_app.dart';

// TODO: доделать главный экран
// TODO: продукт свёрнутый (миниатюра, которая нужна в списке продуктов)
// TODO: продукт развёрнутый (раскрывается при нажатии? нужен где??)
// TODO: страница составления рациона (список блюд)
// TODO: корзина (список продуктов для покупки)
// TODO: окно входа
// TODO: холодильник

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
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light().copyWith(
            primary: Colors.white,
            onPrimary: Colors.black,
            background: const Color(0xFFFFB96C),
            surface: Colors.white,
            surfaceTint: Colors.white,
            onSurface: Colors.black,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'Preslav', color: Colors.black),
            displayMedium:
                TextStyle(fontFamily: 'Preslav', color: Colors.black),
            displaySmall: TextStyle(fontFamily: 'Preslav', color: Colors.black),
            headlineLarge:
                TextStyle(fontFamily: 'Preslav', color: Colors.black),
            headlineMedium:
                TextStyle(fontFamily: 'Preslav', color: Colors.black),
            headlineSmall:
                TextStyle(fontFamily: 'Preslav', color: Colors.black),
            titleLarge: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            titleMedium: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            titleSmall: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            labelLarge: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            labelMedium: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            labelSmall: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            bodyLarge: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            bodyMedium: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            bodySmall: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
          ),
          navigationBarTheme: const NavigationBarThemeData(
            height: 65,
            backgroundColor: Colors.white,
            indicatorColor: Colors.transparent,
            indicatorShape: CircleBorder(),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            iconTheme: MaterialStatePropertyAll(IconThemeData(
              color: Color(0xFFFFB96C),
              size: 45,
            )),
          )),
      home: const Zakroma(),
    );
  }
}
