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
import 'package:flutter_sklad/screens/RegistrationScreen.dart';
import 'package:flutter_sklad/screens/UserScreen.dart';
import '../domain/entity/role_entity.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  wgt.State<StatefulWidget> createState() => AuthScreenState();
}

class AuthScreenState extends wgt.State<AuthScreen> {
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
                        if (value.length > 50) {
                          return "Поле должно иметь не больше 50 символов";
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
                        return "Поле не должно быть пустым";
                      }
                      if (value.length < 5) {
                        return "Поле должно иметь не меньше 5 символов";
                      }
                      if (value.length > 50) {
                        return "Поле должно иметь не больше 50 символов";
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

                    final snackBar = SnackBar(
                        content:
                            Text("Такие себе данные."));
                    String hashPass = md5.convert(utf8.encode(password)).toString();
                    Future<Either<String, RoleEnum>> result =
                        AuthRepositoryImplementation().signIn(login, hashPass);

                    result.then((value) {
                      if (value.isRight()) {
                        RoleEnum enumResult =
                            value.getOrElse(() => RoleEnum.anonymous);
                        switch (enumResult) {
                          case RoleEnum.admin:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminScreen()));
                            break;
                          case RoleEnum.user:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserScreen()));
                            break;
                          default:
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                  },
                  child: const Text("Вход")),
            ),
            ElevatedButton(
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistationScreen()))
                    },
                child: const Text("Регайся"))
          ],
        ),
        Expanded(child: Container()),
      ],
    ));
  }
}
