# App Plus Móvil - Sistema Integral de Control de Flota y Rendimiento

Aplicación multiplataforma (Android, iOS, Windows) desarrollada en **Flutter** para **Sistemas Koffy's**. Basada en los principios de diseño fluido y premium **Antigravity**.

## Características Principales

- **Arquitectura Modular**: Preparada para alta escalabilidad y despliegues con contenedores Docker.
- **Autenticación sin Texto Libre**: Selector visual/desplegable de usuarios con detección e indicación automática de roles y validación mediante PIN.
- **RBAC (Control de Acceso Basado en Roles)**: Vistas adaptativas e interfaces de seguridad para Super Administrador DB, Administrador, Contadora y Operadora.
- **Dashboard Directivo**: Métricas analíticas en tiempo real de llamadas (totales vs. canceladas) y ranking de los mejores choferes.
- **Workspace Operadora**: Panel de control interactivo con tarjetas dinámicas por chofer que reaccionan de forma elástica a cambios de estado (Asistencia, Falta, Recaudo).
- **Módulo Financiero**: Cierre de caja por turno y control de saldos deudores.
- **Perfil 360 de Flota**: Directorio centralizado con alertas visuales (badges) por vencimiento de SOAT, Licencia y datos de emergencia médica.
- **Generador de Credenciales**: Exportación en alta resolución optimizada para compartir en redes sociales.

## Estructura del Proyecto

```
lib/
├── main.dart
├── core/
│   ├── theme/app_theme.dart
│   └── widgets/ ...
├── data/
│   ├── models/ ...
│   └── providers/dummy_data_provider.dart
└── modules/
    ├── auth/ ...
    ├── dashboard/ ...
    ├── finance/ ...
    ├── fleet/ ...
    ├── home/ ...
    └── operator/ ...
```

## Ejecución Local

Para probar localmente en Windows, Web, o Emulador Móvil:

```bash
flutter pub get
flutter run
```

## Despliegue con Docker (Producción)

El proyecto incluye un `Dockerfile` optimizado en múltiples etapas (Multi-stage build) con Nginx para servir el cliente web compilado.

```bash
# Construir imagen Docker
docker build -t app-plus-movil .

# Ejecutar contenedor
docker run -d -p 8080:80 app-plus-movil
```
