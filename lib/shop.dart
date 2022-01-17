import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);
  @override
  _ShopState createState() => _ShopState();
}
class _ShopState extends State<Shop> {

  getDb() async{
    try{
    // await auth.signInWithEmailAndPassword(email: 'jhjh0807@naver.com', password: '123456');
    await firestore.collection('product').get();
    } catch(e){
      print(e);
    }
   if(auth.currentUser?.uid == null){
     print('비로그인 상태입니다.');
   } else {
     print('로그인 상태입니다.');
   }
  // 로그아웃은 auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    getDb();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵페이지!!'),
    );
  }
}
