# Hospital / Clinic System — SQL queries

## 1. Show related appointment, patient, clinician records (up to 20).

```sql
SELECT t0."appointment_id" AS "appointment_appointment_id",
       t0."start_at" AS "appointment_start_at",
       t1."patient_id" AS "patient_patient_id",
       t1."medical_record_no" AS "patient_medical_record_no",
       t2."clinician_id" AS "clinician_clinician_id",
       t2."license_no" AS "clinician_license_no"
FROM portfolio."appointment" t0
JOIN portfolio."patient" t1 ON t0."patient_id" = t1."patient_id"
JOIN portfolio."clinician" t2 ON t0."clinician_id" = t2."clinician_id"
ORDER BY t0."appointment_id", t1."patient_id", t2."clinician_id"
LIMIT 20;
```

| appointment_appointment_id | appointment_start_at | patient_patient_id | patient_medical_record_no | clinician_clinician_id | clinician_license_no |
| --- | --- | --- | --- | --- | --- |
| 301 | 2026-11-02T09:00:00+00:00 | 101 | SYN-MR-101 | 201 | SYN-LIC-201 |
| 302 | 2026-11-03T10:30:00+00:00 | 102 | SYN-MR-102 | 202 | SYN-LIC-202 |

## 2. Find patient records where medical_record_no matches "SYN-MR-101" (up to 20).

```sql
SELECT * FROM portfolio."patient"
WHERE "medical_record_no" IS NOT DISTINCT FROM 'SYN-MR-101'
ORDER BY "patient_id"
LIMIT 20;
```

| patient_id | medical_record_no | full_name | date_of_birth |
| --- | --- | --- | --- |
| 101 | SYN-MR-101 | Alex Sample | 1988-04-12 |

## 3. Count encounter records for each appointment_id (up to 20 groups).

```sql
SELECT "appointment_id", count(*) AS record_count
FROM portfolio."encounter"
GROUP BY "appointment_id"
ORDER BY record_count DESC, "appointment_id" NULLS LAST
LIMIT 20;
```

| appointment_id | record_count |
| --- | --- |
| 302 | 1 |

## 4. Count appointment records for each patient_id (up to 20 groups).

```sql
SELECT "patient_id", count(*) AS record_count
FROM portfolio."appointment"
GROUP BY "patient_id"
ORDER BY record_count DESC, "patient_id" NULLS LAST
LIMIT 20;
```

| patient_id | record_count |
| --- | --- |
| 101 | 1 |
| 102 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.994 | 0.994, 1.026, 0.985 | Sort → Seq Scan | 112 |
| After index | 0.179 | 0.179, 0.184, 0.178 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.994 ms to 0.179 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.962..0.964 rows=20 loops=1)
  Seq Scan on appointment (actual time=0.014..0.928 rows=20 loops=1)
Planning Time: 0.325 ms
Execution Time: 0.994 ms
```

### Before index, run 2

```text
Sort (actual time=0.995..0.997 rows=20 loops=1)
  Seq Scan on appointment (actual time=0.014..0.961 rows=20 loops=1)
Planning Time: 0.323 ms
Execution Time: 1.026 ms
```

### Before index, run 3

```text
Sort (actual time=0.957..0.958 rows=20 loops=1)
  Seq Scan on appointment (actual time=0.014..0.923 rows=20 loops=1)
Planning Time: 0.328 ms
Execution Time: 0.985 ms
```

### After index, run 1

```text
Sort (actual time=0.122..0.124 rows=20 loops=1)
  Bitmap Heap Scan on appointment (actual time=0.03..0.088 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.018 rows=20 loops=1)
Planning Time: 0.559 ms
Execution Time: 0.179 ms
```

### After index, run 2

```text
Sort (actual time=0.127..0.128 rows=20 loops=1)
  Bitmap Heap Scan on appointment (actual time=0.029..0.092 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=20 loops=1)
Planning Time: 0.539 ms
Execution Time: 0.184 ms
```

### After index, run 3

```text
Sort (actual time=0.124..0.126 rows=20 loops=1)
  Bitmap Heap Scan on appointment (actual time=0.03..0.091 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=20 loops=1)
Planning Time: 0.571 ms
Execution Time: 0.178 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Adejoh_Temple_301923742_P2_Queries.sql, then Adejoh_Temple_301923742_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Adejoh_Temple_301923742_P2_QueryResults.png) · [Index comparison](screenshots/Adejoh_Temple_301923742_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

