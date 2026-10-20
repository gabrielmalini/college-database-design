# College Course Delivery Database (MySQL)

Relational database for a multi-campus college that runs programmes validated by different UK universities. It tracks campuses, schools, courses, staff, when and where each course is delivered, and which staff teach each delivery.

> University coursework: *Databases*, BSc (Hons) Computing at Regent College London.

## Entity Relationship Diagram

![ERD](images/erd.png)

*The ERD shows the conceptual design. The SQL files are the final implementation, where some tables have clearer names (`validating_university`, `staff_assignment`).*

## Tables

| Table | Purpose |
|---|---|
| `campus` | Teaching locations (including an online campus) |
| `validating_university` | External universities that validate courses |
| `school` | Academic schools, each with a head of school (a staff member) |
| `course` | Programmes, with level (`ENUM`), duration, school and validating university |
| `staff` | Academic and admin staff, each with a primary campus |
| `course_delivery` | When and where a course runs, and its mode (Onsite / Online / Blended) |
| `staff_assignment` | Resolves the many-to-many between staff and deliveries, with a role per assignment |

## SQL techniques used

- **Constraints:** primary and foreign keys, `UNIQUE`, `NOT NULL`, `ENUM`, and defaults such as `DEFAULT (CURDATE())`
- **Referential actions:** `ON DELETE CASCADE`, `SET NULL` and `RESTRICT`, chosen for each relationship
- **Queries:** multi-table `JOIN`s, `LEFT JOIN`, `GROUP BY` / `HAVING`, `COUNT(DISTINCT …)`, `GROUP_CONCAT`, subqueries
- **Transactions:** `START TRANSACTION` / `COMMIT` for changes that must succeed together
- **Error 1093 workaround:** a derived table, so a table can be updated using a subquery on itself

## Normalisation

The design was normalised to **Third Normal Form (3NF)**. For example, an unnormalised delivery table stored several lecturers in one field (`"Anita Sharma, Omar Ali"`). That breaks 1NF, so the staff were moved into their own assignment table, with one row per lecturer.

![Normalisation](images/normalisation-3nf.png)

## How to run

Run the files in order in **MySQL Workbench**, or from the command line:

```bash
mysql -u root -p < 01_schema.sql
mysql -u root -p < 02_sample_data.sql
mysql -u root -p < 03_queries.sql
```

| File | Contents |
|---|---|
| `01_schema.sql` | Creates the `regent_college` database and all tables |
| `02_sample_data.sql` | Fictional campuses, courses, staff, deliveries and assignments |
| `03_queries.sql` | Reports (Q1–Q2), deletes and inserts (Q3–Q4), and a multi-step transaction (Q5) |

All names and emails in the sample data are fictional.

## Author

**Gabriel Malini Rodrigues** · [LinkedIn](https://www.linkedin.com/in/gabriel-malini)
