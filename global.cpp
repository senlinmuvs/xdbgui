#include "global.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QStandardPaths>
#include "ui_AlertDialog.h"
#include "com/log.h"

namespace global {
    QQmlApplicationEngine *engine;
    L* l = new L();
    Async *DB_Async = new Async("db");
    App* app = new App();
    SQLiteManager* sqlm = new SQLiteManager();

    QJsonDocument parseJsonDoc(const QByteArray& d) {
        QJsonParseError jsonError;
        QJsonDocument document = QJsonDocument::fromJson(d, &jsonError);
        if(document.isNull() || (jsonError.error != QJsonParseError::NoError)) {
            Log::INS().warn(QString("parse resp data error document.isNull() %1 json error %2 cont %3")
                             .arg(document.isNull()).arg(jsonError.error).arg(QString(d)));
        }
        return document;
    }
    QJsonObject parseJson(const QByteArray& d) {
        QJsonDocument doc = parseJsonDoc(d);
        if(!doc.isNull() && doc.isObject()) {
            return doc.object();
        }
        return QJsonObject();
    }
    QJsonArray parseJsonArr(const QByteArray& d) {
        QJsonDocument doc = parseJsonDoc(d);
        if(!doc.isNull() && doc.isArray()) {
            return doc.array();
        }
        return QJsonArray();
    }
    QString getDataDir() {
        return QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)+"/XDB/";
    }
    void alert(const QString &msg) {
        QObject* root = engine->rootObjects()[0];
        QMetaObject::invokeMethod(root, "alert",
                    Q_ARG(QVariant, QVariant::fromValue(msg)),
                    Q_ARG(QVariant, QVariant::fromValue(true)),
                    Q_ARG(QVariant, QVariant::fromValue(NULL)));
    }
    void alertDialog(const QString &msg, QWidget* parent) {
        auto ui = new Ui_AlertDialog();
        auto dialog = new QDialog(parent);
        ui->setupUi(dialog);
        ui->msg->setHtml(QString("<p style='font-size:16px;margin:auto;'>%1</p>").arg(msg));
        dialog->show();
    }
    void clear() {
        delete sqlm;
    }
}
