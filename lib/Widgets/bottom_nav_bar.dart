
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ekyeyo/Search/profile.dart';
import 'package:ekyeyo/jobs/jobs_screen.dart';
import 'package:ekyeyo/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Search/search_company.dart';
import '../jobs/upload_job.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  int indexNum = 0;
  BottomNavigationBarForApp({required this.indexNum});
  void _logout(context){
    final FirebaseAuth _auth  = FirebaseAuth.instance;
    showDialog(context: context, builder:(context){
      return  AlertDialog(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Padding(
                padding: EdgeInsets.all(8.0),
              child: Icon(Icons.logout_rounded,
              color: Colors.white,size: 19,),
            ),
            Padding(
                padding: EdgeInsets.all(8.0),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
        content: const Text(
          'Do you want to logout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                'No',
                style: TextStyle(
                  color:  Colors.lightBlue,
                  fontSize: 18,
                ),
              ),
          ),
          TextButton(
            onPressed: (){
              _auth.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> UserState()));
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color:  Colors.lightBlue,
                fontSize: 18,
              ),
            ),

          )],

      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.white,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: Colors.white,
      height: 50,
      index: indexNum,
      items:  const [
      Icon(Icons.list, size: 30, color: Colors.black,),
        Icon(Icons.search_off_rounded, size: 30, color: Colors.black,),
        Icon(Icons.add_business_outlined, size: 30, color: Colors.black,),
        Icon(Icons.person_pin, size: 30, color: Colors.black,),
        Icon(Icons.logout_rounded, size: 30, color: Colors.black,),


    ],
      animationDuration: const Duration(
        microseconds: 400,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index){
        if(index == 0){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Jobscreen(),));
        }
        else if(index == 1){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllWorkersScreen(), ));
        }
        else if(index == 2){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UploadJobNow(), ));
        }
        else if(index == 3){
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String uid = user!.uid;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen(userID: uid,), ));

        }
        else if(index == 4){
          _logout(context);
        }
      },
    );
  }
}
