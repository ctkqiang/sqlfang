# SQLFang - SQL 注入检测工具

🚀 **SQLFang** 是一款用 Erlang 实现的轻量级 SQL 注入检测工具，专注于快速扫描网页参数，探测潜在的注入风险和数据库类型。适合想用 Erlang 玩安全检测的你，稳、准、狠。

---

## 功能特点

- 支持自定义目标 URL 和注入参数
- 自动编码注入 payload，防止请求错误
- 通过 HTTP 客户端请求目标，分析响应判断注入可能性
- 模块化设计，支持扩展扫描规则和检测逻辑
- Erlang 原生高并发，速度杠杠的

---
## 法律风险与免责声明（务必阅读）

```

【深求科技教育用途软件使用免责声明与法律风险声明】

一、法律依据：

本软件适用下列中华人民共和国法律法规及司法解释，用户必须全面遵守：

1. 《中华人民共和国网络安全法》（2017 年 6 月 1 日实施）
2. 《中华人民共和国刑法》（2015 年修订，2020 年修订版）
3. 《个人信息保护法》（2021 年 11 月 1 日起施行）
4. 《计算机信息网络国际联网安全保护管理办法》（工信部令第 36 号，2000 年）
5. 《网络安全等级保护条例》（2019 年 9 月 1 日起施行）
6. 最高人民法院《审理危害计算机信息系统安全刑事案件具体应用法律若干问题的解释》（法释〔2011〕7 号）

二、用户责任与行为规范：

1. 用户仅限将本软件用于合法的教育研究、技术学习及环境测试，严禁用于任何非法入侵、破坏、数据窃取、恶意攻击等违法犯罪行为。
2. 违反《刑法》第二百八十五条——非法侵入计算机信息系统的，处三年以下有期徒刑或者拘役，并处或者单处罚金；情节严重的，处三年以上七年以下有期徒刑。
3. 违反《刑法》第二百八十六条——制作、传播计算机病毒等破坏性程序，处三年以下有期徒刑、拘役或者罚金；情节严重的，处三年以上七年以下有期徒刑。
4. 违反《刑法》第二百八十七条——非法获取、出售或者提供个人信息，情节严重者可判处五年以下有期徒刑或拘役，并处罚金；情节特别严重的，处五年以上有期徒刑。
5. 违反《个人信息保护法》第六十七条，未采取必要措施导致个人信息泄露，视情节严重，最高可处以 500 万元人民币罚款。
6. 违反《网络安全法》第四十一条规定，擅自提供网络产品、服务存在安全隐患，责任单位依法承担法律责任。

三、免责声明：

1. 本软件仅供合法教育、技术研究及测试使用，开发者不承担任何因用户使用本软件导致的直接或间接损失，包括但不限于数据丢失、系统损坏、经济损失及法律责任。
2. 用户使用本软件即视为已充分理解本声明及法律风险，自愿承担所有责任。
3. 使用本软件请确保已获得目标系统的合法授权，严禁对无授权系统进行任何形式的攻击或测试。

四、风险提示：

1. 网络安全系全社会共同责任，任何非法攻击行为不仅违背法律，更破坏互联网生态环境。
2. 任何违法行为一经发现，将依法追究刑事责任，警方和司法机关可通过技术手段追踪定位违法者。
3. 任何软件滥用后果自负，开发者保留追究相关侵权责任的权利。

五、争议解决：

因使用本软件发生的任何争议，均适用中华人民共和国法律，由软件开发者所在地人民法院管辖。

六、特别声明：

请用户务必慎重下载及使用网络软件，避免因轻率行为导致不可挽回的法律后果。

网络安全不是儿戏，技术学习需守规矩，愿你我共同维护绿色互联网环境。

```

---

## 环境要求

- Erlang/OTP 21+
- 网络访问权限
- 代码结构参考：
```bash
.
├── src/
│ ├── scanner.erl
│ ├── payloads.erl
│ ├── detector.erl
│ └── ...
├── main.erl
└── ebin/
````

---

## 运行方式

姐姐教你两种启动方式，选你喜欢的姿势！

### 方式一：编译 + 运行脚本（推荐）

```bash
mkdir -p ebin

erlc -o ebin src/*.erl main.erl

chmod +x main.erl

./main.erl "https://target.com/page.php" "id"
```

### 方式二：Erlang Shell 交互模式

```erlang
erl

> code:add_path("ebin").
> application:start(inets).
> main:main(["https://target.com/page.php", "argv"]).
```

---

## 使用说明

传入两个参数：

- **目标 URL**：需带协议（http:// 或 https://）
- **注入参数名**：你怀疑被注入的参数字段名

例如：

```bash
./main.erl "https://target.com/page.php" "argv"
```

程序会自动对指定参数尝试多种常用注入 payload，观察返回结果，分析数据库类型。

---

## 常见问题

- 遇到 `{undef, ...}` 错误，多半是模块没编译或 beam 路径没加正确，确认 `ebin/` 目录和 beam 文件都在。
- `badarg` 相关错误，多是类型不匹配，注意字符串（list）与二进制(binary)转换，Erlang 对这块超敏感。
- HTTP 请求失败请确认网络通畅和目标地址正确。
- 运行脚本时别直接 `chmod +x main.erl` 然后 `./main.erl` ——这不是 shell 脚本，是 Erlang 源码，直接用 erl 运行或写个启动脚本。

---

## 参与贡献

欢迎提交 PR & Issues，帮忙完善 payload 库和检测逻辑。想要升级成分布式扫描？随时告诉姐姐，我帮你改写！

---

## 🤝 贡献指南

欢迎提交 Pull Request 或 Issue。

## 许可证

本项目采用 **木兰宽松许可证 (Mulan PSL)** 进行许可。  
有关详细信息，请参阅 [LICENSE](LICENSE) 文件。  
（魔法契约要保管好哟~）

[![License: Mulan PSL v2](https://img.shields.io/badge/License-Mulan%20PSL%202-blue.svg)](http://license.coscl.org.cn/MulanPSL2)

## 🌟 开源项目赞助计划

### 用捐赠助力发展

感谢您使用本项目！您的支持是开源持续发展的核心动力。  
每一份捐赠都将直接用于：  
✅ 服务器与基础设施维护（魔法城堡的维修费哟~）  
✅ 新功能开发与版本迭代（魔法技能树要升级哒~）  
✅ 文档优化与社区建设（魔法图书馆要扩建呀~）

点滴支持皆能汇聚成海，让我们共同打造更强大的开源工具！  
（小仙子们在向你比心哟~）

---

### 🌐 全球捐赠通道

#### 国内用户

<div align="center" style="margin: 40px 0">

<div align="center">
<table>
<tr>
<td align="center" width="300">
<img src="https://github.com/ctkqiang/ctkqiang/blob/main/assets/IMG_9863.jpg?raw=true" width="200" />
<br />
<strong>🔵 支付宝</strong>（小企鹅在收金币哟~）
</td>
<td align="center" width="300">
<img src="https://github.com/ctkqiang/ctkqiang/blob/main/assets/IMG_9859.JPG?raw=true" width="200" />
<br />
<strong>🟢 微信支付</strong>（小绿龙在收金币哟~）
</td>
</tr>
</table>
</div>
</div>

#### 国际用户

<div align="center" style="margin: 40px 0">
  <a href="https://qr.alipay.com/fkx19369scgxdrkv8mxso92" target="_blank">
    <img src="https://img.shields.io/badge/Alipay-全球支付-00A1E9?style=flat-square&logo=alipay&logoColor=white&labelColor=008CD7">
  </a>
  
  <a href="https://ko-fi.com/F1F5VCZJU" target="_blank">
    <img src="https://img.shields.io/badge/Ko--fi-买杯咖啡-FF5E5B?style=flat-square&logo=ko-fi&logoColor=white">
  </a>
  
  <a href="https://www.paypal.com/paypalme/ctkqiang" target="_blank">
    <img src="https://img.shields.io/badge/PayPal-安全支付-00457C?style=flat-square&logo=paypal&logoColor=white">
  </a>
  
  <a href="https://donate.stripe.com/00gg2nefu6TK1LqeUY" target="_blank">
    <img src="https://img.shields.io/badge/Stripe-企业级支付-626CD9?style=flat-square&logo=stripe&logoColor=white">
  </a>
</div>

---

### 📌 开发者社交图谱

#### 技术交流

<div align="center" style="margin: 20px 0">
  <a href="https://github.com/ctkqiang" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-开源仓库-181717?style=for-the-badge&logo=github">
  </a>
  
  <a href="https://stackoverflow.com/users/10758321/%e9%92%9f%e6%99%ba%e5%bc%ba" target="_blank">
    <img src="https://img.shields.io/badge/Stack_Overflow-技术问答-F58025?style=for-the-badge&logo=stackoverflow">
  </a>
  
  <a href="https://www.linkedin.com/in/ctkqiang/" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-职业网络-0A66C2?style=for-the-badge&logo=linkedin">
  </a>
</div>

#### 社交互动

<div align="center" style="margin: 20px 0">
  <a href="https://www.instagram.com/ctkqiang" target="_blank">
    <img src="https://img.shields.io/badge/Instagram-生活瞬间-E4405F?style=for-the-badge&logo=instagram">
  </a>
  
  <a href="https://twitch.tv/ctkqiang" target="_blank">
    <img src="https://img.shields.io/badge/Twitch-技术直播-9146FF?style=for-the-badge&logo=twitch">
  </a>
  
  <a href="https://github.com/ctkqiang/ctkqiang/blob/main/assets/IMG_9245.JPG?raw=true" target="_blank">
    <img src="https://img.shields.io/badge/微信公众号-钟智强-07C160?style=for-the-badge&logo=wechat">
  </a>
</div>

---

💡 姐姐的小贴士：

> "代码要像化妆一样，细节决定成败，别让 bug 脱妆。"

---

用 Erlang 和 SQLFang 愉快地玩耍吧！🚀
