import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat app',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String infoText = '';
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'メールアドレス'),
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'パスワード'),
                      obscureText: true,
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Text(infoText),
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: SelectableText("ユーザー登録"),
                        onPressed: () async {
                          try {
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            await auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                            await Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return ChatPage();
                            }));
                          } catch (e) {
                            setState(() {
                              infoText = "登録に失敗しました：${e.toString()}";
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                        width: double.infinity,
                        child: OutlinedButton(
                          child: Text('login'),
                          onPressed: () async {
                            try {
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              await auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                              await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ChatPage();
                                }),
                              );
                            } catch (e) {
                              setState(() {
                                infoText = 'fail login';
                              });
                            }
                          },
                        ))
                  ],
                ))));
  }
}

// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             child: Text('ログイン'),
//             onPressed: () async {
//               // チャット画面に遷移＋ログイン画面を破棄
//               await Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) {
//                   return ChatPage();
//                 }),
//               );
//             },
//           )
//         ],
//       ),
//     ));
//   }
// }

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('chat'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () async {
            await Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));
          },
        )
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddPostPage();
          }));
        },
      ),
    );
  }
}

class AddPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('チャット投稿'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('戻る'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ));
  }
}
