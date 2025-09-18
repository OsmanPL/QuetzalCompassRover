import React from "react";
import {
  Alert,
  Dimensions,
  KeyboardAvoidingView,
  Platform,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import { Button } from "react-native-elements";
import { useAuth } from "../../src/context/AuthContext.js";

const { width, height } = Dimensions.get("window");
const wp = (p) => (width * p) / 100;
const hp = (p) => (height * p) / 100;

function normalize(value) {
  return String(value ?? "").trim();
}

function validateForm({ nombre, usuario, correo, password, confirm, cel }) {
  if (!nombre) return "Ingresa tu nombre";
  if (!usuario || usuario.length < 3) return "El usuario debe tener al menos 3 caracteres";
  const email = correo.toLowerCase();
  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return "Ingresa un correo valido";
  if (!password || password.length < 8) return "La contrasena debe tener al menos 8 caracteres";
  if (password !== confirm) return "Las contrasenas no coinciden";
  const phone = cel.replace(/[^0-9]/g, "");
  if (!phone) return "Ingresa un numero de telefono";
  if (phone.length < 8) return "El telefono es muy corto";
  return null;
}

export default function RegisterScreen({ navigation }) {
  const { signUp } = useAuth();
  const [form, setForm] = React.useState({
    nombre: "",
    usuario: "",
    correo: "",
    cel: "",
    password: "",
    confirm: "",
  });
  const [submitting, setSubmitting] = React.useState(false);
  const [error, setError] = React.useState(null);

  const updateField = React.useCallback((key, value) => {
    setForm((prev) => ({ ...prev, [key]: value }));
    setError(null);
  }, []);

  const onSubmit = React.useCallback(async () => {
    const trimmed = {
      nombre: normalize(form.nombre),
      usuario: normalize(form.usuario),
      correo: normalize(form.correo),
      password: form.password,
      confirm: form.confirm,
      cel: normalize(form.cel),
    };
    const validation = validateForm(trimmed);
    if (validation) {
      setError(validation);
      return;
    }
    const payload = {
      nombre: trimmed.nombre,
      usuario: trimmed.usuario,
      correo: trimmed.correo.toLowerCase(),
      pass: trimmed.password,
      cel: trimmed.cel.replace(/[^0-9]/g, ""),
      tipo: 2,
    };
    setSubmitting(true);
    try {
      const result = await signUp(payload);
      if (!result.success) {
        setError(result.message || "No fue posible registrar la cuenta");
        return;
      }
      setError(null);
      Alert.alert("Cuenta creada", result.message || "Usuario registrado exitosamente.", [
        {
          text: "Iniciar sesion",
          onPress: () => navigation.replace("Login"),
        },
      ]);
      setForm({ nombre: "", usuario: "", correo: "", cel: "", password: "", confirm: "" });
    } finally {
      setSubmitting(false);
    }
  }, [form, navigation, signUp]);

  return (
    <SafeAreaView style={styles.safeArea}>
      <KeyboardAvoidingView
        style={{ flex: 1 }}
        behavior={Platform.OS === "ios" ? "padding" : undefined}
      >
        <ScrollView contentContainerStyle={styles.scrollContent} keyboardShouldPersistTaps="handled">
          <View style={styles.container}>
            <Text style={styles.title}>Crear cuenta</Text>

            <View style={styles.inputGroup}>
              <Text style={styles.label}>Nombre</Text>
              <TextInput
                style={styles.input}
                placeholder="Nombre completo"
                placeholderTextColor="#9aa0a6"
                value={form.nombre}
                onChangeText={(text) => updateField("nombre", text)}
                returnKeyType="next"
              />
            </View>

            <View style={styles.inputGroup}>
              <Text style={styles.label}>Usuario</Text>
              <TextInput
                style={styles.input}
                placeholder="Nombre de usuario"
                placeholderTextColor="#9aa0a6"
                value={form.usuario}
                onChangeText={(text) => updateField("usuario", text)}
                autoCapitalize="none"
                returnKeyType="next"
              />
            </View>

            <View style={styles.inputGroup}>
              <Text style={styles.label}>Correo</Text>
              <TextInput
                style={styles.input}
                placeholder="correo@ejemplo.com"
                placeholderTextColor="#9aa0a6"
                value={form.correo}
                onChangeText={(text) => updateField("correo", text)}
                autoCapitalize="none"
                keyboardType="email-address"
                returnKeyType="next"
              />
            </View>

            <View style={styles.inputGroup}>
              <Text style={styles.label}>Telefono</Text>
              <TextInput
                style={styles.input}
                placeholder="55555555"
                placeholderTextColor="#9aa0a6"
                value={form.cel}
                onChangeText={(text) => updateField("cel", text)}
                keyboardType="phone-pad"
                returnKeyType="next"
              />
            </View>

            <View style={styles.inputGroup}>
              <Text style={styles.label}>Contrasena</Text>
              <TextInput
                style={styles.input}
                placeholder="Minimo 8 caracteres"
                placeholderTextColor="#9aa0a6"
                value={form.password}
                onChangeText={(text) => updateField("password", text)}
                secureTextEntry
                returnKeyType="next"
              />
            </View>

            <View style={styles.inputGroup}>
              <Text style={styles.label}>Confirmar contrasena</Text>
              <TextInput
                style={styles.input}
                placeholder="Repite tu contrasena"
                placeholderTextColor="#9aa0a6"
                value={form.confirm}
                onChangeText={(text) => updateField("confirm", text)}
                secureTextEntry
                returnKeyType="done"
              />
            </View>

            {error ? <Text style={styles.errorText}>{error}</Text> : null}

            <View style={styles.buttonWrapper}>
              <Button
                title="REGISTRAR"
                onPress={onSubmit}
                buttonStyle={styles.primaryButton}
                titleStyle={styles.primaryTitle}
                loading={submitting}
                disabled={submitting}
              />
            </View>

            <View style={styles.footer}>
              <Text style={styles.footerText}>Ya tienes cuenta?</Text>
              <TouchableOpacity onPress={() => navigation.replace("Login") }>
                <Text style={styles.footerLink}> Inicia sesion</Text>
              </TouchableOpacity>
            </View>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: "#0a0a23" },
  scrollContent: { flexGrow: 1, padding: wp(8), paddingBottom: hp(4) },
  container: { flex: 1 },
  title: { color: "#fff", fontSize: wp(7), fontWeight: "bold", textAlign: "center", marginBottom: hp(3) },
  inputGroup: { marginBottom: hp(1.8) },
  label: { color: "#d7d9e0", marginBottom: hp(0.5), fontSize: wp(3.6) },
  input: {
    backgroundColor: "#fff",
    borderRadius: wp(2.5),
    paddingHorizontal: wp(4),
    paddingVertical: hp(1.4),
    fontSize: wp(4),
    color: "#111",
  },
  errorText: { color: "#ff6b6b", textAlign: "center", marginTop: hp(1.5) },
  buttonWrapper: { marginTop: hp(2.5) },
  primaryButton: { height: hp(6.5), borderRadius: wp(2.5), backgroundColor: "#1ecb5c" },
  primaryTitle: { fontWeight: "bold", fontSize: wp(4.2) },
  footer: { flexDirection: "row", justifyContent: "center", marginTop: hp(2.5) },
  footerText: { color: "#d7d9e0", fontSize: wp(4) },
  footerLink: { color: "#ffa100", fontWeight: "bold", fontSize: wp(4) },
});
