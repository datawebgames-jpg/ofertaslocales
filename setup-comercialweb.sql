-- ============================================================
-- ComercialWeb — Supabase Setup
-- Ejecutar en: supabase.com > SQL Editor > New query
-- Orden: ejecutar TODO de una vez (o bloque por bloque)
-- ============================================================


-- ══════════════════════════════════════════════════════════
-- 1. EXTENSIONES
-- ══════════════════════════════════════════════════════════
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- ══════════════════════════════════════════════════════════
-- 2. TABLA: packs
--    Un pack es el producto que se vende al cliente.
--    Ej: "Pack Comunidad — Centro", "Pack Exclusivo — Norte"
-- ══════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.packs (
  id              SERIAL PRIMARY KEY,
  slug            TEXT UNIQUE NOT NULL,          -- ej: "pack-c-1", "pack-b-2"
  nombre          TEXT NOT NULL,                 -- ej: "Pack Comunidad — Santa Rosa"
  tipo            TEXT NOT NULL                  -- 'comunidad' | 'barrio' | 'exclusivo'
    CHECK (tipo IN ('comunidad','barrio','exclusivo')),
  num_comercios   INT NOT NULL DEFAULT 5,        -- máx comercios que incluye
  precio_mensual  NUMERIC(12,2) DEFAULT 0,       -- precio por comercio/mes
  activo          BOOLEAN NOT NULL DEFAULT FALSE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.packs IS 'Packs de comercios que se venden como producto';
COMMENT ON COLUMN public.packs.tipo IS 'comunidad=5 comercios, barrio=3, exclusivo=1';


-- ══════════════════════════════════════════════════════════
-- 3. TABLA: comercios
--    Cada comercio pertenece a un pack.
--    Un pack comunidad tiene hasta 5 comercios.
-- ══════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.comercios (
  id               SERIAL PRIMARY KEY,
  pack_id          INT NOT NULL REFERENCES public.packs(id) ON DELETE CASCADE,
  orden            INT NOT NULL DEFAULT 1,       -- posición dentro del pack (1..5)
  nombre           TEXT NOT NULL DEFAULT '',
  rubro            TEXT NOT NULL DEFAULT '',     -- ej: "Ferretería y Herramientas"
  logo_url         TEXT DEFAULT '',              -- URL a Supabase Storage
  color            TEXT DEFAULT '#1d3557',       -- color hex del comercio
  inicial          TEXT DEFAULT '',              -- fallback si no hay logo
  telefono         TEXT DEFAULT '',
  telefono_ventas  TEXT DEFAULT '',
  whatsapp         TEXT DEFAULT '',              -- solo números: 5492954123456
  mail             TEXT DEFAULT '',
  direccion        TEXT DEFAULT '',
  ciudad           TEXT DEFAULT '',
  provincia        TEXT DEFAULT '',
  activo           BOOLEAN NOT NULL DEFAULT TRUE,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  UNIQUE (pack_id, orden)                        -- no duplicar posición en el pack
);

COMMENT ON TABLE public.comercios IS 'Comercios suscriptos, cada uno pertenece a un pack';
COMMENT ON COLUMN public.comercios.whatsapp IS 'Solo números internacionales, ej: 5492954123456';
COMMENT ON COLUMN public.comercios.logo_url IS 'URL pública del logo en Supabase Storage (bucket: logos-comercios)';


-- ══════════════════════════════════════════════════════════
-- 4. TABLA: ofertas
--    Cada oferta pertenece a un comercio.
--    Máximo 20 por comercio (validado en la app).
-- ══════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.ofertas (
  id             SERIAL PRIMARY KEY,
  comercio_id    INT NOT NULL REFERENCES public.comercios(id) ON DELETE CASCADE,
  orden          INT NOT NULL DEFAULT 1,         -- posición en la grilla (1..20)
  nombre         TEXT NOT NULL DEFAULT '',       -- ej: "Taladro Percutor 750W"
  descripcion    TEXT DEFAULT '',
  imagen_url     TEXT DEFAULT '',               -- URL a Supabase Storage
  precio_real    NUMERIC(12,2) DEFAULT 0,       -- precio sin descuento
  precio_oferta  NUMERIC(12,2) DEFAULT 0,       -- precio con descuento
  descuento      INT DEFAULT 0                  -- % calculado
    CHECK (descuento >= 0 AND descuento <= 99),
  vence          DATE DEFAULT NULL,             -- NULL = sin vencimiento
  destacada      BOOLEAN NOT NULL DEFAULT FALSE,
  activo         BOOLEAN NOT NULL DEFAULT TRUE,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.ofertas IS 'Ofertas de cada comercio, máx 20 por comercio';
COMMENT ON COLUMN public.ofertas.imagen_url IS 'URL pública en Supabase Storage (bucket: imagenes-ofertas)';
COMMENT ON COLUMN public.ofertas.descuento IS 'Calculado: round((1 - precio_oferta/precio_real)*100)';


-- ══════════════════════════════════════════════════════════
-- 5. TABLA: admins
--    Relaciona usuarios de Supabase Auth con rol de admin.
--    Para acceder al panel admin.
-- ══════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.admins (
  id         UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email      TEXT NOT NULL,
  rol        TEXT NOT NULL DEFAULT 'admin'
    CHECK (rol IN ('admin','superadmin')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.admins IS 'Usuarios con acceso al panel de administración';


-- ══════════════════════════════════════════════════════════
-- 6. TRIGGERS: updated_at automático
-- ══════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_packs_updated_at
  BEFORE UPDATE ON public.packs
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_comercios_updated_at
  BEFORE UPDATE ON public.comercios
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_ofertas_updated_at
  BEFORE UPDATE ON public.ofertas
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


-- ══════════════════════════════════════════════════════════
-- 7. ÍNDICES (performance)
-- ══════════════════════════════════════════════════════════
CREATE INDEX IF NOT EXISTS idx_comercios_pack_id   ON public.comercios(pack_id);
CREATE INDEX IF NOT EXISTS idx_ofertas_comercio_id ON public.ofertas(comercio_id);
CREATE INDEX IF NOT EXISTS idx_ofertas_activo       ON public.ofertas(activo);
CREATE INDEX IF NOT EXISTS idx_packs_activo         ON public.packs(activo);
CREATE INDEX IF NOT EXISTS idx_packs_slug           ON public.packs(slug);


-- ══════════════════════════════════════════════════════════
-- 8. ROW LEVEL SECURITY (RLS)
-- ══════════════════════════════════════════════════════════

-- Habilitar RLS en todas las tablas
ALTER TABLE public.packs      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comercios  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ofertas    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admins     ENABLE ROW LEVEL SECURITY;

-- ── Helper: saber si el usuario autenticado es admin ──
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.admins
    WHERE id = auth.uid()
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- ── PACKS ──
-- Lectura pública: cualquiera puede ver packs activos
CREATE POLICY "packs_select_publico" ON public.packs
  FOR SELECT USING (activo = TRUE);

-- Lectura total para admin (también los inactivos)
CREATE POLICY "packs_select_admin" ON public.packs
  FOR SELECT USING (public.is_admin());

-- Solo admins pueden crear / editar / borrar
CREATE POLICY "packs_insert_admin" ON public.packs
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "packs_update_admin" ON public.packs
  FOR UPDATE USING (public.is_admin());

CREATE POLICY "packs_delete_admin" ON public.packs
  FOR DELETE USING (public.is_admin());

-- ── COMERCIOS ──
CREATE POLICY "comercios_select_publico" ON public.comercios
  FOR SELECT USING (
    activo = TRUE AND EXISTS (
      SELECT 1 FROM public.packs p WHERE p.id = pack_id AND p.activo = TRUE
    )
  );

CREATE POLICY "comercios_select_admin" ON public.comercios
  FOR SELECT USING (public.is_admin());

CREATE POLICY "comercios_insert_admin" ON public.comercios
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "comercios_update_admin" ON public.comercios
  FOR UPDATE USING (public.is_admin());

CREATE POLICY "comercios_delete_admin" ON public.comercios
  FOR DELETE USING (public.is_admin());

-- ── OFERTAS ──
CREATE POLICY "ofertas_select_publico" ON public.ofertas
  FOR SELECT USING (
    activo = TRUE AND EXISTS (
      SELECT 1 FROM public.comercios c
      JOIN public.packs p ON p.id = c.pack_id
      WHERE c.id = comercio_id AND c.activo = TRUE AND p.activo = TRUE
    )
  );

CREATE POLICY "ofertas_select_admin" ON public.ofertas
  FOR SELECT USING (public.is_admin());

CREATE POLICY "ofertas_insert_admin" ON public.ofertas
  FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "ofertas_update_admin" ON public.ofertas
  FOR UPDATE USING (public.is_admin());

CREATE POLICY "ofertas_delete_admin" ON public.ofertas
  FOR DELETE USING (public.is_admin());

-- ── ADMINS ──
-- Solo superadmin puede ver y gestionar admins
CREATE POLICY "admins_select" ON public.admins
  FOR SELECT USING (auth.uid() = id OR EXISTS (
    SELECT 1 FROM public.admins WHERE id = auth.uid() AND rol = 'superadmin'
  ));

CREATE POLICY "admins_insert" ON public.admins
  FOR INSERT WITH CHECK (EXISTS (
    SELECT 1 FROM public.admins WHERE id = auth.uid() AND rol = 'superadmin'
  ));

CREATE POLICY "admins_delete" ON public.admins
  FOR DELETE USING (EXISTS (
    SELECT 1 FROM public.admins WHERE id = auth.uid() AND rol = 'superadmin'
  ));


-- ══════════════════════════════════════════════════════════
-- 9. STORAGE: buckets para imágenes
-- ══════════════════════════════════════════════════════════

-- Bucket logos de comercios
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'logos-comercios',
  'logos-comercios',
  true,
  512000,   -- 500 KB máx
  ARRAY['image/jpeg','image/png','image/webp']
) ON CONFLICT (id) DO NOTHING;

-- Bucket imágenes de ofertas
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'imagenes-ofertas',
  'imagenes-ofertas',
  true,
  1048576,  -- 1 MB máx
  ARRAY['image/jpeg','image/png','image/webp']
) ON CONFLICT (id) DO NOTHING;

-- Políticas storage: lectura pública
CREATE POLICY "logos_read_publico" ON storage.objects
  FOR SELECT USING (bucket_id = 'logos-comercios');

CREATE POLICY "ofertas_img_read_publico" ON storage.objects
  FOR SELECT USING (bucket_id = 'imagenes-ofertas');

-- Políticas storage: solo admins suben/borran
CREATE POLICY "logos_upload_admin" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'logos-comercios' AND public.is_admin()
  );

CREATE POLICY "logos_delete_admin" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'logos-comercios' AND public.is_admin()
  );

CREATE POLICY "ofertas_img_upload_admin" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'imagenes-ofertas' AND public.is_admin()
  );

CREATE POLICY "ofertas_img_delete_admin" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'imagenes-ofertas' AND public.is_admin()
  );


-- ══════════════════════════════════════════════════════════
-- 10. VISTA PÚBLICA: pack_completo
--     Útil para cargar todo el pack de una sola query
-- ══════════════════════════════════════════════════════════
CREATE OR REPLACE VIEW public.pack_completo AS
SELECT
  p.id            AS pack_id,
  p.slug          AS pack_slug,
  p.nombre        AS pack_nombre,
  p.tipo          AS pack_tipo,
  p.num_comercios,
  p.precio_mensual,
  c.id            AS comercio_id,
  c.orden         AS comercio_orden,
  c.nombre        AS comercio_nombre,
  c.rubro,
  c.logo_url,
  c.color,
  c.inicial,
  c.whatsapp,
  c.telefono,
  c.direccion,
  c.ciudad,
  c.provincia,
  o.id            AS oferta_id,
  o.orden         AS oferta_orden,
  o.nombre        AS oferta_nombre,
  o.descripcion   AS oferta_descripcion,
  o.imagen_url,
  o.precio_real,
  o.precio_oferta,
  o.descuento,
  o.vence,
  o.destacada
FROM public.packs p
JOIN public.comercios c ON c.pack_id = p.id AND c.activo = TRUE
LEFT JOIN public.ofertas o ON o.comercio_id = c.id AND o.activo = TRUE
WHERE p.activo = TRUE
ORDER BY p.id, c.orden, o.orden;

COMMENT ON VIEW public.pack_completo IS 'Vista desnormalizada para cargar un pack completo en una query';


-- ══════════════════════════════════════════════════════════
-- 11. DATOS INICIALES — Pack Comunidad de ejemplo
--     (basado en src/data/packs.js)
--     Borrar o comentar si no querés datos de prueba
-- ══════════════════════════════════════════════════════════

INSERT INTO public.packs (slug, nombre, tipo, num_comercios, precio_mensual, activo)
VALUES
  ('pack-c-1', 'Pack Comunidad — Santa Rosa', 'comunidad', 5, 300000, TRUE),
  ('pack-b-1', 'Pack Barrio — Disponible',    'barrio',    3, 400000, FALSE),
  ('pack-e-1', 'Pack Exclusivo — Disponible', 'exclusivo', 1, 700000, FALSE)
ON CONFLICT (slug) DO NOTHING;

-- Comercios del pack comunidad (id=1)
INSERT INTO public.comercios
  (pack_id, orden, nombre, rubro, color, inicial, telefono, telefono_ventas, whatsapp, mail, direccion, ciudad, provincia)
SELECT
  p.id, c.orden, c.nombre, c.rubro, c.color, c.inicial,
  c.telefono, c.telefono_ventas, c.whatsapp, c.mail,
  c.direccion, c.ciudad, c.provincia
FROM public.packs p,
(VALUES
  (1,'Ferretería Sur',       'Ferretería y Herramientas','#e63946','FS','+54 9 2954 123456','+54 9 2954 654321','5492954123456','ferreteria@ejemplo.com','Av. San Martín 450',  'Santa Rosa','La Pampa'),
  (2,'Pinturería Mix',       'Pinturería',               '#f4a261','PM','+54 9 2954 234567','+54 9 2954 765432','5492954234567','pintureria@ejemplo.com','Belgrano 1230',        'Santa Rosa','La Pampa'),
  (3,'Plomería Roca',        'Plomería',                 '#2a9d8f','PR','+54 9 2954 345678','+54 9 2954 876543','5492954345678','plomeria@ejemplo.com',  'Pellegrini 780',       'Santa Rosa','La Pampa'),
  (4,'Hierros del Sur',      'Hierros y Chapas',         '#8338ec','HS','+54 9 2954 456789','+54 9 2954 987654','5492954456789','hierros@ejemplo.com',   'Rivadavia 920',        'Santa Rosa','La Pampa'),
  (5,'Áridos y Materiales',  'Áridos y Materiales de Construcción','#ff006e','AM','+54 9 2954 567890','+54 9 2954 098765','5492954567890','aridos@ejemplo.com','España 340','Santa Rosa','La Pampa')
) AS c(orden, nombre, rubro, color, inicial, telefono, telefono_ventas, whatsapp, mail, direccion, ciudad, provincia)
WHERE p.slug = 'pack-c-1'
ON CONFLICT (pack_id, orden) DO NOTHING;

-- Ofertas del comercio 1 (Ferretería Sur) — se inserta por nombre para evitar hardcodear IDs
INSERT INTO public.ofertas (comercio_id, orden, nombre, descripcion, precio_real, precio_oferta, descuento, vence)
SELECT
  c.id, o.orden, o.nombre, o.descripcion,
  o.precio_real, o.precio_oferta, o.descuento, o.vence::DATE
FROM public.comercios c,
(VALUES
  (1,'Taladro Percutor 750W','Taladro percutor 750W con maletín y accesorios incluidos.',      89999, 59999, 33, '2026-07-31'),
  (2,'Juego Llaves Combinadas x12','Set de 12 llaves combinadas acero cromo-vanadio 8 al 22mm.',34500, 22000, 36, NULL),
  (3,'Pintura Látex Interior 20L','Pintura látex premium interior. Rendimiento 12m²/litro.',    58000, 42000, 28, '2026-06-30'),
  (4,'Cinta Métrica 10m Stanley','Cinta Stanley FatMax 10m con freno de seguridad.',            12500,  8900, 29, NULL),
  (5,'Escalera Aluminio 6 Peldaños','Escalera aluminio plegable 6 peldaños. Cap. 150kg.',       76000, 54000, 29, NULL)
) AS o(orden, nombre, descripcion, precio_real, precio_oferta, descuento, vence)
WHERE c.nombre = 'Ferretería Sur'
ON CONFLICT DO NOTHING;

-- Ofertas del comercio 2 (Pinturería Mix)
INSERT INTO public.ofertas (comercio_id, orden, nombre, descripcion, precio_real, precio_oferta, descuento)
SELECT c.id, o.orden, o.nombre, o.descripcion, o.precio_real, o.precio_oferta, o.descuento
FROM public.comercios c,
(VALUES
  (1,'Esmalte Sintético 4L Blanco','Esmalte sintético brillante alta cobertura para madera y metales.',42000,28000,33),
  (2,'Set Pinceles Profesionales x6','6 pinceles cerdas naturales y sintéticas para pintura.',         18000,11500,36),
  (3,'Rodillo Lana 23cm + Bandeja','Rodillo lana 23cm con bandeja plástica incluida.',                  9800, 6500,34),
  (4,'Enduído Plástico Interior 5kg','Enduído plástico interior, fácil aplicación.',                   22000,15000,32),
  (5,'Fijador Universal 4L','Fijador universal para todo tipo de superficies.',                        28000,18500,34)
) AS o(orden, nombre, descripcion, precio_real, precio_oferta, descuento)
WHERE c.nombre = 'Pinturería Mix'
ON CONFLICT DO NOTHING;

-- Ofertas del comercio 3 (Plomería Roca)
INSERT INTO public.ofertas (comercio_id, orden, nombre, descripcion, precio_real, precio_oferta, descuento)
SELECT c.id, o.orden, o.nombre, o.descripcion, o.precio_real, o.precio_oferta, o.descuento
FROM public.comercios c,
(VALUES
  (1,'Grifería Premium Monocomando','Grifería de cocina monocomando acero inoxidable.',145000,111000,23),
  (2,'Llaves de Paso x3','Set 3 llaves de paso 1/2" acero reforzado.',                  38000, 26000,32),
  (3,'Cañería PVC 4m ø50','Cañería PVC 50mm x 4m para desagüe.',                        12000,  7800,35),
  (4,'Sifón Botella Universal','Sifón botella universal para pileta de cocina.',           8500,  5500,35),
  (5,'Termostato Calefón Digital','Termostato digital compatible calefones 12/14L.',       32000, 21000,34)
) AS o(orden, nombre, descripcion, precio_real, precio_oferta, descuento)
WHERE c.nombre = 'Plomería Roca'
ON CONFLICT DO NOTHING;


-- ══════════════════════════════════════════════════════════
-- 12. PRIMER ADMIN (reemplazá el email con el tuyo)
--     Primero creá el usuario en Supabase Auth (Authentication > Users > Add user)
--     Luego ejecutá este bloque con el UUID que te da Supabase
-- ══════════════════════════════════════════════════════════
-- INSERT INTO public.admins (id, email, rol)
-- VALUES ('UUID-DEL-USUARIO-AQUI', 'dataweb76@gmail.com', 'superadmin');


-- ══════════════════════════════════════════════════════════
-- FIN DEL SCRIPT
-- Tablas creadas:
--   public.packs       — los packs (productos)
--   public.comercios   — los comercios de cada pack
--   public.ofertas     — las ofertas de cada comercio
--   public.admins      — usuarios con acceso al admin
-- Storage buckets:
--   logos-comercios    — logos de los comercios
--   imagenes-ofertas   — fotos de los productos
-- Vista:
--   public.pack_completo — joins de todo en una query
-- ══════════════════════════════════════════════════════════
