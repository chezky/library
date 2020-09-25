import 'package:flutter/material.dart';
import 'package:frontend/app.dart';
import 'package:global_configuration/global_configuration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromPath("assets/config.json");
  runApp(Library());
}
