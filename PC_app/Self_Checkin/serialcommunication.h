#ifndef SERIALCOMMUNICATION_H
#define SERIALCOMMUNICATION_H

#include <QObject>

class SerialCommunication : public QObject
{
    Q_OBJECT
public:
    explicit SerialCommunication(QObject *parent = nullptr);
    Q_INVOKABLE void openSerialPort(const QString &portName, int baudRate);
    Q_INVOKABLE void closeSerialPort();
    Q_INVOKABLE void writeData(const QString &data);

signals:
    void dataReceived(const QString &data);
    void errorOccurred(const QString &error);

private slots:
    void readData();

private:
    QSerialPort *serialPort;
};

#endif // SERIALCOMMUNICATION_H
