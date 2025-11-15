Database.Initialize('xcore.db')

Database.Execute([[
    CREATE TABLE IF NOT EXISTS players (
        license VARCHAR(255) PRIMARY KEY,
        permissions LONG_TEXT
    );
]], {})

Database.Execute([[
    CREATE TABLE IF NOT EXISTS characters (
        citizen_id VARCHAR(255) PRIMARY KEY,
        owner_id VARCHAR(255),
        FOREIGN KEY (owner_id) REFERENCES players(license)
    );
]], {})
