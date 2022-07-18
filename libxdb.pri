macx {
    INCLUDEPATH += $$PWD/libs/macos/
    LIBS += -L$$PWD/libs/macos/ -lxdb
}
win32 {
    INCLUDEPATH += $$PWD/libs/win/
    LIBS += -L$$PWD/libs/win/ -lxdb
}
