import 'package:beni2_sqflit/db/db_helper.dart';
import 'package:flutter/material.dart';

import 'my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DbHelper.helper.getDbInstance();
  runApp(const MyApp());
}
