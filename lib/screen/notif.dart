import 'dart:convert';

import 'package:aula/repository/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class NotificationCentre extends StatelessWidget {
  Future getData() async {
    var json = {
      "type": "MethodCallResult",
      "value": {
        "result": {"type": "Null"},
        "success": {"type": "Bool", "value": false},
        "error": {
          "type": "String",
          "value":
              "java.lang.reflect.InvocationTargetException\r\n\tat sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n\tat sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n\tat sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n\tat java.lang.reflect.Method.invoke(Method.java:498)\r\n\tat com.jfixby.scarabei.red.reflect.JavaMethodCall.invoke(JavaMethodCall.java:22)\r\n\tat com.jfixby.scarabei.red.reflect.JavaCallExecutor.executeCall(JavaCallExecutor.java:11)\r\n\tat com.jfixby.scarabei.red.reflect.CrossLanguageCallAdaptor.processCrossLanguageMethodCall(CrossLanguageCallAdaptor.java:26)\r\n\tat com.jfixby.scarabei.examples.reflect.TestMethodCall.main(TestMethodCall.java:27)\r\nCaused by: java.io.IOException: hello\r\n\tat com.jfixby.scarabei.examples.reflect.TestMethodCall.test(TestMethodCall.java:34)\r\n\t... 8 more\r\n\r\njava.io.IOException: hello\r\n\tat com.jfixby.scarabei.examples.reflect.TestMethodCall.test(TestMethodCall.java:34)\r\n\tat sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\r\n\tat sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)\r\n\tat sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)\r\n\tat java.lang.reflect.Method.invoke(Method.java:498)\r\n\tat com.jfixby.scarabei.red.reflect.JavaMethodCall.invoke(JavaMethodCall.java:22)\r\n\tat com.jfixby.scarabei.red.reflect.JavaCallExecutor.executeCall(JavaCallExecutor.java:11)\r\n\tat com.jfixby.scarabei.red.reflect.CrossLanguageCallAdaptor.processCrossLanguageMethodCall(CrossLanguageCallAdaptor.java:26)\r\n\tat com.jfixby.scarabei.examples.reflect.TestMethodCall.main(TestMethodCall.java:27)\r\n"
        }
      }
    };
    print(json);
    var response = await http.get(
        'http://newsapi.org/v2/top-headlines?country=id&apiKey=f4d3ea982e5c489e92dbe22359574a35');
    var data = jsonDecode(response.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    var repo = RepositoryProvider.of<FirestoreRepo>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Centre'),
      ),
      body: Container(
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              String content;
              if (snapshot.hasData) {
                content = snapshot.data['articles'][0]['content'].toString();
                print(content);
              }
              return Center(
                child: InkWell(
                    onTap: () async {
                      getData();
                      // repo.test();
                      // repo.sendMessage('Tes 1 2', 'Candra', 'Afif');
                      // print(await repo.getUsernameAvailability('Rizal'));
                    },
                    child: Text(snapshot.hasData
                        ? content
                        // snapshot.data['articles'][0]['content']
                        : 'no data')),
              );
            }),
      ),
    );
  }
}
