#ifndef CONST_H
#define CONST_H

#include <QString>
#define FILE_PRE "file:///"
#define FILE_PRE_MAC "file://"
#define WIN 0
#define UNIX 1
#define MAC 2

#define CB_INT std::function<void(int)>

const static QString sql_tree_table =
"create table if not exists tree ("
    "id INTEGER not null primary key,"
    "name TEXT default '' not null,"
    "alias TEXT default '' not null,"
    "ct INTEGER default 0 not null,"
    "pid INTEGER default 0 not null,"
    "params TEXT default '' not null"
")";

const static QString sql_kv_table =
"create table if not exists `kv` ("
    "k TEXT not null primary key,"
    "v text default '' not null"
");";

const static QString LOG_LEVEL_TRACE = "trace";
const static QString LOG_LEVEL_DEBUG = "debug";
const static QString LOG_LEVEL_INFO = "info";
const static QString LOG_LEVEL_WARN = "warn";
const static QString LOG_LEVEL_ERROR = "error";
const static uint LOG_LEVEL_TRACE_VAL = 0;
const static uint LOG_LEVEL_DEBUG_VAL = 1;
const static uint LOG_LEVEL_INFO_VAL = 2;
const static uint LOG_LEVEL_WARN_VAL = 3;
const static uint LOG_LEVEL_ERROR_VAL = 4;

const static uint Push_Add_Conn = 1;
const static uint Push_ConnErr = 2;
const static uint Push_Edit_Conn = 3;

#endif //CONST_H
