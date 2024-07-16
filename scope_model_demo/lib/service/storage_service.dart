class StorageService {
  Future<bool> saveData() async {
    await Future.delayed(const Duration(seconds: 5));
    return true;
  }
}
