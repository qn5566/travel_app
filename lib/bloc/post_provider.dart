import 'package:flutter/cupertino.dart';
import 'package:travel/bloc/post_bloc.dart';

class PostProvider extends InheritedWidget {
  final PostBloc postBloc = PostBloc();

  PostProvider({super.key, required super.child});

  // PostProvider({Key:key, Widget: child}):super(Key:key, child: child);

  static PostBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<PostProvider>(
            aspect: PostProvider) as PostProvider)
        .postBloc;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
