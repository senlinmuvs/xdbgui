#include "future.h"
#include "log.h"
#include <QMutex>

Future::Future() {
    waitingResult = new QSemaphore();
    mtx = new QMutex(QMutex::Recursive);
}

Future::~Future() {
    delete waitingResult;
    delete mtx;
}

QVariantList Future::get(QString tag) {
    waitingResult->acquire(1);
    mtx->lock();
    QVariantList v = res;
    mtx->unlock();
    return v;
}

void Future::setVar(QVariant v) {
    mtx->lock();
    this->res << v;
    waitingResult->release(1);
    mtx->unlock();
}
QVariant Future::getVar() {
    waitingResult->acquire(1);
    mtx->lock();
    QVariantList v = res;
    return v.first();
    mtx->unlock();
}

void Future::set(QString tag, QVariantList res) {
    mtx->lock();
    this->res = res;
    waitingResult->release(1);
    mtx->unlock();
}
