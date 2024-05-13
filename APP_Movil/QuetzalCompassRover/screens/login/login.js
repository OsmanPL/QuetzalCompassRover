import React from 'react';
import { View, Text, Button } from 'react-native';

export default function LoginScreen({ navigation}) {
  return (
    <View>
      <Text >
        Login Screen
      </Text>
      <Button
        title="Ir Mapa"
        onPress={() => {navigation.navigate('Map')}}
      />
   </View>
  );
}