class AppwriteConstants {
  static const String databaseId = 'STUDENTS_DATABASE_ID';
  static const String projectId = '64fef7197fee0b9f571c';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String studentsCollection = '';
  static const String credentialCollection = 'CREDENTIALS_ID';

  static const String filesBucket = '';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$filesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
