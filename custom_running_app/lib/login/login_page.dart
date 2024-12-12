import 'package:biezniappka/global%20widgets/warning_dialog.dart';
import 'package:biezniappka/login/sub/register_page.dart';
import 'package:biezniappka/login/sub/reset_password.dart';
import 'package:biezniappka/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordShowing = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dbService = GetIt.I.get<DatabaseService>();
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF554FFF), Color(0xFFCE5521)]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SizedBox(
                width: screenWidth * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * .05),
                    Image.asset('files/logo.png'),
                    SizedBox(height: screenHeight * .05),
                    Text(
                      "Bieżniapka",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    SizedBox(height: screenHeight * .10),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: 'E-mail',
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Password',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordShowing = !passwordShowing;
                                });
                              },
                              icon: passwordShowing
                                  ? const Icon(Icons.remove_red_eye_outlined)
                                  : const Icon(Icons.remove_red_eye))),
                      obscureText: !passwordShowing,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            //await FirebaseAuth.instance.setPersistence( Persistence.LOCAL);
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
                            if (credential.user == null) {
                              throw Exception("Błąd logowania");
                            }
                            if (!credential.user!.emailVerified) {
                              throw Exception(
                                  "Adres e-mail musi być zweryfikowany, aby się zalogować");
                            }
                            dbService.assignUserSpecificData();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } on FirebaseAuthException catch (e) {
                            switch (e.code) {
                              case 'invalid-credential':
                                if (context.mounted) {
                                  warningDialog(context,
                                      "Nieprawidłowe hasło lub login e-mail. Spróbuj ponownie.");
                                }

                                break;
                              case 'user-disabled':
                                if (context.mounted) {
                                  warningDialog(context,
                                      "Konto zostało zablokowane. Skontaktuj się z obsługą.");
                                }

                                break;
                              case 'too-many-requests':
                                if (context.mounted) {
                                  warningDialog(
                                      context, "Zbyt wiele nieudanych prób.");
                                }

                                break;
                              case 'invalid-email':
                                if (context.mounted) {
                                  warningDialog(
                                      context, "Błędny format adresu email.");
                                }

                                break;
                              case 'network-request-failed':
                                if (context.mounted) {
                                  warningDialog(
                                      context, "Brak połączenia sieciowego.");
                                }

                                break;
                              case 'channel-error':
                                if (context.mounted) {
                                  warningDialog(
                                      context, "Wprowadź dane logowania.");
                                }

                                break;
                              default:
                                warningDialog(context,
                                    "Wystąpił nieznany błąd: ${e.code} ${e.message} Spróbuj ponownie później.");
                            }
                          } catch (e) {
                            if (context.mounted) {
                              warningDialog(context, e.toString());
                            }
                          }
                        },
                        child: Center(
                            child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ))),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child: Center(
                              child: Text(
                            "Sign up",
                            style: TextStyle(
                                fontSize: 14,),
                          ))),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ResetPasswordPage()),
                            );
                          },
                          child: Center(
                              child: Text(
                            "Forgot password?",
                            style: TextStyle(
                                fontSize: 13,),
                          ))),
                    ])
                  ],
                )),
          ),
        ));
  }
}
