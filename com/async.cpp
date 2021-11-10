#include "async.h"
#include "com/util.h"
#include <QMutex>
#include "com/log.h"
#include "com/future.h"

Async::Async(QString name) : QThread() {
    this->name = name;
    this->queue = new std::queue<std::function<void()>>();
    this->mutex = new QMutex();
}

Async::~Async() {
    delete mutex;
    delete queue;
}

void Async::exe(std::function<void()> cb) {
    if(!running) {
        return;
    }
    bool b = mutex->tryLock(5000);
    if(b) {
        queue->push(cb);
        QString threadText = QStringLiteral("@0x%1").arg(quintptr(QThread::currentThreadId()), 16, 16, QLatin1Char('0'));
        condNotEmpty.wakeAll();
        mutex->unlock();
    } else {
        Log::INS().warn(QString("async put task lock timeout %1 %2").arg(name).arg(queue->size()));
    }
}

void Async::run() {
    Log::INS().info(QString("%1 start").arg(name));
    while (running) {
        bool b = mutex->tryLock(5000);
        if(b) {
            if(queue->empty()) {
                condNotEmpty.wait(mutex);
                mutex->unlock();
            } else {
                std::function<void()> cb = queue->front();
                queue->pop();
                mutex->unlock();
                cb();
                if(Log::INS().isDebug()){
                    Log::INS().trace(QString("async %1 close running %2").arg(name).arg(running));
                }
            }
        } else {
            Log::INS().warn(QString("async run task lock timeout %1 %2").arg(name).arg(queue->size()));
        }
    }
}

void Async::close() {
    Future *fu = new Future();
    exe([this, fu]() {
        running = false;
        fu->setVar(0);
    });
    fu->getVar();
    delete fu;
//    condNotEmpty.wakeAll();
}
