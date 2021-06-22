
class UserModel {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
  });

  factory UserModel.fromDocument(Map<String,dynamic> docMap) {
    return UserModel(
      id: docMap['id'],
      email: docMap['email'],
      username: docMap['username'],
      photoUrl: docMap['photoUrl'],
      displayName: docMap['displayName'],
      bio: docMap['bio'],
    );
  }
}