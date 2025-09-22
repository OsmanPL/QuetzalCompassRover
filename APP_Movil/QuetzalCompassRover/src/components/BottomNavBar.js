import React from "react";
import { StyleSheet, Text, TouchableOpacity, View } from "react-native";
import { useNavigation, useRoute } from "@react-navigation/native";

const NAV_ITEMS = Object.freeze([
  { route: "Map", label: "Mapa" },
  { route: "History", label: "Historial" },
  { route: "Favorites", label: "Favoritos" },
  { route: "Profile", label: "Perfil" },
]);

export default function BottomNavBar({ floating = true, style }) {
  const navigation = useNavigation();
  const route = useRoute();
  const current = route?.name ?? "";

  return (
    <View
      style={[
        styles.baseContainer,
        floating ? styles.floatingContainer : styles.inlineContainer,
        style,
      ]}
    >
      {NAV_ITEMS.map((item) => {
        const isActive = current === item.route;
        return (
          <TouchableOpacity
            key={item.route}
            style={[styles.navItem, isActive && styles.navItemActive]}
            onPress={() => {
              if (!isActive) {
                navigation.navigate(item.route);
              }
            }}
            accessibilityRole="button"
            accessibilityState={{ selected: isActive }}
          >
            <Text style={[styles.navLabel, isActive && styles.navLabelActive]}>
              {item.label}
            </Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  baseContainer: {
    backgroundColor: "rgba(20,20,32,0.95)",
    borderRadius: 16,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },
  floatingContainer: {
    position: "absolute",
    left: 10,
    right: 10,
    bottom: 20,
    paddingVertical: 10,
    paddingHorizontal: 12,
    zIndex: 2200,
    elevation: 12,
  },
  inlineContainer: {
    marginHorizontal: 12,
    marginBottom: 12,
    paddingVertical: 12,
    paddingHorizontal: 14,
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
});
