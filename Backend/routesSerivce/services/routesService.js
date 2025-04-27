import { db } from "../config/config.js";
import KDTree from "static-kdtree";
import fetch from "node-fetch";

let paradas = [];
let paradaMap = new Map();
let tree = null;

// --- UTILS ---
function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 6371e3;
  const toRad = x => x * Math.PI / 180;
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  const a = Math.sin(dLat/2)**2 + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon/2)**2;
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return R * c;
}

async function calcularDistanciaRealConCalles(origen, destino) {
  try {
    const url = `https://router.project-osrm.org/route/v1/foot/${origen.longitud},${origen.latitud};${destino.longitud},${destino.latitud}?overview=false`;
    const response = await fetch(url);
    const data = await response.json();
    if (data.routes && data.routes.length > 0) {
      return { distancia: data.routes[0].distance, duracion: data.routes[0].duration };
    }
  } catch (error) {
    console.error("Error OSRM, usando haversine", error);
  }
  return { distancia: haversineDistance(origen.latitud, origen.longitud, destino.latitud, destino.longitud), duracion: null };
}

// --- DATA ---
async function obtenerParadas() {
  console.log("Cargando paradas desde base de datos...");
  const [result] = await db.query("CALL getParadas()");
  console.log(`Paradas cargadas: ${result[0].length}`);
  return result[0];
}

function inicializarMapaParadas() {
  paradaMap.clear();
  paradas.forEach(p => {
    paradaMap.set(p.id_Parada, p);
  });
}

function construirTree() {
  const coords = paradas.map(p => [p.Latitud, p.Longitud]);
  return new KDTree(coords);
}

// --- CORE ---
async function encontrarRuta(origen, destino, modo) {
  console.log("\n\u2728 Iniciando búsqueda de ruta completa...");

  const origenIdxs = tree.knn([origen.latitud, origen.longitud], 5);
  const destinoIdxs = tree.knn([destino.latitud, destino.longitud], 5);

  const origenes = origenIdxs.map(idx => paradas[idx]);
  const destinos = destinoIdxs.map(idx => paradas[idx]);

  let mejorRuta = null;
  let mejorCercania = Infinity;

  for (const inicio of origenes) {
    for (const fin of destinos) {

      let trayecto = [];

      trayecto.push({
        transporte: "Caminar",
        ruta: "Inicio",
        Parada: inicio.Descripcion,
        posicionParada: { latitud: origen.latitud, longitud: origen.longitud },
        posicionSiguienteParada: { latitud: inicio.Latitud, longitud: inicio.Longitud }
      });

      trayecto.push({
        transporte: inicio.TipoTransporte,
        ruta: inicio.Nombre_Ruta,
        Parada: fin.Descripcion,
        posicionParada: { latitud: inicio.Latitud, longitud: inicio.Longitud },
        posicionSiguienteParada: { latitud: fin.Latitud, longitud: fin.Longitud }
      });

      const distanciaRestante = haversineDistance(fin.Latitud, fin.Longitud, destino.latitud, destino.longitud);

      if (distanciaRestante < mejorCercania) {
        mejorRuta = trayecto;
        mejorCercania = distanciaRestante;
      }
    }
  }

  if (!mejorRuta) throw new Error("No se pudo encontrar conexión entre origen y destino.");

  // Agregar caminata final
  const ultimaParada = mejorRuta[mejorRuta.length-1].posicionSiguienteParada;
  const distanciaCalles = await calcularDistanciaRealConCalles(ultimaParada, destino);

  mejorRuta.push({
    transporte: "Caminar",
    ruta: "Final hacia Destino",
    Parada: "Final",
    posicionParada: ultimaParada,
    posicionSiguienteParada: { latitud: destino.latitud, longitud: destino.longitud },
    distanciaRealCalles: distanciaCalles.distancia,
    duracionEstimadaSegundos: distanciaCalles.duracion
  });

  console.log("\u2705 Ruta construida correctamente.");
  return mejorRuta;
}

// --- EXPORTS ---
export const calcularRutaMasRapida = async (req, res) => {
  try {
    const { origen, destino } = req.body;
    const ruta = await encontrarRuta(origen, destino, "rapida");
    res.status(200).json(ruta);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error calculando ruta rápida" });
  }
};

export const calcularRutaMasSegura = async (req, res) => {
  try {
    const { origen, destino } = req.body;
    const ruta = await encontrarRuta(origen, destino, "segura");
    res.status(200).json(ruta);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error calculando ruta segura" });
  }
};

export const inicializarGrafo = async () => {
  console.log("\u2728 Inicializando datos de rutas...");
  paradas = await obtenerParadas();
  inicializarMapaParadas();
  tree = construirTree();
  console.log("\u2705 Grafo y KDTree listos.");
};
