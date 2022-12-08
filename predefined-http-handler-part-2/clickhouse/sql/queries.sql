CREATE TABLE test (key UInt32, value UInt64) ENGINE=MergeTree ORDER BY (key);
INSERT INTO test SELECT number % 100000, rand64() FROM numbers(1000000) FORMAT Null;
INSERT INTO test SELECT 5000 + number % 100000, rand64() FROM numbers(1000000) SETTINGS opentelemetry_trace_processors=1 FORMAT Null;
SELECT key, sum(value), avg(value), median(value) FROM test GROUP BY key FORMAT Null;
SELECT key, sum(value), avg(value), median(value) FROM test GROUP BY key SETTINGS max_threads=1 FORMAT Null;
SELECT key, sum(value), avg(value), median(value) FROM test GROUP BY key SETTINGS max_threads=1, opentelemetry_trace_processors=1 FORMAT Null;
SELECT * FROM (SELECT key, max(value) as max FROM test GROUP BY key) as a JOIN (SELECT (100000 - key) as key, min(value) FROM test WHERE value % 2 = 0 GROUP BY key) as b ON a.key=b.key ORDER BY key LIMIT 10000 FORMAT Null;
SELECT * FROM (SELECT key, max(value) as max FROM test GROUP BY key) as a JOIN (SELECT (100000 - key) as key, min(value) FROM test WHERE value % 2 = 0 GROUP BY key) as b ON a.key=b.key ORDER BY key LIMIT 10000 SETTINGS max_threads = 1, opentelemetry_trace_processors = 1 FORMAT Null;