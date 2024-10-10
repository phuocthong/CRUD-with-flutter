import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/firebase_database/database_methods.dart';
import 'package:flutter_firebase_app/utils/show_toasts.dart';
import 'package:random_string/random_string.dart';

class AddNewData extends StatefulWidget {
  const AddNewData({super.key});

  @override
  State<AddNewData> createState() => _AddNewDataState();
}

class _AddNewDataState extends State<AddNewData> {
  TextEditingController nameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController ageController = TextEditingController();

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.purple.shade700,
      title: const Text(
        'Add New User',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Name',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const SizedBox(height: 5.0),
          _buildTextField(nameController, 'Enter name'),
          const SizedBox(height: 10.0),
          const Text(
            'Profession',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const SizedBox(height: 5.0),
          _buildTextField(professionController, 'Enter profession'),
          const SizedBox(height: 10.0),
          const Text(
            'Age',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const SizedBox(height: 5.0),
          _buildTextField(ageController, 'Enter age'),
          const SizedBox(height: 40.0),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700
              ),
              onPressed: () async {
                // Kiểm tra xem các trường có được nhập không
                if (nameController.text.isEmpty || 
                    professionController.text.isEmpty || 
                    ageController.text.isEmpty) {
                  ShowToasts().getToast('Please fill all fields', Colors.red);
                  return; // Thoát hàm nếu có trường trống
                }

                String id = randomAlphaNumeric(8);
                Map<String, dynamic> userData = {
                  "Name": nameController.text,
                  "Profession": professionController.text,
                  "Id": id,
                  "Age": ageController.text, // Đảm bảo đây là chuỗi
                };

                try {
                  await DatabaseMethods().addUserData(userData, id);
                  ShowToasts().getToast('Data Saved Successfully', Colors.green);
                } catch (error) {
                  ShowToasts().getToast('Error: $error', Colors.red); // Xử lý lỗi
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                child: Text(
                  'Add User',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  // Phương thức tạo TextField với thêm hintText
  Widget _buildTextField(TextEditingController controller, String hintText) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    decoration: BoxDecoration(
      border: Border.all(width: 2.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: TextField(
      controller: controller,
      maxLines: 1, // Giới hạn dòng
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText, // Hiển thị text gợi ý
      ),
    ),
  );
}
}
