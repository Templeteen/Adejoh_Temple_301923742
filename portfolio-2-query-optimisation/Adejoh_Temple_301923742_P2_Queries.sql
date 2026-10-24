-- Show related appointment, patient, clinician records (up to 20).
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

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
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

-- Find patient records where medical_record_no matches "SYN-MR-101" (up to 20).
SELECT * FROM portfolio."patient"
WHERE "medical_record_no" IS NOT DISTINCT FROM 'SYN-MR-101'
ORDER BY "patient_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."patient"
WHERE "medical_record_no" IS NOT DISTINCT FROM 'SYN-MR-101'
ORDER BY "patient_id"
LIMIT 20;

-- Count encounter records for each appointment_id (up to 20 groups).
SELECT "appointment_id", count(*) AS record_count
FROM portfolio."encounter"
GROUP BY "appointment_id"
ORDER BY record_count DESC, "appointment_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "appointment_id", count(*) AS record_count
FROM portfolio."encounter"
GROUP BY "appointment_id"
ORDER BY record_count DESC, "appointment_id" NULLS LAST
LIMIT 20;

-- Count appointment records for each patient_id (up to 20 groups).
SELECT "patient_id", count(*) AS record_count
FROM portfolio."appointment"
GROUP BY "patient_id"
ORDER BY record_count DESC, "patient_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "patient_id", count(*) AS record_count
FROM portfolio."appointment"
GROUP BY "patient_id"
ORDER BY record_count DESC, "patient_id" NULLS LAST
LIMIT 20;
