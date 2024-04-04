import 'package:ekyeyo/Search/search_job.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Othersites extends StatefulWidget {


  @override
  _OthersitesState createState() => _OthersitesState();
}

class _OthersitesState extends State<Othersites> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Searchjobs()));
          },
        ),


      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchURL,
          child: Text('Open URL'),
        ),
      ),
    );
  }
}
void _launchURL() async {
  const url = 'https://nilepost.co.ug/jobs/'; // Replace with your desired URL
  if (await canLaunchUrl(url as Uri)) {
    await launchUrl(url as Uri);
  } else {
    throw 'Could not launch $url';
  }
}

