#include "uartReader.h"

UartReader::UartReader(QObject *parent) : QObject(parent), m_baudRate(QSerialPort::Baud9600)
{
    connect(&m_serialPort, &QSerialPort::readyRead, this, &UartReader::readData);

    // Populate available ports
    for (const QSerialPortInfo &info : QSerialPortInfo::availablePorts()) {
        m_availablePorts.append(info.portName());
    }

    emit availablePortsChanged();
}

UartReader::~UartReader()
{
    if (m_serialPort.isOpen()) {
        m_serialPort.close();
    }
}

QString UartReader::portName() const
{
    return m_portName;
}

void UartReader::setPortName(const QString &portName)
{
    if (m_portName != portName) {
        m_portName = portName;
        emit portNameChanged();
    }
}

qint32 UartReader::baudRate() const
{
    return m_baudRate;
}

void UartReader::setBaudRate(qint32 baudRate)
{
    if (m_baudRate != baudRate) {
        m_baudRate = baudRate;
        emit baudRateChanged();
    }
}

QStringList UartReader::availablePorts() const
{
    return m_availablePorts;
}

void UartReader::openPort()
{
    m_serialPort.setPortName(m_portName);
    m_serialPort.setBaudRate(m_baudRate);

    if (!m_serialPort.open(QIODevice::ReadWrite)) {
        qWarning() << "Failed to open port:" << m_serialPort.errorString();
    }
}

void UartReader::closePort()
{
    if (m_serialPort.isOpen()) {
        m_serialPort.close();
    }
}

void UartReader::writeData(const QString &data)
{
    if (m_serialPort.isOpen()) {
        m_serialPort.write(data.toUtf8());
    } else {
        qWarning() << "Serial port is not open";
    }
}

void UartReader::readData()
{
    while (m_serialPort.canReadLine()) {
        QByteArray data = m_serialPort.readLine();
        emit dataReceived(QString::fromUtf8(data).trimmed());
    }
}
