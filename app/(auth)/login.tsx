import { useRef, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  KeyboardAvoidingView,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
  useWindowDimensions,
} from 'react-native';
import { router } from 'expo-router';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';

import api from '@/api/axiosConfig';

export default function LoginScreen() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [rememberMe, setRememberMe] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);

  const { width } = useWindowDimensions();
  const isWide = width >= 860;

  const emailRef = useRef<TextInput>(null);
  const passwordRef = useRef<TextInput>(null);

  const handleLogin = async () => {
    if (!email.trim() || !password) {
      Alert.alert('Missing Info', 'Please enter your email and password.');
      return;
    }

    setLoading(true);
    try {
      const response = await api.post('/api/login', {
        email: email.trim().toLowerCase(),
        password,
      });

      if (response.data?.success) {
        const user = response.data.user;
        await AsyncStorage.setItem(
          'user',
          JSON.stringify({
            id: user.id,
            full_name: user.full_name ?? user.name,
            username: user.username ?? '',
            email: user.email,
            role: user.role ?? '',
            status: user.status ?? '',
          })
        );
        router.replace('/dashboard');
      }
    } catch (error: any) {
      const message =
        error?.response?.data?.error ??
        'Unable to log in right now. Please try again.';
      Alert.alert('Login Failed', message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <LinearGradient colors={['#000000', '#031a33', '#0369a1']} style={styles.flex}>
      <KeyboardAvoidingView
        style={styles.flex}
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        keyboardVerticalOffset={Platform.OS === 'ios' ? 60 : 0}>
        <ScrollView
          contentContainerStyle={[styles.container, isWide && styles.containerWide]}
          keyboardShouldPersistTaps="handled"
          showsVerticalScrollIndicator={false}>
          {/* Info panel — shown full on wide/tablet screens, condensed on phones */}
          <View style={[styles.infoPanel, isWide ? styles.infoPanelWide : styles.infoPanelNarrow]}>
            <View style={styles.badge}>
              <Text style={styles.badgeText}>AI Smart Traffic Command Center</Text>
            </View>
            <Text style={styles.brandTitle}>TRAVIS</Text>
            <Text style={styles.brandSubtitle}>Traffic Violation Recognition and AI Surveillance</Text>
            {isWide && (
              <Text style={styles.brandDescription}>
                An AI-powered intelligent traffic monitoring platform designed to assist Local
                Government Units in monitoring traffic violations, congestion, collisions, and
                road conditions using Computer Vision and Machine Learning.
              </Text>
            )}

            {isWide && (
              <View style={styles.statRow}>
                <View style={styles.statCard}>
                  <Text style={styles.statValue}>24</Text>
                  <Text style={styles.statLabel}>Active Cameras</Text>
                </View>
                <View style={styles.statCard}>
                  <Text style={styles.statValue}>AI</Text>
                  <Text style={styles.statLabel}>Monitoring Online</Text>
                </View>
                <View style={styles.statCard}>
                  <Text style={styles.statValue}>24/7</Text>
                  <Text style={styles.statLabel}>Traffic Surveillance</Text>
                </View>
              </View>
            )}

            <View style={styles.infoFooter}>
              <Ionicons name="shield-checkmark-outline" size={14} color="rgba(255,255,255,.7)" />
              <Text style={styles.infoFooterText}>
                Municipality of Nasugbu · Batangas State University · TRAVIS v1.0
              </Text>
            </View>
          </View>

          {/* Login card */}
          <View style={[styles.loginCard, isWide && styles.loginCardWide]}>
            <View style={styles.badgeRow}>
              <View style={styles.circleBadge}>
                <Text style={styles.circleBadgeText}>LGU</Text>
              </View>
              <View style={styles.circleBadge}>
                <Text style={styles.circleBadgeText}>BSU</Text>
              </View>
            </View>

            <Text style={styles.title}>Welcome Back</Text>
            <Text style={styles.subtitle}>Authorized Personnel Only</Text>

            <View style={styles.form}>
              <Text style={styles.label}>Email / Username</Text>
              <TextInput
                ref={emailRef}
                style={styles.input}
                placeholder="Enter email address"
                placeholderTextColor="rgba(255,255,255,.5)"
                value={email}
                onChangeText={setEmail}
                autoCapitalize="none"
                autoCorrect={false}
                keyboardType="email-address"
                returnKeyType="next"
                onSubmitEditing={() => passwordRef.current?.focus()}
              />

              <Text style={styles.label}>Password</Text>
              <View style={styles.passwordRow}>
                <TextInput
                  ref={passwordRef}
                  style={[styles.input, styles.passwordInput]}
                  placeholder="Enter password"
                  placeholderTextColor="rgba(255,255,255,.5)"
                  value={password}
                  onChangeText={setPassword}
                  secureTextEntry={!showPassword}
                  returnKeyType="done"
                  onSubmitEditing={handleLogin}
                />
                <Pressable style={styles.eyeBtn} onPress={() => setShowPassword((s) => !s)}>
                  <Ionicons
                    name={showPassword ? 'eye-off-outline' : 'eye-outline'}
                    size={19}
                    color="rgba(255,255,255,.7)"
                  />
                </Pressable>
              </View>

              <View style={styles.optionsRow}>
                <Pressable style={styles.rememberRow} onPress={() => setRememberMe((v) => !v)}>
                  <View style={[styles.checkbox, rememberMe && styles.checkboxChecked]}>
                    {rememberMe && <Ionicons name="checkmark" size={13} color="#fff" />}
                  </View>
                  <Text style={styles.rememberText}>Remember me</Text>
                </Pressable>
                <Pressable onPress={() => Alert.alert('Forgot Password', 'Please contact your system administrator to reset your password.')}>
                  <Text style={styles.forgotText}>Forgot Password?</Text>
                </Pressable>
              </View>

              <Pressable
                style={[styles.button, loading && styles.buttonDisabled]}
                onPress={handleLogin}
                disabled={loading}>
                {loading ? (
                  <ActivityIndicator color="#fff" />
                ) : (
                  <>
                    <Ionicons name="log-in-outline" size={18} color="#fff" style={{ marginRight: 8 }} />
                    <Text style={styles.buttonText}>Sign In</Text>
                  </>
                )}
              </Pressable>

              <View style={styles.divider} />

              <Text style={styles.footerLine}>Traffic Violation Recognition and AI Surveillance</Text>
              <Text style={styles.footerLine}>Powered by Artificial Intelligence</Text>
            </View>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  flex: { flex: 1 },
  container: {
    flexGrow: 1,
    justifyContent: 'center',
    padding: 20,
    paddingBottom: 60,
    gap: 20,
  },
  containerWide: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 32,
    maxWidth: 1100,
    alignSelf: 'center',
    width: '100%',
  },

  // Info panel
  infoPanel: {
    backgroundColor: 'rgba(2,10,25,.55)',
    borderRadius: 20,
    borderWidth: 1,
    borderColor: 'rgba(56,189,248,.18)',
    padding: 24,
  },
  infoPanelWide: { flex: 1.1 },
  infoPanelNarrow: { width: '100%' },
  badge: {
    alignSelf: 'flex-start',
    backgroundColor: '#38bdf8',
    borderRadius: 6,
    paddingHorizontal: 10,
    paddingVertical: 5,
    marginBottom: 14,
  },
  badgeText: { color: '#001427', fontWeight: '700', fontSize: 11 },
  brandTitle: { color: '#fff', fontWeight: '800', fontSize: 34, letterSpacing: 0.5 },
  brandSubtitle: { color: 'rgba(255,255,255,.85)', fontSize: 16, marginTop: 6, fontWeight: '500' },
  brandDescription: { color: 'rgba(255,255,255,.6)', fontSize: 13.5, lineHeight: 21, marginTop: 16 },
  statRow: { flexDirection: 'row', gap: 12, marginTop: 22 },
  statCard: {
    flex: 1,
    backgroundColor: 'rgba(3,105,161,.18)',
    borderWidth: 1,
    borderColor: 'rgba(56,189,248,.22)',
    borderRadius: 12,
    paddingVertical: 16,
    alignItems: 'center',
  },
  statValue: { color: '#fff', fontWeight: '800', fontSize: 22 },
  statLabel: { color: 'rgba(255,255,255,.6)', fontSize: 11, marginTop: 4, textAlign: 'center' },
  infoFooter: { flexDirection: 'row', alignItems: 'center', gap: 6, marginTop: 24 },
  infoFooterText: { color: 'rgba(255,255,255,.6)', fontSize: 11.5 },

  // Login card
  loginCard: {
    backgroundColor: 'rgba(2,17,38,.55)',
    borderRadius: 20,
    borderWidth: 1,
    borderColor: 'rgba(56,189,248,.22)',
    padding: 24,
    width: '100%',
  },
  loginCardWide: { flex: 1, maxWidth: 440 },
  badgeRow: { flexDirection: 'row', justifyContent: 'center', gap: 14, marginBottom: 16 },
  circleBadge: {
    width: 52,
    height: 52,
    borderRadius: 26,
    backgroundColor: 'rgba(56,189,248,.14)',
    borderWidth: 1,
    borderColor: 'rgba(56,189,248,.28)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  circleBadgeText: { color: '#fff', fontWeight: '800', fontSize: 12 },
  title: { color: '#fff', fontWeight: '800', fontSize: 24, textAlign: 'center' },
  subtitle: { color: 'rgba(255,255,255,.7)', fontSize: 13, textAlign: 'center', marginTop: 4, marginBottom: 8 },
  form: { gap: 4, marginTop: 12 },
  label: { fontSize: 12.5, fontWeight: '600', color: 'rgba(255,255,255,.85)', marginTop: 12, marginBottom: 6 },
  input: {
    borderWidth: 1,
    borderColor: 'rgba(56,189,248,.25)',
    borderRadius: 10,
    paddingHorizontal: 14,
    paddingVertical: 12,
    fontSize: 15,
    color: '#fff',
    backgroundColor: 'rgba(3,20,40,.5)',
  },
  passwordRow: { position: 'relative', justifyContent: 'center' },
  passwordInput: { paddingRight: 44 },
  eyeBtn: { position: 'absolute', right: 10, padding: 6 },
  optionsRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 14,
  },
  rememberRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  checkbox: {
    width: 18,
    height: 18,
    borderRadius: 4,
    borderWidth: 1.5,
    borderColor: 'rgba(255,255,255,.4)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  checkboxChecked: { backgroundColor: '#38bdf8', borderColor: '#38bdf8' },
  rememberText: { color: 'rgba(255,255,255,.8)', fontSize: 13 },
  forgotText: { color: '#7dd3fc', fontSize: 13, fontWeight: '600' },
  button: {
    flexDirection: 'row',
    backgroundColor: '#0369a1',
    borderRadius: 10,
    paddingVertical: 14,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 20,
  },
  buttonDisabled: { opacity: 0.6 },
  buttonText: { color: '#fff', fontSize: 16, fontWeight: '700' },
  divider: { height: 1, backgroundColor: 'rgba(56,189,248,.18)', marginTop: 22, marginBottom: 12 },
  footerLine: { color: 'rgba(186,230,253,.55)', fontSize: 11.5, textAlign: 'center', lineHeight: 17 },
});