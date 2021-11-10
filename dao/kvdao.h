#ifndef KVDAO_H
#define KVDAO_H

#include <QJsonObject>
#include <QString>

class KVDao {
private:
    KVDao();

public:
    static KVDao& INS() {
        static KVDao ins;
        return ins;
    }

    bool set(QString k, QString v);
    QString get(QString k);
    qint64 getQint64(QString k, qint64 def);
    uint getUInt(QString k, uint def);
    QJsonObject getJson(QString k);
    void del(QString k);
};

#endif // KVDAO_H
