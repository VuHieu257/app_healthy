
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_app/core/model/dairy.dart';
import 'package:http/http.dart' as http;

const String TODO_COLLECTION_REF="db_Diary";

class DatabaseService{
  final _fierstore=FirebaseFirestore.instance;
  late final CollectionReference _todosRef;
  DatabaseService(){
    _todosRef=_fierstore.collection(TODO_COLLECTION_REF).withConverter<Diary>(
        fromFirestore: (snapshots,_)=>Diary.formJson(
          snapshots.data()?.cast<String, Object>(),
        ) ,
        toFirestore: (message,_)=>message.toJson());
  }
  Stream<DocumentSnapshot> getChatDocumentStream(String documentId) {
    return _todosRef.doc(documentId).snapshots();
  }
  Stream<QuerySnapshot> getTodos(){
    return _todosRef.snapshots();
  }
  Stream<QuerySnapshot> getFind(String nameColumn,String title){
    return _todosRef.where(nameColumn,isEqualTo: title).snapshots();
  }
  void addTodo(Diary todo)async{
    _todosRef.add(todo);
  }
  Future<void> addOnly(String taskId,String title, List list) async {
    try {
      await _todosRef.doc(taskId).update({title: list});
      print('add updated successfully!'); // Thông báo thành công
    } catch (error) {
      print('Error updating Task: $error'); // Ghi log lỗi để debug
    }
  }
  void updateTodo(String todoId,Diary todo){
    _todosRef.doc(todoId).update(todo.toJson());
  }
  Future<void> addList(String taskId, String title, List list) async {
    try {
      await _todosRef.doc(taskId).update({
        title: FieldValue.arrayUnion(list),
      });
      print('add successfully!'); // Thông báo thành công
    } catch (error) {
      print('Error add: $error'); // Ghi log lỗi để debug
    }
  }
}
class NutritionService {
  static const String _apiKey = 'YXwbbPiyXFNJRkLBx0lOfFv0pbbyztCarXnfN5Ve';
  static const String _apiUrl = 'https://api.nal.usda.gov/fdc/v1/foods/search';

  Future<Map<String, dynamic>> fetchNutritionData(String query) async {
    final response = await http.get(Uri.parse('$_apiUrl?api_key=$_apiKey&query=$query'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load nutrition data');
    }
  }
}