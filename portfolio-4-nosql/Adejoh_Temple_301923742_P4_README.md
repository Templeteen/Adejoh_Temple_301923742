# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection patient_timeline for appointment_booked and appointment_rescheduled events. These are fictional event examples based on patient, appointment, encounter.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related appointment details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "appointment_booked",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "encounter",
        "key": {
            "encounter_id": 401
        },
        "snapshot": {
            "encounter_id": 401,
            "appointment_id": 302,
            "occurred_at": "2026-11-03T10:45:00Z",
            "diagnosis_code": "SYN-Z00.0",
            "notes": "Synthetic encounter record"
        }
    },
    "embedded": {
        "appointment": [
            {
                "key": {
                    "appointment_id": 302
                },
                "snapshot": {
                    "appointment_id": 302,
                    "patient_id": 102,
                    "clinician_id": 202,
                    "start_at": "2026-11-03T10:30:00Z",
                    "status": "completed",
                    "reason": "Follow-up"
                },
                "via": [
                    "encounter.appointment_id → appointment"
                ]
            }
        ]
    },
    "references": {
        "patient": [
            {
                "key": {
                    "patient_id": 102
                },
                "via": [
                    "encounter.appointment_id → appointment.patient_id → patient"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("patient_timeline").find({"eventType":"appointment_booked"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "appointment_booked",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "encounter_id": 401
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("patient_timeline").find({"source.key.encounter_id":401}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "appointment_booked",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "encounter_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "appointment_rescheduled",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "encounter_id": 401
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("patient_timeline").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "appointment_booked",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "encounter_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "appointment_rescheduled",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "encounter_id": 401
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("patient_timeline").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| appointment_booked | 1 |
| appointment_rescheduled | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Adejoh_Temple_301923742_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Adejoh_Temple_301923742_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

