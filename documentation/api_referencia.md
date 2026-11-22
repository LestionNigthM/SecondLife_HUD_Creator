# Referencia de la API - HUD Creator

## Estructura General
- **Comunicación**: `llMessageLinked` en canal `-1002`
- **Interfaz**: Menús de diálogo con `llDialog` en canal `-1000`
- **Comandos**: Prefijo `/hud`

## Funciones Principales

### Texturas
- `applyTexture(uuid)` - Aplica textura
- `removeTexture()` - Quita textura
- `setRepeat(<u,v,0>)` - Ajusta repetición
- `setOffset(<u,v,0>)` - Ajusta offset
- `setRotation(degrees)` - Ajusta rotación

### PBR
- `setMetalness(0.0-1.0)` - Metalness
- `setRoughness(0.0-1.0)` - Roughness
- `setEmissive(0.0-1.0)` - Emisivo
- `setNormalMap(uuid)` - Normal Map

### Sonidos
- `playSound(uuid, volume, loop)` - Reproduce
- `stopSound()` - Detiene
- `setVolume(0.0-1.0)` - Volumen

### Animaciones
- `startAnimation(uuid, speed, priority)` - Inicia
- `stopAnimation()` - Detiene
- `setSpeed(0.1-2.0)` - Velocidad

### Color
- `setColor(<r,g,b>, alpha, glow)` - Color
- `setAlpha(0.0-1.0)` - Transparencia
- `setGlow(0.0-1.0)` - Brillo
