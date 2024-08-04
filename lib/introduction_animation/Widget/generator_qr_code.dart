import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/size/size.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../QrImagePainter.dart';

class GeneratorQRcode extends StatefulWidget {
  final String id;
  final String name;
  final String carbs;
  final String fat;
  final String kcal;
  final String protein;
  final String qr_data;
  final bool status;
  const GeneratorQRcode({super.key, required this.name, required this.carbs, required this.fat, required this.kcal, required this.protein, required this.qr_data, required this.status, required this.id});

  @override
  State<GeneratorQRcode> createState() => _GeneratorQRcodeState();
}

class _GeneratorQRcodeState extends State<GeneratorQRcode> {
  TextEditingController urlController = TextEditingController();
  TextEditingController kcalController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController fatContentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _kcalController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  String? _qrData;
  QrImage? _qrImage;

  @override
  void initState() {
    if(widget.status){
      _nameController.text = widget.name;
      _carbsController.text =  widget.carbs;
      _fatController.text = widget.fat;
      _kcalController.text = widget.kcal;
      _proteinController.text = widget.protein;
      _qrData = _qrData;
    }
    super.initState();
  }
  void _generateQRCode() {
    setState(() {
      _qrData = 'Name: ${_nameController.text}, Carbs: ${_carbsController.text}, Fat: ${_fatController.text}, Kcal: ${_kcalController.text}, Protein: ${_proteinController.text}';
      final qrCode = QrCode.fromData(
        data: _qrData!,
        errorCorrectLevel: QrErrorCorrectLevel.L,
      );
      _qrImage = QrImage(qrCode);
    });
  }
  void _saveEditToFirestore() async {
    final productData = {
      'name': _nameController.text,
      'carbs': _carbsController.text,
      'fat': _fatController.text,
      'kcal': _kcalController.text,
      'protein': _proteinController.text,
      'qr_data': _qrData,
    };
    await FirebaseFirestore.instance.collection('db_products').doc(widget.id).update(productData);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product update successfully')));
  }

  void _saveToFirestore() async {
    final productData = {
      'name': _nameController.text,
      'carbs': _carbsController.text,
      'fat': _fatController.text,
      'kcal': _kcalController.text,
      'protein': _proteinController.text,
      'qr_data': _qrData,
    };
    await FirebaseFirestore.instance.collection('db_products').add(productData);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product saved successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(onTap: () => Navigator.pop(context),child: const Icon(Icons.arrow_back_ios,color: Colors.white,),),
        title:
        widget.status?const Text('Edit QR Code' ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),):
        const Text('Generator QR Code' ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'Product Name',    border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a product name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.height*0.01),
                        TextFormField(
                          controller: _carbsController,
                          decoration: InputDecoration(labelText: 'Carbs',    border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter carbs amount';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.height*0.01),
                        TextFormField(
                          controller: _fatController,
                          decoration: InputDecoration(labelText: 'Fat',    border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter fat amount';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.height*0.01),
                        TextFormField(
                          controller: _kcalController,
                          decoration: InputDecoration(labelText: 'Kcal',    border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter kcal amount';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.height*0.01),
                        TextFormField(
                          controller: _proteinController,
                          decoration: InputDecoration(
                            labelText: 'Protein',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter protein amount';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.height*0.02),
                        InkWell(
                        onTap: () => _generateQRCode(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade200,
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: const Text("Generate QR code",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
                          ),
                        ),
                        if (_qrData != null)
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              CustomPaint(
                                size: const Size(200, 200),
                                painter: QrImagePainter(_qrImage!),
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  widget.status?_saveEditToFirestore():_saveToFirestore();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent.shade200,
                                      borderRadius: const BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: const Text("Save",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
