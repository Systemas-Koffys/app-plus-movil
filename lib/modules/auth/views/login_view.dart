import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fluid_container.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/dummy_data_provider.dart';
import '../../home/views/main_navigation_view.dart';

class LoginView extends StatefulWidget {
  final DummyDataProvider dataProvider;

  const LoginView({super.key, required this.dataProvider});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserModel? _selectedUser;
  final TextEditingController _pinController = TextEditingController();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Preseleccionar el primer usuario disponible si existen
    if (widget.dataProvider.users.isNotEmpty) {
      _selectedUser = widget.dataProvider.users.first;
    } else {
      // Si la carga asíncrona no terminó, agregamos listener
      widget.dataProvider.addListener(_onDataLoaded);
    }
  }

  void _onDataLoaded() {
    if (widget.dataProvider.users.isNotEmpty && _selectedUser == null) {
      setState(() {
        _selectedUser = widget.dataProvider.users.first;
      });
      widget.dataProvider.removeListener(_onDataLoaded);
    }
  }

  @override
  void dispose() {
    widget.dataProvider.removeListener(_onDataLoaded);
    _pinController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_selectedUser == null) return;
    
    // Validar contraseña/PIN
    final success = widget.dataProvider.login(_selectedUser!, _pinController.text.trim());
    if (success) {
      setState(() {
        _hasError = false;
      });
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MainNavigationView(dataProvider: widget.dataProvider),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      setState(() {
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN incorrecto. Por favor, intente de nuevo. (Pista: use 1234)'),
          backgroundColor: AppTheme.statusDanger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = widget.dataProvider.users;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.backgroundDark, Color(0xFF0B0F19)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              child: FluidContainer(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Título / Identidad Corporativa Premium
                    const Center(
                      child: Text(
                        "Sistemas Koffy's",
                        style: TextStyle(
                          color: AppTheme.accentPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "App Plus Móvil",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          foreground: Paint()
                            ..shader = AppTheme.primaryGradient.createShader(
                              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        "Control de Flota y Rendimiento",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Selector de Usuario (Dropdown estilizado o tarjetas)
                    Text(
                      "Seleccione su perfil de usuario",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    
                    if (users.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<UserModel>(
                            value: _selectedUser,
                            isExpanded: true,
                            dropdownColor: AppTheme.surfaceDark,
                            icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.accentPrimary),
                            items: users.map((u) {
                              return DropdownMenuItem<UserModel>(
                                value: u,
                                child: Text(
                                  u.fullName,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              );
                            }).toList(),
                            onChanged: (UserModel? newUser) {
                              setState(() {
                                _selectedUser = newUser;
                                _hasError = false;
                              });
                            },
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 20),

                    // Visualización Automática de Rol
                    if (_selectedUser != null) ...[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutQuint,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.accentPrimary.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.admin_panel_settings, color: AppTheme.accentPrimary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rol Asignado",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _selectedUser!.roleLabel,
                                    style: const TextStyle(
                                      color: AppTheme.accentPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Contraseña / PIN
                    Text(
                      "PIN de Acceso",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _pinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 18, letterSpacing: 8, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "••••",
                        hintStyle: const TextStyle(letterSpacing: 8, fontSize: 18),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: _hasError ? AppTheme.statusDanger : AppTheme.accentPrimary,
                            width: 2,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _handleLogin(),
                    ),
                    
                    const SizedBox(height: 32),

                    // Botón Ingresar
                    ElevatedButton(
                      onPressed: _handleLogin,
                      child: const Text("INGRESAR", style: TextStyle(letterSpacing: 1.5)),
                    ),

                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        "PIN de prueba para todos: 1234",
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
