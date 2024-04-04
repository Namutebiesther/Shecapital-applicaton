import 'package:ekyeyo/Search/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class COmments extends StatefulWidget {
  final String commentId;
  final String commentorId;
  final String commentorName;
  final String commentBody;
  final String commentorImageUrl;

  const COmments({
    required this.commentId,
    required this.commentorId,
    required this.commentorName,
    required this.commentBody,
    required this.commentorImageUrl,
});


  @override
  _COmmentsState createState() => _COmmentsState();
}

class _COmmentsState extends State<COmments> {
  final List<Color> _colors = [
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.green,
    Colors.brown,

  ];
  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(

        onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(userID: widget.commentorId)));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    border:   Border.all(
                      width: 3,
                      color: _colors[3],
                    ),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(widget.commentorImageUrl),
                      fit: BoxFit.fill,
                    )
                ),
              ),
            ),
            const SizedBox(width: 10,),

            Flexible(
                flex: 5,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.commentorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),),
                    const SizedBox(height: 7,),
                    Text(widget.commentBody,
                      style: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),),
                  ],
                ) ),


          ],
        ),



    );
  }
}
