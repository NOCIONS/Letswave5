clc;clear;
[header,data] = LW_importMEGA('NeurOne\2014-02-27T122801',1);
str='data1';
save([str,'.mat'],'-MAT','data');
save([str,'.lw5'],'-MAT','header');


[header,data] = LW_importMEGA('NeurOne\2014-02-27T122801',2);
str='data2';
save([str,'.mat'],'-MAT','data');
save([str,'.lw5'],'-MAT','header');
