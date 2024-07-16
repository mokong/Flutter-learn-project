import 'package:scope_model_demo/enums/view_state.dart';
import 'package:scope_model_demo/scoped_model/base_model.dart';
import 'package:scope_model_demo/service/service_locator.dart';
import 'package:scope_model_demo/service/storage_service.dart';

class HomeModel extends BaseModel {
  StorageService storageService = serviceLocator<StorageService>();

  String title = "HomeModel";

  Future savedData() async {
    setState(ViewState.Busy);
    title = "Saving Data";
    await storageService.saveData();
    title = 'Data Saved';
    setState(ViewState.Retrieved);
  }
}
