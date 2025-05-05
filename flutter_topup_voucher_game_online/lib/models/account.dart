class Account {
  final int accountId; // ✅ id dari database Strapi
  final String documentId;
  final String userId;
  final String serverId;
  final String gameName;

  Account({
    required this.documentId,
    required this.accountId,
    required this.userId,
    required this.serverId,
    required this.gameName,
  });

  // ✅ Parsing dari JSON Strapi
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: (json['id']),
      documentId:
          (json['documentId'] ?? ""), // pastikan id diambil dari root object
      userId: json['user_game_id'] ?? '',
      serverId: json['server_game_id'] ?? '',
      gameName: json['game']?['game_name'] ?? '',
    );
  }

  // ✅ Untuk POST / Update ke Strapi
  Map<String, dynamic> toJson({
    required String userIdStrapi,
    required String gameIdStrapi,
  }) {
    return {
      'data': {
        'user_game_id': userId,
        'server_game_id': serverId,
        'user': userIdStrapi,
        'game': gameIdStrapi,
      },
    };
  }

  Map<String, dynamic> toUpdateJson({required String gameIdStrapi}) {
    return {
      'data': {
        'user_game_id': userId,
        'server_game_id': serverId,
        'game': gameIdStrapi,
      },
    };
  }
}
