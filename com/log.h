#ifndef LOG_H
#define LOG_H

#include <QFile>
#include <QMap>
#include <QString>

class Log {
private:
    Log();
    ~Log();
    Log(const Log&);
    Log& operator=(const Log&);

public:
    QFile *logFile;
    void init(QString file);
    void close();
    void log(QString level, QString msg);
    void trace(QString msg);
    void debug(QString msg);
    void info(QString msg);
    void warn(QString msg);
    void error(QString msg);
    bool isDebug();
    bool isTrace();
    QMap<QString, uint> name_level;

    static Log& INS() {
        static Log ins;
        return ins;
    }
};
#endif // LOG_H
