**Data Pipeline for Research Publications** (Based on DBSys course Lab 1)

This project involved designing, implementing, and analyzing a complete data pipeline for the large-scale DBLP research publication dataset. The goal was to transform raw XML data into a normalized relational schema and conduct complex database analysis.

* **Database Design:** Successfully designed and implemented a robust relational database schema (**PubSchema**) for research publications based on an Entity-Relationship (ER) model. The schema included entities like **Author** and **Publication** (with subclasses **Article, Book, Incollection,** and **Inproceedings**) and a many-to-many **Authored** relationship.
* **Data Acquisition & Loading:** Processed the raw DBLP XML dataset by running a Python SAX parser wrapper to generate tab-separated raw data files (`pubFile.txt` and `fieldFile.txt`). The raw data was then imported into a **PostgreSQL** database, creating a two-table **RawSchema** (`Pub` and `Field`).
* **Data Transformation (ETL):** Developed and executed complex **SQL** queries to transform the raw data into the normalized PubSchema. This involved:
    * Handling duplicate and conflicting fields in the raw data.
    * Generating unique integer keys for authors and publications using **sequences**.
    * Implementing best practices like temporarily omitting and then re-adding **foreign key constraints** using `ALTER TABLE` to optimize bulk loading performance.
* **Data Analysis:** Conducted comprehensive data analysis using SQL, including:
    * Finding the **top 20 most prolific authors** overall and within specific conferences (like STOC, PODS, and SIGMOD).
    * Identifying authors with significant publication history in one domain (e.g., $\ge 10$ SIGMOD papers) but *no* history in another (e.g., PODS papers).
* **Data Visualization:** Wrote a script in a language of choice (**Python**) to connect to the database and retrieve data to compute the histogram of author publication counts. The resulting scatter plot was analyzed using log and log-log scales to determine if the distribution followed a power law or an exponential law.

***Tools and Technologies:*** **PostgreSQL, Python, SQL, Data Visualization.**
