import 'package:bus_ticketing_app/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bus_ticketing_app/pages/auth/authmethod.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
  
      try {
        AuthMethod authMethod = AuthMethod();
  
        // Call the signupUser method
        String res = await authMethod.signupUser(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
        );

        if (res == 'success') {
          // Navigate to the home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        } else {
          showSnackBar(context, res);
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
  
        // Show error message
        String res;
        if (e.code == 'weak-password') {
          res = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          res = 'The account already exists for that email.';
        } else {
          res = e.message ?? 'An unknown error occurred.';
        }
        showSnackBar(context, res);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) // Show loading indicator
            : Form(
                key: _formKey, // Use Form widget with a GlobalKey
                child: Column(
                  children: [
                    SizedBox(
                      height: height / 2.7,
                      child: Image.asset('assets/img/bus1.jpeg'),
                    ),
                    TextFieldInput(
                      icon: Icons.person,
                      textEditingController: nameController,
                      hintText: 'Name',
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFieldInput(
                      icon: Icons.email,
                      textEditingController: emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Simple email validation
                        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    TextFieldInput(
                      icon: Icons.lock,
                      textEditingController: passwordController,
                      hintText: 'Enter your password',
                      textInputType: TextInputType.text,
                      isPass: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Button(onTap: signup, text: " Sign Up"),
                   
                 
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                        onPressed: () {
                            // implemantion for google sign in
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Image.asset(
                                'assets/img/ebir.jpeg',
                                height: 35,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Sign Up with Google",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('You have an account?'),
                        TextButton(
                          onPressed: () {
                            // Navigate to signup page
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text('Log In'),
                        ),
                      ],
                    ),
                  ],
                  
                ),
              ),
      ),
    );
  }
}

Widget TextFieldInput({
  required TextEditingController textEditingController,
  required IconData icon,
  required String hintText,
  required TextInputType textInputType,
  bool isPass = false,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: TextFormField(
      style: const TextStyle(fontSize: 20),
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: const Color(0xFFedf0f8),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      validator: validator, // Pass the validator
    ),
  );
}

Widget Button({
  required VoidCallback onTap,
  required String text,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          color: Colors.blue,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: const Text('DISMISS'),
        ),
      ],
    ),
  );
}