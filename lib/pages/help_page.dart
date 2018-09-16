import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ums/helpers/app_constants.dart';
import 'package:ums/helpers/drawer.dart';
import 'package:ums/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HelpPageState createState() => new _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  Future<bool> _onWillPop() {
    activeMenu = home;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text(widget.title),
          ),
          drawer: DrawerContainer(),
          body: ListView(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            children: <Widget>[
              ListTile(
                title: Text(
                  languageType1 == uzbek
                      ? 'Hisobni tekshirish'
                      : 'Проверка баланса',
                ),
                onTap: () {
                  launch('tel:*100%23');
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                  title: Text(
                    languageType1 == uzbek
                        ? 'Oxirgi to`lov'
                        : 'Последняя оплата баланса',
                  ),
                  onTap: () {}),
              Divider(
                height: 2.0,
              ),
              ListTile(
                  title: Text(
                    languageType1 == uzbek
                        ? 'Mening xarajatlarim'
                        : 'Мои расходы',
                  ),
                  onTap: () {}),
              Divider(
                height: 2.0,
              ),
              ListTile(
                  title: Text(
                    languageType1 == uzbek
                        ? 'Reklamalarni taqiqlash'
                        : 'Запрет рассылок',
                  ),
                  onTap: () {}),
              Divider(
                height: 2.0,
              ),
              ListTile(
                  title: Text(
                    languageType1 == uzbek
                        ? 'Yoqilgan xizmatlar'
                        : 'Подключенные услуги',
                  ),
                  onTap: () {}),
              Divider(
                height: 2.0,
              ),
              ListTile(
                  title: Text(
                    languageType1 == uzbek ? 'Mening raqamim' : 'Мой номер',
                  ),
                  onTap: () {
                    launch('tel:*150%23');
                  }),
              Divider(
                height: 2.0,
              ),
              ListTile(
                  title: Text(
                    languageType1 == uzbek
                        ? 'Mening barcha raqamlarim'
                        : 'Все мои номера',
                  ),
                  onTap: () {}),
              Divider(
                height: 2.0,
              ),
              ListTile(
                title: Text(
                  languageType1 == uzbek
                      ? 'Yordam berish xizmati'
                      : 'Службы поддержки',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {},
                trailing: Icon(Icons.call),
              ),
              Divider(
                height: 2.0,
              ),
            ],
          )),
    );
  }
}
