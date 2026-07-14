import { Ionicons } from '@expo/vector-icons';
import { StyleSheet, View } from 'react-native';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';

type PlaceholderScreenProps = {
  title: string;
  description: string;
  icon: keyof typeof Ionicons.glyphMap;
};

export function PlaceholderScreen({ title, description, icon }: PlaceholderScreenProps) {
  return (
    <ThemedView style={styles.container}>
      <View style={styles.iconBadge}>
        <Ionicons name={icon} size={32} color="#14b8a6" />
      </View>
      <ThemedText type="title" style={styles.title}>
        {title}
      </ThemedText>
      <ThemedText style={styles.description}>{description}</ThemedText>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 32,
  },
  iconBadge: {
    width: 64,
    height: 64,
    borderRadius: 16,
    backgroundColor: 'rgba(20,184,166,.12)',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 20,
  },
  title: {
    fontSize: 22,
    textAlign: 'center',
  },
  description: {
    marginTop: 10,
    textAlign: 'center',
    opacity: 0.7,
    maxWidth: 320,
  },
});
