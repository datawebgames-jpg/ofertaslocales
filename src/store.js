/**
 * store.js — Gestión de datos con localStorage
 * Los datos base vienen de comercios.js.
 * El panel admin guarda cambios en localStorage.
 * Todas las páginas leen desde acá (localStorage > datos base).
 */

import { comercios as BASE } from './data/comercios.js';

const KEY = 'ol_data_v1';

/** Devuelve todos los comercios (localStorage si hay, si no los base) */
export function getAll() {
  try {
    const raw = localStorage.getItem(KEY);
    if (raw) return JSON.parse(raw);
  } catch (e) {}
  return JSON.parse(JSON.stringify(BASE)); // deep copy
}

/** Devuelve un comercio por id */
export function getComercio(id) {
  return getAll().find(c => c.id === id) || null;
}

/** Persiste todos los comercios */
export function saveAll(data) {
  localStorage.setItem(KEY, JSON.stringify(data));
}

/** Agrega una oferta a un comercio */
export function addOferta(comercioId, oferta) {
  const data = getAll();
  const c = data.find(x => x.id === comercioId);
  if (!c) return;
  const maxId = c.ofertas.length > 0 ? Math.max(...c.ofertas.map(o => o.id)) : 0;
  c.ofertas.push({ ...oferta, id: maxId + 1 });
  saveAll(data);
}

/** Reemplaza una oferta existente */
export function updateOferta(comercioId, ofertaId, oferta) {
  const data = getAll();
  const c = data.find(x => x.id === comercioId);
  if (!c) return;
  const idx = c.ofertas.findIndex(o => o.id === ofertaId);
  if (idx === -1) return;
  c.ofertas[idx] = { ...oferta, id: ofertaId };
  saveAll(data);
}

/** Elimina una oferta */
export function deleteOferta(comercioId, ofertaId) {
  const data = getAll();
  const c = data.find(x => x.id === comercioId);
  if (!c) return;
  c.ofertas = c.ofertas.filter(o => o.id !== ofertaId);
  saveAll(data);
}

/** Borra el localStorage y vuelve a los datos originales */
export function resetToDefault() {
  localStorage.removeItem(KEY);
}

/** Actualiza los datos generales de un comercio (logo, nombre, color, descripcion…) */
export function updateComercioInfo(id, info) {
  const data = getAll();
  const c = data.find(x => x.id === id);
  if (!c) return;
  Object.assign(c, info);
  saveAll(data);
}

/** Exporta el contenido como string de comercios.js listo para copiar */
export function exportAsJS() {
  const data = getAll();
  return `export const comercios = ${JSON.stringify(data, null, 2)};\n`;
}
