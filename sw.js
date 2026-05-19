const CACHE = 'ol-v1';

const STATIC = [
  'index.html',
  'manifest.json',
  'src/styles.css',
  'src/store.js',
  'src/layout.js',
  'src/data/comercios.js',
  'comercios/comercio-1/index.html',
  'comercios/comercio-2/index.html',
  'comercios/comercio-3/index.html',
  'comercios/comercio-4/index.html',
  'comercios/comercio-5/index.html',
  'icons/icon.svg',
  'icons/icon-maskable.svg',
];

/* ── INSTALL: pre-cache archivos estáticos ── */
self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE).then(c => c.addAll(STATIC)).then(() => self.skipWaiting())
  );
});

/* ── ACTIVATE: borrar cachés viejos ── */
self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

/* ── FETCH ── */
self.addEventListener('fetch', e => {
  const req = e.request;
  const url = new URL(req.url);

  // Solo GET, solo http/https
  if (req.method !== 'GET' || !url.protocol.startsWith('http')) return;

  // Google Fonts → cache-first (evita cargar en offline)
  if (url.hostname === 'fonts.googleapis.com' || url.hostname === 'fonts.gstatic.com') {
    e.respondWith(fromCacheOrNetwork(req));
    return;
  }

  // Páginas HTML → network-first (datos siempre frescos)
  if (req.mode === 'navigate') {
    e.respondWith(
      fetch(req)
        .then(res => { putInCache(req, res.clone()); return res; })
        .catch(() => caches.match(req))
    );
    return;
  }

  // Todo lo demás → cache-first
  e.respondWith(fromCacheOrNetwork(req));
});

function fromCacheOrNetwork(req) {
  return caches.match(req).then(cached => {
    if (cached) return cached;
    return fetch(req).then(res => { putInCache(req, res.clone()); return res; });
  });
}

function putInCache(req, res) {
  if (res.ok) caches.open(CACHE).then(c => c.put(req, res));
}
