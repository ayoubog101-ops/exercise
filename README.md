# Blue/Green and Canary Demo

Zero-downtime deployment demo with Docker, Nginx and GitHub Actions.
Two versions of a small Node app (v1 Blue, v2 Green/Canary) sit behind Nginx.

## Run it

```bash
docker compose up --build
```

Open http://localhost:8080 and refresh. By default Nginx runs a canary split: 95% of requests go to v1 and 5% go to v2.

## Switch modes

```bash
chmod +x switch.sh test-traffic.sh
./switch.sh canary   # 95% v1, 5% v2
./switch.sh green    # all traffic to v2 (blue/green cutover)
./switch.sh blue     # all traffic to v1 (instant rollback)
```

The script copies a config from `nginx/conf/` into `nginx/nginx.conf`, tests it, and reloads Nginx without dropping connections.

## Count requests per version

```bash
./test-traffic.sh 200
```

You can also ask each app directly: `http://localhost:3001/stats` and `http://localhost:3002/stats`.

## Exercises

1. Canary rollout: edit the weights in `nginx/conf/canary.conf` (5, 20, 50, 100), run `./switch.sh canary`, then `./test-traffic.sh`.
2. Blue/Green rollback: break v2 on purpose (for example make `/health` return 500), switch to green, then run `./switch.sh blue`.
3. Logging: `/stats` and `test-traffic.sh` already count requests. Try adding timestamps.
4. Health checks: both apps have `/health`. Compose uses it before starting Nginx, and Nginx stops sending traffic to a failing server through `max_fails`.

## Project layout

```
app/v1, app/v2      Node services with Dockerfiles
nginx/              Nginx image, active config, and conf/ presets
docker-compose.yml  Runs v1, v2 and Nginx
.github/workflows   CI pipeline
```

## Notes

- Nginx open source only has passive health checks. Active checks need Nginx Plus or another proxy.
- The weights 95/5 are applied as a repeating pattern, so 100 requests give almost exactly 95 and 5.
