// import 'package:http/http.dart' as http;
//
// class ServerRequest {
//
//   Future getColors() async {
//     final uri = Uri.http('192.168.10.162:8080', '/colors');
//     var res = await http.get(uri);
//     print(res.body);
//     print(res.statusCode);
//
//     if (res.statusCode == 200) {
//       print("success");
//       return res.body;
//     } else {
//       print("fail..");
//       return null;
//     }
//   }
//
//   Future getLessonHistory(datetime) async {
//     final uri = Uri.http('192.168.10.162:8080', '/datetime/$datetime');
//     var res = await http.get(uri);
//     print(res.body);
//     print(res.statusCode);
//
//     if (res.statusCode == 200) {
//       print("success");
//       return res.body;
//     } else {
//       print("fail..");
//       return null;
//     }
//   }
// }