#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QQmlContext>
#include "uartreader.h"

int main(int argc, char *argv[])
{
    // QGuiApplication app(argc, argv);

    // QQmlApplicationEngine engine;
    // engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    // if (engine.rootObjects().isEmpty())
    //     return -1;

    // return app.exec();

    QGuiApplication app(argc, argv);

    qmlRegisterType<UartReader>("com.example.uartreader", 1, 0, "UartReader");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
