import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/verify_phone.dart';
import 'package:flutter_firebase/widgets/custom_button.dart';
import 'package:flutter_firebase/widgets/utils.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Phone'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: const InputDecoration(
                hintText: '+91 1234567890',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
                isLoading: isLoading,
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  _auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text,
                      verificationCompleted: (_) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      verificationFailed: (e) {
                        print('verification failed');
                        Utils().toastMessage(e.toString());
                        setState(() {
                          isLoading = false;
                        });
                      },
                      codeSent: (verificationId, forceResendingToken) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyOTPScreen(
                                verificationId: verificationId,
                              ),
                            ));
                        setState(() {
                          isLoading = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (e) {
                        // print('code auto retreival');
                        // Utils().toastMessage(e.toString());
                        setState(() {
                          isLoading = false;
                        });
                      });
                },
                title: 'Send OTP')
          ],
        ),
      ),
    );
  }
}
