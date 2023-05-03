import "package:flutter/material.dart";
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' hide CornerStyle;
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'dart:io';
import 'dart:convert';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
       
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late var socket;
  final _controller = ValueNotifier<bool>(false);
  bool _checked = false;

  final _controller2 = ValueNotifier<bool>(false);
  bool _checked2 = false;

  final _controller3 = ValueNotifier<bool>(false);
  bool _checked3 = false;

  final _controller4 = ValueNotifier<bool>(false);
  bool _checked4 = false;

  double _volumeValue = 50;
  double _volumeValue2 = 50;

  double x = 0, y = 0, z = 0, p = 0;

  bool allumer = false;
  void Xchanged(double value) {
    setState(() {
      x = value;
    });
  }

  void Ychanged(double value) {
    setState(() {
      y = value;
    });
  }

  void Zchanged(double value) {
    setState(() {
      z = value;
    });
  }

  void Pchanged(double value) {
    setState(() {
      p = value;
    });
  }

  void sendX(double value) {
    send('b$value\n');
  }

  void sendY(double value) {
    send('c$value\n');
  }

  void sendZ(double value) {
    send('d$value\n');
  }

  void sendP(double value) {
    send('e$value\n');
  }

  void onVolumeChanged(double value) {
    setState(() {
      _volumeValue = value;
    });
  }

  void onVolumeChanged2(double value) {
    setState(() {
      _volumeValue2 = value;
    });
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  connectToSocket() async {
    socket = await Socket.connect('127.0.0.1', 5000);

    final stream = socket.listen((event) {
      print(String.fromCharCodes(event));
    });
  }

  Future<void> send(data) async {
    socket.write(data);
  }

  @override
  void initState() {
    super.initState();
    connectToSocket();

    _controller.addListener(() {
      setState(() {
        if (_controller.value) {
          _checked = true;
        } else {
          _checked = false;
        }
      });
    });

    _controller2.addListener(() {
      setState(() {
        if (_controller2.value) {
          _checked2 = true;
        } else {
          _checked2 = false;
        }
      });

      send("from interface button is $_checked2");
    });

    _controller3.addListener(() {
      setState(() {
        if (_controller3.value) {
          _checked3 = true;
        } else {
          _checked3 = false;
        }
      });
    });

    _controller4.addListener(() {
      setState(() {
        if (_controller4.value) {
          _checked4 = true;
        } else {
          _checked4 = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: Icon(Icons.home),
          title: Row(
            children: [
              Text('ROBOT ASSEMBLEUR'),
              SizedBox(
                width: 70,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AutomaticPage()),
                  );
                },
                child: Text(
                  'MODE AUTOMATIQUE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  
                },
                child: const Text(
                  'MODE MANUELLE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.notification_important)),
                IconButton(onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                }, icon: Icon(Icons.settings))
              ],
            )
          ],
          centerTitle: true,
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                start(
                  setState,
                  size,
                ),
                IconButton(
                    iconSize: 100,
                    onPressed: () {
                      allumer = !allumer;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.adjust,
                      color: allumer ? Colors.green : Colors.red,
                      size: 100,
                    ))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                onoff('Activation de la presse', setState, _controller, size),
                gauge("Rotation tige d'assemblage", setState, size,
                    _volumeValue, onVolumeChanged),
                     onoff('Pipette', setState, _controller4, size),
              
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                onoff("Electro-aimant", setState, _controller2, size),
                gauge("Rotation disque", setState, size, _volumeValue2,
                    onVolumeChanged2),
                  
                onoff('Ventouse', setState, _controller3, size),
               
                 
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                Column(
                  children: [
                    Row(
                      children: [
                        xyz(
                            'X',
                            setState,
                            size,
                            Xchanged,
                            x,
                            Ychanged,
                            y,
                            Zchanged,
                            z,
                            p,
                            Pchanged,
                            sendX,
                            sendY,
                            sendZ,
                            sendP),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ]));
  }
}

//Copied

class AutomaticPage extends StatefulWidget {
  @override
  _AutomaticPageState createState() => _AutomaticPageState();
}

class _AutomaticPageState extends State<AutomaticPage> {
  late var socket;
  int _number = 0;
  double v = 0;
  void Vchanged(double value) {
    setState(() {
      v = value;
    });
  }
  void sendV(double value) {
    send('b$value\n');
  }
  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  connectToSocket() async {
    socket = await Socket.connect('127.0.0.1', 5000);

    final stream = socket.listen((event) {
      print(String.fromCharCodes(event));
    });
  }

  Future<void> send(data) async {
    socket.write(data);
  }


  void _incrementNumber() {
    setState(() {
      _number++;
    });
  }

  void _decrementNumber() {
    setState(() {
      if (_number > 0) {
        _number--;
      }
    });
  }

  Map<String, double> dataMap = {
    "Accomplie": 20,
    "Restant": 80,
   
  };

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      child:Scaffold(
      backgroundColor: Color.fromARGB(255, 54, 54, 54),
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Row(
          children: [
            Text('ROBOT ASSEMBLEUR'),
            SizedBox(
              width: 70,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AutomaticPage()),
                );
              },
              child: Text(
                'MODE AUTOMATIQUE',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Home Page')),
              );
                
              },
              child: const Text(
                'MODE MANUELLE',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: (
                    
                  ) {}, icon: Icon(Icons.notification_important)),
              IconButton(onPressed: (

              ) {
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
              }, icon: Icon(Icons.settings))
            ],
          )
      
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10), // Add space between rows

          Expanded(
            child: Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 40.0),
                    height: 100,
                      color: Color.fromARGB(255, 104, 103, 103),
                      child: TextButton(
                        onPressed: () {
                          // Add your functionality here
                        },
                        child: Text(
                          'Start',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 30.0, bottom: 30.0, left:10.0,right:10.0),
                    
                    color: Color.fromARGB(255, 90, 87, 87),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
  alignment: Alignment.center,
  child: Text(
    'Lot de Production',
    style: TextStyle(
      color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
    ),
  ),
),
                        // ignore: prefer_const_constructors
                        
                        SizedBox(height: 4.0),
                        Divider(
                          color: Colors.white,
                          thickness: 1.0,
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [Container(
  width: 10.0,
  height: 10.0),
                            Container(
  width: 20.0,
  height: 20.0,
  color: Color.fromARGB(255, 147, 247, 150),
  child: Align(
  alignment: Alignment.center,
  child: Text(
                              '$_number',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
                              ),
                            ),
)
  
),
Container( width: 10.0,
  height: 10.0),

Container(
  child:Align(
  alignment: Alignment.center,
  child: Text(
    'Piles boutons',
    style: TextStyle(
      fontWeight: FontWeight.normal,
  fontSize: 10.0,
      color: Colors.green,
    ),
  ),
)
),
                            IconButton(
                              icon: Icon(Icons.remove),
                              color: Colors.white,
                              onPressed: _decrementNumber,
                            ),
                            
                            IconButton(
                              icon: Icon(Icons.add),
                              color: Colors.white,
                              onPressed: _incrementNumber,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left:20.0,right:10.0),
                    
                    color: Color.fromARGB(255, 90, 87, 87),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
  alignment: Alignment.center,
  child: Text(
    'Vitesse de production',
    style: TextStyle(
      color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
    ),
  ),
),
                        // ignore: prefer_const_constructors
                        
                        SizedBox(height: 4.0),
                        Divider(
                          color: Colors.white,
                          thickness: 1.0,
                        ),
                        SizedBox(height: 2.0),
                        Expanded(
              child: SfLinearGauge(
                minimum: 0,
                maximum: 100,
                barPointers: [
                  LinearBarPointer(
                    value: v,
                    color: Colors.yellow,
                  )
                ],
                markerPointers: [
                  LinearShapePointer(
                    value: v,
                    onChanged: Vchanged,
                    onChangeEnd: sendV,
                    color: Colors.yellow,
                  ),
                ],
              ),
            )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.0),
                    
                    height: 100,
                    color: Colors.red,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        // Add your functionality here
                      },
                      child: Text(
                        'ARRET URGENCE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 30.0, bottom: 30.0, left:10.0,right:10.0),
                    
                    color: Color.fromARGB(255, 90, 87, 87),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
  alignment: Alignment.center,
  child: Text(
    'Temps restant',
    style: TextStyle(
      color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
    ),
  ),
),
                        // ignore: prefer_const_constructors
                        
                        SizedBox(height: 8.0),
                        Divider(
                          color: Colors.white,
                          thickness: 1.0,
                        ),
                        SizedBox(height: 3.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        

Container(
  
  child:Align(
  alignment: Alignment.center,
  
  child: Text(
    '00:00:00',
    style: TextStyle(
      fontWeight: FontWeight.normal,
  fontSize: 18.0,
      color: Colors.blue,
    ),
  ),
)
),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30.0, left:20.0,right:20.0),
                    
                    color: Color.fromARGB(255, 90, 87, 87),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
  alignment: Alignment.center,
  child: Text(
    'Avancement',
    style: TextStyle(
      color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
    ),
  ),
),
                        // ignore: prefer_const_constructors
                        
                        SizedBox(height: 4.0),
                        Divider(
                          color: Colors.white,
                          thickness: 1.0,
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            
Container( width: 10.0,
  height: 10.0),

Container(
  child:Align(
  alignment: Alignment.center,
  child: PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 400),
      chartLegendSpacing: 15,
      chartRadius: MediaQuery.of(context).size.width / 15,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 15,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
      // gradientList: ---To add gradient colors---
      // emptyColorGradient: ---Empty Color gradient---
    ),
)
),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.home),
          title: Row(
            children: [
              Text('ROBOT ASSEMBLEUR'),
              SizedBox(
                width: 70,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AutomaticPage()),
                  );
                },
                child: Text(
                  'MODE AUTOMATIQUE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Home Page')),
                  );
                },
                child: const Text(
                  'MODE MANUELLE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.notification_important)),
                IconButton(onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                }, icon: Icon(Icons.settings))
              ],
            )
          ],
          centerTitle: true,
        ),
      body: Column(
    children: [
      Expanded(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Color.fromARGB(255, 37, 37, 37),
                child: Center(
                child: Image.asset('asset/image.png'),
                ),
              ),
            ),
            Expanded(
              flex:5,
                 child:Container(
      color: Colors.grey[900], // dark background color
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Etat de Stock', // top text
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: Colors.white, // white divider
            height: 10.0,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: StockCell(
            text: 'Example Text',
            percentage: 0.7,
          ),
                ),
                Expanded(
                  child: StockCell(
            text: 'Example Text',
            percentage: 0.7,
          ),
                ),
                Expanded(
                  child:StockCell(
            text: 'Example Text',
            percentage: 0.7,
          ),
                ),
                Expanded(
                  child: StockCell(
            text: 'Example Text',
            percentage: 0.7,
          ),
                ),
                Expanded(
                  child: StockCell(
            text: 'Example Text',
            percentage: 0.7,
          ),
                ),
                Expanded(
                  child: StockCell(
            text: 'Example Text',
            percentage: 0.7,
          ),
                ),
                Expanded(
                  child: StockCell(
            text: 'Example Text',
            percentage: 0.7,
          ),
                ),
                Expanded(
                  child: StockCell(
            text: 'Example Text',
            percentage: 0.7,
          ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
                ),
           
          ],
        ),
      ),
      Expanded(
        child: Row(
          children: [
            
            Expanded(
              
              flex: 2,
              child: Container(
                 width: double.infinity,
        height: double.infinity,
  padding: EdgeInsets.all(20),
  color:Colors.grey[900],
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
  padding: EdgeInsets.only(bottom: 15),
  child: Text(
        'Maintenance',
        style: TextStyle(fontSize: 24,
        color:Colors.white,
        ),
      ),
),
      
      ElevatedButton(
        onPressed: () {
          // Reset button logic here
        },
        child: Text('Reset'),
      ),
    ],
  ),
),
            ),
            Expanded(
              flex: 5,
              child: Container(
  color: Color.fromARGB(255, 37, 37, 37),
  child: Row(
    children: [
      Expanded(
        child: MaintWarn(),
      ),
      Expanded(
        child: MaintWarn(),
      ),
      Expanded(
        child:  MaintWarn(),
      ),
      Expanded(
        child:  MaintWarn(),
      ),
      Expanded(
        child:  MaintWarn(),
      ),
    ],
  ),
),
            ),
          ],
        ),
      ),
    ],
  ),
    );
  }
}

Widget onoff(text, setState, _controller, size) {
  return Container(
    height: size.height / 5,
    width: size.height / 5,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 37, 37, 37),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(5),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
        const Divider(
          thickness: 1,
          height: 10,
          color: Colors.white,
        ),
        AdvancedSwitch(
          controller: _controller,
          inactiveColor: Color.fromARGB(255, 204, 204, 204),
          width: 40,
          height: 20,
          borderRadius: BorderRadius.circular(30),
          activeChild: Text('ON'),
          inactiveChild: Text('OFF'),
          thumb: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white, width: 2)),
          ),
        ),
      ],
    ),
  );
}

Widget gauge(text, setState, size, _volumeValue, onVolumeChanged) {
  return Container(
    height: size.height / 5,
    width: size.height / 5,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 37, 37, 37),
      borderRadius: BorderRadius.circular(5),
    ),
    padding: const EdgeInsets.all(5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 9),
        ),
        const Divider(
          thickness: 1,
          height: 10,
          color: Colors.white,
        ),
        Expanded(
          child: SfRadialGauge(axes: <RadialAxis>[
            RadialAxis(
                minimum: 0,
                maximum: 4096,
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.7,
                axisLineStyle:
                    AxisLineStyle(color: Colors.black12, thickness: 10),
                pointers: <GaugePointer>[
                  RangePointer(
                      value: _volumeValue,
                      width: 6,
                      sizeUnit: GaugeSizeUnit.logicalPixel,
                      gradient: const SweepGradient(colors: <Color>[
                        Color.fromARGB(255, 82, 82, 3),
                        Colors.yellow,
                      ], stops: <double>[
                        0.25,
                        0.75
                      ])),
                  MarkerPointer(
                      value: _volumeValue,
                      enableDragging: true,
                      onValueChanged: onVolumeChanged,
                      markerHeight: 8,
                      markerWidth: 8,
                      markerType: MarkerType.circle,
                      color: Colors.white,
                      borderWidth: 1,
                      borderColor: Colors.white)
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      angle: 90,
                      axisValue: 5,
                      positionFactor: 1,
                      widget: Text(
                          (_volumeValue * 360 / 4096).toStringAsFixed(2) + '°',
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)))
                ])
          ]),
        )
      ],
    ),
  );
}

Widget xyz(text, setState, size, Xchanged, x, Ychanged, y, Zchanged, z, p,
    Pchanged, sendX, sendY, sendZ, sendP) {
  return Container(
    height: size.height/ 1.2,
    width: size.height / 2,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 37, 37, 37),
      borderRadius: BorderRadius.circular(5),
    ),
    padding: const EdgeInsets.all(3),
    margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'X',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const Text(
              'mm',
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
            Expanded(
              child: SfLinearGauge(
                minimum: 0,
                maximum: 500,
                barPointers: [
                  LinearBarPointer(
                    value: x,
                    color: Colors.yellow,
                  )
                ],
                markerPointers: [
                  LinearShapePointer(
                    value: x,
                    onChanged: Xchanged,
                    onChangeEnd: sendX,
                    color: Colors.yellow,
                  ),
                ],
              ),
            )
          ],
        ),
        const Divider(
          thickness: 1,
          height: 20,
          color: Colors.white,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Y',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const Text(
              'mm',
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
            Expanded(
              child: SfLinearGauge(
                minimum: 0,
                maximum: 100,
                barPointers: [
                  LinearBarPointer(
                    value: y,
                    color: Colors.yellow,
                  )
                ],
                markerPointers: [
                  LinearShapePointer(
                    value: y,
                    onChanged: Ychanged,
                    onChangeEnd: sendY,
                    color: Colors.yellow,
                  ),
                ],
              ),
            )
          ],
        ),
        const Divider(
          thickness: 1,
          height: 20,
          color: Colors.white,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Z',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const Text(
              'mm',
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
            Expanded(
              child: SfLinearGauge(
                minimum: 0,
                maximum: 50,
                barPointers: [
                  LinearBarPointer(
                    value: z,
                    color: Colors.yellow,
                  )
                ],
                markerPointers: [
                  LinearShapePointer(
                    value: z,
                    onChanged: Zchanged,
                    onChangeEnd: sendZ,
                    color: Colors.yellow,
                  ),
                ],
              ),
            )
          ],
        ),
        const Divider(
          thickness: 1,
          height: 20,
          color: Colors.white,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'A',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const Text(
              'mm',
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
            Expanded(
              child: SfLinearGauge(
                minimum: 0,
                maximum: 50,
                barPointers: [
                  LinearBarPointer(
                    value: p,
                    color: Colors.yellow,
                  )
                ],
                markerPointers: [
                  LinearShapePointer(
                    value: p,
                    onChanged: Pchanged,
                    onChangeEnd: sendP,
                    color: Colors.yellow,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
}
class StockCell extends StatelessWidget {
  final String text;
  final double percentage;

  const StockCell({required this.text, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[800], // cell background color
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              // Do something when the button is pressed
            },
            child: Text(
              'Reset', // button above
              style: TextStyle(
                color: Colors.blue,
                fontSize: 8.0,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            width: 10.0,
            height: 60.0,
            child: VerticalBar(percentage: percentage, color: Colors.red),
          ),
          SizedBox(height: 16.0),
          Text(
            text, // text below
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalBarPainter extends CustomPainter {
  final double percentage;
  final Color color;

  VerticalBarPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final barHeight = size.height * percentage;
    final paint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(0, size.height - barHeight, size.width, barHeight), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
class VerticalBar extends StatelessWidget {
  final double percentage;
  final Color color;

  VerticalBar({required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: VerticalBarPainter(percentage: percentage, color: color),
      size: Size.infinite,
    );
  }
}

class MaintWarn extends StatefulWidget {
  const MaintWarn({Key? key}) : super(key: key);

  @override
  _MaintWarnState createState() => _MaintWarnState();
}

class _MaintWarnState extends State<MaintWarn> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isEditing = false;
  double _rangeValue = 70;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
            child: Text('Edit'),
          ),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _rangeValue -= details.delta.dy / 2;
                  if (_rangeValue < 0) _rangeValue = 0;
                  if (_rangeValue > 100) _rangeValue = 100;
                });
              },
              child: SfRadialGauge(
                axes: [
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    showLabels: false,
                    showTicks: false,
                    axisLineStyle: AxisLineStyle(
                      thickness: 0.2,
                      color: Colors.grey,
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    pointers: [
                      RangePointer(
                        value: _rangeValue,
                        width: 0.2,
                        sizeUnit: GaugeSizeUnit.factor,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isEditing)
            TextField(
              controller: _textEditingController,
              onSubmitted: (String text) {
                int myInt = int.tryParse(text) ?? _rangeValue.toInt();
                setState(() {
                  _rangeValue = myInt.toDouble();
                });
                setState(() {
                  _isEditing = false;
                });
              },
              decoration: InputDecoration(
   hintStyle: TextStyle(color: Color.fromARGB(255, 196, 195, 195)),
    hintText: 'Modifier',
    prefixIcon: Icon(Icons.edit),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
            )
          else
           Container(
  margin: EdgeInsets.only(bottom: 10.0),
  child: Text(
    
    '${_rangeValue.toInt()}',
    style: TextStyle(
      color:Color.fromARGB(255, 206, 206, 206),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
),

        ],
      ),
    );
  }
}



Widget start(
  setState,
  size,
) {
  return Container(
      width: size.height / 2,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 37, 37, 37),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: Image.asset('asset/image.png'));
}
