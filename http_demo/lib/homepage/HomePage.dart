import 'package:flutter/material.dart';
import 'package:http_demo/homepage/HomePageManager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final stateManager = HomePageManager();

  void _showDialog(String errorMsg) {
    final alert = AlertDialog(
      content: Text(
        errorMsg,
        style: const TextStyle(color: Colors.red),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showSnackbar(String errorMsg) {
    final snackBar = SnackBar(
      content: Text(
        errorMsg,
        style: const TextStyle(color: Colors.red),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    // stateManager.onError = _showDialog;
    stateManager.onError = _showSnackbar;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Center(
          child: Wrap(
            spacing: 50,
            // alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: stateManager.trySomething,
                child: Text('GET'),
              ),
              ElevatedButton(
                onPressed: stateManager.makePostRequest,
                child: Text('POST'),
              ),
              ElevatedButton(
                onPressed: stateManager.makePatchReqeust,
                child: Text('PATCH'),
              ),
              ElevatedButton(
                onPressed: stateManager.makePutRequest,
                child: Text('PUT'),
              ),
              ElevatedButton(
                onPressed: stateManager.makeDeleteRequest,
                child: Text('DELETE'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ValueListenableBuilder<RequestState>(
          valueListenable: stateManager.resultNotifier,
          builder: (context, requestState, child) {
            switch (requestState) {
              case RequestLoadInProgress():
                return CircularProgressIndicator();
              case RequestLoadSuccess():
                return Expanded(
                  child: SingleChildScrollView(
                    child: Text(requestState.body),
                  ),
                );
              case RequestLoadFailure():
                return SizedBox(
                  height: 20,
                );
              case RequestInitial():
                return SizedBox(
                  height: 20,
                );
            }
          },
        )
      ],
    );
  }
}
