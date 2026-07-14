import { Ionicons } from '@expo/vector-icons';
import { useCallback, useEffect, useState } from 'react';
import {
  ActivityIndicator,
  RefreshControl,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { BarChart, PieChart } from 'react-native-gifted-charts';

import api from '@/api/axiosConfig';
import { PortalHeader } from '@/components/portal-header';
import { useCurrentUser } from '@/hooks/use-current-user';

type ChartPoint = { label: string; value: number };
type StatusSlice = { label: string; value: number; color: string };

type DashboardData = {
  totalViolations: number;
  pendingViolations: number;
  paidViolations: number;
  todaysCollections: number;
  monthlyCollections: number;
  recentPayments: {
    payment_id: number;
    amount_paid: string;
    payment_date: string;
    payment_method: string;
    ticket_number: string;
    driver_name: string;
  }[];
  pendingPayments: {
    violation_id: number;
    ticket_number: string;
    driver_name: string;
    penalty_amount: string;
    violation_date: string;
  }[];
  dailyCollection: ChartPoint[];
  monthlyCollection: ChartPoint[];
  paymentStatusDistribution: StatusSlice[];
};

const peso = (value: number) =>
  `₱${value.toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;

export default function DashboardScreen() {
  const user = useCurrentUser();
  const [data, setData] = useState<DashboardData | null>(null);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    try {
      setError(null);
      const response = await api.get('/api/dashboard');
      setData(response.data);
    } catch {
      setError('Unable to load dashboard data. Please try again.');
    }
  }, []);

  useEffect(() => {
    load().finally(() => setLoading(false));
  }, [load]);

  const onRefresh = async () => {
    setRefreshing(true);
    await load();
    setRefreshing(false);
  };

  if (loading) {
    return (
      <View style={[styles.screen, styles.centered]}>
        <ActivityIndicator color="#0d9488" size="large" />
      </View>
    );
  }

  const stats = [
    {
      key: 'total',
      icon: 'car-outline' as const,
      iconColor: '#2563eb',
      badgeColor: '#dbeafe',
      label: 'TOTAL VIOLATIONS',
      value: data ? data.totalViolations.toLocaleString() : '—',
    },
    {
      key: 'pending',
      icon: 'time-outline' as const,
      iconColor: '#d97706',
      badgeColor: '#fef3c7',
      label: 'PENDING PAYMENTS',
      value: data ? data.pendingViolations.toLocaleString() : '—',
    },
    {
      key: 'paid',
      icon: 'checkmark-circle-outline' as const,
      iconColor: '#059669',
      badgeColor: '#d1fae5',
      label: 'PAID VIOLATIONS',
      value: data ? data.paidViolations.toLocaleString() : '—',
    },
    {
      key: 'today',
      icon: 'wallet-outline' as const,
      iconColor: '#ea580c',
      badgeColor: '#ffedd5',
      label: "TODAY'S COLLECTIONS",
      value: data ? peso(data.todaysCollections) : '—',
    },
    {
      key: 'month',
      icon: 'trending-up-outline' as const,
      iconColor: '#7c3aed',
      badgeColor: '#ede9fe',
      label: 'MONTHLY COLLECTIONS',
      value: data ? peso(data.monthlyCollections) : '—',
    },
  ];

  return (
    <ScrollView
      style={styles.screen}
      contentContainerStyle={styles.content}
      refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor="#0d9488" />}>
      <PortalHeader
        title="Dashboard"
        subtitle="Overview of collections and violation payments"
        userName={user?.full_name}
        userRole={user?.role}
      />

      {error && (
        <View style={styles.errorBanner}>
          <Ionicons name="alert-circle-outline" size={16} color="#b91c1c" />
          <Text style={styles.errorText}>{error}</Text>
        </View>
      )}

      <View style={styles.statGrid}>
        {stats.map((stat) => (
          <View key={stat.key} style={styles.statCard}>
            <View style={[styles.statIconBadge, { backgroundColor: stat.badgeColor }]}>
              <Ionicons name={stat.icon} size={20} color={stat.iconColor} />
            </View>
            <Text style={styles.statLabel}>{stat.label}</Text>
            <Text style={styles.statValue}>{stat.value}</Text>
          </View>
        ))}
      </View>

      <View style={styles.panelGrid}>
        <View style={styles.panel}>
          <Text style={styles.panelTitle}>Daily Collection</Text>
          <Text style={styles.panelSubtitle}>Last 7 days</Text>
          {data && data.dailyCollection.some((d) => d.value > 0) ? (
            <View style={styles.chartWrap}>
              <BarChart
                data={data.dailyCollection.map((d) => ({ value: d.value, label: d.label }))}
                barWidth={22}
                spacing={18}
                roundedTop
                frontColor="#0d9488"
                yAxisThickness={0}
                xAxisThickness={1}
                xAxisColor="#e2e8f0"
                xAxisLabelTextStyle={styles.chartAxisLabel}
                noOfSections={4}
                hideRules
                height={140}
              />
            </View>
          ) : (
            <View style={styles.panelEmpty}>
              <Ionicons name="bar-chart-outline" size={26} color="#cbd5e1" />
            </View>
          )}
        </View>

        <View style={styles.panel}>
          <Text style={styles.panelTitle}>Monthly Collection</Text>
          <Text style={styles.panelSubtitle}>Calendar year overview</Text>
          {data && data.monthlyCollection.some((d) => d.value > 0) ? (
            <View style={styles.chartWrap}>
              <ScrollView horizontal showsHorizontalScrollIndicator={false}>
                <BarChart
                  data={data.monthlyCollection.map((d) => ({ value: d.value, label: d.label }))}
                  barWidth={16}
                  spacing={14}
                  roundedTop
                  frontColor="#2563eb"
                  yAxisThickness={0}
                  xAxisThickness={1}
                  xAxisColor="#e2e8f0"
                  xAxisLabelTextStyle={styles.chartAxisLabel}
                  noOfSections={4}
                  hideRules
                  height={140}
                />
              </ScrollView>
            </View>
          ) : (
            <View style={styles.panelEmpty}>
              <Ionicons name="stats-chart-outline" size={26} color="#cbd5e1" />
            </View>
          )}
        </View>

        <View style={styles.panel}>
          <Text style={styles.panelTitle}>Payment Status Distribution</Text>
          <Text style={styles.panelSubtitle}>Completed, pending, failed, refunded</Text>
          {data && data.paymentStatusDistribution.length > 0 ? (
            <View style={styles.pieRow}>
              <PieChart
                data={data.paymentStatusDistribution.map((s) => ({ value: s.value, color: s.color }))}
                donut
                radius={54}
                innerRadius={34}
                innerCircleColor="#ffffff"
              />
              <View style={styles.legend}>
                {data.paymentStatusDistribution.map((s) => (
                  <View key={s.label} style={styles.legendRow}>
                    <View style={[styles.legendDot, { backgroundColor: s.color }]} />
                    <Text style={styles.legendLabel}>
                      {s.label[0].toUpperCase() + s.label.slice(1)} ({s.value})
                    </Text>
                  </View>
                ))}
              </View>
            </View>
          ) : (
            <View style={styles.panelEmpty}>
              <Ionicons name="pie-chart-outline" size={26} color="#cbd5e1" />
            </View>
          )}
        </View>
      </View>

      <ListPanel
        title="Recent Payments"
        emptyLabel="No payments recorded yet"
        items={data?.recentPayments.map((p) => ({
          id: p.payment_id,
          primary: p.driver_name,
          secondary: `Ticket #${p.ticket_number} · ${p.payment_method}`,
          amount: peso(Number(p.amount_paid)),
        }))}
      />

      <ListPanel
        title="Pending Payments"
        emptyLabel="No pending payments"
        items={data?.pendingPayments.map((v) => ({
          id: v.violation_id,
          primary: v.driver_name,
          secondary: `Ticket #${v.ticket_number}`,
          amount: peso(Number(v.penalty_amount)),
        }))}
      />
    </ScrollView>
  );
}

type ListPanelItem = {
  id: number;
  primary: string;
  secondary: string;
  amount: string;
};

function ListPanel({
  title,
  emptyLabel,
  items,
}: {
  title: string;
  emptyLabel: string;
  items?: ListPanelItem[];
}) {
  return (
    <View style={styles.listPanel}>
      <View style={styles.listPanelHeader}>
        <Text style={styles.panelTitle}>{title}</Text>
        <Text style={styles.viewAll}>View all</Text>
      </View>
      {!items || items.length === 0 ? (
        <View style={styles.listEmpty}>
          <Ionicons name="file-tray-outline" size={26} color="#cbd5e1" />
          <Text style={styles.listEmptyText}>{emptyLabel}</Text>
        </View>
      ) : (
        items.map((item) => (
          <View key={item.id} style={styles.listRow}>
            <View style={styles.listRowText}>
              <Text style={styles.listRowPrimary}>{item.primary}</Text>
              <Text style={styles.listRowSecondary}>{item.secondary}</Text>
            </View>
            <Text style={styles.listRowAmount}>{item.amount}</Text>
          </View>
        ))
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: '#f8fafc' },
  centered: { alignItems: 'center', justifyContent: 'center' },
  content: { padding: 20, paddingBottom: 48, gap: 20 },
  errorBanner: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    backgroundColor: '#fee2e2',
    borderWidth: 1,
    borderColor: '#fecaca',
    borderRadius: 10,
    padding: 12,
  },
  errorText: { color: '#b91c1c', fontSize: 12.5, flex: 1 },
  statGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 12 },
  statCard: {
    flexBasis: '47%',
    flexGrow: 1,
    backgroundColor: '#ffffff',
    borderRadius: 16,
    padding: 16,
    shadowColor: '#0f172a',
    shadowOpacity: 0.06,
    shadowRadius: 10,
    shadowOffset: { width: 0, height: 4 },
    elevation: 2,
  },
  statIconBadge: {
    width: 38,
    height: 38,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 12,
  },
  statLabel: {
    color: '#94a3b8',
    fontSize: 10.5,
    fontWeight: '700',
    letterSpacing: 0.5,
  },
  statValue: { color: '#0f172a', fontSize: 22, fontWeight: '800', marginTop: 6 },
  panelGrid: { gap: 12 },
  panel: {
    backgroundColor: '#ffffff',
    borderRadius: 16,
    padding: 16,
    shadowColor: '#0f172a',
    shadowOpacity: 0.06,
    shadowRadius: 10,
    shadowOffset: { width: 0, height: 4 },
    elevation: 2,
  },
  panelTitle: { color: '#0f172a', fontSize: 15, fontWeight: '700' },
  panelSubtitle: { color: '#94a3b8', fontSize: 12, marginTop: 2 },
  panelEmpty: {
    height: 90,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 10,
  },
  chartWrap: { marginTop: 14 },
  chartAxisLabel: { color: '#94a3b8', fontSize: 10 },
  pieRow: { flexDirection: 'row', alignItems: 'center', gap: 16, marginTop: 14 },
  legend: { flex: 1, gap: 8 },
  legendRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  legendDot: { width: 9, height: 9, borderRadius: 5 },
  legendLabel: { color: '#475569', fontSize: 12 },
  listPanel: {
    backgroundColor: '#ffffff',
    borderRadius: 16,
    padding: 16,
    shadowColor: '#0f172a',
    shadowOpacity: 0.06,
    shadowRadius: 10,
    shadowOffset: { width: 0, height: 4 },
    elevation: 2,
  },
  listPanelHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  viewAll: { color: '#0d9488', fontSize: 12.5, fontWeight: '600' },
  listEmpty: { alignItems: 'center', justifyContent: 'center', paddingVertical: 28, gap: 8 },
  listEmptyText: { color: '#94a3b8', fontSize: 12.5 },
  listRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 10,
    borderTopWidth: 1,
    borderTopColor: '#f1f5f9',
    marginTop: 10,
  },
  listRowText: { flex: 1, paddingRight: 12 },
  listRowPrimary: { color: '#0f172a', fontSize: 13.5, fontWeight: '600' },
  listRowSecondary: { color: '#94a3b8', fontSize: 11.5, marginTop: 2 },
  listRowAmount: { color: '#0d9488', fontSize: 13.5, fontWeight: '700' },
});
