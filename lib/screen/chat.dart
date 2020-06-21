// import 'package:animations/animations.dart';
import 'package:aula/bloc/contact/contact_bloc.dart' as contact;
import 'package:aula/bloc/messaging/messaging_bloc.dart';
import 'package:aula/repository/firestore.dart';
import 'package:aula/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom>
    with SingleTickerProviderStateMixin {
  TabController tc;
  PageController pc;
  int selectedIndex = 0;
  var openedpage = 0.0;
  @override
  void initState() {
    tc = TabController(length: 2, vsync: this);
    pc = PageController(initialPage: 0);
    // ..addListener(() {
    //   if (pc.page == 0) {
    //     setState(() {
    //       openedpage = pc.page;
    //     });
    //   }
    //   if (pc.page == 1) {
    //     setState(() {
    //       openedpage = pc.page;
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orient = MediaQuery.of(context).orientation.index;
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          // AnimatedOpacity(
          //   duration: Duration(milliseconds: 200),
          //   opacity: openedpage == 0.0 ? 0.0 : 1.0,
          //   child: IconButton(
          //       icon: Icon(Icons.person_add),
          //       onPressed: openedpage == 0.0 ? null : () {}),
          // )
        ],
        bottom: TabBar(
          labelPadding: EdgeInsets.symmetric(vertical: 12),
          onTap: (i) {
            pc.animateToPage(i,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          controller: tc,
          tabs: [
            Text('Chats'),
            Text('Contacts'),
          ],
        ),
        title: Text('ChatRoom'),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pc,
        onPageChanged: (i) {
          tc.animateTo(i);
        },
        children: <Widget>[
          BlocBuilder<MessagingBloc, MessagingState>(builder: (context, state) {
            if (state is Complete) {
              return Container(
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constraint) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: constraint.maxHeight,
                              maxWidth: orient == 0 ? 72.0 : double.infinity),
                          child: IntrinsicHeight(
                            child: NavigationRail(
                              minExtendedWidth: 128.0 + 64.0,
                              labelType: orient == 0
                                  ? NavigationRailLabelType.all
                                  : null,
                              extended: orient == 0 ? false : true,
                              destinations: [
                                for (int i = 0; i < state.sideChat.length; i++)
                                  NavigationRailDestination(
                                    icon: CircleAvatar(),
                                    selectedIcon: CircleAvatar(
                                      radius: 24,
                                    ),
                                    label: Text(
                                      state.sideChat[i]['idTo'] ?? 'hi',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                NavigationRailDestination(
                                  icon: Icon(Icons.add_circle_outline),
                                  selectedIcon: Icon(Icons.add_circle),
                                  label: Text('Second'),
                                ),
                              ],
                              selectedIndex: state.selectedId,
                              onDestinationSelected: (i) {
                                if (i != state.sideChat.length) {
                                  context.bloc<MessagingBloc>().add(
                                      ShowMessages(
                                          idTo: state.sideChat[i]['idTo']));
                                  setState(() {
                                    selectedIndex = state.selectedId;
                                  });
                                } else {
                                  pc.animateToPage(2,
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInOut);
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                    VerticalDivider(thickness: 1, width: 1),
                    Expanded(
                      child: MessageScreen2(
                        id: state.selectedId,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
          Container(
            child: ContactPage(pc: pc),
          ),
        ],
      ),
    );
  }
}

class MessageScreen2 extends StatelessWidget {
  final int id;
  final PageController pc;
  // ..addListener(() {});
  MessageScreen2({@required this.id, this.pc});
  // Widget w = AnimatedList(
  //   initialItemCount: length,
  //   itemBuilder: (context, i, ani) {
  //     return Text(
  //       state.messages[i]['content'],
  //       style: TextStyle(
  //           color: state.messages[i]['sender'] == self
  //               ? Colors.white
  //               : Colors.black),
  //     );
  //   },
  // );
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var repo = RepositoryProvider.of<FirestoreRepo>(context);
    var userrepo = RepositoryProvider.of<UserRepository>(context);
    var bloc = BlocProvider.of<MessagingBloc>(context);
    var self = (bloc.state as Complete).sideChat[0]['idTo'];
    var target = (bloc.state as Complete).sideChat[id]['idTo'];
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: BlocBuilder(
                bloc: bloc,
                builder: (context, state) {
                  if (state is Complete) {
                    if (state.messages.isEmpty) {
                      return Center(child: Text('No Data'));
                    } else {
                      print(state.messages[0]['sender'] + 'hi');
                      return ListView.builder(
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, i) {
                            return Container(
                                padding: EdgeInsets.all(8),
                                alignment: state.messages[i]['sender'] == self
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: size.width * 0.5),
                                  color: state.messages[i]['sender'] == self
                                      ? Colors.blue
                                      : Colors.grey[200],
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    state.messages[i]['content'],
                                    style: TextStyle(
                                        color:
                                            state.messages[i]['sender'] == self
                                                ? Colors.white
                                                : Colors.black),
                                  ),
                                ));
                          },
                          itemCount: state.messages.length);
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                }),
            //  StreamBuilder(
            //     stream: repo.getMessage(self, target),
            //     builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
            //       if (snap.hasData) {
            //         if (snap.data.documents.isEmpty) {
            //           return Text('nodata');
            //         }
            //         return ListView.builder(
            //             reverse: true,
            //             physics: BouncingScrollPhysics(),
            //             itemBuilder: (context, i) {
            //               return Container(
            //                   padding: EdgeInsets.all(8),
            //                   alignment:
            //                       snap.data.documents[i]['sender'] == self
            //                           ? Alignment.centerRight
            //                           : Alignment.centerLeft,
            //                   child: Container(
            //                     constraints:
            //                         BoxConstraints(maxWidth: size.width * 0.5),
            //                     color: snap.data.documents[i]['sender'] == self
            //                         ? Colors.blue
            //                         : Colors.grey[200],
            //                     padding: EdgeInsets.all(8.0),
            //                     child: Text(
            //                       snap.data.documents[i]['content'],
            //                       style: TextStyle(
            //                           color: snap.data.documents[i]['sender'] ==
            //                                   self
            //                               ? Colors.white
            //                               : Colors.black),
            //                     ),
            //                   ));
            //             },
            //             itemCount: snap.data.documents.length);
            //       }
            //       return Center(child: CircularProgressIndicator());
            //     }),
          ),
        ),
        MessageBox()
      ],
    );
  }
}

class MessageBox extends StatefulWidget {
  @override
  _MessageBoxState createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  TextEditingController messageContentController;
  MessagingBloc bloc;
  @override
  void initState() {
    messageContentController = TextEditingController();
    bloc = BlocProvider.of<MessagingBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 56,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(icon: Icon(Icons.add_circle), onPressed: () {}),
          Expanded(
              child: TextField(
            controller: messageContentController,
            // keyboardType: ,
            // maxLines: 2,
          )),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                if (messageContentController.text.isNotEmpty) {
                  bloc.add(
                      SendMessages(content: messageContentController.text));
                  messageContentController.clear();
                } else if (messageContentController.text.isEmpty) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Empty'),
                  ));
                }
              }),
        ],
      ),
    );
  }
}

class MessageScreen extends StatelessWidget {
  MessageScreen({
    this.id,
  });

  final int id;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: <Widget>[
                for (int i = 0; i < 10; i++)
                  Container(
                      padding: EdgeInsets.all(8),
                      color: i % 2 == 0 ? Colors.blue : Colors.white,
                      alignment: i % 2 == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        'gamen $id',
                        style: TextStyle(
                            color: i % 2 == 0 ? Colors.white : Colors.black),
                      ))
              ],
            ),
          ),
        )),
        Container(
          color: Colors.white,
          height: 56,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(icon: Icon(Icons.add_circle), onPressed: () {}),
              Expanded(child: TextField()),
              IconButton(icon: Icon(Icons.send), onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }
}

class ContactPage extends StatelessWidget {
  ContactPage({this.pc});

  final PageController pc;
  Widget _tileCard(context, document) {
    var bloc = BlocProvider.of<MessagingBloc>(context);
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            bloc.add(ShowMessages(idTo: document['email']));

            FocusScope.of(context).unfocus();
            pc.animateToPage(0,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          title: Text(document['email']),
          leading: CircleAvatar(),
        ),
        Divider()
      ],
    );
  }

  // bool validate() {

  //   return tec.text.isEmpty;
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<contact.ContactBloc>(
        create: (context) =>
            contact.ContactBloc(RepositoryProvider.of<FirestoreRepo>(context))
              ..add(contact.Initialize()),
        child: Scaffold(
          floatingActionButton: SearchButton(),
          body: BlocBuilder<contact.ContactBloc, contact.ContactState>(
              builder: (context, state) {
            if (state is contact.ContactInitial) {
              return CircularProgressIndicator();
            }
            if (state is contact.Loaded) {
              print(state.data);
              return ListView.builder(
                itemBuilder: (context, i) {
                  return _tileCard(context, state.data[i]);
                },
                itemCount: state.data.length,
              );
            }
            return CircularProgressIndicator();
          }),
        ));
  }
}

class SearchButton extends StatefulWidget {
  @override
  _SearchButtonState createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  TextEditingController tec = TextEditingController();
  FocusNode searchNode = FocusNode();
  bool open = false;
  contact.ContactBloc cbloc;
  double width = 0.0;
  @override
  void initState() {
    tec.addListener(() {
      _changedQuery();
    });
    cbloc = BlocProvider.of<contact.ContactBloc>(context);
    super.initState();
  }

  void _changedQuery() {
    cbloc.add(contact.Search(tec.text));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          bottom: 17,
          right: 20,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: Alignment.center,
            height: 48.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(8), right: Radius.circular(18.0)),
            ),
            width: width,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: width,
                // padding: EdgeInsets.only(right: 52),
                padding: EdgeInsets.fromLTRB(8.0, 2.0, 48.0, 2.0),
                child: TextField(
                  maxLines: 1,
                  controller: tec,
                  focusNode: searchNode,
                  decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: () {
                            tec.clear();
                            print('tapped');
                          },
                          child: Icon(Icons.close))),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  open = !open;
                  width =
                      open ? MediaQuery.of(context).size.width - 96 + 24 : 0.0;
                });
                Future.delayed(Duration(milliseconds: 500), () {
                  if (open) {
                    searchNode.requestFocus();
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                });
              }),
        )
      ],
    );
  }
}
