import relationalStore from '@ohos.data.relationalStore';

@ObservedV2
class CommonUtil {

  public getBooleanFromCursor(cursor: relationalStore.ResultSet, columnName: string): boolean {
    try {
      const columnIndex = cursor.getColumnIndex(columnName);
      if (columnIndex === -1) {
        console.warn(`列 ${columnName} 不存在`);
        return false;
      }
      // SQLite 中布尔值存为 0/1，用 getLong 读取
      return cursor.getLong(columnIndex) === 1;
    } catch (error) {
      console.error(`转换失败`);
      return false;
    }
  }
}

const commonUtil = new CommonUtil();

export { commonUtil as CommonUtil };