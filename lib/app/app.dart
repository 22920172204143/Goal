import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../screens/home_shell.dart';
import 'theme.dart';

class SmallGoalApp extends StatefulWidget {
  const SmallGoalApp({super.key});

  @override
  State<SmallGoalApp> createState() => _SmallGoalAppState();
}

class _SmallGoalAppState extends State<SmallGoalApp> {
  late final AppController _controller;
  late final Future<void> _initializeFuture;

  @override
  void initState() {
    super.initState();
    _controller = AppController();
    _initializeFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '小目标',
          theme: buildSmallGoalTheme(),
          home: FutureBuilder<void>(
            future: _initializeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  _controller.isLoading) {
                return const _LoadingScreen();
              }
              return HomeShell(controller: _controller);
            },
          ),
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('正在布置你的像素房间...'),
          ],
        ),
      ),
    );
  }
}
