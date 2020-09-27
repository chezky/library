import 'package:flutter/material.dart';
import 'package:frontend/app.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';

import 'models/listBooks.dart';
import 'models/scannedBooks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromPath("assets/config.json");

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScannedBooks()),
        ChangeNotifierProvider(create: (context) => ListBooks()),
      ],
      child: Library(),
    ),
  );
}
