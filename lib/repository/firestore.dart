import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepo {
  var user = Firestore.instance.collection('users');
  var message = Firestore.instance.collection('message');
  Future setUser(Map data) {
    return user.document().setData(data);
  }

  Future<List<DocumentSnapshot>> getUsers() async {
    var data = await user.getDocuments();
    return data.documents;
  }

  Future<bool> getUsernameAvailability(String inputData) async {
    var query = await user.where('name', isEqualTo: inputData).getDocuments();
    print(query.documents.isEmpty);
    return query.documents.isEmpty;
    // print(query.documents[0].data);
  }

  Stream<QuerySnapshot> getMessage(String person1, String person2) {
    // Firestore.instance.collectionGroup('message');
    List sortir = [person1, person2];
    sortir.sort();
    var doc = message.document(sortir[0] + '__' + sortir[1]);
    return doc
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  sendMessage(String content, String sender, String receiver) async {
    // Firestore.instance.collectionGroup('message');
    List sortir = [sender, receiver];
    sortir.sort();
    message.document(sortir[0] + '__' + sortir[1])
      ..setData(
        {
          'participants1': sortir[0],
          'participants2': sortir[1],
        },
      )
      ..collection('messages').document().setData({
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
        'sender': sender
      });
  }

  void test() async {
    // var thedata = await message.document('Telolet').get();
    // var data2 = await message.document('Telolet').setData(
    //   {
    //     'participants1': 'Rizal',
    //     'participants2': 'Afif',
    //   },
    // );

    // var data1 = await message
    //     .where('participants1', isEqualTo: 'rizalafif84@gmail.com')
    //     .getDocuments();
    // var data2 = await message
    //     .where('participants2', isEqualTo: 'rizalafif84@gmail.com')
    //     .getDocuments();
    // // print(thedata.data);
    // print('Data1');
    // print(data1.documents);
    // print('Data2');
    // print(data2.documents);
    // print('Data3');
    // var newList = (data1.documents + data2.documents).map((e) {
    //   if (e['participants1'] == e['participants2']) {
    //     return null;
    //   }

    //   if (e['participants1'] == 'rizalafif84@gmail.com') {
    //     return {'idTo': e['participants2']};
    //   } else if (e['participants2'] == 'rizalafif84@gmail.com') {
    //     return {'idTo': e['participants1']};
    //   }
    // }).toList();
    // print(newList);
  }

  Future<List<DocumentSnapshot>> getRecent(String s) async {
    var data1 = await message
        .where('participants1', isEqualTo: 'rizalafif84@gmail.com')
        .getDocuments();
    var data2 = await message
        .where('participants2', isEqualTo: 'rizalafif84@gmail.com')
        .getDocuments();
    return (data1.documents + data2.documents);
  }

  // Future updateMessage() {}
}
