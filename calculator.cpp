#include "calculator.h"
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

void normalize(QString& exp)
{
    preprocessExpression(exp);
    exp.replace("×", "*");
    exp.replace("÷", "/");
}

QString Calculator::solve(QString eq)
{
    if(eq.isEmpty()) return "0";
    normalize(eq);

    QJSEngine engine;
    QString res = engine.evaluate(eq).toString();

    QRegularExpression regex("[A-Za-z]+");

    if (res == "Infinity") res = "∞";
    else if(res.contains(regex)) res = "ERROR";

    return res;
}
