import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/background_login.jpg',
            fit: BoxFit.cover,
      ),

      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(150, 253, 251, 255),
              Color.fromARGB(200, 141, 171, 136),
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start, 
                children: [
                  // judul
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon( 
                          Icons.book, 
                          size: 35,
                           color: const Color.fromARGB(255, 45, 92, 21),
                        ),
                        const SizedBox(width: 7),
                        const Text(
                          'Jawara Pintar',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ), 
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Solusi digital untuk manajemen keuangan dan kegiatan warga',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
        
                  //EMAIL 
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    cursorColor: Color.fromARGB(255, 45, 92, 21),
                    decoration: InputDecoration(
                      hintText: 'Masukkan email disini',
                       prefixIcon: Icon(Icons.mail),
                       border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ), 
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB( 255,45,92,21,), 
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
        
                  // PASSWORD FIELD 
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    cursorColor: Color.fromARGB(255, 45, 92, 21),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password disini',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 45, 92, 21),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
        
                  // LOGIN BUTTON 
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 45, 92, 21),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        // Navigator.pushReplacementNamed(context, '/dashboard');
                      },
                      child: const Text('Login',
                       style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                        ),
                        )
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  // Sign up section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun?',
                        style: TextStyle(color: Colors.black87),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(3),
                          minimumSize: Size(50, 50),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Daftar',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 45, 92, 21)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
    ]
    )
    );
  }
}