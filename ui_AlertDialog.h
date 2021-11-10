/********************************************************************************
** Form generated from reading UI file 'AlertDialog.ui'
**
** Created by: Qt User Interface Compiler version 5.15.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_ALERTDIALOG_H
#define UI_ALERTDIALOG_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDialog>
#include <QtWidgets/QTextBrowser>

QT_BEGIN_NAMESPACE

class Ui_AlertDialog
{
public:
    QTextBrowser *msg;

    void setupUi(QDialog *AlertDialog)
    {
        if (AlertDialog->objectName().isEmpty())
            AlertDialog->setObjectName(QString::fromUtf8("AlertDialog"));
        AlertDialog->resize(400, 200);
        QSizePolicy sizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(AlertDialog->sizePolicy().hasHeightForWidth());
        AlertDialog->setSizePolicy(sizePolicy);
        AlertDialog->setMinimumSize(QSize(400, 200));
        AlertDialog->setMaximumSize(QSize(400, 200));
        msg = new QTextBrowser(AlertDialog);
        msg->setObjectName(QString::fromUtf8("msg"));
        msg->setGeometry(QRect(0, 0, 400, 200));
        msg->setMinimumSize(QSize(400, 200));
        msg->setMaximumSize(QSize(1000, 1000));

        retranslateUi(AlertDialog);

        QMetaObject::connectSlotsByName(AlertDialog);
    } // setupUi

    void retranslateUi(QDialog *AlertDialog)
    {
        AlertDialog->setWindowTitle(QString());
    } // retranslateUi

};

namespace Ui {
    class AlertDialog: public Ui_AlertDialog {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_ALERTDIALOG_H
