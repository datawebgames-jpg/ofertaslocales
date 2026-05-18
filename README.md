# OfertasLocales 🛍️

Plataforma para promocionar ofertas de comercios locales.

## Estructura del proyecto

```
ofertas-locales/
├── index.html              ← Página de inicio
├── comercio.html           ← Página de cada comercio
└── src/
    └── data/
        └── comercios.js    ← Datos de comercios y ofertas
```

## Cómo levantar en localhost:3000

```bash
# Opción 1: con npx (sin instalar nada)
npx serve . -p 3000

# Opción 2: con Python
python3 -m http.server 3000

# Opción 3: con Node http-server
npm install -g http-server
http-server -p 3000
```

Luego abrí: http://localhost:3000

## Cómo agregar un comercio

En `src/data/comercios.js`, agregá un objeto al array `comercios`:

```js
{
  id: 6,                          // ID único
  nombre: "Mi Comercio",          // Nombre visible
  rubro: "Electrónica",           // Rubro / categoría
  color: "#3A86FF",               // Color del comercio (hex)
  inicial: "MC",                  // Iniciales para el círculo (o logo)
  descripcion: "Descripción...",  // Texto del header en la página del comercio
  ofertas: [
    {
      id: 1,
      titulo: "Nombre de la oferta",
      descripcion: "Detalle de la oferta",
      precio: 5000,               // Precio con descuento
      precioOriginal: 8000,       // Precio original
      imagen: null,               // URL de imagen o null
      destacada: true             // true = aparece en el carrusel
    }
  ]
}
```

## Logo propio para el círculo

Reemplazá la `inicial` por una imagen cambiando el HTML en `index.html`:

```html
<!-- En lugar de las iniciales, se muestra la imagen automáticamente
     si ponés la URL en un campo `logo` del comercio en comercios.js -->
```

O bien, modificá el renderizado en `index.html` para incluir `<img>` cuando exista una URL de logo.
