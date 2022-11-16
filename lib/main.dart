import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel/config/app_model.dart';
import 'package:travel/home.dart';

import 'bloc/post_provider.dart';

void main() {
  // Bloc.observer = SimpleBlocObserver();
  runApp(
    PostProvider(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //在 widget 元件樹中的最上層，使用 provider ，方便傳遞到其他底層頁面
    //建議採用 MultiProvider，因為一個 APP 很少一個 provider 就夠用，所以直接上 MultiProvider
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: AppModel())],
        child: MaterialApp(
          title: '旅遊',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const Home(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
