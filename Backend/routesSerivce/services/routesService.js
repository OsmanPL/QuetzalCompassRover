// Dependencies: `pathfinding`, `geolib`

import { db } from "../config/config.js";
import { getDistance } from "geolib";
import PF from "pathfinding";

let grafo = new Map();
let paradas = [];
let idParadaMap = new Map();

export async function inicializarGrafo() {
  console.log("Inicializando grafo de rutas...");
  const [result] = await db.query("CALL getParadas()");
  paradas = result[0];

  // Mapear parada por ID para acceso rápido
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
      grafo.get(origen.id_Parada.toString()).push({
        id: destino.id_Parada.toString(),
        modo: "ruta",
        ruta: origen.Nombre_Ruta,
        transporte: origen.TipoTransporte,
        peso: 1,
      });
    }
  });

  // Conectar paradas cercanas (menos de 1km)
  for (let i = 0; i < paradas.length; i++) {
    for (let j = i + 1; j < paradas.length; j++) {
      const dist = getDistance(
        { latitude: paradas[i].Latitud, longitude: paradas[i].Longitud },
        { latitude: paradas[j].Latitud, longitude: paradas[j].Longitud }
      );
      if (dist <= 1000) {
        const peso = dist / 100;
        grafo.get(paradas[i].id_Parada.toString()).push({ id: paradas[j].id_Parada.toString(), modo: "caminar", peso });
        grafo.get(paradas[j].id_Parada.toString()).push({ id: paradas[i].id_Parada.toString(), modo: "caminar", peso });
      }
    }
  }

  console.log("Grafo inicializado con:", grafo.size, "paradas");
}

function agruparPorRuta(paradas) {
  const rutas = new Map();
  for (const parada of paradas) {
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
    const dist = getDistance({ latitude: lat, longitude: lon }, {
      latitude: parada.Latitud,
      longitude: parada.Longitud,
    });
    if (dist < minDist) {
      minDist = dist;
      cercana = parada;
    }
  }
  return cercana;
}

export function generarRuta(origen, destino, modo = "Rapida") {
  const start = encontrarParadaCercana(origen.latitud, origen.longitud);
  const end = encontrarParadaCercana(destino.latitud, destino.longitud);

  const nodos = Array.from(grafo.keys());
  const distancias = new Map();
  const anteriores = new Map();
  const visitados = new Set();

  nodos.forEach((id) => distancias.set(id, Infinity));
  distancias.set(start.id_Parada.toString(), 0);

  while (visitados.size < nodos.length) {
    let nodoActual = null;
    let menorDist = Infinity;
    for (const [id, dist] of distancias.entries()) {
      if (!visitados.has(id) && dist < menorDist) {
        menorDist = dist;
        nodoActual = id;
      }
    }
    if (!nodoActual) break;
    visitados.add(nodoActual);

    for (const vecino of grafo.get(nodoActual)) {
      const penalizacion = modo === "Segura" && vecino.modo === "caminar" ? vecino.peso * 5 : vecino.peso;
      const nuevaDist = distancias.get(nodoActual) + penalizacion;
      if (nuevaDist < distancias.get(vecino.id)) {
        distancias.set(vecino.id, nuevaDist);
        anteriores.set(vecino.id, nodoActual);
      }
    }
  }

  // Reconstruir camino
  const ruta = [];
  let actual = end.id_Parada.toString();
  while (anteriores.has(actual)) {
    const anterior = anteriores.get(actual);
    const edge = grafo.get(anterior).find(e => e.id === actual);
    ruta.unshift({
      parada: idParadaMap.get(actual).Descripcion,
      ruta: edge.ruta || "Caminar",
      transporte: edge.modo === "caminar" ? "Caminar" : edge.transporte,
      origen: {
        latitud: idParadaMap.get(anterior).Latitud,
        longitud: idParadaMap.get(anterior).Longitud,
      },
      destino: {
        latitud: idParadaMap.get(actual).Latitud,
        longitud: idParadaMap.get(actual).Longitud,
      },
    });
    actual = anterior;
  }

  // Agregar tramo inicial a pie
  ruta.unshift({
    parada: `Caminando al punto de partida (${getDistance(
      { latitude: origen.latitud, longitude: origen.longitud },
      { latitude: start.Latitud, longitude: start.Longitud }
    )}m)`,
    ruta: "Caminar",
    transporte: "Caminar",
    origen,
    destino: { latitud: start.Latitud, longitud: start.Longitud },
  });

  return ruta;
}


export async function calcularRutaRapida(req, res) {
  try {
    const { origen, destino } = req.body;
    if (!origen || !destino) {
      return res.status(400).json({ error: "Faltan datos de origen o destino" });
    }

    const ruta = generarRuta(origen, destino, "Rapida");
    return res.status(200).json({ ruta });
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
    return res.status(200).json({ ruta });
  } catch (error) {
    console.error("Error al calcular ruta segura:", error);
    return res.status(500).json({ error: "Error al calcular ruta segura" });
  }
}
