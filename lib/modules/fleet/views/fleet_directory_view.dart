import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fluid_container.dart';
import '../../../data/providers/dummy_data_provider.dart';
import 'driver_profile_360_view.dart';

class FleetDirectoryView extends StatelessWidget {
  final DummyDataProvider dataProvider;

  const FleetDirectoryView({super.key, required this.dataProvider});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: dataProvider,
      builder: (context, _) {
        final drivers = dataProvider.drivers;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera del Directorio
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Directorio de Flota",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Perfiles 360, alertas de SOAT/Licencia y fichas médicas",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Lista de Choferes
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: drivers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final driver = drivers[index];

                  // Evaluar si SOAT o Licencia están por vencer o vencidos
                  final soatDate = DateTime.tryParse(driver.soatExpiry) ?? DateTime.now();
                  final licenseDate = DateTime.tryParse(driver.licenseExpiry) ?? DateTime.now();
                  final now = DateTime.now();

                  final soatExpired = soatDate.isBefore(now);
                  final licenseExpired = licenseDate.isBefore(now);

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DriverProfile360View(driver: driver),
                        ),
                      );
                    },
                    child: FluidContainer(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Avatar con borde del color de su estado
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: driver.status == 'activo'
                                    ? AppTheme.statusActive
                                    : driver.status == 'permiso'
                                        ? AppTheme.statusWarning
                                        : AppTheme.statusDanger,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(driver.avatarUrl),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Datos Básicos
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      driver.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.backgroundDark,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        driver.mobileNumber,
                                        style: const TextStyle(color: AppTheme.accentPrimary, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                // Alertas en badges miniatura
                                Row(
                                  children: [
                                    _MiniBadge(
                                      label: "SOAT",
                                      isDanger: soatExpired,
                                    ),
                                    const SizedBox(width: 6),
                                    _MiniBadge(
                                      label: "Licencia",
                                      isDanger: licenseExpired,
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentSecondary.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        driver.bloodType,
                                        style: const TextStyle(color: AppTheme.accentSecondary, fontSize: 9, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textSecondary, size: 16),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final bool isDanger;

  const _MiniBadge({required this.label, required this.isDanger});

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? AppTheme.statusDanger : AppTheme.statusActive;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}
