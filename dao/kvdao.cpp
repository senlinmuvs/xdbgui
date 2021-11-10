#include "kvdao.h"

#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QSqlResult>
#include <QJsonDocument>
#include "com/log.h"
#include "global.h"

KVDao::KVDao() {
}

bool KVDao::set(QString k, QString v) {
    if(Log::INS().isDebug()) {
        Log::INS().debug(QString("set kv k %1 v %2").arg(k).arg(v));
    }
    QString sql = "replace into kv(k,v) values(:k,:v);";
    QSqlQuery q;
    q.prepare(sql);
    q.bindValue(":k", k);
    q.bindValue(":v", v);
    bool r = q.exec();
    if(!r) {
        Log::INS().error(QString("set kv error %1 %2:%3").arg(q.lastError().text()).arg(k).arg(v));
    }
    return r;
}

QString KVDao::get(QString k) {
    QString sql = QString("select v from kv where k=:k;");
    //
    QSqlQuery q;
    q.prepare(sql);
    q.bindValue(":k", k);
    bool r = q.exec();
    if(!r) {
        Log::INS().error(QString("get kv error %1").arg(q.lastError().text()));
        return "";
    }
    QSqlRecord rec = q.record();
    int v_ = rec.indexOf("v");
    if(q.next()) {
        return q.value(v_).toString();
    }
    return "";
}

qint64 KVDao::getQint64(QString k, qint64 def) {
    QString v = get(k);
    if(v.length() > 0){
        bool ok;
        qint64 vv = v.toLongLong(&ok);
        if(ok) {
            return vv;
        }
    }
    return def;
}

uint KVDao::getUInt(QString k, uint def) {
    QString v = get(k);
    if(v.length() > 0){
        bool ok;
        uint vv = v.toUInt(&ok);
        if(ok) {
            return vv;
        }
    }
    return def;
}

QJsonObject KVDao::getJson(QString k) {
    QString s = get(k);
    return QJsonDocument::fromJson(s.toUtf8()).object();
}

void KVDao::del(QString k) {
    QString sql = "delete from kv where k=:k";
    QSqlQuery q;
    q.prepare(sql);
    q.bindValue(":k", k);
    bool r = q.exec();
    if(!r) {
        Log::INS().error(QString("get kv error %1").arg(q.lastError().text()));
    }
}
