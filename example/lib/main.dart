import 'package:flutter/material.dart';
import 'package:vimeo_player_jfv/vimeo_player_jfv.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vimeo Url',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Vimeo Url lib'),
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: VimeoPlayerUrl(
        url:
            'https://player.vimeo.com/video/59777392?h=ab882a04fd&loop=1', // url video Vimeo
        progress: 10, // Initial progress in seconds
      ),
    );
  }
}
