import '../domain/entities/user.dart';

abstract final class AuthStrings {
  static const brand = 'Stud Book';
  static const ranch = 'Circle-J Ranch';
  static const title = 'Sign in';
  static const subtitle = 'Choose a demo account. Each role sees only its own screens.';
  static const staffTitle = 'Ranch staff';
  static const staffDescription = 'Horse registry, pedigrees and compatibility rules.';
  static const clientTitle = 'Client';
  static const clientDescription = 'Mare owners: breeding requests and invoices.';
  static const failedTitle = 'Sign-in failed';
  static const continueAs = 'Continue';
  static const signOut = 'Sign out';
  static const staffEmail = 'staff@test.com';
  static const clientEmail = 'client@test.com';

  static String roleLabel(UserRole role) => switch (role) {
    UserRole.ranchStaff => staffTitle,
    UserRole.client => clientTitle,
  };
}
