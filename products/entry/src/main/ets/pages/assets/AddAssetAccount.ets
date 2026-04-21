import { CommonConstants, BackButton, SubmitButton } from 'commonlib'
import { ServiceContainer } from '../../initializer/ServiceContainer';
import { AssetAccountRecordItemReq, Constants } from 'asset_base';
import { AssetAccountDBBase } from 'asset_base/src/main/ets/model/AssetAccountDB';

import { promptAction } from '@kit.ArkUI';
import { Logger } from 'commonlib/src/main/ets/utils/logger/Index';

const TAG = '[AddAssetAccount]';

/**
 * 资产类型-添加账户页面
 *
 * @author czx
 * @date 2026-03-02
 * */
@Builder
export function AddAssetAccountBuilder() {
  AddAssetAccount()
}

@Entry
@ComponentV2
struct AddAssetAccount {
  private navStack: NavPathStack = new NavPathStack();

  @Local
  assetTypeId: number = 0;

  @Local
  formData: AssetAccountRecordItemReq = new AssetAccountRecordItemReq();

  // 错误信息========================S
  @Local nameError: string = '';
  // 抖动动画
  @Local nameShake: boolean = false;

  @Local balanceError: string = '';
  // 抖动动画
  @Local balanceShake: boolean = false;
  // 错误信息========================E

    // @State assetTypeInfo: AssetTypeDB = null;
  private serviceContainer = ServiceContainer.getInstance();
  private assetAccountDBManager = this.serviceContainer.getAssetAccountDBManager();

  // 账户名称校验======================================================S
  private validateName(value: string): string {
    if (!value || value.trim().length === 0) return '请输入账户名称';
    if (value.length > 20) return '账户名称不能超过20个字符';
    return '';
  }

  private onNameChange(value: string) {
    this.formData.name = value;

    const error = this.validateName(value);
    if (error && !this.balanceError) {
      // 新错误出现时触发抖动
      this.nameShake = true;
      setTimeout(() => { this.nameShake = false; }, 300);
    }
    this.nameError = error;
  }
  // 账户名称校验======================================================E


  // 账户余额校验======================================================S
  private validateBalance(value: number): string {
    if (value === undefined || value === null) return '请输入账户余额';
    if (value < 0) return '账户余额不能为负数';
    return '';
  }
  // 数值改变方法
  private onBalanceChange(value: string) {
    const numValue = parseFloat(value) || 0;
    this.formData.accountBalance = numValue;

    const error = this.validateBalance(numValue);
    if (error && !this.balanceError) {
      // 新错误出现时触发抖动
      this.balanceShake = true;
      setTimeout(() => { this.balanceShake = false; }, 300);
    }
    this.balanceError = error;
  }
  // 账户余额校验======================================================E

  // 创建账户记录========================================================================
  private async _createAssetAccountRecord(formData: AssetAccountRecordItemReq) {
    const data: AssetAccountDBBase = {
      assetTypeId: this.formData.assetTypeId,
      name: this.formData.name,
      remake: this.formData.remake ?? '',
      accountBalance: this.formData.accountBalance ?? 0,
      accountCurrency: this.formData.accountCurrency,
      includedTotalAssets: this.formData.includedTotalAssets ?? 1,
      isOptional: this.formData.isOptional ?? 1,
      // TODO 后期完善账单 Id，现在默认是1
      billId: 1 // 目前默认账单ID为1
    };

    try {
      // 表单校验
      await this.assetAccountDBManager.addAssetAccount(data);
      promptAction.showToast({ message: '资产账户添加成功~' });
    } catch (err) {
      Logger.error(TAG, 'create asset account failed.' + JSON.stringify(err));
    }

  }

  async aboutToAppear() {
    await this.loadData();
  }

  async loadData() {
    try {

    } catch (error) {
      console.error('加载失败:', error);
    }
  }

  build() {
    NavDestination() {
      Column() {
        // 顶部操作空间=========================================================================================S
        Column() {
          // Stack包裹返回按钮和标题，按钮重叠显示，而非横向排列，标题不再受按钮空间影响
          Stack() {
            Text('添加账户')
              .fontColor(CommonConstants.FONT_COLOR_LEVEL1)
              .fontWeight(FontWeight.Medium)
              .textAlign(TextAlign.Center)
              .width('100%');

            // 左侧返回按钮
            BackButton()
            // 按钮绝对定位在左侧，不占用标题的居中空间，仅视觉上叠加在标题左侧
              .position({ left: 0, top: 0, bottom: 0 })
              .onClick(() => {
                this.navStack.pop()
              });
            // 右侧提交按钮
            SubmitButton()
              .position({ right: 0, top: 0, bottom: 0 })
              .onClick(async () => {
                // 添加账户
                this._createAssetAccountRecord(this.formData);
                // 返回上一页
                this.navStack.pop()
              });
          }
          .width('100%')
        }
        .padding({
          left: $r('app.string.space_header'),
          right: $r('app.string.space_header'),
          top: $r('app.string.space_header'),
          bottom: $r('app.string.space_header'),
        })
        // 顶部操作空间=========================================================================================E


        // 内容区=======================================================================================S
        Column() {
          List({ space: 12 }) {
            // 第一张卡片
            ListItemGroup({style: ListItemGroupStyle.CARD }) {
              ListItem() {
                Column() {
                  Row() {
                    Text('账户名称').formLabelStyle();
                    TextInput({ text: this.formData.name, placeholder: '请输入账户名称' })
                      .formTextInputStyle()
                      .maxLength(30)
                      .onChange(this.onNameChange.bind(this))
                  }
                  .formRowStyle()

                  if (this.nameError) {
                    Row() {
                      Text('⚠️ ')
                        .fontSize(12)
                      Text(this.nameError)
                        .fontSize(12)
                        .fontColor('#FF4D4F')
                    }
                    .width('100%')
                    .padding({ top: 4 })
                    .justifyContent(FlexAlign.End)
                    .transition(TransitionEffect.OPACITY
                      .animation({ duration: 400, curve: Curve.EaseInOut })
                      .combine(TransitionEffect.translate({ y: -10 }))
                    )
                  }
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
              }.listItemCardStyle()

              ListItem() {
                Row() {
                  Text('账户备注').formLabelStyle();
                  TextInput({ text: this.formData.remake, placeholder: '点击填写备注（可不填）' })
                    .formTextInputStyle()
                    .maxLength(100)
                    .onChange((value) => {
                      this.formData.remake = value;
                    });
                }
              }.listItemCardStyle()
            }
            .listItemGroupCardStyle()

            // 第二张卡片
            ListItemGroup({style: ListItemGroupStyle.CARD }) {
              ListItem() {
                Column() {
                  Row() {
                    Text('账户余额').formLabelStyle();
                    TextInput({ placeholder: '点击填写账户余额'})
                      .formTextInputStyle()
                      .type(InputType.NUMBER_DECIMAL)
                      .onChange(this.onBalanceChange.bind(this))
                  }.formRowStyle();

                  if (this.balanceError) {
                    Row() {
                      Text('⚠️ ')
                        .fontSize(12)
                      Text(this.balanceError)
                        .fontSize(12)
                        .fontColor('#FF4D4F')
                    }
                    .width('100%')
                    .padding({ top: 4})
                    .justifyContent(FlexAlign.End)
                    .transition(TransitionEffect.OPACITY
                      .animation({ duration: 400, curve: Curve.EaseInOut })
                      .combine(TransitionEffect.translate({ y: -10 }))
                    )
                  }
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
              }.listItemCardStyle()

              ListItem() {
                Row() {
                  Text('账户币种').formLabelStyle();
                  TextInput({ text: this.formData.accountCurrency = 'CNY'})
                    .formTextInputStyle()
                    .enabled(false)
                    .onChange((value) => {
                      this.formData.accountCurrency = value;
                    });
                }.formRowStyle();
              }.listItemCardStyle()

              ListItem() {
                Row() {
                  Text('计入总资产').formLabelStyle();
                  Toggle({ type: ToggleType.Switch, isOn: true })
                    .onChange((value) => {
                      this.formData.includedTotalAssets = value ? 1 : 0;
                    });
                }.formRowStyle();
              }.listItemCardStyle()
            }
            .listItemGroupCardStyle()

            // 第三张卡片
            ListItemGroup({style: ListItemGroupStyle.CARD }) {
              ListItem() {
                Row() {
                  Text('记账时可被选择').formLabelStyle();
                  Toggle({ type: ToggleType.Switch, isOn: true })
                    .onChange((value) => {
                      this.formData.isOptional = value ? 1 : 0;
                    });
                }.formRowStyle();
              }.listItemCardStyle()
            }
            .listItemGroupCardStyle()
          }
          .width($r('app.string.height_percent_full'))
          .height($r('app.string.height_percent_full'))
          .padding({
            left: $r('app.string.space_card_content'),
            right: $r('app.string.space_card_content'),
          })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Start)
        // 内容区=======================================================================================E
      }
      .height($r('app.string.height_percent_full'))
      .width($r('app.string.width_percent_full'))
      .backgroundColor($r('app.color.system_color_background_auxiliary'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      // 获取 navStack 供返回使用
      this.navStack = context.pathStack;
      // 获取参数
      const param = context.pathInfo.param as number | null;
      if (param) {
        this.formData.assetTypeId = param;
      }
    })
  }
}


@Extend(Row)
function formRowStyle() {
  .width('100%')
  .justifyContent(FlexAlign.SpaceBetween);
}

@Extend(Text)
function formLabelStyle() {
  .layoutWeight(1)
  .fontColor(Constants.FONT_COLOR_LEVEL1)
  .fontSize(Constants.FONT_SIZE_16)
  .fontWeight(FontWeight.Medium);
}

@Extend(TextInput)
function formTextInputStyle() {
  .margin(0)
  .padding(2)
  .width('60%')
  .backgroundColor(Constants.BACKGROUND_COLOR)
  .placeholderFont({ size: Constants.FONT_SIZE_14 })
  .fontSize(Constants.FONT_SIZE_14)
  .placeholderColor(Constants.FONT_COLOR_LEVEL2)
  .textAlign(TextAlign.End);

}

@Extend(ListItemGroup)
function listItemGroupCardStyle() {
  .borderRadius(12)
  .divider({ strokeWidth: 1, color: '#f0f0f0' })
  .backgroundColor($r('app.color.system_color_background_white'));
}

@Extend(ListItem)
function listItemCardStyle() {
  .width($r('app.string.height_percent_full'))
  .padding(12)
}

@Extend(Divider)
function commonDividerStyle() {
  .margin({
    top: 12,
    bottom: 12,
  });
}