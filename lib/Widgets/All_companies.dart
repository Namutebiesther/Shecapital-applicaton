import 'package:ekyeyo/Search/profile.dart';
import 'package:ekyeyo/Services/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AllCompanies extends StatefulWidget {
  
final String userID;
final String userName;
final String userEmail;
final String userPhoneNo;
final String userImageurl;

AllCompanies({
  required this.userID,
  required this.userName,
  required  this.userEmail,
  required this.userImageurl,
  required this.userPhoneNo,
});
  @override
  _AllCompaniesState createState() => _AllCompaniesState();
}

class _AllCompaniesState extends State<AllCompanies> {
  void _mailTo() async{
    var mailurl = 'mailto: ${widget.userEmail}';
    print('widget.userEmail ${widget.userEmail}');

    if(await canLaunchUrlString(mailurl)){
      await launchUrlString(mailurl);
    }else
      {
        print('Error');
        throw 'Error Occured';
      }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 100,
      color: Colors.cyan,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListTile(
        onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ProfileScreen(userID: widget.userID)));

        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            )
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(
              // ignore: prefer_if_null_operators
              widget.userImageurl == null
                  ?
                  'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000'
                  :
                  widget.userImageurl,
            ),
          ),
        ),
        title: Text(
            widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),

        ),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Visit Profile',
              maxLines:2,
              overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
            )
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.mail_outlined,
            size: 50,
            color: Colors.white,

          ), onPressed: () {
            _mailTo();
        },
        ),
      ),
    );
  }
}
