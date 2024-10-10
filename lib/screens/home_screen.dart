import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/firebase_database/database_methods.dart';
import 'package:flutter_firebase_app/screens/add_new_data.dart';
import '../utils/show_toasts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<QuerySnapshot>? userStream;

  TextEditingController nameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userStream = FirebaseFirestore.instance.collection('User').snapshots(); // Khởi tạo userStream ở đây
  }

  Widget allUserDataList() {
    return StreamBuilder<QuerySnapshot>(
      stream: userStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapShot.hasError) {
          return Center(child: Text('Error: ${snapShot.error}'));
        }
        if (!snapShot.hasData || snapShot.data!.docs.isEmpty) {
          return Center(child: Text('No users found.'));
        }

        return ListView.builder(
          itemCount: snapShot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot userData = snapShot.data!.docs[index];
            return SizedBox(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.purple.shade50,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.purple.shade700, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${userData['Name']}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Profession: ${userData['Profession']}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Age: ${userData['Age']}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple.shade100,
                                  minimumSize: const Size(60, 30), // Kích thước tối thiểu của nút
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Padding
                                  textStyle: const TextStyle(fontSize: 14), // Kích thước chữ
                                ),
                                onPressed: () {
                                  nameController.text = userData['Name'];
                                  professionController.text = userData['Profession'];
                                  ageController.text = userData['Age'];
                                  editUserDetail(userData['Id']);
                                },
                                icon: const Icon(Icons.edit, size: 15),
                                label: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10), // Giảm khoảng cách giữa hai nút
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple.shade700,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(60, 30), // Kích thước tối thiểu của nút
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Padding
                                ),
                                onPressed: () {
                                  deleteUserData(userData['Id']);
                                },
                                icon: const Icon(Icons.delete, size: 15),
                                label: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade700,
        title: const Text(
          'Firebase Operations',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddNewData();
          }));
        },
      ),
      body: allUserDataList(),
    );
  }

  Future editUserDetail(String id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView( // Thêm SingleChildScrollView để cuộn nếu cần
            child: SizedBox(
              height: 410,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit User Detail',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Name',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 5.0),
                  _buildTextField(nameController),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Profession',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 5.0),
                  _buildTextField(professionController),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Age',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 5.0),
                  _buildTextField(ageController),
                  const SizedBox(height: 40.0),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade700),
                      onPressed: () async {
                        Map<String, dynamic> updatedUserData = {
                          "Name": nameController.text,
                          "Profession": professionController.text,
                          "Id": id,
                          "Age": ageController.text.toString(),
                        };
                        await DatabaseMethods()
                            .updateUserData(id, updatedUserData)
                            .then((value) {
                          Navigator.pop(context);
                          ShowToasts().getToast('Data Updated Successfully', Colors.green);
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        child: Text(
                          'Update User',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Future deleteUserData(String id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView( // Thêm SingleChildScrollView để tránh overflow
            child: SizedBox(
              height: 130.0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Are you sure? Want to delete data?',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        await DatabaseMethods().deleteUserData(id).then((value) {
                          Navigator.pop(context);
                          ShowToasts().getToast('Data Deleted Successfully', Colors.red);
                        });
                      },
                      child: const Text(
                        'Delete User',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
