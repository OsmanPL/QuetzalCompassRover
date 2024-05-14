import * as React from "react";
import {
  Text,
  TextInput,
  View,
  Image,
  ImageBackground,
  StyleSheet,
} from "react-native";
import { Icon, Button } from "react-native-elements";

const image = {
  uri: "../../src/img/Logo.png",
};

export default function LoginScreen({ navigation }) {
  return (
    <ImageBackground source={image} style={styles.image}>
      <View style={styles.container}>
        <View>
          <Text style={styles.title}>Inicio sesión</Text>
        </View>
        <View style={styles.logo}></View>
        <View style={styles.containerUserName}>
          <TextInput
            placeholder="Username"
            placeholderTextColor="gray"
            style={styles.textInput}
          />
        </View>
        <View style={styles.containerPassword}>
          <TextInput
            placeholder="Password"
            placeholderTextColor="gray"
            style={styles.textInput}
            secureTextEntry={true}
          />
        </View>
        <View style={styles.containerSignIn}>
          <Button title="INICIA SESION" backgroundColor="#ffa100" />
        </View>
        <View style={styles.containerRegister}>
          <Text style={{ color: "white", fontWeight: "bold" }}>
            Tienes cuenta?
            <Text
              onPress={() => this.props.navigation.navigate("Registrate")}
              style={{ color: "green", fontWeight: "bold" }}
            >
              {" "}
              Register
            </Text>
          </Text>
        </View>
      </View>
      <Button
        title="Ir Mapa"
        onPress={() => {
          navigation.navigate("Map");
        }}
      />
    </ImageBackground>
  );
}
const styles = StyleSheet.create({
  logo: {
    alignItems: "center",
    justifyContent: "center",
  },
  image: {
    flex: 1,
    resizeMode: "cover",
    aspectRatio: 1.5,
  },
  title: {
    color: "white",
    fontWeight: "bold",
    fontSize: 20,
    textAlign: "center",
  },
  overlay: {
    flex: 1,
    height: "100%",
    width: "100%",
    position: "absolute",
    backgroundColor: "rgba(0, 0, 71, 0.5)",
    justifyContent: "space-evenly",
    flexDirection: "column",
  },
  container: {
    flex: 1,
    flexDirection: "column",
    justifyContent: "center",
    alignItems: "stretch",
  },
  containerSignIn: {
    height: 60,
    marginLeft: "10%",
    marginRight: "10%",
    paddingTop: "2%",
  },
  containerUserName: {
    height: 60,
    flexDirection: "row",
    justifyContent: "center",
    backgroundColor: "#ffffff",
    marginLeft: "10%",
    marginRight: "10%",
  },
  containerPassword: {
    height: 60,
    flexDirection: "row",
    justifyContent: "center",
    backgroundColor: "#ffffff",
    marginLeft: "10%",
    marginRight: "10%",
  },
  containerRegister: {
    height: 60,
    marginLeft: "6%",
    marginRight: "6%",
    alignItems: "center",
    paddingTop: "2%",
  },
  icon: {
    flex: 1,
  },
  textInput: {
    backgroundColor: "transparent",
    flex: 5,
    color: "black",
    paddingLeft: "5%",
  },
});
