import 'package:flutter/material.dart';
import '../components/button.dart';
import 'home.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book_sharp,
                size: 80,
                color: Colors.blueAccent,),
              const SizedBox(height: 20,),
              const Text('Note App',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                ),),
              const SizedBox(height: 10,),
              const Text('Lets take Notes and store Memories',
                style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 20,) ,
              MyButton(onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));},
                  child: const Text('Take Notes',
                    style: TextStyle(
                      color: Colors.white,),))
            ],
          ),
        )
    );
  }
}

