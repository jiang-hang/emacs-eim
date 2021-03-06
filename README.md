## 特点 ##

**五笔**

 1. 临时拼音输入汉字。用 z 开头可以输入汉字的拼音并查看其五笔字码。
 2. 反查五笔。用 M-x eim-describe-char 可以查看光标处汉字的五笔字码。
 3. 加入自造词。M-x eim-table-add-word，默认是光标前的两个汉字。用 C-a 和 C-e 调整。
 4. 可以保存选择的历史。

**拼音**

 1. 自动调频
 2. 自动加入输入的词组。
 3. 不必输入词组的全部拼音，比较智能的查找词组。

在数字后输入标点会不转换成中文标点符号，这是为了方便输入序号和数字。如
果需要作为中文标点符号，再次输入这个标点就好了。可以用 M-x
eim-punc-translate-toggle 命令切换输入中英文标点。
 
## 安装 ##

如果有 make 命令，可以用 make 和 make install 命令安装。可以修改
PREFIX 使文件安装到指定位置。windows 下可以直接设置 ELISPDIR。
如果没有 make 命令，可以直接复制 EL 和 EXTRAFILES 到 load-path 里的目
录里，推荐是在 site-lisp/eim 目录中。

在 .emacs 加入这几行就行了。五笔输入法要修改 eim-wb-history-file 和
eim-wb-user-file 的位置。eim-wb-history-file 要修改成能保存的文件名即
可。eim-wb-user-file 可以不修改，如果不改则使用默认的 mywb.txt。如果修
改则可以自己指定一个文件。文件格式参考 mywb.txt。

```lisp
(add-to-list 'load-path "~/.emacs.d/site-lisp/eim")
(autoload 'eim-use-package "eim" "Another emacs input method")
;; Tooltip 暂时还不好用
(setq eim-use-tooltip nil)

(register-input-method
 "eim-wb" "euc-cn" 'eim-use-package
 "五笔" "汉字五笔输入法" "wb.txt")
(register-input-method
 "eim-py" "euc-cn" 'eim-use-package
 "拼音" "汉字拼音输入法" "py.txt")

;; 用 ; 暂时输入英文
(require 'eim-extra)
(global-set-key ";" 'eim-insert-ascii)
```

注意，如果所有文件都在 load-path 里的某个目录中，就能找到（如果没有同名
文件的话），否则，请在文件或者配置中使用文件全名。

## 常用的按键 ##

```
+--------+----------+
| 按键   | 功能     |
+--------+----------+
| C-n    | 向下翻页 |
+--------+----------+
| C-p    | 向上翻页 |
+--------+----------+
| C-c    | 取消输入 |
+--------+----------+
| SPC    | 确定输入 |
+--------+----------+
| RET    | 字母上屏 |
+--------+----------+
```

按键绑定可以用 C-h I(M-x describe-input-method) 查看。

## 其余无关文件 ##


  * charpy.st        用 Storable 模块保存的汉字拼音列表

  * pychr.txt        原始的汉字拼音列表

  * pyword2tbl.pl    用于把词组文件转换成可用的词库的 perl 程序

  * create_charpy.pl 用于生成charpy.st文件

  * sanguo.txt       一个测试文件

  * mergepy.pl       可以更新词库的程序。

## 导入搜狗等第三方词库 ##

1. 下载搜狗等的标准词库 <http://pinyin.sogou.com/dict/detail/index/11640>

1. 利用[scel2mmseg](https://github.com/archerhu/scel2mmseg)这样的工具从下载的词库中提取词语。提取出来的词放在一个文本文件中，每行一个词。上面的搜狗标准词库中，有39万多词语。
  
  `python scel2mmseg.py a.scel a.txt`
  
  生成的a.txt中，有些多余的行，利用`sed`等工具将其编辑为需要的格式，即每行一词的格式

1. 假设导出的搜狗词库为sg.txt。然后利用`pyword2tbl.pl`来进行转换。具体的步骤在这个文件的最后有比较详细的说明。如果你在第一步中碰到retrieve charpy.st的错误，就需要施用create_charpy.pl来重建charpy.st。重建的命令是`perl create_charpy.pl`

1. 假设使用pyword2tbl.pl的三个步骤都成功了，生成的文件为sg.txt。最后使用mergepy.pl工具来合并词库。方法如下所示：

1. 要使用这个词库又不想丢失自己词库里新造的词和词频信息，就可以用mergepy.pl。
可在命令行中用这样的命令：

    `$ perl mergepy.pl 自己的词库文件(py.txt) 新词库文件(sg.txt) -o py-new.txt`

    然后把自己的词库文件备份或者删除，把 py-new.txt 改名成 py.txt 就行了。



## 增加汉字 ##

**五笔输入法**

对于五笔输入法，可以选择导入 eim-wb-gbk，只要在 .emacs 里加上：

(setq eim-wb-use-gbk t)

另一个选择是在 eim-wb-user-file 里加上需要的汉字。这样基本上是够用的。
一般的输入:q
gbk 汉字是没有问题，因为wb.txt 中已经加入了 fcitx 中所有的
gbk 汉字，只是如果需要造词时，不导入 gbk 汉字是无法自动造词的。

 **拼音输入法**
 
对于拼音输入法，可以通过这样一个折衷的办法，在 .emacs 中加上：

```lisp
(add-hook 'eim-py-load-hook
          (lambda ()
            (eim-py-make-char-table
             '(
               ("ye" "葉")
               ("rong" "镕")
               ))))
```

然后在 otherpy.txt 的 [Table] 一行后加上：

```
ye 葉
rong 镕
```
M-x eim-build-table

这样应该就能正常使用了。

## 如何定制一个输入法 ##

**初级定制方法**

例如，要设置按键，可以这样：

```lisp
(defun my-eim-wb-activate-function ()
  (add-hook 'eim-active-hook 
        (lambda ()
          (let ((map (eim-mode-map)))
            (define-key map "-" 'eim-previous-page)
            (define-key map "=" 'eim-next-page)))))
```

然后要这样 register-input-method：

```lisp
(register-input-method
 "eim-wb" "euc-cn" 'eim-use-package
 "五笔" "汉字五笔输入法" "wb.txt"
 'my-eim-wb-activate-function)
```

或者这样：

```lisp
(add-hook 'eim-wb-load-hook
          (lambda ()
            (let ((map (eim-mode-map)))
              (define-key map "-" 'eim-previous-page)
              (define-key map "=" 'eim-next-page))))
```

这样不需要再写一个函数。
拼音输入法是类似的。

对于五笔输入法，如果不想记录上次输入位置，设置 eim-wb-history-file 为
nil。

## 高级定制方法 ##

eim-use-package 可以接受两个参数，一个是 word-file，给出一个词库，一个
是 active-function，这个 active-function 是在每次切换时都要调用的。如果
想只在第一次启动输入法时调用一些命令，最好定义一个变量，在启动之后设置
为 t，或者加入到 eim-load-hook 中。在调用这个命令时，eim-current-package
可能还没有定义（第一次启动），这样，如果要修改或者使用
eim-current-package 中的变量，就要用 eim-load-hook 或者eim-active-hook
或者 eim-active-function。eim-load-hook 只在第一次启动输入法时调
用，eim-active-function 和 eim-active-hook 每次都要调用。一般来说，如果
要修改按键绑定，就加入到 eim-load-hook 中。如果要修改 eim-page-length
这样的局部变量，使用 eim-active-function 或者 eim-active-hook。
eim-active-function 是为有专门的 lib 的输入法设计的，这样不用在
register-input-method 中加入一个 active-function。而 eim-active-hook
是为用户定制设计的，这样不用专门写到一个文件中。设置
eim-active-function 使用eim-set-active-function 函数。

**eim-stop-function**
  : 这个函数是用于决定是否停止转换。比如五笔中可以设置当 eim-current-key 大于 4
时就停止。默认是 nil，也就是说可以无限的输入。

**eim-translate-function**
  : 当输入的字符是第一个字符（eim-current-key为空）时，如果不在
eim-first-char 中，或者不是第一个字符，但是不在 eim-total-char 中，会
停止转换。这时，会调用这个函数来处理最后一个输入字符。通常用这个函数来
输入标点。

**eim-add-completion-function**
  : 通过这个函数来为当前的词条添加更多的选项。当往后翻页超出直接查找到的词
条时，会调用这个函数，如果添加结束，返回 t，还需要再添加返回 nil。
我写的五笔输入法用这个函数时是直接一次性加完。如果要每次添加几个的话，
一种办法就是在 eim-current-choice 中加入一个新元素，记录这次搜索到哪个
位置。下次从这个位置继续，直到结束，比较麻烦。而且，一次加完的速度也很
快，就用简单的办法好了。

**eim-format-function**
  : eim-current-choice 中的第一个元素是通常是一个字符串列表。但是也可以含
有 list。这时需要给出一个显示的函数。比如我在五笔输入法中搜索出可能的
单字或者输入拼音时显示五笔字根。
这个函数要接受四个参数，分别是当前输入的字符串 eim-current-key，
当前页数，所有页数，这一页的选项。

**eim-handle-function**
  : 这个函数是决定输入法行为的核心函数。通常要完成的任务是：
  
    1. 决定是否要继续转换。
	
    2. 设置 eim-current-choice, eim-current-pos, eim-current-str,
       eim-guidance-str, 最后调用 eim-show 显示结果。通常如果
       eim-current-choice 的 CAR 不为空的话，就调用 eim-format-page 显示。
       如果为空，则设置相应的 eim-current-str 和 eim-guidance-str，调用
       eim-show 显示。

参考 eim-wb 和 eim-py 的写法。

```
;;; Local Variables: ***
;;; mode: outline ***
;;; coding: utf-8 ***
;;; End: ***
```
