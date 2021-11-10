#include "treenode.h"
#include "com/util.h"

TreeNode::TreeNode() {
}
QString TreeNode::toString() {
    return ut::str::mapToStr(toVMap());
}
QVariantMap TreeNode::toVMap() {
    QVariantMap m;
    m.insert("id", id);
    m.insert("name", name);
    m.insert("alias", alias);
    m.insert("ct", ct);
    m.insert("pid", pid);
    return m;
}

////QString params = QString("%1,%2,%3,%4,%5,%6,%7").arg(host).arg(port).arg(pwd).arg(minPoolSize).arg(maxPoolSize).arg(maxWaitSize).arg(acq);
void TreeNode::parseConnConfig() {
    QStringList arr = params.split(",");
    if(arr.size() > 0) {
        host = arr[0];
    }
    if(arr.size() > 1) {
        port = arr[1].toUInt();
    }
    if(arr.size() > 2) {
        pwd = arr[2];
    }
    if(arr.size() > 3) {
        dbMinPoolSize = arr[3].toUInt();
    }
    if(arr.size() > 4) {
        dbMaxPoolSize = arr[4].toUInt();
    }
    if(arr.size() > 5) {
        dbMaxWaitSize = arr[5].toUInt();
    }
    if(arr.size() > 6) {
        dbAcq = arr[6].toUInt();
    }
}
