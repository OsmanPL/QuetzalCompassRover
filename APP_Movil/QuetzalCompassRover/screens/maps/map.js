import React, { useEffect, useMemo, useRef, useState } from "react";
import {
  StyleSheet,
  View,
  ActivityIndicator,
  Alert,
  Image,
  TouchableOpacity,
  Text,
} from "react-native";
import MapView, { PROVIDER_GOOGLE, Marker, Polyline } from "react-native-maps";
import { GooglePlacesAutocomplete } from "react-native-google-places-autocomplete";
import * as Location from "expo-location";
import { useNavigation } from "@react-navigation/native";

/* ========== Geodesia & utils ========== */
const toRad = (deg) => (deg * Math.PI) / 180;
const toDeg = (rad) => (rad * 180) / Math.PI;
const hasNumber = (n) => typeof n === "number" && !Number.isNaN(n);
const isValidCoord = (p) =>
  p && typeof p === "object" && hasNumber(p.latitude) && hasNumber(p.longitude);

const sanitizeCoordsArray = (arr) =>
  Array.isArray(arr) ? arr.filter(isValidCoord) : [];

// Distancia Haversine aproximada en metros
function haversine(a, b) {
  if (!isValidCoord(a) || !isValidCoord(b)) return Infinity;
  const R = 6371000;
  const dLat = toRad(b.latitude - a.latitude);
  const dLng = toRad(b.longitude - a.longitude);
  const lat1 = toRad(a.latitude);
  const lat2 = toRad(b.latitude);
  const sinDLat = Math.sin(dLat / 2);
  const sinDLng = Math.sin(dLng / 2);
  const c = 2 * Math.asin(
    Math.sqrt(sinDLat * sinDLat + Math.cos(lat1) * Math.cos(lat2) * sinDLng * sinDLng)
  );
  return R * c;
}

function closestPointIndex(coords = [], p) {
  if (!Array.isArray(coords) || coords.length === 0 || !isValidCoord(p)) return -1;
  let bestIdx = 0;
  let bestDist = Number.POSITIVE_INFINITY;
  for (let i = 0; i < coords.length; i++) {
    const d = haversine(coords[i], p);
    if (d < bestDist) {
      bestDist = d;
      bestIdx = i;
    }
  }
  return bestIdx;
}

// Rumbo (bearing) de p1 a p2
function bearing(p1, p2) {
  const φ1 = toRad(p1.latitude);
  const φ2 = toRad(p2.latitude);
  const Δλ = toRad(p2.longitude - p1.longitude);
  const y = Math.sin(Δλ) * Math.cos(φ2);
  const x =
    Math.cos(φ1) * Math.sin(φ2) -
    Math.sin(φ1) * Math.cos(φ2) * Math.cos(Δλ);
  const θ = Math.atan2(y, x);
  return (toDeg(θ) + 360) % 360;
}

// Proyecta un punto a 'distMeters' desde 'p' con rumbo 'brngDeg'
function projectPoint(p, brngDeg, distMeters) {
  const R = 6371000; // m
  const δ = distMeters / R;
  const θ = toRad(brngDeg);
  const φ1 = toRad(p.latitude);
  const λ1 = toRad(p.longitude);

  const φ2 = Math.asin(
    Math.sin(φ1) * Math.cos(δ) + Math.cos(φ1) * Math.sin(δ) * Math.cos(θ)
  );
  const λ2 =
    λ1 +
    Math.atan2(
      Math.sin(θ) * Math.sin(δ) * Math.cos(φ1),
      Math.cos(δ) - Math.sin(φ1) * Math.sin(φ2)
    );

  return { latitude: toDeg(φ2), longitude: ((toDeg(λ2) + 540) % 360) - 180 };
}

// Rumbo aproximado de los primeros metros de una polyline
function firstHeading(coords, sample = 5) {
  const pts = Array.isArray(coords) ? coords : [];
  if (pts.length < 2) return null;
  const a = pts[0];
  const b = pts[Math.min(sample, pts.length - 1)];
  const φ1 = toRad(a.latitude);
  const φ2 = toRad(b.latitude);
  const Δλ = toRad(b.longitude - a.longitude);
  const y = Math.sin(Δλ) * Math.cos(φ2);
  const x = Math.cos(φ1) * Math.sin(φ2) - Math.sin(φ1) * Math.cos(φ2) * Math.cos(Δλ);
  let θ = toDeg(Math.atan2(y, x));
  if (θ < 0) θ += 360;
  return θ;
}
function headingDiff(a, b) {
  if (a == null || b == null) return 0;
  let d = Math.abs(a - b);
  return d > 180 ? 360 - d : d;
}

/* ---------- Polyline Google ---------- */
function decodePolyline(str) {
  if (!str || typeof str !== "string") return [];
  let index = 0, lat = 0, lng = 0, coordinates = [];
  while (index < str.length) {
    let b, shift = 0, result = 0;
    do { b = str.charCodeAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
    const dlat = (result & 1) ? ~(result >> 1) : (result >> 1); lat += dlat;
    shift = 0; result = 0;
    do { b = str.charCodeAt(index++) - 63; result |= (b & 0x1f) << shift; shift += 5; } while (b >= 0x20);
    const dlng = (result & 1) ? ~(result >> 1) : (result >> 1); lng += dlng;
    coordinates.push({ latitude: lat / 1e5, longitude: lng / 1e5 });
  }
  return coordinates;
}

/* ---------- Directions REST (con alternativas) ---------- */
async function fetchDirectionsShortest({ o, d, mode, apikey, avoid, via }) {
  const origin = `${o.latitude},${o.longitude}`;
  const dest = `${d.latitude},${d.longitude}`;

  const params = new URLSearchParams({
    origin,
    destination: dest,
    mode: mode || "driving", // "driving" | "walking"
    alternatives: "true",
    key: apikey,
    departure_time: "now",
  });
  if (avoid) params.set("avoid", avoid);
  if (Array.isArray(via) && via.length) {
    const w = via.map((p) => `via:${p.latitude},${p.longitude}`).join("|");
    params.set("waypoints", w);
  }

  const url = `https://maps.googleapis.com/maps/api/directions/json?${params.toString()}`;
  const res = await fetch(url);
  const json = await res.json();

  if (json.status !== "OK" || !Array.isArray(json.routes) || json.routes.length === 0) {
    throw new Error(`Directions error: ${json.status}`);
  }

  // Elegimos la ruta con menor distancia
  let best = json.routes[0], bestDist = Number.POSITIVE_INFINITY;
  for (const r of json.routes) {
    const legs = Array.isArray(r.legs) ? r.legs : [];
    const total = legs.reduce((acc, leg) => acc + (leg?.distance?.value || 0), 0);
    if (total < bestDist) { best = r; bestDist = total; }
  }

  const poly = best?.overview_polyline?.points || "";
  const coordinates = decodePolyline(poly);
  return { coordinates, distanceMeters: bestDist };
}

/* ---------- Helpers seguros para Places ---------- */
const getLatLngFromDetails = (details) => {
  const lat = details?.geometry?.location?.lat;
  const lng = details?.geometry?.location?.lng;
  if (hasNumber(lat) && hasNumber(lng)) {
    return { latitude: lat, longitude: lng };
  }
  return null;
};
const safeApplyPlace = (details, setter, setRegionDefault) => {
  const loc = getLatLngFromDetails(details);
  if (!loc) {
    Alert.alert("Lugar inválido", "No se pudo obtener coordenadas de este resultado.");
    return;
  }
  setter(loc);
  if (typeof setRegionDefault === "function") {
    setRegionDefault((r = {}) => ({
      ...loc,
      latitudeDelta: r.latitudeDelta ?? 0.01,
      longitudeDelta: r.longitudeDelta ?? 0.01,
    }));
  }
};

/* ========== Componente principal ========== */
export default function MapScreen() {
  const navigation = useNavigation();
  const [origin, setOrigin] = useState();
  const [destination, setDestination] = useState();
  const [regionDefault, setRegionDefault] = useState({
    latitude: 14.624312,
    longitude: -90.565671,
    latitudeDelta: 0.01,
    longitudeDelta: 0.01,
  });

  const [segments, setSegments] = useState([]);   // <- ahora viene con parada_origen/parada_destino
  const [loadingRoute, setLoadingRoute] = useState(false);

  // Ubicación del usuario (opt-in)
  const [locationEnabled, setLocationEnabled] = useState(false);
  const [hasLocationPermission, setHasLocationPermission] = useState(false);
  const [userPos, setUserPos] = useState(null);
  const locationWatchRef = useRef(null);
  const [showTraffic, setShowTraffic] = useState(true);
  const [routeTimeMin, setRouteTimeMin] = useState(null);
  const [routeDistanceKm, setRouteDistanceKm] = useState(null);
  const [routeRemainingKm, setRouteRemainingKm] = useState(null);
  const [selectMode, setSelectMode] = useState('none'); // 'none' | 'origin' | 'destination'

  // Polilíneas por segmento (idx -> coordinates[])
  const [polyBySeg, setPolyBySeg] = useState({});
  const PREPEND_EXACT_ORIGIN = true;
  const APPEND_EXACT_DEST = true;

  // --- Tuning de selección (para evitar nudos) ---
  const VIA_METERS = 35;
  const MAX_WORSE_FACTOR = 1.04;
  const MAX_EXTRA_METERS = 120;
  const DISCARD_IF_HEADING_DIFF = 70;

  const SAME_ROAD_BIAS_ENABLED = true;

  const mapRef = useRef(null);

  const ICONS = {
    Caminar: require("../../src/img/transports/walk.png"),
    Camioneta: require("../../src/img/transports/camioneta.png"),
    Express: require("../../src/img/transports/express.png"),
    Transmetro: require("../../src/img/transports/transmetro.png"),
    Transurbano: require("../../src/img/transports/transurbano.png"),
    Tubus: require("../../src/img/transports/tubus.png"),
  };

  const mapMarkers = [
    { name: "Caminar", strokeColor: "#000000" },
    { name: "Camioneta", strokeColor: "#C62828" },
    { name: "Express", strokeColor: "#0288D1" },
    { name: "Transmetro", strokeColor: "#64DD17" },
    { name: "Transurbano", strokeColor: "#0D47A1" },
    { name: "Tubus", strokeColor: "#2E7D32" },
  ];

  const TRANSPORT_STYLE = useMemo(() => {
    const dict = {};
    for (const m of mapMarkers) {
      dict[m.name] = {
        strokeColor: m.strokeColor,
        icon: ICONS[m.name] ?? ICONS.Caminar,
      };
    }
    return dict;
  }, []);

  const GOOGLE_MAPS_APIKEY = "YOUR_GOOGLE_MAPS_API_KEY_HERE"; // <- Pon aquí tu API Key de Google Maps
  const API_URL = "API_BACKEND_URL_HERE"; // <- Pon aquí la URL de tu backend

  /* Ubicación inicial */
  useEffect(() => {
    (async () => {
      try {
        const { status } = await Location.requestForegroundPermissionsAsync();
        if (status !== "granted") return;
        const currentLocation = await Location.getCurrentPositionAsync({});
        const coord = {
          latitude: currentLocation.coords.latitude,
          longitude: currentLocation.coords.longitude,
        };
        setOrigin(coord);
        setRegionDefault((r) => ({
          ...coord,
          latitudeDelta: r.latitudeDelta,
          longitudeDelta: r.longitudeDelta,
        }));
      } catch (e) {
        console.log("getLocation error", e);
      }
    })();
  }, []);

  // Helpers para manejo de permiso/seguimiento de ubicación
  const ensureLocationPermission = async () => {
    try {
      const { status } = await Location.requestForegroundPermissionsAsync();
      const granted = status === "granted";
      setHasLocationPermission(granted);
      if (!granted) Alert.alert("Ubicación", "Se requiere permiso para mostrar tu ubicación.");
      return granted;
    } catch (e) {
      console.log("request permission error", e);
      return false;
    }
  };

  const startLocationWatch = async () => {
    if (!hasLocationPermission || locationWatchRef.current) return;
    try {
      const sub = await Location.watchPositionAsync(
        {
          accuracy: Location.Accuracy.High,
          distanceInterval: 5,
          timeInterval: 2000,
        },
        (loc) => {
          const p = { latitude: loc.coords.latitude, longitude: loc.coords.longitude };
          setUserPos(p);
          setOrigin((prev) => prev || p);
        }
      );
      locationWatchRef.current = sub;
    } catch (e) {
      console.log("watchPosition error", e);
    }
  };

  const stopLocationWatch = async () => {
    try {
      const sub = locationWatchRef.current;
      if (sub && typeof sub.remove === "function") sub.remove();
    } catch {}
    locationWatchRef.current = null;
  };

  const centerOnMyLocation = async () => {
    try {
      let granted = hasLocationPermission;
      if (!granted) granted = await ensureLocationPermission();
      if (!granted) return;
      setLocationEnabled(true);
      await startLocationWatch();
      const loc = await Location.getCurrentPositionAsync({ accuracy: Location.Accuracy.Balanced });
      const region = {
        latitude: loc.coords.latitude,
        longitude: loc.coords.longitude,
        latitudeDelta: 0.01,
        longitudeDelta: 0.01,
      };
      setUserPos({ latitude: region.latitude, longitude: region.longitude });
      setOrigin((prev) => prev || { latitude: region.latitude, longitude: region.longitude });
      if (mapRef.current) mapRef.current.animateToRegion(region, 500);
    } catch (e) {
      Alert.alert("Ubicación", "No se pudo obtener tu ubicación.");
    }
  };

  /* Llama a tu backend y carga segmentos */
  const onBuscarRutaRapida = async () => {
    if (!origin || !destination) {
      Alert.alert("Faltan puntos", "Selecciona Origen y Destino.");
      return;
    }
    if (
      !hasNumber(origin?.latitude) || !hasNumber(origin?.longitude) ||
      !hasNumber(destination?.latitude) || !hasNumber(destination?.longitude)
    ) {
      Alert.alert("Coordenadas inválidas", "Revisa Origen y Destino.");
      return;
    }

    try {
      setLoadingRoute(true);
      setSegments([]);
      setPolyBySeg({});

      const body = {
        origen: { latitud: origin.latitude, longitud: origin.longitude },
        destino: { latitud: destination.latitude, longitud: destination.longitude },
      };

      const res = await fetch(API_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });

      if (!res.ok) throw new Error(`Error API (${res.status})`);

      const data = await res.json();
      const received = Array.isArray(data?.ruta) ? data.ruta : [];
      const cleaned = (received || []).filter((s) =>
        hasNumber(s?.origen?.latitud) &&
        hasNumber(s?.origen?.longitud) &&
        hasNumber(s?.destino?.latitud) &&
        hasNumber(s?.destino?.longitud)
      );
      setSegments(cleaned);

      // Extrae tiempo estimado desde tu API si está disponible
      let apiMinutes = null;
      const maybeNumbers = [
        data?.tiempoMinutos,
        data?.tiempo_minutos,
        data?.tiempo_total_minutos,
        data?.duracionMinutos,
        data?.duracion_minutos,
        data?.minutos,
      ];
      for (const v of maybeNumbers) { if (hasNumber(v)) { apiMinutes = v; break; } }
      if (apiMinutes == null) {
        // Intenta sumar por segmentos si traen duración por tramo
        const sumSegMin = (cleaned || []).reduce((acc, s) =>
          acc + (s?.tiempoMin || s?.tiempo_min || s?.duracionMinutos || s?.duracion_minutos || 0)
        , 0);
        if (sumSegMin > 0) apiMinutes = sumSegMin;
      }
      setRouteTimeMin(apiMinutes ?? null);
    } catch (e) {
      console.error("Ruta rápida error:", e);
      Alert.alert("Ruta", "No se pudo obtener la ruta.");
    } finally {
      setLoadingRoute(false);
    }
  };

  function modeForTransport(transporte) {
    const t = String(transporte || "").toLowerCase();
    if (t === "caminar") return "WALKING";
    return "DRIVING";
  }
  function styleForTransport(transporte) {
    const def = { strokeColor: "#555555", icon: ICONS["Caminar"] };
    if (!transporte) return def;
    return TRANSPORT_STYLE[transporte] || def;
  }

  /* Polyline por segmento (probando base vs sesgada) */
  useEffect(() => {
    let cancelled = false;
    async function buildAll() {
      const next = {};
      for (let idx = 0; idx < (segments || []).length; idx++) {
        const seg = segments[idx] || {};
        const o = { latitude: seg?.origen?.latitud, longitude: seg?.origen?.longitud };
        const d = { latitude: seg?.destino?.latitud, longitude: seg?.destino?.longitud };
        if (![o, d].every(isValidCoord)) { next[idx] = []; continue; }

        const uxMode = modeForTransport(seg?.transporte);
        const apiMode = (uxMode || "DRIVING").toLowerCase();

        let base = null, biased = null;

        try {
          base = await fetchDirectionsShortest({
            o, d, mode: apiMode, apikey: GOOGLE_MAPS_APIKEY, avoid: seg?.avoid || undefined,
          });
        } catch (e) { console.log("base route error seg", idx, e); }

        try {
          if (SAME_ROAD_BIAS_ENABLED) {
            const brng = bearing(o, d);
            const forward = projectPoint(o, brng, VIA_METERS);
            biased = await fetchDirectionsShortest({
              o, d, mode: apiMode, apikey: GOOGLE_MAPS_APIKEY, via: [forward], avoid: seg?.avoid || undefined,
            });
          }
        } catch (e) { console.log("biased route error seg", idx, e); }

        let pick = base;
        if (biased && base && Array.isArray(biased.coordinates) && biased.coordinates.length > 1) {
          const hdgDest = bearing(o, d);
          const hdgBiased = firstHeading(biased.coordinates);
          const diff = headingDiff(hdgBiased, hdgDest);

          const notMuchWorse =
            biased.distanceMeters <= base.distanceMeters * MAX_WORSE_FACTOR ||
            (biased.distanceMeters - base.distanceMeters) <= MAX_EXTRA_METERS;

          pick = (diff <= DISCARD_IF_HEADING_DIFF && notMuchWorse) ? biased : base;
        }

        const baseCoords = Array.isArray(pick?.coordinates) ? pick.coordinates : [];
        const finalCoords = sanitizeCoordsArray([
          PREPEND_EXACT_ORIGIN ? o : null,
          ...baseCoords,
          APPEND_EXACT_DEST ? d : null,
        ]);
        next[idx] = finalCoords.length ? finalCoords : sanitizeCoordsArray([o, d]);
      }
      if (!cancelled) setPolyBySeg(next);
    }

    if ((segments || []).length) buildAll();
    else setPolyBySeg({});

    return () => { cancelled = true; };
  }, [segments]);

  /* Ajustar cámara */
  useEffect(() => {
    const vals = Object.values(polyBySeg || {});
    const allCoords = sanitizeCoordsArray(vals.flat ? vals.flat() : [].concat(...vals));
    if (allCoords.length > 1 && mapRef.current) {
      mapRef.current.fitToCoordinates(allCoords, {
        edgePadding: { top: 80, right: 80, bottom: 120, left: 80 },
        animated: true,
      });
    }
  }, [polyBySeg]);

  // Distancia total de la ruta (sumando cada polyline de segmento)
  useEffect(() => {
    const segs = polyBySeg || {};
    let total = 0;
    for (const k of Object.keys(segs)) {
      const coords = sanitizeCoordsArray(segs[k]);
      for (let i = 1; i < coords.length; i++) {
        total += haversine(coords[i - 1], coords[i]);
      }
    }
    setRouteDistanceKm(total > 0 ? total / 1000 : null);
  }, [polyBySeg]);

  // Distancia restante basada en polilíneas vivas (recortadas)
  useEffect(() => {
    const source = (livePolys && Object.keys(livePolys).length > 0) ? livePolys : polyBySeg;
    const segs = source || {};
    let total = 0;
    for (const k of Object.keys(segs)) {
      const coords = sanitizeCoordsArray(segs[k]);
      for (let i = 1; i < coords.length; i++) {
        total += haversine(coords[i - 1], coords[i]);
      }
    }
    setRouteRemainingKm(total > 0 ? total / 1000 : null);
  }, [livePolys, polyBySeg]);

  // Botón: centrar en la ruta actual pintada
  const centerOnRoute = () => {
    const source = (livePolys && Object.keys(livePolys).length > 0) ? livePolys : polyBySeg;
    const vals = Object.values(source || {});
    const allCoords = sanitizeCoordsArray(vals.flat ? vals.flat() : [].concat(...vals));
    if (allCoords.length > 1 && mapRef.current) {
      mapRef.current.fitToCoordinates(allCoords, {
        edgePadding: { top: 80, right: 80, bottom: 120, left: 80 },
        animated: true,
      });
    } else if (isValidCoord(origin) && isValidCoord(destination) && mapRef.current) {
      mapRef.current.fitToCoordinates([origin, destination], {
        edgePadding: { top: 80, right: 80, bottom: 120, left: 80 },
        animated: true,
      });
    } else if (isValidCoord(origin) && mapRef.current) {
      mapRef.current.animateToRegion({
        latitude: origin.latitude,
        longitude: origin.longitude,
        latitudeDelta: regionDefault.latitudeDelta,
        longitudeDelta: regionDefault.longitudeDelta,
      }, 500);
    }
  };

  // Centrar el mapa cuando haya origen y destino seleccionados (aunque no haya ruta aún)
  useEffect(() => {
    if (isValidCoord(origin) && isValidCoord(destination) && mapRef.current) {
      mapRef.current.fitToCoordinates([origin, destination], {
        edgePadding: { top: 80, right: 80, bottom: 120, left: 80 },
        animated: true,
      });
    }
  }, [origin, destination]);

  // Ruta en vivo: recorta los tramos ya recorridos por el usuario
  const [livePolys, setLivePolys] = useState({});

  useEffect(() => {
    if (!userPos || !polyBySeg || Object.keys(polyBySeg).length === 0) {
      setLivePolys(polyBySeg || {});
      return;
    }

    const keys = Object.keys(polyBySeg)
      .map((k) => Number(k))
      .sort((a, b) => a - b);
    const segStarts = {};
    let combined = [];
    for (const k of keys) {
      const arr = sanitizeCoordsArray(polyBySeg[k]);
      segStarts[k] = combined.length;
      combined = combined.concat(arr);
    }
    if (combined.length < 2) {
      setLivePolys(polyBySeg);
      return;
    }

    const globalIdx = closestPointIndex(combined, userPos);
    const PROXIMITY_M = 80;
    const nearestDist = haversine(combined[globalIdx], userPos);

    const updated = {};
    for (const k of keys) {
      const start = segStarts[k];
      const arr = sanitizeCoordsArray(polyBySeg[k]);
      const end = start + arr.length; // exclusivo

      if (nearestDist <= PROXIMITY_M) {
        if (globalIdx >= end) {
          updated[k] = [];
        } else if (globalIdx <= start) {
          updated[k] = arr;
        } else {
          const cut = Math.max(0, globalIdx - start);
          updated[k] = arr.slice(cut);
        }
      } else {
        updated[k] = arr;
      }
    }
    setLivePolys(updated);
  }, [userPos, polyBySeg]);

  // Inicia/detiene el watcher según preferencia del usuario
  useEffect(() => {
    (async () => {
      if (locationEnabled && hasLocationPermission) {
        await startLocationWatch();
      } else {
        await stopLocationWatch();
      }
    })();
    return () => { /* cleanup handled in stopLocationWatch */ };
  }, [locationEnabled, hasLocationPermission]);

  /* ========= NUEVO: lista de PARADAS ÚNICAS (para no repetir marcadores) ========= */
  const uniqueStops = useMemo(() => {
    const byKey = new Map();
    const add = (p) => {
      if (!p) return;
      const key = p.id ? `id:${p.id}` : `loc:${p.latitud},${p.longitud}`;
      if (!byKey.has(key)) {
        byKey.set(key, {
          id: p.id ?? null,
          nombre: p.nombre ?? "Parada",
          ruta: p.ruta ?? null,
          tipoTransporte: p.tipoTransporte ?? null,
          latitude: p.latitud,
          longitude: p.longitud,
        });
      }
    };
    (segments || []).forEach((seg) => {
      add(seg.parada_origen);
      add(seg.parada_destino);
    });
    return Array.from(byKey.values());
  }, [segments]);

  const quickNavItems = useMemo(
    () => [
      { route: "Map", label: "Mapa" },
      { route: "History", label: "Historial" },
      { route: "Favorites", label: "Favoritos" },
      { route: "Profile", label: "Perfil" },
    ],
    [],
  );

  const navState = navigation?.getState?.();
  const currentRouteName = navState?.routes?.[navState.index]?.name ?? "Map";

  /* ========= Render ========= */
  return (
    <View style={styles.container}>
      {/* Barra superior */}
      <View style={styles.placesBar}>
        {/* Origen */}
        <View style={{ flex: 1, marginRight: 8 }}>
          <GooglePlacesAutocomplete
            placeholder="Origen"
            fetchDetails
            enablePoweredByContainer={false}
            minLength={2}
            debounce={200}
            timeout={15000}
            keyboardShouldPersistTaps="handled"
            query={{ key: GOOGLE_MAPS_APIKEY, language: "es", components: "country:gt" }}
            predefinedPlaces={[]}
            predefinedPlacesAlwaysVisible={false}
            onFail={(e) => console.log("[Places Origen onFail]", e?.message || e)}
            onNotFound={() => console.log("[Places Origen onNotFound]")}
            onPress={(data, details = null) => {
              try {
                if (!details) {
                  Alert.alert("Origen", "No se recibieron detalles del lugar seleccionado.");
                  return;
                }
                safeApplyPlace(details, setOrigin, setRegionDefault);
              } catch (err) { console.log("[Places Origen onPress] error:", err); }
            }}
            textInputProps={{
              placeholderTextColor: "#888",
              returnKeyType: "search",
              style: { color: "#000", paddingVertical: 10, fontSize: 16 },
            }}
            styles={{
              container: { flex: 0, zIndex: 3000, elevation: 3000 },
              textInputContainer: {
                backgroundColor: "#fff",
                borderRadius: 8,
                paddingHorizontal: 8,
                paddingVertical: 4,
              },
              textInput: { backgroundColor: "transparent" },
              listView: {
                position: "absolute",
                top: 50,
                left: 0,
                right: 0,
                backgroundColor: "#fff",
                zIndex: 4000,
                elevation: 4000,
                borderRadius: 8,
                maxHeight: 280,
              },
              row: { paddingVertical: 10 },
              separator: { height: 1, backgroundColor: "#eee" },
            }}
          />
        </View>

        {/* Destino */}
        <View style={{ flex: 1, marginLeft: 8 }}>
          <GooglePlacesAutocomplete
            placeholder="Destino"
            fetchDetails
            enablePoweredByContainer={false}
            minLength={2}
            debounce={200}
            timeout={15000}
            keyboardShouldPersistTaps="handled"
            query={{ key: GOOGLE_MAPS_APIKEY, language: "es", components: "country:gt" }}
            predefinedPlaces={[]}
            predefinedPlacesAlwaysVisible={false}
            onFail={(e) => console.log("[Places Destino onFail]", e?.message || e)}
            onNotFound={() => console.log("[Places Destino onNotFound]")}
            onPress={(data, details = null) => {
              try {
                if (!details) {
                  Alert.alert("Destino", "No se recibieron detalles del lugar seleccionado.");
                  return;
                }
                const loc = getLatLngFromDetails(details);
                if (!loc) {
                  Alert.alert("Destino", "No se pudo obtener coordenadas de este resultado.");
                  return;
                }
                setDestination(loc);
              } catch (err) { console.log("[Places Destino onPress] error:", err); }
            }}
            textInputProps={{
              placeholderTextColor: "#888",
              returnKeyType: "search",
              style: { color: "#000", paddingVertical: 10, fontSize: 16 },
            }}
            styles={{
              container: { flex: 0, zIndex: 3000, elevation: 3000 },
              textInputContainer: {
                backgroundColor: "#fff",
                borderRadius: 8,
                paddingHorizontal: 8,
                paddingVertical: 4,
              },
              textInput: { backgroundColor: "transparent" },
              listView: {
                position: "absolute",
                top: 50,
                left: 0,
                right: 0,
                backgroundColor: "#fff",
                zIndex: 4000,
                elevation: 4000,
                borderRadius: 8,
                maxHeight: 280,
              },
              row: { paddingVertical: 10 },
              separator: { height: 1, backgroundColor: "#eee" },
            }}
          />
        </View>
      </View>

      {/* Botones */}
      <TouchableOpacity style={styles.searchBtn} onPress={onBuscarRutaRapida}>
        <Text style={styles.searchBtnText}>Buscar ruta rápida</Text>
      </TouchableOpacity>

      <TouchableOpacity style={styles.locBtn} onPress={centerOnMyLocation}>
        <Text style={styles.locBtnText}>Mi ubicación</Text>
      </TouchableOpacity>

      <TouchableOpacity style={styles.routeBtn} onPress={centerOnRoute}>
        <Text style={styles.routeBtnText}>Centrar ruta</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={styles.stopLocBtn}
        onPress={async () => { setLocationEnabled(false); await stopLocationWatch(); }}
      >
        <Text style={styles.stopLocBtnText}>Detener ubicación</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={styles.trafficBtn}
        onPress={() => setShowTraffic((v) => !v)}
      >
        <Text style={styles.trafficBtnText}>
          {showTraffic ? "Ocultar Trafico" : "Mostrar Trafico"}
        </Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={[styles.selectBtn, selectMode === 'origin' && styles.selectBtnActive]}
        onPress={() => setSelectMode((m) => (m === 'origin' ? 'none' : 'origin'))}
      >
        <Text style={styles.selectBtnText}>{selectMode === 'origin' ? 'Tap para ORIGEN' : 'Poner Origen'}</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={[styles.selectBtn, styles.selectBtnBelow, selectMode === 'destination' && styles.selectBtnActive]}
        onPress={() => setSelectMode((m) => (m === 'destination' ? 'none' : 'destination'))}
      >
        <Text style={styles.selectBtnText}>{selectMode === 'destination' ? 'Tap para DESTINO' : 'Poner Destino'}</Text>
      </TouchableOpacity>

      {/* Barra inferior de navegacion */}
      <View style={styles.bottomNav}>
        {quickNavItems.map((item) => {
          const isActive = item.route === currentRouteName;
          return (
            <TouchableOpacity
              key={item.route}
              style={[styles.navItem, isActive && styles.navItemActive]}
              onPress={() => {
                if (!isActive) {
                  navigation?.navigate && navigation.navigate(item.route);
                }
              }}
            >
              <Text style={[styles.navLabel, isActive && styles.navLabelActive]}>
                {item.label}
              </Text>
            </TouchableOpacity>
          );
        })}
      </View>
      {/* Mapa */}
      <MapView
        ref={mapRef}
        provider={PROVIDER_GOOGLE}
        style={styles.map}
        initialRegion={regionDefault}
        showsMyLocationButton
        showsUserLocation={!!locationEnabled && !!hasLocationPermission}
        showsTraffic={!!showTraffic}
        onPress={(e) => {
          try {
            const c = e?.nativeEvent?.coordinate;
            if (!isValidCoord(c)) return;
            let placed = false;
            if (selectMode === 'origin' || (selectMode === 'none' && !isValidCoord(origin))) {
              setOrigin(c);
              placed = true;
            } else if (selectMode === 'destination' || (selectMode === 'none' && !isValidCoord(destination))) {
              setDestination(c);
              placed = true;
            } else {
              // Si ambos existen y no hay modo, mover destino por defecto
              setDestination(c);
              placed = true;
            }
            if (placed) {
              setSelectMode('none');
              if (mapRef.current) {
                if (isValidCoord(origin) && isValidCoord(destination)) {
                  mapRef.current.fitToCoordinates([origin, destination], {
                    edgePadding: { top: 80, right: 80, bottom: 120, left: 80 },
                    animated: true,
                  });
                } else {
                  mapRef.current.animateToRegion({
                    latitude: c.latitude,
                    longitude: c.longitude,
                    latitudeDelta: regionDefault.latitudeDelta,
                    longitudeDelta: regionDefault.longitudeDelta,
                  }, 400);
                }
              }
            }
          } catch {}
        }}
      >
        {isValidCoord(origin) && <Marker coordinate={origin} title="Origen" />}
        {isValidCoord(destination) && <Marker coordinate={destination} title="Destino" />}

        {/* Polylines de cada segmento */}
        {Array.isArray(segments) &&
          segments.map((seg, idx) => {
            const o = { latitude: seg?.origen?.latitud, longitude: seg?.origen?.longitud };
            const d = { latitude: seg?.destino?.latitud, longitude: seg?.destino?.longitud };
            if (!isValidCoord(o) || !isValidCoord(d)) return null;

            const { strokeColor } = styleForTransport(seg?.transporte);
            const coords = sanitizeCoordsArray(livePolys[idx] ?? polyBySeg[idx]);

            return (
              <Polyline
                key={`poly-${idx}`}
                coordinates={coords.length > 1 ? coords : [o, d]}
                strokeWidth={5}
                strokeColor={strokeColor}
              />
            );
          })}

        {/* Marcadores ÚNICOS de paradas */}
        {uniqueStops.map((p) => {
          const icon =
            (p.tipoTransporte && ICONS[p.tipoTransporte]) || ICONS.Caminar;
          return (
            <Marker
              key={p.id ? `stop-${p.id}` : `stop-${p.latitude},${p.longitude}`}
              coordinate={{ latitude: p.latitude, longitude: p.longitude }}
              title={p.nombre || "Parada"}
              description={[
                p.ruta ? `${p.ruta}` : null,
                p.tipoTransporte ? `• ${p.tipoTransporte}` : null,
              ]
                .filter(Boolean)
                .join(" ")}
            >
              {icon ? (
                <Image
                  source={icon}
                  style={{ width: 28, height: 28, resizeMode: "contain" }}
                />
              ) : null}
            </Marker>
          );
        })}
      </MapView>

      {(!segments || segments.length === 0) && (
        <View style={styles.tip}>
          <Text style={styles.tipText}>
            Selecciona Origen y Destino y toca “Buscar ruta rápida”.
          </Text>
        </View>
      )}

      {loadingRoute && (
        <View style={styles.loading}>
          <ActivityIndicator size="large" />
        </View>
      )}

      {(routeTimeMin != null || routeDistanceKm != null || routeRemainingKm != null) && (
        <View style={styles.infoBadge}>
          <Text style={styles.infoBadgeText}>
            {routeTimeMin != null ? `Tiempo estimado: ${Math.round(routeTimeMin)} min` : ''}
            {(routeTimeMin != null && (routeDistanceKm != null || routeRemainingKm != null)) ? ' • ' : ''}
            {routeDistanceKm != null ? `Distancia: ${routeDistanceKm.toFixed(1)} km` : ''}
            {(routeDistanceKm != null && routeRemainingKm != null) ? ' • ' : (routeTimeMin == null && routeRemainingKm != null && routeDistanceKm == null ? '' : '')}
            {routeRemainingKm != null ? `Restante: ${routeRemainingKm.toFixed(1)} km` : ''}
          </Text>
        </View>
      )}
    </View>
  );
}

/* ========== Estilos ========== */
const styles = StyleSheet.create({
  container: {
    ...StyleSheet.absoluteFillObject,
    flex: 1,
    justifyContent: "flex-start",
    alignItems: "center",
  },
  placesBar: {
    position: "absolute",
    top: 10,
    left: 10,
    right: 10,
    zIndex: 3000,
    flexDirection: "row",
  },
  searchBtn: {
    position: "absolute",
    top: 80,
    left: 10,
    right: 10,
    height: 44,
    backgroundColor: "#1e88e5",
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
    zIndex: 2000,
    elevation: 8,
  },
  searchBtnText: { color: "#fff", fontWeight: "bold" },
  locBtn: {
    position: "absolute",
    top: 130,
    right: 10,
    height: 40,
    paddingHorizontal: 12,
    backgroundColor: "#ffa100",
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
    zIndex: 2000,
    elevation: 8,
  },
  locBtnText: { color: "#000", fontWeight: "bold" },
  stopLocBtn: {
    position: "absolute",
    top: 180,
    right: 10,
    height: 40,
    paddingHorizontal: 12,
    backgroundColor: "#D32F2F",
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
    zIndex: 2000,
    elevation: 8,
  },
  stopLocBtnText: { color: "#fff", fontWeight: "bold" },
  routeBtn: {
    position: "absolute",
    top: 270,
    right: 10,
    height: 40,
    paddingHorizontal: 12,
    backgroundColor: "#3F51B5",
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
    zIndex: 2000,
    elevation: 8,
  },
  routeBtnText: { color: "#fff", fontWeight: "bold" },
  trafficBtn: {
    position: "absolute",
    top: 220,
    right: 10,
    height: 40,
    paddingHorizontal: 12,
    backgroundColor: "#4CAF50",
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
    zIndex: 2000,
    elevation: 8,
  },
  trafficBtnText: { color: "#fff", fontWeight: "bold" },
  bottomNav: {
    position: "absolute",
    left: 10,
    right: 10,
    bottom: 20,
    paddingVertical: 10,
    paddingHorizontal: 12,
    borderRadius: 16,
    backgroundColor: "rgba(20,20,32,0.95)",
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    zIndex: 2200,
    elevation: 12,
  },
  navItem: {
    flex: 1,
    marginHorizontal: 6,
    paddingVertical: 8,
    borderRadius: 12,
    alignItems: "center",
  },
  navItemActive: {
    backgroundColor: "rgba(255,161,0,0.25)",
  },
  navLabel: {
    color: "#d7d9e0",
    fontSize: 13,
    fontWeight: "600",
  },
  navLabelActive: {
    color: "#ffa100",
  },
  selectBtn: {
    position: "absolute",
    top: 320,
    right: 10,
    height: 40,
    paddingHorizontal: 12,
    backgroundColor: "#009688",
    borderRadius: 10,
    alignItems: "center",
    justifyContent: "center",
    zIndex: 2000,
    elevation: 8,
  },
  selectBtnBelow: {
    top: 370,
  },
  selectBtnActive: {
    backgroundColor: "#00695C",
  },
  selectBtnText: { color: "#fff", fontWeight: "bold" },
  map: { ...StyleSheet.absoluteFillObject },
  tip: {
    position: "absolute",
    bottom: 20,
    left: 10,
    right: 10,
    backgroundColor: "rgba(0,0,0,0.55)",
    paddingVertical: 10,
    paddingHorizontal: 14,
    borderRadius: 10,
  },
  tipText: { color: "#fff", textAlign: "center" },
  loading: {
    position: "absolute",
    bottom: 80,
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 12,
    backgroundColor: "rgba(0,0,0,0.6)",
  },
  infoBadge: {
    position: "absolute",
    bottom: 20,
    left: 10,
    right: 10,
    backgroundColor: "rgba(0,0,0,0.6)",
    paddingVertical: 10,
    paddingHorizontal: 14,
    borderRadius: 10,
  },
  infoBadgeText: { color: "#fff", textAlign: "center", fontWeight: "bold" },
});
