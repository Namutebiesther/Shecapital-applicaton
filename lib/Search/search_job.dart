import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekyeyo/jobs/jobs_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/job_widget.dart';
import 'othersites.dart';


class Searchjobs extends StatefulWidget {

  @override
  _SearchjobsState createState() => _SearchjobsState();
}

class _SearchjobsState extends State<Searchjobs> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search query';
  Widget _searchField(){
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Search For Loans........',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white,

        )
      ),
      style: const TextStyle(
          color: Colors.white,
              fontSize: 20,
      ),
      onChanged: (query) => UpdateSearchQuery(query),
    );
  }

  List<Widget> _buildactions(){

    return<Widget>[
      IconButton(

          icon: Icon(Icons.arrow_forward),
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Othersites()));
      },
      ),
      IconButton(
          onPressed: (){
            _clearSearchQuery();
          },
          icon: const Icon(Icons.clear)),
    ];
  }
  void _clearSearchQuery(){
    setState(() {
      _searchQueryController.clear();
      UpdateSearchQuery('');
    });
  }
  void UpdateSearchQuery(String newQuery){
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent.shade400, Colors.greenAccent.shade700,],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2 , 0.9],

        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(

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
          leading: IconButton(

            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Jobscreen()));
            },

          ),
          title: _searchField(),
          actions: _buildactions(),

        ),

        body:
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs').where('job Title', isGreaterThanOrEqualTo: searchQuery)
              .where('Recruitment', isEqualTo: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }else if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.data?.docs.isNotEmpty == true){
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder:(BuildContext context,int index){
                      return JobWidget(
                          jobTitle: snapshot.data?.docs[index]['job Title'],
                        /*  jobDescription: snapshot.data?.docs[index]['Job Description'], */
                          jobId:snapshot.data?.docs[index]['jobid'] ,
                          UploadedBy: snapshot.data?.docs[index]['UploadedBy'],
                          requirements: snapshot.data?.docs[index]['job Requirements'],
                          UserImage:snapshot.data?.docs[index]['UserImage'],
                          name: snapshot.data?.docs[index]['Name'],
                          Recruitment: snapshot.data?.docs[index]['Recruitment'],
                          email: snapshot.data?.docs[index]['email'],
                          location: snapshot.data?.docs[index]['Location']);
                    } );

              }
              else{
                return const Center(
                  child: Text(
                    'No Job Match',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                );
              }
            }
            return const Center(
              child: Text(
                'Something Went Wrong',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            );
          },
        ),

      ),

    );

  }


}

