# ucore-mips操作系统移植报告

标签（空格分隔）： 操作系统

Author： 计62 徐晟 2016011253

---

## ucore-mips操作系统移植要求

- 基于原本的ucore-thumips操作系统
- 实现操作系统课上完成的OS lab1 - lab8在mips32环境下的移植
- 能够在启动后成功运行文件系统里的程序
- 因为我们组没有最终完成mips32 CPU，所以最终的ucore-thumips是在qemu模拟环境上运行的，当然我们尝试了在助教完成的cpu（）上运行我们的操作系统，也是能工成功运行并且进行交互的
 
## 一些主要不同

- ucore-thumips里除了assert进行判断外，还可以使用`kprintf()`和`printhex()`来打印字符串和十六进制整型数字，对于调试帮助比较大；而原来的ucore-os只有`cprintf()`用于打印调试信息
- ucore-thumips的Makefile更加完整且复杂，但是由于程序的编译链接过程比较复杂，在进行编译器工作的时候碰到了一些麻烦，因为从编译器编译出来的MIPS程序比较难直接通过修改Makefile的方式放进ucore-thumips的文件系统

## lab1

- 因为lab1是bootloader自启动程序，而ucore-mips已经完成了，所以不需要移植
- 相对于老的的ucore-OS，新的ucore-thumips因为要在MIPS32 CPU上运行，所以在自启动的地方除了bootASM外还添加了loader进行辅助，主要作用是把ucore-thumips从flash主动拷贝到内存中

## lab2

- lab2主要要求实现**first-fit** 连续物理内存分配算法
- 新添加了`default_pmm.c`和`default_pmm.h`文件用于描述first-fit算法，这两个文件是基于原本的lab2实验的
- 在`pmm.c`中修改默认内存分配算法从**buddy_pmm**变为**default_pmm**，并且成功运行

## lab3

- lab3主要要求实现**LILO**页面替换算法，对相关缺页异常进行处理
- 新添加了`swap.c`, `swap.h`, `swap_fifo.c`, `swap_fifo.h`, `swapfs.c`, `swapfs.h`，因为新的ucore-thumips中的页替换算法已经完全不一样了，所以需要重新加入原来的很多swap相关的程序
- 修改了`vmm.c`的页替换算法为**swap**，并且成功运行

## lab4

- lab4主要要求实现创建一个进程并且给其分配资源
- 主要修改的是`proc.c`内的函数，其中：初始化没有修改必要；`do_fork()`函数改成了自己的fork函数，但是没有本质区别；暂时没有修改`load_icode()`函数，因为ucore-mips32和ucore-OS的差别比较大，修改起来难度较大，而且在lab6, 8还会进一步改动
- 修改完`proc.c`程序以后成功运行

## lab5

- lab5主要要求在`proc.c`中加载程序并执行，并且实现父进程复制自己的内存空间给子进程
- 第一个要求是对于这个lab的一个小实验，对于ucore-thumips来说没有移植必要
- 第二个实现需要修改`pmm.c`中的`copy_range()`函数，只需要进行一次`memcopy()`即可，修改后成功运行

## lab6

- lab6主要要求实现`stride scheduling`调度算法
- 添加了`skew_heap.h`用于实现斜堆，同时添加了`default_sched_stride.c`用于实现`stride scheduling`算法并调用斜堆，并且修改了部分class结构（e.g.`lab6_run_pool`）用于满足lab6程序的调用
- 修改了默认的`scheduling`算法后成功运行

## lab7

- lab7主要要求完成同步互斥实验
- 因为这个实验只是单纯的要求一个`哲学家就餐问题`的解，所以没有移植的必要

## lab8

- lab8主要要求完成io部分的操作，包括文件系统等
- 因为我在ucore-os上完成的函数并没有ucore-thumips的好，存在可能内存泄漏，错误处理也没有ucore-thumips的完整，同时也没有新的算法，在逻辑上大致是一样的，因此也决定不进行移植，其中还是修改了`load_icode()`函数的一部分并且成功运行

## 运行结果与总结

### 总结

移植了的实验有lab2, 3, 4, 5, 6, 8共6个

lab1, 8因为ucore-thumips的实现和要移植的部分相同甚至更好，所以没有一致的必要；而lab7是一个单独的算法实验，对ucore-thumips也没有移植的必要

### 运行结果

ucore-thumips本来进行`make qemu`的输出为下：
```bash
++setup timer interrupts
Initrd: 0x8002c7f0 - 0x802207ef, size: 0x001f4000, magic: 0x2f8dbe2a
(THU.CST) os is loading ...

Special kernel symbols:
  entry  0x80000108 (phys)
  etext 0x8002A420 (phys)
  edata 0x802207F0 (phys)
  end   0x80223B00 (phys)
Kernel executable memory footprint: 2022KB
memory management: buddy_pmm_manager
memory map:
    [80000000, 82000000]

freemem start at: 80264000
free pages: 00001D9C
## 00000020
checking pmm, errors can be ignored.
Page allocation failed, possibly due to OOM or uninitialized page area.
Page allocation failed, possibly due to OOM or uninitialized page area.
check_alloc_page() succeeded!
pmm check passed!
check_pgdir() succeeded!
check_boot_pgdir() succeeded!
-------------------- BEGIN --------------------
--------------------- END ---------------------
check_slab() succeeded!
kmalloc_init() succeeded!
check_vma_struct() succeeded!
check_pgfault() succeeded!
check_vmm() succeeded.
sched class: RR_scheduler
ramdisk_init(): initrd found, magic: 0x2f8dbe2a, 0x00000fa0 secs
sfs: mount: 'simple file system' (377/123/500)
vfs: mount disk0.
kernel_execve: pid = 2, name = "sh".
user sh is running!!!
$ qemu-system-mipsel: terminating on signal 2
```

ucore-thumips在进行了os实验的移植之后，`make qemu`的输出为下：
```bash
++setup timer interrupts
Initrd: 0x80032830 - 0x8022682f, size: 0x001f4000, magic: 0x2f8dbe2a
(THU.CST) os is loading ...

Special kernel symbols:
  entry  0x80000108 (phys)
  etext 0x80030420 (phys)
  edata 0x80226830 (phys)
  end   0x80229C10 (phys)
Kernel executable memory footprint: 2022KB
memory management: default_pmm_manager
memory map:
    [80000000, 82000000]

freemem start at: 80282000
free pages: 00001D7E
## 0000002C
checking pmm, errors can be ignored.
check_alloc_page() succeeded!
pmm check passed!
check_pgdir() succeeded!
check_boot_pgdir() succeeded!
-------------------- BEGIN --------------------
--------------------- END ---------------------
check_slab() succeeded!
kmalloc_init() succeeded!
check_vma_struct() succeeded!
check_pgfault() succeeded!
check_vmm() succeeded.
sched class: stride_scheduler
ramdisk_init(): initrd found, magic: 0x2f8dbe2a, 0x00000fa0 secs
sfs: mount: 'simple file system' (377/123/500)
vfs: mount disk0.
kernel_execve: pid = 2, name = "sh".
user sh is running!!!
$ qemu-system-mipsel: terminating on signal 2
```

输出调试信息的主要区别在于`memory management`和`sched class`，没有显示出来的还有`page swap`和`fork`等函数

添加了自己通过decaf编译出来的fib程序以后运行移植后的ucore-thumips，可以得到如下结果：
```bash
user sh is running!!!
$ ls
 @ is  [directory] 2(hlinks) 18(blocks) 4608(bytes) : @'.'
   [d]   2(h)       18(b)     4608(s)   .
   [d]   2(h)       18(b)     4608(s)   ..
   [-]   1(h)       25(b)   101944(s)   badarg
   [-]   1(h)       25(b)   102204(s)   cat
   [-]   1(h)       25(b)   101968(s)   exit
   [-]   1(h)       25(b)   101772(s)   faultread
   [-]   1(h)       25(b)   101788(s)   faultreadkernel
   [-]   1(h)       25(b)   102012(s)   fib
   [-]   1(h)       25(b)   101960(s)   forktest
   [-]   1(h)       25(b)   101772(s)   hello
   [-]   1(h)       26(b)   105000(s)   ls
   [-]   1(h)       21(b)    84860(s)   my_test
   [-]   1(h)       25(b)   101772(s)   pgdir
   [-]   1(h)       26(b)   103488(s)   pwd
   [-]   1(h)       27(b)   107752(s)   sh
   [-]   1(h)       25(b)   102072(s)   sleep
   [-]   1(h)        1(b)       21(s)   test.txt
   [-]   1(h)       25(b)   101820(s)   yield
lsdir: step 4
$ fib
1
1
2
3
5
8
13
21
34
55
89
144
233
377
610
987
1597
2584
4181
6765
```

可以看到，移植后的ucore-thumips可以完成启动，并且成功的运行程序