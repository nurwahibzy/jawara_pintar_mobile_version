import http from 'k6/http';
import { check, sleep, group } from 'k6';

// Configuration
const SUPABASE_URL = __ENV.SUPABASE_URL || 'https://iholxqagueeslwyeeufn.supabase.co';
const SUPABASE_KEY = __ENV.SUPABASE_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlob2x4cWFndWVlc2x3eWVldWZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM0MjY3ODMsImV4cCI6MjA3OTAwMjc4M30.o5Sz44vZhgiUgHac7Y4sqcL8OUIzQxg8cXE1-vh3TIY';

// Test Options with Scenarios
export const options = {
  scenarios: {
    // Skenario 1: Dashboard (Beban Ringan tapi Sering)
    dashboard_test: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '10s', target: 5 },
        { duration: '20s', target: 5 },
        { duration: '10s', target: 0 },
      ],
      exec: 'testDashboard', // Fungsi yang akan dijalankan
    },
    // Skenario 2: Cetak Laporan (Beban Berat tapi Jarang)
    laporan_test: {
      executor: 'constant-vus',
      vus: 2, // Hanya 2 user simultan
      duration: '30s',
      exec: 'testLaporan', // Fungsi yang akan dijalankan
    },
  },
  thresholds: {
    http_req_duration: ['p(95)<1000'], // Target umum < 1 detik
    'http_req_failed': ['rate<0.01'],
  },
};


// Headers helper
const getHeaders = (token) => ({
  'apikey': SUPABASE_KEY,
  'Authorization': `Bearer ${token}`,
  'Content-Type': 'application/json',
});

export function setup() {
  const authUrl = `${SUPABASE_URL}/auth/v1/token?grant_type=password`;
  const authPayload = JSON.stringify({
    email: 'admin1@gmail.com',
    password: 'password',
  });
  const authParams = { headers: { 'apikey': SUPABASE_KEY, 'Content-Type': 'application/json' } };

  const loginRes = http.post(authUrl, authPayload, authParams);
  if (loginRes.status !== 200) {
    throw new Error(`Login failed in setup: ${loginRes.status} - ${loginRes.body}`);
  }
  return { token: loginRes.json('access_token') };
}

// Fungsi Khusus Dashboard
export function testDashboard(data) {
  const token = data.token;
  const params = { headers: getHeaders(token) };

  group('Dashboard Features', () => {
    const keuanganRes = http.get(`${SUPABASE_URL}/rest/v1/pengeluaran?select=*&limit=10`, params);
    check(keuanganRes, { 'dashboard keuangan loaded': (r) => r.status === 200 });

    const kependudukanRes = http.get(`${SUPABASE_URL}/rest/v1/warga?select=count`, params);
    check(kependudukanRes, { 'dashboard kependudukan loaded': (r) => r.status === 200 });

    const kegiatanRes = http.get(`${SUPABASE_URL}/rest/v1/kegiatan?select=*&order=tanggal_pelaksanaan.desc&limit=5`, params);
    check(kegiatanRes, { 'dashboard kegiatan loaded': (r) => r.status === 200 });
  });
  sleep(1);
}

// Fungsi Khusus Laporan
export function testLaporan(data) {
  const token = data.token;
  const params = { headers: getHeaders(token) };

  group('Laporan & Cetak', () => {
    const laporanRes = http.get(`${SUPABASE_URL}/rest/v1/pengeluaran?select=*&tanggal_transaksi=gte.2024-01-01&tanggal_transaksi=lte.2024-01-31`, params);
    check(laporanRes, { 'laporan data fetched': (r) => r.status === 200 });

    const cetakRes = http.get(`${SUPABASE_URL}/rest/v1/pengeluaran?select=*&tanggal_transaksi=gte.2024-01-01&tanggal_transaksi=lte.2024-12-31`, params);
    check(cetakRes, { 
      'cetak laporan query success': (r) => r.status === 200,
      'query duration < 2s': (r) => r.timings.duration < 2000,
    });
  });
  sleep(2);
}

export default function () {}
