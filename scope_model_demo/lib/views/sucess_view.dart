import 'package:flutter/material.dart';
import 'package:scope_model_demo/enums/view_state.dart';
import 'package:scope_model_demo/scoped_model/success_model.dart';
import 'package:scope_model_demo/views/base_view.dart';
import 'package:scope_model_demo/views/busy_overlay.dart';

class SuccessView extends StatelessWidget {
  final String title;
  SuccessView({required this.title});

  @override
  Widget build(BuildContext context) {
    return BaseView<SuccessModel>(
        onModelReady: (model) => model.fetchDuplicatedText(title),
        builder: (context, child, model) => BusyOverlay(
            show: model.state == ViewState.Busy,
            child: Scaffold(
              body: Center(child: Text(model.title)),
            )));
  }
}
