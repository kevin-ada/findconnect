class AppwriteConsts {
  static const String database = '';
  static const String projectID = '';
  static const String endpoint = "https://cloud.appwrite.io/v1";
  static const String collection = "";
  static const String tweetscollection = "";
  static const String notficationsCollection = "";
  static const String bucketId = "";

  static imageUrl(String imageId) =>
      'https://cloud.appwrite.io/v1/storage/buckets/$bucketId/files/$imageId/view?project=$projectID&mode=admin';
}
