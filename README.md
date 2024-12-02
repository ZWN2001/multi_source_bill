# multi_source_bill

TODO 

- [x] 删除投资源时在总数据中删除对应金额
- [x] 迁移存储到数据库
- [x] 更详细的数据展示（新开界面）
- [x] 一个逻辑问题：第二天投资源新增数据时总价不对，应该是通过投资源价格变动进行累加
- [x] 排序
- [x] tag
- [x] 按标签筛选
- [x] 按价格筛选
- [x] 按源筛选
- [x] tag应该迁移到source里(未测试)
- [ ] 数据导出与导入 

一些优化方向：
- [ ] 对数据结构进行细粒度划分
- [ ] 数据存储、更新策略的优化

打包：
```shell
flutter build apk --target-platform android-arm64 --split-per-abi
```