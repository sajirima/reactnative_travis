import { Ionicons } from '@expo/vector-icons';
import type { DrawerContentComponentProps } from '@react-navigation/drawer';
import { DrawerContentScrollView } from '@react-navigation/drawer';
import { Drawer } from 'expo-router/drawer';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { router } from 'expo-router';
import React from 'react';
import { Alert, StyleSheet, Text, TouchableOpacity, View } from 'react-native';

type NavItem = {
  routeName: string;
  label: string;
  icon: keyof typeof Ionicons.glyphMap;
};

const NAV_ITEMS: NavItem[] = [
  { routeName: 'dashboard', label: 'Dashboard', icon: 'grid-outline' },
  { routeName: 'violations', label: 'Traffic Violation Records', icon: 'clipboard-outline' },
  { routeName: 'payments', label: 'Payment Management', icon: 'card-outline' },
  { routeName: 'reports', label: 'Collection Reports', icon: 'bar-chart-outline' },
  { routeName: 'history', label: 'Payment History', icon: 'time-outline' },
  { routeName: 'notifications', label: 'Notifications', icon: 'notifications-outline' },
  { routeName: 'profile', label: 'Profile', icon: 'person-outline' },
];

function CustomDrawerContent(props: DrawerContentComponentProps) {
  const { state, navigation } = props;
  const focusedRouteName = state.routes[state.index].name;

  async function handleLogout() {
    Alert.alert('Sign out of TRAVIS?', 'You will need to sign in again to access the dashboard.', [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Sign Out',
        style: 'destructive',
        onPress: async () => {
          await AsyncStorage.removeItem('user');
          router.replace('/login');
        },
      },
    ]);
  }

  return (
    <View style={styles.drawerScroll}>
      <View style={styles.brand}>
        <View style={styles.brandBadge}>
          <Text style={styles.brandBadgeText}>T</Text>
        </View>
        <View>
          <Text style={styles.brandTitle}>TRAVIS</Text>
          <Text style={styles.brandSubtitle}>Treasurer Portal</Text>
        </View>
      </View>

      <DrawerContentScrollView
        {...props}
        style={{ backgroundColor: 'transparent' }}
        contentContainerStyle={styles.drawerContent}>
        <View style={styles.navigationPanel}>
          <Text style={styles.navigationTitle}>Main</Text>
          {NAV_ITEMS.map((item) => {
            const isActive = focusedRouteName === item.routeName;
            return (
              <TouchableOpacity
                key={item.routeName}
                style={[styles.navRow, isActive && styles.navRowActive]}
                onPress={() => navigation.navigate(item.routeName)}
                activeOpacity={0.75}>
                {isActive && <View style={styles.activeBar} />}
                <Ionicons
                  name={item.icon}
                  size={19}
                  color={isActive ? '#FFFFFF' : 'rgba(255,255,255,.75)'}
                  style={styles.navIcon}
                />
                <Text style={[styles.navLabel, isActive && styles.navLabelActive]}>{item.label}</Text>
              </TouchableOpacity>
            );
          })}
        </View>
      </DrawerContentScrollView>

      <TouchableOpacity style={styles.logoutBtn} onPress={handleLogout} activeOpacity={0.8}>
        <Ionicons name="log-out-outline" size={18} color="#fca5a5" style={styles.navIcon} />
        <Text style={styles.logoutLabel}>Logout</Text>
      </TouchableOpacity>

      <Text style={styles.footer}>
        TRAVIS v1.0 · LGU System{'\n'}© {new Date().getFullYear()} City Government
      </Text>
    </View>
  );
}

export default function DrawerLayout() {
  return (
    <Drawer
      drawerContent={(props) => <CustomDrawerContent {...props} />}
      screenOptions={{
        headerShown: false,
        drawerType: 'front',
        overlayColor: 'rgba(0,0,0,0.35)',
        drawerStyle: { width: 300 },
      }}>
      <Drawer.Screen name="dashboard" options={{ title: 'Dashboard' }} />
      <Drawer.Screen name="violations" options={{ title: 'Traffic Violation Records' }} />
      <Drawer.Screen name="payments" options={{ title: 'Payment Management' }} />
      <Drawer.Screen name="reports" options={{ title: 'Collection Reports' }} />
      <Drawer.Screen name="history" options={{ title: 'Payment History' }} />
      <Drawer.Screen name="notifications" options={{ title: 'Notifications' }} />
      <Drawer.Screen name="profile" options={{ title: 'Profile' }} />
    </Drawer>
  );
}

const styles = StyleSheet.create({
  drawerScroll: { flex: 1, backgroundColor: '#0a1120' },
  brand: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    paddingHorizontal: 20,
    paddingTop: 54,
    paddingBottom: 20,
    borderBottomWidth: 1,
    borderBottomColor: 'rgba(255,255,255,.08)',
  },
  brandBadge: {
    width: 42,
    height: 42,
    borderRadius: 12,
    backgroundColor: '#14b8a6',
    alignItems: 'center',
    justifyContent: 'center',
  },
  brandBadgeText: { color: '#fff', fontWeight: '800', fontSize: 19 },
  brandTitle: { color: '#fff', fontWeight: '800', fontSize: 18 },
  brandSubtitle: { color: 'rgba(255,255,255,.55)', fontSize: 12.5, marginTop: 1 },
  drawerContent: { paddingTop: 0, paddingHorizontal: 0, flexGrow: 1 },
  navigationPanel: { flex: 1, paddingTop: 18 },
  navigationTitle: {
    marginBottom: 8,
    paddingHorizontal: 20,
    color: 'rgba(255,255,255,.4)',
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: 1,
    textTransform: 'uppercase',
  },
  navRow: {
    flexDirection: 'row',
    alignItems: 'center',
    height: 50,
    marginHorizontal: 10,
    marginVertical: 2,
    paddingHorizontal: 14,
    borderRadius: 10,
    position: 'relative',
  },
  navRowActive: {
    backgroundColor: '#14b8a6',
  },
  activeBar: {
    position: 'absolute',
    left: -10,
    top: 8,
    bottom: 8,
    width: 4,
    borderRadius: 2,
    backgroundColor: '#14b8a6',
  },
  navIcon: { marginRight: 14 },
  navLabel: { flex: 1, fontSize: 14.5, color: 'rgba(255,255,255,.8)', fontWeight: '500' },
  navLabelActive: { color: '#FFFFFF', fontWeight: '700' },
  logoutBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    marginHorizontal: 16,
    marginBottom: 14,
    paddingVertical: 13,
    paddingHorizontal: 16,
    borderRadius: 10,
    backgroundColor: 'rgba(220,38,38,.08)',
    borderWidth: 1,
    borderColor: 'rgba(220,38,38,.4)',
  },
  logoutLabel: { color: '#fca5a5', fontWeight: '700', fontSize: 14.5 },
  footer: {
    color: 'rgba(255,255,255,.35)',
    fontSize: 10.5,
    textAlign: 'center',
    lineHeight: 15,
    paddingBottom: 18,
  },
});