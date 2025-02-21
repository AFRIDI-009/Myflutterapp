import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:compass_flutter/compass_flutter.dart';

void main() { runApp(PrayerTasbihApp()); }

class PrayerTasbihApp extends StatelessWidget
{
    @override Widget build(BuildContext context) { return MaterialApp(debugShowCheckedModeBanner : false, title : 'Prayer & Tasbih App', theme : ThemeData(primarySwatch : Colors.green), home : HomeScreen(), ); }
}

class HomeScreen extends StatelessWidget
{
    @override Widget build(BuildContext context) { return Scaffold(appBar : AppBar(title : Text('Prayer & Tasbih App')), body : Column(mainAxisAlignment : MainAxisAlignment.center, children : [
                                                                       HomeButton(title : 'Tasbih Counter', screen : TasbihScreen()),
                                                                       HomeButton(title : 'Qibla Finder', screen : QiblaScreen()),
                                                                       HomeButton(title : 'Dua Collection', screen : DuaScreen()),
                                                                   ], ), ); }
}

class HomeButton extends StatelessWidget
{
    final String title;
    final Widget screen;
    HomeButton({required this.title, required this.screen});
    @override Widget build(BuildContext context)
    {
        return ElevatedButton(onPressed : () { Navigator.push(context, MaterialPageRoute(builder : (context) = > screen)); }, child : Text(title, style : TextStyle(fontSize : 20)), );
    }
}

class TasbihScreen extends StatefulWidget
{
    @override _TasbihScreenState createState() = > _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
{
    int _counter = 0;
    int _savedCount = 0;

    @override void initState()
    {
        super.initState();
        _loadCounter();
    }

    void _incrementCounter()
    {
        setState(() { _counter++; });
    }

    void _resetCounter()
    {
        setState(() { _counter = 0; });
    }

    void _saveCounter() async
    {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() { _savedCount = _counter; prefs.setInt('saved_count', _savedCount); });
    }

    void _loadCounter() async
    {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() { _savedCount = prefs.getInt('saved_count') ? ? 0; });
    }

    @override Widget build(BuildContext context) { return Scaffold(appBar : AppBar(title : Text('Tasbih Counter')), body : Column(mainAxisAlignment : MainAxisAlignment.center, children : [
                                                                       Text('Current Count: $_counter', style : TextStyle(fontSize : 24)),
                                                                       Row(mainAxisAlignment : MainAxisAlignment.center, children : [
                                                                           ElevatedButton(onPressed : _incrementCounter, child : Text('+1')),
                                                                           ElevatedButton(onPressed : _resetCounter, child : Text('Reset')),
                                                                       ], ),
                                                                       ElevatedButton(onPressed : _saveCounter, child : Text('Save Count')),
                                                                       Text('Last Saved Count: $_savedCount'),
                                                                   ], ), ); }
}

class QiblaScreen extends StatelessWidget
{
    @override Widget build(BuildContext context)
    {
        return Scaffold(appBar : AppBar(title : Text('Qibla Finder')), body : Center(child : StreamBuilder(stream : CompassFlutter.compassEvents, builder : (context, snapshot) { if (snapshot.hasData) { return Text('Direction: ${snapshot.data!.heading.toStringAsFixed(2)}°'); } else { return Text('Loading Compass...'); } }, ), ), );
    }
}

class DuaScreen extends StatelessWidget
{
    final List<String> duas = [
        'Dua for Waking Up',
        'Dua for Sleeping',
        'Dua for Traveling',
        'Dua for Entering Mosque',
    ];

    @override Widget build(BuildContext context)
    {
        return Scaffold(appBar : AppBar(title : Text('Dua Collection')), body : ListView.builder(itemCount : duas.length, itemBuilder : (context, index) { return ListTile(title : Text(duas[index]), ); }, ), );
    }
}
