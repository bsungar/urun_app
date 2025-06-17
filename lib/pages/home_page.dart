import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urun_app/pages/add_product_page.dart';
import 'package:urun_app/pages/edit_product_page.dart';
import 'package:urun_app/pages/login_page.dart';
import 'package:urun_app/services/auth_service.dart';
class BorderPainter extends CustomPainter {
  final double radius;
  BorderPainter({this.radius = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';

  void _deleteProduct(String docId) {
    FirebaseFirestore.instance.collection('products').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent,
        title:  Text('Ürünler',
        style: Theme.of(context).textTheme.titleLarge,
        ),centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0,left: 15.0),
              child: TextField(
                onChanged: (value) => setState(() => searchText = value.toLowerCase()),
                decoration: InputDecoration(
                  labelText: "Ürün Ara",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Hata oluştu.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final name = (data['name'] ?? '').toString().toLowerCase();
            return name.contains(searchText);
          }).toList();

          if (docs.isEmpty) {
            return const Center(child: Text('Ürün bulunamadı.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final isMine = data['createdBy']['uid'] == currentUser?.uid;

              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                child: CustomPaint(
                  painter: BorderPainter(),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 60),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEAE6F8), Color(0xFFD6C9F1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: Colors.black54, width: 1.5),
                      borderRadius: BorderRadius.circular(12), // Retro görünüm
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withAlpha(77),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data['imageUrl'] != null &&
                              data['imageUrl'].toString().startsWith('http'))
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data['imageUrl'],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 12),
                          Text(
                            '🍓 ${data['name'] ?? 'Ürün'}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'VT323',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '💾 ${data["description"] ?? ''}',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontFamily: 'VT323',
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isMine
                                    ? 'Senin Eklediğin'
                                    : (data['createdBy']['email'] ?? 'Bilinmeyen'),
                                style: const TextStyle(fontStyle: FontStyle.italic),
                              ),
                              if (isMine)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.deepPurpleAccent, size: 22),
                                      tooltip: 'Düzenle',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditProductPage(
                                              docId: docs[index].id,
                                              initialName: data['name'] ?? '',
                                              initialDescription: data['description'] ?? '',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                      tooltip: 'Sil',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: const Color(0xFFEAE6F8),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              title: const Text('Emin misin?',textAlign: TextAlign.center, style: TextStyle(fontFamily: 'VT323', fontSize: 22)),
                                              content: const Text(
                                                'Bu ürünü silmek istediğine emin misin?',
                                                style: TextStyle(fontFamily: 'VT323', fontSize: 18),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  style : ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('İptal', style: TextStyle(fontFamily: 'VT323')),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                                  onPressed: () {
                                                    _deleteProduct(docs[index].id);
                                                    Navigator.pop(context); // diyaloğu kapat
                                                  },
                                                  child: const Text('Sil', style: TextStyle(fontFamily: 'VT323', color: Colors.white)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );

            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
