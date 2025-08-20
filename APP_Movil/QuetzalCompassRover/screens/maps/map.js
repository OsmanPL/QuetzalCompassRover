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
import MapView, { PROVIDER_GOOGLE, Marker } from "react-native-maps";
import MapViewDirections from "react-native-maps-directions";
import { GooglePlacesAutocomplete } from "react-native-google-places-autocomplete";
import * as Location from "expo-location";

export default function MapScreen() {
  const [origin, setOrigin] = useState();
  const [destination, setDestination] = useState();
  const [regionDefault, setRegionDefault] = useState({
    latitude: 14.624312,
    longitude: -90.565671,
    latitudeDelta: 0.01,
    longitudeDelta: 0.01,
  });

  const [isPlacesOpen, setIsPlacesOpen] = useState(false);
  const [segments, setSegments] = useState([]);
  const [loadingRoute, setLoadingRoute] = useState(false);

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
      dict[m.name] = { strokeColor: m.strokeColor, icon: ICONS[m.name] ?? ICONS.Caminar };
    }
    return dict;
  }, []);

  const GOOGLE_MAPS_APIKEY = "API_KEY"; // Places + Directions habilitadas
  const API_URL = "API_URL"; // URL del servicio backend

  const hasNumber = (n) => typeof n === "number" && !Number.isNaN(n);

  // Obtener ubicación para centrar mapa (el mapa se ve aun si falla)
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
        setRegionDefault((r) => ({ ...coord, latitudeDelta: r.latitudeDelta, longitudeDelta: r.longitudeDelta }));
      } catch (e) {
        console.log("getLocation error", e);
      }
    })();
  }, []);

  const centerOnMyLocation = async () => {
    try {
      const loc = await Location.getCurrentPositionAsync({});
      const region = {
        latitude: loc.coords.latitude,
        longitude: loc.coords.longitude,
        latitudeDelta: 0.01,
        longitudeDelta: 0.01,
      };
      setOrigin({ latitude: region.latitude, longitude: region.longitude });
      if (mapRef.current) mapRef.current.animateToRegion(region, 500);
    } catch (e) {
      Alert.alert("Ubicación", "No se pudo obtener tu ubicación.");
    }
  };

  const onBuscarRutaRapida = async () => {
    if (!origin || !destination) {
      Alert.alert("Faltan puntos", "Selecciona Origen y Destino.");
      return;
    }
    if (
      !hasNumber(origin.latitude) || !hasNumber(origin.longitude) ||
      !hasNumber(destination.latitude) || !hasNumber(destination.longitude)
    ) {
      Alert.alert("Coordenadas inválidas", "Revisa Origen y Destino.");
      return;
    }

    try {
      setLoadingRoute(true);
      setSegments([]);

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
      const cleaned = received.filter(
        (s) =>
          hasNumber(s?.origen?.latitud) &&
          hasNumber(s?.origen?.longitud) &&
          hasNumber(s?.destino?.latitud) &&
          hasNumber(s?.destino?.longitud)
      );
      setSegments(cleaned);

      const coords = [];
      cleaned.forEach((s) => {
        coords.push({ latitude: s.origen.latitud, longitude: s.origen.longitud });
        coords.push({ latitude: s.destino.latitud, longitude: s.destino.longitud });
      });
      if (coords.length > 0 && mapRef.current) {
        setTimeout(() => {
          mapRef.current.fitToCoordinates(coords, {
            edgePadding: { top: 80, right: 80, bottom: 120, left: 80 },
            animated: true,
          });
        }, 300);
      }
    } catch (e) {
      console.error("Ruta rápida error:", e);
      Alert.alert("Ruta", "No se pudo obtener la ruta.");
    } finally {
      setLoadingRoute(false);
    }
  };

  function modeForTransport(transporte) {
    if (!transporte) return "DRIVING";
    const t = String(transporte).toLowerCase();
    if (t === "caminar") return "WALKING";
    if (["express", "transmetro", "transurbano", "tubus", "camioneta"].some((x) => t.includes(x))) {
      return "TRANSIT";
    }
    return "DRIVING";
  }

  function styleForTransport(transporte) {
    const def = { strokeColor: "#555555", icon: ICONS["Caminar"] };
    if (!transporte) return def;
    return TRANSPORT_STYLE[transporte] || def;
  }

  return (
    <View style={styles.container}>
      {/* Barra superior: Autocompletes siempre visibles */}
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
            onTimeout={() => console.log("Places timeout (Origen)")}
            keyboardShouldPersistTaps="handled"
            predefinedPlaces={[]}
            predefinedPlacesAlwaysVisible={true}
            query={{ key: GOOGLE_MAPS_APIKEY, language: "es" }}
            onFail={(e) => console.log("[Places Origen onFail]", e)}
            onNotFound={() => console.log("[Places Origen onNotFound]")}
            onPress={(data, details = null) => {
              const lat = details?.geometry?.location?.lat;
              const lng = details?.geometry?.location?.lng;
              if (hasNumber(lat) && hasNumber(lng)) {
                const loc = { latitude: lat, longitude: lng };
                setOrigin(loc);
                setRegionDefault({ ...loc, latitudeDelta: regionDefault.latitudeDelta, longitudeDelta: regionDefault.longitudeDelta });
              }
              setIsPlacesOpen(false);
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
            onTimeout={() => console.log("Places timeout (Destino)")}
            keyboardShouldPersistTaps="handled"
            predefinedPlaces={[]}
            predefinedPlacesAlwaysVisible={false}
            query={{ key: GOOGLE_MAPS_APIKEY, language: "es" }}
            onFail={(e) => console.log("[Places Destino onFail]", e)}
            onNotFound={() => console.log("[Places Destino onNotFound]")}
            onPress={(data, details = null) => {
              const lat = details?.geometry?.location?.lat;
              const lng = details?.geometry?.location?.lng;
              if (hasNumber(lat) && hasNumber(lng)) {
                setDestination({ latitude: lat, longitude: lng });
              }
              setIsPlacesOpen(false);
            }}
            textInputProps={{
              placeholderTextColor: "#888",
              returnKeyType: "search",
              onFocus: () => setIsPlacesOpen(true),
              onBlur: () => setIsPlacesOpen(false),
              onChangeText: (t) => setIsPlacesOpen((t?.length ?? 0) >= 2),
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

      {/* Botones flotantes */}
      <TouchableOpacity style={styles.searchBtn} onPress={onBuscarRutaRapida}>
        <Text style={styles.searchBtnText}>Buscar ruta rápida</Text>
      </TouchableOpacity>

      <TouchableOpacity style={styles.locBtn} onPress={centerOnMyLocation}>
        <Text style={styles.locBtnText}>Mi ubicación</Text>
      </TouchableOpacity>

      {/* Mapa SIEMPRE visible: initialRegion + region */}
      <MapView
        //ref={mapRef}
        //provider={PROVIDER_GOOGLE}
        style={styles.map}
        initialRegion={regionDefault}    
        showsMyLocationButton
      >
        {origin && hasNumber(origin.latitude) && hasNumber(origin.longitude) && (
          <Marker coordinate={origin} title="Origen" />
        )}
        {destination && hasNumber(destination.latitude) && hasNumber(destination.longitude) && (
          <Marker coordinate={destination} title="Destino" />
        )}

        {/* Dibuja solo si hay segmentos válidos */}
        {segments.map((seg, idx) => {
          const o = { latitude: seg?.origen?.latitud, longitude: seg?.origen?.longitud };
          const d = { latitude: seg?.destino?.latitud, longitude: seg?.destino?.longitud };
          if (!hasNumber(o.latitude) || !hasNumber(o.longitude) || !hasNumber(d.latitude) || !hasNumber(d.longitude)) {
            return null;
          }
          const { strokeColor, icon } = styleForTransport(seg?.transporte);
          const mode = modeForTransport(seg?.transporte);
          return (
            <React.Fragment key={`seg-${idx}`}>
              <MapViewDirections
                origin={o}
                destination={d}
                apikey={GOOGLE_MAPS_APIKEY}
                strokeWidth={5}
                strokeColor={strokeColor}
                mode={mode}
              />
              <Marker
                coordinate={d}
                title={seg?.parada || seg?.ruta || seg?.transporte}
                description={`${seg?.ruta ?? ""} • ${seg?.transporte ?? ""}`}
              >
                {icon ? <Image source={icon} style={{ width: 28, height: 28, resizeMode: "contain" }} /> : null}
              </Marker>
            </React.Fragment>
          );
        })}
      </MapView>

      {/* Tip visual cuando no hay ruta aún */}
      {segments.length === 0 && (
        <View style={styles.tip}>
          <Text style={styles.tipText}>Selecciona Origen y Destino y toca “Buscar ruta rápida”.</Text>
        </View>
      )}

      {loadingRoute && (
        <View style={styles.loading}>
          <ActivityIndicator size="large" />
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { ...StyleSheet.absoluteFillObject, flex: 1, justifyContent: "flex-start", alignItems: "center" },
  placesBar: {
    position: "absolute", top: 10, left: 10, right: 10, zIndex: 3000,
    flexDirection: "row",
  },
  searchBtn: {
    position: "absolute", top: 80, left: 10, right: 10, height: 44,
    backgroundColor: "#1e88e5", borderRadius: 10, alignItems: "center", justifyContent: "center",
    zIndex: 2000, elevation: 8,
  },
  searchBtnText: { color: "#fff", fontWeight: "bold" },
  locBtn: {
    position: "absolute", top: 130, right: 10, height: 40, paddingHorizontal: 12,
    backgroundColor: "#ffa100", borderRadius: 10, alignItems: "center", justifyContent: "center",
    zIndex: 2000, elevation: 8,
  },
  locBtnText: { color: "#000", fontWeight: "bold" },
  map: {...StyleSheet.absoluteFillObject},
  tip: {
    position: "absolute", bottom: 20, left: 10, right: 10,
    backgroundColor: "rgba(0,0,0,0.55)", paddingVertical: 10, paddingHorizontal: 14, borderRadius: 10,
  },
  tipText: { color: "#fff", textAlign: "center" },
  loading: {
    position: "absolute", bottom: 80, paddingVertical: 12, paddingHorizontal: 16,
    borderRadius: 12, backgroundColor: "rgba(0,0,0,0.6)",
  },
});
