## 2020NUAA ComputerOrganization Design
### 已完成
1、57条指令
2、相关异常
3、五级流水线设计

### 目录说明
实际代码目录为

```
2020\func_test_v0.01\soc_sram_func\rtl\myCPU
```



####  引入trace追踪机制
查看测试指令  
```
2020\func_test_v0.01\soft\func\obj\test.s
```
查看测试点内容
```
2020\func_test_v0.01\soft\func\inst
```
共计89个测试点
其中前64个不涉及异常处理
后面65-89为异常处理 
包含：pc取值错误、数据访问地址错误、syscall、break、例外指令、系统中断、溢出（加减）

#### 运行步骤
1、使用vivado打开以下文件
```
2020\func_test_v0.01\soc_sram_func\run_vivado\mycpu_prj1\mycpu.xpr
```
2、start simulation
3、运行

#### 说明
并非完全正确，仅在该部分89测试点下完成通过。因为最开始的设计并非尽善尽美，对于异常的理解也不够深刻。
尽量的都加了注释。
