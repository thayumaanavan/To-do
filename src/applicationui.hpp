// Default empty project template
#ifndef ApplicationUI_HPP_
#define ApplicationUI_HPP_

#include <QtCore/QObject>
#include <bb/system/CardDoneMessage.hpp>
#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>

namespace bb { namespace cascades { class Application; }}

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class ApplicationUI : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString startupMode READ startupMode NOTIFY requestChanged)

        // The values of the incoming invocation request
    Q_PROPERTY(QString source READ source NOTIFY requestChanged)
    Q_PROPERTY(QString target READ target NOTIFY requestChanged)
    Q_PROPERTY(QString action READ action NOTIFY requestChanged)
    Q_PROPERTY(QString mimeType READ mimeType NOTIFY requestChanged)
    Q_PROPERTY(QString uri READ uri NOTIFY requestChanged)
    Q_PROPERTY(QString data READ data NOTIFY requestChanged)

        // The textual representation of the card status
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)

public:
    ApplicationUI(QObject *parent = 0);
    virtual ~ApplicationUI() {}
    void initFullUI();
    void initComposerUI();

public Q_SLOTS:
    // This method is invoked to notify the invocation system that the action has been done
    void cardDone(const QString& msg);

Q_SIGNALS:
        // The change notification signal of the properties
        void requestChanged();
        void statusChanged();
private Q_SLOTS:
    // This slot is called whenever an invocation request is received
    void handleInvoke(const bb::system::InvokeRequest&);

    void resized(const bb::system::CardResizeMessage&);
    void pooled(const bb::system::CardDoneMessage&);

private:
    // The accessor methods of the properties
    QString startupMode() const;
    QString source() const;
    QString target() const;
    QString action() const;
    QString mimeType() const;
    QString uri() const;
    QString data() const;
    QString status() const;

    // The central class to manage invocations
    bb::system::InvokeManager *m_invokeManager;

    // The property values
    QString m_startupMode;
    QString m_source;
    QString m_target;
    QString m_action;
    QString m_mimeType;
    QString m_uri;
    QString m_data;
    QString m_status;

};


#endif /* ApplicationUI_HPP_ */
