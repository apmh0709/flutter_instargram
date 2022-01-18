import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notifications = FlutterLocalNotificationsPlugin();



initNotification(context) async {

  //안드로이드용 아이콘파일 이름
  // android/app/src/main/res/drawable 안에 png파일 넣기
  var androidSetting = AndroidInitializationSettings('asd');

  //ios에서 앱 로드시 유저에게 권한요청하려면
  var iosSetting = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting
  );
  await notifications.initialize(
    initializationSettings,
    onSelectNotification: (a){
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => Text('새 페이지'),),);
    }

  );
}

showNotification() async {

  var androidDetails = AndroidNotificationDetails(
    '',
    '',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );
  var iosDetails = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  // 알림 id, 제목, 내용
  notifications.show(
      1,
      '',
      '',
      NotificationDetails(android: androidDetails, iOS: iosDetails)
  );
}

showNotification2() async {

  tz.initializeTimeZones();

  var androidDetails = const AndroidNotificationDetails(
    '',
    '',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );
  var iosDetails = const IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  
  notifications.zonedSchedule(
      2,
      '',
      '',
      tz.TZDateTime.now(tz.local),
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      // 같은 시간에 알람을 띄워줌
      matchDateTimeComponents: DateTimeComponents.time
  );
}

makeDate(hour, min, sec){
  var now = tz.TZDateTime.now(tz.local);
  var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);
  if (when.isBefore(now)) {
    return when.add(Duration(days: 1));
  } else {
    return when;
  }
}