import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_tyre/services/api/ergast_data_provider.dart';
import 'package:hard_tyre/services/api/livetiming_data_provider.dart';
import 'package:hard_tyre/services/api/reddit_data_provider.dart';
import 'package:hard_tyre/services/api/twitter_data_provider.dart';
import 'package:hard_tyre/widgets/tiles/media_tile_widget.dart';

import 'models/media/media_tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Hard Tyre',
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 52,
                  letterSpacing: 2,
                  height: 0.7,
                  color: Colors.black87)),
          headline2: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  letterSpacing: 1.5,
                  height: 0.8,
                  color: Colors.black87)),
          headline3: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.5,
            height: 0.8,
            color: Colors.black87,
          )),
          headline4: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontSize: 24,
            letterSpacing: 1.5,
            height: 0.8,
            color: Colors.black87,
          )),
          headline5: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.5,
            height: 0.8,
            color: Colors.black87,
          )),
          headline6: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontSize: 18,
            letterSpacing: 1.5,
            height: 0.8,
            color: Colors.black87,
          )),
          bodyText1: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontSize: 14,
            height: 1.2,
            color: Colors.black87,
          )),
          bodyText2: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontSize: 12,
            height: 1.2,
            color: Colors.black87,
          )),
          subtitle1: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontSize: 14,
            height: 1.2,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          )),
          subtitle2: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            height: 1.2,
            color: Colors.black87,
          )),
          caption: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontSize: 10,
            color: Colors.black87,
          )),
        ),
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
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'we are checking'),
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
  late ErgastDataProvider _ergast;
  late TwitterDataProvider _twitter;
  late LivetimingDataProvider _livetiming;
  late RedditDataProvider _reddit;

  late List<MediaTile> _mainMedia;
  List<MediaTile> _displayedMedia = [];
  List<MediaTile>? _redditMedia;
  List<MediaTile>? _twitterMedia;
  bool _isDetailedMode = false;

  void _showMoreReddit() {
    _redditMedia ??= _reddit.subreddits
        .map((s) => MediaTile('u/$s', FontAwesomeIcons.reddit,
            () async => await _reddit.getHotPosts(s), null))
        .toList();
    setState(() {
      _displayedMedia = _redditMedia!;
      _isDetailedMode = true;
    });
  }

  void _showMoreTwitter() {
    _twitterMedia ??= _twitter.usernames
        .map((t) => MediaTile('@$t', FontAwesomeIcons.twitter,
            () async => await _twitter.getUserTweets(t), null))
        .toList();
    setState(() {
      _displayedMedia = _twitterMedia!;
      _isDetailedMode = true;
    });
  }

  void _showHome() {
    setState(() {
      _displayedMedia = _mainMedia;
      _isDetailedMode = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _ergast = ErgastDataProvider();
    _twitter = TwitterDataProvider();
    _reddit = RedditDataProvider();
    _livetiming = LivetimingDataProvider();
    _mainMedia = [
      MediaTile('Driver standings', FontAwesomeIcons.trophy,
          _ergast.getDriverStandings, null),
      MediaTile('Constructor standings', FontAwesomeIcons.car,
          _ergast.getConstructorStandings, null),
      MediaTile('Hot reddit posts', FontAwesomeIcons.reddit,
          _reddit.getAllHotPosts, _showMoreReddit),
      MediaTile('Recent tweets', FontAwesomeIcons.twitter,
          _twitter.getTweetTimeline, _showMoreTwitter),
      MediaTile('Lap comparisons', FontAwesomeIcons.codeCompare, () async => await _livetiming.getLapPositionComparisons("1", "44"), null)
    ];
    _displayedMedia = _mainMedia;
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
          centerTitle: true,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.surround_sound),
              const SizedBox(width: 10),
              Text(widget.title),
            ],
          ),
          leading: _isDetailedMode
              ? BackButton(
                  onPressed: _showHome,
                )
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16.0),
          child: ListView(
              physics: const BouncingScrollPhysics(),
              children: _displayedMedia
                  .map((e) => MediaTileWidget(tile: e))
                  .toList(growable: false)),
        ));
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
