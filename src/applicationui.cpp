// List with context menu project template
#include "applicationui.hpp"
#include "mylistmodel.hpp"
#include "ActiveFrame.hpp"
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

using namespace bb::cascades;
using namespace bb::system;

ApplicationUI::ApplicationUI(QObject *parent )
: QObject(parent)
, m_invokeManager(new InvokeManager(this))
{
    // register the MyListModel C++ type to be visible in QML
	qmlRegisterType<MyListModel>("com.vikky.list", 1, 0, "MyListModel");
    bool ok = connect(m_invokeManager, SIGNAL(invoked(const bb::system::InvokeRequest&)),
                          this, SLOT(handleInvoke(const bb::system::InvokeRequest&)));
        Q_ASSERT(ok);
        ok = connect(m_invokeManager,
                     SIGNAL(cardResizeRequested(const bb::system::CardResizeMessage&)),
                     this, SLOT(resized(const bb::system::CardResizeMessage&)));
        Q_ASSERT(ok);
        ok = connect(m_invokeManager,
                     SIGNAL(cardPooled(const bb::system::CardDoneMessage&)), this,
                     SLOT(pooled(const bb::system::CardDoneMessage&)));
        Q_ASSERT(ok);

        m_source = m_target = m_action = m_mimeType = m_uri = m_data = m_status =
                tr("--");

        // Initialize properties with default values
        switch (m_invokeManager->startupMode())  {
        case ApplicationStartupMode::LaunchApplication:
            m_startupMode = tr("Launch");
            initFullUI();
            break;
        case ApplicationStartupMode::InvokeApplication:
                       // Wait for invoked signal to determine and initialize the appropriate UI
                       m_startupMode = tr("Invoke");
                       break;

        case ApplicationStartupMode::InvokeCard:
            // Wait for invoked signal to determine and initialize the appropriate UI
            m_startupMode = tr("Card");
            break;
        }


}

void ApplicationUI::handleInvoke(const InvokeRequest& request) {
    // Copy data from incoming invocation request to properties
    m_source =
            QString::fromLatin1("%1 (%2)").arg(request.source().installId()).arg(
                    request.source().groupId());
    m_target = request.target();
    m_action = request.action();
    m_mimeType = request.mimeType();
    m_uri = request.uri().toString();
    m_data = QString::fromUtf8(request.data());

    if (m_target == "com.vikky.shareItem")
        initComposerUI();



}

void ApplicationUI::initFullUI() {

    QmlDocument *qml = QmlDocument::create("asset:///main.qml");
    qml->setContextProperty("_app", this);
    ActiveFrame *activeFrame = new ActiveFrame();
            Application::instance()->setCover(activeFrame);

            qml->setContextProperty("activeFrame", activeFrame);
    AbstractPane *root = qml->createRootObject<AbstractPane>();
    Application::instance()->setScene(root);
}

void ApplicationUI::initComposerUI() {
    QmlDocument *qml = QmlDocument::create("asset:///Share.qml");
    qml->setContextProperty("_app", this);
    AbstractPane *root = qml->createRootObject<AbstractPane>();
    Application::instance()->setScene(root);
}

void ApplicationUI::cardDone(const QString& msg) {
    // Assemble message
    CardDoneMessage message;
    message.setData(msg);
    message.setDataType("text/plain");
    message.setReason(tr("Success!"));

    // Send message
    m_invokeManager->sendCardDone(message);
}

void ApplicationUI::resized(const bb::system::CardResizeMessage&) {
    m_status = tr("Resized");
    emit statusChanged();
}

void ApplicationUI::pooled(const bb::system::CardDoneMessage& doneMessage) {
    m_status = tr("Pooled");
    m_source = m_target = m_action = m_mimeType = m_uri = m_data = tr("--");
    emit statusChanged();
    emit requestChanged();
}
QString ApplicationUI::startupMode() const {
    return m_startupMode;
}

QString ApplicationUI::source() const {
    return m_source;
}

QString ApplicationUI::target() const {
    return m_target;
}

QString ApplicationUI::action() const {
    return m_action;
}

QString ApplicationUI::mimeType() const {
    return m_mimeType;
}

QString ApplicationUI::uri() const {
    return m_uri;
}

QString ApplicationUI::data() const {
    return m_data;
}

QString ApplicationUI::status() const {
    return m_status;
}

