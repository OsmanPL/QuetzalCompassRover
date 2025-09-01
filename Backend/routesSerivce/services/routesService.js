import { db, GOOGLE_MAPS_API_KEY } from "../config/config.js";
import { getDistance } from "geolib";
import fetch from "node-fetch";

// Velocidades promedio (m/s)
const WALK_SPEED_MPS = 1.33; // ~4.8 km/h
const VEHICLE_SPEED_MPS = 6.94; // ~25 km/h como aproximación urbana
// Penalizaciones de modo Seguro
const WALK_PENALTY_FACTOR = 5.0; // evitar caminar
const CAMIONETA_PENALTY_FACTOR = 2.0; // evitar Camioneta

class MinHeap {
  constructor() { this.a = []; }
  push(x) {
    this.a.push(x);
    this._siftUp(this.a.length - 1);
  }
  pop() {
    if (this.a.length === 0) return null;
    const top = this.a[0];
    const last = this.a.pop();
    if (this.a.length) { this.a[0] = last; this._siftDown(0); }
    return top;
  }
  _siftUp(i) {
    while (i > 0) {
      const p = Math.floor((i - 1) / 2);
      if (this.a[p].dist <= this.a[i].dist) break;
      [this.a[p], this.a[i]] = [this.a[i], this.a[p]];
      i = p;
    }
  }
  _siftDown(i) {
    const n = this.a.length;
    while (true) {
      let l = 2 * i + 1, r = 2 * i + 2, m = i;
      if (l < n && this.a[l].dist < this.a[m].dist) m = l;
      if (r < n && this.a[r].dist < this.a[m].dist) m = r;
      if (m === i) break;
      [this.a[m], this.a[i]] = [this.a[i], this.a[m]];
      i = m;
    }
  }
  get size() { return this.a.length; }
}

let grafo = new Map();
let paradas = [];
let idParadaMap = new Map();

export async function inicializarGrafo() {
  console.log("Inicializando grafo de rutas...");
  const [result] = await db.query("CALL getParadas()");
  paradas = result[0];
  idParadaMap.clear();
  grafo.clear();

  // Mapear parada por ID y crear lista de adyacencia
  paradas.forEach((parada) => {
    idParadaMap.set(parada.id_Parada.toString(), parada);
    grafo.set(parada.id_Parada.toString(), []);
  });

  // Conectar paradas por ruta secuencialmente
  const rutas = agruparPorRuta(paradas);
  rutas.forEach((paradasRuta) => {
    for (let i = 0; i < paradasRuta.length - 1; i++) {
      const origen = paradasRuta[i];
      const destino = paradasRuta[i + 1];
      const dist = getDistance(
        { latitude: origen.Latitud, longitude: origen.Longitud },
        { latitude: destino.Latitud, longitude: destino.Longitud }
      );
      const timeSec = dist / VEHICLE_SPEED_MPS;
      grafo.get(origen.id_Parada.toString()).push({
        id: destino.id_Parada.toString(),
        modo: "ruta",
        ruta: origen.Nombre_Ruta,
        transporte: origen.TipoTransporte,
        peso: 1,
        distanceMeters: dist,
        timeSec,
      });
    }
  });

  // Conectar paradas cercanas (menos de 1km) para caminar
  for (let i = 0; i < paradas.length; i++) {
    for (let j = i + 1; j < paradas.length; j++) {
      const dist = getDistance(
        { latitude: paradas[i].Latitud, longitude: paradas[i].Longitud },
        { latitude: paradas[j].Latitud, longitude: paradas[j].Longitud }
      );
      if (dist <= 1000) {
        const peso = dist / 100;
        const timeSec = dist / WALK_SPEED_MPS;
        grafo.get(paradas[i].id_Parada.toString()).push({
          id: paradas[j].id_Parada.toString(),
          modo: "caminar",
          peso,
          distanceMeters: dist,
          timeSec,
        });
        grafo.get(paradas[j].id_Parada.toString()).push({
          id: paradas[i].id_Parada.toString(),
          modo: "caminar",
          peso,
          distanceMeters: dist,
          timeSec,
        });
      }
    }
  }

  console.log("Grafo inicializado con:", grafo.size, "paradas");
}

function agruparPorRuta(paradasArr) {
  const rutas = new Map();
  for (const parada of paradasArr) {
    if (!rutas.has(parada.Nombre_Ruta)) {
      rutas.set(parada.Nombre_Ruta, []);
    }
    rutas.get(parada.Nombre_Ruta).push(parada);
  }
  rutas.forEach((lista, ruta) => {
    rutas.set(
      ruta,
      lista.sort((a, b) => a.id_Parada - b.id_Parada)
    );
  });
  return rutas;
}

function encontrarParadaCercana(lat, lon) {
  let minDist = Infinity;
  let cercana = null;
  for (const parada of paradas) {
    const dist = getDistance(
      { latitude: lat, longitude: lon },
      { latitude: parada.Latitud, longitude: parada.Longitud }
    );
    if (dist < minDist) {
      minDist = dist;
      cercana = parada;
    }
  }
  return cercana;
}

function costForEdge(edge, modo) {
  const baseTime = edge.timeSec ?? (edge.distanceMeters
    ? edge.distanceMeters / (edge.modo === "caminar" ? WALK_SPEED_MPS : VEHICLE_SPEED_MPS)
    : 1);

  if (modo === "Rapida" || modo === "Tiempo") {
    // Minimiza el tiempo total
    return baseTime;
  }
  if (modo === "Segura") {
    // Minimiza tiempo con penalizaciones a caminar y Camioneta
    let factor = 1;
    if (edge.modo === "caminar") factor *= WALK_PENALTY_FACTOR;
    const t = (edge.transporte || "").toString().toLowerCase();
    if (t === "camioneta") factor *= CAMIONETA_PENALTY_FACTOR;
    return baseTime * factor;
  }
  // Fallback: métrica antigua
  return edge.peso ?? 1;
}

function dijkstra(startId, endId, modo) {
  const dist = new Map();
  const prev = new Map();
  const visited = new Set();
  const pq = new MinHeap();

  for (const id of grafo.keys()) dist.set(id, Infinity);
  dist.set(startId, 0);
  pq.push({ id: startId, dist: 0 });

  while (pq.size) {
    const { id: u, dist: du } = pq.pop();
    if (visited.has(u)) continue;
    visited.add(u);
    if (u === endId) break;
    const neighbors = grafo.get(u) || [];
    for (const edge of neighbors) {
      const v = edge.id;
      const w = costForEdge(edge, modo);
      const alt = du + w;
      if (alt < (dist.get(v) ?? Infinity)) {
        dist.set(v, alt);
        prev.set(v, u);
        pq.push({ id: v, dist: alt });
      }
    }
  }
  return { dist, prev };
}

// --- helper para empaquetar info de parada (si existe) ---
function paradaInfo(parada) {
  if (!parada) return null;
  return {
    id: String(parada.id_Parada),
    nombre: parada.Descripcion,
    ruta: parada.Nombre_Ruta ?? null,
    tipoTransporte: parada.TipoTransporte ?? null,
    latitud: parada.Latitud,
    longitud: parada.Longitud,
  };
}

export function generarRuta(origen, destino, modo = "Rapida") {
  const start = encontrarParadaCercana(origen.latitud, origen.longitud);
  const end = encontrarParadaCercana(destino.latitud, destino.longitud);
  const startId = start.id_Parada.toString();
  const endId = end.id_Parada.toString();
  const { prev } = dijkstra(startId, endId, modo);

  // Reconstruir camino de paradas (de end hacia start)
  const ruta = [];
  let actual = endId;
  while (prev.has(actual)) {
    const anterior = prev.get(actual);
    const edge = grafo.get(anterior).find((e) => e.id === actual);

    const paradaOrigenObj = idParadaMap.get(anterior);
    const paradaDestinoObj = idParadaMap.get(actual);

    ruta.unshift({
      ruta: edge.modo === "caminar" ? "Caminar" : (edge.ruta || null),
      transporte: edge.modo === "caminar" ? "Caminar" : (edge.transporte || null),
      origen: {
        latitud: paradaOrigenObj.Latitud,
        longitud: paradaOrigenObj.Longitud,
      },
      destino: {
        latitud: paradaDestinoObj.Latitud,
        longitud: paradaDestinoObj.Longitud,
      },
      parada_origen: paradaInfo(paradaOrigenObj),
      parada_destino: paradaInfo(paradaDestinoObj),
    });

    actual = anterior;
  }

  // Tramo inicial a pie: usuario -> start
  ruta.unshift({
    ruta: "Caminar",
    transporte: "Caminar",
    origen: { ...origen }, // punto del usuario
    destino: { latitud: start.Latitud, longitud: start.Longitud },
    parada_origen: null,                          // no hay parada en el punto de usuario
    parada_destino: paradaInfo(start),            // sí hay parada destino (start)
  });

  // Tramo final a pie: end -> usuario
  ruta.push({
    ruta: "Caminar",
    transporte: "Caminar",
    origen: { latitud: end.Latitud, longitud: end.Longitud },
    destino: { ...destino },
    parada_origen: paradaInfo(end),               // hay parada origen (end)
    parada_destino: null,                         // el destino es punto del usuario
  });

  // Unir caminar+caminar contiguos (manteniendo parada_origen/destino coherentes)
  for (let i = 0; i < ruta.length - 1; i++) {
    const a = ruta[i];
    const b = ruta[i + 1];
    if (a.transporte === "Caminar" && b.transporte === "Caminar") {
      const distanciaTotal = getDistance(
        { latitude: a.origen.latitud, longitude: a.origen.longitud },
        { latitude: b.destino.latitud, longitude: b.destino.longitud }
      );
      ruta[i] = {
        ruta: "Caminar",
        transporte: "Caminar",
        origen: a.origen,
        destino: b.destino,
        parada_origen: a.parada_origen ?? null,
        parada_destino: b.parada_destino ?? null,
        detalle: `Caminar (${distanciaTotal}m)`,
      };
      ruta.splice(i + 1, 1);
      i--;
    }
  }

  return ruta;
}

function formatDuration(totalSec) {
  const s = Math.max(0, Math.round(totalSec));
  const h = Math.floor(s / 3600);
  const m = Math.floor((s % 3600) / 60);
  const ss = s % 60;
  if (h > 0) return `${h}h ${m}m`;
  if (m > 0) return `${m}m`;
  return `${ss}s`;
}

async function googleDirectionsDurationSec({ o, d, mode }) {
  const origin = `${o.latitud},${o.longitud}`;
  const dest = `${d.latitud},${d.longitud}`;
  const params = new URLSearchParams({
    origin,
    destination: dest,
    mode: mode === "walking" ? "walking" : "driving",
    key: GOOGLE_MAPS_API_KEY,
  });
  if (mode !== "walking") params.set("departure_time", "now");
  const url = `https://maps.googleapis.com/maps/api/directions/json?${params.toString()}`;
  try {
    const res = await fetch(url);
    const json = await res.json();
    if (json.status !== "OK" || !Array.isArray(json.routes) || json.routes.length === 0) return null;
    const route = json.routes[0];
    const legs = Array.isArray(route.legs) ? route.legs : [];
    let total = 0;
    for (const leg of legs) {
      const dur = mode !== "walking" ? (leg.duration_in_traffic?.value ?? leg.duration?.value) : leg.duration?.value;
      if (typeof dur === "number") total += dur;
    }
    return total > 0 ? total : null;
  } catch (e) {
    return null;
  }
}

async function annotateRouteWithTimes(ruta) {
  let total = 0;
  for (const seg of ruta) {
    const dist = getDistance(
      { latitude: seg.origen.latitud, longitude: seg.origen.longitud },
      { latitude: seg.destino.latitud, longitude: seg.destino.longitud }
    );
    seg.distancia_metros = dist;
    let tiempoSeg = 0;
    if (seg.transporte === "Caminar") {
      tiempoSeg = dist / WALK_SPEED_MPS;
    } else {
      const g = await googleDirectionsDurationSec({ o: seg.origen, d: seg.destino, mode: "driving" });
      if (typeof g === "number" && g > 0) tiempoSeg = g; else tiempoSeg = dist / VEHICLE_SPEED_MPS;
    }
    seg.tiempo_segundos = Math.round(tiempoSeg);
    seg.tiempo_texto = formatDuration(seg.tiempo_segundos);
    total += seg.tiempo_segundos;
  }
  return { ruta: ruta, total_tiempo_segundos: total, total_tiempo_texto: formatDuration(total) };
}

export async function calcularRutaRapida(req, res) {
  try {
    const { origen, destino } = req.body;
    if (!origen || !destino) {
      return res.status(400).json({ error: "Faltan datos de origen o destino" });
    }
    const ruta = generarRuta(origen, destino, "Rapida");
    const tiempos = await annotateRouteWithTimes(ruta);
    return res.status(200).json(tiempos);
  } catch (error) {
    console.error("Error al calcular ruta rápida:", error);
    return res.status(500).json({ error: "Error al calcular ruta rápida" });
  }
}

export async function calcularRutaSegura(req, res) {
  try {
    const { origen, destino } = req.body;
    if (!origen || !destino) {
      return res.status(400).json({ error: "Faltan datos de origen o destino" });
    }
    const ruta = generarRuta(origen, destino, "Segura");
    const tiempos = await annotateRouteWithTimes(ruta);
    return res.status(200).json(tiempos);
  } catch (error) {
    console.error("Error al calcular ruta segura:", error);
    return res.status(500).json({ error: "Error al calcular ruta segura" });
  }
}

export async function calcularRutaTiempo(req, res) {
  try {
    const { origen, destino } = req.body;
    if (!origen || !destino) {
      return res.status(400).json({ error: "Faltan datos de origen o destino" });
    }
    const ruta = generarRuta(origen, destino, "Tiempo");
    const tiempos = await annotateRouteWithTimes(ruta);
    return res.status(200).json(tiempos);
  } catch (error) {
    console.error("Error al calcular ruta por tiempo:", error);
    return res.status(500).json({ error: "Error al calcular ruta por tiempo" });
  }
}
