import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekyeyo/Services/global_method.dart';
import 'package:ekyeyo/Services/global_variables.dart';
import 'package:ekyeyo/Widgets/Comments.dart';
import 'package:ekyeyo/jobs/jobs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

class JobDetailScreen extends StatefulWidget {
  final String uploadedBy;
  final String jobid;

  const JobDetailScreen(
      {
        required this.uploadedBy,
        required this. jobid,
      }
      );

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController  _commentingController = TextEditingController();
  bool _isCommmenting = false;
  String? EmployerName;
  String? UserImage;
  String? JobCategory;
  String? JobDescription;
  String? JobTitle;
  String? JobRequirements;
  bool? Recruitment;
  Timestamp? DeadlineDateTimeStamp;
  Timestamp? postedDateTimeStamp;
  String? postedDate;
  String? deadlineDate ;
  String? LocationCompany = '';
  String? emailCompany ='';
  int applicants = 0;
  bool isDeadlineAvailable = false;
  bool showComment =false;

  void getJobData () async{
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.uploadedBy).get();
    if(userDoc == null){
      return;
    }else{
      setState(() {
        EmployerName = userDoc.get('name');
        UserImage = userDoc.get('UserImage');
      });
    }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance.collection('jobs')
    .doc(widget.jobid).get();
    if(jobDatabase == null){
      return;
    }else{
      setState(() {
        postedDateTimeStamp = jobDatabase.get('Uploaded At');
        JobTitle = jobDatabase.get('job Title');
        JobDescription = jobDatabase.get('Job Description');
        Recruitment = jobDatabase.get('Recruitment');
        JobRequirements = jobDatabase.get('job Requirements');
        emailCompany = jobDatabase.get('email');
        LocationCompany = jobDatabase.get('Location');
        applicants = jobDatabase.get('Applicants');
        DeadlineDateTimeStamp = jobDatabase.get('deadline Date TimeStamp');
        deadlineDate = jobDatabase.get('job Deadline Date');

         var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
      });
      var date = DeadlineDateTimeStamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }
  }
@override
  void initState() {
  getJobData();
    super.initState();

  }
  Widget divider(){
    return const Column(
      children: [
        SizedBox(height: 10,),
        Divider(

          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(height: 10,),
      ],
    );
  }

applyForJob(){
    final   Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query: 'subject=Applying for $JobTitle&body=Hello,Please attach your CV',
    );
    final url = params.toString();
    launchUrlString(url);
    newapplicants();
}
void newapplicants() async{
    var docreference = FirebaseFirestore.instance.collection('jobs')
        .doc(widget.jobid);

    docreference.update({
      'Applicants': applicants + 1,
    });
    Navigator.pop(context);
}
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.yellowAccent,],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2 , 0.9],

        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('lOAN DETAILS'),
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
          icon: (const Icon(Icons.close,color: Colors.white,
              size: 40,)
          ),
            onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Jobscreen()));
            },

          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:  CrossAxisAlignment.start,
            children: [
              Padding(

                  padding:const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black87,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 4,),
                          child: Text(
                            JobTitle == null ?
                            ''
                                :
                            JobTitle!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,


                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.grey,

                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        UserImage == null ?
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLaH8Aaj5UhYZugPaeytySWh-TJPmgiYwn3A&usqp=CAU'
                                            : UserImage!,
                                    ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10.0),
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      EmployerName == null ?
                                          ''
                                          :
                                      EmployerName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                      LocationCompany!,
                                    style:const TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(applicants.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            
                            const SizedBox(width: 6,),
                            const Text('Applicants',
                            style: TextStyle(
                              color: Colors.white,
                            ),),
                            const SizedBox(width: 10,),
                            const Icon(Icons.how_to_reg,
                            color: Colors.redAccent,),

                ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid != widget.uploadedBy
                        ?
                            Container()
                            :
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              divider(),
                              const Text('LOAN AVAILABILITY',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: (){
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if(_uid == widget.uploadedBy){
                                          try{
                                            FirebaseFirestore.instance.collection('jobs')
                                                .doc(widget.jobid)
                                                .update({'Recruitment' : true});
                                          }catch(error){
                                            GlobalMethod.showErrorDialog(error: 'Cant be performed', ctx: context);

                                          }
                                        }else {
                                          GlobalMethod.showErrorDialog(error: 'YOU CAN NOT PERFORM THIS ACTION', ctx: context);
                                        }
                                        getJobData();

                                      },
                                      child: const Text(
                                        'ON',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Opacity(
                                      opacity: Recruitment ==true ? 1 : 0,
                                  child: const Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  ),
                                  ),
                                  SizedBox(width: 40,),
                                  TextButton(
                                      onPressed: (){
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if(_uid == widget.uploadedBy){
                                          try{
                                            FirebaseFirestore.instance.collection('jobs')
                                                .doc(widget.jobid)
                                                .update({'Recruitment' : false});
                                          }catch(error){
                                            GlobalMethod.showErrorDialog(error: 'Cant be performed', ctx: context);

                                          }
                                        }else {
                                          GlobalMethod.showErrorDialog(error: 'YOU CAN NOT PERFORM THIS ACTION', ctx: context);
                                        }
                                        getJobData();

                                      },
                                      child: const Text(
                                        'OFF',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Opacity(
                                    opacity: Recruitment ==false ? 1 : 0,
                                    child: const Icon(
                                      Icons.check_box,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              )
                            ],),
                        divider(),
                        /*
                        Text('Job Description',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),),
                        SizedBox(height: 10,),
                        Text(
                          JobDescription == null ?
                              ''
                              :
                              JobDescription!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                         */
                        divider(),
                        const Text(' LOAN REQUIREMENTS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),),
                        const SizedBox(height: 10,),
                        Text(
                        JobRequirements == null ?
                          ''
                              :
                          JobRequirements!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        divider(),
                      ],
                    ),
                  ),
                ),

              ),
              Padding(
                  padding: EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black87,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            isDeadlineAvailable ?
                                'Actively loan available, Send application documents'
                                :
                                ' Its Past Deadline Date.Please try another Job ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDeadlineAvailable ?
                                  Colors.green :
                                  Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Center(
                          child: MaterialButton(
                            onPressed: (){
                              applyForJob();
                            },
                            color: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'Apply Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                            ),
                          ),
                        ),
                        divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Uploaded on',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              postedDate== null
                                  ?
                                  ''
                                  :
                              postedDate!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Deadline',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              deadlineDate == null ?
                              ''
                                  :
                              deadlineDate!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        divider(),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
                  padding:EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.black54,
                      child:Padding(
                          padding: EdgeInsets.all(8.0),
                          child:Column(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children:[
                                AnimatedSwitcher(
                                    duration:   Duration(
                                      milliseconds: 200,
                                    ),
                                  child: _isCommmenting ?
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                          child: TextFormField(
                                            controller: _commentingController ,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            maxLength: 500,
                                            keyboardType: TextInputType.text,
                                            maxLines: 7,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Theme.of(context).scaffoldBackgroundColor,
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white,
                                                
                                                )
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.blueAccent
                                                )
                                              )
                                            ),
                                          ),
                                      ),
                                      Flexible(
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: MaterialButton(
                                                  onPressed: () async {
                                                    if (_commentingController.text.length < 15){
                                                      GlobalMethod.showErrorDialog(error: 'Comment should be more than 15 characters',
                                                          ctx: context);
                                                    }
                                                    else{
                                                      final _generatedcommid = Uuid().v4();
                                                      await FirebaseFirestore.instance.collection('jobs')
                                                      .doc(widget.jobid)
                                                      .update({'jobcomments':
                                                        FieldValue.arrayUnion([{
                                                          'userid':FirebaseAuth.instance.currentUser!.uid,
                                                          'commentid': _generatedcommid,
                                                          'name': name,
                                                          'UserImage': UserImage,
                                                          'commentBody': _commentingController.text,
                                                          'time': Timestamp.now(),
                                                        }]),

                                                      
                                                      });
                                                      await Fluttertoast.showToast(
                                                          msg: 'Comment added succesfully',
                                                      toastLength: Toast.LENGTH_LONG,
                                                      backgroundColor: Colors.grey,
                                                      fontSize: 15.0);
                                                      _commentingController.clear();
                                                    }
                                                    setState(() {
                                                      showComment =true;
                                                    });
                                                  },
                                                  color: Colors.green,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child:  const Text(
                                                    'Post ',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                  onPressed: (){
                                                    setState(() {
                                                      _isCommmenting = !_isCommmenting;
                                                      showComment =true;
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ))
                                            ],
                                          )
                                      )
                                    ],
                                  )
                                      :
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: (){
                                                setState(() {
                                                  _isCommmenting = !_isCommmenting;
                                                  showComment = false;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.add_comment_sharp,
                                                color: Colors.white,
                                              ),
                                          ),
                                          const SizedBox(width: 10,),
                                          IconButton(
                                              onPressed: (){
                                                setState(() {
                                                  showComment = true;

                                                });
                                              },
                                              icon: const Icon(
                                                Icons.arrow_drop_down_circle_outlined,
                                                color: Colors.white,
                                              ),
                                          ),

                                        ],
                                      ),

                                ),
                                showComment == false
                                ? Container()
                                    :
                                    Padding(
                                        padding:EdgeInsets.all(20),
                                      child: FutureBuilder<DocumentSnapshot>(
                                          future: FirebaseFirestore.instance
                                    .collection('jobs')
                                    .doc(widget.jobid)
                                    .get(),
                                          builder:(context,snapshot){
                                            if (snapshot.connectionState == ConnectionState.waiting){
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            else{
                                              if(snapshot.data == null){
                                                const Center(
                                                  child: Text(
                                                      'No comments for this job'
                                                  ),
                                                );
                                              };
                                            }
                                            return ListView.separated(
                                              shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index){
                                                return COmments(
                                                  commentId:snapshot.data!['jobcomments'][index]['commentid'],
                                                    commentorId:snapshot.data!['jobcomments'][index]['userid'],
                                                commentorName:snapshot.data!['jobcomments'][index]['name'],
                                                commentBody:snapshot.data!['jobcomments'][index]['commentBody'],
                                                commentorImageUrl:snapshot.data!['jobcomments'][index]['UserImage'],
                                                );
                                                },
                                              separatorBuilder: (context,index){
                                                 return const Divider(
                                                   thickness: 1,
                                                   color: Colors.white,
                                                 );
                                              },
                                              itemCount: snapshot.data!['jobcomments'].length ,
                                               );
                                          }
                                      ),

                                    ),
                                SizedBox(height: 5,),
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      showComment = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_circle_up_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ]
                          )
                      )
                  )
              )

            ],
          ),
        ),
      ),
    );
  }
}
