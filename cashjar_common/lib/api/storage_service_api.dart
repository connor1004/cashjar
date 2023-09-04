import 'dart:html';

abstract class StorageServiceApi {
  Future<String> uploadFile(String path, File file);

  Future<String> uploadFilePercent(String path, String name, Blob blob, Function onUploading, Function onFinished);

  Future<String> uploadBlob(String path, String name, Blob blob);
}