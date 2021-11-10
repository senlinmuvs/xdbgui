#ifndef TREEDAO_H
#define TREEDAO_H

#include <QMutex>
#include <QSqlQuery>
#include "model/treenode.h"

class TreeDao {
private:
    TreeDao();
    ~TreeDao();
public:
    void init();
    uint increID();
    uint getMaxId();

    static TreeDao& INS() {
        static TreeDao ins;
        return ins;
    }
    TreeNode get(uint id);
    QString addOrUpdate(TreeNode t);
    QString del(uint id);
    QList<TreeNode> getAll();

private:
    QMutex mutex;
    uint maxid = 0;

    QList<TreeNode> gets(QSqlQuery &q);
};

#endif // TREEDAO_H
