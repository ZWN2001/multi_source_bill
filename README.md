# multi_source_bill

TODO 

- [x] 删除投资源时在总数据中删除对应金额
- [x] 迁移存储到数据库
- [x] 更详细的数据展示（新开界面）
- [x] 一个逻辑问题：第二天投资源新增数据时总价不对，应该是通过投资源价格变动进行累加
- [x] 排序
- [ ] 分类（或者tag
- [ ] 筛选

打包：
```shell
flutter build apk --target-platform android-arm64 --split-per-abi --flavor prod
```