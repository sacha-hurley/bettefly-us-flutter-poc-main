/// Single source of truth for BetterFlies ↔︎ USD conversion
/// Example rate: 100 BFs = $1.00 (adjust easily here)

const int kBfsPerDollar = 100; // 100 BFs == $1.00

double bfsToUsd(int bfs) => bfs / kBfsPerDollar;

int usdToBfs(double usd) => (usd * kBfsPerDollar).round();
