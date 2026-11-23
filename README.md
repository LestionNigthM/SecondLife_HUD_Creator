# Second Life HUD Creator

Un sistema para crear HUDs personalizados en Second Life con soporte para texturas, materiales PBR, sonidos, animaciones, colores y modos alpha.

## Estado (v1.1, 23 nov 2026)

El núcleo funciona: se corrigieron los 7 scripts principales, el sistema de ropa y la documentación. Los extras (tienda, cupones, pagos, inventario, base de datos, web) siguen siendo experimentales y se prueban uno por uno, solo si se necesitan.

**Corregido en v1.1:**
- `hud_main.lsl`: los botones del menú ya hacen algo (antes no funcionaba ninguno) y "Salir" ya no destruye el HUD.
- `pbr_material.lsl`: ya compila, con `PRIM_GLTF_*` en vez de la función inexistente `llSetMaterialParam`. Incluye modo alpha.
- `animation_controller.lsl`: ya pide el permiso `PERMISSION_TRIGGER_ANIMATION` y detiene la animación correcta.
- `color_controller.lsl`: `llSetGlow` ya lleva la cara (antes no compilaba).
- `config.lsl`: ya es LSL válido (antes era texto Markdown) y ahora sí manda los valores a los demás scripts.
- `hud_ropa_main.lsl` + `ropa_receiver.lsl`: ya no usan UUIDs falsos ni `llMessageLinked` entre objetos distintos; HUD y prenda hablan por el canal -12350 y la prenda se detecta sola.
- `web_sync.lsl` + `database_connector.lsl`: desactivados por defecto (apuntaban a un servidor que no existe). El botón "Ver tienda" abre https://lysstore.com.
- Documentación: el número de mensaje interno es **0** (no -1002) y los ejemplos ya funcionan.

## 📁 Estructura del Proyecto

```
SecondLife_HUD_Creator/
├── README.md
├── LICENSE
├── documentation/
│   ├── api_referencia.md
│   ├── ejemplos_uso.md
│   └── guia_usuario.md
└── scripts/
    ├── config.lsl
    ├── hud_main.lsl
    ├── texture_manager.lsl
    ├── pbr_material.lsl
    ├── sound_manager.lsl
    ├── animation_controller.lsl
    ├── color_controller.lsl
    ├── config_advanced.lsl
    ├── database_connector.lsl
    ├── web_sync.lsl
    ├── coupon_system.lsl
    ├── social_integration.lsl
    ├── review_system.lsl
    ├── payment_system_advanced.lsl
    ├── inventory_manager_advanced.lsl
    ├── lighting_controller.lsl
    ├── catalog_system_advanced.lsl
    ├── button_3d.lsl
    ├── category_button_pro.lsl
    ├── control_button_pro.lsl
    ├── ropa_receiver_pro.lsl
    ├── config_ropa.lsl
    ├── hud_ropa_main.lsl
    ├── button_ropa.lsl
    ├── category_button.lsl
    ├── control_button.lsl
    ├── mesh_texture_receiver.lsl
    └── ropa_receiver.lsl
```

## 🚀 Características

- Gestión de texturas para prims y mesh
- Materiales PBR completos (metalness, roughness, emisivo, modo alpha)
- Sistema de sonidos
- Control de animaciones (con permiso)
- Color, transparencia y brillo
- Sistema de ropa con detección automática de la prenda
- Botón "Ver tienda" (lysstore.com)
- E-commerce: cupones, pagos, inventario (experimental)
- Integración con base de datos y sincronización web (desactivadas por defecto)

## 📋 Requisitos

- Second Life Viewer
- Conocimientos básicos de SL

## 🛠️ Instalación

1. Crea un cubo en un sandbox y pruébalo primero en el suelo, no como HUD.
2. Copia **únicamente** los 7 scripts del núcleo (ver `documentation/guia_usuario.md`).
3. Configura tus valores en `config.lsl` y tus UUIDs de prueba en `hud_main.lsl`.
4. Cuando el núcleo funcione, adjunta el cubo como HUD.

## 📜 Licencia

MIT License
