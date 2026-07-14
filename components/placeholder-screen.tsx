import { Ionicons } from '@expo/vector-icons';
import { StyleSheet, Text, View } from 'react-native';

import { PortalHeader } from '@/components/portal-header';

type PlaceholderScreenProps = {
  title: string;
  description: string;
  icon: keyof typeof Ionicons.glyphMap;
};

export function PlaceholderScreen({ title, description, icon }: PlaceholderScreenProps) {
  return (
    <View style={styles.screen}>
      <View style={styles.headerWrap}>
        <PortalHeader title={title} subtitle={description} showSearch={false} />
      </View>
      <View style={styles.container}>
        <View style={styles.iconBadge}>
          <Ionicons name={icon} size={32} color="#0d9488" />
        </View>
        <Text style={styles.comingSoonText}>This feature is coming soon</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: '#f8fafc' },
  headerWrap: { padding: 20, paddingBottom: 0 },
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
    backgroundColor: '#f0fdfa',
    alignItems: 'center',
    justifyContent: 'center',
  },
  comingSoonText: { marginTop: 14, color: '#94a3b8', fontSize: 13 },
});
