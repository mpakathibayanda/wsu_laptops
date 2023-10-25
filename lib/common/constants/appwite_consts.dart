class AppwriteConstants {
  static const String studentsDatabaseId = 'STUDENTS_DATABASE_ID';
  static const String applicationsDatabaseId = 'LAPTOPS_DB_ID';

  static const String projectId = '64fef7197fee0b9f571c';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String studentsCollection = 'STUDENTS';
  static const String applicationCollection = 'LAPTOP_APPLICATIONS_ID';
  static const String laptopsCollection = 'LAPTOPS_ID';

  static const String filesBucket = '';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$filesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
