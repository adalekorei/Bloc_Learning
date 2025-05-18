part of 'user_bloc.dart';

class UserState {
  final List<User> users;
  final List<Job> job;
  final bool isLoading;

  UserState({
    this.users = const [],
    this.job = const [],
    this.isLoading = false,
  });

  UserState copyWith({
    final List<User>? users,
    final List<Job>? job,
    bool isLoading = false,
  }) {
    return UserState(
      users: users ?? this.users,
      job: job ?? this.job,
      isLoading: isLoading,
    );
  }
}

class User {
  final String name;
  final String id;

  User({required this.id, required this.name});
}

class Job {
  final String name;
  final String id;

  Job({required this.id, required this.name});
}
