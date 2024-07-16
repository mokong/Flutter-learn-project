import 'package:flutter/material.dart';
import 'package:scope_model_demo/scoped_model/home_model.dart';
import 'package:scope_model_demo/views/base_view.dart';

class Template extends StatelessWidget {
  const Template({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      key: Key(runtimeType.toString()),
      builder: (context, child, model) => Scaffold(
        body: Center(
          child: Text(
            runtimeType.toString(),
          ),
        ),
      ),
    );
  }
}
