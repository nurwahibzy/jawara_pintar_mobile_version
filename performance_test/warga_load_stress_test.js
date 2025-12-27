import http from 'k6/http';
import { check, sleep, group } from 'k6';
import { Rate } from 'k6/metrics';

// Custom metrics
const errorRate = new Rate('errors');

// Configuration
const SUPABASE_URL = __ENV.SUPABASE_URL || 'https://iholxqagueeslwyeeufn.supabase.co';
const SUPABASE_KEY = __ENV.SUPABASE_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlob2x4cWFndWVlc2x3eWVldWZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM0MjY3ODMsImV4cCI6MjA3OTAwMjc4M30.o5Sz44vZhgiUgHac7Y4sqcL8OUIzQxg8cXE1-vh3TIY';

// Test Options with Load and Stress Test Scenarios
export const options = {
  scenarios: {
    // Load Test: Simulate normal usage
    load_test: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '30s', target: 10 },  // Ramp up to 10 users
        { duration: '1m', target: 10 },   // Stay at 10 users
        { duration: '30s', target: 20 },  // Ramp up to 20 users
        { duration: '1m', target: 20 },   // Stay at 20 users
        { duration: '30s', target: 0 },   // Ramp down to 0
      ],
      gracefulRampDown: '30s',
      exec: 'loadTest',
    },
    // Stress Test: Push the system to its limits
    stress_test: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '1m', target: 50 },   // Ramp up to 50 users
        { duration: '2m', target: 50 },   // Stay at 50 users
        { duration: '1m', target: 100 },  // Ramp up to 100 users
        { duration: '2m', target: 100 },  // Stay at 100 users
        { duration: '1m', target: 150 },  // Ramp up to 150 users
        { duration: '2m', target: 150 },  // Stay at 150 users
        { duration: '1m', target: 0 },    // Ramp down to 0
      ],
      gracefulRampDown: '30s',
      exec: 'stressTest',
      startTime: '4m',  // Start after load test finishes
    },
  },
  thresholds: {
    // Load test thresholds
    'http_req_duration{scenario:load_test}': ['p(95)<1500', 'p(99)<2000'],
    'http_req_failed{scenario:load_test}': ['rate<0.01'],
    'errors{scenario:load_test}': ['rate<0.05'],
    
    // Stress test thresholds (more relaxed)
    'http_req_duration{scenario:stress_test}': ['p(95)<3000', 'p(99)<5000'],
    'http_req_failed{scenario:stress_test}': ['rate<0.05'],
    'errors{scenario:stress_test}': ['rate<0.10'],
    
    // Overall thresholds
    'http_req_duration': ['avg<2000'],
    'http_reqs': ['rate>10'],
  },
};

// Headers helper
const getHeaders = (token) => ({
  'apikey': SUPABASE_KEY,
  'Authorization': `Bearer ${token}`,
  'Content-Type': 'application/json',
  'Prefer': 'return=representation',
});

// Setup function - authenticate once
export function setup() {
  const authUrl = `${SUPABASE_URL}/auth/v1/token?grant_type=password`;
  const authPayload = JSON.stringify({
    email: 'admin1@gmail.com',
    password: 'password',
  });

  const authHeaders = {
    'apikey': SUPABASE_KEY,
    'Content-Type': 'application/json',
  };

  const authResponse = http.post(authUrl, authPayload, { headers: authHeaders });
  
  if (authResponse.status !== 200) {
    console.error('Authentication failed:', authResponse.body);
    return null;
  }

  const authData = JSON.parse(authResponse.body);
  return {
    token: authData.access_token,
  };
}

// Load Test Function
export function loadTest(data) {
  if (!data || !data.token) {
    console.error('No auth token available');
    return;
  }

  const headers = getHeaders(data.token);

  group('Warga Load Test - Get All Warga', () => {
    const response = http.get(
      `${SUPABASE_URL}/rest/v1/warga?select=*`,
      { headers }
    );

    const success = check(response, {
      'status is 200': (r) => r.status === 200,
      'response time < 1500ms': (r) => r.timings.duration < 1500,
      'has warga data': (r) => {
        try {
          const data = JSON.parse(r.body);
          return Array.isArray(data) && data.length > 0;
        } catch (e) {
          return false;
        }
      },
    });

    errorRate.add(!success);
  });

  sleep(1);

  group('Warga Load Test - Filter Warga by Name', () => {
    const response = http.get(
      `${SUPABASE_URL}/rest/v1/warga?nama_lengkap=ilike.*a*&select=*`,
      { headers }
    );

    const success = check(response, {
      'status is 200': (r) => r.status === 200,
      'response time < 1500ms': (r) => r.timings.duration < 1500,
    });

    errorRate.add(!success);
  });

  sleep(1);

  group('Warga Load Test - Get Warga with Keluarga', () => {
    const response = http.get(
      `${SUPABASE_URL}/rest/v1/warga?select=*,keluarga:keluarga_id(*)&limit=10`,
      { headers }
    );

    const success = check(response, {
      'status is 200': (r) => r.status === 200,
      'response time < 2000ms': (r) => r.timings.duration < 2000,
    });

    errorRate.add(!success);
  });

  sleep(2);
}

// Stress Test Function
export function stressTest(data) {
  if (!data || !data.token) {
    console.error('No auth token available');
    return;
  }

  const headers = getHeaders(data.token);

  group('Warga Stress Test - Rapid Read Operations', () => {
    // Multiple rapid requests
    const responses = http.batch([
      ['GET', `${SUPABASE_URL}/rest/v1/warga?select=id,nama_lengkap&limit=50`, null, { headers }],
      ['GET', `${SUPABASE_URL}/rest/v1/warga?select=*&limit=20`, null, { headers }],
      ['GET', `${SUPABASE_URL}/rest/v1/warga?select=*,keluarga:keluarga_id(*)&limit=10`, null, { headers }],
    ]);

    responses.forEach((response, index) => {
      const success = check(response, {
        [`batch ${index + 1} - status is 200`]: (r) => r.status === 200,
        [`batch ${index + 1} - response time < 3000ms`]: (r) => r.timings.duration < 3000,
      });
      errorRate.add(!success);
    });
  });

  sleep(0.5);

  group('Warga Stress Test - Complex Query', () => {
    const response = http.get(
      `${SUPABASE_URL}/rest/v1/warga?select=*,keluarga:keluarga_id(*)&status_hidup=eq.Hidup&order=created_at.desc&limit=100`,
      { headers }
    );

    const success = check(response, {
      'status is 200': (r) => r.status === 200,
      'response time < 3000ms': (r) => r.timings.duration < 3000,
      'has data': (r) => {
        try {
          const data = JSON.parse(r.body);
          return Array.isArray(data);
        } catch (e) {
          return false;
        }
      },
    });

    errorRate.add(!success);
  });

  sleep(0.5);

  group('Warga Stress Test - Filter Multiple Conditions', () => {
    const response = http.get(
      `${SUPABASE_URL}/rest/v1/warga?jenis_kelamin=eq.L&status_penduduk=eq.Tetap&select=*&limit=50`,
      { headers }
    );

    const success = check(response, {
      'status is 200': (r) => r.status === 200,
      'response time < 2500ms': (r) => r.timings.duration < 2500,
    });

    errorRate.add(!success);
  });

  sleep(1);
}

// Teardown function
export function teardown(data) {
  console.log('Performance test completed!');
}

// Handle summary
export function handleSummary(data) {
  return {
    'stdout': textSummary(data, { indent: ' ', enableColors: true }),
    'warga_performance_summary.json': JSON.stringify(data),
  };
}

function textSummary(data, options) {
  const indent = options.indent || '';
  const enableColors = options.enableColors !== false;
  
  let summary = '\n' + indent + '=== Performance Test Summary ===\n\n';
  
  // Scenarios summary
  for (const scenario in data.metrics) {
    if (scenario.includes('scenario:')) {
      summary += indent + `Scenario: ${scenario}\n`;
    }
  }
  
  // Key metrics
  summary += '\n' + indent + '=== Key Metrics ===\n';
  summary += indent + `Total Requests: ${data.metrics.http_reqs ? data.metrics.http_reqs.values.count : 0}\n`;
  summary += indent + `Failed Requests: ${data.metrics.http_req_failed ? (data.metrics.http_req_failed.values.rate * 100).toFixed(2) : 0}%\n`;
  summary += indent + `Avg Response Time: ${data.metrics.http_req_duration ? data.metrics.http_req_duration.values.avg.toFixed(2) : 0}ms\n`;
  summary += indent + `95th Percentile: ${data.metrics.http_req_duration ? data.metrics.http_req_duration.values['p(95)'].toFixed(2) : 0}ms\n`;
  summary += indent + `99th Percentile: ${data.metrics.http_req_duration ? data.metrics.http_req_duration.values['p(99)'].toFixed(2) : 0}ms\n`;
  
  return summary;
}
