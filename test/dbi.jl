module TestDBI
    using DBI
    using DBDSQLite

    # User database
    path = Pkg.dir("DBDSQLite", "test", "db", "users.sqlite3")
    run(`touch $path`)
    db = connect(SQLite3, path)

    stmt = prepare(
        db,
        "CREATE TABLE users (id INT NOT NULL, name VARCHAR(255))"
    )
    @assert executed(stmt) == 0
    execute(stmt)
    @assert executed(stmt) == 1
    finish(stmt)

    try
        stmt = prepare(
            db,
            "CREATE TABLE users (id INT NOT NULL, name VARCHAR(255))"
        )
    end
    errcode(db)
    errstring(db)

    stmt = prepare(db, "INSERT INTO users VALUES (1, 'Jeff Bezanson')")
    execute(stmt)
    finish(stmt)

    stmt = prepare(db, "INSERT INTO users VALUES (2, 'Viral Shah')")
    execute(stmt)
    finish(stmt)

    run(db, "INSERT INTO users VALUES (3, 'Stefan Karpinski')")

    stmt = prepare(db, "INSERT INTO users VALUES (?, ?)")
    execute(stmt, {4, "Jameson Nash"})
    execute(stmt, {5, "Keno Fisher"})
    finish(stmt)

    stmt = prepare(db, "SELECT * FROM users")
    execute(stmt)
    row = fetchrow(stmt)
    row = fetchrow(stmt)
    row = fetchrow(stmt)
    row = fetchrow(stmt)
    row = fetchrow(stmt)
    row = fetchrow(stmt)
    finish(stmt)

    stmt = prepare(db, "SELECT * FROM users")
    execute(stmt)
    rows = fetchall(stmt)
    finish(stmt)

    stmt = prepare(db, "SELECT * FROM users")
    execute(stmt)
    rows = fetchdf(stmt)
    finish(stmt)

    rows = select(db, "SELECT * FROM users")

    tabledata = tableinfo(db, "users")

    columndata = columninfo(db, "users", "id")
    columndata = columninfo(db, "users", "name")

    stmt = prepare(db, "DROP TABLE users")
    execute(stmt)
    finish(stmt)

    disconnect(db)

    rm(path)

    # China OK database
    path = Pkg.dir("DBDSQLite", "test", "db", "chinook.sqlite3")
    db = connect(SQLite3, path)

    stmt = prepare(db, "SELECT * FROM Employee")
    execute(stmt)
    df = fetchdf(stmt)
    finish(stmt)

    df = select(
        db,
        "SELECT * FROM sqlite_master WHERE type = 'table' ORDER BY name"
    )
    df = select(db, "SELECT * FROM Album")
    df = select(
        db,
        """
        SELECT a.*, b.AlbumId
        FROM Artist a
        LEFT OUTER JOIN Album b ON b.ArtistId = a.ArtistId
        ORDER BY name
        """
    )

    disconnect(db)
end
