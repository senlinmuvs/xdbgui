#include "l.h"
#include "com/log.h"

L::L() : QObject(){
}

bool L::isDebug() {
    return Log::INS().isDebug();
}
void L::trace(QString msg) {
    Log::INS().trace(msg);
}
void L::debug(QString msg) {
    Log::INS().debug(msg);
}
void L::info(QString msg) {
    Log::INS().info(msg);
}
void L::warn(QString msg) {
    Log::INS().warn(msg);
}
void L::error(QString msg) {
    Log::INS().error(msg);
}
