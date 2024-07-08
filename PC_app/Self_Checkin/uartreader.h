#ifndef UARTREADER_H
#define UARTREADER_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QDebug>

class UartReader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString portName READ portName WRITE setPortName NOTIFY portNameChanged)
    Q_PROPERTY(qint32 baudRate READ baudRate WRITE setBaudRate NOTIFY baudRateChanged)
    Q_PROPERTY(QStringList availablePorts READ availablePorts NOTIFY availablePortsChanged)

public:
    explicit UartReader(QObject *parent = nullptr);
    ~UartReader();

    QString portName() const;
    void setPortName(const QString &portName);

    qint32 baudRate() const;
    void setBaudRate(qint32 baudRate);

    QStringList availablePorts() const;

signals:
    void dataReceived(const QString &data);
    void portNameChanged();
    void baudRateChanged();
    void availablePortsChanged();

public slots:
    void openPort();
    void closePort();
    void writeData(const QString &data);

private slots:
    void readData();

private:
    QSerialPort m_serialPort;
    QString m_portName;
    qint32 m_baudRate;
    QStringList m_availablePorts;
};

#endif // UARTREADER_H
