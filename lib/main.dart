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
    final counterBloc = CounterBloc();
    final userBloc = UserBloc();
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(create: (context) => counterBloc),
        BlocProvider<UserBloc>(create: (context) => userBloc),
      ],
      child: Scaffold(
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
                userBloc.add(UserGetUsersEvent(counterBloc.state));
              },
              icon: Icon(Icons.person),
            ),
            IconButton(
              onPressed: () {
                userBloc.add(UserGetUsersJobEvent(counterBloc.state));
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
                  bloc: counterBloc,
                  builder: (context, state) {
                    return Text(
                      state.toString(),
                      style: TextStyle(fontSize: 35),
                    );
                  },
                ),
                BlocBuilder<UserBloc, UserState>(
                  bloc: userBloc,
                  builder: (context, state) {
                    final user = state.users;
                    final job = state.job;
                    return Column(
                      children: [
                        if (state.isLoading)
                          CircularProgressIndicator(),
                        if (user.isNotEmpty)
                          ...state.users.map((e) => Text(e.name)),
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
      ),
    );
  }
}
