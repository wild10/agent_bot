### ¿Cómo ejecutarlo?
Como ya tienes Flutter instalado en Ubuntu, solo necesitas:

1. Abrir una terminal en la carpeta `chatapp`.
2. Ejecutar: `flutter pub get` (para bajar las librerías).
3. Ejecutar: `flutter run -d linux` (para probarlo en tu escritorio Linux) o `flutter run` si tienes un emulador/celular conectado.

### Docker (Versión Web)
Para ejecutar la aplicación en un contenedor Docker (usando Nginx):

1. **Construir la imagen:**
   ```bash
   docker build -t chatapp .
   ```

2. **Correr el contenedor:**
   ```bash
   docker run -p 8080:80 chatapp
   ```

3. **Abrir en el navegador:**
   Visita `http://localhost:8080`