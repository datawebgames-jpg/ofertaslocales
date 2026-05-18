/**
 * layout.js — Componentes compartidos: nav, filtros mobile
 */

export const RUBROS_ICONO = {
  'Ropa y Moda':    '👕',
  'Gastronomía':    '🍽️',
  'Tecnología':     '💻',
  'Hogar':          '🏠',
  'Salud & Belleza':'💄',
};

/**
 * Construye las tabs del nav de categorías.
 * En index.html: basePath = '', las tabs filtran en la misma página.
 * En comercios: basePath = '../../', las tabs navegan al index.
 *
 * @param {HTMLElement} navEl
 * @param {string[]} rubros
 * @param {object} opts
 *   - basePath: string ('', '../../', etc.)
 *   - mode: 'filter' (index) | 'navigate' (comercio pages)
 *   - activeRubro: string | null
 *   - onFilter: function(rubro) — solo en mode='filter'
 */
export function buildNav(navEl, rubros, { basePath = '', mode = 'filter', activeRubro = null, onFilter } = {}) {
  navEl.innerHTML = '';

  function makeLink(label, rubro) {
    const a = document.createElement('a');
    a.className = 'nav-cat' + (!rubro && !activeRubro || rubro === activeRubro ? ' active' : '');
    a.textContent = label;

    if (mode === 'navigate') {
      a.href = rubro
        ? `${basePath}index.html?rubro=${encodeURIComponent(rubro)}`
        : `${basePath}index.html`;
    } else {
      a.href = '#';
      a.onclick = (e) => {
        e.preventDefault();
        navEl.querySelectorAll('.nav-cat').forEach(el => el.classList.remove('active'));
        a.classList.add('active');
        if (onFilter) onFilter(rubro);
      };
    }
    return a;
  }

  navEl.appendChild(makeLink('Todo', null));
  rubros.forEach(r => {
    navEl.appendChild(makeLink(`${RUBROS_ICONO[r] || '🏪'} ${r}`, r));
  });
}

/**
 * Construye los chips de filtro mobile para el index.
 * Permite filtrar por comercio.
 */
export function buildMobileComercioChips(container, comercios, activeId, onChange) {
  container.innerHTML = '';

  const allBtn = document.createElement('button');
  allBtn.className = 'mob-chip' + (activeId === null ? ' active' : '');
  allBtn.textContent = 'Todos';
  allBtn.onclick = () => onChange(null);
  container.appendChild(allBtn);

  comercios.forEach(c => {
    const btn = document.createElement('button');
    btn.className = 'mob-chip' + (activeId === c.id ? ' active' : '');
    btn.innerHTML = `<span style="width:10px;height:10px;border-radius:50%;background:${c.color};display:inline-block;flex-shrink:0"></span>${c.nombre}`;
    btn.onclick = () => onChange(c.id);
    container.appendChild(btn);
  });
}

/**
 * Construye los chips de filtro mobile para páginas de comercio.
 * Permite filtrar por precio/descuento.
 */
export function buildMobileDescuentoChips(container, activeMin, onChange) {
  container.innerHTML = '';
  const opts = [
    { label: 'Todos', value: null },
    { label: '+20% OFF', value: 20 },
    { label: '+30% OFF', value: 30 },
    { label: '+40% OFF', value: 40 },
  ];
  opts.forEach(({ label, value }) => {
    const btn = document.createElement('button');
    btn.className = 'mob-chip' + (activeMin === value ? ' active' : '');
    btn.textContent = label;
    btn.onclick = () => onChange(value);
    container.appendChild(btn);
  });
}

/** Calcula % de descuento */
export function pct(original, actual) {
  return Math.round((1 - actual / original) * 100);
}

/** Formatea precio en pesos argentinos */
export function fmt(n) {
  return '$' + Number(n).toLocaleString('es-AR');
}
