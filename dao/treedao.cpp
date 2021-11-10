#include "treedao.h"
#include <QSqlError>
#include "model/treenode.h"
#include "com/log.h"
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDebug>

TreeDao::TreeDao() {
}
TreeDao::~TreeDao(){};

void TreeDao::init() {
    this->mutex.lock();
    maxid = getMaxId();
    this->mutex.unlock();
}
uint TreeDao::increID() {
    this->mutex.lock();
    maxid++;
    this->mutex.unlock();
    return maxid;
}
uint TreeDao::getMaxId() {
    QString sql = "select max(id) from tree";
    QSqlQuery q;
    q.prepare(sql);
    bool r = q.exec();
    if(!r) {
        Log::INS().error(QString("getMaxId error %1").arg(q.lastError().text()));
        return 0;
    }
    if(q.next()) {
        return q.value(0).toUInt();
    }
    return 0;
}

QString TreeDao::addOrUpdate(TreeNode t) {
    QString sql = "replace into tree(id, name, alias, ct, pid, params) values(?,?,?,?,?,?)";
    QSqlQuery q;
    q.prepare(sql);
    q.addBindValue(QVariant(t.id));
    q.addBindValue(QVariant(t.name));
    q.addBindValue(QVariant(t.alias));
    q.addBindValue(QVariant(t.ct));
    q.addBindValue(QVariant(t.pid));
    q.addBindValue(QVariant(t.params));
    bool r = q.exec();
    if(!r) {
        Log::INS().error(QString("addOrUpdate error %1 %2").arg(q.lastError().text()).arg(t.toString()));
        return q.lastError().text();
    }
    return "";
}

QString TreeDao::del(uint id) {
    QString sql = "delete from tree where id=:id";
    QSqlQuery q;
    q.prepare(sql);
    q.bindValue(":id", id);
    bool r = q.exec();
    if(!r) {
        Log::INS().error(QString("del error %1 %2").arg(q.lastError().text()).arg(id));
        return q.lastError().text();
    }
    return "";
}
QList<TreeNode> TreeDao::gets(QSqlQuery &q) {
    QList<TreeNode> list;
    while (q.next()) {
        TreeNode tn;
        tn.id = q.value(0).toUInt();
        tn.name = q.value(1).toString();
        tn.alias = q.value(2).toString();
        tn.ct = q.value(3).toLongLong();
        tn.pid = q.value(4).toInt();
        tn.params = q.value(5).toString();
        list << tn;
    }
    return list;
}
QList<TreeNode> TreeDao::getAll() {
    QString sql = "select id,name,alias,ct,pid,params from tree";
    QSqlQuery q;
    q.prepare(sql);
    bool r = q.exec();
    if(!r) {
        Log::INS().error(QString("getAll error %1").arg(q.lastError().text()));
        return QList<TreeNode>();
    }
    QList<TreeNode> list = gets(q);
    if(Log::INS().isDebug()) {
        Log::INS().debug(QString("getAll sql [%1] res %5").arg(sql).arg(list.size()));
    }
    return list;
}
TreeNode TreeDao::get(uint id) {
    QString sql = "select id,name,alias,ct,pid,params from tree where id=:id";
    QSqlQuery q;
    q.prepare(sql);
    q.bindValue(":id", id);
    bool r = q.exec();
    if(!r) {
        Log::INS().error(QString("get error %1").arg(q.lastError().text()));
        return TreeNode();
    }
    TreeNode tn;
    if(q.next()) {
        tn.id = q.value(0).toUInt();
        tn.name = q.value(1).toString();
        tn.alias = q.value(2).toString();
        tn.ct = q.value(3).toLongLong();
        tn.pid = q.value(4).toInt();
        tn.params = q.value(5).toString();
    }
    return tn;
}
