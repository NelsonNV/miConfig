# 🐳 Docker Android + Ionic Capacitor

Contenedor base para proyectos **Ionic/Capacitor** con soporte para:

- 🧠 **Node.js 20** (via `nvm`)
- ☕ **JDK 21**
- 📱 **Android SDK**
- ⚒️ `@ionic/cli`, `gradle`, y herramientas necesarias

---

## 🚀 ¿Cómo ejecutarlo?

1. **Construir la imagen:**

```bash
docker build -t capacitor-android .
````

2. **Correr un contenedor interactivo:**

```bash
docker run -it --rm \
  -v $PWD:/app \
  capacitor-android
```

> 🔁 Usa `--rm` para borrar el contenedor al salir, y `-v` para montar tu proyecto local en `/app`.

---

## 🛠️ ¿Cómo generar el build de Android?

1. Entra al contenedor (si no estás ya adentro):

```bash
docker exec -it <container_name> bash
```

O si lo corriste con `--rm`, ya estás dentro.

2. Ejecuta el build de tu frontend:

```bash
npm install
npm run build
```

3. Sincroniza con Capacitor:

```bash
npx cap sync android
```

---

## 🏗️ ¿Cómo generar el APK?

### Debug (para pruebas rápidas)

```bash
cd android
./gradlew assembleDebug
```

Te deja el APK en:

```
android/app/build/outputs/apk/debug/app-debug.apk
```

---

### Release (APK para producción)

```bash
cd android
./gradlew assembleRelease
```

Resultado:

```
android/app/build/outputs/apk/release/app-release-unsigned.apk
```

> ⚠️ Este APK necesita ser **firmado** antes de subirlo a Google Play.

---

## 🔐 Firmar el APK (opcional)

Si tienes un `.jks`:

```bash
apksigner sign \
  --ks my-release-key.jks \
  --out app-release.apk \
  android/app/build/outputs/apk/release/app-release-unsigned.apk
```

---

## 📦 Versiones incluidas

* **JDK:** 21
* **Node.js:** 20
* **Gradle:** latest (via apt)
* **Android SDK:** Platform 33, Build-tools 33.0.2
* **Ionic CLI:** latest global

---

## 📁 Estructura esperada

Tu proyecto debe tener esta estructura:

```
/app
 ├─ capacitor.config.ts
 ├─ package.json
 ├─ dist/ (tras build)
 ├─ android/
```

---

> ✅ Ideal para pipelines de CI/CD, builds reproducibles o entornos aislados para desarrollo móvil.

