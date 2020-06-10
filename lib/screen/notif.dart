import 'package:aula/repository/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCentre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var repo = RepositoryProvider.of<FirestoreRepo>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Centre'),
      ),
      body: Container(
        child: Center(
          child: InkWell(
              onTap: () async {
                repo.test();
                // repo.sendMessage('Tes 1 2', 'Candra', 'Afif');
                // print(await repo.getUsernameAvailability('Rizal'));
              },
              child: Text('no data')),
        ),
      ),
    );
  }
}
