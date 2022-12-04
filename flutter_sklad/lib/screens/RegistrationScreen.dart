//import 'package:dartz/dartz.dart';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as wgt;
import 'package:flutter_sklad/data/repositories/auth_repository_implementation.dart';
import 'package:flutter_sklad/domain/usecases/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sklad/screens/AdminScreen.dart';
import 'package:flutter_sklad/screens/UserScreen.dart';
import '../domain/entity/role_entity.dart';
import 'AuthScreen.dart';

class RegistationScreen extends StatefulWidget {
  const RegistationScreen({super.key});

  @override
  wgt.State<StatefulWidget> createState() => RegistationScreenState();
}

class RegistationScreenState extends wgt.State<RegistationScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: TextFormField(
                      controller: loginController,
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Поле не должно быть пустым";
                        }
                        if (value.length < 5) {
                          return "Поле должно иметь не меньше 5 символов";
                        }
                        if (value.length > 12) {
                          return "Поле должно иметь не больше 12 символов";
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "login", border: OutlineInputBorder()),
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value == "") {
                        return "Пароль не должен быть пустым";
                      }
                      if (value.length < 5) {
                        return "Пароль должен иметь не меньше 5 символов";
                      }
                      if (value.length > 20) {
                        return "Пароль должен иметь не больше 20 символов";
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return "Пароль должен иметь хотя бы одну заглавную латинску букву";
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return "Пароль должен иметь хотя бы одну цифру";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: "password", border: OutlineInputBorder()),
                  )
                ],
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    String login = loginController.text;
                    String password = passwordController.text;

                    Future<Either<String, bool>> result =
                        AuthRepositoryImplementation().checkLoginExists(login);
                    bool loginExitsts = false;
                    result.then((value) {
                      if (value.isRight()) {
                        final snackBar = SnackBar(
                            content: Text("Такой пользователь уже существует"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        final snackBar =
                            SnackBar(content: Text("Ошибка регистрации"));

                        String hashPass = md5.convert(utf8.encode(password)).toString();
                        Future<Either<String, bool>> result =
                            AuthRepositoryImplementation()
                                .signUp(login, hashPass);

                        result.then((value) {
                          if (value.isRight()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthScreen()));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                      }
                    });
                  },
                  child: const Text("+чел в системе")),
            ),
            ElevatedButton(
                onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AuthScreen()))
                    },
                child: const Text("Назад"))
          ],
        ),
        Expanded(child: Container()),
      ],
    ));
  }
}
