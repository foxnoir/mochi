import 'package:equatable/equatable.dart';

// blueprint of what we pass around layer
// so a user shoulld look like
class User extends Equatable {
  const User({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  // makes it easier to test
  const User.empty()
      : this(
          id: '1',
          createdAt: '_empty.createdAt',
          name: '_empty.name',
          avatar: '_empty.avatar',
        );

  final String id;
  final String createdAt;
  final String name;
  final String avatar;

  @override
  List<Object?> get props => [id, name, avatar];
}
