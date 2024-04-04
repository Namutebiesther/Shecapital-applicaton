import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../Services/global_method.dart';
import '../Services/global_variables.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup>with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  final TextEditingController _fullNameController = TextEditingController(text: '');
  final TextEditingController _emailTextController = TextEditingController(text: '');
  final TextEditingController _passTextController = TextEditingController(text: '');
  final TextEditingController _confirmpassTextController = TextEditingController(text: '');
  final TextEditingController _phoneNumberTextController = TextEditingController(text: '');
  final TextEditingController _locationTextController = TextEditingController(text: '');

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _confirmpassFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _positionFocusNode = FocusNode();
  final _signupFormKey = GlobalKey<FormState>();
  bool _obscureText =true;


  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isloading = false;
  String? ImageUrl;
  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _phoneNumberTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _positionFocusNode.dispose();
    _positionFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _confirmpassFocusNode.dispose();
    _confirmpassTextController.dispose();

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
  void _showImageDialog(){
    showDialog(
        context: context,
        builder: (context){
          return  AlertDialog(
            title: const Text(
              'Please choose an option',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
               onTap: (){
                 _GetFromCamera();//create getFromCamera
               },
                  child: const Row(
                    children:[
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera_alt_sharp,
                          color: Colors.deepOrange,
                        ),
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(
                          color: Colors.deepOrange,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    _GetFromGallery();//create getFromGallery
                  },
                  child: const Row(
                    children:[
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image_search,
                          color: Colors.deepOrange,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          color: Colors.deepOrange,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
  void _GetFromCamera() async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    Navigator.pop(context);
  }
  void _GetFromGallery() async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }
  void _cropImage(FilePath) async{
    CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath: FilePath,
    maxHeight: 1080, maxWidth: 1080
    );
    if(croppedImage != null){
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }
  void _submitFormOnSigning() async{
    final isvalid = _signupFormKey.currentState!.validate();
    if(isvalid){
      if(imageFile == null){
        GlobalMethod.showErrorDialog(
          error: 'Please pick an image',
          ctx: context,
        );
        return;
      }
      setState(() {
        _isloading = true;
      });
      try{
        await _auth.createUserWithEmailAndPassword(
            email: _emailTextController.text.trim().toLowerCase(),
            password: _passTextController.text.trim());
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance.ref().child('userImages').child(_uid + '.jpg');
        await ref.putFile(imageFile!);
        ImageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id' : _uid,
          'name': _fullNameController.text,
          'email': _emailTextController.text,
          'UserImage': ImageUrl,
          'PhoneNumber': _phoneNumberTextController.text,
          'location': _locationTextController.text,
          'createdAt': Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.pop(context):null;
      } catch(error){
        setState(() {
          _isloading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }

    }
    setState(() {
      _isloading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
              imageUrl: signupUrlImage,
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context,url,error)=> const Icon(Icons.error),
            width:double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: 15),
              child:  ListView(
                children: [
                  Form(
                    key: _signupFormKey,
                      child: Column(
                        children: [
                        GestureDetector(
                          onTap: (){
                           _showImageDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: size.width * 0.24,
                              height: size.width * 0.24,
                              decoration: BoxDecoration(
                               border: Border.all(width: 2,color: Colors.cyanAccent,),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: imageFile == null ?
                                    const Icon(Icons.camera_alt_outlined, color: Colors.cyan, size: 30,)
                                    :Image.file(imageFile!, fit: BoxFit.fill,),
                              ),
                            ),
                          ) ,
                        ),
                          const SizedBox(height: 45,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
                            keyboardType: TextInputType.name,
                            controller: _fullNameController,
                            validator: (value){
                              if(value!.isEmpty ){
                                return 'This filled is missing';
                              }
                              else{
                                return null;
                              }
                            },
                            style: const TextStyle(
                              color: Colors.white,),
                            decoration: const InputDecoration(
                              hintText: 'Full Name or Company Name',
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
                          const SizedBox(height: 45,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextController,
                            validator: (value){
                              if(value!.isEmpty || !value.contains('@') ){
                                return 'Please enter a valid email address';
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
                          const SizedBox(height: 45,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_confirmpassFocusNode),
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passTextController,
                            obscureText: !_obscureText,
                            validator: (value){
                              if(value!.isEmpty || value.length < 7){
                                return 'Please enter a valid password. it must be atleast 7 characters';
                              }
                              else{
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
                          const SizedBox(height: 45,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
                            keyboardType: TextInputType.visiblePassword,
                            controller: _confirmpassTextController,
                            obscureText: !_obscureText,
                            validator: (value){
                              if(value!.isEmpty || value! == _passTextController){
                                return 'Passwords donot match';
                              }
                              else{
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
                              hintText: 'Confirm Password',
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
                          const SizedBox(height: 45,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_positionFocusNode),
                            keyboardType: TextInputType.phone,
                            controller: _phoneNumberTextController,
                            obscureText: !_obscureText,
                            validator: (value){
                              if(value!.isEmpty || value.length < 10 || RegExp(r'[A-Za-z]').hasMatch(value)){
                                return 'This field is missing or invalid phone number';
                              }
                              else{
                                return null;
                              }
                            },
                            style: const TextStyle(
                              color: Colors.white,),
                            decoration:  const InputDecoration(

                              hintText: 'Phone Number',
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
                          const SizedBox(height: 45,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_positionFocusNode),
                            keyboardType: TextInputType.text,
                            controller: _locationTextController,
                            obscureText: !_obscureText,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'This field is missing ';
                              }
                              else{
                                return null;
                              }
                            },
                            style: const TextStyle(
                              color: Colors.white,),
                            decoration:  const InputDecoration(

                              hintText: 'Company address or location',
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
                          const SizedBox(height: 25,),
                          _isloading
                          ? Center(
                           child:Container(
                             width: 70,
                             height: 80,
                             child: const CircularProgressIndicator(),
                           ) ,
                          )
                              : MaterialButton(onPressed: (){
                                _submitFormOnSigning();//create submit form on signup
                          },
                            color: Colors.cyan,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Signup',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40,),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Alread have an account ?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '     '
                                  ),

                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.canPop(context)
                                        ? Navigator.pop(context)
                                            : null,
                                    text: 'Log in',
                                    style: const TextStyle(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  ),
                            ],
                              ),
                            ),
                          ),
              const Column(
                children: [
                  Icon(
                    Icons.login_rounded,
                    color: Colors.red,
                  ),
                ],
              ),
                        ],
                      ),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
