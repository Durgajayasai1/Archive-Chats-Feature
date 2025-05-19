class ChatUser {
  final int id;
  final String firstName;
  final String phone;
  final String image;

  ChatUser({
    required this.id,
    required this.firstName,
    required this.phone,
    required this.image,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      firstName: json['firstName'],
      phone: json['phone'],
      image: json['image'],
    );
  }
}
