final class CacheKeys {
  const CacheKeys._();

  static const authSession = 'auth.session';
  static const dashboardDaily = 'reports.daily.latest';
  static const categoriesList = 'categories.list';
  static const companyCurrent = 'company.current';
  static const usersList = 'users.list';

  static String productsList(String? search) {
    final normalized = (search ?? '').trim().toLowerCase();
    return 'products.list.$normalized';
  }

  static String movementsList(int limit) {
    return 'movements.list.$limit';
  }
}
