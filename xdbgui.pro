QT += quick widgets sql

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        app.cpp \
        cfg.cpp \
        com/async.cpp \
        com/future.cpp \
        com/log.cpp \
        com/runmain.cpp \
        com/sqlite_manager.cpp \
        com/util.cpp \
        dao/kvdao.cpp \
        dao/treedao.cpp \
        global.cpp \
        l.cpp \
        main.cpp \
        model/treenode.cpp \
        mytreemodel.cpp \
        mytreenode.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

macx {
    LIBS += -L$$PWD/libs/macos/ -lxdb
    INCLUDEPATH += $$PWD/libs/macos/

    QMAKE_TARGET_BUNDLE_PREFIX = com.xxmoon
#    mac_icon.files = $$files($$PWD/xxmoon/Images.xcassets/AppIcon.appiconset/icon*.png)
    QMAKE_BUNDLE_DATA += mac_icon
    QMAKE_INFO_PLIST=$$PWD/Info.plist
}

HEADERS += \
    app.h \
    cfg.h \
    com/async.h \
    com/const.h \
    com/future.h \
    com/log.h \
    com/runmain.h \
    com/sqlite_manager.h \
    com/util.h \
    dao/kvdao.h \
    dao/treedao.h \
    global.h \
    l.h \
    model/treenode.h \
    mytreemodel.h \
    mytreenode.h \
    test.h

include(libxdb.pri)

FORMS += \
    AddConnDialog.ui \
    AlertDialog.ui
