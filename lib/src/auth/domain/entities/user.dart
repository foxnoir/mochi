import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.createsAt,
    required this.name,
    required this.avatar,
  });

  final int id;
  final String createsAt;
  final String name;
  final String avatar;

  @override
  List<Object?> get props => throw [id];
}