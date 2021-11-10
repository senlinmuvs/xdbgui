#ifndef TREENODE_H
#define TREENODE_H

#include <QMutex>
#include <QString>
#include <QVariantMap>

class TreeNode {
public:
    TreeNode();

    uint id = 0;
    QString name = "";
    QString alias = "";
    qint64 ct = 0;
    int pid = 0;
    QString params = "";//QString params = QString("%1,%2,%3,%4,%5,%6,%7").arg(host).arg(port).arg(pwd).arg(minPoolSize).arg(maxPoolSize).arg(maxWaitSize).arg(acq);
    //tmp
    QString host;
    uint port;
    QString pwd;
    uint dbMinPoolSize;
    uint dbMaxPoolSize;
    uint dbMaxWaitSize;
    uint dbAcq;

    QString toString();
    QVariantMap toVMap();

    static QVariantList toVList(const QList<TreeNode>& list) {
        QVariantList vlist;
        for(TreeNode tn: list) {
            vlist << tn.toVMap();
        }
        return vlist;
    }
    void parseConnConfig();
};

#endif // TREENODE_H
