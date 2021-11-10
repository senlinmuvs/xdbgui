#include "sqlite_manager.h"
#include "global.h"
#include "com/util.h"
#include <QCoreApplication>
#include "com/log.h"
#include "cfg.h"

SQLiteManager::SQLiteManager() {
}
SQLiteManager::~SQLiteManager() {
}
bool SQLiteManager::openDB() {
    if(Log::INS().isDebug()) {
        Log::INS().debug("open db");
    }
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(global::getDataDir() + Cfg::INS().dbFile);
    bool ok = db.open();
    if(!ok) {
        Log::INS().error(QString("db open error dbFile %1%2").arg(global::getDataDir()).arg(Cfg::INS().dbFile));
        return false;
    }
    Log::INS().info(QString("dbFile %1%2").arg(global::getDataDir()).arg(Cfg::INS().dbFile));
    return ok;
}

void SQLiteManager::init() {
    if(Log::INS().isDebug()) {
        Log::INS().debug("init db");
    }
    QSqlQuery query;
    query.exec(sql_kv_table);
    query.exec(sql_tree_table);
}

void SQLiteManager::execute(QString tag, QString sql, std::function<void (QSqlQuery)> cb) {
    QSqlQuery q;
    q.prepare(sql);
    cb(q);
    bool r = q.exec();
    if(!r) {
        Log::INS().error(QString("%1 error %2").arg(tag).arg(q.lastError().text()));
    }
}
void SQLiteManager::close() {
    db.close();
}
bool SQLiteManager::transaction() {
    return db.transaction();
}
bool SQLiteManager::commit() {
    return db.commit();
}
void SQLiteManager::rollback() {
    db.rollback();
}
