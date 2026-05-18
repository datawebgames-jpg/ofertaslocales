# Guia de Proyecto — OfertasLocales

## Que es este proyecto
Plataforma web para que comercios locales publiquen sus ofertas y los clientes las vean. El modelo de negocio es que nosotros subimos las ofertas por los comercios (no lo hacen ellos solos).

Actualmente hay **5 comercios suscriptos** (los datos son placeholder, se van reemplazando con info real).

---

## Stack tecnologico
- HTML + CSS + JavaScript puro (sin frameworks, sin build tools)
- ES Modules nativos (`type="module"`) para compartir datos entre paginas
- Servidor local: `npx serve . --listen 3000` desde la raiz del proyecto

---

## Estructura de archivos

```
/
├── index.html                  → Pagina principal (listado de todos los comercios)
├── comercio.html               → (archivo legacy, revisar si se usa)
├── comercios.js                → (archivo legacy en raiz, revisar si se usa)
├── src/
│   └── data/
│       └── comercios.js        → FUENTE DE DATOS CENTRAL (ES module con export)
├── comercios/
│   ├── comercio-1/index.html   → Ropa y Moda      | color #E63946
│   ├── comercio-2/index.html   → Gastronomia      | color #F4A261
│   ├── comercio-3/index.html   → Tecnologia       | color #2A9D8F
│   ├── comercio-4/index.html   → Hogar            | color #8338EC
│   └── comercio-5/index.html   → Salud & Belleza  | color #FF006E
└── _referencia/
    └── guia-proyecto.md        → Este archivo
```

---

## Como funciona cada pagina de comercio

Cada `comercios/comercio-N/index.html`:
1. Importa los datos desde `../../src/data/comercios.js`
2. Busca el comercio por `id` (hardcodeado como `COMERCIO_ID = N`)
3. Renderiza:
   - Logo grande (por ahora: color de fondo + inicial del comercio)
   - Badge con el rubro
   - Nombre y descripcion
   - Grilla de ofertas con precio actual, precio original tachado y % de descuento
   - Boton "← Volver" al index principal
4. Si el campo `imagen` de la oferta es `null`, muestra emoji 🏷️ como placeholder
5. Si no hay ofertas, muestra un estado "Proximamente"

---

## Datos de cada comercio (src/data/comercios.js)

Cada comercio tiene esta estructura:
```js
{
  id: Number,
  nombre: String,
  rubro: String,
  color: String,       // color hex para logo y acentos
  inicial: String,     // texto que se muestra en el logo placeholder
  descripcion: String,
  ofertas: [
    {
      id: Number,
      titulo: String,
      descripcion: String,
      precio: Number,          // precio con descuento
      precioOriginal: Number,  // precio sin descuento
      imagen: null | String,   // URL o path a la imagen
      destacada: Boolean       // muestra badge "Destacada"
    }
  ]
}
```

---

## Proximos pasos pendientes

- [ ] Reemplazar nombres placeholder ("Comercio 1", etc.) con nombres reales
- [ ] Reemplazar `inicial` por imagen real del logo de cada comercio
- [ ] Linkear tarjetas del index principal a cada pagina de comercio
- [ ] Cargar las ofertas reales (titulo, descripcion, precios, imagen)
- [ ] Subir el proyecto a GitHub
- [ ] Definir hosting (GitHub Pages es la opcion mas simple para este stack)

---

## Decisiones tomadas

- **Un HTML por comercio** en lugar de routing dinamico, para mantener la simplicidad del stack sin frameworks.
- **Datos centralizados** en `src/data/comercios.js` para que editar un solo archivo actualice tanto el index como la pagina del comercio.
- **Logos con color + inicial** como placeholder hasta tener los logos reales.
- **Nosotros cargamos las ofertas**, los comercios no tienen panel de administracion por ahora.
