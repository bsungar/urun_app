import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

  }

  Future<void> _uploadProduct() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'createdAt': Timestamp.now(),
        'createdBy': {
          'uid': user?.uid ?? '',
          'email': user?.isAnonymous == true ? 'Anonim' : user?.email ?? 'Bilinmiyor',
        }
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      print("HATA: $e");
    }

    setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      appBar: AppBar(centerTitle:true,backgroundColor:Colors.yellowAccent,title: const Text("Ürün Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.add_box_outlined,
              size: 180,
              color: Colors.teal,
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
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEAE6F8),
              ),
              onPressed: _uploadProduct,
              child: const Text("Ürünü Ekle",style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

