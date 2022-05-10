// @dart=2.9
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class Scrapper{
  static var URL = "https://www.vyatsu.ru/studentu-1/spravochnaya-informatsiya/teacher.html";
  static const domen = "https://www.vyatsu.ru";
  static void GetData() async{
    List<String> href = [];

    var res = await http.get(Uri.parse(URL));

    var body = utf8.decode(res.bodyBytes);

    var html = parse(body);

    final title = html.querySelectorAll('#listPeriod_5172 > a');
    for (var a in title){
      if (a.attributes["href"].contains("html")){
        href.insert(href.length, a.attributes["href"]);
      }
    }

    for (var x in href){
      print(domen+x);
    }

  }
}

void main(List<String> args){
  Scrapper.GetData();
}
