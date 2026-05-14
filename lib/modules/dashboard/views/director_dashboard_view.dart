import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fluid_container.dart';
import '../../../data/providers/dummy_data_provider.dart';

class DirectorDashboardView extends StatelessWidget {
  final DummyDataProvider dataProvider;

  const DirectorDashboardView({super.key, required this.dataProvider});

  @override
  Widget build(BuildContext context) {
    // Calcular totales de llamadas a partir de los turnos simulados
    int totalCalls = 0;
    int canceledCalls = 0;
    for (var shift in dataProvider.shifts) {
      totalCalls += shift.totalCalls;
      canceledCalls += shift.canceledCalls;
    }
    int successfulCalls = totalCalls - canceledCalls;

    // Obtener los mejores choferes ordenados por menor deuda o un ranking simulado
    final sortedDrivers = List.of(dataProvider.drivers);
    // Ordenamos simulando el ranking (ej. menor deuda y mayor cumplimiento)
    sortedDrivers.sort((a, b) => a.currentDebt.compareTo(b.currentDebt));

    return ListenableBuilder(
      listenable: dataProvider,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sección de bienvenida analítica
              Text(
                "Rendimiento Operativo",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                "Estadísticas consolidadas de turnos y flota en tiempo real",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Gráfico responsivo personalizado de llamadas (Custom Visual Bars)
              FluidContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Llamadas Totales vs Canceladas",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.accentPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Mensual",
                            style: TextStyle(color: AppTheme.accentPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Indicadores numéricos superiores
                    Row(
                      children: [
                        Expanded(
                          child: _MetricIndicator(
                            title: "Llamadas Totales",
                            value: totalCalls.toString(),
                            color: AppTheme.accentPrimary,
                          ),
                        ),
                        Expanded(
                          child: _MetricIndicator(
                            title: "Atendidas",
                            value: successfulCalls.toString(),
                            color: AppTheme.statusActive,
                          ),
                        ),
                        Expanded(
                          child: _MetricIndicator(
                            title: "Canceladas",
                            value: canceledCalls.toString(),
                            color: AppTheme.statusDanger,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Barra visual comparativa
                    if (totalCalls > 0)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final successRatio = successfulCalls / totalCalls;
                          final canceledRatio = canceledCalls / totalCalls;
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 20,
                                  width: constraints.maxWidth,
                                  color: AppTheme.surfaceDark,
                                  child: Row(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 500),
                                        width: constraints.maxWidth * successRatio,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [AppTheme.accentPrimary, AppTheme.statusActive],
                                          ),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 500),
                                        width: constraints.maxWidth * canceledRatio,
                                        color: AppTheme.statusDanger,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${(successRatio * 100).toStringAsFixed(1)}% Éxito", style: const TextStyle(color: AppTheme.statusActive, fontWeight: FontWeight.bold, fontSize: 12)),
                                  Text("${(canceledRatio * 100).toStringAsFixed(1)}% Canceladas", style: const TextStyle(color: AppTheme.statusDanger, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Ranking Mensual de los Mejores Choferes
              Text(
                "Ranking Mensual de Choferes",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedDrivers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final driver = sortedDrivers[index];
                  // Asignar medallas para el top 3
                  Color badgeColor = AppTheme.cardDark;
                  IconData badgeIcon = Icons.military_tech_rounded;
                  if (index == 0) {
                    badgeColor = const Color(0xFFF59E0B); // Oro
                    badgeIcon = Icons.emoji_events_rounded;
                  } else if (index == 1) {
                    badgeColor = const Color(0xFF94A3B8); // Plata
                  } else if (index == 2) {
                    badgeColor = const Color(0xFFB45309); // Bronce
                  }

                  return FluidContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    showShadow: false,
                    child: Row(
                      children: [
                        // Rango / Posición
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: badgeColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: badgeColor, width: 1.5),
                          ),
                          child: Center(
                            child: index < 3
                                ? Icon(badgeIcon, color: badgeColor, size: 20)
                                : Text("#${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Avatar
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.surfaceDark,
                          backgroundImage: NetworkImage(driver.avatarUrl),
                        ),
                        const SizedBox(width: 16),

                        // Datos del Chofer
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
                                      style: const TextStyle(color: AppTheme.accentPrimary, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Cumplimiento impecable · Deuda: \$${driver.currentDebt.toStringAsFixed(2)}",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        // Estado Operativo Actual
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: driver.status == 'activo'
                                ? AppTheme.statusActive
                                : driver.status == 'permiso'
                                    ? AppTheme.statusWarning
                                    : AppTheme.statusDanger,
                          ),
                        ),
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

class _MetricIndicator extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MetricIndicator({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
