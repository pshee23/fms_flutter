import 'package:flutter/material.dart';
import '../locator/locator.dart';
import '../model/Lesson.dart';
import '../service/http_service.dart';

typedef LessonSetter = void Function(Lesson lesson);

class LessonAlertDialog extends StatefulWidget {
  final LessonSetter lessonResult;

  const LessonAlertDialog({
    required this.lessonResult,
    Key? key}) : super(key: key);

  @override
  State<LessonAlertDialog> createState() => _LessonAlertDialogState();
}

class _LessonAlertDialogState extends State<LessonAlertDialog> {
  String? labelText = '';

  final HttpService _httpService = locator<HttpService>();
  TextEditingController searchController = TextEditingController();
  Future<List<Lesson>>? searchResultList;

  emptySearchField() {
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Icon(Icons.format_list_bulleted_outlined),
          SizedBox(width: 10),
          Expanded(
              child: Text(labelText!)
          ),
          ElevatedButton.icon(onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                            title: Text("Select Lesson"),
                            content: Scaffold(
                              appBar: searchHeader(setState),
                              body: searchResultList == null
                                  ? displayAllList()
                                  : displayFoundList(),
                            )
                        );
                      }
                  );
                }
            );
          }, icon: Icon(Icons.search), label: Text("검색"),),

        ]
    );
  }

  AppBar searchHeader(StateSetter setState) {
    return AppBar(
        automaticallyImplyLeading: false,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search here..',
            hintStyle: TextStyle(
              color: Colors.lightBlueAccent,
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlueAccent)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            filled: true,
            // prefixIcon: Icon(Icons.person_pin, color: Colors.lightBlueAccent, size:30),
            suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.white,),
              onPressed: emptySearchField,
            ),
          ),
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          onFieldSubmitted: (str) {
            print('onFieldSubmitted=$str');
            Future<List<Lesson>> lessonList = _httpService.fetchLessonsByEmployee();

            setState(() {
              searchResultList = lessonList;
              print('onFieldSubmitted result=$searchResultList');
            });
          },
        )
    );
  }

  displayAllList() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.group, color: Colors.grey, size: 15),
            Text(
              'Search Lesson',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  displayFoundList() {
    return FutureBuilder(
        future: searchResultList,
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Text('No DATA');
          }
          List<LessonResult> searchList = [];
          List<Lesson>? lessonList = snapshot.data;

          lessonList!.forEach((element) {
            LessonResult lessonResult = LessonResult(
              eachLesson: element,
              lessonSetter: (Lesson lesson) {
                setState(() {
                  labelText = lesson.lessonName;
                  widget.lessonResult(lesson);
                });
              },
            );
            searchList.add(lessonResult);
          });

          return ListView(
            children: searchList,
          );
        }
    );
  }

}

class LessonResult extends StatelessWidget {
  final Lesson eachLesson;
  final LessonSetter lessonSetter;

  const LessonResult({
    required this.eachLesson,
    required this.lessonSetter,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print('tapped=$eachLesson');
                lessonSetter(eachLesson);
                Navigator.pop(context);
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  // backgroundImage: eachLesson.lessonId == 0 > circularProgress() : null
                ),
                title: Text(eachLesson.lessonName, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),),
                subtitle: Text(eachLesson.memberName, style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
