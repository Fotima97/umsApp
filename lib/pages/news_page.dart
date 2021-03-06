import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/helpers/news_model.dart';
import 'package:ums/pages/home_page.dart';
import 'package:ums/pages/news_more_pade.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewsPageState createState() => new _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  var dir;
  var jsonFile;
  var fileExists;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  void _navigateToItemDetail(Map<String, dynamic> message) {
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    Navigator.pushNamed(context, '/news');
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage $message');
      },
      onResume: (Map<String, dynamic> message) {
        _navigateToItemDetail(message);
        //   Navigator.pushNamed(context, '/news');
      },
      onLaunch: (Map<String, dynamic> message) {
        _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  List<NewsModel> parseNews(String responseBody) {
    final parsed = json.decode(responseBody);
    var jsonData;
    jsonData = (parsed).cast<Map<String, dynamic>>();

    return jsonData.map<NewsModel>((json) => NewsModel.fromJson(json)).toList();
  }

  void _saveJsonToFileSystem(String fileName, String content) {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      jsonFile.writeAsStringSync(content);
      // if (fileExists) this.setState(() => fileContent = JSON.decode(jsonFile.readAsStringSync()));
    });
  }

  Future<List<NewsModel>> _getServicesJsonFromPhoneStorage() async {
    var _newsJson;

    Directory directory = await getApplicationDocumentsDirectory();
    dir = directory;
    jsonFile = new File(dir.path + '/news.json');
    fileExists = jsonFile.existsSync();

    if (fileExists) {
      _newsJson = jsonFile.readAsStringSync();
      return parseNews(_newsJson);
    } else {
      Flushbar()
        ..title = "Проблемы с сервером"
        ..message = "Проверьте подключение к сети"
        ..duration = Duration(seconds: 1)
        ..icon = Icon(
          Icons.info,
          color: Colors.white,
        )
        ..backgroundColor = Colors.red
        ..show(context);
      return null;
    }
  }

  Future<List<NewsModel>> fetchNews() async {
    var client = http.Client();
    if (connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi) {
      final response = await client.get(languageType1 == uzbek
          ? 'http://umscontrol.dst.uz/news/en'
          : 'http://umscontrol.dst.uz/news/en');

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        _saveJsonToFileSystem('news.json', body);
        return parseNews(body);
      } else {
        return _getServicesJsonFromPhoneStorage();
      }
    } else {
      return _getServicesJsonFromPhoneStorage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Container(
            padding: EdgeInsets.all(8.0),
            child: FutureBuilder<List<NewsModel>>(
                future: fetchNews(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          var news = snapshot.data[index];
                          return FlatButton(
                            padding: EdgeInsets.all(0.0),
                            child: Card(
                              margin: EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        news.title,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(news.body),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                languageType1 == uzbek
                                                    ? 'Batafsil...'
                                                    : 'Подробнее...',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsMorePage(
                                            title: news.title,
                                            body: news.body,
                                          )));
                            },
                          );
                        });
                  } else {
                    return (Center(
                      child: CircularProgressIndicator(),
                    ));
                  }
                })));
  }
}
