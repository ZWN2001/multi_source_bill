![multi_source_bill](https://socialify.git.ci/ZWN2001/multi_source_bill/image?description=1&language=1&logo=https%3A%2F%2Fgithub.com%2FZWN2001%2Fmulti_source_bill%2Fblob%2Fmaster%2Fassets%2Flogo512.png%3Fraw%3Dtrue&name=1&owner=1&stargazers=1&theme=Light)

# multi_source_bill

用于对多个投资源数据进行汇总与展示，更直观地看出资金变动

本项目使用追加Commons Clause的MIT协议，明确禁止将代码用于任何直接商业收益相关的行为。

## TODO 

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
- [x] logo
- [x] 主题
- [ ] 数据导出与导入 
- [ ] 自定义卡片高度

一些优化方向：
- [ ] 对数据结构进行细粒度划分
- [ ] 数据存储、更新策略的优化

## 打包

```shell
flutter build apk --target-platform android-arm64 --split-per-abi
```

MIT License

Copyright (c) 2024 Karl Eric

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Commons Clause License Condition

The Software is provided to you by the Licensor under the License, as defined
below, subject to the following condition.

Condition: Without limiting other conditions in the License, the grant of
rights under the License does not include, and the License does not grant you,
the right to Sell the Software.

For purposes of the foregoing, “Sell” means primarily for the purpose of
commercial advantage or monetary compensation. The following are expressly
excluded from the definition of “Sell”:

1. The sale of the rights to access, download, use, or modify the Software in
source or object form.
2. The provision of support or services related to the Software, provided that
you do not charge separately for the Software itself.
3. The inclusion of the Software in a distribution aggregate, such as a
distribution or application store, where the aggregate does not itself charge
a fee for the Software.

