/*
 * ActiveFrame.hpp
 *
 *  Created on: 02-Aug-2013
 *      Author: thayumaanavan
 */
#ifndef ActiveFrame_H_
#define ActiveFrame_H_

#include <QObject>
#include <bb/cascades/Label>
#include <bb/cascades/SceneCover>
#include <bb/cascades/QmlDocument>

using namespace ::bb::cascades;

class ActiveFrame: public SceneCover {
    Q_OBJECT

public:
    ActiveFrame();

public slots:
    Q_INVOKABLE void update(QString appText1,QString appText2,QString appText3);

private:
    bb::cascades::Label *m_coverLabel;

    Container *mainContainer;
    QmlDocument *qml;
};

#endif /* ActiveFrame_H_ */
