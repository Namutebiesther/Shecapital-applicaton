import 'package:ekyeyo/user_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';




void main() {
  Stripe.publishableKey = 'pk_test_51NcnW3GIO8vcgq4QVnVKtCPzGXsD0YyZPZpReerSwxYVtjvI3J9yt5pd7kg68L7EkRGRJhAwnVxZUPGtR2O4ASmY009rcu6arK';
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
        builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Welcome To UG JobConnect',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Signatra'
                  ),
                ),
              ),
            ),
          );
        }
        else if(snapshot.hasError){
          return MaterialApp(
            home: Scaffold(
             body: Center(
               child: Text('AN ERROR HAS OCCURED',
               style: TextStyle(
                 color: Colors.cyan,
                 fontSize: 40,
                 fontWeight: FontWeight.bold
               ),),
             ),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UG JobConnect',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            primaryColor: Colors.blue,
          ),
          home: UserState(),
        );
        }
    );
  }
}







