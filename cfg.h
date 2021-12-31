#ifndef CFG_H
#define CFG_H

#include <QMap>
#include <QObject>
#include <QStandardPaths>
#include <QString>

class Cfg {

private:
    Cfg();
    ~Cfg();
    Cfg(const Cfg&);
    Cfg& operator=(const Cfg&);

public:
    QString logLevel = "error";
    QString dbFile = "xdb.db";
    QString version = "1.0.2";
#ifdef Q_OS_MAC
    QString ctrl = "Cmd";
#else
    QString ctrl = "Ctrl";
#endif
    QString toString();
    QVariantMap toVMap();

    static Cfg& INS() {
        static Cfg ins;
        return ins;
    }
};
#endif // CFG_H
