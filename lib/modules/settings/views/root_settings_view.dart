import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fluid_container.dart';
import '../../../data/providers/dummy_data_provider.dart';
import '../../../data/models/driver_model.dart';


class RootSettingsView extends StatelessWidget {
  final DummyDataProvider dataProvider;

  const RootSettingsView({super.key, required this.dataProvider});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: dataProvider,
      builder: (context, _) {
        final incidents = dataProvider.incidents;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabecera Root Exclusiva
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.statusDanger.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.security_rounded, color: AppTheme.statusDanger),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Auditoría DB y Sistema",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Acceso Root exclusivo · Trazabilidad de logs de incidentes",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Controles del Sistema
              Text(
                "Métricas de Contenedor Docker",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              FluidContainer(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _SystemMetricRow(label: "Estado del Servicio", value: "Saludable (Running)", valueColor: AppTheme.statusActive),
                    const Divider(height: 24, color: Colors.white10),
                    const _SystemMetricRow(label: "Versión de Base de Datos", value: "v1.0.0-mock", valueColor: AppTheme.accentPrimary),
                    const Divider(height: 24, color: Colors.white10),
                    _SystemMetricRow(label: "Total Registros Usuarios", value: dataProvider.users.length.toString(), valueColor: Colors.white),
                    const Divider(height: 24, color: Colors.white10),
                    _SystemMetricRow(label: "Total Registros Flota", value: dataProvider.drivers.length.toString(), valueColor: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Log de Auditoría / Incidentes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Log de Auditoría de Incidentes",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text("${incidents.length} Eventos", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (incidents.isEmpty)
                const Center(child: Text("El registro de auditoría está vacío.", style: TextStyle(color: AppTheme.textSecondary)))
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: incidents.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final inc = incidents[index];
                    final driver = dataProvider.drivers.any((d) => d.id == inc.driverId) 
                        ? dataProvider.drivers.firstWhere((d) => d.id == inc.driverId) 
                        : null;

                    return FluidContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      showShadow: false,
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_rounded, color: AppTheme.statusWarning, size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      inc.type.toUpperCase(),
                                      style: const TextStyle(color: AppTheme.statusWarning, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "· ${driver?.mobileNumber ?? 'Móvil'} (${driver?.name ?? 'Desconocido'})",
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text("Fecha de evento: ${inc.date}", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                              ],
                            ),
                          ),
                          Text("ID: ${inc.id}", style: const TextStyle(color: Colors.white24, fontSize: 10, fontFamily: 'monospace')),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SystemMetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SystemMetricRow({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
        Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}


