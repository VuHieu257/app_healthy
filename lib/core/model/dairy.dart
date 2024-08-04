
import 'package:cloud_firestore/cloud_firestore.dart';

class Diary{
  final String idUser;
  final Timestamp time;
  final List breakFastList;
  final List snackList;
  final List lunchList; // Danh sách dữ liệu
  final List dinnerList; // Danh sách dữ liệu
//   final double kcalBF; // Danh sách dữ liệu
//   final double kcalLN; // Danh sách dữ liệu
//   final double kcalDN; // Danh sách dữ liệu
//   final double kcalSN; // Danh sách dữ liệu


  Diary({
    required this.idUser,
    required this.time,
    required this.breakFastList,
    required this.lunchList,
    required this.dinnerList,
    required this.snackList,
    // required this.kcalBF,
    // required this.kcalLN,
    // required this.kcalDN,
    // required this.kcalSN,
  });
  Diary.formJson(Map<String,dynamic>?json):this(
    idUser: json?['idUser']! as String,
    time: json?['time']! as Timestamp,
    breakFastList: json?['breakFastList']! as List,
    lunchList: json?['lunchList']! as List,
    dinnerList: json?['dinnerList']! as List,
    snackList: json?['snackList']! as List,
    // kcalBF: json?['kcalBF']! as double,
    // kcalLN: json?['kcalLN']! as double,
    // kcalDN: json?['kcalDN']! as double,
    // kcalSN: json?['kcalSN']! as double,
  );
  Diary copyWith(
      {
        String? idUser,
        Timestamp? time,
        List?breakFastList,
        List?lunchList,
        List?dinnerList,
        List?snackList,
        // double?kcalBF,
        // double?kcalLN,
        // double?kcalDN,
        // double?kcalSN,
      }){
    return Diary(
      time: time??this.time,
      idUser: idUser??this.idUser,
      breakFastList: breakFastList??this.breakFastList,
      lunchList: lunchList??this.lunchList,
      dinnerList: dinnerList??this.dinnerList,
      snackList: snackList??this.snackList,
      // kcalBF: kcalBF??this.kcalBF,
      // kcalLN: kcalLN??this.kcalLN,
      // kcalDN: kcalDN??this.kcalDN,
      // kcalSN: kcalSN??this.kcalSN,
    );
  }
  Map<String,Object?>toJson(){
    return{
      'idUser':idUser,
      'time':time,
      'breakFastList':breakFastList,
      'lunchList':lunchList,
      'dinnerList':dinnerList,
      'snackList':snackList,
      // 'kcalBF':kcalBF,
      // 'kcalLN':kcalLN,
      // 'kcalDN':kcalDN,
      // 'kcalSN':kcalSN,
    };
  }
}
