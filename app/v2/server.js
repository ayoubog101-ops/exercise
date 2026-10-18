const express = require('express');
const app = express();
const port = 3002;

let requestCount = 0;

app.get('/', (req, res) => {
  requestCount += 1;
  console.log(`v2 handled request #${requestCount}`);
  res.send('Hello from v2 (Green/Canary)!');
});

// Exercise 4: health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', version: 'v2' });
});

// Exercise 3: see how many requests this version received
app.get('/stats', (req, res) => {
  res.json({ version: 'v2', requests: requestCount });
});

app.listen(port, () => console.log(`v2 running on ${port}`));
