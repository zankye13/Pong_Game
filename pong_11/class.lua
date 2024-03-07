-- bu fonksiyon bir tablodan diğerine değerlerin kopyalanmasını sağlar
-- to = kopyalama yapılacak hedef
-- frim = kopyalanacak tablo
-- seen = daha önce ziyaret edilen tabloların takibi bunun üzerinden yapılabilir

local function include_helper(to, from, seen) -- fonksiyon recursive olarak çağırılır ve tüm tablo içeriğini kopyalar
	if from == nil then
		return to
	elseif type(from) ~= 'table' then
		return from
	elseif seen[from] then
		return seen[from]
	end

	seen[from] = to
	for k,v in pairs(from) do
		k = include_helper({}, k, seen) -- keys might also be tables
		if to[k] == nil then
			to[k] = include_helper({}, v, seen)
		end
	end
	return to
end

-- bu fonksiyon bir sınıfa diğer sınıfların özelliklerini dahil eder
-- class = başlangıç sınıfı
-- other = dahil edilecek diğer sınıf(lar)
local function include(class, other) 
	return include_helper(class, other, {}) -- sınıflar arası ilişkiler belirlenir
end

-- bu fonksiyon bir nesnenin kopyasını oluşturur
-- other = kopyalanacak nesne
local function clone(other)
	return setmetatable(include({}, other), getmetatable(other)) -- include işlevi ile nesnenin içeriği kopyalanır
end

-- bu fonksiyon yeni bir sınıf oluşturur
local function new(class)
	
	class = class or {}  
	local inc = class.__includes or {}
	if getmetatable(inc) then inc = {inc} end

	for _, other in ipairs(inc) do
		if type(other) == "string" then
			other = _G[other]
		end
		include(class, other)
	end

    -- class implementasyonu
	class.__index = class
	class.init    = class.init    or class[1] or function() end
	class.include = class.include or include
	class.clone   = class.clone   or clone

	-- sınıf işlev haline getirilir (constructor çağırılır)
	return setmetatable(class, {__call = function(c, ...)
		local o = setmetatable({}, c)
		o:init(...)
		return o
	end})
end

-- bu fonksiyon sınıfların farklı sistemler arasındaki uyumluluğunu sağlar
if class_commons ~= false and not common then
	common = {}
	function common.class(name, prototype, parent)
		return new{__includes = {prototype, parent}}
	end
	function common.instance(class, ...)
		return class(...)
	end
end


-- modül fonksiyonlarını ve arayüzü dışarıya sunar
return setmetatable({new = new, include = include, clone = clone},
	{__call = function(_,...) return new(...) end})