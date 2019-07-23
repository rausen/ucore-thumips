# ucore-mips操作系统移植报告

标签（空格分隔）： 操作系统
Author： 计62 徐晟 2016011253

---

## ucore-mips操作系统移植要求

- 实现操作系统课上完成的lab1 - lab8在mips环境下的移植

## 一些主要不同
- ucore-thumips里除了assert进行判断外，还可以使用`kprintf()`和`printhex()`来打印字符串和十六进制整型数字，对于调试帮助比较大；而原来的ucore-os只有`cprintf()`用于打印调试信息

## lab1

因为lab1是bootloader自启动程序，而ucore-mips已经做完了，所以不需要移植

## lab2

lab2主要要求实现**first-fit** 连续物理内存分配算法
新添加了`default_pmm.c`和`default_pmm.h`文件用于描述first-fit算法，并且在`pmm.c`中修改默认内存分配算法从**buddy_pmm**变为**default_pmm**

## lab3

lab3主要要求实现**LILO**页面替换算法，对相关缺页异常进行处理
新添加了`swap.c`, `swap.h`, `swap_fifo.c`, `swap_fifo.h`, `swapfs.c`, `swapfs.h`，并且修改了`vmm.c`的页替换算法为**swap**

# lab4

lab4主要要求实现创建一个进程并且给其分配资源
主要修改的是`proc.c`内的函数，初始化没有修改必要，`do_fork()`函数改成了自己的fork函数，但是没有本质区别，暂时没有修改`load_icode()`函数，因为ucore-mips32和ucore-os的差别比较大，修改起来难度较大

# lab5

lab5主要要求在`proc.c`中加载程序并执行，并且实现父进程复制自己的内存空间给子进程
第一个要求是对于这个lab的单独操作，对于操作系统没有移植必要
第二个实现需要修改`pmm.c`中的`copy_range()`函数，进行一次`memcopy()`即可

## lab6

lab6主要要求实现`stride scheduling`调度算法
添加了`skew_heap.h`用于实现斜堆，同时添加了`default_sched_stride.c`用于实现`stride scheduling`算法，并且修改了部分class结构（e.g.`lab6_run_pool`）用于满足lab6程序的调用

## lab7

lab7主要要求完成同步互斥实验
因为这个lab只是单纯的要求完成一个`哲学家就餐问题`的解，所以没有移植的必要