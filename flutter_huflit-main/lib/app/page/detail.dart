import 'dart:convert';

import 'package:app_api/mainpage.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // khi dùng tham số truyền vào phải khai báo biến trùng tên require
  User user = User.userEmpty();
  late TextEditingController _fullNameController;
  late TextEditingController _idNumberController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _schoolYearController;
  late TextEditingController _genderController;
  late TextEditingController _birthDayController;

  @override
  void initState() {
    super.initState();
        // Khởi tạo các TextEditingController mà không cần giá trị ban đầu
    _fullNameController = TextEditingController();
    _idNumberController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _schoolYearController = TextEditingController();
    _genderController = TextEditingController();
    _birthDayController = TextEditingController();
    getDataUser();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _idNumberController.dispose();
    _phoneNumberController.dispose();
    _schoolYearController.dispose();
    _genderController.dispose();
    _birthDayController.dispose();
    super.dispose();
  }

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');
    
    if (strUser != null) {
      user = User.fromJson(jsonDecode(strUser));

      setState(() {
        _fullNameController = TextEditingController(text: user.fullName);
        _idNumberController = TextEditingController(text: user.idNumber);
        _phoneNumberController = TextEditingController(text: user.phoneNumber);
        _schoolYearController = TextEditingController(text: user.schoolYear);
        _genderController = TextEditingController(text: user.gender);
        _birthDayController = TextEditingController(text: user.birthDay);
      });
    }
  }
  _saveUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user = User(
      idNumber: _idNumberController.text,
      accountId: user.accountId,
      fullName: _fullNameController.text,
      phoneNumber: _phoneNumberController.text,
      imageURL: user.imageURL,
      birthDay: _birthDayController.text,
      gender: _genderController.text,
      schoolYear: _schoolYearController.text,
      schoolKey: user.schoolKey,
      dateCreated: user.dateCreated,
      status: user.status,
    );
    String strUser = jsonEncode(user.toJson());
    await pref.setString('user', strUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User data saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // create style
    TextStyle mystyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.amber,
    );
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/images/profile_image.png'), // Thêm ảnh asset hoặc ảnh từ mạng
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.fullName ?? 'N/A',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _idNumberController,
              decoration: const InputDecoration(
                labelText: 'NumberID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _birthDayController,
                    decoration: const InputDecoration(
                      labelText: 'Birth Day',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _genderController,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _schoolYearController,
              decoration: const InputDecoration(
                labelText: 'School Year',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveUserData,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    // Scaffold(
    //   body: SingleChildScrollView(
    //     child: Center(
    //       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    //         Image(
    //           image: NetworkImage(user.imageURL!),
    //           height: 200,
    //           width: 200,
    //         ),
    //         Text("NumberID: ${user.idNumber}", style: mystyle),
    //         Text("Fullname: ${user.fullName}", style: mystyle),
    //         Text("Phone Number: ${user.phoneNumber}", style: mystyle),
    //         Text("Gender: ${user.gender}", style: mystyle),
    //         Text("birthDay: ${user.birthDay}", style: mystyle),
    //         Text("schoolYear: ${user.schoolYear}", style: mystyle),
    //         Text("schoolKey: ${user.schoolKey}", style: mystyle),
    //         Text("dateCreated: ${user.dateCreated}", style: mystyle),
    //       ]),
    //     ),
    //   ),
    // );
  }
}
