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
} from "react-native";
import { Button } from "react-native-elements";
import { useAuth } from "../../src/context/AuthContext.js";

const { width, height } = Dimensions.get("window");
const wp = (p) => (width * p) / 100;
const hp = (p) => (height * p) / 100;

const image = require("../../src/img/Logo.png");

export default function LoginScreen({ navigation }) {
  const [correo, setCorreo] = React.useState("");
  const [password, setPassword] = React.useState("");
  const [localError, setLocalError] = React.useState(null);
  const { signIn, loading, error, token } = useAuth();

  React.useEffect(() => {
    if (token) {
      navigation.reset({ index: 0, routes: [{ name: "Map" }] });
    }
  }, [token, navigation]);

  const onRegisterPress = () => {
    navigation.navigate("Register");
  };

  const onLoginPress = async () => {
    if (!correo || !password) {
      setLocalError("Ingresa tu correo y contrasena");
      return;
    }
    const result = await signIn({ correo, pass: password });
    if (!result.success) {
      setLocalError(result.message || "Credenciales invalidas");
      return;
    }
    setLocalError(null);
    navigation.reset({ index: 0, routes: [{ name: "Map" }] });
  };

  const errorMessage = localError || error;

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: "#000" }}>
      <ImageBackground source={image} style={styles.image} imageStyle={styles.imageStyle}>
        <View style={styles.overlay} />
        <KeyboardAvoidingView
          style={{ flex: 1 }}
          behavior={Platform.OS === "ios" ? "padding" : undefined}
        >
          <View style={styles.container}>
            <Text style={styles.title}>Inicio sesion</Text>

            <View style={styles.inputContainer}>
              <TextInput
                placeholder="Correo"
                placeholderTextColor="#9aa0a6"
                style={styles.textInput}
                autoCapitalize="none"
                autoCorrect={false}
                keyboardType="email-address"
                returnKeyType="next"
                value={correo}
                onChangeText={setCorreo}
              />
            </View>

            <View style={[styles.inputContainer, { marginTop: hp(1.5) }]}>
              <TextInput
                placeholder="Contrasena"
                placeholderTextColor="#9aa0a6"
                style={styles.textInput}
                secureTextEntry
                returnKeyType="done"
                value={password}
                onChangeText={setPassword}
              />
            </View>

            {errorMessage ? (
              <Text style={styles.errorText}>{errorMessage}</Text>
            ) : null}

            <View style={{ marginTop: hp(2.5) }}>
              <Button
                title="INICIAR SESION"
                onPress={onLoginPress}
                buttonStyle={styles.primaryButton}
                titleStyle={styles.primaryTitle}
                loading={loading}
                disabled={loading}
              />
            </View>

            <View style={{ marginTop: hp(1.5) }}>
              <Button
                title="CREAR CUENTA"
                type="clear"
                onPress={onRegisterPress}
                buttonStyle={styles.clearButton}
                titleStyle={styles.clearTitle}
              />
            </View>

            <View style={styles.containerRegister}>
              <Text style={styles.registerText}>No tienes cuenta?</Text>
              <TouchableOpacity onPress={onRegisterPress}>
                <Text style={styles.registerLink}>  Registrate</Text>
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
  errorText: { color: "#ff6b6b", textAlign: "center", marginTop: hp(1.5) },
  primaryButton: { height: hp(6.5), borderRadius: wp(2.5), backgroundColor: "#ffa100" },
  primaryTitle: { fontWeight: "bold", fontSize: wp(4.2), letterSpacing: 0.3 },
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
