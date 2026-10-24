-- Fictional sample records for Hospital / Clinic System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."patient" ("patient_id", "medical_record_no", "full_name", "date_of_birth") VALUES (101, 'SYN-MR-101', 'Alex Sample', '1988-04-12');
INSERT INTO portfolio."patient" ("patient_id", "medical_record_no", "full_name", "date_of_birth") VALUES (102, 'SYN-MR-102', 'Jordan Example', '1992-09-23');
INSERT INTO portfolio."clinician" ("clinician_id", "license_no", "full_name", "specialty") VALUES (201, 'SYN-LIC-201', 'Dr. Casey Example', 'Family Medicine');
INSERT INTO portfolio."clinician" ("clinician_id", "license_no", "full_name", "specialty") VALUES (202, 'SYN-LIC-202', 'Dr. Riley Sample', 'Cardiology');
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "start_at", "status", "reason") VALUES (301, 101, 201, '2026-11-02T09:00:00Z', 'scheduled', 'Routine visit');
INSERT INTO portfolio."appointment" ("appointment_id", "patient_id", "clinician_id", "start_at", "status", "reason") VALUES (302, 102, 202, '2026-11-03T10:30:00Z', 'completed', 'Follow-up');
INSERT INTO portfolio."encounter" ("encounter_id", "appointment_id", "occurred_at", "diagnosis_code", "notes") VALUES (401, 302, '2026-11-03T10:45:00Z', 'SYN-Z00.0', 'Synthetic encounter record');
COMMIT;
