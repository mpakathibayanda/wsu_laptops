class AppwriteConstants {
  static const String databaseId = 'WSU_LAPTOPS';

  static const String projectId = '64fef7197fee0b9f571c';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String studentsCollection = 'STUDENTS_ID';
  static const String applicationsCollection = 'APPLICATIONS_ID';
  static const String laptopsCollection = 'LAPTOPS_ID';
  static const String adminCollection = 'ADMINS_ID';

  static const String filesBucket = '';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$filesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
