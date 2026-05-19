# Guía de Proyecto — OfertasLocales

## Qué es este proyecto
Plataforma web para que comercios locales publiquen sus ofertas y los clientes las vean. El modelo de negocio es que nosotros subimos las ofertas por los comercios (no lo hacen ellos solos).

Actualmente hay **5 comercios suscriptos** (los datos son placeholder, se van reemplazando con info real).

**Repositorio GitHub:** https://github.com/datawebgames-jpg/ofertaslocales  
**Sitio online:** https://datawebgames-jpg.github.io/ofertaslocales/  
**Admin online:** https://datawebgames-jpg.github.io/ofertaslocales/admin/  
**Localhost:** `npx serve . --listen 3000` desde la raíz del proyecto

---

## Stack tecnológico
- HTML + CSS + JavaScript puro (sin frameworks, sin build tools)
- ES Modules nativos (`type="module"`) para compartir datos entre páginas
- localStorage para persistir cambios del admin en el navegador
- GitHub REST API para publicar cambios directamente desde el admin
- Canvas API para redimensionar imágenes antes de guardarlas

---

## Estructura de archivos

```
/
├── index.html                  → Página principal (listado de todos los comercios)
├── src/
│   ├── styles.css              → CSS compartido por TODAS las páginas
│   ├── layout.js               → Funciones compartidas (buildNav, pct, fmt, RUBROS_ICONO)
│   ├── store.js                → Gestión de datos (localStorage + exportAsJS)
│   └── data/
│       └── comercios.js        → FUENTE DE DATOS CENTRAL (ES module con export)
├── comercios/
│   ├── comercio-1/index.html   → Ropa y Moda      | color #E63946
│   ├── comercio-2/index.html   → Gastronomía      | color #F4A261
│   ├── comercio-3/index.html   → Tecnología       | color #2A9D8F
│   ├── comercio-4/index.html   → Hogar            | color #8338EC
│   └── comercio-5/index.html   → Salud & Belleza  | color #FF006E
├── admin/
│   └── index.html              → Panel de administración completo
└── _referencia/
    └── guia-proyecto.md        → Este archivo
```

---

## Panel Admin (admin/index.html)

### Funcionalidades implementadas
- **Tabs por comercio** con logo/inicial y nombre
- **Tarjeta 1 — Logo del comercio**: preview 110×110px clickeable, subir JPG/PNG/WebP, redimensiona a 300×300 JPEG 92% automáticamente
- **Tarjeta 2 — Imagen de producto**: preview con borde punteado, subir imagen, redimensiona a 800×600 JPEG 85%, botón "Continuar →" abre modal de oferta con imagen pre-cargada
- **Lista de ofertas** por comercio: thumbnail, título, descripción, precios, % OFF, botones editar/eliminar
- **Modal de oferta**: imagen, título, descripción/características, precio oferta, precio original (calcula % en tiempo real), checkbox destacada
- **Auto-guardado en GitHub**: cada vez que se sube logo, se crea/edita/elimina una oferta → publica automáticamente en GitHub
- **Indicador de estado** en la barra superior: ⏳ Guardando / ✅ Guardado / ❌ Error
- **Banner amarillo** si GitHub no está configurado con botón directo a configuración
- **Modal configuración GitHub**: repo (usuario/repo), rama, Personal Access Token

### Flujo para guardar cambios online
1. Entrar al admin → si hay banner amarillo, clic en "⚙️ Configurar GitHub"
2. Poner:
   - Repositorio: `datawebgames-jpg/ofertaslocales`
   - Rama: `main`
   - Token: Personal Access Token de GitHub (Settings → Developer settings → Fine-grained tokens → Contents: Read & Write)
3. Guardar → desde ese momento cada cambio se publica automáticamente

### Bug crítico corregido (ES modules scope)
El módulo JS usaba `window.renderLista`, `window.openOferta`, etc. como assignments,
pero los llamaba como nombres desnudos desde otras funciones del mismo módulo.
**Fix:** convertirlos a function declarations (hoisting) y exponer a window aparte.

---

## Flujo de datos

```
src/data/comercios.js  ←─── datos base (código)
        ↓
   store.js (getAll)   ←─── localStorage si hay cambios del admin
        ↓
  index.html           → muestra grilla de comercios
  comercios/N/index.html → muestra ofertas del comercio
  admin/index.html     → lee y escribe datos
        ↓
  "Publicar en GitHub" → PUT API → src/data/comercios.js en el repo
        ↓
  GitHub Pages         → sirve los archivos actualizados
```

---

## Estructura de datos (src/data/comercios.js)

```js
export const comercios = [
  {
    id: Number,
    nombre: String,
    rubro: String,          // 'Ropa y Moda' | 'Gastronomía' | 'Tecnología' | 'Hogar' | 'Salud & Belleza'
    color: String,          // hex para logo y acentos
    inicial: String,        // texto del logo placeholder
    logo: null | String,    // base64 JPEG de logo (300x300)
    descripcion: String,
    ofertas: [
      {
        id: Number,
        titulo: String,
        descripcion: String,
        precio: Number,          // precio con descuento
        precioOriginal: Number,  // precio sin descuento
        imagen: null | String,   // base64 JPEG del producto (800x600)
        destacada: Boolean
      }
    ]
  }
]
```

---

## Modal "Consultar / Comprar" (en cada página de comercio)

### Qué hace
Cada card de oferta tiene un botón verde WhatsApp. Al hacer clic:
1. Se abre un modal con header degradado (color del comercio) mostrando imagen del producto, nombre y precio
2. Burbuja de asistente 🤖 con mensaje personalizado
3. Formulario: nombre, teléfono WhatsApp, consulta opcional
4. Al enviar → abre WhatsApp al número del comercio con los datos formateados
5. Pantalla de éxito con animación y botón Cerrar

### Número de WhatsApp actual (test)
`+542954321305` → hardcodeado como `WHATSAPP_ADMIN = '542954321305'` en cada `comercios/comercio-N/index.html`

### Mensaje que llega al comercio
```
🛒 Nueva consulta — OfertasLocales
👤 Cliente: [nombre]
📱 Teléfono: [tel]
🏷️ Producto: [nombre oferta]
💰 Precio oferta: $3.500 (30% OFF)
🏪 Comercio: [nombre comercio]
💬 Consulta: [mensaje si escribió]
```

### CSS del modal
Todo en `src/styles.css` — clases: `.card-buy-btn`, `.consulta-overlay`, `.consulta-modal`, `.cm-header`, `.cm-thumb`, `.cm-prod`, `.cm-bot-row`, `.cm-bot-bubble`, `.cm-form`, `.cm-submit-btn`, `.cm-success`, `.cm-ok-circle`

---

## Páginas de comercio (comercios/comercio-N/index.html)

Todas idénticas salvo `const COMERCIO_ID = N`. Incluyen:
- Header amarillo igual al index
- Nav de categorías (modo navigate, vuelve al index)
- Banner del comercio con logo/color/nombre/descripción
- Sidebar desktop: filtros precio + descuento
- Mobile: chips de descuento
- Grilla de ofertas con botón WhatsApp en cada card
- Modal de consulta/compra
- Footer

---

## Próximos pasos pendientes

- [ ] Reemplazar nombres placeholder ("Comercio 1", etc.) con nombres reales desde el admin
- [ ] Cargar logos reales de cada comercio desde el admin
- [ ] Cargar ofertas reales con imágenes desde el admin
- [ ] Configurar número de WhatsApp real por comercio (actualmente hardcodeado)
- [ ] Configurar token de GitHub en el admin para auto-guardado
- [ ] Probar flujo completo online: admin → publicar → ver en sitio

---

## Cómo arrancar cada sesión

1. `cd "C:\ofertas locales"`
2. `npx serve . --listen 3000` (servidor local)
3. Abrir http://localhost:3000 (sitio) y http://localhost:3000/admin/ (admin)
4. Para subir cambios: `git add -A && git commit -m "mensaje" && git push`
