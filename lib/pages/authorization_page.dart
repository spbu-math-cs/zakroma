import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/custom_scaffold.dart';
import 'package:zakroma_frontend/utility/rr_buttons.dart';

import '../data_cls/user.dart';
import '../main.dart';
import '../utility/styled_headline.dart';

class AuthorizationPage extends ConsumerStatefulWidget {
  const AuthorizationPage({super.key});

  @override
  ConsumerState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends ConsumerState<AuthorizationPage> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    // делаем системную панель навигации «прозрачной»
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Theme.of(context).colorScheme.primary,
        statusBarColor: Colors.transparent));
    final pageController = PageController();

    return CustomScaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => setState(() {
          currentPageIndex = index;
        }),
        children: const [LoginPage()],
      ),
    );
  }
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext text) {
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: constants.dBlockPadding
            .copyWith(top: constants.paddingUnit * 16, bottom: 0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Заголовок
              Expanded(
                  flex: 9,
                  child: Align(
                    alignment: Alignment.center,
                    child: StyledHeadline(
                      text: 'Закрома',
                      textStyle: Theme.of(context).textTheme.displayLarge,
                    ),
                  )),
              // Поле ввода почты
              Expanded(
                flex: 10,
                child: Padding(
                  padding: EdgeInsets.only(top: constants.paddingUnit * 3),
                  child: CustomTextFormField(
                      textEditingController: emailController,
                      validator: (value) {
                        return null;
                      },
                      hintText: 'Электронная почта'),
                ),
              ),
              // Поле ввода пароля
              Expanded(
                  flex: 7,
                  child: CustomTextFormField(
                      textEditingController: passwordController,
                      validator: (value) {
                        return null;
                      },
                      hintText: 'Пароль')),
              // Кнопка «Забыли пароль?»
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(bottom: constants.paddingUnit * 4),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Забыли пароль?',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            height: 1,
                          ),
                    ),
                  ),
                ),
              ),
              // Кнопка «Войти»
              Expanded(
                flex: 37,
                child: Padding(
                  padding: EdgeInsets.only(bottom: constants.paddingUnit * 32),
                  child: RRButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          debugPrint('email: ${emailController.text}');
                          debugPrint('password: ${passwordController.text}');
                          try {
                            await ref.read(userProvider.notifier).authorize(
                                emailController.text, passwordController.text);
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                          if (!context.mounted) return;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Zakroma()));
                        }
                      },
                      child: const Text('Войти')),
                ),
              ),
              // Кнопка регистрации
              Expanded(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.only(top: constants.paddingUnit * 2),
                  child: RRButton(
                    onTap: () {},
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'Нет аккаунта? ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(height: 1),
                            children: [
                              TextSpan(
                                text: 'Зарегистрируйтесь!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        height: 1),
                              )
                            ])),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends ConsumerWidget {
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final String hintText;

  const CustomTextFormField(
      {super.key,
      required this.textEditingController,
      required this.validator,
      required this.hintText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));

    return Padding(
      padding: EdgeInsets.only(bottom: constants.paddingUnit * 2),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.primaryContainer,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(constants.dInnerRadius),
          ),
          hintText: hintText,
          contentPadding: constants.dBlockPadding,
        ),
        controller: textEditingController,
        validator: validator,
      ),
    );
  }
}
