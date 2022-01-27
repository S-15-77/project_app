import 'package:flutter/material.dart';
import 'package:project_app/Register/Login.dart';
import 'package:project_app/Register/MainRegister.dart';
import 'package:project_app/Register/Otp.dart';

enum Reg {
  Register,
  Login,
}

enum Otp { noOtp, getOtp }

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Reg? selectedButton;
  Otp? otpVisible;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(69, 67, 71, 53),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assests/images/register.png',
                      height: 116,
                      width: 235,
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedButton = Reg.Register;
                        otpVisible = Otp.noOtp;
                      });
                    },
                    child: Text("Register"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(160, 50),
                      primary: selectedButton == Reg.Register
                          ? Color(0xFFFFDA7B)
                          : Color(0xFFE8E7E7),
                      onPrimary: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedButton = Reg.Login;
                        otpVisible = Otp.noOtp;
                      });
                    },
                    child: Text("Log In"),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: Size(
                        160,
                        50,
                      ),
                      primary: selectedButton == Reg.Login
                          ? Color(0xFFFFDA7B)
                          : Color(0xFFE8E7E7),
                      onPrimary: Colors.black,
                    ),
                  ),
                ],
              ),
              Visibility(
                  child:
                      selectedButton == Reg.Login ? Login() : MainRegister()),

              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        otpVisible = Otp.getOtp;
                      });
                    },
                    child: Text("Get One Time Password"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
              //
              Visibility(
                child: otpVisible == Otp.getOtp ? OtpRequest() : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}