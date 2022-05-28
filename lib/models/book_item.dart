class BookListStatus {
  final bool successOnRequest;
  final int errorCode;
  final bool readingInProgress;
  final bool readingPaused;
  final bool readingCanceled;
  final bool readingFinished;
  final Map bookInfo;

  const BookListStatus({
    required this.successOnRequest,
    required this.errorCode,
    required this.readingInProgress,
    required this.readingPaused,
    required this.readingCanceled,
    required this.readingFinished,
    required this.bookInfo,
  });

  factory BookListStatus.fromJson(Map<String, dynamic> json) {
    return BookListStatus(
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

class BookInfoByISBN {
  final bool successOnRequest;
  final int errorCode;
  final Map bookInfo;

  const BookInfoByISBN({
    required this.successOnRequest,
    required this.errorCode,
    required this.bookInfo,
  });

  factory BookInfoByISBN.fromJson(Map<String, dynamic> json) {
    return BookInfoByISBN(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      bookInfo: json['bookInfo'] as Map,
    );
  }
}

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

class VerificationStep {
  final bool successOnRequest;
  final int errorCode;
  final String userEmail;
  final int attemptsToValidate;

  const VerificationStep({
    required this.successOnRequest,
    required this.errorCode,
    required this.userEmail,
    required this.attemptsToValidate,
  });

  factory VerificationStep.fromJson(Map<String, dynamic> json) {
    return VerificationStep(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      userEmail: json['userEmail'] as String,
      attemptsToValidate: json['attemptsToValidate'] as int,
    );
  }
}

class CreateUser {
  final bool successOnRequest;
  final int errorCode;
  final String userId;
  final int lastAccess;

  const CreateUser({
    required this.successOnRequest,
    required this.errorCode,
    required this.userId,
    required this.lastAccess,
  });

  factory CreateUser.fromJson(Map<String, dynamic> json) {
    return CreateUser(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      userId: json['userId'] as String,
      lastAccess: json['lastAccess'] as int,
    );
  }
}
