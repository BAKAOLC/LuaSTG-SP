--[[
LuaSTG Special Plus 系函数库 file 附加库
data by OLC
]]

sp.file={}

--读取文件为文件流（默认只读）
function sp.file.LoadFile(filepath,mode)
	local m=mode or 'r'
	local f,msg=io.open(filepath,m)
	return f,not(msg)
end

--卸载文件流
function sp.file.UnLoadFile(file)
	io.close(file)
end

--检查文件是否存在
function sp.file.CheckFileExist(filepath)
	local file,ref=sp.file.LoadFile(filepath)
	sp.file.UnLoadFile(file)
	return ref
end

--读取一个文件并储存为表（以行为分割）
function sp.file.GetFileLine(filepath)
	local line={}
	local file,ref=sp.file.LoadFile(filepath)
	if not(ref) then return nil,false end
	for str in file:lines() do
		table.insert(line,str)
	end
	sp.file.UnLoadFile(file)
	return line,true
end

--向文件流末尾写入一行字符
function sp.file.WriteLine(file,str)
	if io.type(file)=='file' then
		file:setvbuf('line')
		file:write(str)
		return true
	else
		return false
	end
end

function sp.file.SaveToByte(file,saveto)
	local file,ref=sp.file.LoadFile(file,'r')
	if ref then
		local save,ref=sp.file.LoadFile(saveto,'w')
		if ref then
			local str=file:read(1)
			while str do
				local num=string.byte(str)
				num=(num+128)*3+72
				save:write(num..' ')
				str=file:read(1)
			end
			sp.file.UnLoadFile(save)
			sp.file.UnLoadFile(file)
		end
	end
end
function sp.file.ReadFromByte(file,saveto)
	local file,ref=sp.file.LoadFile(file,'r')
	if ref then
		local save,ref=sp.file.LoadFile(saveto,'wb')
		if ref then
			local num=file:read('*n')
			while num do
				num=(num-72)/3-128
				local str=string.char(num)
				save:write(str)
				num=file:read('*n')
			end
			sp.file.UnLoadFile(save)
			sp.file.UnLoadFile(file)
		end
	end
end

function sp.file.StringSaveToByte(str,saveto)
	local save,ref=sp.file.LoadFile(saveto,'w')
	if ref then
		for s in string.gmatch(str,".") do
			local num=string.byte(s)
			num=(num+128)*3+72
			save:write(num..' ')
		end
		sp.file.UnLoadFile(save)
	end
end
function sp.file.StringReadFromByte(file)
	local file,ref=sp.file.LoadFile(file,'r')
	local str=''
	if ref then
		local num=file:read('*n')
		while num do
			num=(num-72)/3-128
			str=str..string.char(num)
			num=file:read('*n')
		end
		sp.file.UnLoadFile(file)
		return str
	end
end

sp.Print(string.format("[sp] File Additional Library install"))