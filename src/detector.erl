-module(detector).
-export([detect_dbms/1]).

detect_dbms(Body) ->
    Patterns = [
        {"MySQL", "MySQL数据库"},
        {"syntax error at", "PostgreSQL数据库"},
        {"ORA-", "Oracle数据库"},
        {"Microsoft SQL Server", "SQL Server数据库"},
        {"SQLite3::", "SQLite数据库"},
        {"DB2 SQL error", "DB2数据库"},
        {"Informix", "Informix数据库"},
        {"Sybase", "Sybase数据库"},
        {"MariaDB", "MariaDB数据库"},
        {"Firebird", "Firebird数据库"},
        {"Teradata", "Teradata数据库"},
        {"SAP HANA", "SAP HANA数据库"},
        {"Ingres", "Ingres数据库"},
        {"SQLSTATE", "通用SQL错误"},
        {"mysql_fetch_array()", "MySQL函数错误"},
        {"pg_query()", "PostgreSQL函数错误"},
        {"oci_execute()", "Oracle函数错误"}
    ],
    detect_dbms_by_patterns(Body, Patterns).

detect_dbms_by_patterns(_Body, []) ->
    "未知数据库";
detect_dbms_by_patterns(Body, [{Pattern, Result} | Rest]) ->
    case string:find(Body, Pattern) of
        nomatch -> detect_dbms_by_patterns(Body, Rest);
        _ -> Result
    end.
