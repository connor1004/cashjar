import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:cashjar_common/bloc/messaging/messaging.dart';
import 'package:cashjar_common/bloc/messaging/messaging_bloc.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:cashjar_common/api/storage_service_api.dart';

@Injectable()
class StorageServiceApiImpl extends StorageServiceApi {
  fb.Storage _fbStorage;

  StorageServiceApiImpl() {
    _fbStorage = fb.storage();
  }

  @override
  Future<String> uploadFile(String path, File file) async {
    fb.StorageReference fbRefFile = _fbStorage.ref("$path/${DateTime.now()}/${file.name}");
    fb.UploadTask task = fbRefFile.put(file, fb.UploadMetadata(contentType: file.type));

    StreamSubscription sub;
    sub = task.onStateChanged.listen((fb.UploadTaskSnapshot snapshot) {
      print("Uploading Image -- Transferred ${snapshot.bytesTransferred}/${snapshot.totalBytes}...");
      if (snapshot.bytesTransferred == snapshot.totalBytes) {
        sub.cancel();
      }
    }, onError: (error) {
      print(error.message);
    });
    String downloadUrl = '';
    try {
      fb.UploadTaskSnapshot snapshot = await task.future;

      if (snapshot.state == fb.TaskState.SUCCESS) {
        await snapshot.ref.getDownloadURL().then((value) {
          downloadUrl = value.toString();
        });
      }
    } catch (error) {
      print(error);
    }
    return downloadUrl;
  }

  @override
  Future<String> uploadFilePercent(String path, String name, Blob blob, Function onUploading, Function onFinished) async {
    fb.StorageReference fbRefFile = _fbStorage.ref("$path/${DateTime.now()}/$name");
    fb.UploadTask task = fbRefFile.put(blob, fb.UploadMetadata(contentType: blob.type));

    StreamSubscription sub;
    sub = task.onStateChanged.listen((fb.UploadTaskSnapshot snapshot) {
      print("Uploading Image -- Transferred ${snapshot.bytesTransferred}/${snapshot.totalBytes}...");
      onUploading(snapshot.bytesTransferred * 100 ~/ snapshot.totalBytes);
      if (snapshot.bytesTransferred == snapshot.totalBytes) {
        sub.cancel();
        onFinished();
      }
    }, onError: (error) {
      print(error.message);
    });
    String downloadUrl = '';
    try {
      fb.UploadTaskSnapshot snapshot = await task.future;

      if (snapshot.state == fb.TaskState.SUCCESS) {
        await snapshot.ref.getDownloadURL().then((value) {
          downloadUrl = value.toString();
        });
      }
    } catch (error) {
      print(error);
    }
    return downloadUrl;
  }

  @override
  Future<String> uploadBlob(String path, String name, Blob blob) async {
    fb.StorageReference fbRefFile = _fbStorage.ref("$path/${DateTime.now()}/$name");
    fb.UploadTask task = fbRefFile.put(blob, fb.UploadMetadata(contentType: blob.type));

    // StreamSubscription sub;
    // sub = task.onStateChanged.listen((fb.UploadTaskSnapshot snapshot) {
    //   print("Uploading Image -- Transferred ${snapshot.bytesTransferred}/${snapshot.totalBytes}...");
    //   if (snapshot.bytesTransferred == snapshot.totalBytes) {
    //     sub.cancel();
    //   }
    // }, onError: (error) {
    //   print(error.message);
    // });
    String downloadUrl = '';
    try {
      fb.UploadTaskSnapshot snapshot = await task.future;

      if (snapshot.state == fb.TaskState.SUCCESS) {
        await snapshot.ref.getDownloadURL().then((value) {
          downloadUrl = value.toString();
        });
      }
    } catch (error) {
      print(error);
    }
    return downloadUrl;
  }
}