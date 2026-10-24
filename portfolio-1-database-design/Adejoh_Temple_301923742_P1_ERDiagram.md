# Hospital / Clinic System — ER diagram

```mermaid
erDiagram
    direction LR
    patient {
        bigint patient_id PK
        text medical_record_no UK
        text full_name
        date date_of_birth
    }
    clinician {
        bigint clinician_id PK
        text license_no UK
        text full_name
        text specialty
    }
    appointment {
        bigint appointment_id PK
        bigint patient_id FK
        bigint clinician_id FK
        timestamptz start_at
        text status
        text reason "Optional"
    }
    encounter {
        bigint encounter_id PK
        bigint appointment_id FK,UK
        timestamptz occurred_at
        text diagnosis_code
        text notes "Optional"
    }
    patient ||--o{ appointment : "patient_id"
    clinician ||--o{ appointment : "clinician_id"
    appointment ||--o| encounter : "appointment_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Adejoh_Temple_301923742_ERDiagram.png)
