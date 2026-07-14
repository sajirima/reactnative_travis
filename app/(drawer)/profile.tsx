import AsyncStorage from '@react-native-async-storage/async-storage';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { useCallback, useEffect, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';

import api from '@/api/axiosConfig';
import { PortalHeader } from '@/components/portal-header';
import { useCurrentUser } from '@/hooks/use-current-user';

type ProfileUser = {
  user_id: number;
  full_name: string;
  email: string;
  role: string;
  status: string;
};

const peso = (value: number) =>
  `₱${value.toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;

export default function ProfileScreen() {
  const currentUser = useCurrentUser();
  const [userId, setUserId] = useState<number | null>(null);
  const [user, setUser] = useState<ProfileUser | null>(null);
  const [paymentsProcessed, setPaymentsProcessed] = useState(0);
  const [totalCollected, setTotalCollected] = useState(0);
  const [loading, setLoading] = useState(true);

  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [savingProfile, setSavingProfile] = useState(false);

  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [savingPassword, setSavingPassword] = useState(false);

  const loadProfile = useCallback(async (id: number) => {
    const response = await api.get(`/api/profile/${id}`);
    setUser(response.data.user);
    setFullName(response.data.user.full_name);
    setEmail(response.data.user.email);
    setPaymentsProcessed(response.data.paymentsProcessed);
    setTotalCollected(response.data.totalCollected);
  }, []);

  useEffect(() => {
    (async () => {
      const raw = await AsyncStorage.getItem('user');
      const stored = raw ? JSON.parse(raw) : null;
      if (stored?.id) {
        setUserId(stored.id);
        try {
          await loadProfile(stored.id);
        } catch {
          Alert.alert('Error', 'Unable to load profile data.');
        }
      }
      setLoading(false);
    })();
  }, [loadProfile]);

  const handleSaveProfile = async () => {
    if (!userId) return;
    if (!fullName.trim() || !email.trim()) {
      Alert.alert('Missing Info', 'Full name and email are required.');
      return;
    }

    setSavingProfile(true);
    try {
      await api.put('/api/profile', { user_id: userId, full_name: fullName.trim(), email: email.trim() });
      const raw = await AsyncStorage.getItem('user');
      const stored = raw ? JSON.parse(raw) : {};
      await AsyncStorage.setItem(
        'user',
        JSON.stringify({ ...stored, full_name: fullName.trim(), email: email.trim() })
      );
      Alert.alert('Saved', 'Your profile has been updated.');
    } catch (error: any) {
      Alert.alert('Error', error?.response?.data?.error ?? 'Unable to save profile.');
    } finally {
      setSavingProfile(false);
    }
  };

  const handleUpdatePassword = async () => {
    if (!userId) return;
    if (!currentPassword || !newPassword || !confirmPassword) {
      Alert.alert('Missing Info', 'Please fill in all password fields.');
      return;
    }
    if (newPassword !== confirmPassword) {
      Alert.alert('Mismatch', 'New password and confirm password do not match.');
      return;
    }

    setSavingPassword(true);
    try {
      await api.put('/api/profile/password', {
        user_id: userId,
        current_password: currentPassword,
        new_password: newPassword,
      });
      setCurrentPassword('');
      setNewPassword('');
      setConfirmPassword('');
      Alert.alert('Updated', 'Password updated successfully.');
    } catch (error: any) {
      Alert.alert('Error', error?.response?.data?.error ?? 'Unable to update password.');
    } finally {
      setSavingPassword(false);
    }
  };

  if (loading) {
    return (
      <View style={[styles.screen, styles.centered]}>
        <ActivityIndicator color="#0d9488" size="large" />
      </View>
    );
  }

  const initials = (user?.full_name ?? '?')
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase())
    .join('');

  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.content}>
      <PortalHeader
        title="My Profile"
        subtitle="Manage your account and security"
        userName={currentUser?.full_name}
        userRole={currentUser?.role}
        showSearch={false}
      />

      <LinearGradient
        colors={['#0369a1', '#0d9488']}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 0 }}
        style={styles.banner}>
        <View style={styles.avatar}>
          <Text style={styles.avatarText}>{initials}</Text>
        </View>
        <View style={styles.bannerInfo}>
          <Text style={styles.bannerName}>{user?.full_name}</Text>
          <Text style={styles.bannerRole}>{user?.role} · TRAVIS Treasurer Portal</Text>
        </View>
        <View style={styles.bannerStats}>
          <View style={styles.bannerStat}>
            <Text style={styles.bannerStatValue}>{paymentsProcessed}</Text>
            <Text style={styles.bannerStatLabel}>Payments Processed</Text>
          </View>
          <View style={styles.bannerStat}>
            <Text style={styles.bannerStatValue}>{peso(totalCollected)}</Text>
            <Text style={styles.bannerStatLabel}>Total Collected</Text>
          </View>
        </View>
      </LinearGradient>

      <View style={styles.card}>
        <Text style={styles.cardTitle}>Personal Information</Text>

        <Text style={styles.label}>Full Name</Text>
        <TextInput style={styles.input} value={fullName} onChangeText={setFullName} placeholderTextColor="#94a3b8" />

        <Text style={styles.label}>Email Address</Text>
        <TextInput
          style={styles.input}
          value={email}
          onChangeText={setEmail}
          autoCapitalize="none"
          keyboardType="email-address"
          placeholderTextColor="#94a3b8"
        />

        <Text style={styles.label}>Access Role</Text>
        <View style={styles.readonlyField}>
          <Text style={styles.readonlyText}>{user?.role}</Text>
        </View>

        <Text style={styles.label}>Account Status</Text>
        <View style={styles.statusBadge}>
          <Text style={styles.statusBadgeText}>{user?.status}</Text>
        </View>

        <Pressable
          style={[styles.saveBtn, savingProfile && styles.btnDisabled]}
          onPress={handleSaveProfile}
          disabled={savingProfile}>
          {savingProfile ? (
            <ActivityIndicator color="#fff" size="small" />
          ) : (
            <>
              <Ionicons name="save-outline" size={16} color="#fff" style={styles.btnIcon} />
              <Text style={styles.saveBtnText}>Save Changes</Text>
            </>
          )}
        </Pressable>
      </View>

      <View style={styles.card}>
        <Text style={styles.cardTitle}>Change Password</Text>

        <Text style={styles.label}>Current Password</Text>
        <TextInput
          style={styles.input}
          value={currentPassword}
          onChangeText={setCurrentPassword}
          secureTextEntry
          placeholderTextColor="#94a3b8"
        />

        <Text style={styles.label}>New Password</Text>
        <TextInput
          style={styles.input}
          value={newPassword}
          onChangeText={setNewPassword}
          secureTextEntry
          placeholderTextColor="#94a3b8"
        />

        <Text style={styles.label}>Confirm New Password</Text>
        <TextInput
          style={styles.input}
          value={confirmPassword}
          onChangeText={setConfirmPassword}
          secureTextEntry
          placeholderTextColor="#94a3b8"
        />

        <Pressable
          style={[styles.updateBtn, savingPassword && styles.btnDisabled]}
          onPress={handleUpdatePassword}
          disabled={savingPassword}>
          {savingPassword ? (
            <ActivityIndicator color="#0d9488" size="small" />
          ) : (
            <>
              <Ionicons name="shield-checkmark-outline" size={16} color="#0d9488" style={styles.btnIcon} />
              <Text style={styles.updateBtnText}>Update Password</Text>
            </>
          )}
        </Pressable>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: '#f8fafc' },
  centered: { alignItems: 'center', justifyContent: 'center' },
  content: { padding: 20, paddingBottom: 48, gap: 20 },
  banner: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    alignItems: 'center',
    gap: 16,
    borderRadius: 18,
    padding: 20,
  },
  avatar: {
    width: 56,
    height: 56,
    borderRadius: 28,
    backgroundColor: 'rgba(255,255,255,.2)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: { color: '#fff', fontWeight: '800', fontSize: 20 },
  bannerInfo: { flex: 1, minWidth: 140 },
  bannerName: { color: '#fff', fontSize: 18, fontWeight: '800' },
  bannerRole: { color: 'rgba(255,255,255,.85)', fontSize: 12.5, marginTop: 2 },
  bannerStats: { flexDirection: 'row', gap: 20 },
  bannerStat: { alignItems: 'flex-end' },
  bannerStatValue: { color: '#fff', fontSize: 17, fontWeight: '800' },
  bannerStatLabel: { color: 'rgba(255,255,255,.8)', fontSize: 10.5, marginTop: 2 },
  card: {
    backgroundColor: '#ffffff',
    borderRadius: 16,
    padding: 18,
    shadowColor: '#0f172a',
    shadowOpacity: 0.06,
    shadowRadius: 10,
    shadowOffset: { width: 0, height: 4 },
    elevation: 2,
  },
  cardTitle: { color: '#0f172a', fontSize: 16, fontWeight: '700', marginBottom: 14 },
  label: { color: '#475569', fontSize: 12.5, fontWeight: '600', marginBottom: 6, marginTop: 12 },
  input: {
    borderWidth: 1,
    borderColor: '#e2e8f0',
    borderRadius: 10,
    paddingHorizontal: 14,
    paddingVertical: 11,
    fontSize: 14,
    color: '#0f172a',
    backgroundColor: '#f8fafc',
  },
  readonlyField: {
    borderWidth: 1,
    borderColor: '#e2e8f0',
    borderRadius: 10,
    paddingHorizontal: 14,
    paddingVertical: 11,
    backgroundColor: '#f1f5f9',
  },
  readonlyText: { color: '#475569', fontSize: 14 },
  statusBadge: {
    alignSelf: 'flex-start',
    backgroundColor: '#d1fae5',
    borderRadius: 999,
    paddingHorizontal: 12,
    paddingVertical: 5,
  },
  statusBadgeText: { color: '#059669', fontSize: 11.5, fontWeight: '700', textTransform: 'capitalize' },
  saveBtn: {
    flexDirection: 'row',
    backgroundColor: '#0d9488',
    borderRadius: 10,
    paddingVertical: 13,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 20,
  },
  saveBtnText: { color: '#fff', fontSize: 14.5, fontWeight: '700' },
  updateBtn: {
    flexDirection: 'row',
    backgroundColor: '#f0fdfa',
    borderWidth: 1,
    borderColor: '#99f6e4',
    borderRadius: 10,
    paddingVertical: 13,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 20,
  },
  updateBtnText: { color: '#0d9488', fontSize: 14.5, fontWeight: '700' },
  btnIcon: { marginRight: 8 },
  btnDisabled: { opacity: 0.6 },
});
