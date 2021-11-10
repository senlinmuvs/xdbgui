#include "cfg.h"

#include <QVariantMap>

Cfg::Cfg() {
}

Cfg::~Cfg(){
}

QString Cfg::toString() {
    QString s;
    QVariantMap m = toVMap();
    QList<QString> ks = m.keys();
    for(QString k: ks) {
        s += k + " = " + m.value(k).toString() + "\n";
    }
    s = s.remove(s.length()-1, 1);
    return s;
}

QVariantMap Cfg::toVMap() {
    QVariantMap m;
    m.insert("logLevel", logLevel);
    m.insert("dbFile", dbFile);
    m.insert("version", version);
    m.insert("ctrl", ctrl);
    return m;
}
