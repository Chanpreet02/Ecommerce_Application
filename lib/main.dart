/*

import 'package:final_commerce/views/apiget.dart';
import 'package:final_commerce/views/cart.dart';
import 'package:final_commerce/views/datapage.dart';
import 'package:final_commerce/views/login.dart';
import 'package:final_commerce/views/previoususers.dart';
import 'package:final_commerce/views/productdetailspage.dart';
import 'package:final_commerce/views/sellerdetails.dart';
import 'package:final_commerce/views/signup.dart';
import 'package:final_commerce/views/wishlist.dart';
import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/":(context)=>SignupPage(),
        "/home":(context)=>ApiGet(),
        "/datapage":(context)=>DataPage(),
        "/cart":(context)=>CartPage(),
        "/signup":(context)=>SignupPage(),
        "/sellerform":(context)=>SellerDetailsPage(),
        "/previoususers":(context)=>PreviousUsers(),
        "/login":(context)=> LoginPage(),
        "/wishlist":(context)=> WishlistPage(wishlist: [])

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:final_commerce/views/apiget.dart';
import 'package:final_commerce/views/cart.dart';
import 'package:final_commerce/views/datapage.dart';
import 'package:final_commerce/views/login.dart';
import 'package:final_commerce/views/previoususers.dart';
import 'package:final_commerce/views/productdetailspage.dart';
import 'package:final_commerce/views/sellerdetails.dart';
import 'package:final_commerce/views/signup.dart';
import 'package:final_commerce/views/wishlist.dart';
import 'package:provider/provider.dart'; // Import the provider package


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartManager(), // Correctly using ChangeNotifierProvider
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          "/": (context) => SignupPage(),
          "/home": (context) => ApiGet(),
          "/datapage": (context) => DataPage(),
          "/cart": (context) => CartPage(),
          "/signup": (context) => SignupPage(),
          "/sellerform": (context) => SellerDetailsPage(),
          "/previoususers": (context) => PreviousUsers(),
          "/login": (context) => LoginPage(),
          "/wishlist": (context) => WishlistPage(wishlist: []),
        },
      ),
    );
  }
}
*/



import 'package:final_commerce/models/constant.dart';
import 'package:final_commerce/views/apiget.dart';
import 'package:final_commerce/views/cart.dart';
import 'package:final_commerce/views/datapage.dart';
import 'package:final_commerce/views/login.dart';
import 'package:final_commerce/views/payment.dart';
import 'package:final_commerce/views/previoususers.dart';
import 'package:final_commerce/views/sellerdetails.dart';
import 'package:final_commerce/views/signup.dart';
import 'package:final_commerce/views/wishlist.dart';
import 'package:final_commerce/models/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  runApp(const MyApp());
  Stripe.publishableKey = "pk_test_51QRTw5DZ9PbOirvL1wJjPRnEYFej0iYfDpAziOaDhLsHwCxcmgLrDFrlvjx5FRbrQVOZvaphWP7gPwg7KncG8NXH0019AqlpJA";
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        // "/":(context)=>SignupPage(),
        "/":(context) => payment(),
        "/home":(context)=>ApiGet(),
        "/datapage":(context)=>DataPage(),
        "/cart":(context)=>CartPage(),
        "/signup":(context)=>SignupPage(),
        "/sellerform":(context)=>SellerDetailsPage(),
        "/previoususers":(context)=>PreviousUsers(),
        "/login":(context)=> LoginPage(),
        "/wishlist":(context)=> WishlistPage(wishlist: [])

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
