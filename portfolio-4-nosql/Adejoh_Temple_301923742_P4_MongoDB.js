// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("patient_timeline")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("patient_timeline", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "appointment_booked",
                    "appointment_rescheduled"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "encounter"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "encounter_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("patient_timeline").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "appointment_rescheduled",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "clinical_notes": "illustrative clinical_notes",
                "vital_signs": "illustrative vital_signs",
                "metadata": "illustrative metadata"
            }
        }
    }
]));
  await db.getCollection("patient_timeline").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("patient_timeline").find({"eventType":"appointment_booked"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("patient_timeline").find({"source.key.encounter_id":401}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("patient_timeline").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("patient_timeline").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("patient_timeline").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("patient_timeline").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("patient_timeline").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
