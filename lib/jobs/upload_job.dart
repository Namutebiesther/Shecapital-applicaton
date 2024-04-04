
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekyeyo/Services/global_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../Persistent/persistent.dart';
import '../Services/global_variables.dart';
import '../Widgets/bottom_nav_bar.dart';

class UploadJobNow extends StatefulWidget {
  const UploadJobNow({Key? key}) : super(key: key);

  @override
  _UploadJobNowState createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  final TextEditingController _jobCategoryController = TextEditingController(text: 'Select Loan Category');
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _jobDeadlineController = TextEditingController(text: 'Deadline Date');
  final TextEditingController _jobrequirementsController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadelineTimeStamp;
  bool _isloading = false;
  @override
  void dispose() {
  _jobCategoryController.dispose();
  _jobTitleController.dispose();
  _jobDescriptionController.dispose();
    _jobDeadlineController.dispose();
    _jobrequirementsController..dispose();

    super.dispose();
  }

  Widget _textTitles({required String label}) {
    return Padding(

      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

    );
  }

  Widget _textFormField({
    required String valuekey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxlength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valuekey),
          style: const TextStyle(
            color: Colors.white,
          ),
          maxLines: valuekey == 'JobsDescription' ||
              valuekey == 'Jobrequirements' ? 4 : 1,
          maxLength: maxlength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              fillColor: Colors.black54,
              filled: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )
          ),

        ),
      ),
    );
  }

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
                          _jobCategoryController.text = Persistent
                              .jobCategoryList[index];
                        });
                        Navigator.pop(context);
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
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ))
            ],
          );
        });
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 0),),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _jobDeadlineController.text =
        '${picked!.year} - ${picked!.month} - ${picked!.day}';
        deadelineTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _uploadjob() async {
    final jobid = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      if (_jobDeadlineController.text == 'Choose Deadline date' ||
          _jobDeadlineController.text == 'Choose the job category') {
        GlobalMethod.showErrorDialog(
            error: 'please fill Every Field',
            ctx: context);
        return;
      }
      setState(() {
        _isloading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('jobs').doc(jobid).set(
            {
              'jobid': jobid,
              'UploadedBy': _uid,
              'email': user.email,
              'job Title': _jobTitleController.text,
              'Job Description': _jobDescriptionController.text,
              'job Requirements': _jobrequirementsController.text,
              'job Deadline Date': _jobDeadlineController.text,
              'deadline Date TimeStamp': deadelineTimeStamp,
              'Job Category': _jobCategoryController.text,
              'Job comment': [],
              'Recruitment': true,
              'Uploaded At': Timestamp.now(),
              'Name': name,
              'UserImage': userImage,
              'Location': location,
              'Applicants': 0,

            });
        await Fluttertoast.showToast(msg: 'Job succesfully Uploaded',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18,
        );
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = 'Choose Loan category';
          _jobDeadlineController.text = 'Choose Loan Deadline Date';
        });
      }
      catch (error) {

        {
          setState(() {
            _isloading=false;
          });
          GlobalMethod.showErrorDialog(
              error: error.toString(),
              ctx: context);
        }
      }
      finally{
        setState(() {
          _isloading=false;
        });
      }
    }else{
      print('It is not valid');
    }
  }
  void getMyData() async{
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      name = userDoc.get('name');
      userImage = userDoc.get('UserImage');
      location =userDoc.get('location');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2,),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('UPLOAD LOAN OPPORTUNITIES',),
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
          child: Padding(
            padding: EdgeInsets.all(7.0),
            child: Card(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
    padding: EdgeInsets.all(8.0),
    child: Text('Please fill all the fields',
    style: TextStyle(
    color: Colors.white,
    fontSize:40,
    fontWeight: FontWeight.bold,
    fontFamily: 'Signatra',),
                )
              ),
            ),
                    SizedBox(height: 10,),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding
                      (
                        padding: const EdgeInsets.all(8.0),
                      child:Form(
                        key: _formkey,
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _textTitles(label: 'Loan Category:'),
                              _textFormField(
                                  valuekey: 'Job Category',
                                  controller: _jobCategoryController,
                                  enabled: false,
                                  fct: (){
                                    _showTaskCategoriesDialog(size: size);
                                  },
                                  maxlength: 150),
                              _textTitles(label: 'Job Title:'),
                              _textFormField(
                                  valuekey: 'Job Title',
                                  controller: _jobTitleController,
                                  enabled: true,
                                  fct: (){},
                                  maxlength: 150,),
                              /*
                              _textTitles(label: 'JOB Description:'),
                              _textFormField(
                                valuekey: 'JobsDescription',
                                controller: _jobDescriptionController,
                                enabled: true,
                                fct: (){},
                                maxlength: 150,),*/
                              _textTitles(label: 'loan Requirements and Qualifications:'),
                              _textFormField(
                                valuekey: 'Jobrequirements',
                                controller: _jobrequirementsController,
                                enabled: true,
                                fct: (){},
                                maxlength: 150,),
                              _textTitles(label: 'Loan Deadline Date'),
                              _textFormField(
                                valuekey: 'Deadline',
                                controller: _jobDeadlineController,
                                enabled: false,
                                fct: (){
                                  _pickDateDialog();
                                },
                                maxlength: 150,),
                            ],
                          )),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: _isloading ?
                        const CircularProgressIndicator()
                        : MaterialButton(onPressed: (){
                          _uploadjob();
                        },
                          color: Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Post  Now  ',
                                  style: TextStyle(

                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                    fontFamily: 'Signatra',
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Icon(Icons.upload_file_outlined,
                                color: Colors.white,)
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
    ),
    ),
    ),
    );
  }
}
