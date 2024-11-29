import 'package:flutter/material.dart';

class TrainingPage extends StatelessWidget{
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Center(
              child: SizedBox(
                width: screenWidth * 0.8,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * .05,
                    ),
                    Container(
                      height: screenHeight * .3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          color: Color(0xAD9B3BA4)),
                    ),
                    Stack(),
                    Row(),
                  ],
                ),
              ),
            );
  }
}