import 'package:dio/dio.dart';
void main() {
  final fd = FormData.fromMap({'cabang_id': 1});
  print(fd.fields);
}
