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

  public extractColumnValues<T>(cursor: relationalStore.ResultSet, columnName: string, extractor: (cursor: relationalStore.ResultSet, idx: number) => T): T[] {
    const result: T[] = [];
    const index = cursor.getColumnIndex(columnName);
    if (index === -1) {
      return result;
    }
    while (cursor.goToNextRow()) {
      result.push(extractor(cursor, index));
    }
    return result;
  }

  // 数字转千分位格式化（支持整数、小数、空值）
  public formatNumberToThousands(num: number | string | null | undefined): string {
    if (num === null || num === undefined || num === '') {
      return '0';
    }
    const number = Number(num);
    if (isNaN(number)) {
      return '0';
    }
    // 千分位格式化
    return number.toLocaleString('zh-CN', { minimumFractionDigits: 0, maximumFractionDigits: 2 });
  }
}

const commonUtil = new CommonUtil();

export { commonUtil as CommonUtil };
