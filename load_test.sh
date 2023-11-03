import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  vus: 10,           // Number of virtual users (simulated users)
  duration: '30s',   // Test duration (e.g., 30 seconds)
};

export default function () {
  // Define the HTTP request
  let response = http.get('http://web-lb-606500421.us-east-1.elb.amazonaws.com/dependencies');

  // Check the response for a successful status code (e.g., 200)
  check(response, {
    'is status 200': (r) => r.status === 200,
  });

  // Add a custom sleep time to simulate user think time (e.g., 1-2 seconds)
  sleep(1 + Math.random() * 2);
}
