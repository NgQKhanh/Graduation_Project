#include "serialcommunication.h"
#include <QSerialPortInfo>
#include <QDebug>

SerialCommunication::SerialCommunication(QObject *parent) : QObject(parent)
{
    serialPort = new QSerialPort(this);
    connect(serialPort, &QSerialPort::readyRead, this, &SerialCommunication::readData);
    connect(serialPort, &QSerialPort::errorOccurred, this, [=](QSerialPort::SerialPortError error) {
        if (error != QSerialPort::NoError) {
            emit errorOccurred(serialPort->errorString());
        }
    });
}

void SerialCommunication::openSerialPort(const QString &portName, int baudRate)
{
    serialPort->setPortName(portName);
    serialPort->setBaudRate(baudRate);

    if (serialPort->open(QIODevice::ReadWrite)) {
        qDebug() << "Serial port opened.";
    } else {
        emit errorOccurred(serialPort->errorString());
    }
}

void SerialCommunication::closeSerialPort()
{
    if (serialPort->isOpen()) {
        serialPort->close();
        qDebug() << "Serial port closed.";
    }
}

void SerialCommunication::writeData(const QString &data)
{
    if (serialPort->isOpen()) {
        serialPort->write(data.toUtf8());
    }
}

void SerialCommunication::readData()
{
    if (serialPort->isOpen()) {
        const QByteArray data = serialPort->readAll();
        emit dataReceived(QString::fromUtf8(data));
    }
}
