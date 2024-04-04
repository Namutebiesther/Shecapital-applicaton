import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekyeyo/Services/global_variables.dart';
import 'package:ekyeyo/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {

final String userID;

const ProfileScreen({required this.userID});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? name;
  String email = '';
  String phoneNo = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isloading = false;
  bool _isSameUser = false;

  void getUserData() async {
    try {
      _isloading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();

      if (userDoc == null) {
        return;
      }else {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNo = userDoc.get('PhoneNumber');
          imageUrl = userDoc.get('UserImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var JoinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${JoinedDate.year}-${JoinedDate.month}-${JoinedDate.day}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      }
    }
    catch(error){} finally{
      _isloading =false;
    }
  }
@override
  void initState() {
    getUserData();
    super.initState();
  }

  Widget userinfo({required IconData icon,required String content})
  {
    return Row(
      children: [
        Icon(icon,
          color:  Colors.white,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Text(
  content,
  style: const TextStyle(
  color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  ),
  ),
        ),
      ],
    );
  }
  Widget _contactBy({
    required Color color,required Function fct,required IconData icon
}){
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white,
      child: IconButton(
        icon: Icon(
          icon,
          color: color,
        ), onPressed: () {
          fct();
      },
      ),

    );
  }

void _openwhatsapp() async{
    var url = 'https://wa.me/$phoneNo?text=HelloWorld';
    launchUrlString(url);
}
void _mailTo() async{
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Write subject here, PLease write the details here',
    );
    final url = params.toString();
    launchUrlString(url);
}

  void _callPhoneNo() async{
    var url = 'tel://$phoneNo';
    launchUrlString(url);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration:  const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xffD16BA5),
            Color(0xff86A8E7),
            Color(0xff5FFBF1),
            Color(0xff5FFBF1),

          ],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3,),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Profile Screen',),
          centerTitle: true,
          flexibleSpace: Container(
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurpleAccent.shade400, Colors.greenAccent.shade700,],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2 , 0.9],

              ),
            ),
          ),
        ),
        body: Center(
          child: _isloading
              ? const Center(
            child:CircularProgressIndicator(),
          )
              :
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Stack(
                    children: [
                      Card(
                        color: Colors.black54,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child:  Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  name == null
                                      ?
                                      'name here'
                                      :
                                      name!,
                                  style:  const TextStyle(
                                      color:Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 30,),
                              const Padding(
                                  padding:EdgeInsets.all(8.0),
                                child: Text('Account Info',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              Padding(
                                  padding: EdgeInsets.only(left: 15),
                                child: userinfo(icon: Icons.email, content: email),
                              ),
                              const SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: userinfo(icon: Icons.phone, content:phoneNo),
                              ),
                              const SizedBox(height: 15,),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 35,),
                              _isSameUser ?
                                  Container()
                              :
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                   children: [
                                     _contactBy(
                                         color: Colors.green,
                                         fct:() {
                                           _openwhatsapp();
                                         },
                                         icon: FontAwesome.whatsapp,),
                                     _contactBy(
                                       color: Colors.red,
                                       fct:() {
                                         _mailTo();
                                       },
                                       icon: Icons.mail_outlined,),
                                     _contactBy(
                                       color: Colors.orange,
                                       fct:() {
                                         _callPhoneNo();
                                       },
                                       icon: Icons.phone,)
                                   ],
                                 ),
                              const SizedBox(height: 15,),
                              const Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 25,),
                              !_isSameUser
                              ?
                                  Container()
                                  :
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 30),
                                      child: MaterialButton(
                                        onPressed: (){
                                          _auth.signOut();
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserState() ));
                                        },
                                        color:  Colors.black,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(13)
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 13),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('LOG OUT',
                                                style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Signatra',
                                              ),),
                                              SizedBox(height: 20,),
                                              Icon(Icons.logout_rounded,
                                              color: Colors.white,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.26,
                            height: size.width * 0.26,
                            decoration: BoxDecoration(
                              color: Colors.lightGreenAccent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 0,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  imageUrl == null ?
                                      'https://cdn-icons-png.flaticon.com/512/4128/4128240.png'
                               :
                                      imageUrl!,
                                ),
                                fit: BoxFit.fill,
                              )
                            ),
                          )
                        ],
                      )
                    ],

                  ),
                ),
              )
        ),
      ),
    );
  }
}
