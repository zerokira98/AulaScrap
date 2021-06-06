import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepo {
  var user = FirebaseFirestore.instance.collection('users');
  var message = FirebaseFirestore.instance.collection('message');
  Future getUserInfo(String email) {
    return user.where('email', isEqualTo: email).get();
  }
  // Future getUserInfo(String query) {
  //   return user.where('email', ).getDocuments();
  // }

  Future setUser(Map<String, dynamic> data, String uid) {
    data.addAll({
      'created': FieldValue.serverTimestamp(),
    });
    return user.doc(uid).set(data);
  }

  Future<List<DocumentSnapshot>> getUsers() async {
    var data = await user.get();
    return data.docs;
  }

  Future<String> uploadPP(File file, String filename,
      {String username, String oldUrl}) async {
    Reference storageReference;
    if (oldUrl != null) {
      storageReference = FirebaseStorage.instance.refFromURL(oldUrl);
      await storageReference.delete();
    }
    // var filePath =
    //     await FirebaseStorage.instance.ref().child("path").putFile(file).t
    storageReference = FirebaseStorage.instance.ref().child("images/$filename");
    final UploadTask uploadTask = storageReference.putFile(file);
    final TaskSnapshot downloadUrl =
        await uploadTask.then((s) => s, onError: (e) {
      print(e);
    });
    // await downloadUrl.state
    final String url = (await downloadUrl.ref.getDownloadURL());
    user.where('name', isEqualTo: username).get().then((value) async {
      for (var val in value.docs) {
        print(val.id);
        await user.doc(val.id).update({'pp': url});
      }
    });
    print("URL is $url");
    return url;
    // return data.documents;
  }

  Future<bool> getUsernameAvailability(String inputData) async {
    var query = await user.where('name', isEqualTo: inputData).get();
    print(query.docs.isEmpty);
    return query.docs.isEmpty;
    // print(query.documents[0].data);
  }

  Stream<QuerySnapshot> getMessage(String person1, String person2) {
    List sortir = [person1, person2];
    sortir.sort();
    var doc = message.doc(sortir[0] + '__' + sortir[1]);
    return doc
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<String> getPpFromEmail(String email) async {
    var doc = await user.where('email', isEqualTo: email).get();
    List docList = doc.docs;
    if (docList.isNotEmpty) {
      return docList[0]['pp'];
    }
    return '';
  }

  sendMessage(String content, String sender, String receiver) async {
    List sortir = [sender, receiver];
    sortir.sort();
    message.doc(sortir[0] + '__' + sortir[1])
      ..set(
        {
          'participants1': sortir[0],
          'participants2': sortir[1],
        },
      )
      ..collection('messages').doc().set({
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
    user.where('email', isEqualTo: 'rizalafif84@gmail.com').get().then((value) {
      for (var val in value.docs) {
        print(val.id);
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
    var data1 = await message.where('participants1', isEqualTo: '$s').get();
    var data2 = await message.where('participants2', isEqualTo: '$s').get();
    return (data1.docs + data2.docs);
  }

  // Future updateMessage() {}
}
