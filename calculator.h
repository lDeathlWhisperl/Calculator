#ifndef CALCULATOR_H
#define CALCULATOR_H

#include <QObject>

class Calculator : public QObject
{
    Q_OBJECT
public:

    Q_INVOKABLE QString solve(const QString);
};

#endif // CALCULATOR_H
