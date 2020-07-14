import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepo {
  var user = Firestore.instance.collection('users');
  var message = Firestore.instance.collection('message');
  Future getUserInfo(String email) {
    return user.where('email', isEqualTo: email).getDocuments();
  }

  Future setUser(Map<String, dynamic> data, String uid) {
    data.addAll({
      'created': FieldValue.serverTimestamp(),
    });
    return user.document(uid).setData(data);
  }

  Future<List<DocumentSnapshot>> getUsers() async {
    var data = await user.getDocuments();
    return data.documents;
  }

  Future<String> uploadPP(File file, String filename,
      {String username, String oldUrl}) async {
    StorageReference storageReference;
    if (oldUrl != null) {
      storageReference =
          await FirebaseStorage.instance.getReferenceFromUrl(oldUrl);
      var deleteTask = await storageReference.delete();
    }
    storageReference = FirebaseStorage.instance.ref().child("images/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    user.where('name', isEqualTo: username).getDocuments().then((value) async {
      for (var val in value.documents) {
        print(val.documentID);
        await user.document(val.documentID).updateData({'pp': url});
      }
    });
    print("URL is $url");
    return url;
    // return data.documents;
  }

  Future<bool> getUsernameAvailability(String inputData) async {
    var query = await user.where('name', isEqualTo: inputData).getDocuments();
    print(query.documents.isEmpty);
    return query.documents.isEmpty;
    // print(query.documents[0].data);
  }

  Stream<QuerySnapshot> getMessage(String person1, String person2) {
    List sortir = [person1, person2];
    sortir.sort();
    var doc = message.document(sortir[0] + '__' + sortir[1]);
    return doc
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<String> getPpFromEmail(String email) async {
    var doc = await user.where('email', isEqualTo: email).getDocuments();
    List docList = doc.documents;
    if (docList.isNotEmpty) {
      return docList[0]['pp'];
    }
    return '';
  }

  sendMessage(String content, String sender, String receiver) async {
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
    //-----------

    // CollectionReference aabb =
    //     user.where('email', isEqualTo: 'rizalafif84@gmail.com').reference();
    // print(aabb.path);
//------------
    user
        .where('email', isEqualTo: 'rizalafif84@gmail.com')
        .getDocuments()
        .then((value) {
      for (var val in value.documents) {
        print(val.documentID);
        // if (val.data['email'] == "rizalafif84@gmail.com") {
        //   print(val.data);
        //   // user.document(val.documentID).updateData({
        //   //   'name': 'RizalAfif',
        //   //   'email': 'rizalafif84@gmail.com',
        //   //   'pp':
        //   //       'https://firebasestorage.googleapis.com/v0/b/aula-4a57d.appspot.com/o/images%2F70-RizalAfif?alt=media&token=088684a5-bc3b-45e3-a9ff-e0a44915153c'
        //   // });
        // }
      }
    });
    // var data1 = message
    //     .where('participants1', isEqualTo: 'rizalafif84@gmail.com')
    //     .snapshots();
    // data1.listen((event) {
    //   print("change" + event.toString());
    // });
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
    var data1 =
        await message.where('participants1', isEqualTo: '$s').getDocuments();
    var data2 =
        await message.where('participants2', isEqualTo: '$s').getDocuments();
    return (data1.documents + data2.documents);
  }

  // Future updateMessage() {}
}
