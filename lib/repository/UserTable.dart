import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/*@PrimaryKey
var tel: String? = null
@Column
var id: String? = null
@Column(defaultValue = "")
var token: String? = null
@Column
var isOnline: Boolean = false
@Column
var nickName: String? = null
@Column
var roleCode: String? = null
@Column
var avatar: String? = null
get() {
  return if (field?.isEmpty() != false) {
    "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3063611797,2186093747&fm=117&gp=0.jpg"
  } else {
    field
  }
}
set(value) {
  if (value?.isEmpty() != false) {
    return
  } else {
    field = value
  }
}
@Column
var gender: Int? = null
@Column
var address: String? = null
@Column(defaultValue = "0")
var relation: Int? = null
@Column
var ysTokenysToken: String? = null
@Column
var schoolName: String? = null
@Column
var qqOpenId: String? = null
@Column
var wxOpenId: String? = null
@Column
var qqNickName: String? = null
@Column
var wxNickName: String? = null*/
class a {
  Future abc() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo.db");

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
// When creating the db, create the table
      await db.execute('''
              CREATE TABLE k_user2 (
                        tel        VARCHAR PRIMARY KEY,
                        name       VARCHAR,
                        token      VARCHAR,
                        isOnline   VARCHAR,
                        nickName   VARCHAR,
                        roleCode   VARCHAR,
                        avatar     VARCHAR,
                        gender     VARCHAR,
                        address    VARCHAR,
                        relation   VARCHAR,
                        ysToken    VARCHAR,
                        schoolName VARCHAR,
                        qqOpenId   VARCHAR,
                        wxOpenId   VARCHAR,
                        qqNickName VARCHAR,
                        wxNickName VARCHAR
                      )
              ''');
    });
  }
}
