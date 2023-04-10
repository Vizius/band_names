import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  
  final boxDecoration = BoxDecoration(
        gradient:LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.2,0.8],
        colors: [
          Color.fromARGB(255, 3, 146, 5), // green
          Color.fromARGB(255, 26, 78, 4),
        ]));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: boxDecoration,),
      ],
    );
  }
}

class _Pinkbox extends StatelessWidget {
  String im;
  _Pinkbox( this.im,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return //Transform.rotate(
      //angle: -pi / 5 ,
       Opacity(
        opacity: 0.6,
         child: Container(
          width: double.infinity,
          height: 270,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            image: DecorationImage(image: AssetImage(im),fit: BoxFit.cover) ),
             ),
       );
  }
}