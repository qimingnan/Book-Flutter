import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:thief_book_flutter/common/utils/http.dart';
import 'package:thief_book_flutter/models/book.dart';

class SearchSourceProcessing {
  static Future<List<Book>> aixdzsData(String bookName) async {
    var baseUrl = "https://www.aixdzs.com";
    // var path = await Config.getLocalFilePath(context);
    final res = await Http.get(baseUrl + "/bsearch?q=" + bookName);
    // File cf = new File(path + "/res.txt");
    // // cf.writeAsStringSync(json.encode(out));
    var str = utf8.decode(res);
    var html = parse(str);
    var content = html.querySelector(".box_k");
    List<Element> list = content.querySelectorAll("li");
    var books = new List<Book>();
    list.forEach((e) {
      var listImg = e.querySelector(".list_img");
      var a = listImg.querySelector("a");
      var detailUrl = a.attributes["href"];
      var img = listImg.querySelector("img");
      var imgUrl = img.attributes["src"];
      var bookName = e.querySelector(".b_name").children[0].text;
      var info = e.querySelector(".b_intro").text;
      var author = e.querySelector(".l1").text;
      var count = e.querySelector(".l2").text; //字数
      var status = e.querySelector(".cp").text; //完结 连载
      var hrefStr = e.querySelector(".b_name").children[0].attributes["href"];
      var s = hrefStr.substring(0, hrefStr.length - 2);
      var id = s.substring(s.lastIndexOf("/") + 1);
      var downTxt = baseUrl + "/down?id=" + id + "&p=1";
      // https: //www.aixdzs.com/down?id=58741&p=1
      var book = new Book(
          importUrl: downTxt,
          name: bookName,
          author: author,
          info: info,
          sourceType: "aixdzs",
          sourceAddress: baseUrl + detailUrl,
          catalogUrl: baseUrl.replaceAll("www", "read") + detailUrl,
          wordCount: count,
          imgUrl: imgUrl,
          status: status);
      books.add(book);
      print(book.toJson());
    });
    return books;
  }
}
