import 'package:flutter/material.dart';
import 'homepage.dart';

// TODO: доделать главный экран
// TODO: при перевороте экрана статус-бары перемещаются в горизонтальную раскладку
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

        brightness: Brightness.light,
        colorScheme: const ColorScheme.light().copyWith(
            primary: Colors.white,
            onPrimary: Colors.black,
            background: const Color(0xFFFFB96C)
        ),
        useMaterial3: true,
         textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          displayMedium: TextStyle(fontFamily: 'Preslav',
                                   color: Colors.black),
          displaySmall: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          headlineLarge: TextStyle(fontFamily: 'Preslav',
                                   color: Colors.black),
          headlineMedium: TextStyle(fontFamily: 'Preslav',
                                    color: Colors.black),
          headlineSmall: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          titleLarge: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                color: Colors.black),
          titleMedium: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                 color: Colors.black),
          titleSmall: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                color: Colors.black),
          labelLarge: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                color: Colors.black),
          labelMedium: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                 color: Colors.black),
          labelSmall: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                color: Colors.black),
          bodyLarge: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                               color: Colors.black),
          bodyMedium: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                color: Colors.black),
          bodySmall: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                               color: Colors.black),
        )
      ),
      home: const ZakromaHomePage(),
    );
  }
}
