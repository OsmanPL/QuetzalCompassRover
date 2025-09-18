import React, { useCallback, useEffect, useMemo, useState } from "react";
import { View, Text, StyleSheet, FlatList, RefreshControl, TouchableOpacity } from "react-native";
import { DEST_API_BASE } from "../../src/config/api.js";
import { useAuth } from "../../src/context/AuthContext.js";

export default function HistoryScreen({ navigation }) {
  const { token, signOut } = useAuth();
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(false);

  const authHeaders = useMemo(() => {
    if (!token) return {};
    return { Authorization: `Bearer ${token}` };
  }, [token]);

  const ensureAuthenticated = useCallback((status) => {
    if (status === 401 || status === 403) {
      signOut();
      navigation.reset({ index: 0, routes: [{ name: "Login" }] });
      return false;
    }
    return true;
  }, [navigation, signOut]);

  const load = useCallback(async () => {
    if (!token) return;
    try {
      setLoading(true);
      const res = await fetch(`${DEST_API_BASE}/user/history?limit=50`, {
        headers: authHeaders,
      });
      if (!ensureAuthenticated(res.status)) return;
      const json = await res.json();
      setItems(Array.isArray(json) ? json : []);
    } catch (e) {
      console.log("Error cargando historial", e);
    } finally {
      setLoading(false);
    }
  }, [token, authHeaders, ensureAuthenticated]);

  useEffect(() => {
    if (!token) {
      navigation.reset({ index: 0, routes: [{ name: "Login" }] });
      return;
    }
    load();
  }, [token, load, navigation]);

  const addToFavorites = async (item) => {
    if (!token) return;
    try {
      const res = await fetch(`${DEST_API_BASE}/user/favorites`, {
        method: "POST",
        headers: { ...authHeaders, "Content-Type": "application/json" },
        body: JSON.stringify({
          nombre: item?.nombre ?? null,
          direccion: item?.direccion ?? null,
          latitud: item.latitud,
          longitud: item.longitud,
        }),
      });
      ensureAuthenticated(res.status);
    } catch (e) {
      console.log("Error agregando a favoritos", e);
    }
  };

  const renderItem = ({ item }) => (
    <TouchableOpacity
      style={styles.card}
      onPress={() => navigation.navigate('Map', {
        selectedDestination: {
          latitude: item.latitud,
          longitude: item.longitud,
          nombre: item?.nombre ?? null,
          direccion: item?.direccion ?? null,
        }
      })}
    >
      <View style={{ flex: 1 }}>
        <Text style={styles.title}>{item?.nombre || item?.direccion || "Destino"}</Text>
        <Text style={styles.subtitle}>{item?.direccion || `(${item.latitud.toFixed(5)}, ${item.longitud.toFixed(5)})`}</Text>
        <Text style={styles.meta}>#{item.id} | {new Date(item.creado_en).toLocaleString()}</Text>
      </View>
      <TouchableOpacity style={styles.action} onPress={() => addToFavorites(item)}>
        <Text style={styles.actionText}>*</Text>
      </TouchableOpacity>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <FlatList
        data={items}
        keyExtractor={(it) => String(it.id)}
        renderItem={renderItem}
        contentContainerStyle={{ padding: 12 }}
        refreshControl={<RefreshControl refreshing={loading} onRefresh={load} />}
        ListEmptyComponent={!loading ? (
          <Text style={styles.empty}>No hay historial aun.</Text>
        ) : null}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#0b0b0f" },
  card: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "#141420",
    padding: 12,
    borderRadius: 12,
    marginBottom: 10,
  },
  title: { color: "#fff", fontWeight: "700", fontSize: 16 },
  subtitle: { color: "#b6b6c2", marginTop: 4, fontSize: 13 },
  meta: { color: "#7b7b8c", marginTop: 6, fontSize: 12 },
  action: { paddingHorizontal: 10, paddingVertical: 6 },
  actionText: { color: "#ffd54f", fontSize: 20 },
  empty: { color: "#b6b6c2", textAlign: "center", marginTop: 40 },
});
