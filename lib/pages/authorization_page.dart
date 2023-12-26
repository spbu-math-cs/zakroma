import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/custom_scaffold.dart';
import 'package:zakroma_frontend/utility/rr_buttons.dart';

import '../data_cls/user.dart';
import '../main.dart';
import '../utility/pair.dart';
import '../utility/styled_headline.dart';

const fieldExtension =
    3; // вертикальное расширение поля ввода при некорректном вводе

class AuthorizationPage extends ConsumerStatefulWidget {
  const AuthorizationPage({super.key});

  @override
  ConsumerState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends ConsumerState<AuthorizationPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final extendFields = Pair(false, false);
  final interactedWithFields = Pair(false, false);

  @override
  Widget build(BuildContext text) {
    // делаем системную панель навигации «прозрачной»
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Theme.of(context).colorScheme.primary,
        statusBarColor: Colors.transparent));

    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));

    return CustomScaffold(
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
                flex: 10 + (extendFields.first ? fieldExtension : 0),
                child: Padding(
                  padding: EdgeInsets.only(top: constants.paddingUnit * 3),
                  child: CustomTextFormField(
                      textEditingController: emailController,
                      validator: (value) {
                        interactedWithFields.first = true;
                        return _validateEmail(value);
                      },
                      hintText: 'Электронная почта'),
                ),
              ),
              // Поле ввода пароля
              Expanded(
                  flex: 7 + (extendFields.second ? fieldExtension : 0),
                  child: CustomTextFormField(
                      textEditingController: passwordController,
                      validator: (value) {
                        interactedWithFields.second = true;
                        return _validatePassword(value);
                      },
                      hintText: 'Пароль')),
              // Кнопка «Забыли пароль?»
              // TODO(func): реализовать нажатие на кнопку
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
                flex: 37 -
                    (extendFields.first ? fieldExtension : 0) -
                    (extendFields.second ? fieldExtension : 0),
                child: RRButton(
                    padding: EdgeInsets.only(
                        bottom: constants.paddingUnit *
                            (32 -
                                (extendFields.first ? fieldExtension : 0) -
                                (extendFields.second ? fieldExtension : 0))),
                    onTap: () async {
                      setState(() {
                        interactedWithFields.first =
                            interactedWithFields.second = true;
                        // хз, почему notifyListeners помечен как visibleForTesting
                        emailController.notifyListeners();
                        passwordController.notifyListeners();
                      });
                      if (formKey.currentState!.validate()) {
                        try {
                          await ref.read(userProvider.notifier).authorize(
                              emailController.text, passwordController.text);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                        if (!context.mounted) return;
                        FocusManager.instance.primaryFocus
                            ?.unfocus(); // убираем клавиатуру
                        // делаем системную панель навигации «прозрачной» — почему-то она не меняет цвет при переходе на главную
                        SystemChrome.setSystemUIOverlayStyle(
                            SystemUiOverlayStyle.light.copyWith(
                                systemNavigationBarColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                statusBarColor: Colors.transparent));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Zakroma()));
                      }
                    },
                    child: const Text('Войти')),
              ),
              // Кнопка регистрации
              Expanded(
                flex: 7,
                child: RRButton(
                  padding: EdgeInsets.only(top: constants.paddingUnit * 2),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegistrationPage()));
                  },
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
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {
          if (emailController.value.text.isNotEmpty) {
            // чтобы поле не расширялось при первом получении фокуса
            interactedWithFields.first = true;
          }
          extendFields.first = interactedWithFields.first &&
              _validateEmail(emailController.value.text) != null;
        }));
    passwordController.addListener(() => setState(() {
          extendFields.second = interactedWithFields.second &&
              _validatePassword(passwordController.value.text) != null;
        }));
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();
  final nameFormKey = GlobalKey<FormState>();
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final interactedWithFields = [false, false, false, false, false];
  final extendFields = [false, false, false, false, false];
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));

    return CustomScaffold(
      topNavigationBar: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          onPressed: () {
            if (currentPageIndex == 0) {
              Navigator.of(context).pop();
            } else {
              setState(() {
                currentPageIndex--;
              });
            }
          },
          icon: const Icon(Icons.arrow_back_ios),
          padding: EdgeInsets.zero,
        ),
      ),
      body: Padding(
        padding: constants.dBlockPadding,
        child: [
          _getNamePage(constants),
          _getEmailPage(constants),
          _getPasswordPage(constants)
        ][currentPageIndex],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(() => setState(() {
          if (firstNameController.value.text.isNotEmpty) {
            interactedWithFields[0] = true;
          }
          extendFields[0] = interactedWithFields[0] &&
              _validateName(firstNameController.value.text) != null;
        }));
    secondNameController.addListener(() => setState(() {
          if (secondNameController.value.text.isNotEmpty) {
            interactedWithFields[1] = true;
          }
          extendFields[1] = interactedWithFields[1] &&
              _validateName(secondNameController.value.text) != null;
        }));
    emailController.addListener(() => setState(() {
          if (emailController.value.text.isNotEmpty) {
            interactedWithFields[2] = true;
          }
          extendFields[2] = interactedWithFields[2] &&
              _validateEmail(emailController.value.text) != null;
        }));
    passwordController.addListener(() => setState(() {
          extendFields[3] =
              interactedWithFields[3] && passwordController.value.text.isEmpty;
        }));
    passwordRepeatController.addListener(() => setState(() {
          extendFields[4] = interactedWithFields[4] &&
              (passwordController.value.text !=
                  passwordRepeatController.value.text);
        }));
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    secondNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordRepeatController.dispose();
  }

  Widget _getNamePage(Constants constants) => Form(
        key: nameFormKey,
        child: Column(
          children: [
            // Заголовок
            SizedBox(
                height: constants.paddingUnit * 9,
                child: Padding(
                  padding: EdgeInsets.only(bottom: constants.paddingUnit * 1),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text('Как мы можем\nк Вам обращаться?',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1,
                            )),
                  ),
                )),
            // Поясняющий текст
            Flexible(
                child: Padding(
              padding: EdgeInsets.only(bottom: constants.paddingUnit * 3),
              child: Text(
                'Пожалуйста, введите свои имя и фамилию.\nОни будут видны другим пользователям.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      height: 1,
                    ),
              ),
            )),
            // Поле ввода имени
            SizedBox(
              height: constants.paddingUnit * 7 +
                  (extendFields[0] ? fieldExtension : 0) *
                      8, // константа 8 подобрана на глаз
              child: CustomTextFormField(
                  textEditingController: firstNameController,
                  validator: (value) {
                    interactedWithFields[0] = true;
                    return _validateName(value);
                  },
                  hintText: 'Имя'),
            ),
            // Поле ввода фамилии
            SizedBox(
                height: constants.paddingUnit * 8 +
                    (extendFields[1] ? fieldExtension : 0) *
                        8, // константа 8 подобрана на глаз
                child: Padding(
                  padding: EdgeInsets.only(bottom: constants.paddingUnit),
                  child: CustomTextFormField(
                      textEditingController: secondNameController,
                      validator: (value) {
                        interactedWithFields[1] = true;
                        return _validateName(value, true);
                      },
                      hintText: 'Фамилия'),
                )),
            // Кнопка «Далее»
            SizedBox(
              height: constants.paddingUnit * 5,
              child: RRButton(
                  onTap: () async {
                    setState(() {
                      interactedWithFields[0] = interactedWithFields[1] = true;
                      firstNameController.notifyListeners();
                      secondNameController.notifyListeners();
                    });
                    if (nameFormKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus
                          ?.unfocus(); // убираем клавиатуру
                      currentPageIndex++;
                    }
                  },
                  child: const Text('Далее')),
            ),
          ],
        ),
      );

  Widget _getEmailPage(Constants constants) {
    return Form(
      key: emailFormKey,
      child: Column(
        children: [
          // Заголовок
          SizedBox(
              height: constants.paddingUnit * 9,
              child: Padding(
                padding: EdgeInsets.only(bottom: constants.paddingUnit * 1),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text('Контактные\nданные',
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1,
                              )),
                ),
              )),
          Flexible(
              child: Padding(
            padding: EdgeInsets.only(bottom: constants.paddingUnit * 3),
            child: Text(
              'Пожалуйста, введите адрес своей электронной почты.\nОна не будет видна другим пользователям.\nИ никаких рассылок!',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    height: 1,
                  ),
            ),
          )),
          // Поле ввода почты
          SizedBox(
            height: constants.paddingUnit * 7 +
                (extendFields[2] ? fieldExtension : 0) * 8,
            // константа 8 подобрана на глаз
            child: CustomTextFormField(
                textEditingController: emailController,
                validator: (value) {
                  interactedWithFields[2] = true;
                  return _validateEmail(value);
                },
                hintText: 'Электронная почта'),
          ),
          // Кнопка «Далее»
          SizedBox(
            height: constants.paddingUnit * 5,
            child: RRButton(
                onTap: () async {
                  setState(() {
                    interactedWithFields[2] = true;
                    emailController.notifyListeners();
                  });
                  if (emailFormKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus
                        ?.unfocus(); // убираем клавиатуру
                    currentPageIndex++;
                  }
                },
                child: const Text('Далее')),
          ),
        ],
      ),
    );
  }

  Widget _getPasswordPage(Constants constants) => Form(
        key: passwordFormKey,
        child: Column(
          children: [
            // Заголовок
            SizedBox(
                height: constants.paddingUnit * 9,
                child: Padding(
                  padding: EdgeInsets.only(bottom: constants.paddingUnit * 1),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text('Ещё чуть-чуть\nи будет готово!',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1,
                            )),
                  ),
                )),
            // Поясняющий текст
            Flexible(
                child: Padding(
              padding: EdgeInsets.only(bottom: constants.paddingUnit * 3),
              child: Text(
                'Пожалуйста, придумайте пароль для своего аккаунта.\nИспользуйте латинские буквы, цифры и специальные символы.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      height: 1,
                    ),
              ),
            )),
            // Поле ввода пароля
            SizedBox(
              height: constants.paddingUnit * 7 +
                  (extendFields[3] ? fieldExtension : 0) *
                      8, // константа 8 подобрана на глаз
              child: CustomTextFormField(
                  textEditingController: passwordController,
                  validator: (value) {
                    interactedWithFields[3] = true;
                    return _validatePassword(value);
                  },
                  hintText: 'Пароль'),
            ),
            // Поле ввода повтора пароля
            SizedBox(
                height: constants.paddingUnit * 8 +
                    (extendFields[4] ? fieldExtension : 0) *
                        8, // константа 8 подобрана на глаз
                child: Padding(
                  padding: EdgeInsets.only(bottom: constants.paddingUnit),
                  child: CustomTextFormField(
                      textEditingController: passwordRepeatController,
                      validator: (value) {
                        interactedWithFields[4] = true;
                        if (value != passwordController.text) {
                          return 'Пароли не совпадают';
                        }
                        return null;
                      },
                      hintText: 'Пароль ещё раз'),
                )),
            // Кнопка «Далее»
            SizedBox(
              height: constants.paddingUnit * 5,
              child: RRButton(
                  onTap: () async {
                    setState(() {
                      interactedWithFields[3] = interactedWithFields[4] = true;
                      passwordController.notifyListeners();
                      passwordRepeatController.notifyListeners();
                    });
                    if (passwordFormKey.currentState!.validate()) {
                      try {
                        // TODO(func): отправить запрос на регистрацию
                        await ref.read(userProvider.notifier).authorize(
                            firstNameController.text,
                            secondNameController.text);
                      } catch (e) {
                        if (!context.mounted) return;
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Text('Произошла ошибка :('),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Ок'))
                                  ],
                                ));
                        debugPrint(e.toString());
                      }
                      if (!context.mounted) return;
                      FocusManager.instance.primaryFocus
                          ?.unfocus(); // убираем клавиатуру
                      ref.watch(userProvider.notifier).register(
                          firstNameController.value.text,
                          secondNameController.value.text,
                          emailController.value.text,
                          passwordController.value.text);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Zakroma()));
                    }
                  },
                  child: const Text('Далее')),
            ),
          ],
        ),
      );

  String? _validateName(String? value, [surname = false]) {
    final alpha = RegExp(r'^[А-Яа-яё]+$');
    if (value == null || value.isEmpty) {
      return 'Введите имя';
    } else if (!alpha.hasMatch(value)) {
      // TODO(think): Длинный вариант не влезает в одну строчку
      // return '${surname ? 'Фамилия' : 'Имя'} может содержать только буквы русского алфавита';
      return 'Только буквы русского алфавита';
    }
    return null;
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

String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Введите адрес электронной почты';
  } else if (!EmailValidator.validate(value)) {
    return 'Введите корректный адрес электронной почты';
  }
  return null;
}

String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Введите пароль';
  }
  return null;
}
