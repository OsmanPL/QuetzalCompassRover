import * as React from "react";
import {
  Text,
  TextInput,
  View,
  ImageBackground,
  StyleSheet,
  Dimensions,
  TouchableOpacity,
  KeyboardAvoidingView,
  Platform,
  SafeAreaView,
  Alert,
} from "react-native";
import { Button } from "react-native-elements";

const { width, height } = Dimensions.get("window");
const wp = p => (width * p) / 100;
const hp = p => (height * p) / 100;

// Usa tu ruta original
const image = require("../../src/img/Logo.png");

export default function LoginScreen({ navigation }) {
  const onRegisterPress = () => {
    Alert.alert("En construcción", "La pantalla de registro aún no está lista.");
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: "#000" }}>
      <ImageBackground source={image} style={styles.image} imageStyle={styles.imageStyle}>
        <View style={styles.overlay} />
        <KeyboardAvoidingView
          style={{ flex: 1 }}
          behavior={Platform.OS === "ios" ? "padding" : undefined}
        >
          <View style={styles.container}>
            <Text style={styles.title}>Inicio sesión</Text>

            {/* Usuario */}
            <View style={styles.inputContainer}>
              <TextInput
                placeholder="Username"
                placeholderTextColor="#9aa0a6"
                style={styles.textInput}
                autoCapitalize="none"
                autoCorrect={false}
                returnKeyType="next"
              />
            </View>

            {/* Password */}
            <View style={[styles.inputContainer, { marginTop: hp(1.5) }]}>
              <TextInput
                placeholder="Password"
                placeholderTextColor="#9aa0a6"
                style={styles.textInput}
                secureTextEntry
                returnKeyType="done"
              />
            </View>

            {/* Botón: Iniciar sesión */}
            <View style={{ marginTop: hp(2.5) }}>
              <Button
                title="INICIAR SESIÓN"
                onPress={() => navigation.navigate("Map")}
                buttonStyle={styles.primaryButton}
                titleStyle={styles.primaryTitle}
              />
            </View>

            {/* Botón: Ir al mapa */}
            <View style={{ marginTop: hp(1.5) }}>
              <Button
                title="IR AL MAPA"
                type="outline"
                onPress={() => navigation.navigate("Map")}
                buttonStyle={styles.outlineButton}
                titleStyle={styles.outlineTitle}
              />
            </View>

            {/* Botón: Crear cuenta (sin ruta) */}
            <View style={{ marginTop: hp(1.5) }}>
              <Button
                title="CREAR CUENTA"
                type="clear"
                onPress={onRegisterPress}
                buttonStyle={styles.clearButton}
                titleStyle={styles.clearTitle}
              />
            </View>

            {/* Enlace de registro (también sin ruta) */}
            <View style={styles.containerRegister}>
              <Text style={styles.registerText}>¿No tienes cuenta?</Text>
              <TouchableOpacity onPress={onRegisterPress}>
                <Text style={styles.registerLink}>  Regístrate</Text>
              </TouchableOpacity>
            </View>
          </View>
        </KeyboardAvoidingView>
      </ImageBackground>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  image: { flex: 1, resizeMode: "cover" },
  imageStyle: {},
  overlay: { ...StyleSheet.absoluteFillObject, backgroundColor: "rgba(0,0,40,0.45)" },
  container: { flex: 1, paddingHorizontal: wp(8), justifyContent: "center" },
  title: { color: "white", fontWeight: "bold", fontSize: wp(7), textAlign: "center", marginBottom: hp(3) },
  inputContainer: {
    height: hp(6.5),
    borderRadius: wp(2.5),
    backgroundColor: "#ffffff",
    paddingHorizontal: wp(4),
    justifyContent: "center",
    shadowColor: "#000",
    shadowOpacity: 0.1,
    shadowOffset: { width: 0, height: 2 },
    shadowRadius: 4,
    elevation: 2,
  },
  textInput: { fontSize: wp(4.2), color: "#111" },

  primaryButton: { height: hp(6.5), borderRadius: wp(2.5), backgroundColor: "#ffa100" },
  primaryTitle: { fontWeight: "bold", fontSize: wp(4.2), letterSpacing: 0.3 },

  outlineButton: {
    height: hp(6.0),
    borderRadius: wp(2.5),
    borderWidth: 1,
    borderColor: "#fff",
    backgroundColor: "transparent",
  },
  outlineTitle: { color: "#fff", fontSize: wp(3.9), fontWeight: "600" },

  clearButton: { height: hp(6.0) },
  clearTitle: { color: "#1ecb5c", fontWeight: "bold", fontSize: wp(4) },

  containerRegister: {
    marginTop: hp(2),
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "center",
  },
  registerText: { color: "white", fontSize: wp(4), fontWeight: "600" },
  registerLink: { color: "#1ecb5c", fontWeight: "bold", fontSize: wp(4) },
});
