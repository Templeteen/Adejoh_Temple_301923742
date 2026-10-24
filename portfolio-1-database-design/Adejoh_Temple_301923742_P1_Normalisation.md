# Hospital / Clinic System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| patient_id | appointment records (list) |
| --- | --- |
| 101 | [301] |
| 102 | [302] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| appointment.appointment_id | appointment.patient_id | appointment.clinician_id | appointment.status | patient.patient_id | patient.medical_record_no | clinician.clinician_id | clinician.license_no |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | scheduled | 101 | SYN-MR-101 | 201 | SYN-LIC-201 |
| 302 | 102 | 202 | completed | 102 | SYN-MR-102 | 202 | SYN-LIC-202 |

Key: appointment_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## appointment_example

| appointment.appointment_id | appointment.patient_id | appointment.clinician_id | appointment.status | patient.patient_id | patient.medical_record_no | clinician.clinician_id | clinician.license_no |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | scheduled | 101 | SYN-MR-101 | 201 | SYN-LIC-201 |
| 302 | 102 | 202 | completed | 102 | SYN-MR-102 | 202 | SYN-LIC-202 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## patient

| patient_id | medical_record_no | full_name | date_of_birth |
| --- | --- | --- | --- |
| 101 | SYN-MR-101 | Alex Sample | 1988-04-12 |
| 102 | SYN-MR-102 | Jordan Example | 1992-09-23 |

## clinician

| clinician_id | license_no | full_name | specialty |
| --- | --- | --- | --- |
| 201 | SYN-LIC-201 | Dr. Casey Example | Family Medicine |
| 202 | SYN-LIC-202 | Dr. Riley Sample | Cardiology |

## appointment

| appointment_id | patient_id | clinician_id | start_at | status | reason |
| --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 2026-11-02T09:00:00+00:00 | scheduled | Routine visit |
| 302 | 102 | 202 | 2026-11-03T10:30:00+00:00 | completed | Follow-up |

## encounter

| encounter_id | appointment_id | occurred_at | diagnosis_code | notes |
| --- | --- | --- | --- | --- |
| 401 | 302 | 2026-11-03T10:45:00+00:00 | SYN-Z00.0 | Synthetic encounter record |

## Dependencies

- patient: (patient_id) → medical_record_no, full_name, date_of_birth
- clinician: (clinician_id) → license_no, full_name, specialty
- appointment: (appointment_id) → patient_id, clinician_id, start_at, status, reason
- encounter: (encounter_id) → appointment_id, occurred_at, diagnosis_code, notes

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
