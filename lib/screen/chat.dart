import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom>
    with SingleTickerProviderStateMixin {
  TabController tc;
  PageController pc;
  int selectedIndex = 0;
  @override
  void initState() {
    tc = TabController(length: 2, vsync: this);
    pc = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orient = MediaQuery.of(context).orientation.index;
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
          Container(
            child: Row(
              children: <Widget>[
                LayoutBuilder(builder: (context, constraint) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          minExtendedWidth: 128.0 + 64.0,
                          labelType:
                              orient == 0 ? NavigationRailLabelType.all : null,
                          extended: orient == 0 ? false : true,
                          destinations: [
                            NavigationRailDestination(
                              icon: CircleAvatar(),
                              selectedIcon: CircleAvatar(
                                radius: 24,
                              ),
                              label: Text('First'),
                            ),
                            NavigationRailDestination(
                              icon: CircleAvatar(),
                              selectedIcon: CircleAvatar(
                                radius: 24,
                              ),
                              label: Text('Second'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.add_circle_outline),
                              selectedIcon: Icon(Icons.add_circle),
                              label: Text('Second'),
                            ),
                          ],
                          selectedIndex: selectedIndex,
                          onDestinationSelected: (i) {
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
          ),
          Container(
            child: ContactPage(),
          ),
        ],
      ),
    );
  }
}

class MessageScreen extends StatelessWidget {
  MessageScreen({this.id});
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
                for (int i = 0; i < 15; i++) Text('gamen $id')
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SearchButton(),
      body: ListView.builder(
        itemBuilder: (context, i) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text('Nama Lengkap'),
                leading: CircleAvatar(),
              ),
              Divider()
            ],
          );
        },
        itemCount: 14,
      ),
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
  double width = 2.0;
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
