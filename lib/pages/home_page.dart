import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/helpers/drawer.dart';

String languageType1;
var connectivity;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double iconWidth = 60.0;
  double iconHeight = 60.0;
  double spaceBetweenRows = 40.0;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  getLanguagetype() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      if (preferences.getInt(languageType) != null) {
        if (preferences.getInt(languageType) == 0) {
          languageType1 = uzbek;
        } else {
          languageType1 = russian;
        }
      } else {
        languageType1 = russian;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getLanguagetype();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        drawer: DrawerContainer(),
        body: Container(
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Image.asset('assets/ums.png'),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      languageType1 == uzbek
                          ? 'TALABLARGA MOS ALOQA OPERATORI'
                          : 'ОПЕРАТОР СВЯЗИ, КАКИМ ОН ДОЛЖЕН БЫТЬ',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/Yordam.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Yordam' : 'Помощь')
                      ],
                    ),
                    onPressed: () {
                      activeMenu = help;
                      Navigator.pushNamed(context, '/help');
                    },
                  ),
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/Internet.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Internet' : 'Интернет')
                      ],
                    ),
                    onPressed: () {
                      activeMenu = internet;
                      Navigator.pushNamed(context, '/internet');
                    },
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetweenRows,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/Tarif_rejalar.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Tariflar' : 'Тарифы')
                      ],
                    ),
                    onPressed: () {
                      activeMenu = tariff;
                      Navigator.pushNamed(context, '/tariffs');
                    },
                  ),
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/Hizmatlar.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Xizmatlar' : 'Услуги')
                      ],
                    ),
                    onPressed: () {
                      activeMenu = services;
                      Navigator.pushNamed(context, '/services');
                    },
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetweenRows,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/Muloqot.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Muloqot' : 'Общение')
                      ],
                    ),
                    onPressed: () {
                      activeMenu = chats;
                      Navigator.pushNamed(context, '/chat');
                    },
                  ),
                  FlatButton(
                    splashColor: Colors.red[50],
                    highlightColor: Colors.red[50],
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/News.svg',
                          allowDrawingOutsideViewBox: true,
                          height: iconHeight,
                          width: iconWidth,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(languageType1 == uzbek ? 'Yangiliklar' : 'Новости')
                      ],
                    ),
                    onPressed: () {
                      activeMenu = news;

                      Navigator.pushNamed(context, '/news');
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

void checkConnectivity() async {
  connectivity = await (new Connectivity().checkConnectivity());
}
