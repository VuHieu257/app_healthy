import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DateProvider with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime _timeWater = DateTime.now();

  double _totalKcal = 0.0;
  double _totalCarbs = 0.0;
  double _totalProtein = 0.0;
  double _totalFat = 0.0;

  double _totalBreakfastKcal = 0.0;
  double _totalLunchKcal = 0.0;
  double _totalDinnerKcal = 0.0;
  double _totalSnackKcal = 0.0;

  bool _isLoading = false; // Flag to track loading state
  String _dataId = '';
  int _water = 0;
  String _dataBodyId = '';
  String _dataWaterId = '';
  String _idUser = 'defaultUserId';


  String get idUser => _idUser;
  DateTime get selectedDate => _selectedDate;
  DateTime get timeWater => _timeWater;
  String get dataId => _dataId;
  String get dataBodyId => _dataBodyId;
  String get dataWaterId => _dataWaterId;
  int get water => _water;

  double get totalKcal => _totalKcal;
  double get totalCarbs => _totalCarbs;
  double get totalProtein => _totalProtein;
  double get totalFat => _totalFat;

  double get totalBreakfastKcal => _totalBreakfastKcal;
  double get totalLunchKcal => _totalLunchKcal;
  double get totalDinnerKcal => _totalDinnerKcal;
  double get totalSnackKcal => _totalSnackKcal;
  bool get isLoading => _isLoading;

  void incrementDate() {
    _selectedDate = _selectedDate.add(const Duration(days: 1));
    notifyListeners();
  }

  void decrementDate() {
    _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setBodyId(String id) {
    _dataBodyId = id;
    notifyListeners();
  }
  void setWater(int id) {
    _water = id;
    notifyListeners();
  }
  void setIdUser(String userId) {
    _idUser = userId;
    checkAndDisplayData(); // Gọi lại fetchData để lấy dữ liệu mới cho idUser mới
  }
  Future<void> fetchDataAndCalculateTotalKcal(String documentId) async {
    _isLoading = true; // Bắt đầu loading
    notifyListeners();
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('db_Diary')
          .doc(documentId) // Truy vấn dựa trên documentId
          .get();

      if (documentSnapshot.exists) {
        // Lấy dữ liệu từ tài liệu đã tìm thấy
        List<dynamic> breakFastList = documentSnapshot.get('breakFastList') ?? [];
        List<dynamic> lunchList = documentSnapshot.get('lunchList') ?? [];
        List<dynamic> dinnerList = documentSnapshot.get('dinnerList') ?? [];
        List<dynamic> snackList = documentSnapshot.get('snackList') ?? [];
        var time = documentSnapshot.get('time');
        DateTime dateTime = time.toDate();
        String formattedItemDate = DateFormat('yyyy-MM-dd').format(dateTime);
        String formattedSelectedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

        if (formattedItemDate == formattedSelectedDate) {
          _totalBreakfastKcal = calculateTotalKcal(breakFastList);
          _totalLunchKcal = calculateTotalKcal(lunchList);
          _totalDinnerKcal = calculateTotalKcal(dinnerList);
          _totalSnackKcal = calculateTotalKcal(snackList);
          _totalKcal = calculateTotalKcal(breakFastList) + calculateTotalKcal(lunchList) + calculateTotalKcal(dinnerList) + calculateTotalKcal(snackList);
          _totalCarbs = calculateTotal(breakFastList,'Carbs') + calculateTotal(lunchList,'Carbs') + calculateTotal(dinnerList,'Carbs') + calculateTotal(snackList,'Carbs');
          _totalFat = calculateTotal(breakFastList,'fat') + calculateTotal(lunchList,'fat') + calculateTotal(dinnerList,'fat') + calculateTotal(snackList,'fat');
          _totalProtein = calculateTotal(breakFastList,'protein') + calculateTotal(lunchList,'protein') + calculateTotal(dinnerList,'protein') + calculateTotal(snackList,'protein');
        }
      }
      _isLoading = false; // Kết thúc loading
      notifyListeners();
    } catch (error) {
      _isLoading = false; // Kết thúc loading với lỗi
      print('Error fetching data: $error');
      // Xử lý lỗi nếu cần thiết
    }
  }
  Future<void> checkAndDisplayData() async {
    _isLoading = true;
    notifyListeners();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final todayStart = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    try {
      final querySnapshot = await _firestore
          .collection('db_Diary')
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
          .where('time', isLessThan: Timestamp.fromDate(todayEnd))
          .where('idUser', isEqualTo: idUser)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Hiển thị dữ liệu nếu ngày tháng khớp
        _dataId =querySnapshot.docs.first.id;

      } else {
        // Tạo mới dữ liệu nếu ngày tháng không khớp
        final newData = {
          'time': Timestamp.fromDate(_selectedDate),
          'breakFastList': [],
          'dinnerList': [],
          'idUser': idUser,
          'lunchList': [],
          'snackList': [],
        };
        final docRef = await _firestore.collection('db_Diary').add(newData);
        _dataId = docRef.id;
      }
      fetchDataAndCalculateTotalKcal(_dataId);
      _isLoading = false; // Kết thúc loading
      notifyListeners();
    } catch (error) {
      _isLoading = false; // Kết thúc loading
      notifyListeners();
      print(error);
    }
  }
  Future<void> checkAndDisplayWaterData() async {
    _isLoading = true;
    notifyListeners();
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final todayStart = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    try {
      final querySnapshot = await fireStore
          .collection('db_water')
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
          .where('time', isLessThan: Timestamp.fromDate(todayEnd))
          .where('idUser', isEqualTo: idUser)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Hiển thị dữ liệu nếu ngày tháng khớp
        _dataWaterId =querySnapshot.docs.first.id;
        _water=querySnapshot.docs.first['totalWater'];
        _timeWater=querySnapshot.docs.first['time'];
        // water = querySnapshot.docs.first['totalWater'];
      } else {
        // Tạo mới dữ liệu nếu ngày tháng không khớp
        final newData = {
          'time': Timestamp.fromDate(_selectedDate),
          'timeFrame1':false,
          'timeFrame2':false,
          'timeFrame3':false,
          'timeFrame4':false,
          'timeFrame5':false,
          'timeFrame6':false,
          'timeFrame7':false,
          'timeFrame8':false,
          'idUser':idUser,
          'totalWater':0
        };
        final docRef = await fireStore.collection('db_water').add(newData);
        _dataWaterId = docRef.id;
        _water=0;
      }
      fetchDataAndCalculateTotalKcal(_dataId);
      _isLoading = false; // Kết thúc loading
      notifyListeners();
    } catch (error) {
      _isLoading = false; // Kết thúc loading
      notifyListeners();
      print(error);
    }
  }
  Future<void> checkAndDisplayBodyData() async {
    try {
      _isLoading = true;
      notifyListeners();
      final FirebaseFirestore fireStore = FirebaseFirestore.instance;
      final querySnapshot = await fireStore
          .collection('db_body')
          .where('idUser', isEqualTo: idUser)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _dataBodyId = querySnapshot.docs.first.id;
      }
      else {
        final newData = {
          'idUser': idUser,
          'height': "0",
          'weight': "0",
          'time': Timestamp.now()
        };
        final docRef = await fireStore.collection('db_body').add(newData);
        _dataBodyId = docRef.id;
      }
      _isLoading = false; // Kết thúc loading
      notifyListeners();
    } catch (error) {
      _isLoading = false; // Kết thúc loading
      notifyListeners();
      print(error);
    }
  }
  double calculateTotalKcal(List<dynamic> mealList) {
    double totalKcal = 0.0;
    for (var item in mealList) {
      totalKcal += double.parse(item['kcal'].toString());
    }
    return totalKcal;
  }
  double calculateTotal(List<dynamic> mealList, String title) {
    double totalKcal = 0.0;
    for (var item in mealList) {
      totalKcal += double.parse(item[title].toString());
    }
    return totalKcal;
  }
}