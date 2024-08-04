import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:health_app/introduction_animation/Widget/generator_qr_code.dart';
import 'package:health_app/introduction_animation/Widget/scan_qr_code.dart';
import 'package:qr/qr.dart';

import '../screens/login/sign_in.dart';
import 'QrImagePainter.dart';

class Qr extends StatefulWidget {
  const Qr({super.key});

  @override
  State<Qr> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Qr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner and Generator' ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen(),), (route) => false);
              },
              child: const Icon(Icons.logout,color: Colors.white,),
            ),
          ),
        ],

      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanQRcode(),));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent.shade200,
                        borderRadius: const BorderRadius.all(Radius.circular(10))
                    ),
                    child: const Text("Scan QR",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GeneratorQRcode(name: '', carbs: '', fat: '', kcal: '', protein: '', qr_data: '', status: false, id: '',),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent.shade200,
                        borderRadius: const BorderRadius.all(Radius.circular(10))
                    ),
                    child: const Text("Create QR",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.height*0.01,),
            const Divider(),
            SizedBox(height: context.height*0.01,),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('db_products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final products = snapshot.data!.docs;

                return SizedBox(
                  height: context.height*0.68,
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      // final product = products[index].data() as Map<String, dynamic>;
                      final product = products[index];
                      final docId=product.id;
                      final qrCode = QrCode.fromData(
                        data: product['qr_data'],
                        errorCorrectLevel: QrErrorCorrectLevel.L,
                      );
                      return Column(
                        children: [
                          Text("Name:${product['name'] ?? 'No Name'}"),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                CustomPaint(
                                  size: const Size(100, 100),
                                  painter: QrImagePainter(QrImage(qrCode)),
                                ),
                                SizedBox(width: context.width*0.02,),
                                Column(
                                  children: [
                                    Text("kcal:${product['kcal'] ?? 'No kcal'}"),
                                    SizedBox(height: context.height*0.02,),
                                    Text("fat:${product['fat'] ?? 'No fat'}"),
                                  ],
                                ),
                                SizedBox(width: context.width*0.04,),
                                Column(
                                  children: [
                                    Text("carbs:${product['carbs'] ?? 'No carbs'}"),
                                    SizedBox(height: context.height*0.02,),
                                    Text("protein:${product['protein'] ?? 'No protein'}"),
                                  ],
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => GeneratorQRcode(
                                          name: product['name'],
                                          carbs: product['carbs'],
                                          fat: product['fat'],
                                          kcal:product['kcal'],
                                          protein: product['protein'],
                                          qr_data: product['qr_data'],
                                          status: true, id: docId,),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent.shade200,
                                        borderRadius: const BorderRadius.all(Radius.circular(10))
                                    ),
                                    child: const Icon(Icons.edit_note_outlined,color: Colors.white,)
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text('Are you sure you want to delete this product?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance.collection('db_products').doc(docId).delete();
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted successfully')));
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.red.shade400,
                                        borderRadius: const BorderRadius.all(Radius.circular(10))
                                    ),
                                    child: const Icon(Icons.delete,color: Colors.white,)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
