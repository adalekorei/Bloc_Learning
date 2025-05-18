import 'package:bloc_learning/counter_bloc.dart';
import 'package:bloc_learning/user_bloc/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Homepage());
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(create: (context) => CounterBloc()),
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
      ],
      child: Builder(
        builder: (context) {
          final counterBloc = BlocProvider.of<CounterBloc>(context);
          return Scaffold(
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    counterBloc.add(CounterIncEvent());
                  },
                  icon: Icon(Icons.plus_one),
                ),
                IconButton(
                  onPressed: () {
                    counterBloc.add(CounterDecEvent());
                  },
                  icon: Icon(Icons.exposure_minus_1),
                ),
                IconButton(
                  onPressed: () {
                    final userBloc = context.read<UserBloc>();
                    userBloc.add(
                      UserGetUsersEvent(context.read<CounterBloc>().state),
                    );
                  },
                  icon: Icon(Icons.person),
                ),
                IconButton(
                  onPressed: () {
                    final userBloc = context.read<UserBloc>();
                    userBloc.add(
                      UserGetUsersJobEvent(context.read<CounterBloc>().state),
                    );
                  },
                  icon: Icon(Icons.work),
                ),
              ],
            ),
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    BlocBuilder<CounterBloc, int>(
                      builder: (context, state) {
                        final users = context.select(
                          (UserBloc bloc) => bloc.state.users,
                        );
                        return Column(
                          children: [
                            Text(
                              state.toString(),
                              style: TextStyle(fontSize: 35),
                            ),
                            if (users.isNotEmpty)
                              ...users.map((e) => Text(e.name)),
                          ],
                        );
                      },
                    ),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        final user = state.users;
                        final job = state.job;
                        return Column(
                          children: [
                            if (state.isLoading) CircularProgressIndicator(),
                            if (job.isNotEmpty)
                              ...state.job.map((e) => Text(e.name)),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
