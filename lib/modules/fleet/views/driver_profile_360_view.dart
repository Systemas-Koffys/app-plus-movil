import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fluid_container.dart';
import '../../../data/models/driver_model.dart';

class DriverProfile360View extends StatelessWidget {
  final DriverModel driver;

  const DriverProfile360View({super.key, required this.driver});

  void _showCredentialExportPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.accentPrimary.withOpacity(0.5), width: 2),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Encabezado de la Credencial
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sistemas Koffy's",
                      style: TextStyle(color: AppTheme.accentPrimary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.accentPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("CREDENCIAL OFICIAL", style: TextStyle(color: AppTheme.backgroundDark, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Foto y Nombre
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(driver.avatarUrl),
                  ),
                ),
                const SizedBox(height: 16),
                Text(driver.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text(driver.mobileNumber.toUpperCase(), style: const TextStyle(color: AppTheme.accentPrimary, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 2)),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white10),
                ),

                // Datos Médicos de Emergencia
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CredentialMetadata(label: "GS / RH", value: driver.bloodType),
                    const _CredentialMetadata(label: "ALERGIAS", value: "Ninguna Conocida"),
                    const _CredentialMetadata(label: "EMERGENCIAS", value: "Apto Flota"),
                  ],
                ),

                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_rounded, color: AppTheme.statusActive, size: 16),
                      SizedBox(width: 8),
                      Text("Verificado · App Plus Móvil", style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                // Botón Simulado de Guardar/Compartir en RRSS
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.statusActive,
                    ),
                    icon: const Icon(Icons.share_rounded, color: Colors.white, size: 18),
                    label: const Text("COMPARTIR EN REDES SOCIALES", style: TextStyle(color: Colors.white, fontSize: 12)),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Credencial exportada en alta resolución lista para compartir."),
                          backgroundColor: AppTheme.statusActive,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final soatDate = DateTime.tryParse(driver.soatExpiry) ?? DateTime.now();
    final licenseDate = DateTime.tryParse(driver.licenseExpiry) ?? DateTime.now();
    final now = DateTime.now();

    final soatExpired = soatDate.isBefore(now);
    final licenseExpired = licenseDate.isBefore(now);

    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil 360 · ${driver.mobileNumber}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de Identificación Principal
            FluidContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: AppTheme.backgroundDark,
                        backgroundImage: NetworkImage(driver.avatarUrl),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: driver.status == 'activo'
                              ? AppTheme.statusActive
                              : driver.status == 'permiso'
                                  ? AppTheme.statusWarning
                                  : AppTheme.statusDanger,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.surfaceDark, width: 3),
                        ),
                        child: Icon(
                          driver.status == 'activo'
                              ? Icons.check_rounded
                              : driver.status == 'permiso'
                                  ? Icons.access_time_rounded
                                  : Icons.close_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    driver.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Identificador Asignado: ${driver.mobileNumber}",
                    style: const TextStyle(color: AppTheme.accentPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),

                  // Botón Generador de Credenciales
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.badge_rounded),
                      label: const Text("GENERAR CREDENCIAL SOCIAL"),
                      onPressed: () => _showCredentialExportPreview(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sistema de Alertas (Badges) de Documentación
            Text(
              "Estado de Documentación",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            _AlertBadgeRow(
              title: "Seguro SOAT",
              expiryDate: driver.soatExpiry,
              isExpired: soatExpired,
              icon: Icons.shield_rounded,
            ),
            const SizedBox(height: 12),
            _AlertBadgeRow(
              title: "Licencia de Conducir",
              expiryDate: driver.licenseExpiry,
              isExpired: licenseExpired,
              icon: Icons.card_membership_rounded,
            ),
            const SizedBox(height: 24),

            // Ficha Médica de Emergencias
            Text(
              "Ficha Médica de Emergencias",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            FluidContainer(
              padding: const EdgeInsets.all(20),
              border: Border.all(color: AppTheme.accentSecondary.withOpacity(0.3)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.accentSecondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.medical_information_rounded, color: AppTheme.accentSecondary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Grupo Sanguíneo y Factor RH", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            const SizedBox(height: 2),
                            Text(driver.bloodType, style: const TextStyle(color: AppTheme.accentSecondary, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Colors.white10),
                  ),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, color: AppTheme.statusWarning, size: 18),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Alergias y Contraindicaciones", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            SizedBox(height: 2),
                            Text("Sin registro de alergias graves a medicamentos. Portar siempre credencial visible.", style: TextStyle(color: AppTheme.textPrimary, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertBadgeRow extends StatelessWidget {
  final String title;
  final String expiryDate;
  final bool isExpired;
  final IconData icon;

  const _AlertBadgeRow({
    required this.title,
    required this.expiryDate,
    required this.isExpired,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = isExpired ? AppTheme.statusDanger : AppTheme.statusActive;
    final statusText = isExpired ? "VENCIDO" : "VIGENTE";

    return FluidContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      showShadow: false,
      border: Border.all(color: color.withOpacity(0.3)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text("Vencimiento: $expiryDate", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusText,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _CredentialMetadata extends StatelessWidget {
  final String label;
  final String value;

  const _CredentialMetadata({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
