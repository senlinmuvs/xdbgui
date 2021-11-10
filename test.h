#ifndef TEST_H
#define TEST_H

#include <QString>
#include <QList>
#include <QDebug>
#include "com/util.h"
#include "libxdb.h"

char* strchar(QString s) {
    QString str1 = s;
    QByteArray ba = str1.toLocal8Bit();
    char *c_str2 = ba.data();
    return c_str2;
}
QString charToStr(char* c) {
    QByteArray ba(c);
    return ba;
}
void test() {
    qDebug() << "------------------------- TEST START -----------------------";
    qDebug() << ut::time::getCurMills();
    qDebug() << "------------------------- TEST START -----------------------";
}
void test5() {
    qDebug() << "------------------------- TEST5 START -----------------------";
    XdbInit(strchar(""));
    QString r0 = charToStr(Xdb(strchar("find h:pobi:%d")));
    QString r1 = charToStr(Xdb(strchar("find h:pobi:%d(*)")));
    qDebug() << r0;
    qDebug() << r1;
    qDebug() << "------------------------- TEST5 END -------------------------";
}
#endif // TEST_H
