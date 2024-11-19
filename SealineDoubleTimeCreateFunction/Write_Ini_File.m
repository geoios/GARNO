function [result] = Write_Ini_File(FilePath,key,value)
 %首先判断配置文件是否存在
 if(exist(FilePath,'file') ~= 2)
     result = 0;
	 return;
 end
 %检查文件中有无key值，如果没有则直接写入到最后一行，否则替换原来的value值
 fid = fopen(FilePath);
 isFind = 0;
 WriteAllText = '';
 while ~feof(fid)
 	tline = fgetl(fid);
 	if ~ischar(tline) || isempty(tline)
 		%跳过无效行
 		continue;
	end
	tline(find(isspace(tline))) = []; %删除空格
	Index = strfind(tline, [key '=']);
	WriteAllText = sprintf('%s%s\r\n',WriteAllText,tline);
	if ~isempty(Index)
		%如果找到该配置项，则用新配置替换
		mytext = [key '=' value];
		WriteAllText = strrep(WriteAllText,tline,mytext);
		isfind = 1;
	end
 end
 fclose(fid) %关闭配置文件
 %创建新的配置文件并写入
 if isfind == 0
 	%配置文件中如果没有key，则加入末尾行
 	WriteAllText = sprintf('%s%s\r\n',WriteAllText ,[key '=' value]);
 end
 %写入配置
 fid = fopen(FilePath,'w+');
 fprintf(fid,'%s',WriteAllText);
 fclose(fid);
end


