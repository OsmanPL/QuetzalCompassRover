import React from "react";
import Config from "react-native-config";
import { StyleSheet, View, Dimensions } from "react-native";
import MapView, { PROVIDER_GOOGLE } from "react-native-maps";
import { Marker } from "react-native-maps";
import { GooglePlacesAutocomplete } from "react-native-google-places-autocomplete";
import MapViewDirections from "react-native-maps-directions";
import { useState } from "react";
import * as Location from "expo-location";

export default function MapScreen() {
  const [origin, setOrigin] = useState();
  const [middleDestination, setMiddleDestination] = useState();
  const [destination, setDestination] = useState();

  const [regionDefault, setRegionDefault] = useState({
    latitude: 14.624312, 
    longitude: -90.565671,
    latitudeDelta: 0.003,
    longitudeDelta: 0.003,
  });

  const GOOGLE_MAPS_APIKEY = "GOOGLE_MAPS_APIKEY";

  async function getLocation() {
    let { status } = await Location.requestForegroundPermissionsAsync();
    if (status !== "granted") {
      alert("Permission to access location was denied");
      return;
    }

    let currentLocation = await Location.getCurrentPositionAsync({});
    setOrigin({
      latitude: currentLocation.coords.latitude,
      longitude: currentLocation.coords.longitude,
    });
    setRegionDefault({
      latitude: currentLocation.coords.latitude,
      longitude: currentLocation.coords.longitude,
      latitudeDelta: 0.003,
      longitudeDelta: 0.003,
    });
  }

  React.useEffect(() => {
    getLocation();
  }, []);

  return (
    <View style={styles.container}>
      <View style={{ zIndex: 1, flex: 0.5, flexDirection: "row" }}>
        <View style={{ flex: 0.5, marginHorizontal: 5 }}>
          <GooglePlacesAutocomplete
            fetchDetails={true}
            placeholder="Origen"
            onPress={(data, details = null) => {
              // 'details' is provided when fetchDetails = true
              let originLocation = {
                latitude: details?.geometry?.location.lat,
                longitude: details?.geometry?.location.lng,
              };
              setOrigin(originLocation);
              setRegionDefault({
                latitude: details?.geometry?.location.lat,
                longitude: details?.geometry?.location.lng,
                latitudeDelta: 0.003,
                longitudeDelta: 0.003,
              });
            }}
            query={{
              key: GOOGLE_MAPS_APIKEY,
              language: "en",
            }}
          />
        </View>
        <View style={{ flex: 0.5, marginLeft: 6 }}>
          <GooglePlacesAutocomplete
            fetchDetails={true}
            placeholder="Destino"
            onPress={(data, details = null) => {
              // 'details' is provided when fetchDetails = true
              let destinationLocation = {
                latitude: details?.geometry?.location.lat,
                longitude: details?.geometry?.location.lng,
              };
              setDestination(destinationLocation);
            }}
            query={{
              key: GOOGLE_MAPS_APIKEY,
              language: "en",
            }}
          />
        </View>
      </View>
      <MapView
        provider={PROVIDER_GOOGLE} // remove if not using Google Maps
        style={styles.map}
        region={regionDefault}
      >
        {origin != undefined ?<Marker coordinate={origin} />:null}
        {destination != undefined?<Marker coordinate={destination} />:null}

        {origin != undefined && destination != undefined ? (
          <MapViewDirections
            origin={origin}
            destination={destination}
            apikey={GOOGLE_MAPS_APIKEY}
          />
        ) : null}
      </MapView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    ...StyleSheet.absoluteFillObject,
    flex: 1,
    justifyContent: "flex-start",
    alignItems: "center",
  },
  map: {
    ...StyleSheet.absoluteFillObject,
  },
});
