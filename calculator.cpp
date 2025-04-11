#include "calculator.h"
#include <QStack>
#include <QDebug>
#include <QJSEngine>
#include <QRegularExpression>

void preprocessExpression(QString &expression)
{
    QRegularExpression regex("([0-9]+(\\.[0-9]+)?)%");
    QString processedExpression = expression;

    QRegularExpressionMatchIterator i = regex.globalMatch(expression);
    while (i.hasNext())
    {
        QRegularExpressionMatch match = i.next();
        QString number = match.captured(1);
        QString replacement = QString("(%1/100)").arg(number);
        expression.replace(match.capturedStart(), match.capturedLength(), replacement);
    }
}

QString Calculator::solve(QString eq)
{
    //normalization
    preprocessExpression(eq);
    for(size_t i = 0; i < eq.size(); ++i)
        switch (eq[i].unicode()) {
        case 0x00D7:
            eq[i] = '*';
            break;
        case 0x00F7:
            eq[i] = '/';
            break;
        }

    QJSEngine engine;
    QString res = engine.evaluate(eq).toString();

    return res;
}
