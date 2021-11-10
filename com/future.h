#ifndef FUTURE_H
#define FUTURE_H

#include <QString>
#include <QSemaphore>
#include <iostream>
#include <QVariantList>
#include "global.h"
#include "const.h"

class Future {
public:
    Future();
    ~Future();
private:
    QSemaphore* waitingResult;
    QVariantList res;
    QMutex* mtx;

public:
    QVariantList get(QString tag = "");
    QVariant getVar();
    void setVar(QVariant v);
    void set(QString tag = "", QVariantList res = QVariantList());
};

#endif // FUTURE_H
