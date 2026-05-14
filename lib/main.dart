import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/dummy_data_provider.dart';
import 'modules/auth/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar el proveedor de datos central
  final dataProvider = DummyDataProvider();

  runApp(AppPlusMovil(dataProvider: dataProvider));
}

class AppPlusMovil extends StatelessWidget {
  final DummyDataProvider dataProvider;

  const AppPlusMovil({super.key, required this.dataProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App Plus Móvil · Sistemas Koffy's",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: LoginView(dataProvider: dataProvider),
    );
  }
}
