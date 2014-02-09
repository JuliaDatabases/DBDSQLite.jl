# Find link to SQLite shared library
let
    global sqlite3_lib
    local lib
    succeeded = false
    @linux_only begin
        lib_choices = ["libsqlite3"]
    end
    @windows_only begin
        if WORD_SIZE == 64
            lib_choices = [Pkg.dir("SQLite", "lib", "sqlite3-64")]
        else
            lib_choices = [Pkg.dir("SQLite", "lib", "sqlite3")]
        end
    end
    @osx_only begin
        lib_choices = [
                        "/usr/local/lib/libsqlite3.dylib",
                        "/usr/lib/libsqlite3.dylib",
                        Pkg.dir("SQLite", "lib", "libsqlite3")
                      ]
    end
    for lib in lib_choices 
        try
            dlopen(lib)
            succeeded = true
            break
        end
    end
    succeeded || error("SQLite library not found")
    @eval const sqlite3_lib = $lib
end

# Return codes
const SQLITE_OK = 0 # Successful result
const SQLITE_ROW = 100 # sqlite3_step() has another row ready
const SQLITE_DONE = 101  # sqlite3_step() has finished executing

# Types
const SQLITE_INTEGER = 1
const SQLITE_FLOAT = 2
const SQLITE3_TEXT = 3
const SQLITE_BLOB = 4
const SQLITE_NULL = 5

# I/O settings
const SQLITE_OPEN_READWRITE = 0x00000002
