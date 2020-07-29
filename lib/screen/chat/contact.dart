// part of 'chat.dart';
import 'package:aula/repository/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aula/bloc/contact/contact_bloc.dart' as contact;
import 'package:aula/bloc/messaging/messaging_bloc.dart';

class ContactPage extends StatelessWidget {
  ContactPage({this.pc});

  final PageController pc;
  Widget _tileCard(context, document) {
    // print(document['pp']);
    // ignore: close_sinks
    var bloc = BlocProvider.of<MessagingBloc>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          onTap: () {
            bloc.add(ShowMessages(idTo: document['email']));

            FocusScope.of(context).unfocus();
            pc.animateToPage(0,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          title: Text(document['email']),
          subtitle: Text(document['username']),
          leading: CircleAvatar(
            backgroundImage:
                document['pp'] != '' ? NetworkImage(document['pp']) : null,
            // child: document['pp'] != null
            //     ? Image.network(document['pp'])
            //     : Container(),
          ),
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
              return Center(child: CircularProgressIndicator());
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
            return Center(child: CircularProgressIndicator());
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
