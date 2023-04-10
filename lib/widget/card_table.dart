import 'package:flutter/material.dart';


class SingleCard extends StatelessWidget {

  final Color color;
  final String text;

  const SingleCard({
    super.key, 
    required this.color, 
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Color.fromARGB(177, 2, 4, 32),
            borderRadius: BorderRadius.circular(50)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(Icons.inventory, color: Colors.white,),
                radius: 30,
              ),
              SizedBox(height: 10,),
              Text(text,style: TextStyle(color: color,fontSize: 20),)
            ],
          ),
        ),
      ),
    );
  }
}