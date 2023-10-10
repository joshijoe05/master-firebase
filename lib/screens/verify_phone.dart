import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home_screen.dart';
import 'package:flutter_firebase/widgets/custom_button.dart';
import 'package:flutter_firebase/widgets/utils.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String verificationId;
  const VerifyOTPScreen({super.key, required this.verificationId});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  final otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
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
              controller: otpController,
              maxLength: 6,
              decoration: const InputDecoration(
                hintText: '6 Digit Code',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
                isLoading: isLoading,
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: otpController.text.toString());
                  try {
                    await _auth.signInWithCredential(credential);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                  } catch (e) {
                    Utils().toastMessage(e.toString());
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                title: 'Verify OTP')
          ],
        ),
      ),
    );
  }
}
