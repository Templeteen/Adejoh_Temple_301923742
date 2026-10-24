-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. patient pk duplicate. Expected: pk_patient, SQLSTATE 23505.
INSERT INTO portfolio."patient" ("patient_id", "medical_record_no", "full_name", "date_of_birth")
VALUES (101, 'SYN-MR-9001', 'Taylor Synthetic', '1990-01-01');

-- 2. patient unique duplicate. Expected: uq_patient_0, SQLSTATE 23505.
INSERT INTO portfolio."patient" ("patient_id", "medical_record_no", "full_name", "date_of_birth")
VALUES (9002, 'SYN-MR-101', 'Morgan Synthetic', '1991-02-02');

-- 3. patient not null. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."patient" ("patient_id", "medical_record_no", "full_name", "date_of_birth")
VALUES (9003, 'SYN-MR-9003', NULL, '1993-03-03');

-- 4. clinician pk duplicate. Expected: pk_clinician, SQLSTATE 23505.
INSERT INTO portfolio."clinician" ("clinician_id", "license_no", "full_name", "specialty")
VALUES (201, 'SYN-LIC-9004', 'Dr. Avery Synthetic', 'Family Medicine');

-- 5. clinician unique duplicate. Expected: uq_clinician_0, SQLSTATE 23505.
INSERT INTO portfolio."clinician" ("clinician_id", "license_no", "full_name", "specialty")
VALUES (9005, 'SYN-LIC-201', 'Dr. Quinn Synthetic', 'Neurology');

-- 6. appointment pk duplicate. Expected: pk_appointment, SQLSTATE 23505.
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "start_at", "status", "reason")
VALUES (301, 102, 202, '2026-11-04T11:00:00Z', 'cancelled', 'Synthetic duplicate primary key');

-- 7. appointment patient fk missing. Expected: fk_appointment_0, SQLSTATE 23503.
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "start_at", "status", "reason")
VALUES (9007, 99007, 201, '2026-11-05T09:00:00Z', 'scheduled', 'Synthetic foreign key test');

-- 8. appointment clinician fk missing. Expected: fk_appointment_1, SQLSTATE 23503.
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "start_at", "status", "reason")
VALUES (9008, 101, 99008, '2026-11-05T10:00:00Z', 'scheduled', 'Synthetic foreign key test');

-- 9. appointment status invalid. Expected: appointment_status_check, SQLSTATE 23514.
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "start_at", "status", "reason")
VALUES (9009, 101, 202, '2026-11-06T09:00:00Z', 'pending', 'Synthetic check test');

-- 10. appointment active slot duplicate. Expected: clinician_active_slot, SQLSTATE 23505.
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "start_at", "status", "reason")
VALUES (9010, 102, 201, '2026-11-02T09:00:00Z', 'confirmed', 'Synthetic active slot conflict');

-- 11. encounter pk duplicate. Expected: pk_encounter, SQLSTATE 23505.
INSERT INTO portfolio."encounter" ("encounter_id", "appointment_id", "occurred_at", "diagnosis_code", "notes")
VALUES (401, 301, '2026-11-02T09:15:00Z', 'SYN-Z00.1', 'Synthetic duplicate primary key');

-- 12. encounter unique duplicate. Expected: uq_encounter_0, SQLSTATE 23505.
INSERT INTO portfolio."encounter" ("encounter_id", "appointment_id", "occurred_at", "diagnosis_code", "notes")
VALUES (9012, 302, '2026-11-03T11:00:00Z', 'SYN-Z00.2', 'Synthetic duplicate appointment encounter');

-- 13. encounter appointment fk missing. Expected: fk_encounter_0, SQLSTATE 23503.
INSERT INTO portfolio."encounter" ("encounter_id", "appointment_id", "occurred_at", "diagnosis_code", "notes")
VALUES (9013, 99013, '2026-11-07T12:00:00Z', 'SYN-Z00.3', 'Synthetic foreign key test');
