# Star Wars Explorer - README

## Descripción

Star Wars Explorer es una aplicación web desarrollada con Flutter que permite explorar personajes del universo de Star Wars. Utiliza la API pública SWAPI https://swapi.py4e.com/api (se utiliza el mirror link ya que la API original está caída) para obtener información detallada sobre los personajes y ofrece diversas funcionalidades como búsqueda, paginación, vista en lista o grilla, y un sistema de favoritos.

## Características principales

- 🔍 Búsqueda de personajes por nombre
- ⭐ Marcado de personajes como favoritos
- 📱 Diseño responsivo 
- 📋 Vista en lista o grilla de personajes

## Tecnologías utilizadas

- Flutter
- Bloc/Cubit (para gestión de estado)
- Dio (para peticiones HTTP)
- SharedPreferences (para almacenamiento local de favoritos)
- Mockito/Bloc Test (para pruebas unitarias)

## Requisitos previos

- Flutter SDK (versión ^3.5.4 o superior)
- Dart SDK (versión ^3.0.0 o superior)
- Un editor como Visual Studio Code o Android Studio
- Git

## Instalación y ejecución

### 1. Clonar el repositorio

```bash
git clone https://github.com/simonosudar/flutter-starwars-webapp.git
cd flutter-starwars-webapp
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Ejecutar la aplicación

Para ejecutar en modo debug:

```bash
flutter run -d web-server --web-port=7357
```

### 4. Ejecutar tests

```bash
flutter test
```

## Estructura del proyecto

```
lib/
├── blocs/             # BLoCs para gestión de estado
│   └── characters/    # BLoC específico para personajes
├── di/                # Inyección de dependencias
├── models/            # Modelos de datos
├── repositories/      # Repositorios para acceso a datos
├── screens/           # Pantallas de la aplicación
├── services/          # Servicios (API, etc.)
├── widgets/           # Widgets reutilizables
└── main.dart          # Punto de entrada de la aplicación

test/                  # Tests unitarios y de widgets
```