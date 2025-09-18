import React, { useCallback, useMemo, useState } from "react";
import {
  ActivityIndicator,
  RefreshControl,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import { useFocusEffect } from "@react-navigation/native";
import { USER_API_BASE } from "../../src/config/api.js";
import { useAuth } from "../../src/context/AuthContext.js";

const INITIAL_FORM = Object.freeze({
  nombre: "",
  apellido: "",
  telefono: "",
  direccion: "",
  password: "",
  confirm: "",
});

export default function ProfileScreen({ navigation }) {
  const { token, user, signOut } = useAuth();
  const [profileId, setProfileId] = useState(null);
  const [username, setUsername] = useState("");
  const [correo, setCorreo] = useState("");
  const [tipo, setTipo] = useState(null);
  const [form, setForm] = useState(INITIAL_FORM);
  const [loading, setLoading] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState(null);
  const [successMessage, setSuccessMessage] = useState(null);

  const authHeaders = useMemo(() => {
    if (!token) return {};
    return { Authorization: `Bearer ${token}` };
  }, [token]);

  const ensureAuthenticated = useCallback(
    (status) => {
      if (status === 401 || status === 403) {
        signOut();
        navigation.reset({ index: 0, routes: [{ name: "Login" }] });
        return false;
      }
      return true;
    },
    [navigation, signOut],
  );

  const hydrateForm = useCallback((payload) => {
    if (!payload) return;
    setProfileId(payload.id ?? null);
    setUsername(payload.username || "");
    setCorreo(payload.correo || "");
    setTipo(payload.tipo ?? null);

    const telefono = payload.telefono != null ? String(payload.telefono) : "";
    const fullName = String(payload.nombre ?? "").trim();
    let firstName = fullName;
    let lastName = "";
    if (fullName) {
      const parts = fullName.split(/\s+/);
      if (parts.length > 1) {
        lastName = parts.pop();
        firstName = parts.join(" ");
      }
    } else {
      firstName = "";
    }

    setForm({
      nombre: firstName,
      apellido: lastName,
      telefono,
      direccion: "",
      password: "",
      confirm: "",
    });
  }, []);

  const loadProfile = useCallback(
    async (silent = false) => {
      if (!token) return;
      if (!silent) {
        setLoading(true);
        setSuccessMessage(null);
      }
      setError(null);
      try {
        const res = await fetch(`${USER_API_BASE}/get/Usuario`, {
          headers: authHeaders,
        });
        if (!ensureAuthenticated(res.status)) return;
        const json = await res.json().catch(() => ({}));
        const record = Array.isArray(json?.data) ? json.data[0] : null;
        if (!record) {
          setError("No fue posible obtener tu perfil.");
          return;
        }
        hydrateForm(record);
      } catch (err) {
        console.log("Error cargando perfil", err);
        setError("No fue posible obtener tu perfil.");
      } finally {
        if (!silent) setLoading(false);
      }
    },
    [token, authHeaders, ensureAuthenticated, hydrateForm],
  );

  useFocusEffect(
    useCallback(() => {
      if (!token) {
        navigation.reset({ index: 0, routes: [{ name: "Login" }] });
        return;
      }
      loadProfile();
    }, [token, navigation, loadProfile]),
  );

  const onRefresh = useCallback(async () => {
    setRefreshing(true);
    await loadProfile(true);
    setRefreshing(false);
  }, [loadProfile]);

  const updateField = useCallback((key, value) => {
    setForm((prev) => ({ ...prev, [key]: value }));
    setError(null);
    setSuccessMessage(null);
  }, []);

  const validate = useCallback(() => {
    if (form.password && form.password.length < 8) {
      return "La contrasena debe tener al menos 8 caracteres.";
    }
    if (form.password && form.password !== form.confirm) {
      return "Las contrasenas no coinciden.";
    }
    if (form.telefono) {
      const digits = form.telefono.replace(/[^0-9]/g, "");
      if (digits.length < 8) {
        return "El telefono es demasiado corto.";
      }
    }
    return null;
  }, [form]);

  const onSave = useCallback(async () => {
    if (!token) {
      navigation.reset({ index: 0, routes: [{ name: "Login" }] });
      return;
    }
    const validation = validate();
    if (validation) {
      setError(validation);
      return;
    }

    const payload = {};
    if (profileId) payload.idCliente = profileId;
    if (form.nombre.trim()) payload.nombre = form.nombre.trim();
    if (form.apellido.trim()) payload.apellido = form.apellido.trim();
    if (form.telefono.trim()) payload.telefono = form.telefono.trim();
    if (form.direccion.trim()) payload.direccion = form.direccion.trim();
    if (form.password.trim()) payload.password = form.password.trim();

    if (!payload.idCliente && Object.keys(payload).length === 0) {
      setError("No hay cambios para guardar.");
      return;
    }
    if (payload.idCliente && Object.keys(payload).length === 1) {
      setError("Ingresa algun dato para actualizar.");
      return;
    }

    setSaving(true);
    setError(null);
    setSuccessMessage(null);
    try {
      const res = await fetch(`${USER_API_BASE}/update/User`, {
        method: "POST",
        headers: { ...authHeaders, "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      if (!ensureAuthenticated(res.status)) return;
      const json = await res.json().catch(() => ({}));
      if (!res.ok) {
        const message = json?.resultado || json?.message || "No fue posible actualizar tu perfil.";
        setError(message);
        return;
      }
      setSuccessMessage(json?.resultado || "Perfil actualizado exitosamente.");
      setForm((prev) => ({ ...prev, password: "", confirm: "" }));
      await loadProfile(true);
    } catch (err) {
      console.log("Error actualizando perfil", err);
      setError("No fue posible actualizar tu perfil.");
    } finally {
      setSaving(false);
    }
  }, [
    token,
    validate,
    form,
    profileId,
    authHeaders,
    ensureAuthenticated,
    navigation,
    loadProfile,
  ]);

  const readableTipo = useMemo(() => {
    if (tipo === 1) return "Administrador";
    if (tipo === 2) return "Cliente";
    if (tipo === 3) return "Piloto";
    if (tipo == null) return "Desconocido";
    return `Tipo ${tipo}`;
  }, [tipo]);

  const initials = useMemo(() => {
    const value = form.nombre || user?.nombre || username || "U";
    return value.trim().charAt(0).toUpperCase();
  }, [form.nombre, user, username]);

  return (
    <View style={styles.container}>
      <ScrollView
        contentContainerStyle={styles.scrollContent}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor="#ffa100" />
        }
      >
        <View style={styles.headerCard}>
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>{initials}</Text>
          </View>
          <View style={{ flex: 1 }}>
            <Text style={styles.nameText}>{form.nombre || user?.nombre || username || "Usuario"}</Text>
            <Text style={styles.secondaryText}>{correo || user?.correo || "correo@ejemplo.com"}</Text>
            <Text style={styles.badge}>{readableTipo}</Text>
          </View>
        </View>

        {loading ? (
          <View style={styles.loadingContainer}>
            <ActivityIndicator size="small" color="#ffa100" />
          </View>
        ) : null}

        {error ? <Text style={styles.errorText}>{error}</Text> : null}
        {successMessage ? <Text style={styles.successText}>{successMessage}</Text> : null}

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Informacion personal</Text>

          <Text style={styles.label}>Nombre</Text>
          <TextInput
            style={styles.input}
            placeholder="Nombre"
            placeholderTextColor="#9aa0a6"
            value={form.nombre}
            onChangeText={(text) => updateField("nombre", text)}
          />

          <Text style={styles.label}>Apellido</Text>
          <TextInput
            style={styles.input}
            placeholder="Apellido"
            placeholderTextColor="#9aa0a6"
            value={form.apellido}
            onChangeText={(text) => updateField("apellido", text)}
          />

          <Text style={styles.label}>Telefono</Text>
          <TextInput
            style={styles.input}
            placeholder="55555555"
            placeholderTextColor="#9aa0a6"
            value={form.telefono}
            onChangeText={(text) => updateField("telefono", text)}
            keyboardType="phone-pad"
          />

          <Text style={styles.label}>Direccion</Text>
          <TextInput
            style={[styles.input, { height: 90, textAlignVertical: "top" }]}
            placeholder="Direccion de referencia"
            placeholderTextColor="#9aa0a6"
            value={form.direccion}
            onChangeText={(text) => updateField("direccion", text)}
            multiline
            numberOfLines={3}
          />
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Cambiar contrasena</Text>

          <Text style={styles.label}>Nueva contrasena</Text>
          <TextInput
            style={styles.input}
            placeholder="Minimo 8 caracteres"
            placeholderTextColor="#9aa0a6"
            value={form.password}
            onChangeText={(text) => updateField("password", text)}
            secureTextEntry
          />

          <Text style={styles.label}>Confirmar contrasena</Text>
          <TextInput
            style={styles.input}
            placeholder="Repite tu nueva contrasena"
            placeholderTextColor="#9aa0a6"
            value={form.confirm}
            onChangeText={(text) => updateField("confirm", text)}
            secureTextEntry
          />
        </View>

        <TouchableOpacity
          style={[styles.saveButton, saving ? styles.saveButtonDisabled : null]}
          onPress={onSave}
          disabled={saving}
        >
          {saving ? (
            <ActivityIndicator size="small" color="#000" />
          ) : (
            <Text style={styles.saveButtonText}>Guardar cambios</Text>
          )}
        </TouchableOpacity>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#0b0b0f" },
  scrollContent: { padding: 16, paddingBottom: 40 },
  headerCard: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "#141420",
    padding: 16,
    borderRadius: 16,
    marginBottom: 18,
  },
  avatar: {
    width: 56,
    height: 56,
    borderRadius: 28,
    backgroundColor: "#1f1f2e",
    alignItems: "center",
    justifyContent: "center",
    marginRight: 14,
  },
  avatarText: { color: "#ffa100", fontSize: 24, fontWeight: "bold" },
  nameText: { color: "#fff", fontSize: 18, fontWeight: "700" },
  secondaryText: { color: "#b6b6c2", marginTop: 4 },
  badge: {
    marginTop: 8,
    alignSelf: "flex-start",
    backgroundColor: "#1e88e5",
    color: "#fff",
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 12,
    fontSize: 12,
    fontWeight: "600",
  },
  loadingContainer: { marginBottom: 12 },
  errorText: { color: "#ff6b6b", marginBottom: 12, textAlign: "center" },
  successText: { color: "#1ecb5c", marginBottom: 12, textAlign: "center" },
  section: {
    backgroundColor: "#141420",
    padding: 16,
    borderRadius: 16,
    marginBottom: 18,
  },
  sectionTitle: { color: "#fff", fontSize: 16, fontWeight: "700", marginBottom: 12 },
  label: { color: "#d7d9e0", marginBottom: 6, marginTop: 10 },
  input: {
    backgroundColor: "#fff",
    borderRadius: 10,
    paddingHorizontal: 12,
    paddingVertical: 12,
    fontSize: 15,
    color: "#111",
  },
  saveButton: {
    backgroundColor: "#ffa100",
    paddingVertical: 14,
    borderRadius: 14,
    alignItems: "center",
  },
  saveButtonDisabled: { opacity: 0.7 },
  saveButtonText: { color: "#000", fontWeight: "bold", fontSize: 16 },
});
