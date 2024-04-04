import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekyeyo/Widgets/bottom_nav_bar.dart';
import 'package:ekyeyo/Widgets/job_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Persistent/persistent.dart';
import '../Search/search_job.dart';
import '../user_state.dart';

class Jobscreen extends StatefulWidget {


  @override
  _JobscreenState createState() => _JobscreenState();
}

class _JobscreenState extends State<Jobscreen> {
  String? jobCategoryFilter;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              'Loan category',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Persistent.jobCategoryList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          jobCategoryFilter = Persistent.jobCategoryList[index];
                        });
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
                        print('jobCategoryList[index], $Persistent.jobCategoryList[index]');
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_right_alt_outlined,
                            color: Colors.green,),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              Persistent.jobCategoryList[index],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),),
                        ],
                      ),
                    );
                  }
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )),
              TextButton(
                  onPressed: (){
                    setState(() {
                      jobCategoryFilter = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text('Cancel Filter',
                  style: TextStyle(
                    color: Colors.white,
                  ),),),
            ],
          );
        });
  }
 @override
  void initState() {
   Persistent persistentOBJCT = Persistent();
   persistentOBJCT.getMyData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const SweepGradient(
          colors: [
            Colors.red,
            Colors.yellow,
            Colors.blue,
            Colors.green,
            Colors.red,
          ],
          stops: <double>[0.0, 0.25, 0.5, 0.75, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),

      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0,),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('LOANS AVAILABLE',),
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
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white,
              size: 40,
            ),
            onPressed: (){
              _showTaskCategoriesDialog(size: size);
            },
          ),
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) =>Searchjobs()));
                },
                icon: const Icon(Icons.search_rounded,
                color: Colors.white,
                size: 40,),
            ),

          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('Job Category', isEqualTo: jobCategoryFilter)
                .where('Recruitment', isEqualTo: true)
          .orderBy('Uploaded At', descending: false)
              .snapshots(),
          builder: (context,AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }else if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.data?.docs.isNotEmpty == true){
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                    itemBuilder:(BuildContext context,int index){
                      return JobWidget(
                          jobTitle: snapshot.data.docs[index]['job Title'],
                          /*jobDescription: snapshot.data.docs[index]['Job Description'], */
                          jobId:snapshot.data.docs[index]['jobid'] ,
                          UploadedBy: snapshot.data.docs[index]['UploadedBy'],
                          requirements: snapshot.data.docs[index]['job Requirements'],
                          UserImage:snapshot.data.docs[index]['UserImage'],
                          name: snapshot.data.docs[index]['Name'],
                          Recruitment: snapshot.data.docs[index]['Recruitment'],
                          email: snapshot.data.docs[index]['email'],
                          location: snapshot.data.docs[index]['Location']);
                    } );
              }
              else{
                return const Center(
                  child: Text('There are no jobs'),
                );
              }
            }
            return const Center(
              child: Text('something went wrong',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),),
            );
          },

        ),
      ),
    );
  }
}
