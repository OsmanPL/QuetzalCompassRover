# Checklist despues de migrar a bcrypt

1. **Actualizar la base de datos**
   - Conectate mediante `mysql` al schema correspondiente.
   - Ejecuta el script `database/migrations/20240917_alter_usuario_password.sql` para modificar la tabla `Usuario` y recargar los procedimientos almacenados.

2. **Reiniciar los servicios de backend**
   - Reinicia el servicio `Backend/UserService` (por ejemplo: `npm run dev` o reinicio del contenedor).
   - Reinicia los otros servicios dependientes si consumen la tabla `Usuario`.

3. **Validar flujos criticos**
   - Registrar un usuario nuevo y confirmar que se almacena correctamente.
   - Iniciar sesion con un usuario existente y verificar que el login responde 200.
   - Actualizar los datos de un usuario (con y sin cambio de contrasena) para confirmar el procedimiento `updateUser`.

4. **Actualizar documentacion/migraciones**
   - Registrar la ejecucion de la migracion y guardar respaldos en caso de rollback.
   - Si usas pipelines, anadir el script a la rutina de despliegue.
