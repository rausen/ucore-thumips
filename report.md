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

## lab4

lab4主要要求实现创建一个进程并且给其分配资源

主要修改的是`proc.c`内的函数，初始化没有修改必要，`do_fork()`函数改成了自己的fork函数，但是没有本质区别，暂时没有修改`load_icode()`函数，因为ucore-mips32和ucore-os的差别比较大，修改起来难度较大，而且lab6,8还会进行改动

## lab5

lab5主要要求在`proc.c`中加载程序并执行，并且实现父进程复制自己的内存空间给子进程

第一个要求是对于这个lab的单独操作，对于操作系统没有移植必要

第二个实现需要修改`pmm.c`中的`copy_range()`函数，进行一次`memcopy()`即可

## lab6

lab6主要要求实现`stride scheduling`调度算法

添加了`skew_heap.h`用于实现斜堆，同时添加了`default_sched_stride.c`用于实现`stride

scheduling`算法，并且修改了部分class结构（e.g.`lab6_run_pool`）用于满足lab6程序的调用

## lab7

lab7主要要求完成同步互斥实验

因为这个lab只是单纯的要求完成一个`哲学家就餐问题`的解，所以没有移植的必要

## lab8

lab8主要要求完成io部分的操作

因为我在ucore-os上完成的函数并没有ucore-thumips的好，存在可能内存泄漏，错误处理也没有ucore-thumips的完整，同时也没有新的算法，在逻辑上大致是一样的，因此也决定不进行移植

## 总结

移植了的实验有lab2, 3, 4, 5, 6

lab1, 8因为ucore-thumips的实现和要移植的部分相同甚至更好，所以没有一致的必要；而lab7是一个单独的算法实验，对ucore-thumips也没有移植的必要

ucore-thumips本来进行`make qemu`的输出为下：
```
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
```
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