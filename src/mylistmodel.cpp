// List with context menu project template
#include "mylistmodel.hpp"

#include <bb/data/JsonDataAccess>
#include <bb/cascades/QListDataModel>

using namespace bb::cascades;

MyListModel::MyListModel(QObject* parent)

{
    qDebug() << "Creating MyListModel object:" << this;
    setParent(parent);
}

MyListModel::~MyListModel()
{
    qDebug() << "Destroying MyListModel object:" << this;
}


bool MyListModel::saveData()
{
    bb::data::JsonDataAccess jda;
    jda.save(mData, mJsonDataPath);

    if (jda.hasError()) {
        bb::data::DataAccessError error = jda.error();
        qDebug() << "JSON loading error: " << error.errorType() << ": " << error.errorMessage();
        return false;
    }

    return true;
}

bool MyListModel::jsonToDataFolder()
{
    // Since we need read-write access to the database, the JSON file has
    // to be moved to a folder where we have that access (application's data folder).
    // First, we check if the file already exists (previously copied)
    QStringList pathSplit = mJsonAssetsPath.split("/");
    QString fileName = pathSplit.last();
    QString dataFolder = QDir::homePath();

    // The path to the file in the data folder
    mJsonDataPath = dataFolder + "/" + fileName;
    QFile newFile(mJsonDataPath);

    if (!newFile.exists()) {
        // If the file is not already in the data folder, we copy it from the
        // assets folder (read only) to the data folder (read and write).
        // Note that on a debug build you will be able to write to a database
        // in the assets folder but that is not possible on a signed application.
        QString appFolder(QDir::homePath());
        appFolder.chop(4);
        QString originalFileName = appFolder + mJsonAssetsPath;
        QFile originalFile(originalFileName);

        if (originalFile.exists()) {
            return originalFile.copy(mJsonDataPath);
        } else {
            qDebug() << "Failed to copy file data base file does not exists.";
            return false;
        }
    }

    return true;
}

void MyListModel::setJsonAssetPath(const QString jsonAssetPath)
{
    if (mJsonAssetsPath.compare(jsonAssetPath) != 0) {
    	bb::data::JsonDataAccess jda;

        // Set and emit the JSON asset path.
        mJsonAssetsPath = jsonAssetPath;
        emit jsonAssetPathChanged(jsonAssetPath);

        if (jsonToDataFolder()) {

            // If the file was either already in the data folder or it was just copied there,
            // it is loaded into the mData QVariantlist.
            mData = jda.load(mJsonDataPath).value<QVariantList>();

            if (jda.hasError()) {
                bb::data::DataAccessError error = jda.error();
                qDebug() << "JSON loading error: " << error.errorType() << ": "
                        << error.errorMessage();
                return;
            }


        }
    }
}

void MyListModel::setFilter(const QString filter)
{
    if (mFilter.compare(filter) != 0) {
        QVariantList filteredData;

        // Remove all the old data.
        clear();

        // Populate a list with the items that has the corresponding status.
        foreach(QVariant v, mData){
        if(v.toMap().value("status") == filter) {
            filteredData << v;
            append(v.toMap());
        }
    }

    // Update the filter property and emit the signal.
        mFilter = filter;
        emit filterChanged(filter);
    }
}

QString MyListModel::filter()
{
    return mFilter;
}

QString MyListModel::jsonAssetPath()
{
    return mJsonAssetsPath;
}

void MyListModel::updateItemStatusAtIndex(QVariantList indexPath, const QString newStatus)
{
    QVariant modelItem = data(indexPath);

    // Two indices are needed: the index of the item in the data list and
    // the index of the item in the current model.
    int itemDataIndex = mData.indexOf(modelItem);
    int itemIndex = indexPath.last().toInt();

    // Update the item in the list of data.
    QVariantMap itemMap = mData.at(itemDataIndex).toMap();
    itemMap["status"] = newStatus;
    mData.replace(itemDataIndex, itemMap);

    // Since the item status was changed, it is removed from the model and
    // consequently it is removed from the current list shown by the app.
    removeAt(itemIndex);
}

void MyListModel::setStatus(const QVariantList selectionList, const QString newStatus)
{
    // If the selectionList parameter is a list of index paths update all the items
    if (selectionList.at(0).canConvert<QVariantList>()) {
        for (int i = selectionList.count() - 1; i >= 0; i--) {
            // Get the item at the index path of position i in the selection list
            QVariantList indexPath = selectionList.at(i).toList();
            updateItemStatusAtIndex(indexPath, newStatus);
        }
    } else {
        updateItemStatusAtIndex(selectionList, newStatus);
    }
    saveData();
}

void MyListModel::deleteItemAtIndex(QVariantList indexPath)
{
    QVariant modelItem = data(indexPath);

    // Two indices are needed: the index of the item in the data list and
    // the index of the item in the current model.
    int itemDataIndex = mData.indexOf(modelItem);
    int itemIndex = indexPath.last().toInt();

    // Remove the item from the data list and from the current data model items.
    mData.removeAt(itemDataIndex);
    removeAt(itemIndex);
}

void MyListModel::deleteItems(const QVariantList selectionList)
{
    // If the selectionList parameter is a list of index paths update all the items
    if (selectionList.at(0).canConvert<QVariantList>()) {
        for (int i = selectionList.count() - 1; i >= 0; i--) {

            // Get the item at the index path of position i in the selection list.
            QVariantList indexPath = selectionList.at(i).toList();
            deleteItemAtIndex(indexPath);
        }
    } else {
        deleteItemAtIndex(selectionList);
    }

    saveData();

}

void MyListModel::addItem(const QString itemTitle)
{
    QVariantMap itemMap;
    itemMap["title"] = QVariant(itemTitle);
    itemMap["status"] = QVariant("todo");

    if (indexOf(itemMap) == -1) {
        if (mFilter.compare("todo") == 0) {
            // New items are added to the todo list. If the filter is set to todo,
            // the current list is shown and the new item is added at the top of the list model.
            insert(0, itemMap);
        }

        // Add the new item to the data list.
        mData.insert(0, itemMap);
        saveData();
    }


}

void MyListModel::editItem(const QVariant item, const QString newItemTitle)
{
    // Get the indices of the item in the model and in the data list.
    QVariantMap itemMap = item.toMap();
    int itemDataIndex = mData.indexOf(itemMap);
    int itemIndex = indexOf(itemMap);

    // Update the title.
    itemMap["title"] = newItemTitle;

    // And replace the item in both the model and the data list.
    mData.replace(itemDataIndex, itemMap);
    replace(itemIndex, itemMap);

    saveData();
}


