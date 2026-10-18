const express = require('express');
const app = express();
const port = 3001;

let requestCount = 0;

app.get('/', (req, res) => {
  requestCount += 1;
  console.log(`v1 handled request #${requestCount}`);
  res.send('Hello from v1 (Blue)!');
});

// Exercise 4: health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', version: 'v1' });
});

// Exercise 3: see how many requests this version received
app.get('/stats', (req, res) => {
  res.json({ version: 'v1', requests: requestCount });
});

app.listen(port, () => console.log(`v1 running on ${port}`));
