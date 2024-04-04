import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekyeyo/Widgets/All_companies.dart';
import 'package:ekyeyo/Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class AllWorkersScreen extends StatefulWidget {


  @override
  _AllWorkersScreenState createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search query';
  Widget _searchField(){
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
          hintText: 'Search For Companies........',
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1,),
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
          automaticallyImplyLeading: false,
          title: _searchField(),
          actions: _buildactions(),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('name', isGreaterThanOrEqualTo: searchQuery)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.connectionState ==  ConnectionState.active){
              if(snapshot.data!.docs.isNotEmpty){
                return ListView.builder(
                  itemCount:  snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index){
                    return AllCompanies(
                        userID: snapshot.data!.docs[index]['id'],
                        userName: snapshot.data!.docs[index]['name'],
                        userEmail: snapshot.data!.docs[index]['email'],
                        userImageurl: snapshot.data!.docs[index]['UserImage'],
                        userPhoneNo: snapshot.data!.docs[index]['PhoneNumber']
                    );
                    }
                );
              }
              else{
                return const Center(
                  child: Text(
                    'No Employer or Company',
                  ),
                );
              }
            }
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            );
          },
        ),
      ),
    );

  }
}
