#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QApplication>
#include <QStandardPaths>
#include <QDir>
#include <QIcon>
#include "mytreemodel.h"
#include "global.h"
#include "com/runmain.h"
#include "dao/treedao.h"
#include "com/sqlite_manager.h"
#include "com/log.h"
#include "cfg.h"
//#include "test.h"
#include "libxdb.h"

void initDB();
void initPath();
void exit_();

int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QApplication app(argc, argv);
#ifdef Q_OS_MAC
    app.setWindowIcon(QIcon(":/assets/logo.icns"));
#endif
#ifdef Q_OS_WIN
    QWindow *w = qobject_cast<QWindow *>(qmlRoot);
    w->setIcon(QIcon(":assets/logo.ico"));
#endif

    qmlRegisterType<MyTreeModel>("XDB.Tree", 1, 0, "TreeModel");
    qmlRegisterType<MyTreeNode>("XDB.Tree", 1, 0, "TreeElement");
//    test();

    Log::INS().init("");
    initPath();
    initDB();
    RunMain::INS().init();
    global::DB_Async->start();

    global::engine = new QQmlApplicationEngine();
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(global::engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);

    global::engine->rootContext()->setContextProperty("$app", global::app);
    global::engine->rootContext()->setContextProperty("$l", global::l);
    global::engine->load(url);
    QObject::connect(global::engine, &QQmlEngine::quit, qApp, &QCoreApplication::quit);
    QObject::connect(qApp, &QGuiApplication::aboutToQuit, qApp, &exit_);
    return app.exec();
}

void initPath() {
    QDir dir;
    if(!dir.exists(global::getDataDir())) {
        dir.mkpath(global::getDataDir());
    }
}
void initDB() {
    global::DB_Async->exe([=] {
        if (global::sqlm->openDB()) {
            global::sqlm->init();
            TreeDao::INS().init();
        }
    });
}
void exit_() {
    XdbClose();
    global::DB_Async->close();
    global::sqlm->close();
    global::clear();
    qDebug() << "-------------- exit_ --------------";
}
