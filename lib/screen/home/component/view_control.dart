part of '../home_course_list.dart';

class ViewControl extends StatefulWidget {
  ViewControl({this.scont});
  final ScrollController scont;
  @override
  _ViewControlState createState() => _ViewControlState();
}

class _ViewControlState extends State<ViewControl> {
  var viewControlloffset = 172.0;
  int filterVal = 0;
  int sortByVal = 0;
  var style = TextStyle(fontSize: 12.0);
  @override
  void initState() {
    this.widget.scont.addListener(listen);
    super.initState();
  }

  void listen() {
    if (this.widget.scont.offset <= 100) {
      setState(() {
        viewControlloffset = 172 - this.widget.scont.offset;
      });
    } else {
      if (viewControlloffset != 72) {
        setState(() {
          viewControlloffset = 72;
        });
      }
    }
    // else if (viewControlloffset >= 64.0) {
    //   setState(() {
    //     viewControlloffset = 64.0;
    //   });
    // }
  }

  @override
  void dispose() {
    // this.widget.scont?.dispose();
    widget.scont.removeListener(listen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Positioned(
      top: viewControlloffset,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 4), blurRadius: 4.0, color: Colors.grey),
          ],
          color: Colors.white,
        ),
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.filter_list),
                DropdownButton(
                    value: filterVal,
                    items: [
                      DropdownMenuItem(
                          child: Text(
                            'All(Except Hidden)',
                            style: style,
                          ),
                          value: 0),
                      DropdownMenuItem(
                          child: Text(
                            'In progress',
                            style: style,
                          ),
                          value: 1),
                      DropdownMenuItem(
                          child: Text(
                            'Future',
                            style: style,
                          ),
                          value: 2),
                      DropdownMenuItem(
                          child: Text(
                            'Past',
                            style: style,
                          ),
                          value: 3),
                      DropdownMenuItem(
                          child: Text(
                            'Starred',
                            style: style,
                          ),
                          value: 4),
                      DropdownMenuItem(
                          child: Text(
                            'Hidden',
                            style: style,
                          ),
                          value: 5),
                    ],
                    onChanged: (value) {
                      setState(() {
                        context.bloc<CardlistBloc>().add(ChangeFilter(value));
                        filterVal = value;
                      });
                    }),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.sort),
                DropdownButton(
                    value: sortByVal,
                    items: [
                      DropdownMenuItem(
                          child: Text(
                            'Course Name',
                            style: style,
                          ),
                          value: 0),
                      DropdownMenuItem(
                          child: Text(
                            'Last Accessed',
                            style: style,
                          ),
                          value: 1),
                    ],
                    onChanged: (value) {
                      setState(() {
                        sortByVal = value;
                      });
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
