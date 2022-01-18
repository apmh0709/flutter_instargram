import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instargram/shop.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'notification.dart';

void main() async{

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => Store1()),
          // ChangeNotifierProvider(create: (c) => Store2())
        ],
        child: MaterialApp(
        theme: style.theme,
        initialRoute: '/',
        routes: {
          '/' : (c) => MyApp(),
          '/detail' : (c) => Text('부가페이지')
        },
  ),
      ));
}

var TextColor = TextStyle(
  color: Colors.black,
  fontSize: 26,
);



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();}
class _MyAppState extends State<MyApp> {


  int tab = 0;
  List<dynamic> data = [];
  var userImage;
  var userContent;

  saveData() async{
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'Park');
    storage.getString('name');
    // var map = {'age' : 20};
    // storage.setString('map', jsonEncode(map));
    // var resultt = storage.getString('map') ?? '없는대요';
    // jsonDecode(resultt['age']);
  }

  addMyData(){
    var myData = {
      'id': data.length,
      'image' : userImage,
      'likes' : 5,
      'date' : 'July 5',
      'content' : userContent,
      'liked' : false,
      'user' : 'John Kim'
    };
    setState(() {
      data.insert(0,myData);
    });
  }

  setUserContent(a){
    setState(() {
      userContent = a;
    });
  }

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
      var result2 = jsonDecode(result.body);
      setState(() {
        data = result2;
      });
  }

  addData(plus){
    setState(() {
      data.add(plus);
    });
  }

  @override
  void initState() {
    super.initState();
    initNotification(context);
    saveData();
    getData();
    context.read<Store1>().getData3();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Text('+'),
        onPressed: () {showNotification2();},),
      appBar: AppBar(
        title: Text('Instagram',style: TextColor,),
        actions: [
        Container(
         padding: EdgeInsets.only(right: 16),
          child: IconButton(onPressed: ()  async {
            var picker = ImagePicker();
            var image = await picker.pickImage(source: ImageSource.gallery);
            if(image != null){
              setState(() {
                userImage = File(image.path);
                print(userImage);
              });
            } else {
              setState(() {
              userImage = File('https://search.pstatic.net/sunny/?src=https%3A%2F%2Fcdn.ibos.kr%2Fdesign%2Fupload_file%2F__HTMLEDITOR__%2FLij1wcDbZ0%2Fb0991c31dea72e8d64f39a62eff91071_73007_11.png&type=sc960_832');
            }); }
            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => Upload(userImage : userImage, setUserContent : setUserContent, addMyData : addMyData))
            );
          },
              icon: Icon(Icons.add_box_outlined,size: 36,)),
        )
      ],),
      body: [
        // MediaQuery.of(context).size.width > 600 ? HomeWidth() : HomeLayout(data : data, addData : addData ), Shop()][tab],
        HomeLayout(data : data, addData : addData ), Shop()][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),label: '샵')
        ],
      ),
      );
  }
}

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key,this.data, this.addData }) : super(key: key);
  final data;
  final addData;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {

  var scroll = ScrollController();

  getData2() async{
    var plusResult = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var plusResult2 = jsonDecode(plusResult.body);
    widget.addData(plusResult2);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if(scroll.position.maxScrollExtent == scroll.position.pixels ){
        getData2();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
    return ListView.builder(itemCount: widget.data.length, controller: scroll, itemBuilder: (context, i) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                widget.data[i]['image'].runtimeType == String
                ? Image.network(widget.data[i]['image'])
                : Image.file(widget.data[i]['image']),
          Container(
            constraints: BoxConstraints(maxWidth: 700),
            padding: EdgeInsets.only(left: 24),
            width: double.infinity,
            height: 120,
            color: Colors.white12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(child:
                Text(widget.data[i]['user']),
                  onTap: (){
                  Navigator.push(context, 
                  PageRouteBuilder(
                    pageBuilder: (c,a1,a2) => Profile(),
                    transitionsBuilder: (c,a1,a2, child) => FadeTransition(opacity: a1, child: child,),
                    transitionDuration: Duration(microseconds: 700)
                  )
                  );

                  },
                ),
                Text('좋아요 ${widget.data[i]['likes']}'),
                Text(widget.data[i]['date']),
                Text(widget.data[i]['content']),
              ],
            ),
          )
        ],
      );
    });
  } else {
      return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: CircularProgressIndicator(),
              width: 80,
              height: 80,)
          ],
        )
      );
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData}) : super(key: key);
final userImage;
final setUserContent;
final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(userImage),
              TextField(onChanged: (text){
                setUserContent(text);
              },),
              Row(
                children: [
                  IconButton(onPressed: (){
                    // Navigator.pushNamed(context,'/detail');
                    Navigator.pop(context);
                  }, icon: Icon(Icons.close)),
                  IconButton(onPressed: (){
                    addMyData();
                    Navigator.pop(context);
                  }, icon: Icon(Icons.check))
                ],
              )

            ],
          ),
        ],
      )

    );
  }
}
class Store1 extends ChangeNotifier {
  var name = 'john Kim';
  var follower = 0;
  var followerCheck = false;

  var profileImage = [];

  getData3() async{
   var profile = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var profile2 = jsonDecode(profile.body);
    profileImage = profile2;
    notifyListeners();
  }

  plusFollower(){
    followerCheck == false
    ? follower++
    : follower--;
    followerCheck = !followerCheck;
    print(followerCheck);
    notifyListeners();
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store1>().name, style: TextStyle(color: Colors.black),),),
      body:
      CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(bottom: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('팔로워 ${context.watch<Store1>().follower}명'),
                    ElevatedButton(onPressed: (){
                      context.read<Store1>().plusFollower();
                    }, child: Text('팔로우')),
                  ],
                ),
              ),
            ),
            SliverGrid(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              delegate: SliverChildBuilderDelegate(
                  (c,i) => Row(
                    children: [
                      Image.network(context.watch<Store1>().profileImage[i])
                    ],
                  ),
                childCount: context.read<Store1>().profileImage.length
              ),),
          ],
        ),

    );
  }
}



