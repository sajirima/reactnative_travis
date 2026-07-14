import { Ionicons } from '@expo/vector-icons';
import { DrawerActions } from '@react-navigation/native';
import { useNavigation } from 'expo-router';
import { Pressable, StyleSheet, Text, TextInput, View } from 'react-native';

type PortalHeaderProps = {
  title: string;
  subtitle: string;
  userName?: string;
  userRole?: string;
  showSearch?: boolean;
};

export function PortalHeader({ title, subtitle, userName, userRole, showSearch = true }: PortalHeaderProps) {
  const navigation = useNavigation();
  const initials = (userName ?? '?')
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('');

  return (
    <View style={styles.container}>
      <View style={styles.topRow}>
        <Pressable
          style={styles.menuBtn}
          onPress={() => navigation.dispatch(DrawerActions.openDrawer())}
          hitSlop={10}>
          <Ionicons name="menu-outline" size={22} color="#0f172a" />
        </Pressable>

        <View style={styles.titleBlock}>
          <Text style={styles.title}>{title}</Text>
          <Text style={styles.subtitle}>{subtitle}</Text>
        </View>

        <View style={styles.bellBtn}>
          <Ionicons name="notifications-outline" size={18} color="#475569" />
        </View>

        <View style={styles.userChip}>
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>{initials || '?'}</Text>
          </View>
          <View>
            <Text style={styles.userName} numberOfLines={1}>{userName ?? ''}</Text>
            <Text style={styles.userRole} numberOfLines={1}>{userRole ?? ''}</Text>
          </View>
        </View>
      </View>

      {showSearch && (
        <View style={styles.searchBar}>
          <Ionicons name="search-outline" size={16} color="#94a3b8" />
          <TextInput
            style={styles.searchInput}
            placeholder="Search violations, receipts, plates..."
            placeholderTextColor="#94a3b8"
          />
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { gap: 14 },
  topRow: { flexDirection: 'row', alignItems: 'center', gap: 12, flexWrap: 'wrap' },
  menuBtn: {
    width: 38,
    height: 38,
    borderRadius: 10,
    backgroundColor: '#f1f5f9',
    alignItems: 'center',
    justifyContent: 'center',
  },
  titleBlock: { flex: 1, minWidth: 120 },
  title: { color: '#0f172a', fontSize: 22, fontWeight: '800' },
  subtitle: { color: '#64748b', fontSize: 12.5, marginTop: 1 },
  bellBtn: {
    width: 38,
    height: 38,
    borderRadius: 10,
    backgroundColor: '#f1f5f9',
    alignItems: 'center',
    justifyContent: 'center',
  },
  userChip: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  avatar: {
    width: 34,
    height: 34,
    borderRadius: 17,
    backgroundColor: '#0d9488',
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: { color: '#fff', fontWeight: '800', fontSize: 12.5 },
  userName: { color: '#0f172a', fontSize: 13, fontWeight: '700', maxWidth: 110 },
  userRole: { color: '#64748b', fontSize: 10.5, maxWidth: 110 },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    backgroundColor: '#f1f5f9',
    borderRadius: 12,
    paddingHorizontal: 14,
    paddingVertical: 10,
  },
  searchInput: { flex: 1, fontSize: 13.5, color: '#0f172a', padding: 0 },
});
