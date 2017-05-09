// List with context menu project template
/*
 * ListModel.h
 */

#ifndef MyListModel_HPP_
#define MyListModel_HPP_

#include <QObject>
#include <QString>
#include <QVariant>
#include <QMetaType>
#include <bb/cascades/QListDataModel>
#include <QtNetwork/QNetworkReply>
#include <bb/data/JsonDataAccess>
typedef bb::cascades::QListDataModel<QVariantMap> MyModel;
/*!
 * @brief Mutable list model implementation
 */
class MyListModel : public MyModel
{
    Q_OBJECT

    Q_PROPERTY(QString filter READ filter WRITE setFilter NOTIFY filterChanged)

    Q_PROPERTY(QString jsonAssetPath READ jsonAssetPath WRITE setJsonAssetPath NOTIFY jsonAssetPathChanged)
public:

    /**
         * This function returns the current filter set on the model, there are three
         * valid filters "todo", "Incomplete" and "completed".
         *
         * @return A QString with the current filter
         */
        QString filter();

        /**
         * This function sets the current filter that is used to populate the model with data.
         * It can be one of: "todo", "Incomplete" or "completed". If filter is
         * not one of those three is states, the data model will be empty.
         *
         * @param filter The new filter that should be used when loading data.
         */
        void setFilter(const QString filter);



        /**
         * This function returns the relative file path to the JSON file in the assets folder. Note
         * that this path will only be used the first time the application launches.
         * The file will then be moved to the application's data folder, so that it is
         * possible to write to the file.
         *
         * @return The assets path to the JSON file for the bucket list app.
         */
        QString jsonAssetPath();

        /**
         * Sets the relative path to the JSON file containing the initial list
         * data.
         *
         * @param jsonAssetPath The new relative path to the JSON file residing in the assets folder.
         */
        void setJsonAssetPath(const QString jsonAssetPath);
    MyListModel(QObject* parent = 0);
    virtual ~MyListModel();


signals:
/**
     * This signal is emitted when the filter changes.
     *
     * @param filter The new filter string.
     */
    void filterChanged(QString filter);

    /**
     * This signal is emitted when the property holding the path to JSON file in the assets folder is changed.
     *
     * @param jsonAssetPath The new path to the JSON file in the asset path.
     */
    void jsonAssetPathChanged(QString jsonAssetPath);

public slots:
    /**
     * This Slot function changes the status of a list of items.
     *
     * @param selectionList The list of indexPaths to the item that should be changed.
     * @param newStatus The new status that all items should have.
     */
    void setStatus(const QVariantList selectionList, const QString newStatus);

    /**
     * This Slot function deletes the items at the index paths given in the parameter list.
     *
     * @param selectionList A list of indices to the items that should be removed.
     */
    void deleteItems(const QVariantList selectionList);

    /**
     * Slot function that adds a new item to the JSON file, the status will be set to "todo".
     *
     * @param itemTitle The string with the text describing the title.
     */
    void addItem(const QString itemTitle);

    /**
     * This Slot function edits the content of an item.
     *
     * @param item The item that is to be edited.
     * @param newItemTitle The new title text of the item.
     */
    void editItem(const QVariant item, const QString newItemTitle);

private:
    /**
     * In order to write to a file in a signed application the file has
     * to reside in the app's data folder. This function copies the bundled
     * JSON file to that folder.
     *
     * @return True either if the file has already been copied or if the file is successfully copied, otherwise false.
     */
    bool jsonToDataFolder();

    /**
     * This helper function is for saving the data in mData to the JSON file.
     *
     * @return If save was successful returns true.
     */
    bool saveData();

    /**
        * This helper function updates the status of the item at indexPath;
        *
        * @param indexPath item indexPath
        * @param newStatus the updated status string
        */
       void updateItemStatusAtIndex(QVariantList indexPath, const QString newStatus);

       /**
        * This helper function deletes the item at indexPath.
        *
        * @param indexPath item indexPath
        */
       void deleteItemAtIndex(QVariantList indexPath);

       // Property variables
       QString mFilter;
       QString mJsonAssetsPath;
       QString mJsonDataPath;


       // A list containing all data read from the JSON file
       QVariantList mData;


};


#endif /* MyListModel_HPP_ */
