import 'dart:convert';

import 'package:aula/repository/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class NotificationCentre extends StatefulWidget {
  @override
  _NotificationCentreState createState() => _NotificationCentreState();
}

class _NotificationCentreState extends State<NotificationCentre>
    with SingleTickerProviderStateMixin {
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

  AnimationController acont;
  Animation ani;
  CurvedAnimation curve;
  Tween<double> twe = Tween<double>(
    begin: 0.0,
    end: -64.0,
  );
  @override
  void initState() {
    // TODO: implement initState
    acont = AnimationController(vsync: this, duration: Duration(seconds: 2));
    curve = CurvedAnimation(parent: acont, curve: Curves.ease);
    ani = twe.animate(curve);
    ani.addListener(() {
      listener();
    });
    acont.forward();
    // acont.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    acont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var repo = RepositoryProvider.of<FirestoreRepo>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Centre'),
      ),
      body: CustomPaint(
        // clipper: CusClipper(),
        foregroundPainter: CusPaint(ani: ani),
        child: Container(
          child: FutureBuilder(
              // future: getData(),
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
                  child: Card(
                    child: Text(snapshot.hasData
                        ? content
                        // snapshot.data['articles'][0]['content']
                        : '${ani.value}'),
                  )),
            );
          }),
        ),
      ),
    );
  }

  void listener() {
    curve.value;
    setState(() {});
  }
}

class CusPaint extends CustomPainter {
  CusPaint({this.ani});
  Animation ani;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.blue;
    var paint2 = Paint();
    paint2.color = Colors.blue;
    // paint2.color = ;

    var path2 = Path();
    path2.moveTo(0, size.height * 0.7 + ani.value);
    path2.relativeLineTo(size.width, -100);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint);
    canvas.rotate(-math.pi / 1.0);
    canvas.translate(-size.width, -size.height);
    // canvas.transform(mat.storage);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CusClipper extends CustomClipper<Path> {
  // CusClipper();

  @override
  Path getClip(Size size) {
    var path = Path();
    // path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    // path.lineTo(0, 50);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
