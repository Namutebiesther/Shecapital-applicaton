import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Services/global_variables.dart';

class   Persistent{
  static List<String> jobCategoryList =[
    'Group loan',
    'Individual business loan',
    'Agriculture loan',
    'capital loans',
    'Education Loans(more specific)',
    'personal loan',
    'payday loan(depends on specified day)',
    'Others',
  ];
  void getMyData() async{
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      name = userDoc.get('name');
      userImage = userDoc.get('UserImage');
      location =userDoc.get('location');

  }
}