#ifndef GLOBAL_H
#define GLOBAL_H

#include "app.h"
#include "l.h"
#include <QJsonObject>
#include <QObject>
#include <QQmlApplicationEngine>
#include "com/async.h"
#include "com/runmain.h"
#include "com/sqlite_manager.h"

namespace global {
    extern QQmlApplicationEngine *engine;
    extern L* l;
    extern Async *DB_Async;
    extern App* app;
    extern SQLiteManager* sqlm;

    template<typename T>
    extern void sendMsg(uint cbid, const T &data) {
        RunMain::INS().exec([cbid, data] {
            if(engine->rootObjects().length() > 0) {
                QObject* root = engine->rootObjects()[0];
                QMetaObject::invokeMethod(root, "onCallback",
                            Q_ARG(QVariant, QVariant::fromValue(cbid)),
                            Q_ARG(QVariant, QVariant::fromValue(data)));
            }
        });
    }
    template<typename T>
    extern void pushMsg(uint ty, const T &data) {
        RunMain::INS().exec([ty, data] {
            if(engine->rootObjects().length() > 0) {
                QObject* root = engine->rootObjects()[0];
                QMetaObject::invokeMethod(root, "onPush",
                            Q_ARG(QVariant, QVariant::fromValue(ty)),
                            Q_ARG(QVariant, QVariant::fromValue(data)));
            }
        });
    }
    extern QJsonDocument parseJsonDoc(const QByteArray& d);
    extern QJsonObject parseJson(const QByteArray& d);
    extern QJsonArray parseJsonArr(const QByteArray& d);
    extern QString getDataDir();
    extern void alert(const QString &msg);
    extern void alertDialog(const QString &msg, QWidget* parent = nullptr);
    extern void clear();
}

#endif // GLOBAL_H
