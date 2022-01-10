

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';



void main() {
  runApp(const MyApp());
}
//główny ekran
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
  
//test values: do lepszego testowania polecam zmkienić na 0
  int to_mins = 60;
int to_hours = 3600;




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

//startuje czas głównegi timera
 void _start()
 {  
  
   if(!is_counting)
    {
      seconds_t = time.toInt() * to_hours ;
    }
    
    
   is_counting = true;
   
   
   //start timera
     _timer =Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        if(seconds_t>0)
        {
          seconds_t = seconds_t-1;

        }
        else
        {
          //jesli czas się skończy, to uruchamia alarm
          timer.cancel();
          is_counting = false;
          Navigator.push(
           context,
         MaterialPageRoute(builder: (context) => Alarm()),
  );

         
         
        }
        
      });
    });
 }

 //zatrzymanie głównego timera

 void _stop()
 {
   is_counting = false;
  seconds_t = 0;
  setState(() => _timer.cancel()
    
  );
  

   
 }
 //zaczyna przerwę 

 void _przerwa()
{
  is_break = true;
  setState(() => _timer.cancel()
  );
  brek_seconds = break_time.toInt() * to_mins;
  //uruchomienie timera przerwy
  _break_timer = Timer.periodic(Duration(seconds: 1), (timer){

      setState(()  {
        if(brek_seconds>0)
        {
          brek_seconds= brek_seconds-1;

        }
        else
        {
          
          timer.cancel();
 //otworzenie alarmu przerwy
    Navigator.push(
           context,
         MaterialPageRoute(builder: (context) => Break_Alarm()),
  ).then((value) {

  _start();

          
  is_break = false;
  });
  

        }
        
      });
    });

}
//zakończenie przerwy przed upływem czasu
void _end_break()
{
  is_break = false;
  _start();
  _break_timer.cancel();
}
//wyświetla czas, nie wiem dlacego tak zrobiłem, ale działa 
Widget display_time(int seconds)
{
    return Text(
              
              formatHHMMSS(seconds),
              style: Theme.of(context).textTheme.headline4,
            );
}

//zamienia format
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
          //styl gradient
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
          
          
        //wyśrodkowanie elementów na stronie
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
                seconds_t = time.toInt() * to_hours
                }
  },
              min: 1,
              max: 12,
              divisions: 11,
              label: '$time',
) ],
          
          if(!is_counting) ...[
          MaterialButton(
            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
                     padding: EdgeInsets.all(10.0),
                color: Colors.white,
                textColor: Color.fromRGBO(0, 160, 227, 1),
            onPressed: _start,
          child: 
          const Text("START"),
          )
           ]
          else if(!is_break)...[
          MaterialButton(
            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
                     padding: EdgeInsets.all(10.0),
                color: Colors.white,
                textColor: Color.fromRGBO(0, 160, 227, 1),
            onPressed: _stop,
          child: 
          Text("Całkowity koniec!!!"),
          ),
         
           Text(
            "Wybierz długość przerwy",
            style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue[700]
    ),

    
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

          MaterialButton(
            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
                     padding: EdgeInsets.all(10.0),
                color: Colors.white,
                textColor: Color.fromRGBO(0, 160, 227, 1),
            onPressed: _przerwa,
          child: 
          const Text("PRZERWA")
          )
          ],

         
         if(is_break)
          ...[
            Text(
              "Pozostały czas przerwy:",
              style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.blue[700]
    ),
            ),
            display_time(brek_seconds),

            MaterialButton(
              shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
                     padding: EdgeInsets.all(10.0),
                color: Colors.white,
                textColor: Color.fromRGBO(0, 160, 227, 1),
              onPressed: _end_break,

            child: Text("Zakończ przerwę i wróć do roboty"),
            
            )
           
          ]
          
          ],
// 
          
        ),
      ),
    
      ),
    );
  }
  

  
}


//wiget alamu po zakończeniu pracy

class  Alarm extends StatelessWidget {
  Alarm({ Key? key }) : super(key: key);

AudioPlayer player = AudioPlayer();

//funkcja grająca muzykę
Future<void> play_music()
async {
   String audioasset = "assets/end_work.mp3";
  ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
   Uint8List  soundbytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  int result = await player.playBytes(soundbytes);
                             
}
 

  @override
  Widget build(BuildContext context) {
 
    play_music();
   return Scaffold(
     
      body: Center(
        child: Container(
          
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

          Text("Na dzisiaj wystarczy",
          style: TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold),
          ),

           ElevatedButton(

             
          onPressed: () async {
            Navigator.pop(context, true);
            int result = await player.stop();
          },
          child: const Text('Koniec pracy'),
        ),
        




          ]),
          
          
        
        ),
      ),
    );
    
    
  }



  
  
}

//wiget alarmu przerwy
class  Break_Alarm extends StatelessWidget {
  Break_Alarm({ Key? key }) : super(key: key);

AudioPlayer player = AudioPlayer();
Future<void> play_music()
async {
   String audioasset = "assets/alarm.mp3";
  ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
   Uint8List  soundbytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  int result = await player.playBytes(soundbytes);
                             
}
 


  @override
  Widget build(BuildContext context) {
 
    play_music();
   return Scaffold(
     
      body: Center(
        child: Container(
          
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

          Text("ALARM",
          style: TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold),
          ),

           ElevatedButton(
          onPressed: () async {
            Navigator.pop(context, true);
            int result = await player.stop();
          },
          child: const Text('Koniec przerwy'),
        ),
        




          ]),
          
          
        
        ),
        
        
         
        
      ),
    );
    
    
  }

  
}
