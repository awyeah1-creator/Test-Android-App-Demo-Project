# set-purple-bg.ps1
param (
    [string]$ProjectDir = ".\lib"
)

$mainFile = "$ProjectDir\main.dart"
$backupFile = "$mainFile.bak"

Write-Host "1. Backing up main.dart to main.dart.bak..."
Copy-Item $mainFile $backupFile -Force
if (Test-Path $backupFile) {
    Write-Host "Backup created successfully."
} else {
    Write-Host "Backup failed!" ; Exit 1
}

Write-Host "2. Writing new main.dart with Animated Purple Background..."
@"
import 'package:flutter/material.dart';

void main() {
  runApp(const AnimatedPurpleApp());
}

class AnimatedPurpleApp extends StatelessWidget {
  const AnimatedPurpleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedPurpleBackground(),
    );
  }
}

class AnimatedPurpleBackground extends StatefulWidget {
  @override
  _AnimatedPurpleBackgroundState createState() => _AnimatedPurpleBackgroundState();
}

class _AnimatedPurpleBackgroundState extends State<AnimatedPurpleBackground> {
  bool _toggle = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 2));
      setState(() => _toggle = !_toggle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _toggle
                ? [Colors.deepPurple, Colors.purpleAccent]
                : [Colors.purple, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            'Animated Purple Background!',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
"@ | Out-File -Encoding utf8 $mainFile

if (Test-Path $mainFile) {
    Write-Host "main.dart successfully updated."
} else {
    Write-Host "Failed to update main.dart!" ; Exit 1
}

Write-Host "3. Running flutter pub get..."
flutter pub get

Write-Host "4. Launching the app on the currently selected device..."
flutter run -d all --observatory-port 0

Write-Host "Script completed. Check the emulator/device for animated background."
