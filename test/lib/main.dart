

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
      title: 'Czasomierz',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Czas pracy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
//main timer values
  double time = 1.0;
  int seconds_t = 3600;

  bool is_counting = false;
  

late  Timer _timer;

//break values
late Timer _break_timer;
bool is_break = false;
double break_time = 5.0;
int brek_seconds = 300; 


  
  // TODO  *3600 aby działało na godzinach

 void _start()
 {  
   if(!is_counting)
    {
      seconds_t = time.toInt() ;
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
  brek_seconds = break_time.toInt();
  _break_timer = Timer.periodic(Duration(seconds: 1), (timer){

      setState(() {
        if(brek_seconds>0)
        {
          brek_seconds= brek_seconds-1;

        }
        else
        {
          timer.cancel();
         
          _start();
          is_break = false;
          //TODO wiget 
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
    return Scaffold(
      appBar: AppBar(
        
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.white,
              ],
            ),
          ),
        
        width: double.infinity,
        height: double.infinity,
       
        child: Column(
          
          
        
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
          display_time(seconds_t),
          
          if( !is_counting) ...[
            Slider(
               value: time,
  
               onChanged: (newValue) => {
             setState(() => time = newValue),
             if(!is_counting)
              {
                seconds_t = time.toInt() 
                }
  },
              min: 1,
              max: 12,
              divisions: 11,
              label: '$time',
) ],
          
          if(!is_counting) ...[
          MaterialButton(onPressed: _start,
          child: 
          const Text("START"),
          )
           ]
          else if(!is_break)...[
          MaterialButton(onPressed: _stop,
          child: 
          Text("Całkowity koniec!!!"),
          ),
         
           Text(
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
          const Text("PRZERWA")
          )
          ],

         
         if(is_break)
          ...[
            Text(
              "Pozostały czas przerwy:"
            ),
            display_time(brek_seconds),
           
          ]
          
          ],
// 
          
        ),
      ),
    
      ),
    );
  }
  

  
}
