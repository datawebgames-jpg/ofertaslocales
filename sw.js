// SW desactivado — borra todos los caches y se elimina solo
// Esto fuerza que el browser sirva siempre los archivos frescos del servidor

self.addEventListener('install', () => self.skipWaiting());

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.map(k => caches.delete(k))))
      .then(() => self.clients.claim())
      .then(() => {
        // Notifica a todos los clientes que recarguen
        return self.clients.matchAll({ type: 'window' }).then(clients => {
          clients.forEach(client => client.navigate(client.url));
        });
      })
  );
});

// No interceptar ningún fetch — todo va directo a la red
