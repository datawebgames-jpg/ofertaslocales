export const comercios = [
  {
    id: 1,
    nombre: "Comercio 1",
    rubro: "Ropa y Moda",
    color: "#E63946",
    inicial: "C1",
    logo: null,
    descripcion: "Las mejores prendas de temporada con precios increíbles",
    ofertas: [
      { id: 1, titulo: "Remeras 2x1", descripcion: "Llevá 2 remeras al precio de 1. Todos los talles disponibles, varios colores.", precio: 3500, precioOriginal: 7000, imagen: null, destacada: true },
      { id: 2, titulo: "30% OFF en jeans", descripcion: "Todos los jeans de la nueva colección primavera-verano en todos los talles.", precio: 14000, precioOriginal: 20000, imagen: null, destacada: false },
      { id: 3, titulo: "Camperas de abrigo", descripcion: "Camperas con relleno térmico, impermeables y con capucha. Talles S a XXL.", precio: 18500, precioOriginal: 26000, imagen: null, destacada: true },
      { id: 4, titulo: "Zapatillas urbanas", descripcion: "Modelos de temporada, suela antideslizante. Talles del 35 al 45.", precio: 22000, precioOriginal: 32000, imagen: null, destacada: false },
      { id: 5, titulo: "Vestidos de verano", descripcion: "Colección de vestidos livianos, varios modelos y estampados disponibles.", precio: 9800, precioOriginal: 15000, imagen: null, destacada: false },
      { id: 6, titulo: "Accesorios — 40% OFF", descripcion: "Cinturones, bufandas, gorros y más. Todos con 40% de descuento.", precio: 2100, precioOriginal: 3500, imagen: null, destacada: false }
    ]
  },
  {
    id: 2,
    nombre: "Comercio 2",
    rubro: "Gastronomía",
    color: "#F4A261",
    inicial: "C2",
    logo: null,
    descripcion: "Sabores únicos de nuestra cocina en el corazón de tu ciudad",
    ofertas: [
      { id: 1, titulo: "Menú del día completo", descripcion: "Entrada + plato principal + postre + bebida. El menú cambia todos los días.", precio: 4500, precioOriginal: 6500, imagen: null, destacada: true },
      { id: 2, titulo: "Pizza familiar", descripcion: "Pizza grande a la piedra con hasta 3 ingredientes a elección.", precio: 3200, precioOriginal: 4800, imagen: null, destacada: false },
      { id: 3, titulo: "Combo hamburguesa", descripcion: "Hamburguesa artesanal doble + papas fritas crocantes + bebida 350ml.", precio: 3800, precioOriginal: 5500, imagen: null, destacada: true },
      { id: 4, titulo: "Empanadas x12", descripcion: "Docena de empanadas al horno. Variedad de rellenos a elección del cliente.", precio: 4200, precioOriginal: 5800, imagen: null, destacada: false },
      { id: 5, titulo: "Desayuno especial", descripcion: "Café con leche + 4 medialunas + jugo de naranja exprimido natural.", precio: 1800, precioOriginal: 2800, imagen: null, destacada: false },
      { id: 6, titulo: "Sushi — 20 piezas", descripcion: "Mix de 20 piezas: nigiri + maki + california roll. Ideal para 2 personas.", precio: 6500, precioOriginal: 9500, imagen: null, destacada: false }
    ]
  },
  {
    id: 3,
    nombre: "Comercio 3",
    rubro: "Tecnología",
    color: "#2A9D8F",
    inicial: "C3",
    logo: null,
    descripcion: "Los mejores gadgets y accesorios tecnológicos al mejor precio",
    ofertas: [
      { id: 1, titulo: "Auriculares Bluetooth", descripcion: "Sonido HD, 20hs de batería, cancelación de ruido pasiva. Incluye estuche.", precio: 18000, precioOriginal: 28000, imagen: null, destacada: true },
      { id: 2, titulo: "Cargadores — 20% OFF", descripcion: "Todos los cargadores y cables USB-C y Lightning de la tienda en oferta.", precio: 2400, precioOriginal: 3000, imagen: null, destacada: false },
      { id: 3, titulo: "Smartwatch", descripcion: "Reloj inteligente con monitor cardíaco, GPS, resistente al agua. Incluye correa extra.", precio: 32000, precioOriginal: 48000, imagen: null, destacada: true },
      { id: 4, titulo: "Parlante portátil", descripcion: "Bluetooth 5.0, resistente al agua IPX5, 10hs de autonomía, graves potentes.", precio: 14500, precioOriginal: 22000, imagen: null, destacada: false },
      { id: 5, titulo: "Memoria USB 64GB", descripcion: "USB 3.0 de alta velocidad. Compatible con PC, Mac y smart TV. Garantía 1 año.", precio: 3200, precioOriginal: 4800, imagen: null, destacada: false },
      { id: 6, titulo: "Mouse inalámbrico", descripcion: "Mouse ergonómico silencioso, receptor nano USB, 12 meses de batería.", precio: 5800, precioOriginal: 8500, imagen: null, destacada: false }
    ]
  },
  {
    id: 4,
    nombre: "Comercio 4",
    rubro: "Hogar",
    color: "#8338EC",
    inicial: "C4",
    logo: null,
    descripcion: "Todo lo que tu hogar necesita con diseño y calidad garantizada",
    ofertas: [
      { id: 1, titulo: "Sábanas 2 plazas", descripcion: "Juego de sábanas 200 hilos, incluye sábana bajera, encimera y fundas de almohada.", precio: 9500, precioOriginal: 14000, imagen: null, destacada: true },
      { id: 2, titulo: "Vajilla 12 piezas", descripcion: "Set de vajilla de porcelana: platos hondos, platos planos, tazas y bowls.", precio: 12000, precioOriginal: 18000, imagen: null, destacada: false },
      { id: 3, titulo: "Almohadas viscoelásticas", descripcion: "Par de almohadas memory foam con funda lavable e hipoalergénica incluida.", precio: 8500, precioOriginal: 13000, imagen: null, destacada: true },
      { id: 4, titulo: "Set de toallas x4", descripcion: "4 toallas de baño 100% algodón, 500g/m². Disponibles en varios colores.", precio: 6200, precioOriginal: 9500, imagen: null, destacada: false },
      { id: 5, titulo: "Cortinas blackout", descripcion: "Par de cortinas oscurecedoras 2m x 2.2m. Disponibles en 6 colores.", precio: 11000, precioOriginal: 17000, imagen: null, destacada: false },
      { id: 6, titulo: "Set de cubiertos 24pz", descripcion: "Cubiertos de acero inoxidable 18/10. Incluye estuche de regalo.", precio: 7800, precioOriginal: 12000, imagen: null, destacada: false }
    ]
  },
  {
    id: 5,
    nombre: "Comercio 5",
    rubro: "Salud & Belleza",
    color: "#FF006E",
    inicial: "C5",
    logo: null,
    descripcion: "Cuidado personal de primera calidad para lucir y sentirte bien",
    ofertas: [
      { id: 1, titulo: "Kit de cuidado facial", descripcion: "Crema hidratante + sérum vitamina C + contorno de ojos. Kit completo.", precio: 7800, precioOriginal: 12000, imagen: null, destacada: true },
      { id: 2, titulo: "Perfumes — 25% OFF", descripcion: "Gran variedad de fragancias nacionales e importadas. Para él y para ella.", precio: 15000, precioOriginal: 20000, imagen: null, destacada: false },
      { id: 3, titulo: "Shampoo + acondicionador", descripcion: "Dúo nutritivo para cabello seco o dañado. Fórmula sin sal, 400ml c/u.", precio: 4200, precioOriginal: 6500, imagen: null, destacada: true },
      { id: 4, titulo: "Set de maquillaje", descripcion: "Kit completo con base, corrector, sombras, rubor y labiales. Varios tonos.", precio: 9500, precioOriginal: 15000, imagen: null, destacada: false },
      { id: 5, titulo: "Crema corporal 500ml", descripcion: "Crema nutritiva con manteca de karité y vitamina E. Aroma a vainilla.", precio: 2800, precioOriginal: 4200, imagen: null, destacada: false },
      { id: 6, titulo: "Vitaminas y suplementos", descripcion: "Vitamina C, D3, Omega 3 y multivitamínicos en cápsulas blandas, x30.", precio: 3600, precioOriginal: 5500, imagen: null, destacada: false }
    ]
  }
];
