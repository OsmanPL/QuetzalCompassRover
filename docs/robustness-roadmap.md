# Roadmap de Robustez para QuetzalCompassRover

## Prioridad 1 - Seguridad y estabilidad
- **Autenticacion**: migrar todos los servicios al nuevo esquema de contrasenas con `bcrypt`, forzar HTTPS y tokens con expiracion corta mas refresh tokens.
- **Validacion y saneamiento**: centralizar validaciones (p. ej. `zod`/`yup`) para evitar input invalido en todos los endpoints.
- **Rate limiting**: anadir limites de peticiones por IP/usuario y proteccion contra ataques de fuerza bruta.
- **Gestion de errores**: normalizar respuestas y registrar trazas estructuradas (p. ej. `pino`) con IDs de correlacion.
- **Politica de contrasenas**: establecer requisitos (longitud, complejidad) y flujos de cambio/recuperacion seguros.

## Prioridad 2 - Experiencia de usuario y resiliencia
- **Modo offline**: cachear rutas/horarios recientes en la app y reintentar sincronizaciones.
- **Monitorizacion**: integrar metricas (Prometheus/Grafana) y logging centralizado.
- **Pruebas automatizadas**: unitarias (Jest) para servicios y componentes, pruebas E2E (Detox/Appium) para la app.
- **Gestion de estado en la app**: consolidar acceso a APIs, manejo de errores y reintentos desde un modulo central.
- **Internacionalizacion**: preparar textos y formatos para soportar multiples idiomas.

## Prioridad 3 - Escalabilidad y mantenimiento
- **CI/CD**: pipeline con lint, test, escaneo de seguridad (Dependabot, npm audit) y despliegues automatizados.
- **Infraestructura**: contenedores para cada microservicio, orquestacion (Docker Compose/Kubernetes) y secretos gestionados (Vault/SSM).
- **Base de datos**: script de migraciones versionadas y backups automaticos verificados.
- **Documentacion**: OpenAPI para servicios REST, diagramas de arquitectura y runbooks de incidentes.
- **Observabilidad de movilidad**: registrar metricas de puntualidad, ocupacion estimada y feedback de usuarios para analisis futuro.

## Proximos pasos sugeridos
1. Ejecutar `npm install` en cada servicio para actualizar dependencias (`bcryptjs` nuevo en UserService).
2. Desplegar los stored procedures actualizados en MySQL y validar en un entorno de staging.
3. Implementar validaciones compartidas (`middlewares/validation`) que reutilicen esquemas en la app movil.
4. Configurar pruebas de integracion para flujos criticos (registro, login, consulta de rutas y favoritos).
5. Definir un plan de monitoreo y alertas (errores 5xx, picos de latencia, geocodificacion fallida).
