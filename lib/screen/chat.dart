// import 'package:animations/animations.dart';
import 'package:aula/bloc/messaging/messaging_bloc.dart';
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
    pc = PageController(initialPage: 0)
      ..addListener(() {
        if (pc.page == 0) {
          setState(() {
            openedpage = pc.page;
          });
        }
        if (pc.page == 1) {
          setState(() {
            openedpage = pc.page;
          });
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orient = MediaQuery.of(context).orientation.index;
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          openedpage == 1.0
              ? IconButton(icon: Icon(Icons.person_add), onPressed: () {})
              : Container(),
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
                              minHeight: constraint.maxHeight, maxWidth: 72.0),
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
                              selectedIndex: selectedIndex,
                              onDestinationSelected: (i) {
                                context.bloc<MessagingBloc>().add(ShowMessages(
                                    idTo: state.sideChat[i]['idTo']));
                                setState(() {
                                  selectedIndex = i;
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                    VerticalDivider(thickness: 1, width: 1),
                    Expanded(
                      child: MessageScreen(id: selectedIndex),
                    ),
                  ],
                ),
              );
            }
            return CircularProgressIndicator();
          }),
          Container(
            child: ContactPage(),
          ),
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
  Widget _tileCard(context, DocumentSnapshot document) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(document['email']),
          leading: CircleAvatar(),
        ),
        Divider()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SearchButton(),
      body: StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, i) {
                  return _tileCard(context, snapshot.data.documents[i]);
                },
                itemCount: snapshot.data.documents.length,
              );
            }
            return CircularProgressIndicator();
          }),
    );
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
  double width = 0.0;
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
                if (open) {
                  searchNode.requestFocus();
                } else {
                  FocusScope.of(context).unfocus();
                }
              }),
        )
      ],
    );
  }
}
