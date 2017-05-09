/*
 * ActiveFrame.cpp
 *
 *  Created on: 02-Aug-2013
 *      Author: thayumaanavan
 */


#include "ActiveFrame.hpp"

#include <bb/cascades/SceneCover>
#include <bb/cascades/Container>
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>


using namespace bb::cascades;

ActiveFrame::ActiveFrame()
    : SceneCover(this)
{
    qml = QmlDocument::create("asset:///ActiveFrames.qml")
            .parent(this);
    mainContainer = qml->createRootObject<Container>();
    setContent(mainContainer);

    //m_coverLabel = mainContainer->findChild<Label*>("label1");
   // m_coverLabel->setParent(mainContainer);
}

void ActiveFrame::update(QString appText1,QString appText2,QString appText3) {
	if(appText1=="")
	{
		m_coverLabel = mainContainer->findChild<Label*>("label1");
		m_coverLabel->setVisible(false);
		m_coverLabel = mainContainer->findChild<Label*>("label2");
		m_coverLabel->setVisible(false);
		m_coverLabel = mainContainer->findChild<Label*>("label3");
		m_coverLabel->setVisible(false);

	}
	else
	{
		m_coverLabel = mainContainer->findChild<Label*>("label1");
		m_coverLabel->setVisible(true);
		m_coverLabel->setText(appText1);
		m_coverLabel = mainContainer->findChild<Label*>("label2");
		m_coverLabel->setText(appText2);
		m_coverLabel->setVisible(true);
		m_coverLabel = mainContainer->findChild<Label*>("label3");
		m_coverLabel->setText(appText3);
		m_coverLabel->setVisible(true);
	}


}

