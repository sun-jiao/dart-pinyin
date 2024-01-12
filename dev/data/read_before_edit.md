请在编辑xlsx文件后将其导出为csv，而不是直接编辑csv文件。
直接打开csv文件可能导致含有E的16进制数被转换为科学计数法，
或者non-BMP的字符被转换成乱码。

Please export the xlsx file to csv after editing it 
instead of editing the csv file directly. Directly 
opening a csv file may cause hexadecimal numbers 
containing `E` to be converted into scientific
numbers, or non-BMP character surrogate pairs to not 
be processed correctly.

导出为csv文件时请注意编码格式。

Please pay attention to the encoding format when 
exporting it to a csv file.

请在您的`.git/config`或`~/.gitconfig`中加入以下内容：

Please add the following script to your `.git/config`
or `~/.gitconfig` file:

```
[diff "xlsx"]
    binary = true
    textconv = unzip -c -a
```