import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_app/Question_Page/dbConnect.dart';
import 'package:project_app/Question_Page/widgets/Question_overview.dart';
import 'package:project_app/Question_Page/widgets/optionCard.dart';
import 'package:project_app/Question_Page/widgets/result_box.dart';
import 'const.dart';
import 'question_model.dart';
import 'package:project_app/splash_screen/splash.dart';
import 'package:custom_timer/custom_timer.dart';

class QuestionViews extends StatefulWidget {
  @override
  _QuestionViewsState createState() => _QuestionViewsState();
}

class _QuestionViewsState extends State<QuestionViews> {
  final CustomTimerController _controller = CustomTimerController();
  Duration _duration = Duration(
    minutes: 0,
    seconds: 10,
  );
  List ans = [];
  var db = DBConnect();
  late Future _questions;
  Future<List<Questions>> getData() async {
    return db.fetchQuestions();
  }

  bool isFlagged = false;

  @override
  void initState() {
    _questions = getData();
  }

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;

  void previousQuestion(int questionLength) {
    if (index == 0) {
      return;
    } else {
      if (isPressed) {
        setState(() {
          index--;
          isPressed = false;
          isAlreadySelected = false;
          ans.removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select any options"),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0),
          ),
        );
      }
    }
  }

  void nextQuestion(int questionLength) {
    if (index == questionLength - 1) {
      int count = 0;
      for (int i = 0; i < ans.length; i++) {
        if (ans[i] == 1) {
          count++;
        }
      }
      if (isPressed | isFlagged) {
        // showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (ctx) => ResultBox(
        //           result: count,
        //           questionLength: questionLength,
        //           onPressed: startOver,
        //         ));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => QuestionOverview()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select any options"),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0),
          ),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QuestionViews()));
      }
    } else {
      if (isPressed | isFlagged) {
        print(isPressed);
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
          isFlagged = false;
          if (ans.length > index) {
            ans.removeAt(index);
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select any options"),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0),
          ),
        );
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        print("true");
        ans.insert(index, 1);
        print(ans);
        //score++;

        setState(() {
          isPressed = true;
          isAlreadySelected = true;
        });
      } else {
        print("fls");
        ans.insert(index, 0);
        print(ans);
        setState(() {
          isPressed = true;
          isAlreadySelected = true;
        });
      }
    }
  }

  void startOver() {
    setState(() {
      ans = [];
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
      isFlagged = false;
    });
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<Questions>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Questions>;
            return Scaffold(
              body: Stack(children: [
                Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 27, 33, 1),
                    ),
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                    ),
                                    color: Color(0xFFF6F6F6),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: Container(
                                              child: Center(
                                                child: Text(
                                                  "${index + 1} / ${extractedData.length}",
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              height: 42,
                                              width: 83,
                                              decoration: BoxDecoration(
                                                  color: Colors.white),
                                            ),
                                          ),

                                          // SizedBox(
                                          //     width: MediaQuery.of(context)
                                          //             .size
                                          //             .width *
                                          //         0.30),
                                          Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: Container(
                                              child: Center(
                                                child: Text(
                                                  extractedData[index]
                                                      .mainTitle,
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              height: 42,
                                              width: 83,
                                              decoration: BoxDecoration(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 54, right: 54),
                                              child: Text(
                                                extractedData[index].title,
                                                overflow: TextOverflow.visible,
                                                textAlign: TextAlign.justify,
                                                style: GoogleFonts.nunito(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ), //Question part
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      for (int i = 0;
                                          i <
                                              extractedData[index]
                                                  .options
                                                  .length;
                                          i++)
                                        GestureDetector(
                                          onTap: () => checkAnswerAndUpdate(
                                              extractedData[index]
                                                  .options
                                                  .values
                                                  .toList()[i]),
                                          child: OptionCard(
                                            option: extractedData[index]
                                                .options
                                                .keys
                                                .toList()[i],
                                            color: isPressed
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      Material(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () => previousQuestion(
                                                extractedData.length,
                                              ),
                                              icon: index == 0
                                                  ? Container()
                                                  : Icon(Icons.arrow_back),
                                              splashRadius: 26,
                                              splashColor: Colors.black,
                                            ),
                                            Ink(
                                              decoration: ShapeDecoration(
                                                  shape: CircleBorder(),
                                                  color: isFlagged
                                                      ? Colors.blue
                                                      : Colors.white),
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isFlagged = !isFlagged;
                                                  });
                                                },
                                                color: isFlagged
                                                    ? Colors.white
                                                    : Colors.blue,
                                                icon: Icon(Icons.flag),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => nextQuestion(
                                                  extractedData.length),
                                              child: Icon(Icons.arrow_forward),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  onPrimary: Colors.white,
                                                  primary: Colors.black),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ), //answer part
                          ],
                        ),
                      ),

                      // Positioned(
                      //     top: 190,
                      //     left: 28,
                      //     child: Container(
                      //         width: 83,
                      //         height: 42,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(6),
                      //             topRight: Radius.circular(6),
                      //             bottomLeft: Radius.circular(6),
                      //             bottomRight: Radius.circular(6),
                      //           ),
                      //           color: Color.fromRGBO(255, 255, 255, 1),
                      //         ))),
                      // Positioned(
                      //     top: 190,
                      //     left: 264,
                      //     child: Container(
                      //         width: 83,
                      //         height: 42,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(6),
                      //             topRight: Radius.circular(6),
                      //             bottomLeft: Radius.circular(6),
                      //             bottomRight: Radius.circular(6),
                      //           ),
                      //           color: Color.fromRGBO(255, 255, 255, 1),
                      //         ))),
                      // Positioned(
                      //     top: 106,
                      //     left: 139,
                      //     child: Container(
                      //         width: 97,
                      //         height: 97,
                      //         decoration: BoxDecoration(
                      //           color: Color.fromRGBO(255, 255, 255, 1),
                      //           borderRadius: BorderRadius.all(Radius.elliptical(97, 97)),
                      //         ))),
                      // Positioned(
                      //     top: 267,
                      //     left: 54,
                      //     child: Text(
                      //       'How do you store the next node reference in a Linked List?',
                      //       textAlign: TextAlign.left,
                      //       style: TextStyle(
                      //           color: Color.fromRGBO(0, 0, 0, 1),
                      //           fontFamily: 'Nunito',
                      //           fontSize: 18,
                      //           letterSpacing:
                      //               0 /*percentages not used in flutter. defaulting to zero*/,
                      //           fontWeight: FontWeight.normal,
                      //           height: 1),
                      //     )),
                      // Positioned(
                      //     top: 199,
                      //     left: 47,
                      //     child: Text(
                      //       '1 / 30',
                      //       textAlign: TextAlign.left,
                      //       style: TextStyle(
                      //           color: Color.fromRGBO(0, 0, 0, 1),
                      //           fontFamily: 'Nunito',
                      //           fontSize: 18,
                      //           letterSpacing:
                      //               0 /*percentages not used in flutter. defaulting to zero*/,
                      //           fontWeight: FontWeight.normal,
                      //           height: 1),
                      //     )),
                      // Positioned(
                      //     top: 199,
                      //     left: 282,
                      //     child: Text(
                      //       'D.S.A',
                      //       textAlign: TextAlign.left,
                      //       style: TextStyle(
                      //           color: Color.fromRGBO(0, 0, 0, 1),
                      //           fontFamily: 'Nunito',
                      //           fontSize: 18,
                      //           letterSpacing:
                      //               0 /*percentages not used in flutter. defaulting to zero*/,
                      //           fontWeight: FontWeight.normal,
                      //           height: 1),
                      //     )),
                      // Positioned(
                      //     top: 138,
                      //     left: 148,
                      //     child: Text(
                      //       '189:30',
                      //       textAlign: TextAlign.left,
                      //       style: TextStyle(
                      //           color: Color.fromRGBO(0, 0, 0, 1),
                      //           fontFamily: 'Nunito',
                      //           fontSize: 24,
                      //           letterSpacing:
                      //               0 /*percentages not used in flutter. defaulting to zero*/,
                      //           fontWeight: FontWeight.normal,
                      //           height: 1),
                      //     )),
                      // Positioned(
                      //     top: 393,
                      //     left: 34,
                      //     child: Container(
                      //         width: 307,
                      //         height: 58,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(6),
                      //             topRight: Radius.circular(6),
                      //             bottomLeft: Radius.circular(6),
                      //             bottomRight: Radius.circular(6),
                      //           ),
                      //           color: Color.fromRGBO(255, 255, 255, 1),
                      //           border: Border.all(
                      //             color: Color.fromRGBO(0, 27, 33, 1),
                      //             width: 2,
                      //           ),
                      //         ))),
                      // Positioned(
                      //     top: 543,
                      //     left: 34,
                      //     child: Container(
                      //         width: 307,
                      //         height: 58,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(6),
                      //             topRight: Radius.circular(6),
                      //             bottomLeft: Radius.circular(6),
                      //             bottomRight: Radius.circular(6),
                      //           ),
                      //           color: Color.fromRGBO(255, 255, 255, 1),
                      //           border: Border.all(
                      //             color: Color.fromRGBO(0, 27, 33, 1),
                      //             width: 2,
                      //           ),
                      //         ))),
                      // Positioned(
                      //     top: 469,
                      //     left: 34,
                      //     child: Container(
                      //         width: 307,
                      //         height: 58,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(6),
                      //             topRight: Radius.circular(6),
                      //             bottomLeft: Radius.circular(6),
                      //             bottomRight: Radius.circular(6),
                      //           ),
                      //           color: Color.fromRGBO(255, 255, 255, 1),
                      //           border: Border.all(
                      //             color: Color.fromRGBO(0, 27, 33, 1),
                      //             width: 2,
                      //           ),
                      //         ))),
                      // Positioned(
                      //     top: 619,
                      //     left: 34,
                      //     child: Container(
                      //         width: 307,
                      //         height: 58,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(6),
                      //             topRight: Radius.circular(6),
                      //             bottomLeft: Radius.circular(6),
                      //             bottomRight: Radius.circular(6),
                      //           ),
                      //           color: Color.fromRGBO(255, 255, 255, 1),
                      //           border: Border.all(
                      //             color: Color.fromRGBO(0, 27, 33, 1),
                      //             width: 2,
                      //           ),
                      //         ))),
                      // Positioned(
                      //     top: 411,
                      //     left: 118,
                      //     child: Text(
                      //       'In the NEXT part',
                      //       textAlign: TextAlign.left,
                      //       style: TextStyle(
                      //           color: Color.fromRGBO(0, 27, 33, 1),
                      //           fontFamily: 'Nunito',
                      //           fontSize: 18,
                      //           letterSpacing:
                      //               0 /*percentages not used in flutter. defaulting to zero*/,
                      //           fontWeight: FontWeight.normal,
                      //           height: 1),
                      //     )),
                      // Positioned(
                      //     top: 485,
                      //     left: 116,
                      //     child: Text(
                      //       'In the HEAD part',
                      //       textAlign: TextAlign.left,
                      //       style: TextStyle(
                      //           color: Color.fromRGBO(0, 27, 33, 1),
                      //           fontFamily: 'Nunito',
                      //           fontSize: 18,
                      //           letterSpacing:
                      //               0 /*percentages not used in flutter. defaulting to zero*/,
                      //           fontWeight: FontWeight.normal,
                      //           height: 1),
                      //     )),
                      // Positioned(
                      //     top: 559,
                      //     left: 112,
                      //     child: Text(
                      //       'In the VALUE part',
                      //       textAlign: TextAlign.left,
                      //       style: TextStyle(
                      //           color: Color.fromRGBO(0, 27, 33, 1),
                      //           fontFamily: 'Nunito',
                      //           fontSize: 18,
                      //           letterSpacing:
                      //               0 /*percentages not used in flutter. defaulting to zero*/,
                      //           fontWeight: FontWeight.normal,
                      //           height: 1),
                      //     )),
                      // Positioned(
                      //     top: 635,
                      //     left: 123,
                      //     child: Text(
                      //       'In the TAIL part',
                      //       textAlign: TextAlign.left,
                      //       style: TextStyle(
                      //           color: Color.fromRGBO(0, 27, 33, 1),
                      //           fontFamily: 'Nunito',
                      //           fontSize: 18,
                      //           letterSpacing:
                      //               0 /*percentages not used in flutter. defaulting to zero*/,
                      //           fontWeight: FontWeight.normal,
                      //           height: 1),
                      //     )),
                      // Positioned(
                      //     top: 721,
                      //     left: 51,
                      //     child: Container(
                      //         width: 56,
                      //         height: 56,
                      //         decoration: BoxDecoration(
                      //           color: Color.fromRGBO(255, 255, 255, 1),
                      //           border: Border.all(
                      //             color: Color.fromRGBO(0, 27, 33, 1),
                      //             width: 2,
                      //           ),
                      //           borderRadius: BorderRadius.all(Radius.elliptical(56, 56)),
                      //         ))),
                      // Positioned(
                      //     top: 721,
                      //     left: 269,
                      //     child: Container(
                      //         width: 56,
                      //         height: 56,
                      //         decoration: BoxDecoration(
                      //           boxShadow: [
                      //             BoxShadow(
                      //                 color: Color.fromRGBO(0, 27, 33, 0.20000000298023224),
                      //                 offset: Offset(0, 4),
                      //                 blurRadius: 4)
                      //           ],
                      //           color: Color.fromRGBO(0, 27, 33, 1),
                      //           borderRadius: BorderRadius.all(Radius.elliptical(56, 56)),
                      //         ))),
                      // Positioned(
                      //     top: 721,
                      //     left: 160,
                      //     child: Container(
                      //         width: 56,
                      //         height: 56,
                      //         decoration: BoxDecoration(
                      //           color: Color.fromRGBO(255, 255, 255, 1),
                      //           border: Border.all(
                      //             color: Color.fromRGBO(97, 150, 255, 1),
                      //             width: 2,
                      //           ),
                      //           borderRadius: BorderRadius.all(Radius.elliptical(56, 56)),
                      //         ))),
                    ])),
                Positioned(
                  top: 150,
                  left: 150,
                  child: Container(
                    width: 113,
                    height: 113,
                    child: Stack(children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 113,
                          height: 113,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 217, 122, 1),
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(113, 113)),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 113,
                          height: 113,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 217, 122, 1),
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(113, 113)),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          alignment: Alignment.center,
                          child:
                              // CustomTimer(
                              //     controller: _controller,
                              //     from: Duration(seconds: 10),
                              //     to: Duration(),
                              //     builder: (remaining) {
                              //       return Text(
                              //           "${remaining.minutes}:${remaining.seconds}",
                              //           style: TextStyle(fontSize: 24.0));
                              //     }),
                              TimerCountdown(
                                  format: CountDownTimerFormat.minutesSeconds,
                                  endTime: DateTime.now().add(
                                    _duration,
                                  ),
                                  onEnd: () {
                                    print("Timer Completed");
                                  },
                                  timeTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                  descriptionTextStyle: TextStyle(
                                    color: Colors.red,
                                    fontSize: 0,
                                  ),
                                  spacerWidth: 5),
                          width: 97,
                          height: 97,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(97, 97),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
