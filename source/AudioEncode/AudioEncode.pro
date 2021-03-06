TARGET = VideoEncode
TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

UI_DIR  = obj/Gui
MOC_DIR = obj/Moc
OBJECTS_DIR = obj/Obj


#将输出文件直接放到源码目录下的bin目录下，将dll都放在了次目录中，用以解决运行后找不到dll的问
#DESTDIR=$$PWD/bin/
contains(QT_ARCH, i386) {
    message("32-bit")
    DESTDIR = $${PWD}/bin32
} else {
    message("64-bit")
    DESTDIR = $${PWD}/bin64
}

SOURCES += \
        src/AppConfig.cpp \
        src/Audio/AudioEncoder.cpp \
        src/Audio/AudioFrame/AACFrame.cpp \
        src/Audio/AudioFrame/PCMFrame.cpp \
        src/Audio/GetAudioThread.cpp \
        src/AudioRecordManager.cpp \
        src/Mix/PcmMix.cpp \
        src/Mutex/Cond.cpp \
        src/Mutex/Mutex.cpp \
        src/main.cpp

HEADERS += \
    src/AppConfig.h \
    src/Audio/AudioEncoder.h \
    src/Audio/AudioFrame/AACFrame.h \
    src/Audio/AudioFrame/PCMFrame.h \
    src/Audio/GetAudioThread.h \
    src/AudioRecordManager.h \
    src/Mix/PcmMix.h \
    src/Mutex/Cond.h \
    src/Mutex/Mutex.h

win32{

    contains(QT_ARCH, i386) {
        message("32-bit")
        INCLUDEPATH += $$PWD/lib/win32/ffmpeg/include \
                       $$PWD/src

        LIBS += -L$$PWD/lib/win32/ffmpeg/lib -lavcodec -lavdevice -lavfilter -lavformat -lavutil -lpostproc -lswresample -lswscale

    } else {
        message("64-bit")
        INCLUDEPATH += $$PWD/lib/win64/ffmpeg/include \
                       $$PWD/src

        LIBS += -L$$PWD/lib/win64/ffmpeg/lib -lavcodec -lavdevice -lavfilter -lavformat -lavutil -lpostproc -lswresample -lswscale

    }

    LIBS += -lWS2_32 -lUser32 -lGDI32 -lAdvAPI32 -lwinmm -lshell32
}

unix{
    contains(QT_ARCH, i386) {
        message("32-bit, 请自行编译32位库!")
    } else {
        message("64-bit")
        INCLUDEPATH += $$PWD/lib/linux/ffmpeg/include \
                       $$PWD/src

        LIBS += -L$$PWD/lib/linux/ffmpeg/lib  -lavformat  -lavcodec -lavdevice -lavfilter -lavutil -lswresample -lswscale -lpostproc

        LIBS += -lpthread -ldl
    }

#QMAKE_POST_LINK 表示编译后执行内容
#QMAKE_PRE_LINK 表示编译前执行内容

#解压库文件
#QMAKE_PRE_LINK += "cd $$PWD/lib/linux && tar xvzf ffmpeg.tar.gz "
system("cd $$PWD/lib/linux && tar xvzf ffmpeg.tar.gz")

}
