import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/providers/dummy_data_provider.dart';
import '../../auth/views/login_view.dart';
import '../../dashboard/views/director_dashboard_view.dart';
import '../../operator/views/operator_panel_view.dart';
import '../../finance/views/finance_module_view.dart';
import '../../fleet/views/fleet_directory_view.dart';
import '../../settings/views/root_settings_view.dart';

class MainNavigationView extends StatefulWidget {
  final DummyDataProvider dataProvider;

  const MainNavigationView({super.key, required this.dataProvider});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 0;
  late List<_NavigationTab> _availableTabs;

  @override
  void initState() {
    super.initState();
    _setupTabs();
  }

  void _setupTabs() {
    final role = widget.dataProvider.currentUser?.roleLabel ?? '';
    _availableTabs = [];

    // Lógica RBAC para inyectar pestañas permitidas según rol
    if (role == 'Super Administrador DB') {
      // Root tiene acceso total a todos los módulos
      _availableTabs = [
        _NavigationTab(icon: Icons.dashboard_rounded, title: "Dashboard", view: DirectorDashboardView(dataProvider: widget.dataProvider)),
        _NavigationTab(icon: Icons.support_agent_rounded, title: "Operador", view: OperatorPanelView(dataProvider: widget.dataProvider)),
        _NavigationTab(icon: Icons.account_balance_wallet_rounded, title: "Finanzas", view: FinanceModuleView(dataProvider: widget.dataProvider)),
        _NavigationTab(icon: Icons.directions_car_rounded, title: "Flota 360", view: FleetDirectoryView(dataProvider: widget.dataProvider)),
        _NavigationTab(icon: Icons.admin_panel_settings_rounded, title: "Auditoría DB", view: RootSettingsView(dataProvider: widget.dataProvider)),
      ];
    } else if (role == 'Administrador') {
      // Directores
      _availableTabs = [
        _NavigationTab(icon: Icons.dashboard_rounded, title: "Dashboard", view: DirectorDashboardView(dataProvider: widget.dataProvider)),
        _NavigationTab(icon: Icons.directions_car_rounded, title: "Flota 360", view: FleetDirectoryView(dataProvider: widget.dataProvider)),
      ];
    } else if (role == 'Contadora') {
      // Finanzas exclusivo
      _availableTabs = [
        _NavigationTab(icon: Icons.account_balance_wallet_rounded, title: "Finanzas", view: FinanceModuleView(dataProvider: widget.dataProvider)),
        _NavigationTab(icon: Icons.directions_car_rounded, title: "Flota 360", view: FleetDirectoryView(dataProvider: widget.dataProvider)),
      ];
    } else {
      // Operadora
      _availableTabs = [
        _NavigationTab(icon: Icons.support_agent_rounded, title: "Operador", view: OperatorPanelView(dataProvider: widget.dataProvider)),
        _NavigationTab(icon: Icons.directions_car_rounded, title: "Flota 360", view: FleetDirectoryView(dataProvider: widget.dataProvider)),
      ];
    }
  }

  void _handleLogout() {
    widget.dataProvider.logout();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginView(dataProvider: widget.dataProvider),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.dataProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("App Plus Móvil", style: TextStyle(fontSize: 18)),
            Text(
              "${user?.fullName ?? ''} (${user?.roleLabel ?? ''})",
              style: const TextStyle(fontSize: 12, color: AppTheme.accentPrimary, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppTheme.statusDanger),
            tooltip: "Cerrar Sesión",
            onPressed: _handleLogout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _availableTabs[_currentIndex].view,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: AppTheme.accentPrimary.withOpacity(0.2),
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(color: AppTheme.accentPrimary, fontSize: 12, fontWeight: FontWeight.bold);
              }
              return const TextStyle(color: AppTheme.textSecondary, fontSize: 12);
            }),
            iconTheme: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const IconThemeData(color: AppTheme.accentPrimary);
              }
              return const IconThemeData(color: AppTheme.textSecondary);
            }),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            destinations: _availableTabs.map((tab) {
              return NavigationDestination(
                icon: Icon(tab.icon),
                label: tab.title,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavigationTab {
  final IconData icon;
  final String title;
  final Widget view;

  _NavigationTab({required this.icon, required this.title, required this.view});
}
