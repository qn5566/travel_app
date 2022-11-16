import 'package:flutter/material.dart';

import '../bloc/post_bloc.dart';
import '../bloc/post_provider.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late PostBloc _postBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _postBloc = PostProvider.of(context);
    print("didChangeDependencies");
  }


  @override
  Widget build(BuildContext context) {
    /// Create a `BlocObserver` instance.
    // final cubit = BlocObserver();

    return Scaffold(
      appBar: AppBar(title: const Text('Bloc')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '目前計數值: ${_postBloc.state}',
            ),
          ],
        ),
      ),
    );
  }
}
