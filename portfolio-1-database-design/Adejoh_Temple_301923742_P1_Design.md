# Hospital / Clinic System — database design

My case study records patient, clinician, appointment, encounter.

## Users

- Clinic reception staff
- Clinicians
- Database students

## Main operations

- Register patients and clinicians using synthetic records.
- Schedule and reschedule appointments, and record encounters.
- Benchmark an appointment date-range filter on 20,000 synthetic appointments, comparing query plans before and after a B-tree index on start_at using the same query and data.

## Entities

| Entity | Information stored |
| --- | --- |
| patient | Stores synthetic patient identity and contact details. |
| clinician | Stores synthetic clinician identity and specialty. |
| appointment | Records a scheduled patient visit with its clinician, time, and status. |
| encounter | Stores the clinical record associated with a completed appointment. |

## patient

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| patient_id | BIGINT | PK | Yes |
| medical_record_no | TEXT | Unique | Yes |
| full_name | TEXT |  | Yes |
| date_of_birth | DATE |  | Yes |
- Unique key: (medical_record_no).

## clinician

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| clinician_id | BIGINT | PK | Yes |
| license_no | TEXT | Unique | Yes |
| full_name | TEXT |  | Yes |
| specialty | TEXT |  | Yes |
- Unique key: (license_no).

## appointment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| appointment_id | BIGINT | PK | Yes |
| patient_id | BIGINT | FK | Yes |
| clinician_id | BIGINT | FK | Yes |
| start_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| reason | TEXT |  | No |
- patient_id → patient.patient_id
- clinician_id → clinician.clinician_id

## encounter

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| encounter_id | BIGINT | PK | Yes |
| appointment_id | BIGINT | FK, Unique | Yes |
| occurred_at | TIMESTAMPTZ |  | Yes |
| diagnosis_code | TEXT |  | Yes |
| notes | TEXT |  | No |
- appointment_id → appointment.appointment_id
- Unique key: (appointment_id).

## Relationships and business rules

- Each patient must have a distinct medical record number.
- Each clinician must have a distinct license number.
- Every appointment must reference an existing patient.
- Every appointment must reference an existing clinician.
- Appointment status must be scheduled, confirmed, completed, or cancelled.
- A clinician may have at most one appointment at a start time among appointments whose status is scheduled or confirmed; enforce with a partial unique index on clinician_id and start_at for those statuses.
- Every encounter must reference an existing appointment.
- An appointment may have at most one encounter.

## Assumptions

- All records and identifiers are synthetic; student names and IDs are omitted.
- Each appointment has exactly one patient and one clinician; an encounter refers to one appointment.
- An appointment's start_at is its scheduled start time, and cancelled appointments do not occupy a clinician's time slot.
- For a worked normalization example, use appointment as the root: keep patient and clinician attributes in their own tables and store their foreign keys on appointment, without repeating ancestor roles.

