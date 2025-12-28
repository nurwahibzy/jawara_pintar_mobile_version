import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  vus: 20,
  duration: "30s",
};

export default function () {
  // cara run
  // k6 run -e SUPABASE_URL="https://url-project.supabase.co" -e SUPABASE_KEY="........." load_tests/pengeluaran_test.js
  
  const sbUrl = __ENV.SUPABASE_URL;
  const sbKey = __ENV.SUPABASE_KEY;

  if (!sbUrl || !sbKey) {
    throw new Error(
      "ERROR: URL atau KEY belum dimasukkan! Gunakan flag -e saat run."
    );
  }

  // 3. Setup URL & Header
  const url = `${sbUrl}/rest/v1/pengeluaran?select=*`;

  const params = {
    headers: {
      apikey: sbKey,
      Authorization: `Bearer ${sbKey}`,
      "Content-Type": "application/json",
    },
  };

  const res = http.get(url, params);

  check(res, {
    "status aman (200)": (r) => r.status === 200,
  });

  sleep(1);
}