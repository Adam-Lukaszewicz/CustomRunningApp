import 'package:biezniappka/global%20widgets/warning_dialog.dart';
import 'package:biezniappka/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordShowing = false;
  bool verifyShowing = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    verifyController.dispose();
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
                    const SizedBox(height: 50),
                    TextField(
                      controller: verifyController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Input password again',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  verifyShowing = !verifyShowing;
                                });
                              },
                              icon: verifyShowing
                                  ? const Icon(Icons.remove_red_eye_outlined)
                                  : const Icon(Icons.remove_red_eye))),
                      obscureText: !verifyShowing,
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: () async {
                          if (passwordController.text ==
                              verifyController.text) {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              await credential.user?.sendEmailVerification();
                              if (context.mounted) {
                                Navigator.pop(context);
                              }

                              if (context.mounted) {
                                warningDialog(context,
                                    "Na twój adres email został wysłany link aktywujący konto. Otwórz go w celu aktywacji konta.");
                              }
                            } on FirebaseAuthException catch (e) {
                              switch (e.code) {
                                case 'email-already-in-use':
                                  if (context.mounted) {
                                    warningDialog(context,
                                        "Istnieje już konto związane z podanym adresem email. Podaj inny adres.");
                                  }
                                  break;
                                case 'weak-password':
                                  if (context.mounted) {
                                    warningDialog(context,
                                        "Hasło jest za krótkie. Hasło powinno składać się z min. sześciu znaków");
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
                            }
                          } else {
                            warningDialog(
                                context, "Hasła muszą być takie same");
                          }
                        },
                        child: Center(
                            child: Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 20,),
                        ))),
                  ],
                )),
          ),
        ));
  }
}
