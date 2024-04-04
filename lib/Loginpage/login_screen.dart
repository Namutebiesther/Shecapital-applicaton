import 'package:cached_network_image/cached_network_image.dart';
import 'package:ekyeyo/Services/global_method.dart';
import 'package:ekyeyo/Signup/signup_screen.dart';
import 'package:ekyeyo/forgotPassword/forgot_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Services/global_variables.dart';


class Login extends StatefulWidget {


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
 late Animation<double> _animation;
  late AnimationController _animationController;
  final TextEditingController _emailTextController = TextEditingController(text: '');
  final TextEditingController _passTextController = TextEditingController(text: '');
  final FocusNode _passFocusNode = FocusNode();
  bool _isloading = false;
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _loginformkey = GlobalKey<FormState>();
  @override
  void dispose() {
   _animationController.dispose();
   _emailTextController.dispose();
   _passTextController.dispose();
   _passFocusNode.dispose();
    super.dispose();
  }
  @override
  void initState() {
   _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 20));
   _animation =CurvedAnimation(parent: _animationController, curve: Curves.linear)
   ..addListener(() {
     setState(() {


     });


   })
   ..addStatusListener((animationStatus) {
     if(animationStatus == AnimationStatus.completed)
       {
         _animationController.reset();
         _animationController.forward();
       }
   });
   _animationController.forward();
    super.initState();
  }

  void _submitFormOnLogin() async {
    final isvalid = _loginformkey.currentState!.validate();
    if (isvalid) {
      setState(() {
        _isloading = true;
      });
      try{
        await _auth.signInWithEmailAndPassword(email: _emailTextController.text.trim().toLowerCase(), password: _passTextController.text.trim());
        Navigator.canPop(context) ?  Navigator.pop(context) : null;
      }catch(error){
        setState(() {
          _isloading =false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        print('Error occured $error');
      }
    }
    setState(() {
      _isloading =false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context,url,error)=> Icon(Icons.error),
            width:double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: (const EdgeInsets.symmetric(horizontal: 16, vertical: 80)),
              child:ListView(
                children: [
                  Padding(padding: const EdgeInsets.only(
              left: 80, right: 82),
                    child: Image.asset('assets/images/login.png'),
                  ),
                  const SizedBox(height: 15,),
                  Form(
                    key: _loginformkey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value){
                            if(value!.isEmpty || !value.contains('@')){
                              return 'please enter a valid email';
                            }
                            else{
                              return null;
                            }
                          },
                          style: const TextStyle(
                              color: Colors.white,),
                        decoration: const InputDecoration(
                        hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _passFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller:_passTextController ,
                          obscureText: !_obscureText,
                          validator: (value){
                            if(value!.isEmpty || value.length < 7){
                              return 'please enter a valid password';
                            }else{
                              return null;
                            }
                          },
                          style: const TextStyle(
                            color: Colors.white,),
                          decoration:  InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: ()
                              {
                                setState(() {
                                  _obscureText = !_obscureText;
                              });
                              },
                              child: Icon(
                                _obscureText
                                ?Icons.visibility
                                    :Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => ForgotPasswordScreen())));
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        MaterialButton(onPressed: _submitFormOnLogin,
                          color: Colors.deepOrange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),),

                              ],
                            ),
                          ),
                            
                        ),
                        const SizedBox(height: 40,),
                         Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Do not have an account ?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                                ),
                                const TextSpan(text: '        '),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup())),
                                  text: 'signup',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ) ,
            ),
          ),
        ],
      )
    );
  }
}
