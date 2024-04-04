import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekyeyo/Services/global_method.dart';
import 'package:ekyeyo/jobs/jobs_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JobWidget extends StatefulWidget {

final String jobTitle;
/*final String jobDescription; */
final String jobId;
final String UploadedBy;
final bool Recruitment;
final String UserImage;
final String name;
final String requirements;
final String email;
final String location;


const JobWidget({
  required this.jobTitle,
  /*required this.jobDescription,*/
  required this.jobId,
  required this.UploadedBy,
  required this.requirements,
  required this.UserImage,
  required this.name,
  required this.Recruitment,
  required this.email,
  required this.location,
});
  @override
  _JobWidgetState createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  _deleteDialog(){
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () async{
                    try{
                      if(widget.UploadedBy == _uid){
                        await FirebaseFirestore.instance.collection('jobs')
                            .doc(widget.jobId)
                            .delete();
                        await Fluttertoast.showToast(msg: 'Job has been deleted',
                        toastLength: Toast.LENGTH_LONG,
                          fontSize: 18,
                          backgroundColor: Colors.grey,
                        );
                        Navigator.canPop(context) ? Navigator.pop(context) :null;

                      }else{
                        GlobalMethod.showErrorDialog(error: 'You  cannot perform this action', ctx: ctx);
                      }
                    }catch(error){
                      GlobalMethod.showErrorDialog(error: 'This job cannot be deleted', ctx: ctx);
                    }finally{}
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(Icons.delete_forever,
                       color: Colors.red,),
                      Text('Delete',
                      style: TextStyle(
                        color: Colors.red,
                      ),)
                    ],
                  ))
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black38,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: ListTile(
        onTap: (){
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobDetailScreen(
           uploadedBy: widget.UploadedBy,
           jobid: widget.jobId,
         )));
        },
        onLongPress: (){
          _deleteDialog();
        },
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration:   const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            )
          ),
          child: Image.network(widget.UserImage),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 40,
            fontFamily: 'AbrilFatface',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            ),
            ),
            const SizedBox(height: 8,),
           /* Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ), */
            Text('lOAN REQUIREMENTS',
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              widget.requirements,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right_outlined,
          size: 36,
          color: Colors.black,
        ),
      ),
    );
  }
}
