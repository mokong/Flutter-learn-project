import 'package:flutter/material.dart';
import 'package:scope_model_demo/enums/view_state.dart';
import 'package:scope_model_demo/scoped_model/home_model.dart';
import 'package:scope_model_demo/service/service_locator.dart';
import 'package:scope_model_demo/views/base_view.dart';
import 'package:scope_model_demo/views/busy_overlay.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  _saveData(HomeModel model) {
    model.savedData();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      key: const Key("HomeView"),
      builder: (context, child, model) => BusyOverlay(
        show: model.state == ViewState.Busy,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _getBodyUi(model.state),
                Text(model.title),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _saveData(model),
            child: const Icon(Icons.save),
          ),
        ),
      ),
    );
  }

  Widget _getBodyUi(ViewState state) {
    switch (state) {
      case ViewState.Busy:
        return const CircularProgressIndicator();
      case ViewState.Retrieved:
      default:
        return const Text('Done');
    }
  }
}
