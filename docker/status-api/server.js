const http = require("http");

const PORT = Number(process.env.PORT) || 3001;
const VERSION = process.env.BUILD_NUMBER || "local";
const GIT_SHA = process.env.GIT_COMMIT || "unknown";
const BUILD_TIME = new Date().toISOString();

const server = http.createServer((req, res) => {
  if (req.url === "/api/health" || req.url === "/healthz") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ status: "ok" }));
    return;
  }

  if (req.url === "/api/version") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(
      JSON.stringify({
        version: VERSION,
        gitSha: GIT_SHA,
        buildTime: BUILD_TIME,
      })
    );
    return;
  }

  res.writeHead(404, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ error: "not_found" }));
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(`status-api listening on ${PORT}`);
});
