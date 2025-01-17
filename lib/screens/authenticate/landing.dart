import 'package:flutter/material.dart';
import 'package:hangout/screens/authenticate/Login.dart';
import 'package:hangout/screens/authenticate/register.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DecoratedBox(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/landing-background.png'),
                    fit: BoxFit.cover)),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Organize. Invite. Enjoy.\nThe Easy Way',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Image.asset('assets/images/mascot.png'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xffFF7A00), // Background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical:
                            14), // Adjust padding to make the button wider and taller
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Adjust the border radius
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()));
                    },
                    child: const Text(
                      'Join for free',
                      style: TextStyle(
                          color: Color(0xffFF7A00),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ))));
  }
}
