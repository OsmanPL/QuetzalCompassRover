// src/navigation/Navigation.js
import React, { useEffect } from "react";
import { NavigationContainer, createNavigationContainerRef } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { enableScreens } from "react-native-screens";
import LoginScreen from "../screens/login/login";
import RegisterScreen from "../screens/register/register";
import MapScreen from "../screens/maps/map";
import HistoryScreen from "../screens/history/history";
import FavoritesScreen from "../screens/favorites/favorites";
import ProfileScreen from "../screens/profile/perfil";
import { useAuth } from "./context/AuthContext.js";

enableScreens(false);

const Stack = createNativeStackNavigator();
const navigationRef = createNavigationContainerRef();

export default function Navigation() {
  const { token } = useAuth();

  useEffect(() => {
    if (!navigationRef.isReady()) return;
    if (token) {
      navigationRef.resetRoot({ index: 0, routes: [{ name: "Map" }] });
    } else {
      navigationRef.resetRoot({ index: 0, routes: [{ name: "Login" }] });
    }
  }, [token]);

  return (
    <NavigationContainer ref={navigationRef}>
      <Stack.Navigator
        initialRouteName="Login"
        screenOptions={{
          animation: "fade",
          headerBackTitleVisible: false,
          gestureEnabled: true,
        }}
      >
        <Stack.Screen
          name="Login"
          component={LoginScreen}
          options={{ title: "Quetzal Compass Rover" }}
        />
        <Stack.Screen
          name="Register"
          component={RegisterScreen}
          options={{ title: "Crear Cuenta" }}
        />
        <Stack.Screen
          name="Map"
          component={MapScreen}
          options={{ title: "Mapa" }}
        />
        <Stack.Screen
          name="Profile"
          component={ProfileScreen}
          options={{ title: "Perfil" }}
        />
        <Stack.Screen
          name="History"
          component={HistoryScreen}
          options={{ title: "Historial" }}
        />
        <Stack.Screen
          name="Favorites"
          component={FavoritesScreen}
          options={{ title: "Favoritos" }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
