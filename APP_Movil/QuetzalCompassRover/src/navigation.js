// src/navigation/Navigation.js
import React from "react";
import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
// Si llega a fallar, veremos enableScreens(false) en el paso 4
import { enableScreens } from "react-native-screens";
enableScreens(false); 

import LoginScreen from "../screens/login/login";
import MapScreen from "../screens/maps/map";

const Stack = createNativeStackNavigator();

export default function Navigation() {
  return (
    <NavigationContainer>
      <Stack.Navigator
        initialRouteName="Map"
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
          name="Map"
          component={MapScreen}
          options={{ title: "Mapa" }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
