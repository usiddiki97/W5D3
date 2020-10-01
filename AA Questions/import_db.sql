DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;


-- # We'll first construct a series of tables. Write the table definitions in a SQL
-- # script named import_db.sql.

-- # Add a users table.
-- # Should track fname and lname attributes.

PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL 
);

INSERT INTO 
    users (first_name, last_name)
VALUES
    ('Chris','Lopez'), ('Umarbin', 'Siddiki');

-- # Add a questions table.
-- # Track the title, the body, and the associated author (a foreign key).

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    associated_author_id INTEGER NOT NULL,

    FOREIGN KEY (associated_author_id) REFERENCES users(id)
);

INSERT INTO
    questions (title, body, associated_author_id)
VALUES
    ('I got a question', 'What color is the sky?', 1 ),
    ('Umarbin Question', 'Why didnt we have a lecture today bozos', 2);

-- # Add a question_follows table.
-- # This should support the many-to-many relationship between questions and users 
-- # (a user can have many questions she is following, and a question can have many followers).
-- # This is an example of a join table; the rows in question_follows are used to join
-- # users to questions and vice versa.

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    question_follows(user_id, question_id)
VALUES
    (1,1),
    (2,2);
    
-- # Add a replies table.
-- # Each reply should contain a reference to the subject question.
-- # Each reply should have a reference to its parent reply.
-- # Each reply should have a reference to the user who wrote it.
-- # Don't forget to keep track of the body of a reply.
-- # "Top level" replies don't have any parent, but all replies have a subject question.
-- # It's okay for a column to be self referential; a foreign key can point to a primary key
-- # in the same table.

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    body TEXT NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

INSERT INTO
    replies(question_id, user_id, parent_reply_id, body)
VALUES
    (1, 1, NULL, 'blue'),
    (2, 2, NULL, 'cuz we bozos, sincerely TAs');

-- # Add a question_likes table.
-- # Users can like a question.
-- # Have references to the user and the question in this table

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    question_likes (user_id, question_id)
VALUES
    (1,1),
    (2,2);

-- # At the top of your import_db.sql file make sure you add the line PRAGMA foreign_keys = ON;. This statement
-- # makes sqlite3 actually respect the foreign
-- # key constraints you've added in your CREATE TABLE statements. Whenever we have a
-- # foreign key column in a table we want to make sure that the id we provide actually
-- # references a record in the corresponding table. If you plan on putting DROP TABLE
-- # statements at the top of your import_db.sql file you need to make sure you're dropping
-- # the tables in the right order. If you drop a table that is depended upon by a foreign
-- # key in another table, you will get an error telling you you've violated the foreign key constraint.

-- # You will probably also want to write some INSERT statements at the bottom of your
-- # import_db.sql file, so that you have some data in each table to play with. We call
-- # this 'seeding the database'.

-- # After you've written the SQL, don't forget to run the SQL commands and create the
-- # db - in terminal, run:

-- # cat import_db.sql | sqlite3 questions.db
-- # Now go into your shiny, new sqlite database and try making some basic queries to
-- # ensure that seeding proceeded as planned. Use sqlite3 questions.db to open the sqlite3
-- # console with questions.db loaded.

-- # NB Running .headers on and .mode column will greatly enhance the readability of
-- # the outputs:

-- # sqlite> SELECT * FROM questions;
-- # 1|Ned Question|NED NED NED|1
-- # 2|Kush Question|KUSH KUSH KUSH|2
-- # 3|Earl Question|MEOW MEOW MEOW|3
-- # sqlite> .headers on
-- # sqlite> .mode column
-- # sqlite> SELECT * FROM questions;
-- # id          title         body         author_id
-- # ----------  ------------  -----------  ----------
-- # 1           Ned Question  NED NED NED  1
-- # 2           Kush Questio  KUSH KUSH K  2
-- # 3           Earl Questio  MEOW MEOW M  3