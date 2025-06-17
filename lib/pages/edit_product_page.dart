import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProductPage extends StatefulWidget {
  final String docId;
  final String initialName;
  final String initialDescription;

  const EditProductPage({
    super.key,
    required this.docId,
    required this.initialName,
    required this.initialDescription,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descController = TextEditingController(text: widget.initialDescription);
  }

  Future<void> _updateProduct() async {
    await FirebaseFirestore.instance.collection('products').doc(widget.docId).update({
      'name': _nameController.text.trim(),
      'description': _descController.text.trim(),
    });

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      appBar: AppBar(centerTitle:true,title: const Text("Ürünü Düzenle"),
      backgroundColor: Colors.yellowAccent,),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: const Icon(
                Icons.edit,
                size: 100,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: _nameController,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              cursorColor: Colors.teal, // İmleç rengi
              decoration: InputDecoration(
                labelText: "Ürün Adı",
                labelStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: Color(0xFFEAE6F8),// Arkaplan rengi
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal.shade200, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              cursorColor: Colors.teal, // İmleç rengi
              decoration: InputDecoration(
                labelText: "Açıklama",
                labelStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: Color(0xFFEAE6F8),// Arkaplan rengi
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal.shade200, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(style:ElevatedButton.styleFrom(
              backgroundColor:  Color(0xFFEAE6F8),
            ), onPressed: _updateProduct, child: const Text("Güncelle",style: TextStyle(fontSize: 18),)),
          ],
        ),
      ),
    );
  }
}
