import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:findmychild/authentication/const.dart';
import 'package:findmychild/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StorageApiProvider = Provider((ref) {
  return StorageApi(storage: ref.watch(appwriteStorageProvider));
});

class StorageApi {
  final Storage _storage;
  StorageApi({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imagelink = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
          bucketId: AppwriteConsts.bucketId,
          fileId: ID.unique(),
          file: InputFile(path: file.path));
      imagelink.add(AppwriteConsts.imageUrl(uploadedImage.$id));
    }
    return imagelink;
  }
}
