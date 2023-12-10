import 'package:flutter/material.dart';
import 'package:gmaps_spinoff/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 248, 249),
      body: Align(
        alignment: AlignmentDirectional(0, 1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              // logo image
              

              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: Color(0x24000000),
                      offset: Offset(0, -1),
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 15, 15, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            // welcome back text
                            child: Text(
                              'Lets Create an Account',
                              style: GoogleFonts.raleway(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17.0, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Email Address',
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(25, 15, 0, 15),
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17.0, vertical: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Password',
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(25, 15, 0, 15),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: InkWell(
                            onTap: () {},
                            child: Icon(Icons.visibility),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 244, 91, 105),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                      color: Color(0xFFE0E3E7),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(fontSize: 15),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
