import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fluid_container.dart';
import '../../../data/providers/dummy_data_provider.dart';
import '../../../data/models/driver_model.dart';


class FinanceModuleView extends StatelessWidget {
  final DummyDataProvider dataProvider;

  const FinanceModuleView({super.key, required this.dataProvider});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: dataProvider,
      builder: (context, _) {
        final transactions = dataProvider.transactions;
        final driversWithDebt = dataProvider.drivers.where((d) => d.currentDebt > 0).toList();

        // Calcular total recaudado (ingresos aprobados en caja)
        double totalCollected = 0.0;
        double totalPending = 0.0;
        for (var tx in transactions) {
          if (tx.type == 'pago') {
            if (tx.status == 'aprobado') {
              totalCollected += tx.amount;
            } else {
              totalPending += tx.amount;
            }
          }
        }

        final isAccountant = dataProvider.currentUser?.roleLabel == 'Contadora' || dataProvider.currentUser?.roleLabel == 'Super Administrador DB';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabecera Financiera
              Text(
                "Módulo Financiero y Caja",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                "Arqueo de caja por turno y control general de saldos deudores",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Tarjetas de Resumen de Arqueo
              Row(
                children: [
                  Expanded(
                    child: FluidContainer(
                      padding: const EdgeInsets.all(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D9488), Color(0xFF10B981)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text("Recaudado en Turno", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "\$${totalCollected.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          const Text("Efectivo validado en caja", style: TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FluidContainer(
                      padding: const EdgeInsets.all(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.pending_actions_rounded, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text("Liquidaciones Pendientes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "\$${totalPending.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          const Text("Requiere aprobación contable", style: TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Lista de Transacciones y Aprobación
              Text(
                "Movimientos del Turno",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              if (transactions.isEmpty)
                const Center(child: Text("No hay transacciones registradas en este turno.", style: TextStyle(color: AppTheme.textSecondary)))
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final driver = dataProvider.drivers.firstWhere((d) => d.id == tx.driverId, orElse: () => DriverModel(id: '', mobileNumber: 'Móvil', name: 'Desconocido', bloodType: '', licenseExpiry: '', soatExpiry: '', currentDebt: 0, avatarUrl: ''));

                    final isPending = tx.status == 'pendiente';

                    return FluidContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      showShadow: false,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: tx.type == 'pago' ? AppTheme.statusActive.withOpacity(0.1) : AppTheme.statusDanger.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              tx.type == 'pago' ? Icons.arrow_downward_rounded : Icons.warning_amber_rounded,
                              color: tx.type == 'pago' ? AppTheme.statusActive : AppTheme.statusDanger,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${driver.mobileNumber} · ${driver.name}",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isPending ? AppTheme.statusWarning.withOpacity(0.2) : AppTheme.statusActive.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        tx.status.toUpperCase(),
                                        style: TextStyle(
                                          color: isPending ? AppTheme.statusWarning : AppTheme.statusActive,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(tx.reason, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${tx.amount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: tx.type == 'pago' ? AppTheme.statusActive : AppTheme.statusDanger,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (isPending && isAccountant) ...[
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () => dataProvider.approveTransaction(tx.id),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentPrimary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text("APROBAR", style: TextStyle(color: AppTheme.backgroundDark, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

              const SizedBox(height: 40),

              // Saldos Deudores de Choferes
              Text(
                "Saldos Deudores de Choferes",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              if (driversWithDebt.isEmpty)
                FluidContainer(
                  padding: const EdgeInsets.all(24),
                  child: const Center(
                    child: Text("¡Excelente! Ningún chofer registra saldos deudores pendientes.", style: TextStyle(color: AppTheme.statusActive, fontWeight: FontWeight.bold)),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: driversWithDebt.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final driver = driversWithDebt[index];

                    return FluidContainer(
                      padding: const EdgeInsets.all(16),
                      border: Border.all(color: AppTheme.statusDanger.withOpacity(0.3)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(driver.avatarUrl),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(driver.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    const SizedBox(width: 8),
                                    Text(driver.mobileNumber, style: const TextStyle(color: AppTheme.accentPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text("Deuda acumulada por multas o liquidaciones pendientes", style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${driver.currentDebt.toStringAsFixed(2)}",
                                style: const TextStyle(color: AppTheme.statusDanger, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              if (isAccountant) ...[
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () {
                                    // Simular pago de la deuda completa
                                    dataProvider.addTransaction(
                                      driverId: driver.id,
                                      amount: driver.currentDebt,
                                      reason: "Liquidación total de deuda contable",
                                      type: "pago",
                                    );
                                  },
                                  child: const Text(
                                    "Liquidar Deuda",
                                    style: TextStyle(color: AppTheme.accentPrimary, fontSize: 11, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ],
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
