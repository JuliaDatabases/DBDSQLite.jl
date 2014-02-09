DBDSQLite.jl
=========

A Julia interface to the SQLite3 library that implements the
[DBI.jl protocol](https://github.com/JuliaDB/DBI.jl).

Testing status: [![Build Status](https://travis-ci.org/JuliaDB/DBDSQLite.jl.png)](https://travis-ci.org/JuliaDB/DBDSQLite.jl)

# Package Documentation

This package implements the interface described in the
[DBI.jl docs](https://github.com/JuliaDB/DBI.jl).

# Known Problems / Installation

To function, this package needs to have access to a custom build of SQLite3
that has the `SQLITE_ENABLE_COLUMN_METADATA` compile-time option enabled. The
steps below describe one possible way to enable this option:

**Step 1**: Download a copy of the autoconf-ready source code for SQLite3
[here](https://sqlite.org/download.html). This package has been tested
against `sqlite-autoconf-3080300.tar.gz`.

**Step 2**: Modify the first line of the `sqlite3.c` file to include the
following code:

```
// For use with DBI.jl, we always build SQLite3 with column metadata enabled
#define SQLITE_ENABLE_COLUMN_METADATA
```

**Step 3**: Compile and install the modified SQLite3 library:

```
./configure
make
make install
```

On most systems that provide SQLite3, the `SQLITE_ENABLE_COLUMN_METADATA`
option is not enabled. Under these circumstances, most of the functionality of
this library will work, except for the `tableinfo` and `columninfo` functions.
