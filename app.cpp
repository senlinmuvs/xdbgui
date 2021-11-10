#include "app.h"
#include "global.h"
#include "ui_AddConnDialog.h"
#include <QDialog>
#include "com/util.h"
#include "com/log.h"
#include "libxdb.h"
#include "com/const.h"
#include "dao/treedao.h"
#include "dao/kvdao.h"
#include "cfg.h"

App::App(QObject *parent) : QObject(parent) {
}
App::~App() {
    delete addConnDialog;
}
void App::query(QString cmd, int cbid) {
}

void App::openAddConnDialog() {
    auto ui = new Ui_AddConnDialog();
    addConnDialog = new QDialog();
    ui->setupUi(addConnDialog);
    connect(ui->btn_ok, &QPushButton::clicked, this, [this, ui]() {
        addConn(ui->name->text(), ui->host->text(), ui->port->text().toUInt(),
                ui->pwd->text(), ui->minPoolSize->text().toUInt(), ui->maxPoolSize->text().toUInt(),
                          ui->maxWaitSize->text().toUInt(), ui->acquire->text().toUInt(), [this](int ok){
            if(ok) {
                addConnDialog->close();
            }
        });
    });
    addConnDialog->show();
}

void App::addConn(QString alias, QString host, uint port, QString pwd, uint minPoolSize, uint maxPoolSize, uint maxWaitSize, uint acq, CB_INT cb) {
    //qDebug() << host << port << pwd << minPoolSize << maxPoolSize << maxWaitSize << acq;
    QString params = QString("%1,%2,%3,%4,%5,%6,%7").arg(host).arg(port).arg(pwd).arg(minPoolSize).arg(maxPoolSize).arg(maxWaitSize).arg(acq);
    XdbClose();
    QString r = ut::str::charToStr(XdbInit(ut::str::strToChar(params)));
    if(!r.isEmpty()) {
        QString s = QString("add connection error %1").arg(r);
        Log::INS().error(s);
        global::alertDialog(s, addConnDialog);
        cb(0);
        global::pushMsg(Push_ConnErr, 0);
        return;
    }
    //
    global::DB_Async->exe([alias, host,port,this,cb,params](){
        TreeNode tn;
        tn.id = TreeDao::INS().increID();
        tn.name = QString("%1:%2").arg(host).arg(port);
        tn.alias = alias;
        tn.ct = ut::time::getCurMills();
        tn.pid = -1;
        tn.params = params;
        QString err = TreeDao::INS().addOrUpdate(tn);
        if(err != "") {
            QString s = "addOrUpdate local conntion record error " + err;
            Log::INS().error(s);
            global::alertDialog(s, addConnDialog);
            global::pushMsg(Push_ConnErr, 0);
            return false;
        }
        global::pushMsg(Push_Add_Conn, tn.toVMap());
        cb(1);
    });
}

void App::getTree(int cbid) {
    global::DB_Async->exe([cbid](){
        QList<TreeNode> list = TreeDao::INS().getAll();
        global::sendMsg(cbid, TreeNode::toVList(list));
    });
}

void App::collecting(QString cmd, uint nodeId, int cbid) {
    global::DB_Async->exe([cbid, nodeId, cmd](){
        TreeNode t;
        t.id = TreeDao::INS().increID();
        t.name = cmd;
        t.ct = ut::time::getCurMills();
        t.pid = nodeId;
        QString err = TreeDao::INS().addOrUpdate(t);
        if(err != "") {
            global::alert(err);
            return;
        }
        global::sendMsg(cbid, t.toVMap());
    });
}

void App::del(uint id, int cbid) {
    global::DB_Async->exe([cbid, id](){
        QString err = TreeDao::INS().del(id);
        if(err != "") {
            global::alert(err);
            return;
        }
        global::sendMsg(cbid, 0);
    });
}

void App::exe(QString cmd, int cbid) {
    QString json = ut::str::charToStr(Xdb(ut::str::strToChar(cmd)));
    global::sendMsg(cbid, json);
}
void App::conn(uint id, int cbid) {
    global::DB_Async->exe([id,cbid](){
        TreeNode tn = TreeDao::INS().get(id);
        XdbClose();
        QString r = ut::str::charToStr(XdbInit(ut::str::strToChar(tn.params)));
        if(!r.isEmpty()) {
            QString s = QString("connection error %1").arg(r);
            Log::INS().error(s);
            global::alert(s);
            return;
        }
        global::sendMsg(cbid, 0);
    });
}
void App::closeConn() {
    XdbClose();
}

void App::edit(uint id, QString text, int cbid) {
    global::DB_Async->exe([id,text,cbid](){
        TreeNode tn = TreeDao::INS().get(id);
        tn.name = text;
        QString err = TreeDao::INS().addOrUpdate(tn);
        if(err!="") {
            global::alert(err);
            return;
        }
        global::sendMsg(cbid, 0);
    });
}
int App::getPlatform() {
#ifdef Q_OS_MAC
    return MAC;
#elif Q_OS_WIN
    return WIN;
#else
    return UNIX;
#endif
}
QString App::getCfgVal(QString k) {
    return Cfg::INS().toVMap().value(k, "").toString();
}
QString App::getCtrl() {
    return Cfg::INS().ctrl;
}
void App::editConn(uint id) {
    global::DB_Async->exe([id,this](){
        TreeNode tn = TreeDao::INS().get(id);
        if(tn.id > 0) {
            tn.parseConnConfig();
            RunMain::INS().exec([id,tn,this](){
                auto ui = new Ui_AddConnDialog();
                addConnDialog = new QDialog();
                ui->setupUi(addConnDialog);
                ui->name->setText(tn.alias);
                ui->host->setText(tn.host);
                ui->port->setValue(tn.port);
                ui->minPoolSize->setValue(tn.dbMinPoolSize);
                ui->maxPoolSize->setValue(tn.dbMaxPoolSize);
                ui->maxWaitSize->setValue(tn.dbMaxWaitSize);
                ui->acquire->setValue(tn.dbAcq);
                connect(ui->btn_ok, &QPushButton::clicked, this, [id, this, ui]() {
                    editConn0(id, ui->name->text(), ui->host->text(), ui->port->text().toUInt(),
                            ui->pwd->text(), ui->minPoolSize->text().toUInt(), ui->maxPoolSize->text().toUInt(),
                                      ui->maxWaitSize->text().toUInt(), ui->acquire->text().toUInt(), [this](int ok){
                        if(ok) {
                            addConnDialog->close();
                        }
                    });
                });
                addConnDialog->show();
            });
        }
    });
}

void App::editConn0(uint id, QString alias, QString host, uint port, QString pwd, uint minPoolSize, uint maxPoolSize, uint maxWaitSize, uint acq, CB_INT cb) {
    qDebug() << "editConn0" << id << alias << host << port << pwd << minPoolSize << maxPoolSize << maxWaitSize << acq;
    global::DB_Async->exe([=](){
        TreeNode tn = TreeDao::INS().get(id);
        if(tn.id > 0) {
            tn.alias = alias;
            tn.name = QString("%1:%2").arg(host).arg(port);
            QString params = QString("%1,%2,%3,%4,%5,%6,%7").arg(host).arg(port).arg(pwd).arg(minPoolSize).arg(maxPoolSize).arg(maxWaitSize).arg(acq);
            tn.params = params;
            QString err = TreeDao::INS().addOrUpdate(tn);
            if(err != "") {
                QString s = "addOrUpdate local conntion record error " + err;
                Log::INS().error(s);
                global::alertDialog(s, addConnDialog);
                global::pushMsg(Push_ConnErr, 0);
                return false;
            }
            global::pushMsg(Push_Edit_Conn, tn.toVMap());
            cb(1);
        }
    });
}

void App::setKV(QString k, QString v, int cbid) {
    global::DB_Async->exe([k,v,cbid](){
        KVDao::INS().set(k,v);
        global::sendMsg(cbid, 0);
    });
}
void App::getKV(QString k, int cbid) {
    global::DB_Async->exe([k,cbid](){
        QString v = KVDao::INS().get(k);
        global::sendMsg(cbid, v);
    });
}
void App::copy(QString cont) {
    ut::cpb::setText(cont);
}
