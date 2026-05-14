import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fluid_container.dart';
import '../../../core/widgets/elastic_button.dart';
import '../../../data/models/driver_model.dart';
import '../../../data/providers/dummy_data_provider.dart';

class OperatorPanelView extends StatelessWidget {
  final DummyDataProvider dataProvider;

  const OperatorPanelView({super.key, required this.dataProvider});

  void _showTransactionDialog(BuildContext context, DriverModel driver) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();
    String txType = 'pago'; // 'pago' o 'multa'

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppTheme.surfaceDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text("Caja / Multas · ${driver.mobileNumber}", style: const TextStyle(color: AppTheme.textPrimary)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Chofer: ${driver.name}", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                    const SizedBox(height: 16),
                    
                    // Selector de tipo (Pago o Multa)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setStateDialog(() => txType = 'pago'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: txType == 'pago' ? AppTheme.statusActive.withOpacity(0.2) : AppTheme.backgroundDark,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: txType == 'pago' ? AppTheme.statusActive : Colors.transparent),
                              ),
                              alignment: Alignment.center,
                              child: const Text("Ingreso a Caja", style: TextStyle(color: AppTheme.statusActive, fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setStateDialog(() => txType = 'multa'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: txType == 'multa' ? AppTheme.statusDanger.withOpacity(0.2) : AppTheme.backgroundDark,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: txType == 'multa' ? AppTheme.statusDanger : Colors.transparent),
                              ),
                              alignment: Alignment.center,
                              child: const Text("Aplicar Multa", style: TextStyle(color: AppTheme.statusDanger, fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Monto
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: "Monto (\$)",
                        hintText: "Ej: 50.00",
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Motivo
                    TextField(
                      controller: reasonController,
                      decoration: InputDecoration(
                        labelText: "Motivo / Detalle",
                        hintText: txType == 'pago' ? "Abono de turno" : "Auto sucio / Rechazo",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar", style: TextStyle(color: AppTheme.textSecondary)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: txType == 'pago' ? AppTheme.statusActive : AppTheme.statusDanger,
                  ),
                  onPressed: () {
                    final amount = double.tryParse(amountController.text) ?? 0.0;
                    if (amount > 0) {
                      dataProvider.addTransaction(
                        driverId: driver.id,
                        amount: amount,
                        reason: reasonController.text.isNotEmpty ? reasonController.text : (txType == 'pago' ? 'Ingreso a caja' : 'Multa operativa'),
                        type: txType,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(txType == 'pago' ? 'Dinero ingresado a caja correctamente.' : 'Multa registrada con éxito.'),
                          backgroundColor: txType == 'pago' ? AppTheme.statusActive : AppTheme.statusDanger,
                        ),
                      );
                    }
                  },
                  child: const Text("CONFIRMAR"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: dataProvider,
      builder: (context, _) {
        final drivers = dataProvider.drivers;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera de Turno Operativo
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Workspace Operativo",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentSecondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text("Turno Actual", style: TextStyle(color: AppTheme.accentSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Operador en línea · Control interactivo de flota",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Cuadrícula/Lista de Tarjetas de Choferes
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 210, // altura fija optimizada para botones de acción
                ),
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  final driver = drivers[index];

                  // Determinar color de la tarjeta según el estado
                  Color statusColor = AppTheme.statusActive;
                  Color cardBackground = AppTheme.surfaceDark;
                  String statusLabel = "Asistencia";

                  if (driver.status == 'permiso') {
                    statusColor = AppTheme.statusWarning;
                    cardBackground = AppTheme.statusWarning.withOpacity(0.08);
                    statusLabel = "Permiso";
                  } else if (driver.status == 'falta') {
                    statusColor = AppTheme.statusDanger;
                    cardBackground = AppTheme.statusDanger.withOpacity(0.08);
                    statusLabel = "Falta";
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
                      boxShadow: AppTheme.fluidShadows,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Info Superior
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(driver.avatarUrl),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        driver.mobileNumber,
                                        style: const TextStyle(color: AppTheme.accentPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      const Spacer(),
                                      // Estado etiqueta
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          statusLabel,
                                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    driver.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Deuda Actual
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Saldo deudor:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            Text(
                              "\$${driver.currentDebt.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: driver.currentDebt > 0 ? AppTheme.statusDanger : AppTheme.statusActive,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // Botones de acción rápida con respuesta elástica
                        Row(
                          children: [
                            // Botón Asistencia
                            Expanded(
                              child: ElasticButton(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                backgroundColor: driver.status == 'activo' ? AppTheme.statusActive : AppTheme.backgroundDark,
                                border: Border.all(color: AppTheme.statusActive.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => dataProvider.updateDriverStatus(driver.id, 'activo'),
                                child: Text(
                                  "Asist.",
                                  style: TextStyle(
                                    color: driver.status == 'activo' ? Colors.white : AppTheme.statusActive,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Botón Permiso
                            Expanded(
                              child: ElasticButton(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                backgroundColor: driver.status == 'permiso' ? AppTheme.statusWarning : AppTheme.backgroundDark,
                                border: Border.all(color: AppTheme.statusWarning.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => dataProvider.updateDriverStatus(driver.id, 'permiso'),
                                child: Text(
                                  "Perm.",
                                  style: TextStyle(
                                    color: driver.status == 'permiso' ? Colors.white : AppTheme.statusWarning,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Botón Falta
                            Expanded(
                              child: ElasticButton(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                backgroundColor: driver.status == 'falta' ? AppTheme.statusDanger : AppTheme.backgroundDark,
                                border: Border.all(color: AppTheme.statusDanger.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => dataProvider.updateDriverStatus(driver.id, 'falta'),
                                child: Text(
                                  "Falta",
                                  style: TextStyle(
                                    color: driver.status == 'falta' ? Colors.white : AppTheme.statusDanger,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Botón Caja / Recaudo
                            ElasticButton(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              backgroundColor: AppTheme.accentPrimary,
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => _showTransactionDialog(context, driver),
                              child: const Icon(Icons.point_of_sale_rounded, color: AppTheme.backgroundDark, size: 16),
                            ),
                          ],
                        ),
                      ],
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
