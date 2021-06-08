part of '../home_course_list.dart';

class UserDetailsCard extends StatefulWidget {
  UserDetailsCard({this.scont});
  final ScrollController scont;

  @override
  _UserDetailsCardState createState() => _UserDetailsCardState();
}

class _UserDetailsCardState extends State<UserDetailsCard> {
  double pos = 0;
  @override
  void initState() {
    widget.scont.addListener(listen);
    super.initState();
  }

  void listen() {
    if (mounted && widget.scont.offset < 110) {
      setState(() {
        pos = -widget.scont.offset / 2.5;
      });
    } else {
      if (pos != -110) {
        setState(() {
          pos = -110;
        });
      }
    }
  }

  @override
  void dispose() {
    // widget.scont.dispose();
    widget.scont.removeListener(listen);
    super.dispose();
  }

  @override
  Widget build(context) {
    var width = MediaQuery.of(context).size.width;
    return Positioned(
      top: pos,
      child: Hero(
        tag: 'profilecard',
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.purple,
                // boxShadow: [
                //   BoxShadow(
                //     spreadRadius: 0.0,
                //     blurRadius: 8.0,
                //   )
                // ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(48),
                    bottomRight: Radius.circular(48))),
            padding: EdgeInsets.fromLTRB(24.0, 68.0, 24.0, 8.0),
            width: width,
            height: 160,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ProfilePict(),
                Padding(padding: EdgeInsets.only(left: 16)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder(
                        future:
                            context.repository<UserRepository>().getUserName(),
                        builder: (context, snapshot) {
                          return Material(
                            color: Colors.transparent,
                            child: Text(
                              snapshot.data ?? '',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }),
                    Material(
                      color: Colors.transparent,
                      child: Text(
                        'S1 Ekonomi Bisnis',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                      // color: Colors.purple,
                      ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      // alignment: Alignment.topCenter,
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                            iconSize: 14,
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ProfileScreen()));
                            }),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePict extends StatefulWidget {
  @override
  _ProfilePictState createState() => _ProfilePictState();
}

class _ProfilePictState extends State<ProfilePict> {
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future getImage(BuildContext context) async {
    // var str = await Permission.mediaLibrary.request();
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var fileSize = await File(pickedFile.path).length();
    if (pickedFile == null || fileSize >= 2000000) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        // backgroundColor: Colors.red,
        content: Text('Canceled by user.'),
      ));
      if (fileSize >= 2000000) {
        print(fileSize);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('File is over 2MB, canceled...'),
        ));
      }
      return;
    }
    //upload
    var username = await context.repository<UserRepository>().getUserName();
    var oldurl = await context.repository<UserRepository>().getUserPpUrl();
    var tgl = DateTime.now();
    String namaFile = tgl.minute.toString() + tgl.second.toString();
    // print(namaFile);
    String photourl = await context.repository<FirestoreRepo>().uploadPP(
        File(pickedFile.path), namaFile + '-' + username,
        oldUrl: oldurl, username: username);
    await context.repository<UserRepository>().updatePp(photourl);
    setState(() {});
    //get sys dir
    // var listAppDocDir =
    //     await getExternalStorageDirectories(type: StorageDirectory.pictures);
    // Directory appDocDir = listAppDocDir[0];

    // Directory appDir = Directory('/storage/emulated/0/Downloads/');

    // String appDocPath = appDocDir.path;
    // '/storage/emulated/0/Pictures';
    // print(Permission.values);
    // print(appDir.existsSync());

// copy the file to a new path
    // var extensi = (extension(pickedFile.path));
    // try {
    //   var tgl = DateTime.now();
    //   String fileLama = prefs.getString('profile_picture');
    //   print('$fileLama');
    //   if (fileLama != null) {
    //     if (await File(fileLama).exists()) {
    //       await File(fileLama).delete();
    //     }
    //     prefs.remove('profile_picture');
    //   }
    //   String namaFile = tgl.minute.toString() + tgl.second.toString();
    //   String newDir = '$appDocPath/$namaFile' 'pp$extensi';
    //   File newImage = await File(pickedFile.path).copy(newDir);
    //   //set shpref
    //   prefs.setString('profile_picture', newImage.path);
    //   print(newImage.path);
    //   setState(() {
    //     _image = File(newImage.path);
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print('tapped');
          getImage(context);
        },
        child: FutureBuilder(
            // stream: null,
            future: context.repository<UserRepository>().getUserPpUrl(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data),
                  // _image != null ? FileImage(_image) : null,
                  radius: 28,
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return CircleAvatar();
              }
              return CircleAvatar();
            }),
      ),
    );
  }
}
