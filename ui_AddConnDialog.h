/********************************************************************************
** Form generated from reading UI file 'AddConnDialog.ui'
**
** Created by: Qt User Interface Compiler version 5.15.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_ADDCONNDIALOG_H
#define UI_ADDCONNDIALOG_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDialog>
#include <QtWidgets/QFormLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_AddConnDialog
{
public:
    QPushButton *btn_ok;
    QWidget *layoutWidget;
    QFormLayout *formLayout;
    QLabel *label;
    QLineEdit *host;
    QLabel *label_2;
    QSpinBox *port;
    QLabel *label_3;
    QLineEdit *pwd;
    QLabel *label_4;
    QSpinBox *minPoolSize;
    QLabel *label_5;
    QSpinBox *maxPoolSize;
    QLabel *label_6;
    QSpinBox *maxWaitSize;
    QLabel *label_7;
    QSpinBox *acquire;
    QLabel *label_8;
    QLineEdit *name;

    void setupUi(QDialog *AddConnDialog)
    {
        if (AddConnDialog->objectName().isEmpty())
            AddConnDialog->setObjectName(QString::fromUtf8("AddConnDialog"));
        AddConnDialog->setWindowModality(Qt::ApplicationModal);
        AddConnDialog->resize(305, 300);
        AddConnDialog->setMinimumSize(QSize(305, 300));
        AddConnDialog->setMaximumSize(QSize(305, 300));
        btn_ok = new QPushButton(AddConnDialog);
        btn_ok->setObjectName(QString::fromUtf8("btn_ok"));
        btn_ok->setGeometry(QRect(120, 270, 51, 24));
        layoutWidget = new QWidget(AddConnDialog);
        layoutWidget->setObjectName(QString::fromUtf8("layoutWidget"));
        layoutWidget->setGeometry(QRect(10, 10, 281, 247));
        formLayout = new QFormLayout(layoutWidget);
        formLayout->setObjectName(QString::fromUtf8("formLayout"));
        formLayout->setHorizontalSpacing(20);
        formLayout->setContentsMargins(0, 0, 0, 0);
        label = new QLabel(layoutWidget);
        label->setObjectName(QString::fromUtf8("label"));

        formLayout->setWidget(2, QFormLayout::LabelRole, label);

        host = new QLineEdit(layoutWidget);
        host->setObjectName(QString::fromUtf8("host"));

        formLayout->setWidget(2, QFormLayout::FieldRole, host);

        label_2 = new QLabel(layoutWidget);
        label_2->setObjectName(QString::fromUtf8("label_2"));

        formLayout->setWidget(3, QFormLayout::LabelRole, label_2);

        port = new QSpinBox(layoutWidget);
        port->setObjectName(QString::fromUtf8("port"));
        port->setMaximum(99999);
        port->setValue(8888);

        formLayout->setWidget(3, QFormLayout::FieldRole, port);

        label_3 = new QLabel(layoutWidget);
        label_3->setObjectName(QString::fromUtf8("label_3"));

        formLayout->setWidget(4, QFormLayout::LabelRole, label_3);

        pwd = new QLineEdit(layoutWidget);
        pwd->setObjectName(QString::fromUtf8("pwd"));

        formLayout->setWidget(4, QFormLayout::FieldRole, pwd);

        label_4 = new QLabel(layoutWidget);
        label_4->setObjectName(QString::fromUtf8("label_4"));

        formLayout->setWidget(5, QFormLayout::LabelRole, label_4);

        minPoolSize = new QSpinBox(layoutWidget);
        minPoolSize->setObjectName(QString::fromUtf8("minPoolSize"));
        minPoolSize->setMaximum(9999);
        minPoolSize->setValue(5);

        formLayout->setWidget(5, QFormLayout::FieldRole, minPoolSize);

        label_5 = new QLabel(layoutWidget);
        label_5->setObjectName(QString::fromUtf8("label_5"));

        formLayout->setWidget(6, QFormLayout::LabelRole, label_5);

        maxPoolSize = new QSpinBox(layoutWidget);
        maxPoolSize->setObjectName(QString::fromUtf8("maxPoolSize"));
        maxPoolSize->setMaximum(9999);
        maxPoolSize->setValue(20);

        formLayout->setWidget(6, QFormLayout::FieldRole, maxPoolSize);

        label_6 = new QLabel(layoutWidget);
        label_6->setObjectName(QString::fromUtf8("label_6"));

        formLayout->setWidget(7, QFormLayout::LabelRole, label_6);

        maxWaitSize = new QSpinBox(layoutWidget);
        maxWaitSize->setObjectName(QString::fromUtf8("maxWaitSize"));
        maxWaitSize->setMaximum(9999);
        maxWaitSize->setValue(1000);

        formLayout->setWidget(7, QFormLayout::FieldRole, maxWaitSize);

        label_7 = new QLabel(layoutWidget);
        label_7->setObjectName(QString::fromUtf8("label_7"));

        formLayout->setWidget(8, QFormLayout::LabelRole, label_7);

        acquire = new QSpinBox(layoutWidget);
        acquire->setObjectName(QString::fromUtf8("acquire"));
        acquire->setValue(5);

        formLayout->setWidget(8, QFormLayout::FieldRole, acquire);

        label_8 = new QLabel(layoutWidget);
        label_8->setObjectName(QString::fromUtf8("label_8"));

        formLayout->setWidget(0, QFormLayout::LabelRole, label_8);

        name = new QLineEdit(layoutWidget);
        name->setObjectName(QString::fromUtf8("name"));

        formLayout->setWidget(0, QFormLayout::FieldRole, name);


        retranslateUi(AddConnDialog);

        QMetaObject::connectSlotsByName(AddConnDialog);
    } // setupUi

    void retranslateUi(QDialog *AddConnDialog)
    {
        AddConnDialog->setWindowTitle(QCoreApplication::translate("AddConnDialog", "Connection Configure", nullptr));
        btn_ok->setText(QCoreApplication::translate("AddConnDialog", "OK", nullptr));
        label->setText(QCoreApplication::translate("AddConnDialog", "Host", nullptr));
        host->setText(QCoreApplication::translate("AddConnDialog", "localhost", nullptr));
        label_2->setText(QCoreApplication::translate("AddConnDialog", "Port", nullptr));
        label_3->setText(QCoreApplication::translate("AddConnDialog", "Password", nullptr));
        label_4->setText(QCoreApplication::translate("AddConnDialog", "MinPoolSize", nullptr));
        label_5->setText(QCoreApplication::translate("AddConnDialog", "MaxPoolSize", nullptr));
        label_6->setText(QCoreApplication::translate("AddConnDialog", "MaxWaitSize", nullptr));
        label_7->setText(QCoreApplication::translate("AddConnDialog", "AcquireIncrement", nullptr));
        label_8->setText(QCoreApplication::translate("AddConnDialog", "Name", nullptr));
        name->setText(QCoreApplication::translate("AddConnDialog", "Local", nullptr));
    } // retranslateUi

};

namespace Ui {
    class AddConnDialog: public Ui_AddConnDialog {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_ADDCONNDIALOG_H
