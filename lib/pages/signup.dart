import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/pages/login.dart';

class Signup extends StatefulWidget {

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formkey = GlobalKey<FormState>();

  var email = " ";
  var password = " ";
  var confirmPassword = " ";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  registration()async{
    if (password == confirmPassword){
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text('Registered successfully',
            style: TextStyle(fontSize: 20),
            ),
        ),
        );
       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginPage(),),);
      } on FirebaseAuthException catch (error) {
        if (error.code == 'weak password'){
          print('password is to weak');

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text('password is to weak',
              style: TextStyle(fontSize: 20, color: Colors.amberAccent),
            ),
          ),
          );
        }
        else if (error.code == 'email-already in use'){
          print('Account already exists');

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text('Account already exists',
              style: TextStyle(fontSize: 20, color: Colors.amberAccent),
            ),
          ),
          );
        }
    }
    }
    else {
      print('Password does not match');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blueGrey,
        content: Text('Password does not match',
          style: TextStyle(fontSize: 20, color: Colors.amberAccent),
        ),
      ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60,horizontal: 20),
          child: ListView(
            children: [
              Padding(padding: const EdgeInsets.all(30),
              child: Image.asset("images/signup.png"),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'email:',
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                    errorStyle:
                      TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  controller: emailController,
                  validator: (value){
                    if ( value == null || value.isEmpty){
                      return ' Please enter email';
                    }
                    else if (!value.contains('@')){
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: ' Confirm Password ',
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                    errorStyle:
                      TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  controller: confirmPasswordController,
                  validator:  (value){
                    if ( value == null || value.isEmpty){
                      return ' Please confirm password';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                child: Row(
                  children: [
                    ElevatedButton(onPressed: (){
                      if (_formkey.currentState!.validate()){
                        setState(() {
                          email = emailController.text;
                          password = passwordController.text;
                          confirmPassword = confirmPasswordController.text;
                        });
                        registration();
                      }
                    },
                        child: Text(' Signup ',
                        style: TextStyle(fontSize: 18),
                    ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account ? '),
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation, animation2) => LoginPage(),
                      transitionDuration: Duration(seconds: 0),),
                      );
                    },
                        child: Text('Log in'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
