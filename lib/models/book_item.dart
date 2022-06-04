// Fetch Books on the User Shelf -----------------------------------------------
class UserShelfBooks {
  final bool successOnRequest;
  final int errorCode;
  final bool readingInProgress;
  final bool readingPaused;
  final bool readingCanceled;
  final bool readingFinished;
  final Map bookInfo;

  const UserShelfBooks({
    required this.successOnRequest,
    required this.errorCode,
    required this.readingInProgress,
    required this.readingPaused,
    required this.readingCanceled,
    required this.readingFinished,
    required this.bookInfo,
  });

  factory UserShelfBooks.fromJson(Map<String, dynamic> json) {
    return UserShelfBooks(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      readingInProgress: json['readingInProgress'] as bool,
      readingPaused: json['readingPaused'] as bool,
      readingCanceled: json['readingCanceled'] as bool,
      readingFinished: json['readingFinished'] as bool,
      bookInfo: json['bookInfo'] as Map,
    );
  }
}

// Returned Book Information ---------------------------------------------------
class BookInformation {
  final bool successOnRequest;
  final int errorCode;
  final Map bookInfo;

  const BookInformation({
    required this.successOnRequest,
    required this.errorCode,
    required this.bookInfo,
  });

  factory BookInformation.fromJson(Map<String, dynamic> json) {
    return BookInformation(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      bookInfo: json['bookInfo'] as Map,
    );
  }
}

// New book on Shelf -----------------------------------------------------------
class BookAdded {
  final bool successOnRequest;
  final int errorCode;
  final String title;
  final String isbn;

  const BookAdded({
    required this.successOnRequest,
    required this.errorCode,
    required this.title,
    required this.isbn,
  });

  factory BookAdded.fromJson(Map<String, dynamic> json) {
    return BookAdded(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      title: json['title'] as String,
      isbn: json['isbn'] as String,
    );
  }
}

// Send User Email or Verification Code to Application -------------------------
class UserSignUpCredentials {
  final bool successOnRequest;
  final int errorCode;
  final String userEmail;
  final int attemptsToValidate;

  const UserSignUpCredentials({
    required this.successOnRequest,
    required this.errorCode,
    required this.userEmail,
    required this.attemptsToValidate,
  });

  factory UserSignUpCredentials.fromJson(Map<String, dynamic> json) {
    return UserSignUpCredentials(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      userEmail: json['userEmail'] as String,
      attemptsToValidate: json['attemptsToValidate'] as int,
    );
  }
}

// Send User Information to Application ----------------------------------------
class CreateUserForm {
  final bool successOnRequest;
  final int errorCode;
  final String userId;
  final int lastAccess;

  const CreateUserForm({
    required this.successOnRequest,
    required this.errorCode,
    required this.userId,
    required this.lastAccess,
  });

  factory CreateUserForm.fromJson(Map<String, dynamic> json) {
    return CreateUserForm(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      userId: json['userId'] as String,
      lastAccess: json['lastAccess'] as int,
    );
  }
}
