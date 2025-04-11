#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "calculator.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Calculator>("calc", 1, 0, "Calc");

    const QUrl url(QStringLiteral("qrc:/Calculator/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
