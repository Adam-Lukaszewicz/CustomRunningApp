import 'package:biezniappka/global%20widgets/warning_dialog.dart';
import 'package:biezniappka/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        border: OutlineInputBorder(),
                        hintText: 'E-mail',
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text,
                            );
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            }
                            if (context.mounted) {
                              warningDialog(context,
                                  "Na twój adres email został wysłany link resetujący hasło. Otwórz go w celu zmiany hasła.");
                            }
                          } on FirebaseAuthException catch (e) {
                            switch (e.code) {
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
                                      context, "Wprowadź adres email.");
                                }
                                break;
                              default:
                                if (context.mounted) {
                                  warningDialog(context,
                                      "Wystąpił nieznany błąd: ${e.code} ${e.message} Spróbuj ponownie później.");
                                }
                            }
                          }
                        },
                        child: Center(
                            child: Text(
                          "Reset password",
                          style: TextStyle(
                              fontSize: 20,),
                        ))),
                  ],
                )),
          ),
        ));
  }
}
