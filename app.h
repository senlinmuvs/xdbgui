#ifndef APP_H
#define APP_H

#include <QDialog>
#include <QObject>
#include "com/const.h"

class App : public QObject {
    Q_OBJECT
public:
    explicit App(QObject *parent = nullptr);
    ~App();

    void query(QString cmd, int cbid);
    Q_INVOKABLE void openAddConnDialog();
    Q_INVOKABLE void getTree(int cbid);
    Q_INVOKABLE void del(uint id, int cbid);
    Q_INVOKABLE void collecting(QString cmd, uint nodeId, int cbid);
    Q_INVOKABLE void exe(QString cmd, int cbid);
    Q_INVOKABLE void conn(uint id, int cbid);
    Q_INVOKABLE void closeConn();
    Q_INVOKABLE void edit(uint id, QString text, int cbid);
    Q_INVOKABLE int getPlatform();
    Q_INVOKABLE QString getCfgVal(QString k);
    Q_INVOKABLE QString getCtrl();
    Q_INVOKABLE void editConn(uint id);
    Q_INVOKABLE void setKV(QString k, QString v, int cbid);
    Q_INVOKABLE void getKV(QString k, int cbid);
    Q_INVOKABLE void copy(QString cont);
signals:

private:
    void addConn(QString alias, QString host, uint port, QString pwd, uint minPoolSize, uint maxPoolSize, uint maxWaitSize, uint acq, CB_INT cb = NULL);
    void editConn0(uint id, QString alias, QString host, uint port, QString pwd, uint minPoolSize, uint maxPoolSize, uint maxWaitSize, uint acq, CB_INT cb = NULL);
    QDialog* addConnDialog;
};

#endif // APP_H
