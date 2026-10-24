# Portfolio 1 — Database Design and Modelling

I organised the data into patient, clinician, appointment, encounter. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| patient | 2 |
| clinician | 2 |
| appointment | 2 |
| encounter | 1 |

The 13 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Adejoh_Temple_301923742_P1_Design.md)
- [ER diagram](Adejoh_Temple_301923742_P1_ERDiagram.md)
- [Normalisation](Adejoh_Temple_301923742_P1_Normalisation.md)
- [Schema](Adejoh_Temple_301923742_P1_Schema.sql)
- [Sample data](Adejoh_Temple_301923742_P1_SampleData.sql)
- [Constraint tests](Adejoh_Temple_301923742_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Adejoh_Temple_301923742_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

