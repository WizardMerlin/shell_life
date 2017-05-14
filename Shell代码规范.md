shell脚本代码规范.


主要参考了: <Google Shell 风格指南> (对部分内容做了补充)
https://google.github.io/styleguide/shell.xml


下面分条目罗列:

# 用shell的时机
1. 有性能要求的不选shell脚本(几乎所有的脚本都不可能完成性能要求的任务)
2. 写shell请指明"#!/bin/bash", 而且为了保证兼容性, 最好选择bash.
3. 如果你的shell脚本超过了100行, 请用python而不是shell.  (这是Google的建议)
4. 只用于调用其他工具, 并且处理的数据量非常少.(大量的使用数据, 而不是一些简单的变量的时候, 也改用python)

# 文件扩展名
1. 可执行文件不能有扩展名
2. 库(或者需要source的环境文件)以.sh作为扩展名, 而且不加可执行权限
3. 不要添加SUID,SGID权限


# STDOUT vs STDERR
推荐使用类似如下函数, 将错误信息和其他状态信息一起打印出来:
(把错误信息全部打印到标准错误输出)

```bash
err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

if ! do_something; then
    err "Unable to do_something"
    exit "${E_DID_NOTHING}"
fi
```

# 注释

## 文件头

每个文件必须包含一个顶层注释(每个文件的开头是其文件内容的描述), 对其内容进行简要概述(版权声明和作者信息是可选的)

```bash
#!/bin/bash
#
# Perform hot backups of Oracle databases.
```

完整一点儿的, 可以这样:

	      1. 第一行一般为调用使用的语言
	      2. 下面要有这个程序名，避免更改文件名为无法找到正确的文件
	      3. 版本号
	      4. 更改后的时间
	      5. 作者相关信息
	      6. 该程序的作用，及注意事项
	      7. 版权与是否开放共享GNU说明
	      8. 最后是各版本的更新简要说明

一个生动的例子如下:

```bash
#!/bin/bash
# -------------------------------------------------------------------------------
# Filename:    check_memory.sh
# Revision:    2.0
# Date:        2017/05/10
# Author:      Merlin
# Email:       wizardmerlin945@gmail.com
# Website:     http://www.wizardmerlin.github.io
# Description: module of memory check
# Notes:       this module xxxxx
# -------------------------------------------------------------------------------
# Copyright:   2017 (c) Merlin
# License:     GPL
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# you should have received a copy of the GNU General Public License
# along with this program (or with Nagios);
#
# Credits go to Ethan Galstad for coding Nagios
# If any changes are made to this script, please mail me a copy of the changes
# -------------------------------------------------------------------------------
#Version 1.0
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#Version 2.0
#yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
```


## 函数

任何不是既明显又短的函数都必须被注释, 任何库函数无论其长短和复杂性都必须被注释

所有的函数注释应该包含:(特别注意使用全局变量)

* 函数的描述
* 全局变量的使用和修改
* 使用的参数说明
* 返回值，而不是上一条命令运行后默认的退出状态

下面是一个案例:
```bash
#!/bin/bash
#
# Perform hot backups of Oracle databases.

export PATH='/usr/xpg4/bin:/usr/bin:/opt/csw/bin:/opt/goog/bin'

#######################################
# Cleanup files from the backup dir
# Globals:
#   BACKUP_DIR
#   ORACLE_SID
# Arguments:
#   None
# Returns:
#   None
#######################################
cleanup() {
  ...
}

```


## 技巧注释

这部分遵循谷歌代码注释的通用做法. 
不要注释所有代码, 如果有一个复杂的算法或者你正在做一些与众不同的, 放一个简单的注释.


## TODO注释

使用TODO注释临时的、短期解决方案的、或者足够好但不够完美的代码。

TODOs应该包含全部大写的字符串TODO, 接着是括号中`user_name`, 冒号是可选的.最好在TODO条目之后加上 bug或者ticket 的序号.
例如:

```bash
# TODO(merlin): Handle the unlikely edge cases (bug ####)
```


# 命名约定

## 函数名

如果你正在写单个函数, 请用小写字母来命名, 并用下划线分隔单词.如果你正在写一个包, 使用双冒号` :: `来分隔包名.

大括号必须和函数名位于同一行(就像在Google的其他语言一样), 并且函数名和圆括号之间没有空格.

```bash
# Single function
my_func() {
  ...
}

# Part of a package
mypackage::my_func() {
  ...
}
```

当函数名后存在`()`时, 关键词`function`是多余的, 但是其促进了函数的快速辨识.


## 变量名
命名规则和函数名一样.

循环的变量名应该和循环的任何变量同样命名:

```bash
for zone in ${zones}; do
  something_with "${zone}"
done
```

## 常量和环境变量名

常量和任何导出到环境中的都应该大写, 并且放在文件的顶部.
```bash
# Constant
readonly PATH_TO_FILES='/some/path'

# Both constant and environment
declare -xr ORACLE_SID='PROD'
```

第一次设置时有一些就变成了常量(例如通过getopts).
因此, 可以在getopts中或基于条件来设定常量, 但之后应该立即设置其为只读.
值得注意的是, 在函数中`declare`不会对全局变量进行操作, 所以推荐使用 `readonly` 和 `export` 来代替。

```bash
VERBOSE='false'
while getopts 'v' flag; do
  case "${flag}" in
    v) VERBOSE='true' ;;
  esac
done
readonly VERBOSE
```

## 源文件名

小写, 如果需要的话使用下划线分隔单词
这是为了和在Google中的其他代码风格保持一致:
maketemplate 或者 make_template, 而不是 make-template


## 只读变量

使用 `readonly` 或者 `declare -r` 来确保变量只读.
因为全局变量在shell中广泛使用, 所以在使用它们的过程中捕获错误是很重要的.当你声明了一个变量, 希望其只读, 那么请明确指出.

```bash
zip_version="$(dpkg --status zip | grep Version: | cut -d ' ' -f 2)"
if [[ -z "${zip_version}" ]]; then
  error_message
else
  readonly zip_version
fi
```


## 使用本地变量

一般用在函数中, 使用`local`关键字
声明和赋值应该在不同行, 当赋值的值由命令替换提供时, 声明和赋值必须分开. 因为内建的 `local` 不会从命令替换中传递退出码.

```bash
my_func2() {
  local name="$1"

  # Separate lines for declaration and assignment:
  local my_var
  my_var="$(my_func)" || return

  # DO NOT do this: $? contains the exit code of 'local', not my_func
  local my_var="$(my_func)"
  [[ $? -eq 0 ]] || return

  ...
}
```


## 函数位置

如果你有函数, 请将他们一起放在文件头部. 只有`includes`,  `set声明`和`常量设置`可能在函数声明之前完成. 不要在函数之间隐藏可执行代码. 如果那样做,会使得代码在调试时难以跟踪并出现意想不到的讨厌结果.



## 主函数main


对于包含至少一个其他函数的足够长的脚本, 需要称为 main 的函数.

为了方便查找程序的开始, 将主程序放入一个称为 main 的函数，作为最下面的函数. 这使其和代码库的其余部分保持一致性, 同时允许你定义更多变量为局部变量（如果主代码不是一个函数就不能这么做）。

文件中最后的非注释行应该是对 main 函数的调用, 例如:

```bash
main "$@"
```

然然仅仅是顺序执行(线性流)的脚本, main函数的出现可能会有些多余.


# 格式

## 缩进

主要注意点如下:
1. 缩进两个空格, 没有制表符
2. 在代码块之间请使用空行以提升可读性
3. 缩进为两个空格,  无论你做什么, 请不要使用制表符
4. 对于已有文件，保持已有的缩进格式


## 长度

行的最大长度为80个字符

如果你必须写长度超过80个字符的字符串, 如果可能的话, 尽量使用here document或者嵌入的换行符.
* END; 语法
* 字符串内嵌换行符号

例如:

```bash
# DO use 'here document's
cat << END;
I am an exceptionally long
string.
END

# Embedded newlines are ok too
long_string="I am an exceptionally
  long string."
```

长度超过80个字符的文字串且不能被合理地分割, 这是正常的, 但强烈建议找到一个方法使其变短.


## 管道

如果一行容得下整个管道操作，那么请将整个管道操作写在同一行。
否则应该将整个管道操作分割成每行一个管段, 管道操作的下一部分应该将管道符放在新行并且缩进2个空格. 

```bash
# All fits on one line
command1 | command2

# Long commands
command1 \
  | command2 \
  | command3 \
  | command4
```
(注意上面代码, 如果在第二行, 要进行缩进)

这适用于使用管道符’|’的合并命令链以及使用’||’和’&&’的逻辑运算链.



## 循环和分支

请将 `; do `, `; then` 和 `while` , `for` , `if` 放在同一行.
else 应该单独一行, 结束语句应该单独一行并且跟开始语句垂直对齐.

例如:

```bash
for dir in ${dirs_to_cleanup}; do
  if [[ -d "${dir}/${ORACLE_SID}" ]]; then
    log_date "Cleaning up old files in ${dir}/${ORACLE_SID}"
    rm "${dir}/${ORACLE_SID}/"*
    if [[ "$?" -ne 0 ]]; then
      error_message
    fi
  else
    mkdir -p "${dir}/${ORACLE_SID}"
    if [[ "$?" -ne 0 ]]; then
      error_message
    fi
  fi
done
```

## case语句
主要注意缩进和换行:
* 缩进: 
  * 通过2个空格缩进可选项
  * 匹配表达式`value )`比 case 和 esac 缩进一级; 多行操作要再缩进一级
* 换行: 
  * 在同一行可选项的模式`右圆括号`之后和结束符` ;; `之前各需要一个空格
  * 长可选项或者多命令可选项应该被拆分成多行: 模式、操作和结束符 ;; 在不同的行

例如:
```bash
case "${expression}" in
  a)
    variable="..."
    some_command "${variable}" "${other_expr}" ...
    ;;
  absolute)
    actions="relative"
    another_command "${actions}" "${other_expr}" ...
    ;;
  *)
    error "Unexpected expression '${expression}'"
    ;;
esac
```

同一行的情况:右括号之后和结束符` ;; `之前请使用一个空格分隔
```bash
verbose='false'
aflag=''
bflag=''
files=''
while getopts 'abf:v' flag; do
  case "${flag}" in
    a) aflag='true' ;;
    b) bflag='true' ;;
    f) files="${OPTARG}" ;;
    v) verbose='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done
```

## 变量扩展(引用)

推荐将其他所有变量用大括号括起来(但不是强制)
荐用`${var}` 而不是 `$var`.

```bash
# Section of recommended cases.

# Preferred style for 'special' variables:
echo "Positional: $1" "$5" "$3"
echo "Specials: !=$!, -=$-, _=$_. ?=$?, #=$# *=$* @=$@ \$=$$ ..."

# Braces necessary:
echo "many parameters: ${10}"

# Braces avoiding confusion:
# Output is "a0b0c0"
set -- a b c
echo "${1}0${2}0${3}0"

# Preferred style for other variables:
echo "PATH=${PATH}, PWD=${PWD}, mine=${some_var}"
while read f; do
  echo "file=${f}"
done < <(ls -l /tmp)

# Section of discouraged cases

# Unquoted vars, unbraced vars, brace-quoted single letter
# shell specials.
echo a=$avar "b=$bvar" "PID=${$}" "${1}"

# Confusing use: this is expanded as "${1}0${2}0${3}0",
# not "${10}${20}${30}
set -- a b c
echo "$10$20$30"
```


## 引用(号)
主要涉及:

* 单引号
* 双引号
* 引用(命令行-函数)参数

大致规则如下:(google原文档比较难理解)

* 引号用于包裹变量、命令替换符、空格或shell元字符的字符串
* 单引号用于引用字符串中没有子串(shell元字符可以不用转义)
* 双引号用于引用的字符串中可以有子串, 或者"$( )"命令子串, 或者"命令行(位置)参数",例如`"$1"`
* 推荐引用是单词的字符串
* 千万不要引用整数
* 请使用`$@` 除非你有特殊原因需要使用`$*` (参考下面的代码)



代码演示如下:
```bash
# 'Single' quotes indicate that no substitution is desired.
# "Double" quotes indicate that substitution is required/tolerated.

# Simple examples
# "quote command substitutions"
flag="$(some_command and its args "$@" 'quoted separately')"

# "quote variables"
echo "${flag}"

# "never quote literal integers"
value=32

# "quote command substitutions", even when you expect integers
number="$(generate_number)"

# "prefer quoting words", not compulsory
readonly USE_INTEGER='true'

# "quote shell meta characters" 这里单引号和双引号作用不一样
echo 'Hello stranger, and well met. Earn lots of $$$'
echo "Process $$: Done making \$\$\$."

# "command options or path names"
# ($1 is assumed to contain a value here)
grep -li Hugo /dev/null "$1"

# Less simple examples
# "quote variables, unless proven false": ccs might be empty
git send-email --to "${reviewers}" ${ccs:+"--cc" "${ccs}"}

# Positional parameter precautions: $1 might be unset
# Single quotes leave regex as-is.
grep -cP '([Ss]pecial|\|?characters*)$' ${1:+"$1"}

# For passing on arguments,
# "$@" is right almost everytime, and
# $* is wrong almost everytime:
#
# * $* and $@ will split on spaces, clobbering up arguments
#   that contain spaces and dropping empty strings;
# * "$@" will retain arguments as-is, so no args
#   provided will result in no args being passed on;
#   This is in most cases what you want to use for passing
#   on arguments.
# * "$*" expands to one argument, with all args joined
#   by (usually) spaces,
#   so no args provided will result in one empty string
#   being passed on.
# (Consult 'man bash' for the nit-grits ;-)

set -- 1 "2 two" "3 three tres"; echo $# ; set -- "$*"; echo "$#, $@")
set -- 1 "2 two" "3 three tres"; echo $# ; set -- "$@"; echo "$#, $@")
```



# 调用命令

## 检查返回值

总是检查返回值并给出信息返回值.

对于非管道命令, 使用 `$?` 或直接通过一个 `if` 语句来检查以保持其简洁.

```bash
if ! mv "${file_list}" "${dest_dir}/" ; then
  echo "Unable to move ${file_list} to ${dest_dir}" >&2
  exit "${E_BAD_MOVE}"
fi

# Or
mv "${file_list}" "${dest_dir}/"
if [[ "$?" -ne 0 ]]; then
  echo "Unable to move ${file_list} to ${dest_dir}" >&2
  exit "${E_BAD_MOVE}"
fi
```

Bash也有 `PIPESTATUS` 变量, 允许检查从管道所有部分返回的代码.
如果仅仅需要检查整个管道是成功还是失败, 以下的方法是可以接受的:

```bash
tar -cf - ./* | ( cd "${dir}" && tar -xf - )
if [[ "${PIPESTATUS[0]}" -ne 0 || "${PIPESTATUS[1]}" -ne 0 ]]; then
  echo "Unable to tar files to ${dir}" >&2
fi
```


可是, 只要你运行任何其他命令, `PIPESTATUS` 将会被覆盖.如果你需要基于管道中发生的错误执行不同的操作, 那么你需要在运行命令后立即将 `PIPESTATUS`数组 赋值给另一个(数组)变量(别忘了 [ 是一个会将 PIPESTATUS 擦除的命令)

```bash
tar -cf - ./* | ( cd "${DIR}" && tar -xf - )
return_codes=(${PIPESTATUS[*]})
if [[ "${return_codes[0]}" -ne 0 ]]; then
  do_something
fi
if [[ "${return_codes[1]}" -ne 0 ]]; then
  do_something_else
fi
```






## 内建or外部

可以在调用shell内建命令和调用另外的程序之间选择, 请选择内建命令.
(从健壮性和扩展性方面进行考虑)


```bash
# Prefer this:
addition=$((${X} + ${Y}))
substitution="${string/#foo/bar}"

# Instead of this:
addition="$(expr ${X} + ${Y})"
substitution="$(echo "${string}" | sed -e 's/^foo/bar/')"
```


(我个人的习惯, 使用`$[  ]` 而不是 `$((  ))` 进行数学计算)




# 特性及错误

## 命令替换
使用 `$(command)` 而不是反引号. 理由如下:

嵌套的反引号要求用反斜杠转义内部的反引号.
而 `$(command)` 形式嵌套时不需要改变, 而且更易于阅读.

```bash
# This is preferred:
var="$(command "$(command1)")"

# This is not:
var="`command \`command1\``"
```




## [和[[

条件测试, 推荐使用 `[[ ... ]]` ，而不是 `[ `, `test` , 和 `/usr/bin/ [`.

* 因为在 "[[" 和 "]]" 之间不会有路径名称扩展或单词分割发生
* "[[ ... ]]" 允许正则表达式匹配, 而 "[ ... ]" 不允许

```bash
# This ensures the string on the left is made up of characters in the
# alnum character class followed by the string name.
# Note that the RHS should not be quoted here.
# For the gory details, see
# E14 at http://tiswww.case.edu/php/chet/bash/FAQ
if [[ "filename" =~ ^[[:alnum:]]+name ]]; then
  echo "Match"
fi

# This matches the exact pattern "f*" (Does not match in this case)
if [[ "filename" == "f*" ]]; then
  echo "Match"
fi

# This gives a "too many arguments" error as f* is expanded to the
# contents of the current directory
if [ "filename" == f* ]; then
  echo "Match"
fi
```


## 测试字符串

尽可能使用引用,而不是过滤字符串.

即应该这样: 
```bash
# Do this:
if [[ "${my_var}" = "some_string" ]]; then
  do_something
fi

# -z (string length is zero) and -n (string length is not zero) are
# preferred over testing for an empty string
if [[ -z "${my_var}" ]]; then
  do_something
fi

# This is OK (ensure quotes on the empty side), but not preferred:
if [[ "${my_var}" = "" ]]; then
  do_something
fi
```

而不是这样:
```bash
# Not this:
if [[ "${my_var}X" = "some_stringX" ]]; then
  do_something
fi
```


判断空串,应该使用`-n`选项, 而不是直接应用字符串.(测试目的明确)

```bash
# Use this
if [[ -n "${my_var}" ]]; then
  do_something
fi

# Instead of this as errors can occur if ${my_var} expands to a test
# flag
if [[ "${my_var}" ]]; then
  do_something
fi
```


## 点通配符

如果你要使用`*`作为文件/目录的通配符, 那么请用目录路径作为限制,这样比较安全.

即使用 `./*` 而不是直接使用 `*` , 因为文件名可能以`-`开头.

演示代码如下:
```bash
# Here's the contents of the directory:
# -f  -r  somedir  somefile

# This deletes almost everything in the directory by force
psa@bilby$ rm -v *
removed directory: `somedir'
removed `somefile'

# As opposed to:
psa@bilby$ rm -v ./*
removed `./-f'
removed `./-r'
rm: cannot remove `./somedir': Is a directory
removed `./somefile'
```


## Eval

当用于给变量赋值时, 避免使用`eval`, 因为Eval解析输入, 并且能够设置变量, 但无法检查这些变量是什么.

```bash
# What does this set?
# Did it succeed? In part or whole?
eval $(set_my_variables)

# What happens if one of the returned values has a space in it?
variable="$(eval some_function)"
```



## 管道导向循环

总之, 请使用过程替换或者for循环, 而不是管道导向while循环.

把第一个命令的结果传递给第二个命令, 如果第二个命令是循环, 则称为"管道导向循环", 例如:

```bash
last_line='NULL'
your_command | while read line; do
  last_line="${line}"
done

# This will output 'NULL'
echo "${last_line}"
```
子进行中修改了变量last_line, 回到父进程的时候, 还是没有变.
管道导向while循环中的隐式子shell使得追踪bug变得很困难.

在while循环中被修改的变量是不能传递给父shell的, 因为循环命令是在一个子shell中运行的.(父子进行不共享内部变量)



如果你确定输入中不包含空格或者特殊符号（通常意味着不是用户输入的），那么可以使用一个for循环:

```bash
total=0
# Only do this if there are no spaces in return values.
for value in $(command); do
  total+="${value}"
done
```

特殊情况:
使用过程替换允许重定向输出, 但是请将命令放入一个 `显式的子shell` 中, 而不是bash为while循环创建的隐式子shell.

```bash
total=0
last_file=
while read count filename; do
  total+="${count}"
  last_file="${filename}"
done < <(your_command | uniq -c)

# This will output the second field of the last line of output from
# the command.
echo "Total = ${total}"
echo "Last one = ${last_file}"
```

当不需要传递复杂的结果给父shell时可以使用while循环, 当你特别不希望改变父shell的范围变量时这可能也是有用的.

但这种情况的, 代码逻辑的解析过程会比较复杂, 还不如直接使用 `awk` 这类工具.

```bash
# Trivial implementation of awk expression:

cat /proc/mounts | while read src dest type opts rest; do
  if [[ ${type} == "nfs" ]]; then
    echo "NFS ${dest} maps to ${src}"
  fi
done
```

或者

```bash
awk '$3 == "nfs" { print $2 " maps to " $1 }' /proc/mounts
```

 




# 结束语

借用别人的话:

> 运用常识和判断力, 并且 保持一致.

> 风格指南的重点在于提供一个通用的编程规范, 这样大家可以把精力集中在实现内容而不是表现形式上. 我们展示的是一个总体的的风格规范, 但局部风格也很重要, 如果你在一个文件中新加的代码和原有代码风格相去甚远, 这就破坏了文件本身的整体美观, 也让打乱读者在阅读代码时的节奏, 所以要尽量避免.


