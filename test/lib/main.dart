

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Czas pracy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
//main timer values
  double time = 1.0;
  int seconds_t = 0;

  bool is_counting = false;
  

late  Timer _timer;

//break values
late Timer _break_timer;
bool is_break = false;
double break_time = 5.0;
int brek_secons = 0; 

  

 void _start()
 {  
    if(!is_counting)
    {
      seconds_t = time.toInt() * 3600;
    }
    
   is_counting = true;
   
   
   
     _timer =Timer.periodic(Duration(seconds: 1), (timer){

      setState(() {
        if(seconds_t>0)
        {
          seconds_t = seconds_t-1;

        }
        else
        {
          timer.cancel();
          is_counting = false;
        }
        
      });
    });
 }

 void _stop()
 {
   is_counting = false;
  seconds_t = 0;
  setState(() => _timer.cancel()
    
  );
  

   
 }

 void _przerwa()
{
  is_break = true;
  setState(() => _timer.cancel()
    
  );
  brek_secons = break_time.toInt();
  _break_timer = Timer.periodic(Duration(seconds: 1), (timer){

      setState(() {
        if(brek_secons>0)
        {
          brek_secons= brek_secons-1;

        }
        else
        {
          timer.cancel();
         
          _start();
        }
        
      });
    });

}
Widget display_time(int seconds)
{
    return Text(
              
              formatHHMMSS(seconds),
              style: Theme.of(context).textTheme.headline4,
            );
}


 String formatHHMMSS(int seconds) {
  int hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  int minutes = (seconds / 60).truncate();

  String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  if (hours == 0) {
    return "$minutesStr:$secondsStr";
  }

  return "$hoursStr:$minutesStr:$secondsStr";
}
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        
        title: Text(widget.title),
      ),
      body: Center(
       
        child: Column(
        
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            display_time(seconds_t),
          !is_counting ?
            Slider(
               value: time,
  
               onChanged: (newValue) => {
             setState(() => time = newValue)
  },
              min: 1,
              max: 12,
              divisions: 11,
              label: '$time',
) :SizedBox.shrink(),
          
          if(!is_counting) ...[
          MaterialButton(onPressed: _start,
          child: 
          const Text("START"),
          )
           ]
          else ...[
          MaterialButton(onPressed: _stop,
          child: 
          Text("STOP"),
          ), Text(
            "Wybierz długość przerwy"
          ),
          
           Slider(
               value: break_time,
  
               onChanged: (newValue) => {
             setState(() => break_time = newValue)
  },
              min: 5,
              max: 45,
              divisions: 8,
              label: '$break_time',
),
          MaterialButton(onPressed: _przerwa,
          child: 
          Text("PRZERWA")
          )
          ],
        
          
          ],

          
        ),
      ),
      
    );
  }
  

  
}
