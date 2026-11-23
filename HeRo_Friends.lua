--*************************************************************************************************************************************************************
-- Tool by : '' MAHMOUDHERO ''
-- Modify  by HERO
-- Decrypted by : '' MAHMOUDHERO '' 
--*************************************************************************************************************************************************************
-- ██╗  ██╗███████╗██████╗  ██████╗ 
-- ██║  ██║██╔════╝██╔══██╗██╔═══██╗
-- ███████║█████╗  ██████╔╝██║   ██║
-- ██╔══██║██╔══╝  ██╔══██╗██║   ██║
-- ██║  ██║███████╗██║  ██║╚██████╔╝
-- ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝--

local MIN_VERSION = "101.4" 
local VERSION_URL = "https://pastebin.com/raw/F1t2tycZ"

local DOWNLOAD_LINK  = "https://linktr.ee/mahmoud.hero"
local TELEGRAM_LINK  = "https://t.me/mahmoudhero0"
local MESSENGER_LINK = "https://m.me/mahmouddhero"

local LINE = "━━━━━━━━━━━━━━━━"


local function parseVer(s)
  local t = {}
  for n in tostring(s or ""):gmatch("%d+") do t[#t + 1] = tonumber(n) end
  return t
end

local function isOlder(a, b)
  local x, y = parseVer(a), parseVer(b)
  for i = 1, math.max(#x, #y) do
    local p, q = x[i] or 0, y[i] or 0
    if p ~= q then return p < q end
  end
  return false
end


local function copyLink(name, url)
  pcall(os.execute, '/system/bin/am start --user 0 -a android.intent.action.VIEW -d "' .. url .. '" >/dev/null 2>&1')
  gg.copyText(url, false)

  local msg = "✅ تم نسخ رابط " .. name .. " بنجاح\n\n"
    .. LINE .. "\n\n"
    .. "🔗 " .. url .. "\n\n"
    .. LINE .. "\n\n"
    .. "📋 افتح المتصفح أو التطبيق، ثم اضغط مطولًا على شريط البحث واختر (لصق)."

  return gg.alert(msg, "🔙 رجوع للقائمة", "▶️ بدء السكربت", "🚪 خروج")
end

local function showUpdate(latest)
  while true do
    local msg = "🔔 تحديث جديد لـ جيم جاردن 🔔\n\n"
      .. LINE .. "\n\n"
      .. "📌 إصدارك الحالي: " .. tostring(gg.VERSION) .. "\n"
      .. "🚀 الإصدار الجديد: " .. latest .. "\n\n"
      .. LINE .. "\n\n"
      .. "📥 طريقة التحديث:\n\n"
      .. "1️⃣ اضغط على (تحميل التحديث) لنسخ رابط الموقع.\n"
      .. "2️⃣ الصق الرابط في المتصفح وادخل إلى الموقع.\n"
      .. "3️⃣ حمّل الإصدار الذي اسمه (تحميل الاسكربت).\n\n"
      .. LINE .. "\n\n"
      .. "💬 للمساعدة:\n"
      .. "تواصل مع المطور عبر تليجرام أو ماسنجر.\n\n"
      .. LINE .. "\n\n"
      .. "⚠️ ننصح بالتحديث للحصول على أحدث الميزات والإصلاحات."

    local choice = gg.alert(msg, "📥 تحميل التحديث", "✈️ تليجرام", "💬 ماسنجر")

    local result
    if choice == 1 then
      result = copyLink("التحميل", DOWNLOAD_LINK)
    elseif choice == 2 then
      result = copyLink("تليجرام", TELEGRAM_LINK)
    elseif choice == 3 then
      result = copyLink("ماسنجر", MESSENGER_LINK)
    else
      return 
    end

    if result == 3 then
      os.exit() 
    elseif result ~= 1 then
      return 
    end
  end
end


local required = MIN_VERSION
local ok, response = pcall(gg.makeRequest, VERSION_URL)
if ok and response and response.content then
  local v = response.content:match("%d+[%d%.]*")
  if v then required = v end
end

if isOlder(gg.VERSION, required) then
  showUpdate(required)
end


do
    local _error = error
    error = function() os.exit() end

    local _make = gg.makeRequest
    gg.makeRequest = function(url)
        local ok, res = pcall(_make, url)
        if not ok or type(res) ~= "table" or not res.content then
            os.exit()
        end
        return res
    end

    local _load = load
    load = function(...)
        local ok, f = pcall(_load, ...)
        if not ok then os.exit() end
        return f
    end

    local _loadstring = loadstring
    if _loadstring then
        loadstring = function(...)
            local ok, f = pcall(_loadstring, ...)
            if not ok then os.exit() end
            return f
        end
    end
end



--نطاقات Ca
gg.setVisible(false)
local cachedValues = {
    secondary = nil,
    mainPattern = nil
}
-- =============  المؤشرات =============

function cacheSecondaryPattern()
    if cachedValues.secondary then return true end
    
    gg.clearResults()
    gg.searchNumber('1599099688;1936682818;33;24', gg.TYPE_DWORD)
    gg.refineNumber('33', gg.TYPE_DWORD)
    local results = gg.getResults(1)

    if #results < 1 then
        gg.toast("لم يتم العثور على الكود الأول جاري البحث عن الكود الثاني")
        gg.clearResults()

        gg.searchNumber('1599099680;109;33;26:33', gg.TYPE_DWORD)
        gg.refineNumber('33', gg.TYPE_DWORD)
        results = gg.getResults(1)

        if #results < 1 then
            gg.toast("لم يتم العثور على الكود الثاني جاري البحث عن الكود الثالث")
            gg.clearResults()

            gg.searchNumber('1701998675;116;33;30:65', gg.TYPE_DWORD)
            gg.refineNumber('33', gg.TYPE_DWORD)
            results = gg.getResults(1)

            if #results < 1 then
                gg.alert("⚠️كود استخراج قيمه 33 لا يعمل تحدث مع مطور الاسكربت⚠️")
                gg.clearResults()
                return false
            else
                gg.toast("الكود الثالث يعمل جاري الاستكمال انتظر🙋")
            end
        else
            gg.toast("الكود الثاني يعمل جاري الاستكمال انتظر🙋")
        end
    else
        gg.toast("الكود الأول يعمل جاري الاستكمال انتظر🙋")
    end

    local address = results[1].address
    cachedValues.secondary = {
        address = address,
        values = gg.getValues({
            {address = address + 0x0, flags = gg.TYPE_DWORD},
            {address = address + 0x4, flags = gg.TYPE_DWORD},
            {address = address + 0x8, flags = gg.TYPE_DWORD},
            {address = address + 0xC, flags = gg.TYPE_DWORD},
            {address = address + 0x10, flags = gg.TYPE_DWORD},
            {address = address + 0x14, flags = gg.TYPE_DWORD}
        })
    }

    return true
end

function cacheMainPattern()
    if cachedValues.mainPattern then return true end
    
    gg.clearResults()
    gg.searchNumber('65537~65542;1970225964;29::457', gg.TYPE_DWORD)
    gg.refineNumber('29', gg.TYPE_DWORD)
    local results = gg.getResults(2)

    if #results ~= 1 then
        gg.toast("لم يتم العثور على الكود الأول جاري البحث عن الكود الثاني")
        gg.clearResults()

        gg.searchNumber('65537~65542;1970225964;5;29::457', gg.TYPE_DWORD)
        gg.refineNumber('29', gg.TYPE_DWORD)
        results = gg.getResults(2)

        if #results ~= 1 then
            gg.toast("لم يتم العثور على الكود الثاني جاري البحث عن الكود الثالث")
            gg.clearResults()

            gg.searchNumber('28;1952533798;29::641', gg.TYPE_DWORD)
            gg.refineNumber('29', gg.TYPE_DWORD)
            results = gg.getResults(2)

            if #results ~= 1 then
                gg.alert("❌ كود استبدال الهديه رقم 29 لا يعمل  ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ") 
                gg.clearResults()
                return false
            else
                gg.toast("الكود الثالث يعمل جاري الاستكمال انتظر🙋")
            end
        else
            gg.toast("الكود الثاني يعمل جاري الاستكمال انتظر🙋")
        end
    else
        gg.toast("الكود الأول يعمل جاري الاستكمال انتظر🙋")
    end
    
    cachedValues.mainPattern = results[1].address
    return true
end

local function safeQword(addr)
    local ok, res = pcall(function()
        return gg.getValues({{address = addr, flags = gg.TYPE_QWORD}})[1]
    end)
    if not ok or not res or type(res.value) ~= "number" then return nil end
    return res.value
end

local function isValidPtr(p)
    return type(p) == "number" and p ~= 0 and p > 0x10000 and p < 0x7FFFFFFFFFFF
end

local function toNum(v, def)
    local n = tonumber(v)
    if n == nil then return def or 0 end
    return n
end

function applyStatue(values, statueName, showInput)
    if not cacheSecondaryPattern() or not cacheMainPattern() then
        return
    end

    local mainAddress = cachedValues.mainPattern
    local refValues   = cachedValues.secondary.values
    
    if showInput then
        local input = gg.prompt({"🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n🙋 اكتب الرقم الذي تريده 🙋"},
            {""},
            {"number"}
        )
        if input then
            local customValue = toNum(input[1], 0)
            pcall(function()
                gg.setValues({{address = mainAddress + 40, flags = gg.TYPE_QWORD, value = customValue}})
            end)
        else
            gg.toast("تم الإلغاء")
            return
        end
    end

    
    gg.sleep(100)

    local okBase = pcall(function()
        gg.setValues({
            {address = mainAddress + 12, flags = gg.TYPE_DWORD, value = 2}, -- الأوفيس 12 المضاف
            {address = mainAddress + 16, flags = gg.TYPE_DWORD, value = refValues[1].value},
            {address = mainAddress + 20, flags = gg.TYPE_DWORD, value = refValues[2].value},
            {address = mainAddress + 24, flags = gg.TYPE_DWORD, value = refValues[3].value},
            {address = mainAddress + 28, flags = gg.TYPE_DWORD, value = refValues[4].value},
            {address = mainAddress + 32, flags = gg.TYPE_DWORD, value = refValues[5].value},
            {address = mainAddress + 36, flags = gg.TYPE_DWORD, value = refValues[6].value}            
        })
    end)
    if not okBase then
        gg.alert("هناك خطأ في استبدال الكود تحدث مع مطور الاسكربت وأرسل صوره❤️")
        return
    end
   
 local pointer = safeQword(mainAddress + 32)
if isValidPtr(pointer) then
    local mods = {}
    local count = #values or 0
    if count == 0 then return end

    ------------------------------------------------
    
    ------------------------------------------------
    local last = values[count]
    local prev = values[count - 1]

    local lastSmall = type(last) == "number" and math.abs(last) < 43
    local prevSmall = type(prev) == "number" and math.abs(prev) < 43

    
    local skip = 1
    if lastSmall and prevSmall then
        skip = 2
    end

    ------------------------------------------------
    
    ------------------------------------------------
    local ptrCount = math.min(count - skip, 10)
    if ptrCount < 0 then ptrCount = 0 end

    for i = 1, ptrCount do
        mods[#mods + 1] = {
            address = pointer + (i - 1) * 4,
            flags   = gg.TYPE_DWORD,
            value   = toNum(values and values[i], 0)
        }
    end

    for i = ptrCount + 1, 10 do
        mods[#mods + 1] = {
            address = pointer + (i - 1) * 4,
            flags   = gg.TYPE_DWORD,
            value   = 0
        }
    end

    ------------------------------------------------
    
    ------------------------------------------------
    if skip == 2 then
        mods[#mods + 1] = {
            address = mainAddress + 16,
            flags   = gg.TYPE_DWORD,
            value   = toNum(values and values[count - 1], 0)
        }
    end

    ------------------------------------------------

    ------------------------------------------------
    mods[#mods + 1] = {
        address = mainAddress + 24,
        flags   = gg.TYPE_DWORD,
        value   = toNum(values and values[count], 0)
    }

    pcall(function() gg.setValues(mods) end)
else
    gg.toast("⚠️هناك مشكله في المؤشر تحدث مع مطور الاسكربت وأرسل صوره⚠️")
end
    
    
    if statueName then
        gg.sleep(500)
        gg.toast("تم استبدال كود " .. statueName)
        gg.sleep(500)
        gg.alert(
            "🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n" ..
            "✨ تم استبدال كود " .. statueName .. " بنجاح ✨\n\n" ..
            "⚠️ ملاحظة: يجب استلام الهديه رقم 29 لتظهر التغييرات\n\n" ..
            "🇪🇬 Egypt Mother of the World 🇪🇬"
        )
    end
end

-- ============= نظام applyTicket  =============
local ticketSystem = {
    initialized = false,
    secondResults = {},
    
    init = function(self)
        if self.initialized then return true end      
        gg.toast("🏴‍☠️𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🏴‍☠️")
        

        gg.clearResults()
        gg.searchNumber("65537~65542;1970225964;29::457", gg.TYPE_DWORD)
        gg.refineNumber("29", gg.TYPE_DWORD)
        
        local results = gg.getResults(100)
        
        if #results < 1 then
            gg.toast("لم يتم العثور على الكود الأول جاري البحث عن الكود الثاني")
            gg.clearResults()
            
       
            gg.searchNumber("28;1952533798;29::641", gg.TYPE_DWORD)
            gg.refineNumber("29", gg.TYPE_DWORD)
            results = gg.getResults(100)
            
            if #results < 1 then
                gg.toast("لم يتم العثور على الكود الثاني جاري البحث عن الكود الثالث")
                gg.clearResults()
                

                gg.searchNumber("65537;1970225964;29:457", gg.TYPE_DWORD)
                results = gg.getResults(100)
                
                if #results < 1 then
                    gg.alert("❌ كود استبدال الهديه رقم 29 لا يعمل  ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ") 
                    gg.clearResults()
                    return false
                else
                    gg.toast("الكود الثالث يعمل جاري الاستكمال انتظر🙋")
                end
            else
                gg.toast("الكود الثاني يعمل جاري الاستكمال انتظر🙋")
            end
        else
            gg.toast("الكود الأول يعمل جاري الاستكمال انتظر🙋")
        end
        
        self.secondResults = results
        self.initialized = true        
        return true
    end
}

-- ============= نظام applyTicket  =============
function applyTicket(values, name, showInput)
    if not ticketSystem:init() then return end

    local tickets = {}
    local shouldShowInput = false
    
    if type(values) == "table" and values.values and values.name then
        table.insert(tickets, {name = values.name, values = values.values})
        shouldShowInput = true
    elseif type(values[1]) == "number" and name then
        table.insert(tickets, {name = name, values = values})
        shouldShowInput = showInput == true
    elseif type(values[1]) == "table" and values[1].name then
        tickets = values
        for _, ticket in ipairs(tickets) do
            if ticket.values and ticket.name then
                shouldShowInput = true
                break
            end
        end
    else
        gg.alert("⚠️هناك مشكله في التنسيق تحدث مع مطور الاسكربت⚠️")
        return
    end

    local inp = {}
    
    if shouldShowInput then
        local promptTable, defaultTable, typesTable = {}, {}, {}
        for i, ticket in ipairs(tickets) do
            promptTable[i] = "🇪🇬Edited by MAHMOUDHERO🇪🇬\n🇪🇬 Egypt mother of the world 🇪🇬\n"..ticket.name
            defaultTable[i] = "🙋اكتب الرقم الذي تريده🙋"
            typesTable[i] = 'number'
        end
        
        inp = gg.prompt(promptTable, defaultTable, nil, typesTable)
        if not inp then
            gg.toast("تم الإلغاء")
            return
        end
    else
        for i = 1, #tickets do
            inp[i] = 0
        end
    end


    local mainAddress = nil
    local isMultiple = (#tickets > 1)
    
    if isMultiple then
        if not cachedValues or not cachedValues.mainPattern then
            if not cacheMainPattern() then
                isMultiple = false
            else
                mainAddress = cachedValues.mainPattern
                local offset12Value = readOffset12(mainAddress)
                if offset12Value == 1 then
                    gg.setValues({{address = mainAddress + 12, value = 2, flags = gg.TYPE_DWORD}})
                end
            end
        else
            mainAddress = cachedValues.mainPattern
            local offset12Value = readOffset12(mainAddress)
            if offset12Value == 1 then
                gg.setValues({{address = mainAddress + 12, value = 2, flags = gg.TYPE_DWORD}})
            end
        end
    end

    for i, ticket in ipairs(tickets) do
        if shouldShowInput then
            gg.sleep(500)
            gg.toast(ticket.name.." العدد هو  "..inp[i])
        end
        
        gg.sleep(100)
        for _, result in ipairs(ticketSystem.secondResults) do
            local mods = {
                {address = result.address + 12, flags = gg.TYPE_DWORD, value = 2},
                {address = result.address + 16, flags = gg.TYPE_DWORD, value = ticket.values[1], freeze = true},
                {address = result.address + 20, flags = gg.TYPE_DWORD, value = ticket.values[2], freeze = true},
                {address = result.address + 24, flags = gg.TYPE_DWORD, value = ticket.values[3], freeze = true},
                {address = result.address + 28, flags = gg.TYPE_DWORD, value = ticket.values[4], freeze = true},
                {address = result.address + 32, flags = gg.TYPE_DWORD, value = ticket.values[5], freeze = true},
                {address = result.address + 36, flags = gg.TYPE_DWORD, value = ticket.values[6], freeze = true},
                {address = result.address + 40, flags = gg.TYPE_QWORD, value = inp[i], freeze = true}              
            }
            gg.setValues(mods)
        end

        gg.sleep(300)
        gg.toast("✅ تم استبدال كود "..ticket.name)
        
        -- التتبع للأكواد المتعددة
        if isMultiple and i < #tickets then
            gg.sleep(500)
            gg.toast("⏳ استلم الهدية 29 للمتابعة للكود التالي ⏳")  
            local waited = false
            local startTime = os.time()
            
            while os.time() - startTime < 30 do
                local currentValue = readOffset12(mainAddress)
                if currentValue == 1 then                 
                    waited = true
                    break
                end
                gg.sleep(500)
            end
            
            if not waited then
                gg.alert("⚠️ انتهى الوقت، يجب استلام الهدية 29 بسرعة ⚠️")
                break
            end
            
            gg.setValues({{
                address = mainAddress + 12,
                value = 2,
                flags = gg.TYPE_DWORD
            }})
        end
    end
    
    
    if #tickets == 1 then
        gg.sleep(3000)
        gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n" ..
                "✨ تم استبدال كود " .. tickets[1].name .. " بنجاح ✨\n\n" ..
                "⚠️ ملاحظة: يجب استلام الهديه رقم 29 لتظهر التغييرات\n\n" ..
                "🇪🇬 Egypt Mother of the World 🇪🇬")
    end
end

-- ============ =============
function readOffset12(address)
    if not address then return nil end
    local result = gg.getValues({{address = address + 12, flags = gg.TYPE_DWORD}})
    if result and #result > 0 then
        return result[1].value
    end
    return nil
end

function applyAllWithTracking(itemList, categoryName)
gg.toast("🕵️‍♂️جاري استبدال جميع أكواد🕵️‍♂️ " .. (categoryName or "العناصر"))
    
if not cachedValues then cachedValues = {} end
if not cacheMainPattern() then
gg.alert("❌ كود البحث الأساسي لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")    return end
    
 if not cachedValues.mainPattern then  return end
local mainAddress = cachedValues.mainPattern
local offset12Value = readOffset12(mainAddress)
    
if offset12Value == 1 then
gg.setValues({{address = mainAddress + 12,value = 2,flags = gg.TYPE_DWORD}})
offset12Value = 2
end

if offset12Value ~= 2 then
gg.toast("⚠️هناك مشكله في قيمه التجميد كود الاستبدال ⚠️")return end
    
local totalItems = #itemList
gg.toast("🕵️‍♂️عدد الاكواد هو 🕵️‍♂️" .. totalItems)
local originalAlert = gg.alert
gg.alert = function() end

for i = 1, totalItems do
local item = itemList[i]
gg.toast("🔄 [" .. i .. "/" .. totalItems .. "] جاري الاستبدال...")
        
if type(item) == "function" then

item() elseif type(item) == "table" and item.values then
applyStatue(item.values, item.name or ("العنصر " .. i), false)else end
        
if i == totalItems then
gg.toast("🕵️‍♂️تم استبدال اخر كود في المجموعة🕵️‍♂️") break end
        
gg.toast("⏳عليك استلام الهديه 29⏳" )
local waited = false
local startTime = os.time()
local timeout = 30
        
        while os.time() - startTime < timeout do
         local currentValue = readOffset12(mainAddress)
         if currentValue == 1 then
         gg.toast("✅تم الاستلام ✅ " .. i)
         waited = true
         break
         end
        gg.sleep(500) end
        
        if not waited then
            gg.alert("⚠️انتهي الوقت يجب استلام الهديه 29 بشكل سريع⚠️" .. i)
            break
        end
        
        
      gg.setValues({{
      address = mainAddress + 12,
       value = 2,
       flags = gg.TYPE_DWORD
        }})
    end
    gg.alert = originalAlert
    gg.sleep(4000) 
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n" ..
"🎉 تم استبدال جميع اكواد " .. categoryName .. " بنجاح! 🎉\n\n" ..
"🇪🇬 Egypt Mother of the World 🇪🇬")
end


--  ⚔️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️⚔️
  --⚔️🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥⚔️
  --  ⚔️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️⚔️
  --⚔️🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥⚔️
-- ============================================================
                       -- دالة تطبيق الصور 
-- ============================================================
function applyImage(imageNumber, imageName)

    if not ticketSystem:init() then return end
    

    for _, result in ipairs(ticketSystem.secondResults) do

        gg.setValues({{address = result.address + 12, flags = 4, value = 2}})
        
        
        gg.setValues({{address = result.address + 16, flags = 4, value = 1635148064}})
        

        local str = tostring(imageNumber)
        for j = 0, #str - 1 do
            gg.setValues({{address = result.address + 20 + j, flags = 1, value = string.byte(str, j + 1)}})
        end

        gg.setValues({{address = result.address + 20 + #str, flags = 1, value = 0}})
        gg.setValues({{address = result.address + 20 + #str + 1, flags = 1, value = 0}})
        gg.setValues({{address = result.address + 20 + #str + 2, flags = 1, value = 0}})
        gg.setValues({{address = result.address + 20 + #str + 3, flags = 1, value = 0}})
        
        
        gg.setValues({
            {address = result.address + 24, flags = 4, value = 0},
            {address = result.address + 28, flags = 4, value = 0},
            {address = result.address + 32, flags = 4, value = 0},
            {address = result.address + 36, flags = 4, value = 0},
            {address = result.address + 40, flags = 8, value = 0},
        })
    end
    
    gg.sleep(500)
    gg.toast("✅ تم استبدال " .. (imageName or "الصورة " .. imageNumber))
end


 
 --اختيار جميع الديكورات
function selectAllDecorations()
lastMenu = selectAllDecorations
    local categories = {    	
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد القطارات            𝄟\n╚═══════════════╝",--1
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد المحطات            𝄟\n╚═══════════════╝",--2
        "╔══════⟬⚜️⟭══════╗\n𝄟           اكواد الميناء               𝄟\n╚═══════════════╝",--3
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد السفن                 𝄟\n╚═══════════════╝",--4
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد الطائرات             𝄟\n╚═══════════════╝",--5
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد المطارات            𝄟\n╚═══════════════╝",--6
        "╔══════⟬⚜️⟭══════╗\n𝄟        اكواد الهليكوبتر             𝄟\n╚═══════════════╝",--7
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد المهابط              𝄟\n╚═══════════════╝",--8
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد الجزر                 𝄟\n╚═══════════════╝",--9
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد الأبقار                𝄟\n╚═══════════════╝",--10
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد الدجاج              𝄟\n╚═══════════════╝",--11
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد الخرفان             𝄟\n╚═══════════════╝",--12
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد الخنازير             𝄟\n╚═══════════════╝",--13
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد اللوحات             𝄟\n╚═══════════════╝",--14
        "╔══════⟬⚜️⟭══════╗\n𝄟    اكواد الرحلة الاستكشافية   𝄟\n╚═══════════════╝",--15
        "╔══════⟬⚜️⟭══════╗\n𝄟        اكواد حدث الدمج          𝄟\n╚═══════════════╝",--16      
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد الإطارات             𝄟\n╚═══════════════╝",--17
        "╔══════⟬⚜️⟭══════╗\n𝄟           اكواد النمط                𝄟\n╚═══════════════╝",--18
        "╔══════⟬⚜️⟭══════╗\n𝄟          اكواد الشارات              𝄟\n╚═══════════════╝",--19
        "╔══════⟬⚜️⟭══════╗\n𝄟        اكواد الملصقات              𝄟\n╚═══════════════╝",--20
        "╔══════⟬⚜️⟭══════╗\n𝄟             اكواد الصور              𝄟\n╚═══════════════╝",--21
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع الاكواد  🟡 𝄟\n╚═══════════════╝",--22
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--23
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--24
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--25
    }
    
    local groups = {
        {name = "القطارات", prefix = "Train"},
        {name = "المحطات", prefix = "Station"},
        {name = "الميناء", prefix = "Port"},
        {name = "السفن", prefix = "Ship"},
        {name = "الطائرات", prefix = "Airplane"},
        {name = "المطارات", prefix = "Airport"},
        {name = "الهليكوبتر", prefix = "Helicopter"},
        {name = "المهابط", prefix = "Helipad"},
        {name = "الجزر", prefix = "Island"},
        {name = "الأبقار", prefix = "Cow"},
        {name = "الدجاج", prefix = "Chicken"},
        {name = "الخرفان", prefix = "Sheep"},
        {name = "الخنازير", prefix = "Pigs"},
        {name = "اللوحات", prefix = "Sign"},
        {name = "الرحلة الاستكشافية", prefix = "Expedition"},
        {name = "حدث الدمج", prefix = "Merge"},       
        {name = "الإطارات", prefix = "Style"},
        {name = "النمط", prefix = "Frame"},
        {name = "الشارات", prefix = "Badge"},
        {name = "الملصقات", prefix = "Emoji"},
        {name = "الصور", prefix = "Pic"}
    }
    
    local choice = gg.multiChoice(categories, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊       ❪ اختر مجموعة الاكواد التي تريدها ❫               𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
    
    if not choice then 

        Mahmoud()
        return 
    end
    
    
    if choice[23] then  
        Mahmoud()
        return
    end
    
    if choice[24] then  
        Home()
        return
    end
    
    if choice[25] then  
        EXIT()
        return
    end
    
    
    local functionsToApply = {}
    local categoryName = ""
    
    
        if choice[22] then
       categoryName = "جميع الاكواد"
        
        for _, group in ipairs(groups) do
        local i = 1
        while true do
        local funcName = group.prefix .. i
        if _G[funcName] then
        table.insert(functionsToApply, _G[funcName])
        i = i + 1
        else
        break 
        end
        end
        end
        else
   
        local selectedGroups = {}
        for i = 1, 21 do
        if choice[i] then
        table.insert(selectedGroups, groups[i])
        end
        end
        
        if #selectedGroups == 0 then
        gg.alert("❌ لم تختار أي مجموعة!")
        return
        end
        categoryName = "المحددة"
        
        for _, group in ipairs(selectedGroups) do
        local i = 1
        while true do
        local funcName = group.prefix .. i
        if _G[funcName] then
        table.insert(functionsToApply, _G[funcName])
        i = i + 1
        else
        break 
        end
        end
        end
        end
    

    if #functionsToApply == 0 then
    return
    end
    
applyAllWithTracking(functionsToApply, categoryName)
end

 
 
 
 
 
 
 
--  ⚔️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️⚔️
  --⚔️🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥⚔️

Detector = gg.getFile():match('[^/]+$')
endtime=load("return os.time{year=2028,month=1,day=10}")()
if(os.time()>endtime) then
gg.alert("🙋جاري اضافه التحديث الجديد عليك الانتظار🙋\n\n📸أو كلم المطور وأرسل صوره له يمكن نايم 📸 ") 
gg.alert('🙋رايح فين خد معاك خمسه جنيه وأرسل الصوره🙋')
os.exit()
end

gg.alert("⚠️تم استبدال قسم الحظر ب اسم قسم متنوعه وإضافة بعض الاكواد ⚠️")


lastMenu = nil
function HOME()
    if isLoggedIn then
        
        if lastMenu then
            return lastMenu()
        else
            return Home()
        end
    end

    local loginChoice = gg.alert(
        "╔═══════════════════╗\n𝄟🤡🤡 MAHMOUDHERO 🤡🤡 𝄟\n╚═══════════════════╝\n\n" ..
        "╔═══════════════════╗\n𝄟🤡للمتابعه اضغط علي كلمه دخول🤡𝄟\n╚═══════════════════╝\n\n" ..
        "╔═══════════════════╗\n𝄟🤡Ⓜ️Ⓜ️Ⓜ️ HERO Ⓜ️Ⓜ️Ⓜ️🤡 𝄟\n╚═══════════════════╝",
        "⟬Ⓜ️دخـــــــــــــــــــولⓂ️⟭",
        "",
        "⟬🤡خـــــــــــــــــــروج🤡⟭"
    )
  
if loginChoice == 1 then
    isLoggedIn = true
    Home()
elseif loginChoice == 3 then
    EXIT()
else
return 
end
end

function Home()
lastMenu = Home
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟       فتح التذكره الذهبيه       𝄟\n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟   زياده المستوي من الزراعة   𝄟\n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟   زياده المستوي من الطائرة   𝄟\n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟تصفير وقت الحيوانات مؤقت 𝄟\n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟  تصفير وقت الزراعة مؤقت   𝄟\n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟تصفير طلب الهليكوبتر مؤقت 𝄟\n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟    ارسل الكروت بدون وقت   𝄟\n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟             زياده الكروت           𝄟\n╚═══════════════╝",--8
    "╔══════⟬⚜️⟭══════╗\n𝄟   ترقيه الأكاديمية الصناعية    𝄟\n╚═══════════════╝",--9
    "╔══════⟬⚜️⟭══════╗\n𝄟      فتح المباني المجتمعيه     𝄟\n╚═══════════════╝",--10
    "╔══════⟬⚜️⟭══════╗\n𝄟 توسيع المدينه بدون اي شي  𝄟\n╚═══════════════╝",--11   
    "╔══════⟬⚜️⟭══════╗\n𝄟   زياده الاعجابات لاي مدينة  𝄟\n╚═══════════════╝",--12
    "╔══════⟬⚜️⟭══════╗\n𝄟   فتح جميع صنديق المصانع  𝄟\n╚═══════════════╝",--13
    "╔══════⟬⚜️⟭══════╗\n𝄟    زيادة عدد صناديق السوق   𝄟\n╚═══════════════╝",--14 
    "╔══════⟬⚜️⟭══════╗\n𝄟🗃️قسم حديقه الحيوانات🗃️ 𝄟\n╚═══════════════╝",--15
    "╔══════⟬⚜️⟭══════╗\n𝄟🗃️ قسم كل اكواد المدينه🗃️ 𝄟\n╚═══════════════╝",--16
    "╔══════⟬⚜️⟭══════╗\n𝄟🕵️‍♂️     قسم عام متنوعه   🕵️‍♂️ 𝄟\n╚═══════════════╝",--17    
    "╔══════⟬⚜️⟭══════╗\n𝄟⏏️خــــــــــــــــــــــــــروج⏏️𝄟\n╚═══════════════╝",--18
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[1]== true then F1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then F2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then F3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then F4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then F5() end -- 👹MAHMOUDHERO👹
if MH[6]== true then F6() end -- 👹MAHMOUDHERO👹
if MH[7]== true then F7() end -- 👹MAHMOUDHERO👹
if MH[8]== true then F8() end -- 👹MAHMOUDHERO👹
if MH[9]== true then F9() end -- 👹MAHMOUDHERO👹
if MH[10]== true then F10() end -- 👹MAHMOUDHERO👹
if MH[11]== true then F11() end -- 👹MAHMOUDHERO👹
if MH[12]== true then F12() end -- 👹MAHMOUDHERO👹
if MH[13]== true then F13() end -- 👹MAHMOUDHERO👹
if MH[14]== true then F14() end -- 👹MAHMOUDHERO👹
if MH[15]== true then F15() end -- 👹MAHMOUDHERO👹
if MH[16]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[17]== true then HeRoBan() end -- 👹MAHMOUDHERO👹
if MH[18]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
 




--قسم الحيوانات 
function F15 ()
lastMenu = F15
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟          حيوانات السفانا             𝄟 \n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟          حيوانات المستنقع          𝄟 \n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟             حيوانات الغابه            𝄟 \n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟            حيوانات الجليد           𝄟 \n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟           حيوانات الادغال           𝄟 \n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟           رجـــــــــــــــــــوع          𝄟 \n╚═══════════════╝",--6  
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== F15 then else
if MH[1]== true then H1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then H2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then H3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then H4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then H5() end -- 👹MAHMOUDHERO👹
if MH[6]== true then Home() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹



----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
function HeRoBan ()
lastMenu = HeRoBan
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟     طلب مساعده في القطار    𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟         زيادة نقاط السباق         𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟       فتح جميع الانجازات        𝄟 \n╚═══════════════╝",--3
    "╔══════⟬⚜️⟭══════╗\n𝄟   فتح جميع عناصر المتحف     𝄟 \n╚═══════════════╝",--4
    "╔══════⟬⚜️⟭══════╗\n𝄟         إظهار جميع الأحداث      𝄟 \n╚═══════════════╝",--5
    "╔══════⟬⚜️⟭══════╗\n𝄟       تجميد الكروت للمساعدة   𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== HeRoBan then else
if MH[1]== true then HH1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then HH2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then HH3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then HH4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then HH5() end -- 👹MAHMOUDHERO👹
if MH[6]== true then HH6() end -- 👹MAHMOUDHERO👹
if MH[7]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[8]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------

--قسم جميع الاكواد
--قسم الاكواد
function Mahmoud ()
lastMenu = Mahmoud
hero = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟               اكواد القسائم         𝄟 \n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟               اكواد السبائك        𝄟 \n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟                اكواد المنجم         𝄟 \n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟                اكواد الشونه         𝄟 \n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟                  اكواد البناء         𝄟 \n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟            اكواد المجوهرات      𝄟 \n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟   اكواد حدث الالوان القديمة  𝄟 \n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟  اكواد حدث الالوان الجديده  𝄟 \n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟         اكواد علف الحيوانات    𝄟 \n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟           اكواد تصفير الوقت     𝄟 \n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟       اكواد رحله استكشافية    𝄟 \n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟اكواد الكاش_الفلوس_الاحداث𝄟 \n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟        اكواد الأكياس للكروت    𝄟 \n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟       اكواد القطار + المحطه    𝄟 \n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟       اكواد الميناء + المركب    𝄟 \n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟        اكواد الطائره + المطار    𝄟 \n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟      اكواد هليكوبتر + مهبط    𝄟 \n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟             اكواد الجزيرة           𝄟 \n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟      اكواد تغير شكل الأبقار      𝄟 \n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟   اكواد تغير شكل الدجاجه     𝄟 \n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟    اكواد تغير شكل الخرفان    𝄟 \n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟    اكواد تغير شكل الخنازير    𝄟 \n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟    اكواد تغير شكل اللافتات    𝄟 \n╚═══════════════╝",--23
"╔══════⟬⚜️⟭══════╗\n𝄟      اكواد ديكورات التماثيل    𝄟 \n╚═══════════════╝",--24
"╔══════⟬⚜️⟭══════╗\n𝄟    اكواد الإطار ملف تعريفي    𝄟 \n╚═══════════════╝",--25
"╔══════⟬⚜️⟭══════╗\n𝄟     اكواد النمط ملف تعريفي   𝄟 \n╚═══════════════╝",--26
"╔══════⟬⚜️⟭══════╗\n𝄟    اكواد الشاره ملف تعريفي   𝄟 \n╚═══════════════╝",--27
"╔══════⟬⚜️⟭══════╗\n𝄟             اكواد الملصقات       𝄟 \n╚═══════════════╝",--28
"╔══════⟬⚜️⟭══════╗\n𝄟                  اكواد الصور       𝄟 \n╚═══════════════╝",--29
"╔══════⟬⚜️⟭══════╗\n𝄟     قسم جميع اكواد الزينه     𝄟 \n╚═══════════════╝",--30
"╔══════⟬⚜️⟭══════╗\n𝄟    🔥تنزيل جميع الاكواد🔥  𝄟 \n╚═══════════════╝",--31
"╔══════⟬⚜️⟭══════╗\n𝄟           رجـــــــــــــــــــوع       𝄟 \n╚═══════════════╝",--32
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if hero== Mahmoud then else
if hero[1]== true then U1() end -- 👹MAHMOUDHERO👹
if hero[2]== true then U2() end -- 👹MAHMOUDHERO👹
if hero[3]== true then U3() end -- 👹MAHMOUDHERO👹
if hero[4]== true then U4() end -- 👹MAHMOUDHERO👹
if hero[5]== true then U5() end -- ??MAHMOUDHERO👹
if hero[6]== true then U6() end -- 👹MAHMOUDHERO👹
if hero[7]== true then U7() end -- 👹MAHMOUDHERO👹
if hero[8]== true then U8() end -- 👹MAHMOUDHERO👹
if hero[9]== true then U9() end -- 👹MAHMOUDHERO👹
if hero[10]== true then U10() end -- 👹MAHMOUDHERO👹
if hero[11]== true then U11() end -- 👹MAHMOUDHERO👹
if hero[12]== true then U12() end -- 👹MAHMOUDHERO👹
if hero[13]== true then U13() end -- 👹MAHMOUDHERO👹
if hero[14]== true then U14() end -- 👹MAHMOUDHERO👹
if hero[15]== true then U15() end -- 👹MAHMOUDHERO👹
if hero[16]== true then U16() end -- 👹MAHMOUDHERO👹
if hero[17]== true then U17() end -- 👹MAHMOUDHERO👹
if hero[18]== true then U18() end -- 👹MAHMOUDHERO👹
if hero[19]== true then U19() end -- 👹MAHMOUDHERO👹
if hero[20]== true then U20() end -- 👹MAHMOUDHERO👹
if hero[21]== true then U21() end -- 👹MAHMOUDHERO👹
if hero[22]== true then U22() end -- 👹MAHMOUDHERO👹
if hero[23]== true then U23() end -- 👹MAHMOUDHERO👹
if hero[24]== true then U24() end -- 👹MAHMOUDHERO👹
if hero[25]== true then U25() end -- 👹MAHMOUDHERO👹
if hero[26]== true then U26() end -- 👹MAHMOUDHERO👹
if hero[27]== true then U27() end -- 👹MAHMOUDHERO👹
if hero[28]== true then U28() end -- 👹MAHMOUDHERO👹
if hero[29]== true then U29() end -- 👹MAHMOUDHERO👹
if hero[30]== true then U30() end -- 👹MAHMOUDHERO👹
if hero[31]== true then selectAllDecorations()  return  end
if hero[32]== true then Home() end
end
HERO = -1
end


function U30 ()
gg.alert("🕵️‍♂️جاري العمل عليها عليك الانتظار حتي يتم الانتهاء هات خمسه جنيه🕵️‍♂️")
end -- 👹MAHMOUDHERO👹

--قسم جميع اكواد الزينه 
function U300 ()
lastMenu = U300
hero = gg.multiChoice({
"╔══════⟬🎈⟭══════╗\n𝄟             بالونات طائرة           𝄟 \n╚═══════════════╝",--1
"╔══════⟬🌊⟭══════╗\n𝄟                زينة مائية             𝄟 \n╚═══════════════╝",--2
"╔══════⟬🌲⟭══════╗\n𝄟             أشجار وأزهار            𝄟 \n╚═══════════════╝",--3
"╔══════⟬🗿⟭══════╗\n𝄟            تماثيل ونوافير           𝄟 \n╚═══════════════╝",--4
"╔══════⟬🎮⟭══════╗\n𝄟              ألعاب ومرح             𝄟 \n╚═══════════════╝",--5
"╔══════⟬❤️⟭══════╗\n𝄟            حب وفلانتين            𝄟 \n╚═══════════════╝",--6
"╔══════⟬🏙️⟭══════╗\n𝄟              زينة المدينة             𝄟 \n╚═══════════════╝",--7
"╔══════⟬❄️⟭══════╗\n𝄟          كريسماس وثلج            𝄟 \n╚═══════════════╝",--8
"╔══════⟬🦁⟭══════╗\n𝄟         حيوانات وحديقة           𝄟 \n╚═══════════════╝",--9
"╔══════⟬🍃⟭══════╗\n𝄟             زينة الطبيعة              𝄟 \n╚═══════════════╝",--10
"╔══════⟬🏛️⟭══════╗\n𝄟             معالم أثرية                𝄟 \n╚═══════════════╝",--11
"╔══════⟬🎃⟭══════╗\n𝄟           هالوين ورعب              𝄟 \n╚═══════════════╝",--12
"╔══════⟬⚓⟭══════╗\n𝄟              ساحل وبحر             𝄟 \n╚═══════════════╝",--13
"╔══════⟬🚧⟭══════╗\n𝄟            سياج وجسور             𝄟 \n╚═══════════════╝",--14
"╔══════⟬🐇⟭══════╗\n𝄟              عيد الفصح              𝄟 \n╚═══════════════╝",--15
"╔══════⟬🎉⟭══════╗\n𝄟            زينة الأحداث             𝄟 \n╚═══════════════╝",--16
"╔══════⟬📦⟭══════╗\n𝄟              كل الزينات              𝄟 \n╚═══════════════╝",--17
"╔══════⟬💾⟭══════╗\n𝄟              حفظ الكل               𝄟 \n╚═══════════════╝",--18
"╔══════⟬🔙⟭══════╗\n𝄟      رجوع      𝄟 \n╚═══════════════╝",--19
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

if hero== U300 then else
if hero[1]== true then AirDec() end
if hero[2]== true then WaterDec() end
if hero[3]== true then Trees() end
if hero[4]== true then Statues() end
if hero[5]== true then Games() end
if hero[6]== true then Love() end
if hero[7]== true then City() end
if hero[8]== true then Christmas() end
if hero[9]== true then Animals() end
if hero[10]== true then Nature() end
if hero[11]== true then Ancient() end
if hero[12]== true then Halloween() end
if hero[13]== true then Beach() end
if hero[14]== true then Fences() end
if hero[15]== true then Easter() end
if hero[16]== true then Events() end
if hero[17]== true then U30() end
if hero[18]== true then selectAllDecorations() return end
if hero[19]== true then Home() end
end
HERO = -1
end


--اكواد بالون طائرة من قسم اكواد الزينه 
function AirDec()
    lastMenu = AirDec
    MH = gg.multiChoice({
        "╔══════⟬🎈⟭══════╗\n𝄟              بالون الببغاء            𝄟\n╚═══════════════╝",--1
        "╔══════⟬🎈⟭══════╗\n𝄟           بالون السلحفاة           𝄟\n╚═══════════════╝",--2
        "╔══════⟬🎈⟭══════╗\n𝄟         بالون الأخطبوط           𝄟\n╚═══════════════╝",--3
        "╔══════⟬🎈⟭══════╗\n𝄟             بالون البطريق          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🎈⟭══════╗\n𝄟             بالون الدجاجة         𝄟\n╚═══════════════╝",--5
        "╔══════⟬🎈⟭══════╗\n𝄟               بالون الخنزير         𝄟\n╚═══════════════╝",--6
        "╔══════⟬🎈⟭══════╗\n𝄟              بالون الخروف         𝄟\n╚═══════════════╝",--7
        "╔══════⟬🎈⟭══════╗\n𝄟                 بالون البقرة         𝄟\n╚═══════════════╝",--8
        "╔══════⟬🎈⟭══════╗\n𝄟                  بالون الفيل         𝄟\n╚═══════════════╝",--9
        "╔══════⟬🎈⟭══════╗\n𝄟                بالون السمكة        𝄟\n╚═══════════════╝",--10
        "╔══════⟬🎈⟭══════╗\n𝄟               بالون الفراشة         𝄟\n╚═══════════════╝",--11
        "╔══════⟬🎈⟭══════╗\n𝄟           الحوت المطاطي         𝄟\n╚═══════════════╝",--12
        "╔══════⟬🎈⟭══════╗\n𝄟               بالون البطة            𝄟\n╚═══════════════╝",--13
        "╔══════⟬🎈⟭══════╗\n𝄟           الطائرة المطاطية        𝄟\n╚═══════════════╝",--14
        "╔══════⟬🎈⟭══════╗\n𝄟               بالون رقم 3           𝄟\n╚═══════════════╝",--15
        "╔══════⟬🎈⟭══════╗\n𝄟               المنزل الطائر          𝄟\n╚═══════════════╝",--16
        "╔══════⟬🎈⟭══════╗\n𝄟               بالون الكلب            𝄟\n╚═══════════════╝",--17
        "╔══════⟬??⟭══════╗\n𝄟            الدمية الراقصة          𝄟\n╚═══════════════╝",--18
        "╔══════⟬🎈⟭══════╗\n𝄟            قنديل مطاطي           𝄟\n╚═══════════════╝",--19
        "╔══════⟬🎈⟭══════╗\n𝄟              قوس البالون            𝄟\n╚═══════════════╝",--20
        "╔══════⟬🎈⟭══════╗\n𝄟              منطاد القبعة            𝄟\n╚═══════════════╝",--21
        "╔══════⟬🎈⟭══════╗\n𝄟              رائدة الفضاء            𝄟\n╚═══════════════╝",--22
        "╔══════⟬🎈⟭══════╗\n𝄟                  منطاد                 𝄟\n╚═══════════════╝",--23
        "╔══════⟬🎈⟭══════╗\n𝄟             منطاد الخنزير           𝄟\n╚═══════════════╝",--24
        "╔══════⟬🎈⟭══════╗\n𝄟🟡  اختيار جميع الزينات  🟡𝄟\n╚═══════════════╝",--25
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣   العوده لقائمة الزينه  🟣𝄟\n╚═══════════════╝",--26
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟\n╚═══════════════╝",--27
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟\n╚═══════════════╝",--28
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟\n╚═══════════════╝",--29
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 24
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["AirDec"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["AirDec"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "زينه طائرة")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end
  
  
 -- اكواد زينه مائه من قسم اكواد الزينه 
    function WaterDec()
    lastMenu = WaterDec
    MH = gg.multiChoice({
        "╔══════⟬🌊⟭══════╗\n𝄟             الجسر الأحمر           𝄟\n╚═══════════════╝",--1
        "╔══════⟬🌊⟭══════╗\n𝄟              طاحونة مائية         𝄟\n╚═══════════════╝",--2
        "╔══════⟬🌊⟭══════╗\n𝄟               معبد الأعماق          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🌊⟭══════╗\n𝄟               سيف ف الحجر       𝄟\n╚═══════════════╝",--4
        "╔══════⟬🌊⟭══════╗\n𝄟               البرج المغمور          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🌊⟭══════╗\n𝄟              حانة القراصنة         𝄟\n╚═══════════════╝",--6
        "╔══════⟬🌊⟭══════╗\n𝄟             سفينة أوديسيوس    𝄟\n╚═══════════════╝",--7
        "╔══════⟬🌊⟭══════╗\n𝄟              طائرة برمائية          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🌊⟭══════╗\n𝄟           لعبة جهاز الطيران       𝄟\n╚═══════════════╝",--9
        "╔══════⟬🌊⟭══════╗\n𝄟                يخت عالق            𝄟\n╚═══════════════╝",--10
        "╔══════⟬🌊⟭══════╗\n𝄟               منزل الصياد           𝄟\n╚═══════════════╝",--11
        "╔══════⟬🌊⟭══════╗\n𝄟             سفينة القراصنة        𝄟\n╚═══════════════╝",--12
        "╔══════⟬🌊⟭══════╗\n𝄟              قارب مع أزهار         𝄟\n╚═══════════════╝",--13
        "╔══════⟬🌊⟭══════╗\n𝄟               قرية الغابة             𝄟\n╚═══════════════╝",--14
        "╔══════⟬🌊⟭══════╗\n𝄟               حورية البحر          𝄟\n╚═══════════════╝",--15
        "╔══════⟬🌊⟭══════╗\n𝄟           الزنبق المائي الأحمر    𝄟\n╚═══════════════╝",--16
        "╔══════⟬🌊⟭══════╗\n𝄟         زهرة زنبق مائية وردي  𝄟\n╚═══════════════╝",--17
        "╔══════⟬🌊⟭══════╗\n𝄟                  الطوف               𝄟\n╚═══════════════╝",--18
        "╔══════⟬🌊⟭══════╗\n𝄟               قارب هوائي           𝄟\n╚═══════════════╝",--19
        "╔══════⟬🌊⟭══════╗\n𝄟                  عطلة                 𝄟\n╚═══════════════╝",--20
        "╔══════⟬🌊⟭══════╗\n𝄟                جسر خشبي          𝄟\n╚═══════════════╝",--21
        "╔══════⟬🌊⟭══════╗\n𝄟                  مرسى                𝄟\n╚═══════════════╝",--22
        "╔══════⟬🌊⟭══════╗\n𝄟                جسر حجري          𝄟\n╚═══════════════╝",--23
        "╔══════⟬🌊⟭══════╗\n𝄟                   يخت                 𝄟\n╚═══════════════╝",--24
        "╔══════⟬🌊⟭══════╗\n𝄟           جسر البوابة الذهبية    𝄟\n╚═══════════════╝",--25
        "╔══════⟬🌊⟭══════╗\n𝄟              سحر السينما           𝄟\n╚═══════════════╝",--26
        "╔══════⟬🌊⟭══════╗\n𝄟             الفوانيس الطافية      𝄟\n╚═══════════════╝",--27
        "╔══════⟬🌊⟭══════╗\n𝄟               جسر فينيسي         𝄟\n╚═══════════════╝",--28
        "╔══════⟬🌊⟭══════╗\n𝄟               مخيم عائم             𝄟\n╚═══════════════╝",--29
        "╔══════⟬🌊⟭══════╗\n𝄟              الجسر الزجاجي       𝄟\n╚═══════════════╝",--30
        "╔══════⟬🌊⟭══════╗\n𝄟             المدينة الغارقة          𝄟\n╚═══════════════╝",--31
        "╔══════⟬🌊⟭══════╗\n𝄟               يخت متعة             𝄟\n╚═══════════════╝",--32
        "╔══════⟬🌊⟭══════╗\n𝄟             المحطة البحرية        𝄟\n╚═══════════════╝",--33
        "╔══════⟬🌊⟭══════╗\n𝄟              بوابات البحر            𝄟\n╚═══════════════╝",--34
        "╔══════⟬🌊⟭══════╗\n𝄟                   قارب                 𝄟\n╚═══════════════╝",--35
        "╔══════⟬🌊⟭══════╗\n𝄟             الفندق الشراعي         𝄟\n╚═══════════════╝",--36
        "╔══════⟬🌊⟭══════╗\n𝄟               قارب صيد              𝄟\n╚═══════════════╝",--37
        "╔══════⟬🌊⟭══════╗\n𝄟             الشعب المرجانية       𝄟\n╚═══════════════╝",--38
        "╔══════⟬🌊⟭══════╗\n𝄟               جنية الماء              𝄟\n╚═══════════════╝",--39
        "╔══════⟬🌊⟭══════╗\n𝄟             البوابة الجليدية        𝄟\n╚═══════════════╝",--40
        "╔══════⟬🌊⟭══════╗\n𝄟               فيلا مائية              𝄟\n╚═══════════════╝",--41
        "╔══════⟬🌊⟭══════╗\n𝄟             السفينة القديمة        𝄟\n╚═══════════════╝",--42
        "╔══════⟬🌊⟭══════╗\n𝄟              قارب المتعة            𝄟\n╚═══════════════╝",--43
        "╔══════⟬🌊⟭══════╗\n𝄟             قارب الجندول          𝄟\n╚═══════════════╝",--44
        "╔══════⟬🌊⟭══════╗\n𝄟              زلاقة مائية             𝄟\n╚═══════════════╝",--45
        "╔══════⟬🌊⟭══════╗\n𝄟                    زلاجة               𝄟\n╚═══════════════╝",--46
        "╔══════⟬🌊⟭══════╗\n𝄟            سوق رصيف الصيد    𝄟\n╚═══════════════╝",--47
        "╔══════⟬🌊⟭══════╗\n𝄟             حديقة مرجانية        𝄟\n╚═══════════════╝",--48
        "╔══════⟬🌊⟭══════╗\n𝄟                زيارة الدلافين        𝄟\n╚═══════════════╝",--49
        "╔══════⟬🌊⟭══════╗\n𝄟                   الغواصة             𝄟\n╚═══════════════╝",--50
        "╔══════⟬🌊⟭══════╗\n𝄟        مستكشف اعماق البحار    𝄟\n╚═══════════════╝",--51
        "╔══════⟬🌊⟭══════╗\n𝄟              جسر الحلوى            𝄟\n╚═══════════════╝",--52
        "╔══════⟬🌊⟭══════╗\n𝄟            حديقة مائية قطبية    𝄟\n╚═══════════════╝",--53
        "╔══════⟬🌊⟭══════╗\n𝄟                الغواصون              𝄟\n╚═══════════════╝",--54
        "╔══════⟬🌊⟭══════╗\n𝄟         فندق في أطلانتس        𝄟\n╚═══════════════╝",--55
        "╔══════⟬🌊⟭══════╗\n𝄟       رمح ثلاثي أطلنطي         𝄟\n╚═══════════════╝",--56
        "╔══════⟬🌊⟭══════╗\n𝄟              كسارة الثلج             𝄟\n╚═══════════════╝",--57
        "╔══════⟬🌊⟭══════╗\n𝄟                  نيسي                 𝄟\n╚═══════════════╝",--58
        "╔══════⟬🌊⟭══════╗\n𝄟             سفينة مسكونة         𝄟\n╚═══════════════╝",--59
        "╔══════⟬🌊⟭══════╗\n𝄟       بيت من طابق واحد        𝄟\n╚═══════════════╝",--60
        "╔══════⟬🎈⟭══════╗\n𝄟🟡  اختيار جميع الزينات 🟡𝄟\n╚═══════════════╝",--61
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣   العوده لقائمة الزينه  🟣𝄟\n╚═══════════════╝",--62
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟\n╚═══════════════╝",--63
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟\n╚═══════════════╝",--64
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟\n╚═══════════════╝",--65
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 60
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["WaterDec"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["WaterDec"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "زينه مائيه")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end


-- 🌲 أشجار وأزهار
function Trees()
    lastMenu = Trees
    MH = gg.multiChoice({
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة تفاح          𝄟\n╚═══════════════╝",--1
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة نخيل          𝄟\n╚═══════════════╝",--2
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة أرز          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة تنوب          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة جزر          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة سكر          𝄟\n╚═══════════════╝",--6
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة توت          𝄟\n╚═══════════════╝",--7
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة سلة          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة ضوء          𝄟\n╚═══════════════╝",--9
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة مورقة          𝄟\n╚═══════════════╝",--10
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة مزهرة          𝄟\n╚═══════════════╝",--11
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة ساقطة          𝄟\n╚═══════════════╝",--12
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة قابلة للنفخ          𝄟\n╚═══════════════╝",--13
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة عيد الفصح          𝄟\n╚═══════════════╝",--14
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة الحصاد          𝄟\n╚═══════════════╝",--15
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة المصباح          𝄟\n╚═══════════════╝",--16
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة بروكلي          𝄟\n╚═══════════════╝",--17
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة صنوبر          𝄟\n╚═══════════════╝",--18
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة سكوية          𝄟\n╚═══════════════╝",--19
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة بونسيانا          𝄟\n╚═══════════════╝",--20
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة سنط          𝄟\n╚═══════════════╝",--21
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة أرجواني          𝄟\n╚═══════════════╝",--22
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة وستريا          𝄟\n╚═══════════════╝",--23
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة عنكبوت          𝄟\n╚═══════════════╝",--24
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة شبكة          𝄟\n╚═══════════════╝",--25
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة باوباب          𝄟\n╚═══════════════╝",--26
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة تزيين          𝄟\n╚═══════════════╝",--27
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة زينة          𝄟\n╚═══════════════╝",--28
        "╔══════⟬🌲⟭══════╗\n𝄟          شجيرة زينة          𝄟\n╚═══════════════╝",--29
        "╔══════⟬🌲⟭══════╗\n𝄟          شرفة          𝄟\n╚═══════════════╝",--30
        "╔══════⟬🌲⟭══════╗\n𝄟          بيت الشجرة          𝄟\n╚═══════════════╝",--31
        "╔══════⟬🌲⟭══════╗\n𝄟          منزل طائر          𝄟\n╚═══════════════╝",--32
        "╔══════⟬🌲⟭══════╗\n𝄟          عربة زهور          𝄟\n╚═══════════════╝",--33
        "╔══════⟬🌲⟭══════╗\n𝄟          قوس أزهار          𝄟\n╚═══════════════╝",--34
        "╔══════⟬🌲⟭══════╗\n𝄟          مشتل أزهار          𝄟\n╚═══════════════╝",--35
        "╔══════⟬🌲⟭══════╗\n𝄟          حديقة أزهار          𝄟\n╚═══════════════╝",--36
        "╔══════⟬🌲⟭══════╗\n𝄟          حقل زهور          𝄟\n╚═══════════════╝",--37
        "╔══════⟬🌲⟭══════╗\n𝄟          أزهار برية          𝄟\n╚═══════════════╝",--38
        "╔══════⟬🌲⟭══════╗\n𝄟          أزهار الكرز          𝄟\n╚═══════════════╝",--39
        "╔══════⟬🌲⟭══════╗\n𝄟          ورود حمراء          𝄟\n╚═══════════════╝",--40
        "╔══════⟬🌲⟭══════╗\n𝄟          ورود صفراء          𝄟\n╚═══════════════╝",--41
        "╔══════⟬🌲⟭══════╗\n𝄟          دوار الشمس          𝄟\n╚═══════════════╝",--42
        "╔══════⟬🌲⟭══════╗\n𝄟          جربارة          𝄟\n╚═══════════════╝",--43
        "╔══════⟬🌲⟭══════╗\n𝄟          سوسنيات          𝄟\n╚═══════════════╝",--44
        "╔══════⟬🌲⟭══════╗\n𝄟          خشخاش          𝄟\n╚═══════════════╝",--45
        "╔══════⟬🌲⟭══════╗\n𝄟          قزحية          𝄟\n╚═══════════════╝",--46
        "╔══════⟬🌲⟭══════╗\n𝄟          نرجسي          𝄟\n╚═══════════════╝",--47
        "╔══════⟬🌲⟭══════╗\n𝄟          وردة خيالية          𝄟\n╚═══════════════╝",--48
        "╔══════⟬🌲⟭══════╗\n𝄟          مزهرية أزهار          𝄟\n╚═══════════════╝",--49
        "╔══════⟬🌲⟭══════╗\n𝄟          لوحة زهور          𝄟\n╚═══════════════╝",--50
        "╔══════⟬🌲⟭══════╗\n𝄟          تشذيب قلعة          𝄟\n╚═══════════════╝",--51
        "╔══════⟬🌲⟭══════╗\n𝄟          تشذيب طير          𝄟\n╚═══════════════╝",--52
        "╔══════⟬🌲⟭══════╗\n𝄟          تشذيب دولفين          𝄟\n╚═══════════════╝",--53
        "╔══════⟬🌲⟭══════╗\n𝄟          تشذيب طاووس          𝄟\n╚═══════════════╝",--54
        "╔══════⟬🌲⟭══════╗\n𝄟          تشذيب سلحفاة          𝄟\n╚═══════════════╝",--55
        "╔══════⟬🌲⟭══════╗\n𝄟          تشذيب فيل          𝄟\n╚═══════════════╝",--56
        "╔══════⟬🌲⟭══════╗\n𝄟          نبات العدينة          𝄟\n╚═══════════════╝",--57
        "╔══════⟬🌲⟭══════╗\n𝄟          نبات صفصاف          𝄟\n╚═══════════════╝",--58
        "╔══════⟬🌲⟭══════╗\n𝄟          صبار          𝄟\n╚═══════════════╝",--59
        "╔══════⟬🌲⟭══════╗\n𝄟          تمثال زرافة          𝄟\n╚═══════════════╝",--60
        "╔══════⟬🌲⟭══════╗\n𝄟          تمثال غوريلا          𝄟\n╚═══════════════╝",--61
        "╔══════⟬🌲⟭══════╗\n𝄟          تمثال النصر          𝄟\n╚═══════════════╝",--62
        "╔══════⟬🌲⟭══════╗\n𝄟          نافورة الحياة          𝄟\n╚═══════════════╝",--63
        "╔══════⟬🌲⟭══════╗\n𝄟          نافورة مشتل          𝄟\n╚═══════════════╝",--64
        "╔══════⟬🌲⟭══════╗\n𝄟          الشراع الذهبي          𝄟\n╚═══════════════╝",--65
        "╔══════⟬🌲⟭══════╗\n𝄟          منتزه بري          𝄟\n╚═══════════════╝",--66
        "╔══════⟬🌲⟭══════╗\n𝄟          مشبك غسيل فني          𝄟\n╚═══════════════╝",--67
        "╔══════⟬🌲⟭══════╗\n𝄟          حديقة فضاء          𝄟\n╚═══════════════╝",--68
        "╔══════⟬🌲⟭══════╗\n𝄟          أعجوبة طبيعية          𝄟\n╚═══════════════╝",--69
        "╔══════⟬🌲⟭══════╗\n𝄟          خليج صغير          𝄟\n╚═══════════════╝",--70
        "╔══════⟬🌲⟭══════╗\n𝄟          باقة بالونات          𝄟\n╚═══════════════╝",--71
        "╔══════⟬🌲⟭══════╗\n𝄟          أرنب المنتزه          𝄟\n╚═══════════════╝",--72
        "╔══════⟬🌲⟭══════╗\n𝄟          معدات شاطئ          𝄟\n╚═══════════════╝",--73
        "╔══════⟬🌲⟭══════╗\n𝄟          عمود إنارة زهري          𝄟\n╚═══════════════╝",--74
        "╔══════⟬🌲⟭══════╗\n𝄟          مشتل سيارة          𝄟\n╚═══════════════╝",--75
        "╔══════⟬🌲⟭══════╗\n𝄟          طاووس زهري          𝄟\n╚═══════════════╝",--76
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرتا أرز          𝄟\n╚═══════════════╝",--77
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة تنوب 1          𝄟\n╚═══════════════╝",--78
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة تنوب 2          𝄟\n╚═══════════════╝",--79
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة مورقة 1          𝄟\n╚═══════════════╝",--80
        "╔══════⟬🌲⟭══════╗\n𝄟          شجرة مورقة 2          𝄟\n╚═══════════════╝",--81
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--82
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--83
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--84
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--85
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--86
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 81
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Tree"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Tree"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "أشجار وأزهار")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end
    
 -- 🗿 تماثيل ونفوره
function Statues()
    lastMenu = Statues
    MH = gg.multiChoice({
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال أسد          𝄟\n╚═══════════════╝",--1
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال فيل          𝄟\n╚═══════════════╝",--2
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال زرافة          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال باندا          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال بطريق          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال تمساح          𝄟\n╚═══════════════╝",--6
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال كوالا          𝄟\n╚═══════════════╝",--7
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال بجعة          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال فلامينجو          𝄟\n╚═══════════════╝",--9
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال حمار          𝄟\n╚═══════════════╝",--10
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال فقمة          𝄟\n╚═══════════════╝",--11
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال نمر بحر          𝄟\n╚═══════════════╝",--12
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال قرد          𝄟\n╚═══════════════╝",--13
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال غوريلا          𝄟\n╚═══════════════╝",--14
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال جعران          𝄟\n╚═══════════════╝",--15
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال ثور          𝄟\n╚═══════════════╝",--16
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال ملك          𝄟\n╚═══════════════╝",--17
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال قائد          𝄟\n╚═══════════════╝",--18
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال عمدة          𝄟\n╚═══════════════╝",--19
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال فرعون          𝄟\n╚═══════════════╝",--20
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال شمس          𝄟\n╚═══════════════╝",--21
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال مدينة          𝄟\n╚═══════════════╝",--22
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال مخرج          𝄟\n╚═══════════════╝",--23
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال محبين          𝄟\n╚═══════════════╝",--24
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال طاووس          𝄟\n╚═══════════════╝",--25
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال بوسيدون          𝄟\n╚═══════════════╝",--26
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال قديم          𝄟\n╚═══════════════╝",--27
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال جليدي          𝄟\n╚═══════════════╝",--28
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال زنجبيل          𝄟\n╚═══════════════╝",--29
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال دب          𝄟\n╚═══════════════╝",--30
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال وحيد قرن          𝄟\n╚═══════════════╝",--31
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال حامل الشعلة          𝄟\n╚═══════════════╝",--32
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال موجة ثلج          𝄟\n╚═══════════════╝",--33
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال الثروات          𝄟\n╚═══════════════╝",--34
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال الجبابرة          𝄟\n╚═══════════════╝",--35
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال بطل العالم          𝄟\n╚═══════════════╝",--36
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال فارس          𝄟\n╚═══════════════╝",--37
        "╔══════⟬🗿⟭══════╗\n𝄟          تمثال الراكب          𝄟\n╚═══════════════╝",--38
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة كلاسيك          𝄟\n╚═══════════════╝",--39
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة عصرية          𝄟\n╚═══════════════╝",--40
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة حديثة          𝄟\n╚═══════════════╝",--41
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة غرام          𝄟\n╚═══════════════╝",--42
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة حب          𝄟\n╚═══════════════╝",--43
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة أصدقاء          𝄟\n╚═══════════════╝",--44
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة أنغام          𝄟\n╚═══════════════╝",--45
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة فيلم          𝄟\n╚═══════════════╝",--46
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة شلال          𝄟\n╚═══════════════╝",--47
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة حوت          𝄟\n╚═══════════════╝",--48
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة شهرة          𝄟\n╚═══════════════╝",--49
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة جنية          𝄟\n╚═══════════════╝",--50
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة تفاعلية          𝄟\n╚═══════════════╝",--51
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة راقصة          𝄟\n╚═══════════════╝",--52
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة عيد الفصح          𝄟\n╚═══════════════╝",--53
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة الحياة          𝄟\n╚═══════════════╝",--54
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة شوكولاتة          𝄟\n╚═══════════════╝",--55
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة حفل شاي          𝄟\n╚═══════════════╝",--56
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة قياسي          𝄟\n╚═══════════════╝",--57
        "╔══════⟬🗿⟭══════╗\n𝄟          نافورة مشؤومة          𝄟\n╚═══════════════╝",--58
        "╔══════⟬🗿⟭══════╗\n𝄟          بركة إوز          𝄟\n╚═══════════════╝",--59
        "╔══════⟬🗿⟭══════╗\n𝄟          بركة سمك          𝄟\n╚═══════════════╝",--60
        "╔══════⟬🗿⟭══════╗\n𝄟          مسلة حجرية          𝄟\n╚═══════════════╝",--61
        "╔══════⟬🗿⟭══════╗\n𝄟          كرة حجرية          𝄟\n╚═══════════════╝",--62
        "╔══════⟬🗿⟭══════╗\n𝄟          درج لا نهاية          𝄟\n╚═══════════════╝",--63
        "╔══════⟬🗿⟭══════╗\n𝄟          قاهر البحار          𝄟\n╚═══════════════╝",--64
        "╔══════⟬🗿⟭══════╗\n𝄟          دليل البحر          𝄟\n╚═══════════════╝",--65
        "╔══════⟬🗿⟭══════╗\n𝄟          سيد الفاكهة          𝄟\n╚═══════════════╝",--66
        "╔══════⟬🗿⟭══════╗\n𝄟          حارس الثروة          𝄟\n╚═══════════════╝",--67
        "╔══════⟬🗿⟭══════╗\n𝄟          حارس اللفائف          𝄟\n╚═══════════════╝",--68
        "╔══════⟬🗿⟭══════╗\n𝄟          مصباح سحري          𝄟\n╚═══════════════╝",--69
        "╔══════⟬🗿⟭══════╗\n𝄟          صنبور سحري          𝄟\n╚═══════════════╝",--70
        "╔══════⟬🗿⟭══════╗\n𝄟          رمز العام الجديد          𝄟\n╚═══════════════╝",--71
        "╔══════⟬🗿⟭══════╗\n𝄟          صائدة أشباح          𝄟\n╚═══════════════╝",--72
        "╔══════⟬🗿⟭══════╗\n𝄟          قراصنة          𝄟\n╚═══════════════╝",--73
        "╔══════⟬🗿⟭══════╗\n𝄟          خيول عربية          𝄟\n╚═══════════════╝",--74
        "╔══════⟬🗿⟭══════╗\n𝄟          الثلاثي الرائع          𝄟\n╚═══════════════╝",--75
        "╔══════⟬🗿⟭══════╗\n𝄟          رامي القرص          𝄟\n╚═══════════════╝",--76
        "╔══════⟬🗿⟭══════╗\n𝄟          كلب أصفر          𝄟\n╚═══════════════╝",--77
        "╔══════⟬🗿⟭══════╗\n𝄟          تماثيل حديقة          𝄟\n╚═══════════════╝",--78
        "╔══════⟬🗿⟭══════╗\n𝄟          مصمم طائرات          𝄟\n╚═══════════════╝",--79
        "╔══════⟬🗿⟭══════╗\n𝄟          عالم وراثة          𝄟\n╚═══════════════╝",--80
        "╔══════⟬🗿⟭══════╗\n𝄟          كيميائي          𝄟\n╚═══════════════╝",--81
        "╔══════⟬🗿⟭══════╗\n𝄟          مفكر          𝄟\n╚═══════════════╝",--82
        "╔══════⟬🗿⟭══════╗\n𝄟          كاتب          𝄟\n╚═══════════════╝",--83
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--84
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--85
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--86
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--87
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--88
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 ?? 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 83
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Statue"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Statue"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "تماثيل ونوافير")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end   
    
    
    -- 🎮 ألعاب ومرح
function Games()
    lastMenu = Games
    MH = gg.multiChoice({
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب كرة          𝄟\n╚═══════════════╝",--1
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب تنس          𝄟\n╚═══════════════╝",--2
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب بيسبول          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب كرة سلة          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب هوكي          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب رجبي          𝄟\n╚═══════════════╝",--6
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب تدريب          𝄟\n╚═══════════════╝",--7
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب أطفال          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب قراصنة          𝄟\n╚═══════════════╝",--9
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب رعاة البقر          𝄟\n╚═══════════════╝",--10
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب جزيرة الكنز          𝄟\n╚═══════════════╝",--11
        "╔══════⟬🎮⟭══════╗\n𝄟          ملعب الغرب          𝄟\n╚═══════════════╝",--12
        "╔══════⟬🎮⟭══════╗\n𝄟          أرجوحة          𝄟\n╚═══════════════╝",--13
        "╔══════⟬🎮⟭══════╗\n𝄟          أرجوحة أطفال          𝄟\n╚═══════════════╝",--14
        "╔══════⟬🎮⟭══════╗\n𝄟          أرجوحة زهرية          𝄟\n╚═══════════════╝",--15
        "╔══════⟬🎮⟭══════╗\n𝄟          أرجوحة شاطئ          𝄟\n╚═══════════════╝",--16
        "╔══════⟬🎮⟭══════╗\n𝄟          أرجوحة عيد الفصح          𝄟\n╚═══════════════╝",--17
        "╔══════⟬🎮⟭══════╗\n𝄟          أرجوحة دوارة          𝄟\n╚═══════════════╝",--18
        "╔══════⟬🎮⟭══════╗\n𝄟          أرجوحة أفيال          𝄟\n╚═══════════════╝",--19
        "╔══════⟬🎮⟭══════╗\n𝄟          أرجوحة نقانق          𝄟\n╚═══════════════╝",--20
        "╔══════⟬🎮⟭══════╗\n𝄟          أرجوحة سماوية          𝄟\n╚═══════════════╝",--21
        "╔══════⟬🎮⟭══════╗\n𝄟          ترامبولين          𝄟\n╚═══════════════╝",--22
        "╔══════⟬🎮⟭══════╗\n𝄟          ترامبولين أسد          𝄟\n╚═══════════════╝",--23
        "╔══════⟬🎮⟭══════╗\n𝄟          ترامبولين هلامي          𝄟\n╚═══════════════╝",--24
        "╔══════⟬🎮⟭══════╗\n𝄟          ترامبولين حيوانات          𝄟\n╚═══════════════╝",--25
        "╔══════⟬🎮⟭══════╗\n𝄟          ترامبولين هليكوبتر          𝄟\n╚═══════════════╝",--26
        "╔══════⟬🎮⟭══════╗\n𝄟          قلعة نطاطة          𝄟\n╚═══════════════╝",--27
        "╔══════⟬🎮⟭══════╗\n𝄟          قلعة مطاطية          𝄟\n╚═══════════════╝",--28
        "╔══════⟬🎮⟭══════╗\n𝄟          قلعة حلوى          𝄟\n╚═══════════════╝",--29
        "╔══════⟬🎮⟭══════╗\n𝄟          عجلة دوارة          𝄟\n╚═══════════════╝",--30
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة دوارة          𝄟\n╚═══════════════╝",--31
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة قطار          𝄟\n╚═══════════════╝",--32
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة قارب          𝄟\n╚═══════════════╝",--33
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة بينبول          𝄟\n╚═══════════════╝",--34
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة صدفة          𝄟\n╚═══════════════╝",--35
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة رمي حلقات          𝄟\n╚═══════════════╝",--36
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة رماية          𝄟\n╚═══════════════╝",--37
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة سيارات          𝄟\n╚═══════════════╝",--38
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة شطرنج          𝄟\n╚═══════════════╝",--39
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة طائرات          𝄟\n╚═══════════════╝",--40
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة أحصنة          𝄟\n╚═══════════════╝",--41
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة أخطبوط          𝄟\n╚═══════════════╝",--42
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة قوس قزح          𝄟\n╚═══════════════╝",--43
        "╔══════⟬🎮⟭══════╗\n𝄟          لعبة موجة          𝄟\n╚═══════════════╝",--44
        "╔══════⟬🎮⟭══════╗\n𝄟          ركوب بحر          𝄟\n╚═══════════════╝",--45
        "╔══════⟬🎮⟭══════╗\n𝄟          ركوب أمواج          𝄟\n╚═══════════════╝",--46
        "╔══════⟬🎮⟭══════╗\n𝄟          مبارزة إبحار          𝄟\n╚═══════════════╝",--47
        "╔══════⟬🎮⟭══════╗\n𝄟          سباق أكياس          𝄟\n╚═══════════════╝",--48
        "╔══════⟬🎮⟭══════╗\n𝄟          سباق طائرات          𝄟\n╚═══════════════╝",--49
        "╔══════⟬🎮⟭══════╗\n𝄟          سباق شاحنات          𝄟\n╚═══════════════╝",--50
        "╔══════⟬🎮⟭══════╗\n𝄟          سباق دراجات          𝄟\n╚═══════════════╝",--51
        "╔══════⟬🎮⟭══════╗\n𝄟          سباق فرع عسل          𝄟\n╚═══════════════╝",--52
        "╔══════⟬🎮⟭══════╗\n𝄟          مسابقة رقص          𝄟\n╚═══════════════╝",--53
        "╔══════⟬🎮⟭══════╗\n𝄟          مسابقة ثلاثية          𝄟\n╚═══════════════╝",--54
        "╔══════⟬🎮⟭══════╗\n𝄟          ممارسة بيسبول          𝄟\n╚═══════════════╝",--55
        "╔══════⟬🎮⟭══════╗\n𝄟          محاكي طيران          𝄟\n╚═══════════════╝",--56
        "╔══════⟬🎮⟭══════╗\n𝄟          طائرة تجريبية          𝄟\n╚═══════════════╝",--57
        "╔══════⟬🎮⟭══════╗\n𝄟          طائرة بخارية          𝄟\n╚═══════════════╝",--58
        "╔══════⟬🎮⟭══════╗\n𝄟          طائرة شراعية          𝄟\n╚═══════════════╝",--59
        "╔══════⟬🎮⟭══════╗\n𝄟          طائرة ورقية          𝄟\n╚═══════════════╝",--60
        "╔══════⟬🎮⟭══════╗\n𝄟          جوال مريخ          𝄟\n╚═══════════════╝",--61
        "╔══════⟬🎮⟭══════╗\n𝄟          روبوت آلي          𝄟\n╚═══════════════╝",--62
        "╔══════⟬🎮⟭══════╗\n𝄟          عنكبوت آلي          𝄟\n╚═══════════════╝",--63
        "╔══════⟬🎮⟭══════╗\n𝄟          ثور آلي          𝄟\n╚═══════════════╝",--64
        "╔══════⟬🎮⟭══════╗\n𝄟          آلة متطورة          𝄟\n╚═══════════════╝",--65
        "╔══════⟬🎮⟭══════╗\n𝄟          آلة مخلب          𝄟\n╚═══════════════╝",--66
        "╔══════⟬🎮⟭══════╗\n𝄟          آلة ألعاب          𝄟\n╚═══════════════╝",--67
        "╔══════⟬🎮⟭══════╗\n𝄟          ألعاب نارية          𝄟\n╚═══════════════╝",--68
        "╔══════⟬🎮⟭══════╗\n𝄟          بالونات          𝄟\n╚═══════════════╝",--69
        "╔══════⟬🎮⟭══════╗\n𝄟          ألعاب مائية          𝄟\n╚═══════════════╝",--70
        "╔══════⟬🎮⟭══════╗\n𝄟          ألعاب صيفية          𝄟\n╚═══════════════╝",--71
        "╔══════⟬🎮⟭══════╗\n𝄟          ألعاب شتوية          𝄟\n╚═══════════════╝",--72
        "╔══════⟬🎮⟭══════╗\n𝄟          ترفيه عائلي          𝄟\n╚═══════════════╝",--73
        "╔══════⟬🎮⟭══════╗\n𝄟          حفلة موسيقية          𝄟\n╚═══════════════╝",--74
        "╔══════⟬🎮⟭══════╗\n𝄟          ديسكو          𝄟\n╚═══════════════╝",--75
        "╔══════⟬🎮⟭══════╗\n𝄟          سينما          𝄟\n╚═══════════════╝",--76
        "╔══════⟬🎮⟭══════╗\n𝄟          مسرح          𝄟\n╚═══════════════╝",--77
        "╔══════⟬🎮⟭══════╗\n𝄟          معرض فني          𝄟\n╚═══════════════╝",--78
        "╔══════⟬🎮⟭══════╗\n𝄟          عرض سيارات          𝄟\n╚═══════════════╝",--79
        "╔══════⟬🎮⟭══════╗\n𝄟          عرض خيول          𝄟\n╚═══════════════╝",--80
        "╔══════⟬🎮⟭══════╗\n𝄟          عرض أزياء          𝄟\n╚═══════════════╝",--81
        "╔══════⟬🎮⟭══════╗\n𝄟          ركن قراصنة          𝄟\n╚═══════════════╝",--82
        "╔══════⟬🎮⟭══════╗\n𝄟          جولة عالمية          𝄟\n╚═══════════════╝",--83
        "╔══════⟬🎮⟭══════╗\n𝄟          مخيم صيفي          𝄟\n╚═══════════════╝",--84
        "╔══════⟬🎮⟭══════╗\n𝄟          مغامرة مائية          𝄟\n╚═══════════════╝",--85
        "╔══════⟬🎮⟭══════╗\n𝄟          حديقة مغامرات          𝄟\n╚═══════════════╝",--86
        "╔══════⟬🎮⟭══════╗\n𝄟          منتزه بري          𝄟\n╚═══════════════╝",--87
        "╔══════⟬🎮⟭══════╗\n𝄟          نصب تجريبي          𝄟\n╚═══════════════╝",--88
        "╔══════⟬🎮⟭══════╗\n𝄟          لغز ضخم          𝄟\n╚═══════════════╝",--89
        "╔══════⟬🎮⟭══════╗\n𝄟          كرة بلازما          𝄟\n╚═══════════════╝",--90
        "╔══════⟬🎮⟭══════╗\n𝄟          كرة فاكهة          𝄟\n╚═══════════════╝",--91
        "╔══════⟬🎮⟭══════╗\n𝄟          ماسة كبرى          𝄟\n╚═══════════════╝",--92
        "╔══════⟬🎮⟭══════╗\n𝄟          صندوق مقدس          𝄟\n╚═══════════════╝",--93
        "╔══════⟬🎮⟭══════╗\n𝄟          بطيخة عملاقة          𝄟\n╚═══════════════╝",--94
        "╔══════⟬🎮⟭══════╗\n𝄟          تفاحة كراميل          𝄟\n╚═══════════════╝",--95
        "╔══════⟬🎮⟭══════╗\n𝄟          قش طازج          𝄟\n╚═══════════════╝",--96
        "╔══════⟬🎮⟭══════╗\n𝄟          بيتزا ساخنة          𝄟\n╚═══════════════╝",--97
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--98
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--99
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--100
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--101
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--102
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 97
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Game"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Game"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "ألعاب ومرح")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end

-- ❤️ حب وفلانتين
function Love()
    lastMenu = Love
    MH = gg.multiChoice({
        "╔══════⟬❤️⟭══════╗\n𝄟          قلب ياقوتي          𝄟\n╚═══════════════╝",--1
        "╔══════⟬❤️⟭══════╗\n𝄟          حديقة حب          𝄟\n╚═══════════════╝",--2
        "╔══════⟬❤️⟭══════╗\n𝄟          جسر حب          𝄟\n╚═══════════════╝",--3
        "╔══════⟬❤️⟭══════╗\n𝄟          قوس حب          𝄟\n╚═══════════════╝",--4
        "╔══════⟬❤️⟭══════╗\n𝄟          نفق غرام          𝄟\n╚═══════════════╝",--5
        "╔══════⟬❤️⟭══════╗\n𝄟          قفل غرام          𝄟\n╚═══════════════╝",--6
        "╔══════⟬❤️⟭══════╗\n𝄟          نافورة غرام          𝄟\n╚═══════════════╝",--7
        "╔══════⟬❤️⟭══════╗\n𝄟          نافورة حب          𝄟\n╚═══════════════╝",--8
        "╔══════⟬❤️⟭══════╗\n𝄟          كيوبيد          𝄟\n╚═══════════════╝",--9
        "╔══════⟬❤️⟭══════╗\n𝄟          سهم كيوبيد          𝄟\n╚═══════════════╝",--10
        "╔══════⟬❤️⟭══════╗\n𝄟          تمثال حب          𝄟\n╚═══════════════╝",--11
        "╔══════⟬❤️⟭══════╗\n𝄟          تمثال عاطفي          𝄟\n╚═══════════════╝",--12
        "╔══════⟬❤️⟭══════╗\n𝄟          تمثال محبين          𝄟\n╚═══════════════╝",--13
        "╔══════⟬❤️⟭══════╗\n𝄟          تمثال رسول          𝄟\n╚═══════════════╝",--14
        "╔══════⟬❤️⟭══════╗\n𝄟          مقعد محبين          𝄟\n╚═══════════════╝",--15
        "╔══════⟬❤️⟭══════╗\n𝄟          عشب زفاف          𝄟\n╚═══════════════╝",--16
        "╔══════⟬❤️⟭══════╗\n𝄟          كشك رومانسي          𝄟\n╚═══════════════╝",--17
        "╔══════⟬❤️⟭══════╗\n𝄟          عشاء رومانسي          𝄟\n╚═══════════════╝",--18
        "╔══════⟬❤️⟭══════╗\n𝄟          موعد رومانسي          𝄟\n╚═══════════════╝",--19
        "╔══════⟬❤️⟭══════╗\n𝄟          موعد مزدوج          𝄟\n╚═══════════════╝",--20
        "╔══════⟬❤️⟭══════╗\n𝄟          عربة أزهار          𝄟\n╚═══════════════╝",--21
        "╔══════⟬❤️⟭══════╗\n𝄟          مشتل قلب          𝄟\n╚═══════════════╝",--22
        "╔══════⟬❤️⟭══════╗\n𝄟          مشتل ملائكة          𝄟\n╚═══════════════╝",--23
        "╔══════⟬❤️⟭══════╗\n𝄟          حديقة رومانسية          𝄟\n╚═══════════════╝",--24
        "╔══════⟬❤️⟭══════╗\n𝄟          طيار عاشق          𝄟\n╚═══════════════╝",--25
        "╔══════⟬❤️⟭══════╗\n𝄟          لحن غرامي          𝄟\n╚═══════════════╝",--26
        "╔══════⟬❤️⟭══════╗\n𝄟          حمام عاشق          𝄟\n╚═══════════════╝",--27
        "╔══════⟬❤️⟭══════╗\n𝄟          دمية دب          𝄟\n╚═══════════════╝",--28
        "╔══════⟬❤️⟭══════╗\n𝄟          دمية أرنب          𝄟\n╚═══════════════╝",--29
        "╔══════⟬❤️⟭══════╗\n𝄟          قطة محبوبة          𝄟\n╚═══════════════╝",--30
        "╔══════⟬❤️⟭══════╗\n𝄟          وحيد قرن          𝄟\n╚═══════════════╝",--31
        "╔══════⟬❤️⟭══════╗\n𝄟          مفتاح القلب          𝄟\n╚═══════════════╝",--32
        "╔══════⟬❤️⟭══════╗\n𝄟          قلب خالد          𝄟\n╚═══════════════╝",--33
        "╔══════⟬❤️⟭══════╗\n𝄟          متزوجون حديثا          𝄟\n╚═══════════════╝",--34
        "╔══════⟬❤️⟭══════╗\n𝄟          النقل          𝄟\n╚═══════════════╝",--35
        "╔══════⟬❤️⟭══════╗\n𝄟          شجيرة مشدبة          𝄟\n╚═══════════════╝",--36
        "╔══════⟬❤️⟭══════╗\n𝄟          أرجوحة دوارة          𝄟\n╚═══════════════╝",--37
        "╔══════⟬❤️⟭══════╗\n𝄟          هدية غير متوقعة          𝄟\n╚═══════════════╝",--38
        "╔══════⟬❤️⟭══════╗\n𝄟          منحوتة حب          𝄟\n╚═══════════════╝",--39
        "╔══════⟬❤️⟭══════╗\n𝄟          زوجان رائعان          𝄟\n╚═══════════════╝",--40
        "╔══════⟬❤️⟭══════╗\n𝄟          حب خالد          𝄟\n╚═══════════════╝",--41
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--42
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--43
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--44
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--45
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--46
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 41
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Love"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Love"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "حب وفلانتين")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end


-- ❄️ كريسماس وثلج
function Christmas()
    lastMenu = Christmas
    MH = gg.multiChoice({
        "╔══════⟬❄️⟭══════╗\n𝄟          شجرة عيد          𝄟\n╚═══════════════╝",--1
        "╔══════⟬❄️⟭══════╗\n𝄟          شجرة احتفالية          𝄟\n╚═══════════════╝",--2
        "╔══════⟬❄️⟭══════╗\n𝄟          سوق شجرة          𝄟\n╚═══════════════╝",--3
        "╔══════⟬❄️⟭══════╗\n𝄟          زينة عيد          𝄟\n╚═══════════════╝",--4
        "╔══════⟬❄️⟭══════╗\n𝄟          كرة ثلجية          𝄟\n╚═══════════════╝",--5
        "╔══════⟬❄️⟭══════╗\n𝄟          كرة ثلجية 2          𝄟\n╚═══════════════╝",--6
        "╔══════⟬❄️⟭══════╗\n𝄟          مدفع ثلج          𝄟\n╚═══════════════╝",--7
        "╔══════⟬❄️⟭══════╗\n𝄟          معركة ثلج          𝄟\n╚═══════════════╝",--8
        "╔══════⟬❄️⟭══════╗\n𝄟          حلبة تزلج          𝄟\n╚═══════════════╝",--9
        "╔══════⟬❄️⟭══════╗\n𝄟          حلبة سناجب          𝄟\n╚═══════════════╝",--10
        "╔══════⟬❄️⟭══════╗\n𝄟          حلبة بطاريق          𝄟\n╚═══════════════╝",--11
        "╔══════⟬❄️⟭══════╗\n𝄟          زلاقة ثلج          𝄟\n╚═══════════════╝",--12
        "╔══════⟬❄️⟭══════╗\n𝄟          زلاقة كلاب          𝄟\n╚═══════════════╝",--13
        "╔══════⟬❄️⟭══════╗\n𝄟          زلاقة نعجات          𝄟\n╚═══════════════╝",--14
        "╔══════⟬❄️⟭══════╗\n𝄟          زلاجة سانتا          𝄟\n╚═══════════════╝",--15
        "╔══════⟬❄️⟭══════╗\n𝄟          مصعد تزلج          𝄟\n╚═══════════════╝",--16
        "╔══════⟬❄️⟭══════╗\n𝄟          منزل سانتا          𝄟\n╚═══════════════╝",--17
        "╔══════⟬❄️⟭══════╗\n𝄟          ورشة سانتا          𝄟\n╚═══════════════╝",--18
        "╔══════⟬❄️⟭══════╗\n𝄟          مكتب سانتا          𝄟\n╚═══════════════╝",--19
        "╔══════⟬❄️⟭══════╗\n𝄟          مساعد سانتا          𝄟\n╚═══════════════╝",--20
        "╔══════⟬❄️⟭══════╗\n𝄟          مساعدو سانتا          𝄟\n╚═══════════════╝",--21
        "╔══════⟬❄️⟭══════╗\n𝄟          رنة سانتا          𝄟\n╚═══════════════╝",--22
        "╔══════⟬❄️⟭══════╗\n𝄟          حادث في الورشة          𝄟\n╚═══════════════╝",--23
        "╔══════⟬❄️⟭══════╗\n𝄟          صورة مع سانتا          𝄟\n╚═══════════════╝",--24
        "╔══════⟬❄️⟭══════╗\n𝄟          منزل خبز الزنجبيل          𝄟\n╚═══════════════╝",--25
        "╔══════⟬❄️⟭══════╗\n𝄟          رجل الزنجبيل          𝄟\n╚═══════════════╝",--26
        "╔══════⟬❄️⟭══════╗\n𝄟          كوخ رجل الثلج          𝄟\n╚═══════════════╝",--27
        "╔══════⟬❄️⟭══════╗\n𝄟          منزل هاسكي          𝄟\n╚═══════════════╝",--28
        "╔══════⟬❄️⟭══════╗\n𝄟          قلعة ثلجية          𝄟\n╚═══════════════╝",--29
        "╔══════⟬❄️⟭══════╗\n𝄟          قلعة جليدية          𝄟\n╚═══════════════╝",--30
        "╔══════⟬❄️⟭══════╗\n𝄟          متحف جليد          𝄟\n╚═══════════════╝",--31
        "╔══════⟬❄️⟭══════╗\n𝄟          تماثيل جليدية          𝄟\n╚═══════════════╝",--32
        "╔══════⟬❄️⟭══════╗\n𝄟          تنين جليد          𝄟\n╚═══════════════╝",--33
        "╔══════⟬❄️⟭══════╗\n𝄟          نهر جليدي          𝄟\n╚═══════════════╝",--34
        "╔══════⟬❄️⟭══════╗\n𝄟          بحيرة متجمدة          𝄟\n╚═══════════════╝",--35
        "╔══════⟬❄️⟭══════╗\n𝄟          ينابيع ساخنة          𝄟\n╚═══════════════╝",--36
        "╔══════⟬❄️⟭══════╗\n𝄟          متجر هدايا          𝄟\n╚═══════════════╝",--37
        "╔══════⟬❄️⟭══════╗\n𝄟          كشك سوق          𝄟\n╚═══════════════╝",--38
        "╔══════⟬❄️⟭══════╗\n𝄟          ساحة كريسماس          𝄟\n╚═══════════════╝",--39
        "╔══════⟬❄️⟭══════╗\n𝄟          ليلة رأس السنة          𝄟\n╚═══════════════╝",--40
        "╔══════⟬❄️⟭══════╗\n𝄟          موسم الأعياد          𝄟\n╚═══════════════╝",--41
        "╔══════⟬❄️⟭══════╗\n𝄟          رياضة شتوية          𝄟\n╚═══════════════╝",--42
        "╔══════⟬❄️⟭══════╗\n𝄟          أنشطة شتوية          𝄟\n╚═══════════════╝",--43
        "╔══════⟬❄️⟭══════╗\n𝄟          متعة شتوية          𝄟\n╚═══════════════╝",--44
        "╔══════⟬❄️⟭══════╗\n𝄟          محطة قطبية          𝄟\n╚═══════════════╝",--45
        "╔══════⟬❄️⟭══════╗\n𝄟          منزل الأقزام          𝄟\n╚═══════════════╝",--46
        "╔══════⟬❄️⟭══════╗\n𝄟          منزل البحيرة          𝄟\n╚═══════════════╝",--47
        "╔══════⟬❄️⟭══════╗\n𝄟          شاليه مريح          𝄟\n╚═══════════════╝",--48
        "╔══════⟬❄️⟭══════╗\n𝄟          كوخ الأعياد          𝄟\n╚═══════════════╝",--49
        "╔══════⟬❄️⟭══════╗\n𝄟          رقم سحري          𝄟\n╚═══════════════╝",--50
        "╔══════⟬❄️⟭══════╗\n𝄟          كرلنج          𝄟\n╚═══════════════╝",--51
        "╔══════⟬❄️⟭══════╗\n𝄟          ملك الثلج          𝄟\n╚═══════════════╝",--52
        "╔══════⟬❄️⟭══════╗\n𝄟          وحش ثلجي          𝄟\n╚═══════════════╝",--53
        "╔══════⟬❄️⟭══════╗\n𝄟          مستكشف قطبي          𝄟\n╚═══════════════╝",--54
        "╔══════⟬❄️⟭══════╗\n𝄟          مطعم وجبات          𝄟\n╚═══════════════╝",--55
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--56
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--57
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--58
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--59
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--60
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 55
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Christmas"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Christmas"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "كريسماس وثلج")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end


-- 🦁 حيوانات وحديقة
function Animals()
    lastMenu = Animals
    MH = gg.multiChoice({
        "╔══════⟬🦁⟭══════╗\n𝄟          حديقة حيوان          𝄟\n╚═══════════════╝",--1
        "╔══════⟬🦁⟭══════╗\n𝄟          حديقة مدللة          𝄟\n╚═══════════════╝",--2
        "╔══════⟬🦁⟭══════╗\n𝄟          محمية برية          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🦁⟭══════╗\n𝄟          حديقة ديناصورات          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🦁⟭══════╗\n𝄟          حديقة فئران          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🦁⟭══════╗\n𝄟          حديقة مرجانية          𝄟\n╚═══════════════╝",--6
        "╔══════⟬🦁⟭══════╗\n𝄟          حديقة مائية          𝄟\n╚═══════════════╝",--7
        "╔══════⟬🦁⟭══════╗\n𝄟          حوض سمك          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🦁⟭══════╗\n𝄟          حوض سمك عملاق          𝄟\n╚═══════════════╝",--9
        "╔══════⟬🦁⟭══════╗\n𝄟          حوض سمك سعيد          𝄟\n╚═══════════════╝",--10
        "╔══════⟬🦁⟭══════╗\n𝄟          حوض سمك يوناني          𝄟\n╚═══════════════╝",--11
        "╔══════⟬🦁⟭══════╗\n𝄟          حوض سمك أطلنطي          𝄟\n╚═══════════════╝",--12
        "╔══════⟬🦁⟭══════╗\n𝄟          حوض سمك مدينة          𝄟\n╚═══════════════╝",--13
        "╔══════⟬🦁⟭══════╗\n𝄟          سمكة ذهبية          𝄟\n╚═══════════════╝",--14
        "╔══════⟬🦁⟭══════╗\n𝄟          كوي راقص          𝄟\n╚═══════════════╝",--15
        "╔══════⟬🦁⟭══════╗\n𝄟          ضفدع مال          𝄟\n╚═══════════════╝",--16
        "╔══════⟬🦁⟭══════╗\n𝄟          نحلة طيارة          𝄟\n╚═══════════════╝",--17
        "╔══════⟬🦁⟭══════╗\n𝄟          ديك ناري          𝄟\n╚═══════════════╝",--18
        "╔══════⟬🦁⟭══════╗\n𝄟          قط حظ          𝄟\n╚═══════════════╝",--19
        "╔══════⟬🦁⟭══════╗\n𝄟          أسد صيني          𝄟\n╚═══════════════╝",--20
        "╔══════⟬🦁⟭══════╗\n𝄟          تنين أحمر          𝄟\n╚═══════════════╝",--21
        "╔══════⟬🦁⟭══════╗\n𝄟          ماموث متجمد          𝄟\n╚═══════════════╝",--22
        "╔══════⟬🦁⟭══════╗\n𝄟          ديناصور          𝄟\n╚═══════════════╝",--23
        "╔══════⟬🦁⟭══════╗\n𝄟          تيرانوصور          𝄟\n╚═══════════════╝",--24
        "╔══════⟬🦁⟭══════╗\n𝄟          ديبلودوكس          𝄟\n╚═══════════════╝",--25
        "╔══════⟬🦁⟭══════╗\n𝄟          تي ريكس متجمد          𝄟\n╚═══════════════╝",--26
        "╔══════⟬🦁⟭══════╗\n𝄟          طاووس عاشق          𝄟\n╚═══════════════╝",--27
        "╔══════⟬🦁⟭══════╗\n𝄟          خروف محشو          𝄟\n╚═══════════════╝",--28
        "╔══════⟬🦁⟭══════╗\n𝄟          أفيال سعيدة          𝄟\n╚═══════════════╝",--29
        "╔══════⟬🦁⟭══════╗\n𝄟          بقرة حلوى          𝄟\n╚═══════════════╝",--30
        "╔══════⟬🦁⟭══════╗\n𝄟          مشتل خروف          𝄟\n╚═══════════════╝",--31
        "╔══════⟬🦁⟭══════╗\n𝄟          زرافة ميكانيكية          𝄟\n╚═══════════════╝",--32
        "╔══════⟬🦁⟭══════╗\n𝄟          لوحة حيوانات          𝄟\n╚═══════════════╝",--33
        "╔══════⟬🦁⟭══════╗\n𝄟          لوحة فيل          𝄟\n╚═══════════════╝",--34
        "╔══════⟬🦁⟭══════╗\n𝄟          لوحة زرافة          𝄟\n╚═══════════════╝",--35
        "╔══════⟬🦁⟭══════╗\n𝄟          لوحة حمار          𝄟\n╚═══════════════╝",--36
        "╔══════⟬🦁⟭══════╗\n𝄟          لوحة أسد          𝄟\n╚═══════════════╝",--37
        "╔══════⟬🦁⟭══════╗\n𝄟          لوحة غوص          𝄟\n╚═══════════════╝",--38
        "╔══════⟬🦁⟭══════╗\n𝄟          طوطم مزارع          𝄟\n╚═══════════════╝",--39
        "╔══════⟬🦁⟭══════╗\n𝄟          برج حمام          𝄟\n╚═══════════════╝",--40
        "╔══════⟬🦁⟭══════╗\n𝄟          مقعد صداقة          𝄟\n╚═══════════════╝",--41
        "╔══════⟬🦁⟭══════╗\n𝄟          رسام بدائي          𝄟\n╚═══════════════╝",--42
        "╔══════⟬🦁⟭══════╗\n𝄟          طهاة سعداء          𝄟\n╚═══════════════╝",--43
        "╔══════⟬🦁⟭══════╗\n𝄟          خبز موز          𝄟\n╚═══════════════╝",--44
        "╔══════⟬🦁⟭══════╗\n𝄟          رشات سعيدة          𝄟\n╚═══════════════╝",--45
        "╔══════⟬🦁⟭══════╗\n𝄟          عمل جماعي          𝄟\n╚═══════════════╝",--46
        "╔══════⟬🦁⟭══════╗\n𝄟          سقسقة          𝄟\n╚═══════════════╝",--47
        "╔══════⟬🦁⟭══════╗\n𝄟          قوس قزح          𝄟\n╚═══════════════╝",--48
        "╔══════⟬🦁⟭══════╗\n𝄟          متجر هدايا          𝄟\n╚═══════════════╝",--49
        "╔══════⟬🦁⟭══════╗\n𝄟          مطعم          𝄟\n╚═══════════════╝",--50
        "╔══════⟬🦁⟭══════╗\n𝄟          مقهى          𝄟\n╚═══════════════╝",--51
        "╔══════⟬🦁⟭══════╗\n𝄟          آيس كريم          𝄟\n╚═══════════════╝",--52
        "╔══════⟬🦁⟭══════╗\n𝄟          وجبات خفيفة          𝄟\n╚═══════════════╝",--53
        "╔══════⟬🦁⟭══════╗\n𝄟          مشروبات          𝄟\n╚═══════════════╝",--54
        "╔══════⟬🦁⟭══════╗\n𝄟          مسرح 4D          𝄟\n╚═══════════════╝",--55
        "╔══════⟬🦁⟭══════╗\n𝄟          عرض ثلاثي          𝄟\n╚═══════════════╝",--56
        "╔══════⟬🦁⟭══════╗\n𝄟          معرض بيئي          𝄟\n╚═══════════════╝",--57
        "╔══════⟬🦁⟭══════╗\n𝄟          حضانة قرود          𝄟\n╚═══════════════╝",--58
        "╔══════⟬🦁⟭══════╗\n𝄟          مينوتور          𝄟\n╚═══════════════╝",--59
        "╔══════⟬🦁⟭══════╗\n𝄟          حصان طروادة          𝄟\n╚═══════════════╝",--60
        "╔══════⟬🦁⟭══════╗\n𝄟          ترامبولين حيوانات          𝄟\n╚═══════════════╝",--61
        "╔══════⟬🦁⟭══════╗\n𝄟          بطل وزن          𝄟\n╚═══════════════╝",--62
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--63
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--64
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--65
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--66
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--67
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 62
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Animal"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Animal"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "حيوانات وحديقة")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end


-- 🍃 زينة الطبيعة
function Nature()
    lastMenu = Nature
    MH = gg.multiChoice({
        "╔══════⟬🍃⟭══════╗\n𝄟          شلال          𝄟\n╚═══════════════╝",--1
        "╔══════⟬🍃⟭══════╗\n𝄟          نبع          𝄟\n╚═══════════════╝",--2
        "╔══════⟬🍃⟭══════╗\n𝄟          بئر          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🍃⟭══════╗\n𝄟          بئر أمنيات          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🍃⟭══════╗\n𝄟          بئر نفط          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🍃⟭══════╗\n𝄟          بحيرة          𝄟\n╚═══════════════╝",--6
        "╔══════⟬🍃⟭══════╗\n𝄟          بحيرة غموض          𝄟\n╚═══════════════╝",--7
        "╔══════⟬🍃⟭══════╗\n𝄟          بحيرة زهور          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🍃⟭══════╗\n𝄟          بركة          𝄟\n╚═══════════════╝",--9
        "╔══════⟬🍃⟭══════╗\n𝄟          بركة بجع          𝄟\n╚═══════════════╝",--10
        "╔══════⟬🍃⟭══════╗\n𝄟          بركة متنزه          𝄟\n╚═══════════════╝",--11
        "╔══════⟬🍃⟭══════╗\n𝄟          كهف          𝄟\n╚═══════════════╝",--12
        "╔══════⟬🍃⟭══════╗\n𝄟          كهف غابة          𝄟\n╚═══════════════╝",--13
        "╔══════⟬🍃⟭══════╗\n𝄟          ملاذ كهف          𝄟\n╚═══════════════╝",--14
        "╔══════⟬🍃⟭══════╗\n𝄟          خيمة          𝄟\n╚═══════════════╝",--15
        "╔══════⟬🍃⟭══════╗\n𝄟          خيمة جنة          𝄟\n╚═══════════════╝",--16
        "╔══════⟬🍃⟭══════╗\n𝄟          خيمة ملونة          𝄟\n╚═══════════════╝",--17
        "╔══════⟬🍃⟭══════╗\n𝄟          كشك نزهة          𝄟\n╚═══════════════╝",--18
        "╔══════⟬🍃⟭══════╗\n𝄟          متنزه          𝄟\n╚═══════════════╝",--19
        "╔══════⟬🍃⟭══════╗\n𝄟          متنزه صغير          𝄟\n╚═══════════════╝",--20
        "╔══════⟬🍃⟭══════╗\n𝄟          متنزه كبير          𝄟\n╚═══════════════╝",--21
        "╔══════⟬🍃⟭══════╗\n𝄟          جناح زهور          𝄟\n╚═══════════════╝",--22
        "╔══════⟬🍃⟭══════╗\n𝄟          شرفة شلال          𝄟\n╚═══════════════╝",--23
        "╔══════⟬🍃⟭══════╗\n𝄟          شرفة مزرعة          𝄟\n╚═══════════════╝",--24
        "╔══════⟬🍃⟭══════╗\n𝄟          مزرعة عنب          𝄟\n╚═══════════════╝",--25
        "╔══════⟬🍃⟭══════╗\n𝄟          بستان خيزران          𝄟\n╚═══════════════╝",--26
        "╔══════⟬🍃⟭══════╗\n𝄟          بستان تفاح          𝄟\n╚═══════════════╝",--27
        "╔══════⟬🍃⟭══════╗\n𝄟          حدائق معلقة          𝄟\n╚═══════════════╝",--28
        "╔══════⟬🍃⟭══════╗\n𝄟          واحة          𝄟\n╚═══════════════╝",--29
        "╔══════⟬🍃⟭══════╗\n𝄟          واحة حضرية          𝄟\n╚═══════════════╝",--30
        "╔══════⟬🍃⟭══════╗\n𝄟          فندق واحة          𝄟\n╚═══════════════╝",--31
        "╔══════⟬🍃⟭══════╗\n𝄟          جسر حبال          𝄟\n╚═══════════════╝",--32
        "╔══════⟬🍃⟭══════╗\n𝄟          جسر حلوى          𝄟\n╚═══════════════╝",--33
        "╔══════⟬🍃⟭══════╗\n𝄟          جسر زجاجي          𝄟\n╚═══════════════╝",--34
        "╔══════⟬🍃⟭══════╗\n𝄟          جسر حجري          𝄟\n╚═══════════════╝",--35
        "╔══════⟬🍃⟭══════╗\n𝄟          جسر خشبي          𝄟\n╚═══════════════╝",--36
        "╔══════⟬🍃⟭══════╗\n𝄟          عش عائلة          𝄟\n╚═══════════════╝",--37
        "╔══════⟬🍃⟭══════╗\n𝄟          منزل بحار          𝄟\n╚═══════════════╝",--38
        "╔══════⟬🍃⟭══════╗\n𝄟          منزل صياد          𝄟\n╚═══════════════╝",--39
        "╔══════⟬🍃⟭══════╗\n𝄟          منزل حجري          𝄟\n╚═══════════════╝",--40
        "╔══════⟬🍃⟭══════╗\n𝄟          بيت لبلاب          𝄟\n╚═══════════════╝",--41
        "╔══════⟬🍃⟭══════╗\n𝄟          بيت شاي          𝄟\n╚═══════════════╝",--42
        "╔══════⟬🍃⟭══════╗\n𝄟          بيت حلوى          𝄟\n╚═══════════════╝",--43
        "╔══════⟬🍃⟭══════╗\n𝄟          نبات آكل          𝄟\n╚═══════════════╝",--44
        "╔══════⟬🍃⟭══════╗\n𝄟          جبل حلوى          𝄟\n╚═══════════════╝",--45
        "╔══════⟬🍃⟭══════╗\n𝄟          جذع غراب          𝄟\n╚═══════════════╝",--46
        "╔══════⟬🍃⟭══════╗\n𝄟          هرم مشروبات          𝄟\n╚═══════════════╝",--47
        "╔══════⟬🍃⟭══════╗\n𝄟          تشكيلة فواكه          𝄟\n╚═══════════════╝",--48
        "╔══════⟬🍃⟭══════╗\n𝄟          جزيرة مرح          𝄟\n╚═══════════════╝",--49
        "╔══════⟬🍃⟭══════╗\n𝄟          بوابة مفقودة          𝄟\n╚═══════════════╝",--50
        "╔══════⟬🍃⟭══════╗\n𝄟          موقع قديم          𝄟\n╚═══════════════╝",--51
        "╔══════⟬🍃⟭══════╗\n𝄟          مستوطنة          𝄟\n╚═══════════════╝",--52
        "╔══════⟬🍃⟭══════╗\n𝄟          متعة نار          𝄟\n╚═══════════════╝",--53
        "╔══════⟬🍃⟭══════╗\n𝄟          عيد ربيع          𝄟\n╚═══════════════╝",--54
        "╔══════⟬🍃⟭══════╗\n𝄟          اتصال أول          𝄟\n╚═══════════════╝",--55
        "╔══════⟬🍃⟭══════╗\n𝄟          توبياري          𝄟\n╚═══════════════╝",--56
        "╔══════⟬🍃⟭══════╗\n𝄟          عرض فني          𝄟\n╚═══════════════╝",--57
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--58
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--59
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--60
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--61
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--62
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 57
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Nature"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Nature"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "زينة الطبيعة")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end


-- 🏙️ زينة المدينة
function City()
    lastMenu = City
    MH = gg.multiChoice({
        "╔══════⟬🏙️⟭══════╗\n𝄟          برج خليفة          𝄟\n╚═══════════════╝",--1
        "╔══════⟬🏙️⟭══════╗\n𝄟          برج إيفل          𝄟\n╚═══════════════╝",--2
        "╔══════⟬🏙️⟭══════╗\n𝄟          برج بيزا          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🏙️⟭══════╗\n𝄟          برج فلكي          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🏙️⟭══════╗\n𝄟          برج معرفة          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🏙️⟭══════╗\n𝄟          برج مياه          𝄟\n╚═══════════════╝",--6
        "╔══════⟬🏙️⟭══════╗\n𝄟          برج حراسة          𝄟\n╚═══════════════╝",--7
        "╔══════⟬🏙️⟭══════╗\n𝄟          برج مراقبة          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🏙️⟭══════╗\n𝄟          ناطحة سحاب          𝄟\n╚═══════════════╝",--9
        "╔══════⟬🏙️⟭══════╗\n𝄟          بتروناس          𝄟\n╚═══════════════╝",--10
        "╔══════⟬🏙️⟭══════╗\n𝄟          إبرة فضائية          𝄟\n╚═══════════════╝",--11
        "╔══════⟬🏙️⟭══════╗\n𝄟          قصر شيخ          𝄟\n╚═══════════════╝",--12
        "╔══════⟬🏙️⟭══════╗\n𝄟          منزل راق          𝄟\n╚═══════════════╝",--13
        "╔══════⟬🏙️⟭══════╗\n𝄟          منزل مقلوب          𝄟\n╚═══════════════╝",--14
        "╔══════⟬🏙️⟭══════╗\n𝄟          منزل مصري          𝄟\n╚═══════════════╝",--15
        "╔══════⟬🏙️⟭══════╗\n𝄟          منزل مأمور          𝄟\n╚═══════════════╝",--16
        "╔══════⟬🏙️⟭══════╗\n𝄟          منزل منسق          𝄟\n╚═══════════════╝",--17
        "╔══════⟬🏙️⟭══════╗\n𝄟          كوخ صانع          𝄟\n╚═══════════════╝",--18
        "╔══════⟬🏙️⟭══════╗\n𝄟          شاليه جبلي          𝄟\n╚═══════════════╝",--19
        "╔══════⟬🏙️⟭══════╗\n𝄟          مدينة راعي          𝄟\n╚═══════════════╝",--20
        "╔══════⟬🏙️⟭══════╗\n𝄟          قرية أوليمبية          𝄟\n╚═══════════════╝",--21
        "╔══════⟬🏙️⟭══════╗\n𝄟          حي صيني          𝄟\n╚═══════════════╝",--22
        "╔══════⟬🏙️⟭══════╗\n𝄟          شارع حلوى          𝄟\n╚═══════════════╝",--23
        "╔══════⟬🏙️⟭══════╗\n𝄟          جادة قصيرة          𝄟\n╚═══════════════╝",--24
        "╔══════⟬🏙️⟭══════╗\n𝄟          جادة طويلة          𝄟\n╚═══════════════╝",--25
        "╔══════⟬🏙️⟭══════╗\n𝄟          سوق مزارعين          𝄟\n╚═══════════════╝",--26
        "╔══════⟬🏙️⟭══════╗\n𝄟          سوق متنقل          𝄟\n╚═══════════════╝",--27
        "╔══════⟬🏙️⟭══════╗\n𝄟          متجر هدايا          𝄟\n╚═══════════════╝",--28
        "╔══════⟬🏙️⟭══════╗\n𝄟          متجر كتب          𝄟\n╚═══════════════╝",--29
        "╔══════⟬🏙️⟭══════╗\n𝄟          متجر زهور          𝄟\n╚═══════════════╝",--30
        "╔══════⟬🏙️⟭══════╗\n𝄟          متجر موسيقى          𝄟\n╚═══════════════╝",--31
        "╔══════⟬🏙️⟭══════╗\n𝄟          متجر عضوي          𝄟\n╚═══════════════╝",--32
        "╔══════⟬🏙️⟭══════╗\n𝄟          متجر بردي          𝄟\n╚═══════════════╝",--33
        "╔══════⟬🏙️⟭══════╗\n𝄟          متجر تذكارات          𝄟\n╚═══════════════╝",--34
        "╔══════⟬🏙️⟭══════╗\n𝄟          مطعم          𝄟\n╚═══════════════╝",--35
        "╔══════⟬🏙️⟭══════╗\n𝄟          مطعم بيتزا          𝄟\n╚═══════════════╝",--36
        "╔══════⟬🏙️⟭══════╗\n𝄟          مطعم طريق          𝄟\n╚═══════════════╝",--37
        "╔══════⟬🏙️⟭══════╗\n𝄟          مقهى          𝄟\n╚═══════════════╝",--38
        "╔══════⟬🏙️⟭══════╗\n𝄟          مقهى 2          𝄟\n╚═══════════════╝",--39
        "╔══════⟬🏙️⟭══════╗\n𝄟          مقهى صيفي          𝄟\n╚═══════════════╝",--40
        "╔══════⟬🏙️⟭══════╗\n𝄟          مقهى روبوت          𝄟\n╚═══════════════╝",--41
        "╔══════⟬🏙️⟭══════╗\n𝄟          مقهى مكوك          𝄟\n╚═══════════════╝",--42
        "╔══════⟬🏙️⟭══════╗\n𝄟          مقهى قراصنة          𝄟\n╚═══════════════╝",--43
        "╔══════⟬🏙️⟭══════╗\n𝄟          حانة          𝄟\n╚═══════════════╝",--44
        "╔══════⟬🏙️⟭══════╗\n𝄟          حانة كمثرى          𝄟\n╚═══════════════╝",--45
        "╔══════⟬🏙️⟭══════╗\n𝄟          متجر آيس كريم          𝄟\n╚═══════════════╝",--46
        "╔══════⟬🏙️⟭══════╗\n𝄟          عربة بيتزا          𝄟\n╚═══════════════╝",--47
        "╔══════⟬🏙️⟭══════╗\n𝄟          عربة نقانق          𝄟\n╚═══════════════╝",--48
        "╔══════⟬🏙️⟭══════╗\n𝄟          عربة خضار          𝄟\n╚═══════════════╝",--49
        "╔══════⟬🏙️⟭══════╗\n𝄟          كشك هاتف          𝄟\n╚═══════════════╝",--50
        "╔══════⟬🏙️⟭══════╗\n𝄟          استديو تغيير          𝄟\n╚═══════════════╝",--51
        "╔══════⟬🏙️⟭══════╗\n𝄟          ورشة كاتب          𝄟\n╚═══════════════╝",--52
        "╔══════⟬🏙️⟭══════╗\n𝄟          ورشة نحات          𝄟\n╚═══════════════╝",--53
        "╔══════⟬🏙️⟭══════╗\n𝄟          مدرسة بستاني          𝄟\n╚═══════════════╝",--54
        "╔══════⟬🏙️⟭══════╗\n𝄟          مسرح          𝄟\n╚═══════════════╝",--55
        "╔══════⟬🏙️⟭══════╗\n𝄟          مسرح مفتوح          𝄟\n╚═══════════════╝",--56
        "╔══════⟬🏙️⟭══════╗\n𝄟          مسرح خارجي          𝄟\n╚═══════════════╝",--57
        "╔══════⟬🏙️⟭══════╗\n𝄟          مسرح رباعي          𝄟\n╚═══════════════╝",--58
        "╔══════⟬🏙️⟭══════╗\n𝄟          سينما          𝄟\n╚═══════════════╝",--59
        "╔══════⟬🏙️⟭══════╗\n𝄟          سينما خارجية          𝄟\n╚═══════════════╝",--60
        "╔══════⟬🏙️⟭══════╗\n𝄟          متحف          𝄟\n╚═══════════════╝",--61
        "╔══════⟬🏙️⟭══════╗\n𝄟          متحف أطلانتس          𝄟\n╚═══════════════╝",--62
        "╔══════⟬🏙️⟭══════╗\n𝄟          متحف أفلام          𝄟\n╚═══════════════╝",--63
        "╔══════⟬🏙️⟭══════╗\n𝄟          مركز فنون          𝄟\n╚═══════════════╝",--64
        "╔══════⟬🏙️⟭══════╗\n𝄟          مركز أبحاث          𝄟\n╚═══════════════╝",--65
        "╔══════⟬🏙️⟭══════╗\n𝄟          محطة اتصالات          𝄟\n╚═══════════════╝",--66
        "╔══════⟬🏙️⟭══════╗\n𝄟          قاعدة إطلاق          𝄟\n╚═══════════════╝",--67
        "╔══════⟬🏙️⟭══════╗\n𝄟          رادار          𝄟\n╚═══════════════╝",--68
        "╔══════⟬🏙️⟭══════╗\n𝄟          توربينات رياح          𝄟\n╚═══════════════╝",--69
        "╔══════⟬🏙️⟭══════╗\n𝄟          منصة كاميرا          𝄟\n╚═══════════════╝",--70
        "╔══════⟬🏙️⟭══════╗\n𝄟          طقم فيلم          𝄟\n╚═══════════════╝",--71
        "╔══════⟬🏙️⟭══════╗\n𝄟          مجموعة أفلام          𝄟\n╚═══════════════╝",--72
        "╔══════⟬🏙️⟭══════╗\n𝄟          برنامج طهي          𝄟\n╚═══════════════╝",--73
        "╔══════⟬??️⟭══════╗\n𝄟          قاعة مشاهير          𝄟\n╚═══════════════╝",--74
        "╔══════⟬🏙️⟭══════╗\n𝄟          منطقة فنون          𝄟\n╚═══════════════╝",--75
        "╔══════⟬🏙️⟭══════╗\n𝄟          منطقة موسيقية          𝄟\n╚═══════════════╝",--76
        "╔══════⟬🏙️⟭══════╗\n𝄟          منطقة تخفيضات          𝄟\n╚═══════════════╝",--77
        "╔══════⟬🏙️⟭══════╗\n𝄟          ساحة حصاد          𝄟\n╚═══════════════╝",--78
        "╔══════⟬🏙️⟭══════╗\n𝄟          ساحة أبطال          𝄟\n╚═══════════════╝",--79
        "╔══════⟬🏙️⟭══════╗\n𝄟          بلازا باريسية          𝄟\n╚═══════════════╝",--80
        "╔══════⟬🏙️⟭══════╗\n𝄟          حي ديسكو          𝄟\n╚═══════════════╝",--81
        "╔══════⟬🏙️⟭══════╗\n𝄟          دراجة قهوة          𝄟\n╚═══════════════╝",--82
        "╔══════⟬🏙️⟭══════╗\n𝄟          مولف ضخم          𝄟\n╚═══════════════╝",--83
        "╔══════⟬🏙️⟭══════╗\n𝄟          جرامافون          𝄟\n╚═══════════════╝",--84
        "╔══════⟬🏙️⟭══════╗\n𝄟          عازف أرجن          𝄟\n╚═══════════════╝",--85
        "╔══════⟬🏙️⟭══════╗\n𝄟          مطبخ ميداني          𝄟\n╚═══════════════╝",--86
        "╔══════⟬🏙️⟭══════╗\n𝄟          بيت معكرونة          𝄟\n╚═══════════════╝",--87
        "╔══════⟬🏙️⟭══════╗\n𝄟          بيت حوض سمك          𝄟\n╚═══════════════╝",--88
        "╔══════⟬🏙️⟭══════╗\n𝄟          قرية فاكهة          𝄟\n╚═══════════════╝",--89
        "╔══════⟬🏙️⟭══════╗\n𝄟          منجم ذهب          𝄟\n╚═══════════════╝",--90
        "╔══════⟬🏙️⟭══════╗\n𝄟          عرش قديم          𝄟\n╚═══════════════╝",--91
        "╔══════⟬🏙️⟭══════╗\n𝄟          قرن وفرة          𝄟\n╚═══════════════╝",--92
        "╔══════⟬🏙️⟭══════╗\n𝄟          حصاد عملاق          𝄟\n╚═══════════════╝",--93
        "╔══════⟬🏙️⟭══════╗\n𝄟          طاحونة شوكولاتة          𝄟\n╚═══════════════╝",--94
        "╔══════⟬🏙️⟭══════╗\n𝄟          حشد متحمس          𝄟\n╚═══════════════╝",--95
        "╔══════⟬🏙️⟭══════╗\n𝄟          وضع علامة          𝄟\n╚═══════════════╝",--96
        "╔══════⟬🏙️⟭══════╗\n𝄟          الحياة على الطريق          𝄟\n╚═══════════════╝",--97
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--98
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--99
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--100
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--101
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--102
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 97
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["City"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["City"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "زينة المدينة")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end


-- ⚓ ساحل وبحر
function Beach()
    lastMenu = Beach
    MH = gg.multiChoice({
        "╔══════⟬⚓⟭══════╗\n𝄟          شاطئ          𝄟\n╚═══════════════╝",--1
        "╔══════⟬⚓⟭══════╗\n𝄟          كوخ شاطئي          𝄟\n╚═══════════════╝",--2
        "╔══════⟬⚓⟭══════╗\n𝄟          حانة تيكي          𝄟\n╚═══════════════╝",--3
        "╔══════⟬⚓⟭══════╗\n𝄟          حانة جوز هند          𝄟\n╚═══════════════╝",--4
        "╔══════⟬⚓⟭══════╗\n𝄟          مقهى شاطئي          𝄟\n╚═══════════════╝",--5
        "╔══════⟬⚓⟭══════╗\n𝄟          مقهى عصير          𝄟\n╚═══════════════╝",--6
        "╔══════⟬⚓⟭══════╗\n𝄟          حمام سباحة          𝄟\n╚═══════════════╝",--7
        "╔══════⟬⚓⟭══════╗\n𝄟          كرة طائرة          𝄟\n╚═══════════════╝",--8
        "╔══════⟬⚓⟭══════╗\n𝄟          ركوب أمواج          𝄟\n╚═══════════════╝",--9
        "╔══════⟬⚓⟭══════╗\n𝄟          مقاعد شمس          𝄟\n╚═══════════════╝",--10
        "╔══════⟬⚓⟭══════╗\n𝄟          ممر انتظار          𝄟\n╚═══════════════╝",--11
        "╔══════⟬⚓⟭══════╗\n𝄟          جسر أحمر          𝄟\n╚═══════════════╝",--12
        "╔══════⟬⚓⟭══════╗\n𝄟          مرسى          𝄟\n╚═══════════════╝",--13
        "╔══════⟬⚓⟭══════╗\n𝄟          قارب          𝄟\n╚═══════════════╝",--14
        "╔══════⟬⚓⟭══════╗\n𝄟          قارب شاطئ          𝄟\n╚═══════════════╝",--15
        "╔══════⟬⚓⟭══════╗\n𝄟          قارب صيد          𝄟\n╚═══════════════╝",--16
        "╔══════⟬⚓⟭══════╗\n𝄟          قارب متعة          𝄟\n╚═══════════════╝",--17
        "╔══════⟬⚓⟭══════╗\n𝄟          قارب جندول          𝄟\n╚═══════════════╝",--18
        "╔══════⟬⚓⟭══════╗\n𝄟          قارب هوائي          𝄟\n╚═══════════════╝",--19
        "╔══════⟬⚓⟭══════╗\n𝄟          يخت          𝄟\n╚═══════════════╝",--20
        "╔══════⟬⚓⟭══════╗\n𝄟          يخت عالق          𝄟\n╚═══════════════╝",--21
        "╔══════⟬⚓⟭══════╗\n𝄟          يخت متعة          𝄟\n╚═══════════════╝",--22
        "╔══════⟬⚓⟭══════╗\n𝄟          سفينة          𝄟\n╚═══════════════╝",--23
        "╔══════⟬⚓⟭══════╗\n𝄟          سفينة قديمة          𝄟\n╚═══════════════╝",--24
        "╔══════⟬⚓⟭══════╗\n𝄟          سفينة مسكونة          𝄟\n╚═══════════════╝",--25
        "╔══════⟬⚓⟭══════╗\n𝄟          سفينة قراصنة          𝄟\n╚═══════════════╝",--26
        "╔══════⟬⚓⟭══════╗\n𝄟          سفينة أوديسيوس          𝄟\n╚═══════════════╝",--27
        "╔══════⟬⚓⟭══════╗\n𝄟          سفينة شراعية          𝄟\n╚═══════════════╝",--28
        "╔══════⟬⚓⟭══════╗\n𝄟          غواصة          𝄟\n╚═══════════════╝",--29
        "╔══════⟬⚓⟭══════╗\n𝄟          غواصون          𝄟\n╚═══════════════╝",--30
        "╔══════⟬⚓⟭══════╗\n𝄟          غواصة صفراء          𝄟\n╚═══════════════╝",--31
        "╔══════⟬⚓⟭══════╗\n𝄟          مستكشفو بحار          𝄟\n╚═══════════════╝",--32
        "╔══════⟬⚓⟭══════╗\n𝄟          زيارة دلافين          𝄟\n╚═══════════════╝",--33
        "╔══════⟬⚓⟭══════╗\n𝄟          فرس بحر          𝄟\n╚═══════════════╝",--34
        "╔══════⟬⚓⟭══════╗\n𝄟          نيسي          𝄟\n╚═══════════════╝",--35
        "╔══════⟬⚓⟭══════╗\n𝄟          حورية بحر          𝄟\n╚═══════════════╝",--36
        "╔══════⟬⚓⟭══════╗\n𝄟          جنية ماء          𝄟\n╚═══════════════╝",--37
        "╔══════⟬⚓⟭══════╗\n𝄟          سرطان ناسك          𝄟\n╚═══════════════╝",--38
        "╔══════⟬⚓⟭══════╗\n𝄟          طاهي سلطعون          𝄟\n╚═══════════════╝",--39
        "╔══════⟬⚓⟭══════╗\n𝄟          صيد أخطبوط          𝄟\n╚═══════════════╝",--40
        "╔══════⟬⚓⟭══════╗\n𝄟          شعب مرجانية          𝄟\n╚═══════════════╝",--41
        "╔══════⟬⚓⟭══════╗\n𝄟          زنبق مائي          𝄟\n╚═══════════════╝",--42
        "╔══════⟬⚓⟭══════╗\n𝄟          زنبق وردي          𝄟\n╚═══════════════╝",--43
        "╔══════⟬⚓⟭══════╗\n𝄟          طوف          𝄟\n╚═══════════════╝",--44
        "╔══════⟬⚓⟭══════╗\n𝄟          زلاقة مائية          𝄟\n╚═══════════════╝",--45
        "╔══════⟬⚓⟭══════╗\n𝄟          زلاجة          𝄟\n╚═══════════════╝",--46
        "╔══════⟬⚓⟭══════╗\n𝄟          فيلا مائية          𝄟\n╚═══════════════╝",--47
        "╔══════⟬⚓⟭══════╗\n𝄟          فندق أطلانتس          𝄟\n╚═══════════════╝",--48
        "╔══════⟬⚓⟭══════╗\n𝄟          فندق شراعي          𝄟\n╚═══════════════╝",--49
        "╔══════⟬⚓⟭══════╗\n𝄟          محطة بحرية          𝄟\n╚═══════════════╝",--50
        "╔══════⟬⚓⟭══════╗\n𝄟          بوابات بحر          𝄟\n╚═══════════════╝",--51
        "╔══════⟬⚓⟭══════╗\n𝄟          بوابة جليدية          𝄟\n╚═══════════════╝",--52
        "╔══════⟬⚓⟭══════╗\n𝄟          مدينة غارقة          𝄟\n╚═══════════════╝",--53
        "╔══════⟬⚓⟭══════╗\n𝄟          أطلال أتلانتس          𝄟\n╚═══════════════╝",--54
        "╔══════⟬⚓⟭══════╗\n𝄟          رمح أطلنطي          𝄟\n╚═══════════════╝",--55
        "╔══════⟬⚓⟭══════╗\n𝄟          كسارة ثلج          𝄟\n╚═══════════════╝",--56
        "╔══════⟬⚓⟭══════╗\n𝄟          قائد أسطوري          𝄟\n╚═══════════════╝",--57
        "╔══════⟬⚓⟭══════╗\n𝄟          مرساة أميرالية          𝄟\n╚═══════════════╝",--58
        "╔══════⟬⚓⟭══════╗\n𝄟          مدفع بحري          𝄟\n╚═══════════════╝",--59
        "╔══════⟬⚓⟭══════╗\n𝄟          مدفع فاكهة          𝄟\n╚═══════════════╝",--60
        "╔══════⟬⚓⟭══════╗\n𝄟          كنز بالداساري          𝄟\n╚═══════════════╝",--61
        "╔══════⟬⚓⟭══════╗\n𝄟          معسكر قراصنة          𝄟\n╚═══════════════╝",--62
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--63
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--64
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--65
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--66
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--67
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 62
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Beach"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Beach"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "ساحل وبحر")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end


-- 🏛️ معالم أثرية
function Ancient()
    lastMenu = Ancient
    MH = gg.multiChoice({
        "╔══════⟬🏛️⟭══════╗\n𝄟          هرم خوفو          𝄟\n╚═══════════════╝",--1
        "╔══════⟬🏛️⟭══════╗\n𝄟          هرم          𝄟\n╚═══════════════╝",--2
        "╔══════⟬🏛️⟭══════╗\n𝄟          أبو الهول          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🏛️⟭══════╗\n𝄟          تمثال فرعون          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🏛️⟭══════╗\n𝄟          معبد تايلاندي          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🏛️⟭══════╗\n𝄟          معبد فردوس          𝄟\n╚═══════════════╝",--6
        "╔══════⟬🏛️⟭══════╗\n𝄟          تاج محل          𝄟\n╚═══════════════╝",--7
        "╔══════⟬🏛️⟭══════╗\n𝄟          قوس نصر          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🏛️⟭══════╗\n𝄟          تمثال حرية          𝄟\n╚═══════════════╝",--9
        "╔══════⟬🏛️⟭══════╗\n𝄟          كاتدرائية          𝄟\n╚═══════════════╝",--10
        "╔══════⟬🏛️⟭══════╗\n𝄟          دار أوبرا          𝄟\n╚═══════════════╝",--11
        "╔══════⟬🏛️⟭══════╗\n𝄟          ساعة بيج بن          𝄟\n╚═══════════════╝",--12
        "╔══════⟬🏛️⟭══════╗\n𝄟          تقويم قديم          𝄟\n╚═══════════════╝",--13
        "╔══════⟬🏛️⟭══════╗\n𝄟          مدينة مفقودة          𝄟\n╚═══════════════╝",--14
        "╔══════⟬🏛️⟭══════╗\n𝄟          بوابة مفقودة          𝄟\n╚═══════════════╝",--15
        "╔══════⟬🏛️⟭══════╗\n𝄟          موقع مدينة          𝄟\n╚═══════════════╝",--16
        "╔══════⟬🏛️⟭══════╗\n𝄟          فوهة بركان          𝄟\n╚═══════════════╝",--17
        "╔══════⟬🏛️⟭══════╗\n𝄟          صندوق كنز          𝄟\n╚═══════════════╝",--18
        "╔══════⟬🏛️⟭══════╗\n𝄟          وعاء ثروة          𝄟\n╚═══════════════╝",--19
        "╔══════⟬🏛️⟭══════╗\n𝄟          عرش جلالة          𝄟\n╚═══════════════╝",--20
        "╔══════⟬🏛️⟭══════╗\n𝄟          سفينة قرصان          𝄟\n╚═══════════════╝",--21
        "╔══════⟬🏛️⟭══════╗\n𝄟          مقدمة سفينة          𝄟\n╚═══════════════╝",--22
        "╔══════⟬🏛️⟭══════╗\n𝄟          منزل صيني          𝄟\n╚═══════════════╝",--23
        "╔══════⟬🏛️⟭══════╗\n𝄟          ستونهنج          𝄟\n╚═══════════════╝",--24
        "╔══════⟬🏛️⟭══════╗\n𝄟          تيرانوصور          𝄟\n╚═══════════════╝",--25
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--26
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--27
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--28
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--29
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--30
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 25
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Ancient"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Ancient"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "معالم أثرية")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end

-- 🎃 هالوين ورعب
function Halloween()
    lastMenu = Halloween
    MH = gg.multiChoice({
        "╔══════⟬🎃⟭══════╗\n𝄟          منزل ملعون          𝄟\n╚═══════════════╝",--1
        "╔══════⟬🎃⟭══════╗\n𝄟          بيت رعب          𝄟\n╚═══════════════╝",--2
        "╔══════⟬🎃⟭══════╗\n𝄟          برج مرعب          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🎃⟭══════╗\n𝄟          قبو مخيف          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🎃⟭══════╗\n𝄟          غرفة رعب          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🎃⟭══════╗\n𝄟          متجر ساحرة          𝄟\n╚═══════════════╝",--6
        "╔══════⟬🎃⟭══════╗\n𝄟          مرجل سحري          𝄟\n╚═══════════════╝",--7
        "╔══════⟬🎃⟭══════╗\n𝄟          ساحرة بجرعة          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🎃⟭══════╗\n𝄟          رجل يقطين          𝄟\n╚═══════════════╝",--9
        "╔══════⟬🎃⟭══════╗\n𝄟          فزاعة يقطين          𝄟\n╚═══════════════╝",--10
        "╔══════⟬🎃⟭══════╗\n𝄟          شجرة يقطين          𝄟\n╚═══════════════╝",--11
        "╔══════⟬🎃⟭══════╗\n𝄟          قطة سوداء          𝄟\n╚═══════════════╝",--12
        "╔══════⟬🎃⟭══════╗\n𝄟          فارس برأس          𝄟\n╚═══════════════╝",--13
        "╔══════⟬🎃⟭══════╗\n𝄟          عرض مستذئب          𝄟\n╚═══════════════╝",--14
        "╔══════⟬🎃⟭══════╗\n𝄟          سفينة شبح          𝄟\n╚═══════════════╝",--15
        "╔══════⟬🎃⟭══════╗\n𝄟          عربة أشباح          𝄟\n╚═══════════════╝",--16
        "╔══════⟬🎃⟭══════╗\n𝄟          عربة مطاردة          𝄟\n╚═══════════════╝",--17
        "╔══════⟬🎃⟭══════╗\n𝄟          عجلة قرع          𝄟\n╚═══════════════╝",--18
        "╔══════⟬🎃⟭══════╗\n𝄟          مصباح أشباح          𝄟\n╚═══════════════╝",--19
        "╔══════⟬🎃⟭══════╗\n𝄟          نافورة مشؤومة          𝄟\n╚═══════════════╝",--20
        "╔══════⟬🎃⟭══════╗\n𝄟          بقعة خضراء          𝄟\n╚═══════════════╝",--21
        "╔══════⟬🎃⟭══════╗\n𝄟          طريق سري          𝄟\n╚═══════════════╝",--22
        "╔══════⟬🎃⟭══════╗\n𝄟          مزراب          𝄟\n╚═══════════════╝",--23
        "╔══════⟬🎃⟭══════╗\n𝄟          معصرة عنب          𝄟\n╚═══════════════╝",--24
        "╔══════⟬🎃⟭══════╗\n𝄟          زينة عادية          𝄟\n╚═══════════════╝",--25
        "╔══════⟬🎃⟭══════╗\n𝄟          متنزه ساحرات          𝄟\n╚═══════════════╝",--26
        "╔══════⟬🎃⟭══════╗\n𝄟          دورة مكنسة          𝄟\n╚═══════════════╝",--27
        "╔══════⟬🎃⟭══════╗\n𝄟          أوركسترا          𝄟\n╚═══════════════╝",--28
        "╔══════⟬🎃⟭══════╗\n𝄟          بيت زجاجي          𝄟\n╚═══════════════╝",--29
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--30
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--31
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--32
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--33
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--34
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 29
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Halloween"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Halloween"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "هالوين ورعب")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end


-- 🚧 سياج وجسور
function Fences()
    lastMenu = Fences
    MH = gg.multiChoice({
        "╔══════⟬🚧⟭══════╗\n𝄟          سياج ذهبي          𝄟\n╚═══════════════╝",--1
        "╔══════⟬🚧⟭══════╗\n𝄟          سياج زهور          𝄟\n╚═══════════════╝",--2
        "╔══════⟬🚧⟭══════╗\n𝄟          سياج شجيرات          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🚧⟭══════╗\n𝄟          سياج خشبي          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🚧⟭══════╗\n𝄟          سياج ديكوري          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🚧⟭══════╗\n𝄟          سياج شرقي          𝄟\n╚═══════════════╝",--6
        "╔══════⟬🚧⟭══════╗\n𝄟          سياج بحر          𝄟\n╚═══════════════╝",--7
        "╔══════⟬🚧⟭══════╗\n𝄟          سياج زنجبيل          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🚧⟭══════╗\n𝄟          سياج عيد الفصح          𝄟\n╚═══════════════╝",--9
        "╔══════⟬🚧⟭══════╗\n𝄟          بوابة زهور          𝄟\n╚═══════════════╝",--10
        "╔══════⟬🚧⟭══════╗\n𝄟          بوابات المجد          𝄟\n╚═══════════════╝",--11
        "╔══════⟬🚧⟭══════╗\n𝄟          جسر فاكهة          𝄟\n╚═══════════════╝",--12
        "╔══════⟬🚧⟭══════╗\n𝄟          فوانيس ورقية          𝄟\n╚═══════════════╝",--13
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--14
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--15
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--16
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--17
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--18
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 13
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Fence"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Fence"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "سياج وجسور")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end

-- 🐇 عيد الفصح
function Easter()
    lastMenu = Easter
    MH = gg.multiChoice({
        "╔══════⟬🐇⟭══════╗\n𝄟          بيضة فابرجي          𝄟\n╚═══════════════╝",--1
        "╔══════⟬🐇⟭══════╗\n𝄟          بيض فابرجيه          𝄟\n╚═══════════════╝",--2
        "╔══════⟬🐇⟭══════╗\n𝄟          توبياري بيض          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🐇⟭══════╗\n𝄟          توبياري عيد          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🐇⟭══════╗\n𝄟          تمثال أرنب          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🐇⟭══════╗\n𝄟          دمية أرنب          𝄟\n╚═══════════════╝",--6
        "╔══════⟬🐇⟭══════╗\n𝄟          منزل أرنب          𝄟\n╚═══════════════╝",--7
        "╔══════⟬🐇⟭══════╗\n𝄟          بيت أرنب          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🐇⟭══════╗\n𝄟          متجر عيد          𝄟\n╚═══════════════╝",--9
        "╔══════⟬🐇⟭══════╗\n𝄟          ورشة عيد          𝄟\n╚═══════════════╝",--10
        "╔══════⟬🐇⟭══════╗\n𝄟          قرية أرانب          𝄟\n╚═══════════════╝",--11
        "╔══════⟬🐇⟭══════╗\n𝄟          متاهة عيد          𝄟\n╚═══════════════╝",--12
        "╔══════⟬🐇⟭══════╗\n𝄟          كنز أرانب          𝄟\n╚═══════════════╝",--13
        "╔══════⟬🐇⟭══════╗\n𝄟          عربة هدايا          𝄟\n╚═══════════════╝",--14
        "╔══════⟬🐇⟭══════╗\n𝄟          أرجوحة عيد          𝄟\n╚═══════════════╝",--15
        "╔══════⟬🐇⟭══════╗\n𝄟          سكة حديد          𝄟\n╚═══════════════╝",--16
        "╔══════⟬🐇⟭══════╗\n𝄟          متعة عيد          𝄟\n╚═══════════════╝",--17
        "╔══════⟬🐇⟭══════╗\n𝄟          رشاش مياه          𝄟\n╚═══════════════╝",--18
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--19
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--20
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--21
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--22
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--23
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 18
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Easter"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Easter"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "عيد الفصح")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end


-- 🎉 زينة الأحداث
function Events()
    lastMenu = Events
    MH = gg.multiChoice({
        "╔══════⟬🎉⟭══════╗\n𝄟          طاحونة هالوين          𝄟\n╚═══════════════╝",--1
        "╔══════⟬🎉⟭══════╗\n𝄟          قرية سانتا          𝄟\n╚═══════════════╝",--2
        "╔══════⟬🎉⟭══════╗\n𝄟          بوابة سايبر          𝄟\n╚═══════════════╝",--3
        "╔══════⟬🎉⟭══════╗\n𝄟          مكتب مأمور          𝄟\n╚═══════════════╝",--4
        "╔══════⟬🎉⟭══════╗\n𝄟          نادي جاز          𝄟\n╚═══════════════╝",--5
        "╔══════⟬🎉⟭══════╗\n𝄟          عربة مشؤومة          𝄟\n╚═══════════════╝",--6
        "╔══════⟬🎉⟭══════╗\n𝄟          بوابة فايكنج          𝄟\n╚═══════════════╝",--7
        "╔══════⟬🎉⟭══════╗\n𝄟          ديك حبش          𝄟\n╚═══════════════╝",--8
        "╔══════⟬🎉⟭══════╗\n𝄟          شاليه جبلي          𝄟\n╚═══════════════╝",--9
        "╔══════⟬🎉⟭══════╗\n𝄟          مذبح باستيت          𝄟\n╚═══════════════╝",--10
        "╔══════⟬🎉⟭══════╗\n𝄟          ريشة ذهبية          𝄟\n╚═══════════════╝",--11
        "╔══════⟬🎉⟭══════╗\n𝄟          دراكار فايكنج          𝄟\n╚═══════════════╝",--12
        "╔══════⟬🎉⟭══════╗\n𝄟          منطقة قراصنة          𝄟\n╚═══════════════╝",--13
        "╔══════⟬🎉⟭══════╗\n𝄟          مسرح خارجي          𝄟\n╚═══════════════╝",--14
        "╔══════⟬🎉⟭══════╗\n𝄟          نافورة حية          𝄟\n╚═══════════════╝",--15
        "╔══════⟬🟡⟭══════╗\n𝄟     اختيار جميع الزينات     𝄟\n╚═══════════════╝",--16
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمة الزينه      𝄟\n╚═══════════════╝",--17
        "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد      𝄟\n╚═══════════════╝",--18
        "╔══════⟬🔴⟭══════╗\n𝄟      العوده للقائمه الرئيسيه      𝄟\n╚═══════════════╝",--19
        "╔══════⟬🟡⟭══════╗\n𝄟      الخروج بشكل نهائي      𝄟\n╚═══════════════╝",--20
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 15
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Event"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Event"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "زينة الأحداث")return end

if MH[total + 2] then U30() end
if MH[total + 3] then Mahmoud() end
if MH[total + 4] then Home() end
if MH[total + 5] then EXIT() end

HERO = -1
end

   
--قسم القسائم 
function U1()
    lastMenu = U1
    MH = gg.multiChoice({
        "╔══════⟬⚜️⟭══════╗\n𝄟              قسيمة التوسع         𝄟 \n╚═══════════════╝",--1
        "╔══════⟬⚜️⟭══════╗\n𝄟                قسيمة الدعم         𝄟 \n╚═══════════════╝",--2
        "╔══════⟬⚜️⟭══════╗\n𝄟              قسيمة المصانع        𝄟 \n╚═══════════════╝",--3
        "╔══════⟬⚜️⟭══════╗\n𝄟               قسيمة القطار         𝄟 \n╚═══════════════╝",--4
        "╔══════⟬⚜️⟭══════╗\n𝄟               قسيمة الجزر          𝄟 \n╚═══════════════╝",--5
        "╔══════⟬⚜️⟭══════╗\n𝄟              قسيمة الشونة         𝄟 \n╚═══════════════╝",--6
        "╔══════⟬⚜️⟭══════╗\n𝄟              قسيمة التاجر          𝄟 \n╚═══════════════╝",--7
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع القسائم 🟡 𝄟 \n╚═══════════════╝",--8
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--9
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--10
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--11
    }, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

    if not MH then return end
    if MH[8] or (function()
    local count = 0
    for i = 1, 7 do if MH[i] then count = count + 1 end end
    return count > 1
    end)() then
    
    local allTickets = {}   for i = 1, 7 do
 if MH[i] or MH[8] then table.insert(allTickets, _G["M"..i]()) end end
    
    if #allTickets > 0 then   
    applyTicket(allTickets, true) 
       gg.sleep(3000)
      gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n✨ تم استبدال جميع أكواد القسائم ✨\n\n🙋 هات خمسه جنيه بقا 🙋\n\n🇪🇬 Egypt Mother of the World 🇪🇬")  end  return end
        
   
    local tickets = {} for i = 1, 7 do
    if MH[i] then table.insert(tickets, _G["M"..i]()) end end

    if #tickets > 0 then applyTicket(tickets, true) end

    if MH[9] then Mahmoud() end
    if MH[10] then Home() end
    if MH[11] then EXIT() end

    HERO = -1
end




--قسم السبائك 
function U2 ()
lastMenu = U2
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟              سبيكه برونزية         𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟               سبيكة فضية          𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟               سبيكة ذهبية          𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟                سبيكة بلاتين         𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع السبائك🟡 𝄟 \n╚═══════════════╝",--5
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--8
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

if not MH then return end

local selectedCount = 0
for i = 1, 4 do  
if MH[i] then 
selectedCount = selectedCount + 1
end end

if MH[5] or selectedCount > 1 then
local allTickets = {} for i = 1, 4 do
  
if MH[5] or MH[i] then  
table.insert(allTickets, _G["K"..i]())
end end
    
if #allTickets > 0 then   
applyTicket(allTickets, true) 
gg.sleep(4000)
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n✨ تم استبدال جميع أكواد السبائك ✨\n\n🙋 هات خمسه جنيه بقا 🙋\n\n🇪🇬 Egypt Mother of the World 🇪🇬") 
end return end


local tickets = {} for i = 1, 4 do
if MH[i] then  table.insert(tickets, _G["K"..i]()) 
end end

if #tickets > 0 then 
applyTicket(tickets, true) 
end

if MH[6] then Mahmoud() end
if MH[7] then Home() end
if MH[8] then EXIT() end

HERO = -1
end






--ادوات المنجم 
function U3 ()
lastMenu = U3
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                     معول              𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                    ديناميت           𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟                    متفجرات          𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟                صاروخ المنجم       𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع المتفجرات🟡𝄟 \n╚═══════════════╝",--5
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--8
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[5] then
local allTickets = {} for i = 1, 4 do
table.insert(allTickets, _G["V"..i]())end
    
if #allTickets > 0 then   
applyTicket(allTickets, true) 
gg.sleep(2000)
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n✨ تم استبدال جميع أكواد المتفجرات ✨\n\n🙋 هات خمسه جنيه بقا 🙋\n\n🇪🇬 Egypt Mother of the World 🇪🇬") end return end
        
local tickets = {}for i = 1, 4 do
if MH[i] then table.insert(tickets, _G["V"..i]()) end end

if #tickets > 0 then applyTicket(tickets, true) end

if MH[6] then Mahmoud() end
if MH[7] then Home() end
if MH[8] then EXIT() end

HERO = -1
end

--اكواد الشونه 
function U4 ()
lastMenu = U4
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                    مطرقه              𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                    مسمار               𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟                طلاء احمر             𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار جميع الادوات 🟡  𝄟 \n╚═══════════════╝",--4
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--7
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[4] then
local allTickets = {} for i = 1, 3 do
table.insert(allTickets, _G["A"..i]())end
    
if #allTickets > 0 then   
applyTicket(allTickets, true) 
gg.sleep(2000)
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n✨ تم استبدال جميع أكواد الشونة✨\n\n🙋 هات خمسه جنيه بقا 🙋\n\n🇪🇬 Egypt Mother of the World 🇪🇬") end return end
        
local tickets = {}for i = 1, 3 do
if MH[i] then table.insert(tickets, _G["A"..i]()) end end

if #tickets > 0 then applyTicket(tickets, true) end

if MH[5] then Mahmoud() end
if MH[6] then Home() end
if MH[7] then EXIT() end

HERO = -1
end


--اكواد البناء 
function U5 ()
lastMenu = U5
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                 طوب احمر           𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                بلاط ابيض            𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟                     زجاج               𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟                     مثقاب              𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟                 مطرقة ثاقبة         𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟              منشار كهربائي         𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n??🟡اختيار جميع ادوات البناء🟡𝄟 \n╚═══════════════╝",--7
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--8
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--9
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--10
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[7] then
local allTickets = {} for i = 1, 6 do
table.insert(allTickets, _G["AA"..i]())end
    
if #allTickets > 0 then   
applyTicket(allTickets, true) 
gg.sleep(2000)
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n✨ تم استبدال جميع أكواد البناء ✨\n\n🙋 هات خمسه جنيه بقا 🙋\n\n🇪🇬 Egypt Mother of the World 🇪🇬") end return end
        
local tickets = {}for i = 1, 6 do
if MH[i] then table.insert(tickets, _G["AA"..i]()) end end

if #tickets > 0 then applyTicket(tickets, true) end

if MH[8] then Mahmoud() end
if MH[9] then Home() end
if MH[10] then EXIT() end

HERO = -1
end

--المجوهرات 
function U6 ()
lastMenu = U6
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟               التوباز الاصفر         𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n??               الزمرد الاخضر        𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟               الياقوت الاحمر       𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع المجوهرات🟡𝄟 \n╚═══════════════╝",--4
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--7
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n??⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 ?? 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[4] then
local allTickets = {} for i = 1, 3 do
table.insert(allTickets, _G["DD"..i]())end
    
if #allTickets > 0 then   
applyTicket(allTickets, true) 
gg.sleep(2000)
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n✨ تم استبدال جميع أكواد المجوهرات ✨\n\n🙋 هات خمسه جنيه بقا 🙋\n\n🇪🇬 Egypt Mother of the World 🇪🇬") end return end
        
local tickets = {}for i = 1, 3 do
if MH[i] then table.insert(tickets, _G["DD"..i]()) end end

if #tickets > 0 then applyTicket(tickets, true) end

if MH[5] then Mahmoud() end
if MH[6] then Home() end
if MH[7] then EXIT() end

HERO = -1
end


--الالوان
function U7 ()
lastMenu = U7
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                مطرقة ثاقبة          𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                     صنبور              𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟                       قفاز               𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟                     صاروخ             𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟                  الديناميت            𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟               كرة قوس قزح        𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع المعزازات 🟡𝄟 \n╚═══════════════╝",--7
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--8
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--9
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--10
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[7] then
local allTickets = {} for i = 1, 6 do
table.insert(allTickets, _G["B"..i]())end
    
if #allTickets > 0 then   
applyTicket(allTickets, true) 
gg.sleep(2000)
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n✨ تم استبدال جميع أكواد المعزازات ✨\n\n🙋 هات خمسه جنيه بقا ??\n\n🇪🇬 Egypt Mother of the World 🇪🇬") end return end
        
local tickets = {}for i = 1, 6 do
if MH[i] then table.insert(tickets, _G["B"..i]()) end end

if #tickets > 0 then applyTicket(tickets, true) end

if MH[8] then Mahmoud() end
if MH[9] then Home() end
if MH[10] then EXIT() end

HERO = -1
end

--حدث الألوان الجديد 
function U8 ()
lastMenu = U8
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                 مطرقة ثاقبة         𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                     مثقاب              𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟                        ثقل               𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟                      مروحة            𝄟 \n╚═══════════════╝",--4
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--7
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[5] then
local allTickets = {} for i = 1, 4 do
table.insert(allTickets, _G["C"..i]())end
    
if #allTickets > 0 then   
applyTicket(allTickets, true) 
gg.sleep(2000)
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n✨ تم استبدال جميع أكواد المعزازات ✨\n\n🙋 هات خمسه جنيه بقا 🙋\n\n🇪🇬 Egypt Mother of the World 🇪🇬") end return end
        
local tickets = {}for i = 1, 4 do
if MH[i] then table.insert(tickets, _G["C"..i]()) end end

if #tickets > 0 then applyTicket(tickets, true) end

if MH[5] then Mahmoud() end
if MH[6] then Home() end
if MH[7] then EXIT() end

HERO = -1
end


--اكواد العلف 
function U9 ()
lastMenu = U9
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                  علف أبقار            𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                 علف دجاج           𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟                علف خروف           𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟                 غذاء النحل           𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟               طعام الخنزير          𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟                     المادة               𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع الاعلاف  🟡𝄟 \n╚═══════════════╝",--5
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--8
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--9
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[7] then
local allTickets = {} for i = 1, 6 do
table.insert(allTickets, _G["WW"..i]())end
    
if #allTickets > 0 then   
applyTicket(allTickets, true) 
gg.sleep(2000)
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n✨ تم استبدال جميع أكواد علف الحيوانات ✨\n\n🙋 هات خمسه جنيه بقا 🙋\n\n🇪🇬 Egypt Mother of the World 🇪🇬") end return end
        
local tickets = {}for i = 1, 6 do
if MH[i] then table.insert(tickets, _G["WW"..i]()) end end

if #tickets > 0 then applyTicket(tickets, true) end

if MH[8] then Mahmoud() end
if MH[9] then Home() end
if MH[10] then EXIT() end

HERO = -1
end

--اكواد تصفير الوقت
function U10 ()
lastMenu = U10
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟  تصفير وقت المحاصيل ثابت 𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟    تصفير وقت الطائره ثابت    𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟 تصفير وقت الحيوانات ثابت  𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟     تصفير وقت البناء ثابت     𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟         زيادة الشونه ثابت        𝄟 \n╚═══════════════╝",--5
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣?? \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--8
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

if not MH then return end
    local tickets = {}
    if MH[1]  then table.insert(tickets, WWW1())  end
    if MH[2]  then table.insert(tickets, WWW2())  end
    if MH[3]  then table.insert(tickets, WWW3())  end
    if MH[4]  then WWW4() end -- 👹MAHMOUDHERO👹
    if MH[5]  then WWW5() end -- 👹MAHMOUDHERO👹
    
    

    if #tickets > 0 then applyTicket(tickets, false) end
    if MH[6] then Mahmoud() end -- 👹MAHMOUDHERO👹
    if MH[7] then Home() end -- 👹MAHMOUDHERO👹
    if MH[8] then EXIT() end -- 👹MAHMOUDHERO👹

    HERO = -1
end


--الغاز الشمال
-- طاقه وقمبله 
function U11 ()
lastMenu = U11
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                معزز الطاقه           𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                معزز القنبله           𝄟 \n╚═══════════════╝",--2
    "╔══════⟬⚜️⟭══════╗\n𝄟      العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--5
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U11 then else
if MH[1]== true then W1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then W2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[5]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹


--ذهب وكاش واحداث 
function U12 ()
lastMenu = U12
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟              كود الكاش              𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟             كود الفلوس             𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟            كود المستوى            𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟         كود الكاتب الأول          𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟 كود زيادة نقاط حدث الإطار   𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟 كود زيادة نقاط حدث الاسم   𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟     مضاعف الحدث               𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟     مضاعفة خام المنجم        𝄟 \n╚═══════════════╝",--8
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--9
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--10
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--11
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊  ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U12 then else
if MH[1]== true then G1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then G2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then G3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then G4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then G5() end -- 👹MAHMOUDHERO👹
if MH[6]== true then G6() end -- 👹MAHMOUDHERO👹
if MH[7]== true then G7() end -- 👹MAHMOUDHERO👹
if MH[8]== true then G8() end -- 👹MAHMOUDHERO👹
if MH[9]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[10]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[11]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹


--اكواد كيس الكروت 
function U13 ()
lastMenu = U13
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟          الكيس البرونزي           𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟           الكيس الأخضر           𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟            الكيس الأزرق            𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟         الكيس البنفسجي          𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟             الكيس الذهبي          𝄟 \n╚═══════════════╝",--5
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--8
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U13 then else
if MH[1]== true then Cartas1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then Cartas2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then Cartas3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Cartas4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then Cartas5() end -- 👹MAHMOUDHERO👹
if MH[6]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[7]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[8]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹


--اكواد القطار والمحطه
function U14 ()
lastMenu = U14
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟             اكواد القطار             𝄟\n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟           اكواد المحطه             𝄟\n╚═══════════════╝",--2
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--5
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U14 then else
if MH[1]== true then GG1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then GG2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[5]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹



-- القطار 🚂
function GG1()
    lastMenu = GG1
    MH = gg.multiChoice({
        "╔══════⟬⚜️⟭══════╗\n𝄟        قطار فائق السرعة          𝄟\n╚═══════════════╝",--1
        "╔══════⟬⚜️⟭══════╗\n𝄟             قطار الأشباح            𝄟\n╚═══════════════╝",--2
        "╔══════⟬⚜️⟭══════╗\n𝄟            قطار الديسكو            𝄟\n╚═══════════════╝",--3
        "╔══════⟬⚜️⟭══════╗\n𝄟           قطار رعاة البقر           𝄟\n╚═══════════════╝",--4
        "╔══════⟬⚜️⟭══════╗\n𝄟         قطار الكريسماس          𝄟\n╚═══════════════╝",--5
        "╔══════⟬⚜️⟭══════╗\n𝄟    قطار عيد الفصح السريع     𝄟\n╚═══════════════╝",--6
        "╔══════⟬⚜️⟭══════╗\n𝄟          قطار بدائي سريع         𝄟\n╚═══════════════╝",--7
        "╔══════⟬⚜️⟭══════╗\n𝄟        قطار مسرحي سريع       𝄟\n╚═══════════════╝",--8
        "╔══════⟬⚜️⟭══════╗\n𝄟             قطار التنين              𝄟\n╚═══════════════╝",--9
        "╔══════⟬⚜️⟭══════╗\n𝄟         قطار مسبار المريخ        𝄟\n╚═══════════════╝",--10
        "╔══════⟬⚜️⟭══════╗\n𝄟       قطار العربة الخشبيه       𝄟\n╚═══════════════╝",--11
        "╔══════⟬⚜️⟭══════╗\n𝄟     قطار الموسيقى السريع      𝄟\n╚═══════════════╝",--12
        "╔══════⟬⚜️⟭══════╗\n𝄟             قطار الفرسان           𝄟\n╚═══════════════╝",--13
        "╔══════⟬⚜️⟭══════╗\n𝄟         قطار الترام السريع        𝄟\n╚═══════════════╝",--14
        "╔══════⟬⚜️⟭══════╗\n𝄟              قطار الهالوين          𝄟\n╚═══════════════╝",--15
        "╔══════⟬⚜️⟭══════╗\n𝄟          قطار عيد الميلاد         𝄟\n╚═══════════════╝",--16
        "╔══════⟬⚜️⟭══════╗\n𝄟               قطار الزهور           𝄟\n╚═══════════════╝",--17
        "╔══════⟬⚜️⟭══════╗\n𝄟          القطار الأسطوري         𝄟\n╚═══════════════╝",--18
        "╔══════⟬⚜️⟭══════╗\n𝄟             قطار غاتسبي           𝄟\n╚═══════════════╝",--19
        "╔══════⟬⚜️⟭══════╗\n𝄟           القطار الفرنسي           𝄟\n╚═══════════════╝",--20
        "╔══════⟬⚜️⟭══════╗\n𝄟            قطار المشاهير           𝄟\n╚═══════════════╝",--21
        "╔══════⟬⚜️⟭══════╗\n𝄟            قطار مستقبلي           𝄟\n╚═══════════════╝",--22
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع القطارات 🟡𝄟\n╚═══════════════╝",--
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
    }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝?? ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 22
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Train"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Train"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "القطار")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end




--محطة القطار 
    function GG2()
    lastMenu = GG2
    MH = gg.multiChoice({
        "╔══════⟬⚜️⟭══════╗\n𝄟        بوابة القطار السريع        𝄟\n╚═══════════════╝",--1
        "╔══════⟬⚜️⟭══════╗\n𝄟            محطة الأشباح           𝄟\n╚═══════════════╝",--2
        "╔══════⟬⚜️⟭══════╗\n𝄟           محطة الديسكو           𝄟\n╚═══════════════╝",--3
        "╔══════⟬⚜️⟭══════╗\n𝄟         محطة رعاة البقر           𝄟\n╚═══════════════╝",--4
        "╔══════⟬⚜️⟭══════╗\n𝄟       محطة الكريسماس          𝄟\n╚═══════════════╝",--5
        "╔══════⟬⚜️⟭══════╗\n𝄟        محطة عيد الفصح          𝄟\n╚═══════════════╝",--6
        "╔══════⟬⚜️⟭══════╗\n𝄟          مستوطنة قديمة          𝄟\n╚═══════════════╝",--7
        "╔══════⟬⚜️⟭══════╗\n𝄟           محطة مسرحية          𝄟\n╚═══════════════╝",--8
        "╔══════⟬⚜️⟭══════╗\n𝄟            محطة صينية            𝄟\n╚═══════════════╝",--9
        "╔══════⟬⚜️⟭══════╗\n𝄟              محطة فضاء            𝄟\n╚═══════════════╝",--10
        "╔══════⟬⚜️⟭══════╗\n𝄟           معسكر التدريب          𝄟\n╚═══════════════╝",--11
        "╔══════⟬⚜️⟭══════╗\n𝄟            مركز التسجيل           𝄟\n╚═══════════════╝",--12
        "╔══════⟬⚜️⟭══════╗\n𝄟             محطة القلعة            𝄟\n╚═══════════════╝",--13
        "╔══════⟬⚜️⟭══════╗\n𝄟           محطة رومانيه           𝄟\n╚═══════════════╝",--14
        "╔══════⟬⚜️⟭══════╗\n𝄟           محطة الهالوين           𝄟\n╚═══════════════╝",--15
        "╔══════⟬⚜️⟭══════╗\n𝄟        محطة عيد الميلاد         𝄟\n╚═══════════════╝",--16
        "╔══════⟬⚜️⟭══════╗\n𝄟            محطة الزهور            𝄟\n╚═══════════════╝",--17
        "╔══════⟬⚜️⟭══════╗\n𝄟       المحطة الأسطورية         𝄟\n╚═══════════════╝",--18
        "╔══════⟬⚜️⟭══════╗\n𝄟            محطة غاتسبي          𝄟\n╚═══════════════╝",--19
        "╔══════⟬⚜️⟭══════╗\n𝄟        المحطة الفرنسية           𝄟\n╚═══════════════╝",--20
        "╔══════⟬⚜️⟭══════╗\n𝄟         محطة مستقبلي           𝄟\n╚═══════════════╝",--21
        "╔══════⟬⚜️⟭══════╗\n𝄟          محطه المشاهير           𝄟\n╚═══════════════╝",--22
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع المحطات🟡 𝄟\n╚═══════════════╝",--
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
    }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 22
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Station"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Station"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "المحطة")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end



--اكواد الميناء والمركب
function U15 ()
lastMenu = U15
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟             اكواد الميناء            𝄟\n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟            اكواد المركب            𝄟\n╚═══════════════╝",--2
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--5
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U15 then else
if MH[1]== true then BB1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then BB2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[5]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹



-- الميناء 
function BB1 ()
lastMenu = BB1
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟           ميناء القرصان           𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟           ميناء إستوائي           𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟               ميناء جميل           𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟              رصيف اللورد          𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟              ميناء الأهوال          𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟           ميناء الرومانسية        𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟              ميناء الفايكينج        𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟                  ميناء الغابة         𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟         ميناء الكريسماس          𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟             ميناء الفوانيس         𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟                   ميناء قديم         𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟            صالون على الماء        𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟             ميناء الحلوى            𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟    ميناء ذو الطابع المصري      𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟        ميناء القطب الشمالي      𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟                 ميناء العطله         𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟              الميناء الياباني         𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟              ميناء الفارس           𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟              ميناء برودواي         𝄟\n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟           ميناء عيد الفصح        𝄟\n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع المواني  🟡𝄟 \n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--23
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--24
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 20
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Port"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Port"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الميناء")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end

--المركب 
function BB2 ()
lastMenu = BB2
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟           سفينة القرصان           𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟            سفينة سياحية           𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟           عبارة كرواسون           𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟                   جندول              𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟             سفينة الأشباح          𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟                قارب الحب           𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟                سفينة قوية          𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟            سفينة سياحية          𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟              قارب الهدايا            𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟               قارب التنين            𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟              سفينة يونانية          𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟                باخرة نهرية           𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟               قارب الحلوى           𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟   سفينة ذات الطابع المصري   𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟       سفينه القطب الشمالي     𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟             سفينه العطله           𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟           السفينه اليابانيه         𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟             سفينة الفارس          𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟           سفينة برودواي          𝄟\n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟        سفينة عيد الفصح         𝄟\n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع السفن   🟡𝄟 \n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--23
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--24
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 20
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Ship"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Ship"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "المركب")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end



--اكود الطائره والمطار 
function U16 ()
lastMenu = U16
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟            اكواد الطائره             𝄟\n╚═══════════════╝",--1
    "╔══════⟬⚜️⟭══════╗\n𝄟             اكواد المطار             𝄟\n╚═══════════════╝",--2
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--5
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U16 then else
if MH[1]== true then VV1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then VV2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[5]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹




--اكود الطائره 
function VV1 ()
lastMenu = VV1
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟           الطائرة الضخمة          𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟                تنين خارق            𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟           طائرة استوائية          𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟             طائرة الأشباح          𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟               مركبة إطلاق          𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟                 طائرة روك           𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟              طائرة النجوم          𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟               طائرة الأعياد          ??\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟       طائرة على شكل طائر      𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟              طائرة الإكلير           𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟              زلاجة هوائية          𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟                طائرة الحظ          𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟                 طائرة شبح          𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟                طائرة مائية          𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟           طائرة السيمفونية       𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟              طائرة الموضة         𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟       طائرة مصاصة الدماء      𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟             طائرة الكرنفال         𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟                طائرة الطهي         𝄟\n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار جميع الطائرات🟡𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 19
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Airplane"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Airplane"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الطائرات")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end



--اكواد المطار 
function VV2 ()
lastMenu = VV2
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟             البوابة الجوية           𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟            مطار المهرجان           𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟             مطار استوائي           𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟              مطار الأشباح           𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟               ميناء فضائي          𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟                  مطار روك           𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟             مطار سينمائي          𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟                مسكن سانتا          𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟                مطار الفصح          𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟               مطار الحلوى          𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟                 مركز التزلج          𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟          مطار قوس قزح           𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟                قاعدة سرية           𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟          مطار خمس نجوم         𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟           مطار السيمفونية         𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟              مطار الموضة           𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟              مطار دراكولا           𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟             مطار الكرنفال           𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟               مطار الطهي           𝄟\n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار جميع المطارات🟡𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 19
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Airport"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Airport"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "المطارات")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end



--اكود الهليكوبتر والمهبط
function U17 ()
lastMenu = U17
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟      اكواد طائرة الهليكوبتر      𝄟\n╚═══════════════╝",--1
    "╔══════⟬⚜️⟭══════╗\n𝄟  اكواد مهبط طائرة الهليكوبتر 𝄟\n╚═══════════════╝",--2
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--5
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 ?? 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U17 then else
if MH[1]== true then NN1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then NN2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[5]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO??




--هليكوبتر
function NN1 ()
lastMenu = NN1
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟                 طبق تربو             𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟                موصل آلي            𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟                مزلقة سانتا           𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟      طائرة هليكوبتر خاصة      𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟  الطائره الهليكوبتر الباذنجانة  𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟                بساط طائر            𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟      طائرة على شكل أريكة      𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟              السفينة الطائرة        𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟    طائرة هليكوبتر دراجة        𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟  طائرة هليكوبتر قرع العسل   𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟              المرجل الطائر          𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟      طائرة هليكوبتر ريشية      𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟             قطاعة البيض           𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟      غواصة الأعماق الطائرة     𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟    طائرة هليكوبتر للقراصنة    𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟 الطائرة الهليكوبتر الإحتفالية  𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟طائرة الهليكوبتر لقاعة الرقص 𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟    طائرة الديسكو الهليكوبتر   𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟     طائرة الفضاء الهليكوبتر    𝄟\n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟طائرة هليكوبتر الروك آند رول𝄟\n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟      مروحية الكريسماس       𝄟\n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟           مروحية الربيع          𝄟\n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟           مروحية ايطالية        𝄟\n╚═══════════════╝",--23
"╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع الهليكوبتر🟡?? \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 23
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Helicopter"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Helicopter"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الهليكوبتر")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end







--مهبط
function NN2 ()
lastMenu = NN2
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟          حظيرة الطبق الطائر     𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟           محطة رسو سفن        𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟              موقف المزلقة         𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟 مهبط طائرات هليكوبتر خاص𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟 مهبط طائرة هليكوبتر النباتي 𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟            قصر السلطان            𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟مهبط طائرة هليكوبتر 5 نجوم𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟           ميناء المتجولين         𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟            مهبط رياضي            𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟               القصر الملكي          𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟             البرج المسكون          𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟            منصة الكرنفال           𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟        مهبط طائرات الفصح      𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟              قصر الأعماق           𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟              مهبط القراصنة       𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟   مهبط الطائرة الاحتفالية      𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟  مهبط طائرة لقاعة الرقص     𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟    مهبط هليكوبتر الديسكو     𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟 مهبط طائرة الفضاء الهليكوبتر𝄟\n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟   مهبط طائرة الروك آند رول  𝄟\n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟    مهبط طائرة الكريسماس    𝄟\n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟               مهبط الربيع          𝄟\n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟             حظيرة ايطالية        𝄟\n╚═══════════════╝",--23
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع المهابط 🟡𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴  ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 23
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Helipad"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Helipad"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "المهابط")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end




--اكواد الجزيرة 
function U18 ()
lastMenu = U18
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟            كوخ القراصنة            𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟             مركز القراصنة          𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟           حصن القراصنة           𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟             منزل الجزيره            𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟            قصر الجزيرة             𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟           مسكن الجزيرة           𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟           منزل الساحرة            𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟             قصر الساحرة           𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟             قلعة الساحرة            𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟            القلعة الجليدية          𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟            باريس صغيرة           𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟          قرية عيد الفصح          𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟     جزيرة الإنسان البدائي       𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟             جزيرة الآزتك           𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟            جزيرة العطلات         𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟🟡    اختيار جميع الجزر  🟡𝄟 \n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--19
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 15
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Island"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Island"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الجزر")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end



--اكواد الإبقار
function U19 ()
lastMenu = U19
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟            بقرة سينمائية            𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟              البقرة القزمة            𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟               بقرة مغازلة             𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟         البقرة رائدة الفضاء        𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟           بقرة الاحتفالات          𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟       البقرة صانعة الحلويات    𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟                مو-سفيراتو           𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟                 بقرة جبلية           𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟              بقرة احتفالية          𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟               بقرة الفصح            𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟              بقرة جاسوسة          𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟             ملكة أطلانتس          𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟                  بقرة أنيقة           𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟               بقرة احتفالية         𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟      بقرة القراصنة المعتمدين   𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟         بقرة القطب الشمالي      𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟              بقرة السيمفونية      𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟                بقرة الزهور           𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟             البقرة اليابانية          𝄟\n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟    بقرة الروك آند رول للأبقار   𝄟\n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟            البقرة الفرنسية          𝄟\n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟              بقرة الكرنفال          𝄟\n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟             بقرة المشاهير          𝄟\n╚═══════════════╝",--23
"╔══════⟬⚜️⟭══════╗\n𝄟            بقرة مستقبلية          𝄟\n╚═══════════════╝",--24
"╔══════⟬⚜️⟭══════╗\n𝄟🟡   اختيار جميع الأبقار  🟡𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 24
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Cow"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Cow"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الإبقار")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end


--اكواد الدجاجه
function U20()
  lastMenu = U20
  MH = gg.multiChoice({
    "╔══════⟬⚜️⟭══════╗\n𝄟            دجاجة طيارة            𝄟\n╚═══════════════╝",--1
    "╔══════⟬⚜️⟭══════╗\n𝄟            الدجاج المهرج           𝄟\n╚═══════════════╝",--2
    "╔══════⟬⚜️⟭══════╗\n𝄟           الدجاجة المشجعة       𝄟\n╚═══════════════╝",--3
    "╔══════⟬⚜️⟭══════╗\n𝄟           الدجاجة الخيالية        𝄟\n╚═══════════════╝",--4
    "╔══════⟬⚜️⟭══════╗\n𝄟          الدجاجة المستكشفة     𝄟\n╚═══════════════╝",--5
    "╔══════⟬⚜️⟭══════╗\n𝄟         دجاجة عيد الميلاد        𝄟\n╚═══════════════╝",--6
    "╔══════⟬⚜️⟭══════╗\n𝄟        مساعد سانتا الصغير       𝄟\n╚═══════════════╝",--7
    "╔══════⟬⚜️⟭══════╗\n𝄟           دجاجة جنية              𝄟\n╚═══════════════╝",--8
    "╔══════⟬⚜️⟭══════╗\n𝄟        دجاجة بثوب يوناني      𝄟\n╚═══════════════╝",--9
    "╔══════⟬⚜️⟭══════╗\n𝄟         دجاجة في إجازة          𝄟\n╚═══════════════╝",--10
    "╔══════⟬⚜️⟭══════╗\n𝄟          دجاجة احتفالية          𝄟\n╚═══════════════╝",--11
    "╔══════⟬⚜️⟭══════╗\n𝄟           دجاجة الحفلات         𝄟\n╚═══════════════╝",--12
    "╔══════⟬⚜️⟭══════╗\n𝄟          دجاجة الهالوين           𝄟\n╚═══════════════╝",--13
    "╔══════⟬⚜️⟭══════╗\n𝄟        الدجاجة الاحتفالية        𝄟\n╚═══════════════╝",--14
    "╔══════⟬⚜️⟭══════╗\n𝄟          دجاجة الموضة            𝄟\n╚═══════════════╝",--15
    "╔══════⟬⚜️⟭══════╗\n𝄟           دجاجة الديسكو          𝄟\n╚═══════════════╝",--16
    "╔══════⟬⚜️⟭══════╗\n𝄟           دجاجة الفضاء            𝄟\n╚═══════════════╝",--17
    "╔══════⟬⚜️⟭══════╗\n𝄟نظارات شمسية الروك آند رول 𝄟\n╚═══════════════╝",--18
    "╔══════⟬⚜️⟭══════╗\n𝄟        دجاجة الروك آند رول     𝄟\n╚═══════════════╝",--19
    "╔══════⟬⚜️⟭══════╗\n𝄟           دجاجة الفارس           𝄟\n╚═══════════════╝",--20
    "╔══════⟬⚜️⟭══════╗\n𝄟      دجاجة الكريسماس          𝄟\n╚═══════════════╝",--21
    "╔══════⟬⚜️⟭══════╗\n𝄟          دجاجة برودواي          𝄟\n╚═══════════════╝",--22
    "╔══════⟬⚜️⟭══════╗\n𝄟      دجاجة عيد الفصح          𝄟\n╚═══════════════╝",--23
    "╔══════⟬⚜️⟭══════╗\n𝄟             دجاجة الطهي          𝄟\n╚═══════════════╝",--24
    "╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع الدجاجات🟡𝄟 \n╚═══════════════╝",--
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
    "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
    "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
  }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 24
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Chicken"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Chicken"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الدجاجة")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end


--اكواد الخرفان 
function U21()
  lastMenu = U21
  MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟          النعجة الساحرة            𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟      نعجة مهرجان الربيع         𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n??         نعجة الفصح                 𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟          خروف شمالي              𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟         الخروف المحقق            𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟      خروف عيد الميلاد           𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟     خروف بانديت النبيله        𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟         خروف السامبا              𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟      خروف الروك آند رول       𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟         الخروف المقاتل            𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟        عصابة الخرفان              𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟             بيلي بونكا               𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟          خروف احتفالي           𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟         الخراف المصرية           𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟       خروف عيد الميلاد          𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟       خراف قاعة الرقص         𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟       خروف غاتسبي               𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟       خروف مصاص الدماء      𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟 نظارات شمسية الروك آند رول𝄟\n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟       الخروف الأسطوري         𝄟\n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟          خروف العطلة             𝄟\n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟       خروف نجم الروك           𝄟\n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟              خروف الربيع           𝄟\n╚═══════════════╝",--23
"╔══════⟬⚜️⟭══════╗\n𝄟            خروف ايطالي           𝄟\n╚═══════════════╝",--24
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع الخرفان🟡𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
  }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ ?? 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 24
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Sheep"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Sheep"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الخروف")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end




-- اكواد الخنازير 
function U22()
  lastMenu = U22
  MH = gg.multiChoice({
    "╔══════⟬⚜️⟭══════╗\n𝄟         الخنزير الكيوبيد           𝄟\n╚═══════════════╝",--1
    "╔══════⟬⚜️⟭══════╗\n𝄟         الخنزير احتفالي           𝄟\n╚═══════════════╝",--2   
    "╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار جميع الخنازير 🟡𝄟 \n╚═══════════════╝",--3
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--4
    "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--5
    "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--6
  }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 2
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Pigs"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Pigs"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الخنازير")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡------


-- اكواد اللوحات
function U23()
  lastMenu = U23
  MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟      مدينة عيد الميلاد            𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟      طيران المدينة                 𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟   مدينة بطابع خيالي             𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟   مدينة بشاشة كبيرة            𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟          أعياد الربيع                 𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟    معكم على الهواء مباشرة     𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟     مدينة التفاحة الكبيرة        𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟     مدينة الهالوين الكبيرة       𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟   علامة المدينة في الميلاد     𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟      تزلج على الجليد              ??\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟     مدينة منزل مريح             𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟        مدينة الروك                  𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟       العلكة للجميع                 𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟      كشك المشروبات              𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟     مدينة عشرة سنوات          𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟       تحية المدينة                  𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟       مزرعة قديمة                  𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟        عيد المدينة                   𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟        وحش مطاطي              𝄟\n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟        رائعة قديمة                  𝄟\n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟      مدينة لا تنام                   𝄟\n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟      مدينة القراصنة                𝄟\n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟      علامة المدينة الخفية        𝄟\n╚═══════════════╝",--23
"╔══════⟬⚜️⟭══════╗\n𝄟 المدينة الخارقة للطبيعة         𝄟\n╚═══════════════╝",--24
"╔══════⟬⚜️⟭══════╗\n𝄟     مدينة كثوتون                  𝄟\n╚═══════════════╝",--25
"╔══════⟬⚜️⟭══════╗\n𝄟     مدينة العطلات                 𝄟\n╚═══════════════╝",--26
"╔══════⟬⚜️⟭══════╗\n𝄟     المدينة الشتوية                𝄟\n╚═══════════════╝",--27
"╔══════⟬⚜️⟭══════╗\n𝄟 المدينة خارج كوكب الأرض    𝄟\n╚═══════════════╝",--28
"╔══════⟬⚜️⟭══════╗\n𝄟     شعار المدينة الشبحية        𝄟\n╚═══════════════╝",--29
"╔══════⟬⚜️⟭══════╗\n𝄟     المدينة القرمزية                𝄟\n╚═══════════════╝",--30
"╔══════⟬⚜️⟭══════╗\n𝄟     المدينة الصحراوية            𝄟\n╚═══════════════╝",--31
"╔══════⟬⚜️⟭══════╗\n𝄟    مدينة راعي البقر                ??\n╚═══════════════╝",--32
"╔══════⟬⚜️⟭══════╗\n𝄟   علامة مدينة قوة الأجداد      𝄟\n╚═══════════════╝",--33
"╔══════⟬⚜️⟭══════╗\n𝄟      مدينة أطلانتس                𝄟\n╚═══════════════╝",--34
"╔══════⟬⚜️⟭══════╗\n𝄟 مدينة بطابع الحديقة الذكية   𝄟\n╚═══════════════╝",--35
"╔══════⟬⚜️⟭══════╗\n𝄟  مدينة بتصميم حلوى            𝄟\n╚═══════════════╝",--36
"╔══════⟬⚜️⟭══════╗\n𝄟 مدينة منتجع البطاريق           𝄟\n╚═══════════════╝",--37
"╔══════⟬⚜️⟭══════╗\n𝄟      علامة هالوين كبيرة          𝄟\n╚═══════════════╝",--38
"╔══════⟬⚜️⟭══════╗\n𝄟 بلدة العجائب الشتوية            𝄟\n╚═══════════════╝",--39
"╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار جميع اللوحات 🟡𝄟 \n╚═══════════════╝",--40
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--41
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--42
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--43
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 39
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Sign"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Sign"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "اللوحات")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡------


-- اكواد الديكورات التماثيل 
function U24 ()
lastMenu = U24
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟   ديكورات حدث الاستكشاف 𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟        ديكورات حدث الدمج    𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟 حدث الاستكشاف قاعده تكرار𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟      حدث الدمج قاعده تكرار  𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--7
    
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 ?? 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== Home then else
if MH[1]== true then Decorations1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then Decorations2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then Decorationss1() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Decorationss2() end -- 👹MAHMOUDHERO👹
if MH[5]== true then Mahmoud() end -- ??MAHMOUDHERO👹
if MH[6]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[7]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹




--☆ديكورات الرحلة الإستكشافية☆
--مؤشرات 

function Decorations1()
    lastMenu = Decorations1
    MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟      أبطال الحديقة القديمة     𝄟 \n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟       ملكة جزيرة السلحفاه      𝄟 \n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟             حارس الشمال          𝄟 \n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟           أوديسة القراصنة        𝄟 \n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟    ميجالوث الوحش الثلجي    𝄟 \n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟 منتجع فندقي أسرار كليوباترا 𝄟 \n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟       متنزه ترفيهي نباتي         ?? \n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟    متحف مملكة بوسيدون      𝄟 \n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟  مركز أبحاث الحالات الشاذة  𝄟 \n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟             قصر ذكي                𝄟 \n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟   منزل الغزال الذهبي الريفي  𝄟 \n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟      تمثال نافورة اللوتس        𝄟 \n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟      مسرح باندورا القديم        𝄟 \n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟       صوبة ملكة الدبابير         𝄟 \n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟      منشأة أبحاث فضائية       𝄟 \n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟            مكتبة الشجرة           𝄟 \n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟            قاعدة التخييم           𝄟 \n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟              مقهى كوني             𝄟 \n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟   حديقة أرض القرود المائية   𝄟 \n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟              ملاذ جبلي               𝄟 \n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟        حديقة ترفيهية رائعة      𝄟 \n╚═══════════════╝",--21     
"╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار كل الديكورات 🟡𝄟 \n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--23
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--24
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--25
    }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

    if not MH then return end
    local total = 21
    local list = {}

    for i = 1, total do if MH[i] then list[#list + 1] = _G["Expedition"..i] end end
    
    if MH[total + 1] and #list == 0 then 
        HERO = 22 
        for i = 1, total do list[#list + 1] = _G["Expedition"..i] end 
    end
    
    if #list == 1 then list[1]() return end 
    if #list > 1 then applyAllWithTracking(list, "رحلة استكشافية") return end

    if MH[total + 2] then Mahmoud() end
    if MH[total + 3] then Home() end
    if MH[total + 4] then EXIT() end

    HERO = -1
end


function Expedition1()
    if HERO == 22 then
        for i = 1, 3 do _G["Mahmoud"..i]() end        
        return
    end

    local hero = gg.multiChoice({
        "╔══════════════════╗\n𝄟 ❁ التمثال الأول ❁ 𝄟 \n╚══════════════════╝",
        "╔══════════════════╗\n𝄟 ❁ التمثال الثاني ❁ 𝄟 \n╚══════════════════╝",
        "╔══════════════════╗\n𝄟 ❁ التمثال الثالث ❁ 𝄟 \n╚══════════════════╝",
        "╔══════════════════╗\n𝄟 ❁ رجـــــــــــــــــــوع ❁ 𝄟 \n╚══════════════════╝",
    }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫ 𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

    if not hero then return end

    if hero[1] then Mahmoud1() end
    if hero[2] then Mahmoud2() end
    if hero[3] then Mahmoud3() end
    if hero[4] then Decorations1() end

    HERO = -1
end
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡------

--☆ديكورات الرحلة الإستكشافية☆

--اكواد التكرار 
function Decorationss1()
    lastMenu = Decorationss1
    MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟      أبطال الحديقة القديمة     𝄟 \n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟       ملكة جزيرة السلحفاه      𝄟 \n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟             حارس الشمال          𝄟 \n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟           أوديسة القراصنة        𝄟 \n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟    ميجالوث الوحش الثلجي    𝄟 \n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟 منتجع فندقي أسرار كليوباترا 𝄟 \n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟       متنزه ترفيهي نباتي         𝄟 \n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟    متحف مملكة بوسيدون      𝄟 \n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟  مركز أبحاث الحالات الشاذة  𝄟 \n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟             قصر ذكي                𝄟 \n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟   منزل الغزال الذهبي الريفي  𝄟 \n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟      تمثال نافورة اللوتس        𝄟 \n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟      مسرح باندورا القديم        𝄟 \n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟       صوبة ملكة الدبابير         𝄟 \n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟      منشأة أبحاث فضائية       𝄟 \n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟            مكتبة الشجرة           𝄟 \n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟            قاعدة التخييم           𝄟 \n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟              مقهى كوني             𝄟 \n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n??   حديقة أرض القرود المائية   𝄟 \n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟              ملاذ جبلي               𝄟 \n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟        حديقة ترفيهية رائعة      𝄟 \n╚═══════════════╝",--21     
"╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار كل الديكورات 🟡𝄟 \n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--23
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--24
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--25
    }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

  if not MH then return end
  if MH[22] then
   local expeditionns = {}  for i = 1, 21 do expeditionns[i] = _G["Expeditionn"..i] end
  applyAllWithTracking(expeditionns, "رحلة استكشافية")return end

 
  for i = 1, 21 do if MH[i] then _G["Expeditionn"..i]() end end
  if MH[23] then Mahmoud() end
  if MH[24] then Home() end
  if MH[25] then EXIT() end

  HERO = -1
end

----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡------

------قسم ديكورات الدمج------
-- اكواد المؤشرات 
function Decorations2 ()
lastMenu = Decorations2
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟              سنترال بارك           𝄟 \n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟      مركز المجتمع الصيني      𝄟 \n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟    حديقة بيئية قوس قزح      𝄟 \n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟             جولة الزواقة            𝄟 \n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟          المعرض الزراعي          𝄟 \n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟             مجمع رياضي           𝄟 \n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟              عالم البطريق           𝄟 \n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟     صالة ديسكو كلاسيكية      𝄟 \n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟معرض الفنون والحرف اليدوية𝄟 \n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟          موقع مخيم مريح        𝄟 \n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟              حفل شاطئي           𝄟 \n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟              قلب ايطالي             𝄟 \n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار كل الديكورات 🟡𝄟 \n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n??🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--16
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
  if MH[13] then
   local merges = {}  for i = 1, 12 do merges[i] = _G["Merge"..i] end
  applyAllWithTracking(merges, "حدث الدمج")return end

 
  for i = 1, 12 do if MH[i] then _G["Merge"..i]() end end
  if MH[14] then Mahmoud() end
  if MH[15] then Home() end
  if MH[16] then EXIT() end

  HERO = -1
end

----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡------


------قسم ديكورات الدمج------
-- اكواد التكرار
function Decorationss2 ()
lastMenu = Decorationss2
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟              سنترال بارك           𝄟 \n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟      مركز المجتمع الصيني      𝄟 \n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟    حديقة بيئية قوس قزح      𝄟 \n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟             جولة الزواقة            𝄟 \n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟          المعرض الزراعي          𝄟 \n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟             مجمع رياضي           𝄟 \n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟              عالم البطريق           𝄟 \n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟     صالة ديسكو كلاسيكية      𝄟 \n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟معرض الفنون والحرف اليدوية𝄟 \n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟          موقع مخيم مريح        𝄟 \n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟              حفل شاطئي           𝄟 \n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟              قلب ايطالي             𝄟 \n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار كل الديكورات 🟡𝄟 \n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n??🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--16
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
  if MH[13] then
   local mergees = {}  for i = 1, 12 do mergees[i] = _G["Mergee"..i] end
  applyAllWithTracking(mergees, "رحلة استكشافية")return end
 
  for i = 1, 12 do if MH[i] then _G["Mergee"..i]() end end
  if MH[14] then Mahmoud() end
  if MH[15] then Home() end
  if MH[16] then EXIT() end

  HERO = -1
end

----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------



--اكواد الإطار 
function U25 ()
    
    local warn = gg.alert(
        "⚠️⚠️ تحذير خطير ⚠️⚠️\n" ..
        "━━━━━━━━━━━━━━━━━━━\n" ..
        "❌ أكواد الإطار ❌\n\n" ..
        "🔴 بعد التحديث الأخير، هذه الأكواد\n" ..
        "تسبب حظر لعبتك بشكل دائم!\n\n" ..
        "📛 استخدامها = فقدان الحساب\n" ..
        "━━━━━━━━━━━━━━━━━━━\n" ..
        "هل تريد المتابعة على مسؤوليتك؟",
        "❌ إلغاء (آمن)",
        "⚠️ متابعة (خطر)"
    )

    if warn == 1 or warn == nil then
        gg.toast("✅ تم الإلغاء - حسابك بأمان")
        Home()   
        return
    elseif warn == 2 then
        local confirm = gg.alert(
            "🛑 تأكيد نهائي 🛑\n\n" ..
            "أنت على وشك تنفيذ أكواد الإطار\n" ..
            "قد تؤدي إلى حظر حسابك!\n\n" ..
            "هل أنت متأكد 100%؟",
            "لا، إلغاء",
            "نعم، أنا متأكد"
        )
        if confirm ~= 2 then
            gg.toast("✅ تم الإلغاء")
            Home()  
            return
        end
        gg.toast("⚠️ جاري التنفيذ على مسؤوليتك...")
    end

    MH = gg.multiChoice({
        "╔══════⟬⚜️⟭══════╗\n𝄟             الإطار الوردي            𝄟 \n╚═══════════════╝",--1
        "╔══════⟬⚜️⟭══════╗\n𝄟              الإطار الازرق            𝄟 \n╚═══════════════╝",--2
        "╔══════⟬⚜️⟭══════╗\n𝄟             الإطار الثلجي            𝄟 \n╚═══════════════╝",--3
        "╔══════⟬⚜️⟭══════╗\n𝄟             الإطار الأحمر            𝄟 \n╚═══════════════╝",--4
        "╔══════⟬⚜️⟭══════╗\n𝄟               إطار الربيع             𝄟 \n╚═══════════════╝",--5
        "╔══════⟬⚜️⟭══════╗\n𝄟          إطار عيد الفصح          𝄟 \n╚═══════════════╝",--6
        "╔══════⟬⚜️⟭══════╗\n𝄟               إطار الناري             𝄟 \n╚═══════════════╝",--7
        "╔══════⟬⚜️⟭══════╗\n𝄟                إطار نيون             𝄟 \n╚═══════════════╝",--8
        "╔══════⟬⚜️⟭══════╗\n𝄟               إطار رقم 8            𝄟 \n╚═══════════════╝",--9
        "╔══════⟬⚜️⟭══════╗\n𝄟                إطار رقم 9           𝄟 \n╚═══════════════╝",--10
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع الإطارات 🟡𝄟 \n╚═══════════════╝",
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",
    }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
    if not MH then return end
    local total = 10
    local list = {}

    for i = 1, total do  if MH[i] then list[#list + 1] = _G["Style"..i] end  end
    if MH[total + 1] and #list == 0 then  for i = 1, total do list[i] = _G["Style"..i] end  end
   if #list == 1 then  list[1]() return  end  if #list > 1 then applyAllWithTracking(list, "الإطارات")  return  end
   
   if MH[total + 2] then Mahmoud() return end
   if MH[total + 3] then Home()  return end
   if MH[total + 4] then EXIT() return end

lastMenu = U25  
end



----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------


--النمط الاسم 
function U26 ()

local warn = gg.alert(
        "⚠️⚠️ تحذير خطير ⚠️⚠️\n" ..
        "━━━━━━━━━━━━━━━━━━━\n" ..
        "❌ أكواد الإطار ❌\n\n" ..
        "🔴 بعد التحديث الأخير، هذه الأكواد\n" ..
        "تسبب حظر لعبتك بشكل دائم!\n\n" ..
        "📛 استخدامها = فقدان الحساب\n" ..
        "━━━━━━━━━━━━━━━━━━━\n" ..
        "هل تريد المتابعة على مسؤوليتك؟",
        "❌ إلغاء (آمن)",
        "⚠️ متابعة (خطر)"
    )

    if warn == 1 or warn == nil then
        gg.toast("✅ تم الإلغاء - حسابك بأمان")
        Home()
        return
    elseif warn == 2 then
        local confirm = gg.alert(
            "🛑 تأكيد نهائي 🛑\n\n" ..
            "أنت على وشك تنفيذ أكواد الإطار\n" ..
            "قد تؤدي إلى حظر حسابك!\n\n" ..
            "هل أنت متأكد 100%؟",
            "لا، إلغاء",
            "نعم، أنا متأكد"
        )
        if confirm ~= 2 then
            gg.toast("✅ تم الإلغاء")
            Home()
            return
        end
        gg.toast("⚠️ جاري التنفيذ على مسؤوليتك...")
    end


MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟              نمط الوردي            𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟          نمط عيد الفصح          𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟              نمط الناري              𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟               نمط نيون             𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡   اختيار جميع النمط   🟡𝄟 \n╚═══════════════╝",--
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 4
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Frame"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Frame"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "النمط")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end


lastMenu = U26
end

----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------

--اكواد الشارات 
function U27 ()

local warn = gg.alert(
        "⚠️⚠️ تحذير خطير ⚠️⚠️\n" ..
        "━━━━━━━━━━━━━━━━━━━\n" ..
        "❌ أكواد الإطار ❌\n\n" ..
        "🔴 بعد التحديث الأخير، هذه الأكواد\n" ..
        "تسبب حظر لعبتك بشكل دائم!\n\n" ..
        "📛 استخدامها = فقدان الحساب\n" ..
        "━━━━━━━━━━━━━━━━━━━\n" ..
        "هل تريد المتابعة على مسؤوليتك؟",
        "❌ إلغاء (آمن)",
        "⚠️ متابعة (خطر)"
    )

    if warn == 1 or warn == nil then
        gg.toast("✅ تم الإلغاء - حسابك بأمان")
        Home()  
        return
    elseif warn == 2 then
        local confirm = gg.alert(
            "🛑 تأكيد نهائي 🛑\n\n" ..
            "أنت على وشك تنفيذ أكواد الإطار\n" ..
            "قد تؤدي إلى حظر حسابك!\n\n" ..
            "هل أنت متأكد 100%؟",
            "لا، إلغاء",
            "نعم، أنا متأكد"
        )
        if confirm ~= 2 then
            gg.toast("✅ تم الإلغاء")
            Home() 
            return
        end
        gg.toast("⚠️ جاري التنفيذ على مسؤوليتك...")
    end


MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟            شارة المدينة1           𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟     شارة البلدة الأسطورية 1    𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟            شارة المدينة 2           𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟     شارة البلدة الأسطورية 2    𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟                شارة الشتاء           𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟     شارة الشتاء الأسطورية      𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟                شارة الرحلة           𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟     شارة الرحلة الأسطورية      𝄟 \n╚═══════════════╝",--8
	"╔══════⟬⚜️⟭══════╗\n𝄟                شارة الربيع            𝄟 \n╚═══════════════╝",--9
	"╔══════⟬⚜️⟭══════╗\n𝄟      شارة الربيع الاسطورية      𝄟 \n╚═══════════════╝",--10
	"╔══════⟬⚜️⟭══════╗\n𝄟             شارة الطهي              𝄟 \n╚═══════════════╝",--11
	"╔══════⟬⚜️⟭══════╗\n𝄟      شارة الطهي الأسطورية     𝄟 \n╚═══════════════╝",--12
	"╔══════⟬⚜️⟭══════╗\n𝄟              شارة بطيخ احمر      𝄟 \n╚═══════════════╝",--13
	"╔══════⟬⚜️⟭══════╗\n𝄟             شارة بطيخ اخضر     𝄟 \n╚═══════════════╝",--14
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع الشارات 🟡𝄟 \n╚═══════════════╝",--
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 14
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Badge"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Badge"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الشارات")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

lastMenu = U27
end

----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
--اكواد الملصقات 
function U28 ()
lastMenu = U28
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟         البطة النعسانة        😴 𝄟 \n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟         خليط الفراولة        🍓 𝄟 \n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟  نحلة تختفي في الملابس 🐝𝄟 \n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟           بقرة الفشار           🐮𝄟 \n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟   خروف المهرجان الراقص🐑𝄟 \n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟    الديك الصيف المستريح 🐓𝄟 \n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟      الخضيرة الراقصة 🥬💃  𝄟 \n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟         النحلة الراقصة         🐝𝄟 \n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟       خنزير يلعب بالعملة    🐷𝄟 \n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟      بقرة تعزف على العود  🐮𝄟 \n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟        فرخة الصابون         🐔𝄟 \n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟    الخنزير يحتسي الشراب🐷𝄟 \n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟  بقرة على الدراجة النارية 🐮𝄟 \n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟        خروف وقناع الشبح 🐑𝄟 \n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟 مركب السماعة بالأذن ويرقص𝄟 \n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟               بقرة الفضاء      🐮 𝄟 \n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟         ضارب على الدفوف 🥁 𝄟 \n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟   خروج البطة تلقى بوسة 🦆 𝄟 \n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟        البقرة وعصا الكهرباء 🐮𝄟 \n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟  الديك الراقص بيده غصن 🐓𝄟 \n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟 صندوق الهدايا تخرج بقرة 🎁𝄟 \n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟   بقرة حلوة وسلة التسوق 🐮𝄟 \n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟          خنزير فوق الطيارة 🐷𝄟 \n╚═══════════════╝",--23
"╔══════⟬⚜️⟭══════╗\n𝄟    نحلة تحول سائل أزرق  🐝𝄟 \n╚═══════════════╝",--24
"╔══════⟬⚜️⟭══════╗\n𝄟          خروف وأداة بحث 🐑 𝄟 \n╚═══════════════╝",--25
"╔══════⟬⚜️⟭══════╗\n𝄟     بقرة تخرج من البيضة 🐮 ?? \n╚═══════════════╝",--26
"╔══════⟬⚜️⟭══════╗\n𝄟          فرخة وكرة الضوء 🐔 𝄟 \n╚═══════════════╝",--27
"╔══════⟬⚜️⟭══════╗\n𝄟               القبعة الساحرة 🎩 𝄟 \n╚═══════════════╝",--28
"╔══════⟬⚜️⟭══════╗\n𝄟                         لايك      👍 𝄟 \n╚═══════════════╝",--29
"╔══════⟬⚜️⟭══════╗\n𝄟         بطة تعطي إشارة لا 🦆 𝄟 \n╚═══════════════╝",--30
"╔══════⟬⚜️⟭══════╗\n𝄟            الديك الطاهي     🐓 𝄟 \n╚═══════════════╝",--31
"╔══════⟬⚜️⟭══════╗\n𝄟             تجديف القارب   🚣 𝄟 \n╚═══════════════╝",--32
"╔══════⟬⚜️⟭══════╗\n𝄟     قبعة الديك مع الغمزة  🐓 𝄟 \n╚═══════════════╝",--33
"╔══════⟬⚜️⟭══════╗\n𝄟          الخروف العازف      🐑𝄟 \n╚═══════════════╝",--34
"╔══════⟬⚜️⟭══════╗\n𝄟         الخروف المصري      🐑𝄟 \n╚═══════════════╝",--35
"╔══════⟬⚜️⟭══════╗\n𝄟      استعراض العضلات     💪𝄟 \n╚═══════════════╝",--36
"╔══════⟬⚜️⟭══════╗\n𝄟          البنت الراقصة        👧𝄟 \n╚═══════════════╝",--37
"╔══════⟬⚜️⟭══════╗\n𝄟        البوسة والقلب         ❤️𝄟 \n╚═══════════════╝",--38
"╔══════⟬⚜️⟭══════╗\n𝄟   الخروف يحطم التلفاز    🐑𝄟 \n╚═══════════════╝",--39
"╔══════⟬⚜️⟭══════╗\n𝄟       البقرة تزين الحلوى    🐮𝄟 \n╚═══════════════╝",--40
"╔══════⟬⚜️⟭══════╗\n𝄟 دجاجة تعزف على جيتار  🐔𝄟 \n╚═══════════════╝",--41
"╔══════⟬⚜️⟭══════╗\n𝄟            البقرة تقرأ           🐮𝄟 \n╚═══════════════╝",--42
"╔══════⟬⚜️⟭══════╗\n𝄟  النحلة والهدية المغلفة    🐝 𝄟 \n╚═══════════════╝",--43
"╔══════⟬⚜️⟭══════╗\n𝄟  نحلة تلعب على الزجاج    🐝𝄟 \n╚═══════════════╝",--44
"╔══════⟬⚜️⟭══════╗\n𝄟       بقرة تنظف الأذن        🐮𝄟 \n╚═══════════════╝",--45
"╔══════⟬⚜️⟭══════╗\n𝄟  بقرة تتحول إلى خفاش    🐮𝄟 \n╚═══════════════╝",--46
"╔══════⟬⚜️⟭══════╗\n𝄟          بقرة تصور              🐮𝄟 \n╚═══════════════╝",--47
"╔══════⟬⚜️⟭══════╗\n𝄟         البقرة السارقة          🐮𝄟 \n╚═══════════════╝",--48
"╔══════⟬⚜️⟭══════╗\n𝄟            بقرة الزينة           🐮 𝄟 \n╚═══════════════╝",--49
"╔══════⟬⚜️⟭══════╗\n𝄟          الخروف الطائر        🐑𝄟 \n╚═══════════════╝",--50
"╔══════⟬⚜️⟭══════╗\n𝄟          الخروف يزمر          🐑𝄟 \n╚═══════════════╝",--51
"╔══════⟬⚜️⟭══════╗\n𝄟    بقرة القلب تبتسم قلوب  🐮𝄟 \n╚═══════════════╝",--52
"╔══════⟬⚜️⟭══════╗\n𝄟        الخروف يطلق السهم  🐑𝄟 \n╚═══════════════╝",--53
"╔══════⟬⚜️⟭══════╗\n𝄟          بقرة تشرب القهوة    🐮𝄟 \n╚═══════════════╝",--54
"╔══════⟬⚜️⟭══════╗\n𝄟         دجاجة الثلج والشاي 🐔𝄟 \n╚═══════════════╝",--55
"╔══════⟬⚜️⟭══════╗\n𝄟             دجاجة تتبختر    🐔 𝄟 \n╚═══════════════╝",--56
"╔══════⟬⚜️⟭══════╗\n𝄟 الخروج من الفانوس السحري  𝄟 \n╚═══════════════╝",--57
"╔══════⟬⚜️⟭══════╗\n𝄟  دجاجة منبطحه مع MP3🐔?? \n╚═══════════════╝",--58
"╔══════⟬⚜️⟭══════╗\n𝄟          دجاجة الأوزان       🐔𝄟 \n╚═══════════════╝",--59
"╔══════⟬⚜️⟭══════╗\n𝄟             قرون الزينة        🎄𝄟 \n╚═══════════════╝",--60
"╔══════⟬⚜️⟭══════╗\n𝄟         التاج والعصا الملكية 👑𝄟 \n╚═══════════════╝",--61
"╔══════⟬⚜️⟭══════╗\n𝄟          شيطان يقبل الهدية 🎁𝄟 \n╚═══════════════╝",--62
"╔══════⟬⚜️⟭══════╗\n𝄟          دجاجة تزين البيضة 🐔𝄟 \n╚═══════════════╝",--63
"╔══════⟬⚜️⟭══════╗\n𝄟             البنت والعروسة   👧 𝄟 \n╚═══════════════╝",--64
"╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع الملصقات🟡𝄟 \n╚═══════════════╝",--65
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--66
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--67
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--68
  }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 64
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Emoji"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Emoji"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الملصقات")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end

----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
--زينه
function U29()
    lastMenu = U29
    
    -- توليد دوال الصور من 1 إلى 398
    for i = 1, 398 do
        local funcName = "Pic" .. i
        _G[funcName] = function()
            applyImage(i, "صورة " .. i)
        end
    end
    
    -- الصور الخاصة (1390، 1391)
    function Pic1390()
        applyImage(1390, "صورة 1390")
    end
    
    function Pic1391()
        applyImage(1391, "صورة 1391")
    end
    
    -- القائمة الرئيسية
    local choice = gg.multiChoice({
        "╔══════⟬🖼️⟭══════╗\n𝄟               الصور 1 - 40         𝄟\n╚═══════════════╝",
        "╔══════⟬🖼️⟭══════╗\n𝄟             الصور 41 - 80         𝄟\n╚═══════════════╝",
        "╔══════⟬🖼️⟭══════╗\n𝄟           الصور 81 - 120        𝄟\n╚═══════════════╝",
        "╔══════⟬🖼️⟭══════╗\n𝄟         الصور 121 - 160        𝄟\n╚═══════════════╝",
        "╔══════⟬🖼️⟭══════╗\n𝄟         الصور 161 - 200        𝄟\n╚═══════════════╝",
        "╔══════⟬🖼️⟭══════╗\n𝄟         الصور 201 - 240        𝄟\n╚═══════════════╝",
        "╔══════⟬🖼️⟭══════╗\n𝄟         الصور 241 - 280        𝄟\n╚═══════════════╝",
        "╔══════⟬🖼️⟭══════╗\n𝄟         الصور 281 - 320        𝄟\n╚═══════════════╝",
        "╔══════⟬🖼️⟭══════╗\n𝄟         الصور 321 - 360        𝄟\n╚═══════════════╝",
        "╔══════⟬🖼️⟭══════╗\n𝄟         الصور 361 - 398        𝄟\n╚═══════════════╝",
        "╔══════⟬🖼️⟭══════╗\n𝄟🟡  اختيار جميع الصور   🟡𝄟\n╚═══════════════╝",
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣 العوده لقائمه الأكواد   🟣𝄟\n╚═══════════════╝",
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟\n╚═══════════════╝",
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡 الخروج بشكل نهائي  🟡𝄟\n╚═══════════════╝",
    }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
    
    if not choice then return end
    
    local groupRanges = {
        {1, 40}, {41, 80}, {81, 120}, {121, 160}, {161, 200},
        {201, 240}, {241, 280}, {281, 320}, {321, 360}, {361, 398}
    }
    
    for gIdx = 1, #groupRanges do
        if choice[gIdx] then
            local startNum = groupRanges[gIdx][1]
            local endNum = groupRanges[gIdx][2]
            
            local groupPics = {}
            for i = startNum, endNum do
                groupPics[#groupPics + 1] = _G["Pic" .. i]
            end
            
            if gIdx == 10 then
                groupPics[#groupPics + 1] = _G["Pic1390"]
                groupPics[#groupPics + 1] = _G["Pic1391"]
            end
            
            applyAllWithTracking(groupPics, "المجموعة " .. gIdx .. " (صور " .. startNum .. "-" .. endNum .. ")")
            return
        end
    end
    
    if choice[11] then
        local allPics = {}
        for i = 1, 398 do
            allPics[#allPics + 1] = _G["Pic" .. i]
        end
        allPics[#allPics + 1] = _G["Pic1390"]
        allPics[#allPics + 1] = _G["Pic1391"]
        applyAllWithTracking(allPics, "جميع الصور")
        return
    end
    
    if choice[12] then Mahmoud() end
    if choice[13] then Home() end
    if choice[14] then EXIT() end
    
    HERO = -1
end
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡---------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡??🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
--التذكرة الذهبيه 
function F1 ()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("1937011470;1701998435", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.refineNumber("1937011470", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local results = gg.getResults(gg.getResultCount())
if #results == 0 then
gg.alert("❌ كود فتح التذكرة الذهبيه لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
return
end
local success = false
for i, v in ipairs(results) do
local offset232 = gg.getValues({{address = v.address + 232, flags = gg.TYPE_DWORD}})[1]
local offset236 = gg.getValues({{address = v.address + 236, flags = gg.TYPE_DWORD}})[1]
local offset240 = gg.getValues({{address = v.address + 240, flags = gg.TYPE_DWORD}})[1]
local offset244 = gg.getValues({{address = v.address + 244, flags = gg.TYPE_DWORD}})[1]

if offset232.value and offset236.value and offset240.value and offset244.value then
local str232 = tostring(math.abs(offset232.value))
local str236 = tostring(math.abs(offset236.value))
local str240 = tostring(math.abs(offset240.value))
local str244 = tostring(math.abs(offset244.value))

local length232 = #str232
local length236 = #str236
local length240 = #str240
local length244 = #str244

local validLength232 = (length232 == 8 or length232 == 9 or length232 == 10)
local validLength236 = (length236 == 8 or length236 == 9 or length236 == 10)
local validLength240 = (length240 == 8 or length240 == 9 or length240 == 10)
local validLength244 = (length244 == 8 or length244 == 9 or length244 == 10)

local isMatchFirstPair = str232:sub(1, 4) == str236:sub(1, 4)
local isMatchSecondPair = str240:sub(1, 4) == str244:sub(1, 4)
if validLength232 and validLength236 and validLength240 and validLength244 and isMatchFirstPair and isMatchSecondPair then  
          
gg.setValues({{address = v.address + 232, flags = gg.TYPE_QWORD, value = 1000},
{address = v.address + 248, flags = gg.TYPE_DWORD, value = 1}})
success = true
end
end
end
if success then
gg.alert("🤡مبروك فتح التذكره الذهبيه🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
else
gg.alert("❌ التحقق لا يعمل في كود التذكره الذهبيه  ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
end
gg.clearList()
 gg.clearResults()
 end --👹تم الانتهاء👹
 
 

--زياده المستوى من الزراعة 
function F2 ()
gg.alert("⚠️ ملحوظه لا تضع عدد كبير حتي لا يرتفع المستوى بشكل كبير⚠️")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)

gg.searchNumber('1701147414;2002744164;1123024896', gg.TYPE_DWORD) 
gg.refineNumber('1123024896', gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
gg.alert("❌ كود زياده المستوى من الزراعة لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
gg.clearResults()
return
end
gg.toast(n)
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
local M12 = gg.prompt({" 🇪🇬Edited by MAHMOUDHERO🇪🇬".."\n🇪🇬 Egypt mother of the world 🇪??\n"},{[1]="\n🙋اكتب الرقم الذي تريده🙋\n"},nil,{'number'})
if M12 == nil then
else
end
if M12[1] ==nil then
else
end
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 0,flags = gg.TYPE_DWORD,freeze = true,value = 0}})
gg.addListItems({[1] = {address = jz[i].address + 16,flags = gg.TYPE_QWORD,freeze = true,value = M12[1],gg.TYPE_QWORD}})
if not messageShown then
if not toastShown then
gg.alert("🤡كل ما تفعله ازرع القمح واحصده🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
end
end
gg.clearList()
gg.clearResults()
end -- 👹تم الانتهاء👹

function F3()
    gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    local POINTER_MAX_OFFSET = 0

    local mode = gg.choice({
        "🚁 تعديل جميع طلبات الطائرة",
        "📦 تعديل طلب واحد فقط "
    }, nil, "🇪🇬Edited by MAHMOUDHERO🇪🇬")
    if not mode then
        gg.toast("🤡تم الإلغاء🤡")
        return
    end

    
    local originalRanges = gg.getRanges()
    local addedOther = false
    local addedCAlloc = false

    
    if (originalRanges & gg.REGION_OTHER) == 0 then
        gg.setRanges(gg.getRanges() | gg.REGION_OTHER)
        addedOther = true
    end

    local function restoreRanges()
        
        gg.setRanges(originalRanges)
        addedOther = false
        addedCAlloc = false
    end

    local function run()
        gg.clearResults()


        gg.searchNumber('-8;-1;1800::9', gg.TYPE_DWORD)
        gg.refineNumber('-8', gg.TYPE_DWORD)

        local first = gg.getResults(1)
        if #first == 0 then
            gg.alert("❌ كود زيادة المستوى من الطائرة لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صورة📸")
            return
        end

        gg.clearResults()
        gg.loadResults(first)

 
        if (gg.getRanges() & gg.REGION_C_ALLOC) == 0 then
            gg.setRanges(gg.getRanges() | gg.REGION_C_ALLOC)
            addedCAlloc = true
        end

        
        gg.searchPointer(POINTER_MAX_OFFSET)

        local count = gg.getResultsCount()
        if count == 0 then
            gg.alert("❌ لم يتم العثور على أي مؤشرات ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صورة📸")
            return
        end

        local pointers = gg.getResults(math.min(count, 100))

        if mode == 2 then
            pointers = { pointers[1] }
        end

        local names = {
            "💰 زيادة الفلوس",
            "💵 زيادة الدولارات",
            "⭐ زيادة المستوى",
            "🖼️ حدث الإطار",
            "🔥 حدث الاسم (العناصر الأربعة)",
            "🎯 حدث الاسم (إظهار وطنين)"
        }

        local input = gg.prompt(names, nil, {
            'number', 'number', 'number', 'number', 'number', 'number', 'number'
        })

        if not input then
            gg.alert("🤡لا يتم تعديل أي شيء🤡")
            return
        end

        local offsets = { 40, 48, 72, 128, 136, 152 }

        local edits = {}
        for p = 1, #pointers do
            local base = pointers[p].address
            for i = 1, #offsets do
                local n = tonumber(input[i])
                if n then
                    edits[#edits + 1] = {
                        address = base + offsets[i],
                        flags = gg.TYPE_QWORD,
                        value = math.tointeger(n) or math.floor(n)
                    }
                end
            end
        end

        if #edits == 0 then
            gg.alert("🤡لم تدخل أي قيمة، لا يتم تعديل أي شيء🤡")
            return
        end

        gg.setValues(edits)

        gg.clearResults()

        gg.alert("مبروك ✅\n\n" ..
            "\n\nكل ما عليك الذهاب إلى الطائرة الهليكوبتر والبحث داخل الطلبات للحصول على الطلب الذي تم تعديله، ثم اضغط على إرسال الطلب للحصول على كل شيء")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
    end

    
    local ok, err = pcall(run)
    restoreRanges()
    if not ok then
        gg.alert("⚠️ حدث خطأ:\n" .. tostring(err))
    end
end

-- قبل الأخير 
-- زيادة المستوى من الطائرة
function F73()
    gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    local POINTER_MAX_OFFSET = 0

    local mode = gg.choice({
        "🚁 تعديل جميع طلبات الطائرة",
        "📦 تعديل طلب واحد فقط "
    }, nil, "🇪🇬Edited by MAHMOUDHERO🇪🇬")
    if not mode then
        gg.toast("🤡تم الإلغاء🤡")
        return
    end


    local addedRange = false
    local currentRanges = gg.getRanges()
    if (currentRanges & gg.REGION_OTHER) == 0 then
        gg.setRanges(currentRanges | gg.REGION_OTHER)
        addedRange = true
    end

    local function restoreRanges()
        if addedRange then

            gg.setRanges(gg.getRanges() & ~gg.REGION_OTHER)
            addedRange = false
        end
    end

    local function run()
        gg.clearResults()

        
        gg.searchNumber('-8;-1;1800::9', gg.TYPE_DWORD)
        gg.refineNumber('-8', gg.TYPE_DWORD)

        local first = gg.getResults(1)
        if #first == 0 then
            gg.alert("❌ كود زيادة المستوى من الطائرة لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صورة📸")
            return
        end

        
        gg.clearResults()
        gg.loadResults(first)

        
        gg.searchPointer(POINTER_MAX_OFFSET)

        local count = gg.getResultsCount()
        if count == 0 then
            gg.alert("❌ لم يتم العثور على أي مؤشرات ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صورة📸")
            return
        end

        local pointers = gg.getResults(math.min(count, 100))


        if mode == 2 then
            pointers = { pointers[1] }
        end

        
        local names = {
            "💰 زيادة الفلوس",
            "💵 زيادة الدولارات",
            "⭐ زيادة المستوى",
            "🖼️ حدث الإطار",
            "🔥 حدث الاسم (العناصر الأربعة)",     
            "🎯 حدث الاسم (إظهار وطنين)"
        }

        local input = gg.prompt(names, nil, {
            'number', 'number', 'number', 'number', 'number', 'number', 'number'
        })

        if not input then
            gg.alert("🤡لا يتم تعديل أي شيء🤡")
            return
        end


        local offsets = { 40, 48, 72, 128, 136, 152 }


        local filled = {}
        for i = 1, #offsets do
            if tonumber(input[i]) then
                filled[#filled + 1] = names[i]
            end
        end

        
        local edits, editNames = {}, {}
        for p = 1, #pointers do
            local base = pointers[p].address
            for i = 1, #offsets do
                local n = tonumber(input[i])
                if n then
                    edits[#edits + 1] = {
                        address = base + offsets[i],
                        flags = gg.TYPE_QWORD,
                        value = math.tointeger(n) or math.floor(n)
                    }
                    editNames[#edits] = names[i]
                end
            end
        end

        if #edits == 0 then
            gg.alert("🤡لم تدخل أي قيمة، لا يتم تعديل أي شيء🤡")
            return
        end

        
        gg.setValues(edits)


        local verify = {}
        for k = 1, #edits do
            verify[k] = { address = edits[k].address, flags = gg.TYPE_QWORD }
        end
        local after = gg.getValues(verify)

local okCount, failed, seen = 0, {}, {}
        for k = 1, #edits do
            if after[k].value == edits[k].value then
                okCount = okCount + 1
            elseif not seen[editNames[k]] then
                seen[editNames[k]] = true
                failed[#failed + 1] = editNames[k]
            end
        end

        gg.clearResults()

        local report = "عدد الطلبات: " .. #pointers ..
            "\n\nالخانات المعدّلة:\n• " .. table.concat(filled, "\n• ") ..
            "\n\nنجح " .. okCount .. " من " .. #edits .. " كتابة"
        if #failed > 0 then
            report = report .. "\n\n❌ لم تثبت:\n• " .. table.concat(failed, "\n• ")
        end

        gg.alert("مبروك ✅\n\n" .. report ..
            "\n\nكل ما عليك الذهاب إلى الطائرة الهليكوبتر والبحث داخل الطلبات للحصول على الطلب الذي تم تعديله، ثم اضغط على إرسال الطلب للحصول على كل شيء")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
    end

    -- تشغيل آمن: نرجّع النطاقات في كل الحالات حتى لو حصل خطأ
    local ok, err = pcall(run)
    restoreRanges()
    if not ok then
        gg.alert("⚠️ حدث خطأ:\n" .. tostring(err))
    end
end


-- زياده المستوي من الطائره   قديم 
function F563()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.clearResults()
    gg.setVisible(false)
    
    gg.searchNumber('65536;1441793~1441794:121', gg.TYPE_DWORD)
    gg.refineNumber('1441793~1441794', gg.TYPE_DWORD)
    local refinedResults = gg.getResults(1)
    if #refinedResults == 0 then
        gg.alert("❌ كود زياده المستوى من الطائرة لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
        return
    end

    local baseAddress = refinedResults[1].address

    local currentValues = gg.getValues({
        {address = baseAddress + 48, flags = gg.TYPE_QWORD},
        {address = baseAddress + 56, flags = gg.TYPE_QWORD},
        {address = baseAddress + 64, flags = gg.TYPE_QWORD}
    })

    
    local input = gg.prompt({[1] = "🇪🇬Edited by MAHMOUDHERO🇪🇬", [2] = "🇪🇬Edited by MAHMOUDHERO🇪🇬", [3] = "🇪🇬Edited by MAHMOUDHERO🇪🇬"},{[1] = "\n🤡زيادة الذهب🤡\n", [2] = "\n🤡زياده الدولارات 🤡\n", [3] = "\n🤡زياده المستوى🤡\n"},nil, {'number', 'number', 'number'})

    if not input then
        gg.alert("🤡لا يتم تعديل اي شيء🤡")
        return
    end

    
    gg.setValues({
        {address = baseAddress + 48, flags = gg.TYPE_QWORD, value = tonumber(input[1]) or currentValues[1].value},
        {address = baseAddress + 56, flags = gg.TYPE_QWORD, value = tonumber(input[2]) or currentValues[2].value},
        {address = baseAddress + 64, flags = gg.TYPE_QWORD, value = tonumber(input[3]) or currentValues[3].value}
    })

    gg.clearResults()
    gg.alert("مبروك كل ما عليك الذهاب الي الطائره الهليكوبتر والبحث داخل الطلبات للحصول علي الطلب الذي تم تعديله ثم بعد ذلك اضغط علي ارسال الطلب للحصول علي كل شي")
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
end

-- تصفير وقت الحيوانات مؤقت
function F4()
gg.alert("🔥لحظه لا تغلق البرنامج حتي ينتهي من البحث 🔥")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)

gg.searchNumber("1818848520;107;1150681088::25", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1150681088", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 0,flags = gg.TYPE_FLOAT,freeze = true,value = 1}})
gg.addListItems({[1] = {address = jz[i].address + 160,flags = gg.TYPE_DWORD,freeze = true,value = 1}})
gg.addListItems({[1] = {address = jz[i].address + 320,flags = gg.TYPE_DWORD,freeze = true,value = 1}})
gg.addListItems({[1] = {address = jz[i].address + 480,flags = gg.TYPE_DWORD, freeze = true,value = 1}})
gg.addListItems({[1] = {address = jz[i].address + 640,flags = gg.TYPE_DWORD, freeze = true,value = 1}})
gg.addListItems({[1] = {address = jz[i].address + 800,flags = gg.TYPE_DWORD, freeze = true,value = 1}})
end

gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)

gg.searchNumber("1701995018;25697;1168687104::25", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1168687104", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 0,flags = gg.TYPE_DWORD,freeze = true,value = 1}})
gg.addListItems({[1] = {address = jz[i].address + 128,flags = gg.TYPE_DWORD,freeze = true,value = 1}})
gg.addListItems({[1] = {address = jz[i].address + 384,flags = gg.TYPE_DWORD,freeze = true,value = 1}})
end

gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)

gg.searchNumber("1734829318;1182605312::25", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1182605312", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 0,flags = gg.TYPE_DWORD,freeze = true,value = 1}})
gg.addListItems({[1] = {address = jz[i].address + 128,flags = gg.TYPE_DWORD,freeze = true,value = 1}})
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = 1}})
gg.alert("🔥مبروك عليك تصفير الوقت لجميع الحيوانات🔥")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearList() 
gg.clearResults()
end
end

--وقت الزراعه
function F5() 
gg.alert("🔥لحظه لا تغلق البرنامج حتي ينتهي من البحث 🔥")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
local codes = {120, 300, 600, 900, 1200, 1800, 3600, 7200, 10800, 14400, 28800, 43200, 54000, 18000, 4800, 9000, 12600, 21600, 25200, 32400, 27000, 9900, 36000}
local timePerCode = 5 
local totalTime = #codes * timePerCode 
local remainingTime = totalTime   
local function showRemainingTime()gg.toast("باقي من الوقت" .. tostring(remainingTime) .. " ثانية") end
for _, code in ipairs(codes) do
gg.clearResults()
gg.searchNumber(tostring(code), gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
local results = gg.getResults(gg.getResultCount())
if #results == 0 then
gg.toast("كود تصفير وقت الزراعة مؤقت لا يعمل تحدث مع مطور الاسكربت" .. tostring(code))
else
for _, result in ipairs(results) do
local offsets = {
{address = result.address - 4, flags = gg.TYPE_DWORD},
{address = result.address - 8, flags = gg.TYPE_DWORD},
{address = result.address + 8, flags = gg.TYPE_DWORD},
{address = result.address + 12, flags = gg.TYPE_DWORD},}
local values = gg.getValues(offsets)
local minus4 = tostring(math.abs(values[1].value))
local minus8 = tostring(math.abs(values[2].value))
local plus8 = tostring(math.abs(values[3].value))
local plus12 = tostring(math.abs(values[4].value))
local lenMinus4 = #minus4
local lenMinus8 = #minus8
local lenPlus8 = #plus8
local lenPlus12 = #plus12
local isMatchMinus = (lenMinus4 == 8 or lenMinus4 == 9 or lenMinus4 == 10) and (lenMinus8 == 8 or lenMinus8 == 9 or lenMinus8 == 10) and minus4:sub(1, 4) == minus8:sub(1, 4)
local isMatchPlus = (lenPlus8 == 8 or lenPlus8 == 9 or lenPlus8 == 10) and (lenPlus12 == 8 or lenPlus12 == 9 or lenPlus12 == 10) and plus8:sub(1, 4) == plus12:sub(1, 4)
if isMatchMinus and isMatchPlus then
gg.setValues({{address = result.address, flags = gg.TYPE_DWORD, value = 0} })
end
end
end
remainingTime = remainingTime - timePerCode
showRemainingTime()
end
gg.alert("🤡تم تصفير جميع المحاصيل الزراعية مؤقت🤡")
end






--تصفير طلبات الطائره
function F6()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("16842752;1053609165::13", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("16842752", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 4 ,flags = 4,freeze = true,value = 0}})
gg.addListItems({[1] = {address = jz[i].address - 8 ,flags = 4,freeze = true,value = 0}})
gg.addListItems({[1] = {address = jz[i].address + 0 ,flags = 4,freeze = true,value = 0}})
gg.addListItems({[1] = {address = jz[i].address + 4 ,flags = 4,freeze = true,value = 0}})
gg.addListItems({[1] = {address = jz[i].address + 8 ,flags = 4,freeze = true,value = 0}})
gg.addListItems({[1] = {address = jz[i].address + 12 ,flags = 4,freeze = true,value = 0}})
gg.addListItems({[1] = {address = jz[i].address + 16 ,flags = 4,freeze = true,value = 0}})
 if not messageShown then
 if not toastShown then
gg.alert(" اذهب  الان الي الطائره الهليكوبتر ثم قم بعمل حذف لاي طلب ثم  بعد الحذف اعمل  انهاء وسوف تعمل معك")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--ارسال الكروت الجديد
function F7()
    gg.toast("❤️لا تنسي الصلاة علي النبي❤️")
    gg.clearResults()
    gg.setVisible(false)


    gg.searchNumber("1701274988;1918985326;121:9", gg.TYPE_DWORD)
    gg.refineNumber("1701274988;1918985326;121", gg.TYPE_DWORD)

    local n1 = gg.getResultCount()

    if n1 == 0 then
        gg.clearResults()
        gg.searchNumber("1701274988;1918985326;121:9", gg.TYPE_DWORD)
        gg.refineNumber("1701274988", gg.TYPE_DWORD)
        n1 = gg.getResultCount()
    end

    if n1 == 0 then
        gg.clearResults()
        gg.searchNumber("1684828007;0;0:9", gg.TYPE_DWORD)
        gg.refineNumber("1684828007", gg.TYPE_DWORD)
        n1 = gg.getResultCount()
    end

    if n1 == 0 then
        gg.alert("كود تغير الكارت الذهبي لا يعمل لكن سوف يتم الاستكمال عن بحث ارسال الكروت اخبر المطور عن هذا ")
    else
        local r1 = gg.getResults(n1)
        for i = 1, n1 do
            r1[i].value = 0
        end
        gg.setValues(r1)
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
    end
    
    gg.clearResults()

    -- ارسال الكروت 
    gg.toast("❤️لا تنسي الصلاة علي النبي❤️")
    gg.searchNumber("86400;50;1;1;1::17", gg.TYPE_DWORD)
    gg.refineNumber("86400", gg.TYPE_DWORD)

    local n2 = gg.getResultCount()
    if n2 == 0 then
        gg.toast("❌ كود ارسال الكروت لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
        gg.clearResults()
        return
    end

    local r2 = gg.getResults(n2)
    local offsets = {32, 36, 40, 44, 48, 52}
    local edits = {}

    for i = 1, n2 do
        local base = r2[i].address
        for _, off in ipairs(offsets) do
            table.insert(edits, {
                address = base + off,
                flags = gg.TYPE_DWORD,
                value = 0,
                freeze = true
            })
        end
    end

    gg.setValues(edits)
    gg.addListItems(edits)

    gg.alert("اذهب الان وأرسل جميع الكروت لكن من فضلك لا ترسل كروت كثيره حتي لا يتم حظرك")
    gg.clearResults()
end

function F7()
    gg.toast("❤️لا تنسي الصلاة علي النبي❤️")
    gg.clearResults()
    gg.setVisible(false)

    -- الكود الأول
    gg.searchNumber("17303087X32", gg.TYPE_DWORD)
    gg.refineNumber("1684828007", gg.TYPE_DWORD)
    local n1 = gg.getResultCount()
    if n1 > 0 then
        local r1 = gg.getResults(n1)
        for i = 1, n1 do
            r1[i].value = 0
        end
        gg.setValues(r1)
    end
    gg.clearResults()

    -- الكود الثاني
    gg.searchNumber("1701274988;1918985326;121:9", gg.TYPE_DWORD)
    gg.refineNumber("1701274988;1918985326;121", gg.TYPE_DWORD)
    local n2 = gg.getResultCount()
    if n2 > 0 then
        local r2 = gg.getResults(n2)
        for i = 1, n2 do
            r2[i].value = 0
        end
        gg.setValues(r2)
    end
    gg.clearResults()

    -- الكود الثالث
    gg.searchNumber("1684828007;0;0:9", gg.TYPE_DWORD)
    gg.refineNumber("1684828007", gg.TYPE_DWORD)
    local n3 = gg.getResultCount()
    if n3 > 0 then
        local r3 = gg.getResults(n3)
        for i = 1, n3 do
            r3[i].value = 0
        end
        gg.setValues(r3)
    end
    gg.clearResults()

    -- ارسال الكروت 
    gg.toast("❤️لا تنسي الصلاة علي النبي❤️")
    gg.searchNumber("86400;50;1;1;1::17", gg.TYPE_DWORD)
    gg.refineNumber("86400", gg.TYPE_DWORD)
    local n4 = gg.getResultCount()
    if n4 > 0 then
        local r4 = gg.getResults(n4)
        local offsets = {32, 36, 40, 44, 48, 52}
        local edits = {}
        for i = 1, n4 do
            local base = r4[i].address
            for _, off in ipairs(offsets) do
                table.insert(edits, {
                    address = base + off,
                    flags = gg.TYPE_DWORD,
                    value = 0,
                    freeze = true
                })
            end
        end
        gg.setValues(edits)
        gg.addListItems(edits)
        gg.alert("اذهب الان وأرسل جميع الكروت لكن من فضلك لا ترسل كروت كثيره حتي لا يتم حظرك")
    end

    gg.clearResults()
end


-- زيادة الكروت 
function F8 ()
gg.toast("❤️لا تنسي الصلاة علي النبي❤️")
gg.setVisible(false)
gg.clearResults()

    pcall(function()
    gg.searchNumber("1918984974~1918984976", gg.TYPE_DWORD)
    end)

    local total = gg.getResultsCount()
    if total == 0 then
        gg.toast("❌ كود زيادة الكروت لا يعمل ❌\n📸 تواصل مع المطور 📸")
        return
    end

    local batchSize = 200
    local valid = {}


    for i = 1, total, batchSize do
        local size = math.min(batchSize, total - i + 1)

        local part = {}
        pcall(function()
            part = gg.getResults(size, i - 1)
        end)

        if part and #part > 0 then
            local readList = {}

            for _, v in ipairs(part) do
                readList[#readList+1] = {address = v.address + 24, flags = gg.TYPE_DWORD}
                readList[#readList+1] = {address = v.address + 32, flags = gg.TYPE_DWORD}
            end

            local values = {}
            pcall(function()
                values = gg.getValues(readList)
            end)

            if values and #values > 0 then
                local index = 1

                for j = 1, #values, 2 do
                    local val24 = tonumber(values[j].value) or -1
                    local val32 = tonumber(values[j+1].value) or 0

                    if val24 >= 0 and val24 <= 10 and val32 > 0 then
                        valid[#valid+1] = part[index]
                    end

                    index = index + 1
                end
            end
        end
    end

    if #valid == 0 then
        gg.toast("❌ كود زيادة الكروت لا يعمل ❌\n📸 تواصل مع المطور 📸")
        return
    end

      
 
   local input = gg.prompt({" 🇪🇬Edited by MAHMOUDHERO🇪🇬\n🇪🇬 Egypt mother of the world 🇪🇬\n"}, {"\n🙋اكتب الرقم الذي تريده🙋\n"},nil,{"number"})
   
    if not input or not input[1] then
        gg.clearResults()
        return
    end

    local newVal = tonumber(input[1])
    if not newVal then
        gg.toast("❌ من فضلك اكتب رقم صحيح ❌")
        return
    end

    
    if newVal > 999999 then newVal = 999999 end
    if newVal < 0 then newVal = 0 end

    
    local edits = {}
    for _, item in ipairs(valid) do
        edits[#edits+1] = {
            address = item.address + 28,
            flags = gg.TYPE_DWORD,
            value = newVal
        }
    end


    pcall(function()
        gg.setValues(edits)
    end)
    gg.alert("🌹تم زيادة الكروت بنجاح اذهب الان وشاهد🌹")
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
    gg.clearResults()
end





--زياده الكروت  القديم 
function F88888 ()
    gg.clearResults()
    gg.searchNumber("1918984974~1918984976", gg.TYPE_DWORD)
    local all = gg.getResults(gg.getResultsCount())

    if #all == 0 then
        gg.toast("❌ كود زيادة الكروت لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
        return
    end 


    local readList = {}
    for _, v in ipairs(all) do
        table.insert(readList, {
            address = v.address + 24,
            flags = gg.TYPE_DWORD
        })
    end

    local readValues = gg.getValues(readList)

    
    local valid = {}
    for i, v in ipairs(readValues) do
        local val = tonumber(v.value) or 0
        if val >= 1 and val <= 10 then
            table.insert(valid, all[i])
        end
    end

    if #valid == 0 then
        gg.toast("لا يوجد نتائج زيادة الكروت لتعديل عليها تحدث مع مطور الاسكربت وأرسل صوره")
        return
    end

    
    local input = gg.prompt({" 🇪🇬Edited by MAHMOUDHERO🇪🇬\n🇪🇬 Egypt mother of the world 🇪🇬\n"}, {"\n🙋اكتب الرقم الذي تريده🙋\n"},nil,{"number"})

    if not input then
        gg.clearResults()
        return
    end

    local newVal = tonumber(input[1])
    if not newVal then return end


    local edits = {}
    for _, item in ipairs(valid) do
        table.insert(edits, {
            address = item.address + 28,
            flags = gg.TYPE_DWORD,
            value = newVal,
            freeze = false
        })
    end

    gg.setValues(edits)
    gg.alert("🌹تم زيادة الكروت اذهب الان وشاهد🌹")
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
    gg.clearResults()
end

-- الأكاديمية الصناعية 
function F9()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("32161984~32162047X4", gg.TYPE_DWORD)
local count = gg.getResultsCount()
if count == 0 then
return
end

local userInput = gg.prompt({"🇪🇬Edited by MAHMOUDHERO🇪🇬\n🇪🇬 Egypt mother of the world 🇪🇬\n"},{"🙋من الأفضل ضع هنا رقم 99🙋"},nil,{'number'})
if userInput == nil then 
return 
end

local inputValue = tonumber(userInput[1])
if inputValue == nil then
return
end

local results = gg.getResults(count)    
local success = false
local modifiedCount = 0

for i, v in ipairs(results) do
local offset16 = gg.getValues({{address = v.address + 16, flags = gg.TYPE_DWORD}})[1]
local offset20 = gg.getValues({{address = v.address + 20, flags = gg.TYPE_DWORD}})[1]

if offset16.value and offset20.value then
if offset16.value ~= 0 and offset20.value ~= 0 then
            
if offset20.value < 32161984 or offset20.value > 32162047 then
gg.setValues({{address = v.address + 20, flags = gg.TYPE_QWORD, value = inputValue}})
modifiedCount = modifiedCount + 1success = true end end end end

if success then
gg.alert("🔰 مبروك تم تعديل الأكاديمية الصناعية 🔰\n🧐 تم تعديل " .. modifiedCount .. "مصنع وقطار ومركب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
end
gg.clearResults()
end

--الشونه  ملغيه
function FFFF9 ()
    gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.clearResults()
    gg.setVisible(false)
    
    gg.searchNumber("50;1;70;2;90;3;110;4::113", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.refineNumber("50", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)

    local n = gg.getResultCount()

    
    if n == 0 then
        gg.alert("❌ كود زيادة الشونه لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
        gg.clearResults()
        return
    end

    local startOffset = gg.getResults(1)[1].address
    local endOffset = startOffset + 0xC60
    -- زياده لحد 5000 الأوفيس 0xC4C
    
    local modifications = {}
    for offset = 0, 0xC60, 4 do
        table.insert(modifications, {
            address = startOffset + offset,
            flags = gg.TYPE_DWORD,
            value = 0
        })
    end

    gg.setValues(modifications)

    gg.alert("هناك حظر في ترقيه الشونه بشكل سريع يجب أن تكون بطئ جدا في ترقيه الشونه\nتم التفعيل اذهب الان وقم برفع الشونه")
    gg.alert("وانت تقوم بعمل زيادة الشونه سوف يظهر الرقم 0 في كل مره ليس هناك مشكله\nعند إغلاق اللعبه وفتحها سوف يظهر كل شي طبيعي")
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.clearList()
end -- 👹MAHMOUDHERO👹



--المباني المجتمعيه 
function F10()
gg.alert("🤡افتح قائمة الشروط أمامكم لاي مبني مجتمعي حتي يظهر بحث 100%🤡")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber('256;1836016402::81', gg.TYPE_DWORD)
gg.refineNumber("256", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
gg.alert("❌ كود المباني المجتمعية لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
gg.clearResults()
return
end
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 24, flags = gg.TYPE_DWORD, freeze = true, value = 4}})
gg.addListItems({[1] = {address = jz[i].address + 32, flags = gg.TYPE_QWORD, freeze = true, value = 0}})
gg.addListItems({[1] = {address = jz[i].address + 40, flags = gg.TYPE_QWORD, freeze = true, value = 0}})
gg.addListItems({[1] = {address = jz[i].address + 48, flags = gg.TYPE_QWORD, freeze = true, value = 0}})
end
gg.alert("🤡اذهب الان وافتح جميع المباني المجتمعيه🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
end -- 👹MahmoudHeRo👹

--توسيع المدينه  القديمه 
function F111()
gg.alert("⚠️بعد الانتهاء عليك الانتظار أقل من دقيقة حتي ينتهي التوسيع ⚠️")
gg.toast("❤️ لا تنسى الصلاة على النبي ❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("1886938386;4::25", gg.TYPE_DWORD)
gg.refineNumber("1886938386", gg.TYPE_DWORD)

local n = gg.getResultCount()
if n == 0 then
    gg.alert("❌ كود توسيع الأرض لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
    return
end

local r = gg.getResults(n)
local edit = {}


for i = 1, n do
    local check = {
        address = r[i].address + 368,
        flags = gg.TYPE_DWORD
    }

    local v = gg.getValues({check})[1]

    if v.value == 1 then
        table.insert(edit, {
            address = check.address,
            flags = gg.TYPE_DWORD,
            value = 6
        })
    end
end

if #edit == 0 then
    gg.alert("لا يتم العثور علي اي شي تحدث مع مطور الاسكربت")
    return
end

gg.setValues(edit)
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
end

-- توسيع المدينه الجديد
function F11()
    gg.alert("⚠️بعد الانتهاء عليك الانتظار أقل من دقيقة حتي ينتهي التوسيع ⚠️")
    gg.toast("❤️ لا تنسى الصلاة على النبي ❤️")
    gg.clearResults()
    gg.setVisible(false)
    gg.searchNumber("1886938386;4::25", gg.TYPE_DWORD)
    gg.refineNumber("1886938386", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("❌ كود توسيع الأرض لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
        return
    end

    local r = gg.getResults(n)
    local allEdits = {} 


    for i = 1, n do
        local check = {
            address = r[i].address + 368,
            flags = gg.TYPE_DWORD
        }

        local v = gg.getValues({check})[1]

        if v.value == 1 then
            table.insert(allEdits, {
                address = check.address,
                flags = gg.TYPE_DWORD,
                value = 6
            })
        end
    end

    if #allEdits == 0 then
        gg.alert("لا يتم العثور علي اي شي تحدث مع مطور الاسكربت")
        return
    end

    
    local totalEdits = #allEdits
    local batchSize = 50
    local batches = math.ceil(totalEdits / batchSize) 
    for batch = 1, batches do
        local startIdx = (batch - 1) * batchSize + 1
        local endIdx = math.min(batch * batchSize, totalEdits)
        

        local currentBatch = {}
        for i = startIdx, endIdx do
            table.insert(currentBatch, allEdits[i])
        end
        
        
        gg.setValues(currentBatch)
                        
        if batch < batches then
            gg.sleep(5000) 
        end
    end

    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥??‍☠️")
    gg.clearResults()
    gg.alert("🎉 تم الانتهاء من تعديل جميع القيم بنجاح")
end

-- الاعجابات 
function F12()
gg.toast("❤️ لا تنسى الصلاة على النبي ❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_OTHER)
gg.searchNumber("1918978076;6647145:13", gg.TYPE_DWORD)
gg.refineNumber("1918978076", gg.TYPE_DWORD)

local n = gg.getResultCount()
if n == 0 then
    gg.alert("❌ كود زيادة الاعجابات لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
    return
end

local jz = gg.getResults(n)
for i = 1, n do
    gg.addListItems({
        {address = jz[i].address - 64, flags = gg.TYPE_DWORD, value = 0, freeze = true},
        {address = jz[i].address - 60, flags = gg.TYPE_DWORD, value = 0, freeze = true},
        {address = jz[i].address - 56, flags = gg.TYPE_DWORD, value = 0, freeze = true}--58
    })
end

gg.clearResults()
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.alert("👍 الان اذهب الي اي مدينه تريدها وقم بعمل اعجاب لها 👍")
end


--صندوق المصانع 
function F13()
gg.alert("🤡يجب فتح اي مصنع قبل عمليه البحث حتي يتم التفعيل🤡")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("3407873;256:41", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("256", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
n = gg.getResultCount()
if n == 0 then
gg.alert("❌ كود فتح صنديق المصانع لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
gg.clearResults()
return
end
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({
[1] = {address = jz[i].address + 256, flags = gg.TYPE_DWORD, freeze = true, value = 0} })
end
gg.alert("🤡اذهب الان لفتح جميع صنديق المصانع🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
end -- 👹MahmoudHeRo👹

--صندوق السوق 
function F14 ()
gg.alert("🤡حتي لا تغلق اللعبه افتح السوق قبل البحث🤡")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber('1953063702;1185464320::73', gg.TYPE_DWORD)
gg.refineNumber('1953063702', gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
gg.alert("❌ كود زيادة صنديق السوق لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
gg.clearResults()
return
end
gg.toast(n)
jz = gg.getResults(n)
local M12 = gg.prompt(
{"🇪🇬Edited by MAHMOUDHERO🇪🇬\n🇪🇬 Egypt mother of the world 🇪🇬\n🙋اكتب الرقم الذي تريده🙋"},{""},nil,{'number'})
if M12 == nil or M12[1] == nil then
gg.clearResults()
return
end
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 60, flags = gg.TYPE_DWORD, freeze = true, value = 0} })
gg.addListItems({[1] = {address = jz[i].address - 52, flags = gg.TYPE_DWORD, freeze = true, value = 0}})
gg.addListItems({[1] = {address = jz[i].address - 56, flags = gg.TYPE_DWORD, freeze = true, value = M12[1]}})
end
gg.alert("🤡مبروك عليك زياده عدد صناديق السوق🤡")
gg.clearResults()
gg.clearList()
end




function HH1()
    gg.setVisible(false)
    gg.toast("❤️لا تنسى الصلاة على النبي❤️")

    gg.alert("🚂 الآن يمكن استخدام القطار في أي وضع لديك بدون تفريغ الصندوق، وبدون إغلاق اللعبة، ويمكن التشغيل أوتوماتيك 🚂")

    local POINTER_MAX_OFFSET = 0

    local options = {
        "╔══════⟬⚜️⟭══════╗\n𝄟 ارسال البرسيم فقط للاصدقاء𝄟\n╚═══════════════╝",
        "╔══════⟬⚜️⟭══════╗\n𝄟     زيادة المستوى للاصدقاء   𝄟\n╚═══════════════╝",
        "╔══════⟬⚜️⟭══════╗\n𝄟     زيادة الفلوس للاصدقاء   𝄟\n╚═══════════════╝"
    }
    local choice = gg.multiChoice(options, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊                     ❪ اختيار ما تريده ❫                         𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

    if not choice then return end
    if not choice[1] and not choice[2] and not choice[3] then
        gg.toast("🤡لم تختر شيئًا🤡")
        return
    end

    local val1 = 1701345034
    local val2 = 29793
    local qwordValue = 1
    local isMoney = false

    -- ============ زيادة المستوى (التاج) ============
    if choice[2] == true then
        gg.alert("⚠️ تحذير ⚠️\nلا تضع رقم كبير حتى لا يتم حظرك\n\n📌 المسموح من 1 إلى 400 فقط")

        local input = gg.prompt({"🇪🇬Edited by MAHMOUDHERO🇪🇬\n🇪🇬 Egypt mother of the world 🇪🇬\n🙋اكتب الرقم الذي تريده (1 - 400)🙋"}, {""}, {"number"})
        if not input then return end
        qwordValue = tonumber(input[1])

        if not qwordValue or qwordValue < 1 or qwordValue > 400 then
            gg.alert("❌ الرقم غير صالح ❌\nيجب أن يكون بين 1 و 400")
            return
        end

        val1 = 1634296844
        val2 = 7169380
    end

    -- =========== زيادة الفلوس للأصدقاء (جديد) ============
    if choice[3] == true then
        val1 = 1918984972
        val2 = 7630706
        qwordValue = 9999   -- ✅ القيمة مكتوبة تلقائياً
        isMoney = true
    end

    local mode = gg.choice({
        "🤖 طلب القطار وتفريغ الصندوق أوتوماتيك",
        "✋ طلب القطار وتفريغ الصندوق يدوياً"
    }, nil, "اختيار ما تريده")

    if not mode then
        gg.toast("🤡تم الإلغاء🤡")
        return
    end

    local autoMode = (mode == 1)

    local originalRanges = gg.getRanges()

    local function zeroAfter(baseAddr, count)
        local list = {}
        for i = 1, count do
            list[i] = {address = baseAddr + (i * 4), flags = gg.TYPE_DWORD, value = 0, freeze = true}
        end
        return list
    end

    local function run()
        if (originalRanges & gg.REGION_OTHER) == 0 then
            gg.setRanges(originalRanges | gg.REGION_OTHER)
        end

        gg.clearResults()
        gg.searchNumber("-8;1904::9", gg.TYPE_DWORD)
        gg.refineNumber("-8", gg.TYPE_DWORD)

        local first = gg.getResults(1)

        local results = {}

        if #first > 0 then
            gg.setRanges(gg.REGION_C_ALLOC)

            gg.clearResults()
            gg.loadResults(first)
            gg.searchPointer(POINTER_MAX_OFFSET)

            local count = gg.getResultsCount()
            if count > 0 then
                results = gg.getResults(math.min(count, 100))
            end
        end

        if autoMode and #results > 0 then
            pcall(function()
                gg.toast("⏳ انتظر، جاري اكتشاف إذا كان القطار فاضي أو لديه أدوات محملة...")

                local emptied = false

                for _, v in ipairs(results) do
                    local check = gg.getValues({
                        {address = v.address + 1728, flags = gg.TYPE_DWORD},
                        {address = v.address + 1696, flags = gg.TYPE_DWORD},
                        {address = v.address + 1664, flags = gg.TYPE_DWORD},
                        {address = v.address + 1632, flags = gg.TYPE_DWORD},
                        {address = v.address + 1600, flags = gg.TYPE_DWORD},
                    })

                    local loaded = false
                    for _, c in ipairs(check) do
                        if c.value == 1 then
                            loaded = true
                        end
                    end

                    if loaded then
                        gg.setValues({
                            {address = v.address + 1732, flags = gg.TYPE_DWORD, value = 1},
                            {address = v.address + 1700, flags = gg.TYPE_DWORD, value = 1},
                            {address = v.address + 1668, flags = gg.TYPE_DWORD, value = 1},
                            {address = v.address + 1636, flags = gg.TYPE_DWORD, value = 1},
                            {address = v.address + 1604, flags = gg.TYPE_DWORD, value = 1},
                        })
                        emptied = true
                    end
                end

                if emptied then
                    gg.toast("✅ تم تفريغ الصندوق، جاري البدء الآن لطلب القطار 🚂")
                    gg.sleep(5000)
                end
            end)
        end

        local freezeList = {}

        for i, v in ipairs(results) do

            local modifications = {
                {address = v.address + 1736, flags = gg.TYPE_FLOAT, value = 1, freeze = true},

                -- ============ الصندوق 1 ============
                {address = v.address + 80, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
                {address = v.address + 128, flags = gg.TYPE_DWORD, value = 1, freeze = true},
                {address = v.address + 56, flags = gg.TYPE_DWORD, value = val1, freeze = true},
                {address = v.address + 60, flags = gg.TYPE_DWORD, value = val2, freeze = true},
                {address = v.address + 248, flags = gg.TYPE_DWORD, value = 1, freeze = true},

                -- ============ الصندوق 2 ============
                {address = v.address + 384, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
                {address = v.address + 432, flags = gg.TYPE_DWORD, value = 1, freeze = true},
                {address = v.address + 360, flags = gg.TYPE_DWORD, value = val1, freeze = true},
                {address = v.address + 364, flags = gg.TYPE_DWORD, value = val2, freeze = true},
                {address = v.address + 552, flags = gg.TYPE_DWORD, value = 1, freeze = true},

                -- ============ الصندوق 3 ============
                {address = v.address + 688, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
                {address = v.address + 736, flags = gg.TYPE_DWORD, value = 1, freeze = true},
                {address = v.address + 664, flags = gg.TYPE_DWORD, value = val1, freeze = true},
                {address = v.address + 668, flags = gg.TYPE_DWORD, value = val2, freeze = true},
                {address = v.address + 856, flags = gg.TYPE_DWORD, value = 1, freeze = true},

                -- ============ الصندوق 4 ============
                {address = v.address + 992, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
                {address = v.address + 1040, flags = gg.TYPE_DWORD, value = 1, freeze = true},
                {address = v.address + 968, flags = gg.TYPE_DWORD, value = val1, freeze = true},
                {address = v.address + 972, flags = gg.TYPE_DWORD, value = val2, freeze = true},
                {address = v.address + 1160, flags = gg.TYPE_DWORD, value = 1, freeze = true},

                -- ============ الصندوق 5 ============
                {address = v.address + 1296, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
                {address = v.address + 1344, flags = gg.TYPE_DWORD, value = 1, freeze = true},
                {address = v.address + 1272, flags = gg.TYPE_DWORD, value = val1, freeze = true},
                {address = v.address + 1276, flags = gg.TYPE_DWORD, value = val2, freeze = true},
                {address = v.address + 1464, flags = gg.TYPE_DWORD, value = 1, freeze = true},
            }

            if autoMode then
                table.insert(modifications, {address = v.address + 1732, flags = gg.TYPE_DWORD, value = 1, freeze = true})
                table.insert(modifications, {address = v.address + 1700, flags = gg.TYPE_DWORD, value = 1, freeze = true})
                table.insert(modifications, {address = v.address + 1668, flags = gg.TYPE_DWORD, value = 1, freeze = true})
                table.insert(modifications, {address = v.address + 1636, flags = gg.TYPE_DWORD, value = 1, freeze = true})
                table.insert(modifications, {address = v.address + 1604, flags = gg.TYPE_DWORD, value = 1, freeze = true})
            end

            local zeroLists = {
                zeroAfter(v.address + 60,   4),
                zeroAfter(v.address + 364,  4),
                zeroAfter(v.address + 668,  4),
                zeroAfter(v.address + 972,  4),
                zeroAfter(v.address + 1276, 4),
            }

            for _, zl in ipairs(zeroLists) do
                for _, item in ipairs(zl) do
                    table.insert(modifications, item)
                end
            end

            gg.setValues(modifications)

            for _, mod in ipairs(modifications) do
                if mod.freeze then
                    table.insert(freezeList, {
                        address = mod.address,
                        flags = mod.flags,
                        value = mod.value,
                        freeze = true
                    })
                end
            end
        end

        gg.clearResults()

        if #freezeList > 0 then
            gg.addListItems(freezeList)

            if choice[1] == true then
                gg.alert("🕵️‍♂️يمكن ارسال البرسيم للاصدقاء بعد المساعدة🕵️‍♂️")
            end

            if choice[2] == true then
                gg.alert("✅ تم تفعيل التاج بنجاح ✅\n\n👑 اذهب وشاهد بنفسك 👑")
            end

         if isMoney then
    gg.alert("✅ تم تفعيل زيادة الفلوس للأصدقاء ✅\n\n💸 اذهب وشاهد بنفسك 💸")
end

            gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        elseif #first == 0 then
            gg.alert("❌ كود طلب المساعدة في القطار لا يعمل ❌\n\n📱 تأكد أنك تستخدم هاتف وليس تابلت أو لاب توب")
        else
            gg.alert("❌ لم يتم العثور على مؤشرات للقطار ❌\n\n🚂 تأكد أن القطار موجود في المحطة، وأعد المحاولة")
        end
    end

    local ok, err = pcall(run)
    gg.setRanges(originalRanges)
    if not ok then
        gg.alert("⚠️ حدث خطأ:\n" .. tostring(err))
    end
end

--طلب مساعده في القطار 
function HH881()
    gg.setVisible(false)
    gg.toast("❤️لا تنسى الصلاة على النبي❤️")

    
    gg.alert("🚂 الآن يمكن استخدام القطار في أي وضع لديك بدون تفريغ الصندوق، وبدون إغلاق اللعبة، ويمكن التشغيل أوتوماتيك 🚂")

    
    local POINTER_MAX_OFFSET = 0   

    local options = {
        "╔══════⟬⚜️⟭══════╗\n𝄟 ارسال البرسيم فقط للاصدقاء𝄟\n╚═══════════════╝",
        "╔══════⟬⚜️⟭══════╗\n𝄟     زيادة المستوى للاصدقاء   𝄟\n╚═══════════════╝"
    }
    local choice = gg.multiChoice(options, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊                     ❪ اختيار ما تريده ❫                         𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

    if not choice then return end
    if not choice[1] and not choice[2] then
        gg.toast("🤡لم تختر شيئًا🤡")
        return
    end

    local val1 = 1701345034
    local val2 = 29793
    local qwordValue = 1

    if choice[2] == true then
        gg.alert("⚠️ تحذير ⚠️\nلا تضع رقم كبير حتى لا يتم حظرك\n\n📌 المسموح من 1 إلى 400 فقط")

        local input = gg.prompt({"🇪🇬Edited by MAHMOUDHERO🇪🇬\n🇪🇬 Egypt mother of the world 🇪🇬\n🙋اكتب الرقم الذي تريده (1 - 400)🙋"}, {""}, {"number"})
        if not input then return end
        qwordValue = tonumber(input[1])

        if not qwordValue or qwordValue < 1 or qwordValue > 400 then
            gg.alert("❌ الرقم غير صالح ❌\nيجب أن يكون بين 1 و 400")
            return
        end

        val1 = 1634296844
        val2 = 7169380
    end

    
    local mode = gg.choice({
        "🤖 طلب القطار وتفريغ الصندوق أوتوماتيك",
        "✋ طلب القطار وتفريغ الصندوق يدوياً"
    }, nil, "اختيار ما تريده")

    if not mode then
        gg.toast("🤡تم الإلغاء🤡")
        return
    end

    local autoMode = (mode == 1)

    
    local originalRanges = gg.getRanges()

    
    local function zeroAfter(baseAddr, count)
        local list = {}
        for i = 1, count do
            list[i] = {address = baseAddr + (i * 4), flags = gg.TYPE_DWORD, value = 0, freeze = true}
        end
        return list
    end

    local function run()
        -- ===================================================
        
        -- ===================================================
        if (originalRanges & gg.REGION_OTHER) == 0 then
            gg.setRanges(originalRanges | gg.REGION_OTHER)
        end

        gg.clearResults()
        gg.searchNumber("-8;1904::9", gg.TYPE_DWORD)
        gg.refineNumber("-8", gg.TYPE_DWORD)

        local first = gg.getResults(1)

        -- ===================================================
        
        -- ===================================================
        local results = {}

        if #first > 0 then
            gg.setRanges(gg.REGION_C_ALLOC)

            gg.clearResults()
            gg.loadResults(first)
            gg.searchPointer(POINTER_MAX_OFFSET)

            local count = gg.getResultsCount()
            if count > 0 then
                results = gg.getResults(math.min(count, 100))
            end
        end

        -- ===================================================
        
        -- ===================================================
        if autoMode and #results > 0 then
            pcall(function()
                gg.toast("⏳ انتظر، جاري اكتشاف إذا كان القطار فاضي أو لديه أدوات محملة...")

                local emptied = false

                for _, v in ipairs(results) do
                    local check = gg.getValues({
                        {address = v.address + 1728, flags = gg.TYPE_DWORD},
                        {address = v.address + 1696, flags = gg.TYPE_DWORD},
                        {address = v.address + 1664, flags = gg.TYPE_DWORD},
                        {address = v.address + 1632, flags = gg.TYPE_DWORD},
                        {address = v.address + 1600, flags = gg.TYPE_DWORD},
                    })

                    local loaded = false
                    for _, c in ipairs(check) do
                        if c.value == 1 then
                            loaded = true
                        end
                    end

   
                    if loaded then
                        gg.setValues({
                            {address = v.address + 1732, flags = gg.TYPE_DWORD, value = 1},
                            {address = v.address + 1700, flags = gg.TYPE_DWORD, value = 1},
                            {address = v.address + 1668, flags = gg.TYPE_DWORD, value = 1},
                            {address = v.address + 1636, flags = gg.TYPE_DWORD, value = 1},
                            {address = v.address + 1604, flags = gg.TYPE_DWORD, value = 1},
                        })
                        emptied = true
                    end
                end

                if emptied then
                    gg.toast("✅ تم تفريغ الصندوق، جاري البدء الآن لطلب القطار 🚂")
                    gg.sleep(5000)
                end
            end)
        end

        -- ===================================================

        -- ===================================================
        local freezeList = {}

        for i, v in ipairs(results) do

            local modifications = {
  
                {address = v.address + 1736, flags = gg.TYPE_FLOAT, value = 1, freeze = true},

                -- ============ الصندوق 1 ============
                {address = v.address + 80, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
                {address = v.address + 128, flags = gg.TYPE_DWORD, value = 1, freeze = true},
                {address = v.address + 56, flags = gg.TYPE_DWORD, value = val1, freeze = true},
                {address = v.address + 60, flags = gg.TYPE_DWORD, value = val2, freeze = true},
                {address = v.address + 248, flags = gg.TYPE_DWORD, value = 1, freeze = true},

                -- ============ الصندوق 2 ============
                {address = v.address + 384, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
                {address = v.address + 432, flags = gg.TYPE_DWORD, value = 1, freeze = true},
                {address = v.address + 360, flags = gg.TYPE_DWORD, value = val1, freeze = true},
                {address = v.address + 364, flags = gg.TYPE_DWORD, value = val2, freeze = true},
                {address = v.address + 552, flags = gg.TYPE_DWORD, value = 1, freeze = true},

                -- ============ الصندوق 3 ============
                {address = v.address + 688, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
                {address = v.address + 736, flags = gg.TYPE_DWORD, value = 1, freeze = true},
                {address = v.address + 664, flags = gg.TYPE_DWORD, value = val1, freeze = true},
                {address = v.address + 668, flags = gg.TYPE_DWORD, value = val2, freeze = true},
                {address = v.address + 856, flags = gg.TYPE_DWORD, value = 1, freeze = true},

                -- ============ الصندوق 4 ============
                {address = v.address + 992, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
                {address = v.address + 1040, flags = gg.TYPE_DWORD, value = 1, freeze = true},
                {address = v.address + 968, flags = gg.TYPE_DWORD, value = val1, freeze = true},
                {address = v.address + 972, flags = gg.TYPE_DWORD, value = val2, freeze = true},
                {address = v.address + 1160, flags = gg.TYPE_DWORD, value = 1, freeze = true},

                -- ============ الصندوق 5 ============
                {address = v.address + 1296, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
                {address = v.address + 1344, flags = gg.TYPE_DWORD, value = 1, freeze = true},
                {address = v.address + 1272, flags = gg.TYPE_DWORD, value = val1, freeze = true},
                {address = v.address + 1276, flags = gg.TYPE_DWORD, value = val2, freeze = true},
                {address = v.address + 1464, flags = gg.TYPE_DWORD, value = 1, freeze = true},
            }

            
            if autoMode then
                table.insert(modifications, {address = v.address + 1732, flags = gg.TYPE_DWORD, value = 1, freeze = true})
                table.insert(modifications, {address = v.address + 1700, flags = gg.TYPE_DWORD, value = 1, freeze = true})
                table.insert(modifications, {address = v.address + 1668, flags = gg.TYPE_DWORD, value = 1, freeze = true})
                table.insert(modifications, {address = v.address + 1636, flags = gg.TYPE_DWORD, value = 1, freeze = true})
                table.insert(modifications, {address = v.address + 1604, flags = gg.TYPE_DWORD, value = 1, freeze = true})
            end

            
            local zeroLists = {
                zeroAfter(v.address + 60,   4),  -- بعد val2 الصندوق 1: +64, +68, +72, +76
                zeroAfter(v.address + 364,  4),  -- بعد val2 الصندوق 2: +368, +372, +376, +380
                zeroAfter(v.address + 668,  4),  -- بعد val2 الصندوق 3: +672, +676, +680, +684
                zeroAfter(v.address + 972,  4),  -- بعد val2 الصندوق 4: +976, +980, +984, +988
                zeroAfter(v.address + 1276, 4),  -- بعد val2 الصندوق 5: +1280, +1284, +1288, +1292
            }

            for _, zl in ipairs(zeroLists) do
                for _, item in ipairs(zl) do
                    table.insert(modifications, item)
                end
            end

            gg.setValues(modifications)

            for _, mod in ipairs(modifications) do
                if mod.freeze then
                    table.insert(freezeList, {
                        address = mod.address,
                        flags = mod.flags,
                        value = mod.value,
                        freeze = true
                    })
                end
            end
        end

        gg.clearResults()

        -- ===================================================

        -- ===================================================
        if #freezeList > 0 then
            gg.addListItems(freezeList)

            if choice[1] == true then
                gg.alert("🕵️‍♂️يمكن ارسال البرسيم للاصدقاء بعد المساعدة🕵️‍♂️")
            end

            if choice[2] == true then
                gg.alert("✅ تم تفعيل التاج بنجاح ✅\n\n👑 اذهب وشاهد بنفسك 👑")
            end

            gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        elseif #first == 0 then
            gg.alert("❌ كود طلب المساعدة في القطار لا يعمل ❌\n\n🚂 خلي القطار فاضي من الأول خالص، وادخل حدث الاستكشاف وابحث تاني 🔍\n\n⚠️ لو المشكلة متحلتش، اقفل اللعبة وافتحها تاني وجرب مرة أخرى.")
        else
            gg.alert("❌ لم يتم العثور على مؤشرات للقطار ❌\n\n🚂 تأكد أن القطار موجود في المحطة، وأعد المحاولة")
        end
    end

    
    local ok, err = pcall(run)
    gg.setRanges(originalRanges)
    if not ok then
        gg.alert("⚠️ حدث خطأ:\n" .. tostring(err))
    end
end

--السباق 
function HH2()
gg.clearResults()
gg.alert("🕵️‍♂️من الأفضل أن تكون القيمه لنقاط المهام هي 150 نقظه ملحوظه اخري بعد عمل مجموعة من المهام حوالي 30 مهمه إلي 50 مهمه أو بعد كل 10000 نقطه عليك عمل مهمه بدون تعديل وعمل إنهاء لها أو حذفها🕵️‍♂️")
    gg.searchNumber("10;1701536084;1935758446;29547", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    local firstResults = gg.getResults(gg.getResultsCount())
    
    if #firstResults > 0 then
       
        local edits1 = {}
        for i, res in ipairs(firstResults) do
            if res.value == 1701536084 then
                table.insert(edits1, {address = res.address, flags = gg.TYPE_DWORD, value = 0})
            end
        end
        if #edits1 > 0 then
            gg.setValues(edits1)
        else
            gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        end
    else
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
    end

    gg.clearResults()
    gg.searchNumber("9;1633121097", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    local firstResults = gg.getResults(gg.getResultsCount())
    
    if #firstResults > 0 then        
        local edits1 = {}
        for i, res in ipairs(firstResults) do
            if res.value == 1633121097 then
                table.insert(edits1, {address = res.address, flags = gg.TYPE_DWORD, value = 0})
            end
        end
        if #edits1 > 0 then
            gg.setValues(edits1)
        else
            gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        end
    else
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
    end


    gg.clearResults()
    gg.searchNumber("1952533772;65538~65540", gg.TYPE_DWORD)
    local results1 = gg.getResults(gg.getResultsCount())
    if #results1 == 0 then
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        return
    end

    local BATCH_SIZE = 5000
    local validResults = {}
    local processedPointers = {}


    local startTime = os.clock()
    local totalBatches = math.ceil(#results1 / BATCH_SIZE)
    local processedBatches = 0
    local lastToastTime = 0

    local function updateTime()
   processedBatches = processedBatches + 1
        
        local elapsed = os.clock() - startTime
        local avgPerBatch = elapsed / processedBatches
        local remainingBatches = totalBatches - processedBatches
        
        local remainingTime = math.floor(avgPerBatch * remainingBatches)
        

        if (elapsed - lastToastTime) >= 2 then
            lastToastTime = elapsed
            gg.toast("⏳ باقي من الوقت" .. remainingTime .. " ثانية\n هات خمسه جنيه😁")
        end
    end

    for batchStart = 1, #results1, BATCH_SIZE do
        local batchEnd = math.min(batchStart + BATCH_SIZE - 1, #results1)
        
        local valuesToRead = {}
        for i = batchStart, batchEnd do
            local res = results1[i]
            table.insert(valuesToRead, {address = res.address + 192, flags = gg.TYPE_DWORD})
            table.insert(valuesToRead, {address = res.address + 196, flags = gg.TYPE_DWORD})
            table.insert(valuesToRead, {address = res.address + 200, flags = gg.TYPE_DWORD})
            table.insert(valuesToRead, {address = res.address + 204, flags = gg.TYPE_DWORD})      
            table.insert(valuesToRead, {address = res.address + 328, flags = gg.TYPE_QWORD})
        end
        
        local allValues = gg.getValues(valuesToRead)
        
        for i = batchStart, batchEnd do
            local idx = (i - batchStart) * 5
            
            local pointer328 = allValues[idx + 5].value
            if pointer328 == 0 then
            goto continue
            end
            
            
            local v192 = tostring(math.abs(allValues[idx + 1].value))
            local v196 = tostring(math.abs(allValues[idx + 2].value))
            local v200 = tostring(math.abs(allValues[idx + 3].value))
            local v204 = tostring(math.abs(allValues[idx + 4].value))
            
            local len192 = #v192
            local len196 = #v196
            local len200 = #v200
            local len204 = #v204
            
            if not ((len192 == 8 or len192 == 9 or len192 == 10) and
                    (len196 == 8 or len196 == 9 or len196 == 10) and
                    (len200 == 8 or len200 == 9 or len200 == 10) and
                    (len204 == 8 or len204 == 9 or len204 == 10)) then
                goto continue
            end
            
            local first4192 = v192:sub(1, 4)
            local first4196 = v196:sub(1, 4)
            local first4200 = v200:sub(1, 4)
            local first4204 = v204:sub(1, 4)
            
            if not ((first4192 == first4196) and (first4200 == first4204)) then
                goto continue
            end
            
            table.insert(validResults, {
                address = results1[i].address,
                pointer328 = pointer328
            })
            
            ::continue::
        end
        
        
        updateTime()
        gg.sleep(50)
    end

    if #validResults > 0 then
        local edits = {}
        local pointerEdits = {}
        
        local input = gg.prompt({"ضع رقم المهام هنا والافضل أن لا يزيد عن 300"}, {300}, {"number"})
        if not input then
            gg.clearResults()
            return
        end
        
        local userValue = tonumber(input[1]) or 300
        if userValue > 300 then
            userValue = 300
        elseif userValue < 0 then
            userValue = 0
        end
        
        for _, resData in ipairs(validResults) do
            table.insert(edits, {address = resData.address + 192, flags = gg.TYPE_DWORD, value = 0, freeze = true})
            table.insert(edits, {address = resData.address + 196, flags = gg.TYPE_DWORD, value = 0, freeze = true})
            
            if not processedPointers[resData.pointer328] then
                table.insert(pointerEdits, {
                    address = resData.pointer328,
                    flags = gg.TYPE_QWORD,
                    value = userValue,
                    freeze = true
                })
                processedPointers[resData.pointer328] = true
            end
        end
        
        if #edits > 0 then
            gg.setValues(edits)
            gg.addListItems(edits)
        end
        
        if #pointerEdits > 0 then
            gg.setValues(pointerEdits)
            gg.addListItems(pointerEdits)
            gg.alert("🕵️‍♂️يمكن الان إرسال المهام بدون وقت او دولارات🕵️‍♂️")
        else
            gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        end
    else
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
    end
end


--الانجازات 
function HH3()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
local oldRanges = gg.getRanges()
gg.setRanges(gg.REGION_OTHER)
gg.setVisible(false)

local function searchAndRefine(query)
gg.clearResults()
local ok = pcall(gg.searchNumber, query, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
if not ok or gg.getResultCount() == 0 then return {} end
local ok2 = pcall(gg.refineNumber, "23~39", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
if not ok2 or gg.getResultCount() == 0 then return {}end
local r = gg.getResults(gg.getResultCount())
local copy = {} for i, v in ipairs(r) do
copy[#copy + 1] = {address = v.address, flags = v.flags, value = v.value}
end return copy end


local all = searchAndRefine("49;0;23~39::13")

local function validLen(n)
local l = #tostring(math.abs(n))
return l == 8 or l == 9 or l == 10
end


local function checkPair(address, off1, off2)
local a = gg.getValues({
{address = address + off1, flags = gg.TYPE_DWORD},
{address = address + off2, flags = gg.TYPE_DWORD}})
local x, y = a[1], a[2]
if x and y and x.value and y.value then
local s1 = tostring(math.abs(x.value))
local s2 = tostring(math.abs(y.value))
if validLen(x.value) and validLen(y.value) and s1:sub(1, 4) == s2:sub(1, 4) then
return true
end
end
return false
end


local function checkZero(address, off)
local a = gg.getValues({{address = address + off, flags = gg.TYPE_DWORD}})
local x = a[1]
if x and x.value and x.value == 0 then
return true
end
return false
end

local seen = {}
local edits = {}
local count = 0


for _, v in ipairs(all) do
if not seen[v.address] then
seen[v.address] = true


if checkPair(v.address, 48, 52) and checkZero(v.address, 136) then
edits[#edits + 1] = {address = v.address + 40, flags = gg.TYPE_QWORD, value = 0}
count = count + 1
end


if checkPair(v.address, 72, 76) and checkZero(v.address, 160) then
edits[#edits + 1] = {address = v.address + 64, flags = gg.TYPE_QWORD, value = 0}
count = count + 1
end
end
end


if #edits > 0 then
gg.setValues(edits)
end

gg.setRanges(oldRanges)
gg.clearList()
gg.clearResults()

if count > 0 then
gg.alert("🤡مبروك عليك تم فتح جميع الانجازات🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
else
gg.alert("❌ لم يتم العثور على قيم مطابقة، لم يتم فتح الانجازات ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸")
end
end


 --المتحف
 function HH4 ()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("1;1953653000~1953653090:5", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.refineNumber("1", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local results = gg.getResults(gg.getResultCount())
if #results == 0 then
gg.alert("❌ كود فتح عناصر المتحف لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
return
end
local success = false
for i, v in ipairs(results) do
gg.setValues({{address = v.address - 4, flags = gg.TYPE_DWORD, value = 3}})
success = true
end
if success then
gg.alert("🏛️ تم فتح جميع عناصر المتحف 🏛️")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
else
gg.alert("❌ التعديل لا يعمل في كود المتحف ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
end
gg.clearList()
 gg.clearResults()
 end --👹تم الانتهاء👹



--معزز الطاقه السحرية 
function HHHHH5 ()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("827477012;1953452127;7237481::9", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.refineNumber("827477012", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local results = gg.getResults(gg.getResultCount())
if #results == 0 then
gg.alert("❌ كود الجرعات السحرية لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
return
end
local success = false
local target = nil
for i, v in ipairs(results) do
local offset24 = gg.getValues({{address = v.address + 24, flags = gg.TYPE_DWORD}})[1]
local offset28 = gg.getValues({{address = v.address + 28, flags = gg.TYPE_DWORD}})[1]

if offset24.value and offset28.value then
local str24 = tostring(math.abs(offset24.value))
local str28 = tostring(math.abs(offset28.value))

local length24 = #str24
local length28 = #str28

local validLength24 = (length24 == 8 or length24 == 9 or length24 == 10)
local validLength28 = (length28 == 8 or length28 == 9 or length28 == 10)

local isMatchPair = str24:sub(1, 4) == str28:sub(1, 4)
if validLength24 and validLength28 and isMatchPair then

if not target then
local input = gg.prompt({" 🇪🇬Edited by MAHMOUDHERO🇪🇬\n🇪🇬 Egypt mother of the world 🇪🇬\n\n🙋اكتب الرقم الذي تريده🙋"}, {""}, {"number"})
if not input or input[1] == "" then
gg.clearResults()
return
end
target = tonumber(input[1])
if not target then
gg.alert("⚠️ الخانة تقبل الأرقام فقط ⚠️")
gg.clearResults()
return
end
end

gg.setValues({{address = v.address + 24, flags = gg.TYPE_QWORD, value = target}})
success = true
end
end
end
if success then
gg.alert("🎉 اكتمل تنفيذ الكود 🎉\n\n🚁 اذهب إلى الهليكوبتر واحصل على التغييرات 🚁")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
else
gg.alert("❌ التحقق لا يعمل في كود الجرعات السحرية ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
end
gg.clearList()
 gg.clearResults()
 end --👹تم الانتهاء👹
 
 
 
  --زياده النجوم للكروت 
 function HHHH6()
    gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    local POINTER_MAX_OFFSET = 0

    
    local originalRanges = gg.getRanges()
    local addedOther = false
    local addedCAlloc = false

    
    if (originalRanges & gg.REGION_OTHER) == 0 then
        gg.setRanges(gg.getRanges() | gg.REGION_OTHER)
        addedOther = true
    end

    local function restoreRanges()
        gg.setRanges(originalRanges)
        addedOther = false
        addedCAlloc = false
    end

    local function run()
        gg.clearResults()


        gg.searchNumber('257;-16;-1;376;8::25', gg.TYPE_DWORD)
        gg.refineNumber('-16', gg.TYPE_DWORD)

        local first = gg.getResults(1)
        if #first == 0 then
            gg.alert("❌ كود زيادة النجوم لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صورة📸")
            return
        end

        gg.clearResults()
        gg.loadResults(first)

        
        if (gg.getRanges() & gg.REGION_C_ALLOC) == 0 then
            gg.setRanges(gg.getRanges() | gg.REGION_C_ALLOC)
            addedCAlloc = true
        end


        gg.searchPointer(POINTER_MAX_OFFSET)

        local count = gg.getResultsCount()
        if count == 0 then
            gg.alert("❌ لم يتم العثور على أي مؤشرات ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صورة📸")
            return
        end

        local pointers = gg.getResults(math.min(count, 100))

        -- مربع إدخال عدد النجوم
        local input = gg.prompt(
            {"🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n🙋 ضع هنا عدد النجوم 🙋"},
            {""},
            {"number"}
        )

        if not input or input[1] == "" then
            gg.alert("⚠️ لم يتم إدخال قيمة — العملية أُلغيت")
            return
        end

        local targetStars = tonumber(input[1])
        if not targetStars then
            gg.alert("⚠️ اكتب رقماً صحيحاً")
            return
        end
        targetStars = math.floor(targetStars)

        
        local offsets = { 112, 116, 124 }

        local edits = {}
        for p = 1, #pointers do
            local base = pointers[p].address
            for i = 1, #offsets do
                edits[#edits + 1] = {
                    address = base + offsets[i],
                    flags = gg.TYPE_DWORD,
                    value = targetStars
                }
            end
        end

        if #edits == 0 then
            gg.alert("🤡لم يتم بناء أي تعديل — العملية أُلغيت")
            return
        end

        gg.setValues(edits)

        gg.clearResults()

        gg.alert("⭐ تم زيادة عدد النجوم للكروت ⭐\n\n🎁 اذهب وشاهد بنفسك 🎁")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
    end

   
    local ok, err = pcall(run)
    restoreRanges()
    if not ok then
        gg.alert("⚠️ حدث خطأ:\n" .. tostring(err))
    end
end
 
 
 

 

 --كود إظهار الأحداث 
 function HH5 ()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("100;86400::33", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.refineNumber("86400", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local results = gg.getResults(gg.getResultCount())
if #results == 0 then
gg.alert("❌ كود اظهار الأحداث لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
gg.clearResults()
return
end
local editList = {}
for i, v in ipairs(results) do
table.insert(editList, {address = v.address - 24, flags = gg.TYPE_DWORD, value = 100})
end
gg.setValues(editList)
gg.alert("🎉 تم التعديل بنجاح 🎉\n\n🏙️ افتح المدينة وشاهد التغييرات 🏙️")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearList()
 gg.clearResults()
 end --👹تم الانتهاء👹
 
 
 
 --تجميد الكروت 
 function HH6()
    local CARD_H2 = 1918984974 -- card_01 .. card_99
    local CARD_H3 = 1918984976 -- card_100 .. card_160
    local CARD_RANGE = CARD_H2 .. "~" .. CARD_H3
    local OFF_CNT, OFF_A, OFF_B = 24, 28, 32
    local VAL_MAX = 150000

    local choice = gg.choice({
        "🃏 150 كارت",
        "🃏 160 كارت"
    }, nil, "🃏 كم عدد الكروت في مجموعتك؟")
    if not choice then return end
    local CARD_MAX = (choice == 1) and 150 or 160

    local function getCardCode(n)
        local s = string.format("card_%02d", n)
        local bytes = {#s * 2}
        for i = 1, #s do bytes[#bytes + 1] = s:byte(i) end
        for i = #bytes + 1, 24 do bytes[i] = 0 end
        local code = {}
        for i = 0, 5 do
            local b = i * 4
            code[i + 1] = bytes[b + 1]
                        + bytes[b + 2] * 256
                        + bytes[b + 3] * 65536
                        + bytes[b + 4] * 16777216
        end
        return code
    end

    local cardLookup = {}
    for n = 1, CARD_MAX do
        local c = getCardCode(n)
        if n < 100 then
            cardLookup[c[1] .. ":" .. c[2]] = n
        else
            cardLookup[c[1] .. ":" .. c[2] .. ":" .. (c[3] % 256)] = n
        end
    end

    gg.clearResults()
    gg.searchNumber(CARD_RANGE .. ";1~15000::33", gg.TYPE_DWORD)
    gg.refineNumber(CARD_RANGE, gg.TYPE_DWORD)

    local count = gg.getResultCount()
    if count == 0 then
        gg.alert(
            "⚠️ لم يتم العثور ⚠️\n\n" ..
            "تأكد من وجود كارت في مجموعتك\n" ..
            "له نسخة واحدة فقط وليس أكثر.\n\n" ..
            "🔄 ثم أعد المحاولة.\n\n" ..
            "📌 إذا لم تنجح الطريقة:\n" ..
            "اضبط نطاقات الذاكرة المناسبة لجهازك.",
            "حسناً")
        return
    end

    local results = gg.getResults(count)

    local OFFSETS = {0, 4, 8, OFF_CNT, OFF_A, OFF_B}
    local N = #OFFSETS
    local reads = {}
    for _, r in ipairs(results) do
        for _, off in ipairs(OFFSETS) do
            reads[#reads + 1] = {address = r.address + off, flags = gg.TYPE_DWORD}
        end
    end
    local vals = gg.getValues(reads)


    local function isRealEntry(cnt, a, c)
        return a >= 1 and a <= VAL_MAX and c >= 1 and c <= VAL_MAX
    end

    local found, foundAny = {}, false
    local writeTo, fallback
    for i = 1, count do
        local b = (i - 1) * N
        local v1  = vals[b + 1].value
        local v2  = vals[b + 2].value
        local v3  = vals[b + 3].value
        local cnt = vals[b + 4].value
        local a   = vals[b + 5].value
        local c   = vals[b + 6].value

        local key
        if v1 == CARD_H2 then
            key = v1 .. ":" .. v2
        elseif v1 == CARD_H3 then
            key = v1 .. ":" .. v2 .. ":" .. (v3 % 256)
        end
        local n = key and cardLookup[key]

        if n and isRealEntry(cnt, a, c) then
            found[n] = true
            foundAny = true

            local item = {address = results[i].address, flags = results[i].flags}
            if not writeTo and v1 == CARD_H2 and a == 1 and c == 1 then
                writeTo = item
            end
            if not fallback then
                fallback = item
            end
        end
    end

    if not foundAny then
        gg.alert(
            "⚠️ لم يتم العثور على كروت صالحة ⚠️\n\n" ..
            "🔄 أعد المحاولة، أو اضبط نطاقات الذاكرة المناسبة لجهازك.",
            "حسناً")
        return
    end

    writeTo = writeTo or fallback

    local missingList = {}
    for n = 1, CARD_MAX do
        if not found[n] then missingList[#missingList + 1] = n end
    end

    if #missingList == 0 then
        gg.alert("🎉 جميع الكروت موجودة في مجموعتك!\nلا يوجد شيء للتجميد.", "حسناً")
        return
    end

    if not writeTo then
        gg.alert(
            "⚠️ لم يتم العثور ⚠️\n\n" ..
            "🔄 أعد المحاولة، أو اضبط نطاقات الذاكرة المناسبة لجهازك.",
            "حسناً")
        return
    end


    local missingToFreeze = missingList[1]
    local code = getCardCode(missingToFreeze)

    local editTable = {}
    for i = 1, 6 do
        editTable[i] = {
            address = writeTo.address + (i - 1) * 4,
            flags = writeTo.flags,
            value = code[i]
        }
    end

    gg.setValues(editTable)
    gg.addListItems(editTable)


    local shown = {}
    for i = 1, math.min(#missingList, 40) do
        shown[i] = missingList[i]
    end
    local missingText = table.concat(shown, "، ") .. (#missingList > 40 and " ..." or "")


    gg.alert(
        "📋 الكروت المفقودة: " .. missingText .. "\n\n" ..
        "❄️ تم تجميد الكارت رقم: " .. missingToFreeze .. "\n\n" ..
        "━━━━━━━━━━━━━━━\n" ..
        "⚠️ كل ما عليك زيادة الكارت الناقص\n" ..
        "من التذكرة 🎫 أو من صندوق النجوم ⭐",
        "حسناً")
end


--اظهار التذكره الذهبيه المخفيه
function HHH9()
    gg.setVisible(false)
    
    local success = true
    
    -- ═══════════════════════════════════════════════════════════════
    -- المرحلة 1: الفحص التلقائي (استخراج الرقم الحالي)
    -- ═══════════════════════════════════════════════════════════════
    gg.clearResults()
    
    gg.searchNumber("1634038552;1937011470;700~10000::121", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    gg.refineNumber("700~10000", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    
    local count = gg.getResultCount()
    if count == 0 then
        success = false
    else
        local results = gg.getResults(count)
        local counts = {}
        local maxCount = 0
        local currentId = results[1].value
        
        for _, r in ipairs(results) do
            local val = r.value
            counts[val] = (counts[val] or 0) + 1
            if counts[val] > maxCount then
                maxCount = counts[val]
                currentId = val
            end
        end
        
        gg.clearResults()
        
        -- ═══════════════════════════════════════════════════════════════
        -- المرحلة 2: إعادة ضبط كل التصاريح (بدون قائمة)
        -- ═══════════════════════════════════════════════════════════════
        gg.clearResults()
        
        gg.searchNumber("1634038552;1937011470;700~10000::121", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
        gg.refineNumber("700~10000", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
        
        local resetCount = gg.getResultCount()
        if resetCount == 0 then
            success = false
        else
            local resetResults = gg.getResults(resetCount)
            
            local ticketsTable = {
                [780] = {
                    startTime = 1785488400,
                    endTime   = 1787302800
                },
                [790] = {
                    startTime = 1787302800,
                    endTime   = 1789117200
                },
                [800] = {
                    startTime = 1789117200,
                    endTime   = 1790931600
                },
                [810] = {
                    startTime = 1790931600,
                    endTime   = 1792746000
                },
                [820] = {
                    startTime = 1792746000,
                    endTime   = 1794560400
                }
            }
            
            local uniqueValues = {}
            local valueToAddressMap = {}
            
            for _, result in ipairs(resetResults) do
                local value = tonumber(result.value)
                if value and not uniqueValues[value] then
                    uniqueValues[value] = true
                    valueToAddressMap[value] = result.address
                end
            end
            
            local editList = {}
            
            for ticketNum, baseAddress in pairs(valueToAddressMap) do
                local ticketData = ticketsTable[ticketNum]
                
                if ticketData then
                    table.insert(editList, {
                        address = baseAddress + 16,
                        value = 0,
                        flags = gg.TYPE_DWORD
                    })
                    table.insert(editList, {
                        address = baseAddress + 20,
                        value = ticketData.startTime,
                        flags = gg.TYPE_DWORD
                    })
                    table.insert(editList, {
                        address = baseAddress + 24,
                        value = 0,
                        flags = gg.TYPE_DWORD
                    })
                    table.insert(editList, {
                        address = baseAddress + 28,
                        value = ticketData.endTime,
                        flags = gg.TYPE_DWORD
                    })
                end
            end
            
            if #editList > 0 then
                gg.setValues(editList)
            end
            
            gg.clearResults()
            
            -- ═══════════════════════════════════════════════════════════════
            -- المرحلة 3: التبديل التلقائي (currentId → currentId + 10)
            -- ═══════════════════════════════════════════════════════════════
            local destId = currentId + 10
            
            if ticketsTable[destId] then
                gg.clearResults()
                
                gg.searchNumber("1634038552;1937011470;700~10000::121", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
                gg.refineNumber("700~1000", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
                
                local swapResults = gg.getResults(100)
                local srcAddress = nil
                local destAddresses = {}
                
                for _, v in ipairs(swapResults) do
                    if v.value == currentId and srcAddress == nil then 
                        srcAddress = v.address 
                    end
                    if v.value == destId then 
                        table.insert(destAddresses, v.address) 
                    end
                end
                
                if srcAddress and #destAddresses > 0 then
                    local sourceValues = {}
                    for i = 0, 323 do
                        sourceValues[i + 1] = {address = srcAddress - 0x1E8 + (i * 4), flags = gg.TYPE_DWORD}
                    end
                    
                    local data = gg.getValues(sourceValues)
                    
                    local allTargetValues = {}
                    for _, dAddr in ipairs(destAddresses) do
                        for i = 0, 323 do
                            table.insert(allTargetValues, {
                                address = dAddr - 0x1E8 + (i * 4), 
                                flags = gg.TYPE_DWORD, 
                                value = data[i + 1].value
                            })
                        end
                    end
                    
                    gg.setValues(allTargetValues)
                end
                
                gg.clearResults()
            end
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- المرحلة 4: إظهار التصريح المختفي
    -- ═══════════════════════════════════════════════════════════════
    gg.clearResults()
    
    gg.searchNumber("1937011470;1701998435;700~10000;1634030360::161", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    gg.refineNumber("700~10000", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    
    local showCount = gg.getResultCount()
    if showCount == 0 then
        success = false
    else
        local showResults = gg.getResults(showCount)
        local showEditList = {}
        
        for _, r in ipairs(showResults) do
            local baseAddress = r.address
            
            local vals = gg.getValues({
                {address = baseAddress + 16, flags = gg.TYPE_DWORD},
                {address = baseAddress + 20, flags = gg.TYPE_DWORD}
            })
            
            if vals and vals[1] and vals[2] then
                local val16 = vals[1].value
                local val20 = vals[2].value
                
                table.insert(showEditList, {address = baseAddress + 8, value = val16, flags = gg.TYPE_DWORD})
                table.insert(showEditList, {address = baseAddress + 12, value = val20, flags = gg.TYPE_DWORD})
            end
        end
        
        if #showEditList > 0 then
            gg.setValues(showEditList)
        end
        
        gg.clearResults()
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- الرسالة النهائية
    -- ═══════════════════════════════════════════════════════════════
    if success then
        gg.alert("✅ يمكنك إغلاق اللعبة وفتحها مرة أخرى")
    else
        gg.alert("❌ الكود لا يعمل\n\n🔄 يرجى التأكد وإعادة المحاولة")
    end
    
    saveState("TICKET_MENU", "0")
    gg.setVisible(false)
end


----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------

--قسم حديقه الحيوانات 
--حيوانات السافانا
function H1()
gg.alert("🤡 تنزيل كل يوم قسم من اقسام الحيوانات لتجنب الحظر 🤡")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("1635148147;1818324232;1835361804", gg.TYPE_DWORD)
gg.refineNumber("1635148147", gg.TYPE_DWORD)
n = gg.getResultCount()
jz = gg.getResults(n)
local messageShown = false
 local toastShown = false
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 168,flags = gg.TYPE_DWORD,freeze = true,value = "30",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 304,flags = gg.TYPE_DWORD,freeze = true,value = "30",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 440,flags = gg.TYPE_DWORD,freeze = true,value = "15",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 576,flags = gg.TYPE_DWORD,freeze = true,value = "10",gg.TYPE_DWORD}})

if not messageShown then
if not toastShown then
gg.alert("🤡مبروك تنزيل جميع حيوانات السفانا🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼??𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
messageShown = true
toastShown = true
gg.clearList() 
gg.clearResults()
end
end
end
end

--حيوانات المستنقعات
function H2()
gg.alert("🤡 تنزيل كل يوم قسم من اقسام الحيوانات لتجنب الحظر 🤡")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("1835104115;1818324232;1835361804", gg.TYPE_DWORD)
gg.refineNumber("1835104115", gg.TYPE_DWORD)
n = gg.getResultCount()
jz = gg.getResults(n)
local messageShown = false
local toastShown = false
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 168,flags = gg.TYPE_DWORD,freeze = true,value = "30",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 304,flags = gg.TYPE_DWORD,freeze = true,value = "30",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 440,flags = gg.TYPE_DWORD,freeze = true,value = "15",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 576,flags = gg.TYPE_DWORD,freeze = true,value = "10",gg.TYPE_DWORD}})

if not messageShown then
if not toastShown then
gg.alert("🤡مبروك تنزيل جميع حيوانات المستنقع🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
messageShown = true
toastShown = true
gg.clearList() 
gg.clearResults()
end
end
end
end

--حيوانات الغابا
function H3()
gg.alert("🤡 تنزيل كل يوم قسم من اقسام الحيوانات لتجنب الحظر 🤡")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("1701998438;1818324232;1835361804", gg.TYPE_DWORD)
gg.refineNumber("1701998438", gg.TYPE_DWORD)
n = gg.getResultCount()
jz = gg.getResults(n)
local messageShown = false
local toastShown = false
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 168,flags = gg.TYPE_DWORD,freeze = true,value = "30",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 304,flags = gg.TYPE_DWORD,freeze = true,value = "30",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 440,flags = gg.TYPE_DWORD,freeze = true,value = "15",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 576,flags = gg.TYPE_DWORD,freeze = true,value = "10",gg.TYPE_DWORD}})

if not messageShown then
if not toastShown then
gg.alert("🤡مبروك تنزيل جميع حيوانات الغابا🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
messageShown = true
toastShown = true
gg.clearList() 
gg.clearResults()
end
end
end
end

-- حيوانات الجليد
function H4()
gg.alert("🤡 تنزيل كل يوم قسم من اقسام الحيوانات لتجنب الحظر 🤡")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("6644585;1818324232;1835361804", gg.TYPE_DWORD)
gg.refineNumber("6644585", gg.TYPE_DWORD)
n = gg.getResultCount()
jz = gg.getResults(n)
local messageShown = false
 local toastShown = false
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 168, flags = gg.TYPE_DWORD, freeze = true, value = "30", gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 304, flags = gg.TYPE_DWORD, freeze = true, value = "30", gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 440, flags = gg.TYPE_DWORD, freeze = true, value = "15", gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 576, flags = gg.TYPE_DWORD, freeze = true, value = "10", gg.TYPE_DWORD}})

if not messageShown then
if not toastShown then
gg.alert("🤡مبروك تنزيل جميع حيوانات الجليد🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
messageShown = true
toastShown = true
gg.clearList() 
gg.clearResults()
end
end
end
end


--حيوانات الادغال
function H5()
gg.alert("?? تنزيل كل يوم قسم من اقسام الحيوانات لتجنب الحظر 🤡")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)

gg.searchNumber("1735292266;1818324232;1835361804", gg.TYPE_DWORD)
gg.refineNumber("1735292266", gg.TYPE_DWORD)
n = gg.getResultCount()
jz = gg.getResults(n)
local messageShown = false
    local toastShown = false

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 168,flags = gg.TYPE_DWORD,freeze = true,value = "30",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 304,flags = gg.TYPE_DWORD,freeze = true,value = "30",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 440,flags = gg.TYPE_DWORD,freeze = true,value = "15",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 576,flags = gg.TYPE_DWORD,freeze = true,value = "10",gg.TYPE_DWORD}})

if not messageShown then
if not toastShown then
gg.alert("🤡مبروك تنزيل جميع حيوانات الادغال🤡")
gg.toast("??‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
messageShown = true
toastShown = true
gg.clearList() 
gg.clearResults()
end
end
end
end
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------

--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾????🇪🇾🇪🇾🇪🇾🇪
--قسم جميع الاكواد

-- قسيمه التوسع
function M1()
return { values = {1701996058, 1886930277, 1769172577, 28271, 0, 0},name = "قسيمة التوسع"}end
--قسيمة الدعم 
function M2()
return { values = {1970225964, 1282305904, 1415864687, 1852399986, 1886546241, 7631471},name = "قسيمة الدعم"}end
--قسيمة المصانع 
function M3()
return { values = {1970225960, 1433300848, 1634887536, 1632003428, 1919906915, 121},name = "قسيمة المصانع"}end
--قسيمة القطار 
function M4()
return { values = {1970225956, 1433300848, 1634887536, 1918133604, 7235937, 0},name = "قسيمة القطار"}end
--قسيمة الجزر 
function M5()
return { values = {1970225958, 1433300848, 1634887536, 1934189924, 1684955500, 0},name = "قسيمة الجزر"}end
--قسيمة الشونه
function M6()
return { values = {1701996056, 1651327333, 1850307169, 99, 0, 0},name = "قسيمة الشونة"}end
--قسيمة التاجر
function M7()
return { values = {1970225952, 1215197040, 1147499113, 1701601637, 114, 0},name = "قسيمة التاجر"}end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- قسم السبائك

-- سبائك برونزية
function K1()
return { values = {1869759016, 1113946734, 1768713333, 1866690159, 1702129269, 114}, name = "السبيكة البرونزية" }end
-- سبائك فضة
function K2()
return { values = {1818841896, 1114793334, 1768713333, 1866690159, 1702129269, 114}, name = "السبيكة الفضية" }end
-- سبائك ذهب
function K3()
return { values = {1819232036, 1819624036, 1852795244, 1853189955, 7497076, 0}, name = "السبيكة الذهبية" }end
-- سبائك بلاتين
function K4()
return { values = {1634488364, 1970170228, 1819624045, 1852795244, 1853189955, 7497076}, name = "السبيكة البلاتينية" }end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- قسم أدوات المنجم

-- معول
function V1()
return { values = {3304708, 0, 0, 0, 0, 0}, name = "المعول" }end
-- ديناميت
function V2()
return { values = {3370244, 0, 0, 0, 0, 0}, name = "ديناميت" }end
-- متفجرات
function V3()
return { values = {3239172, 0, 0, 0, 0, 0}, name = "المتفجرات" }end
-- صاروخ المنجم
function V4()
return { values = {1599099682, 1734830404, 1348955753, 1768777074, 28021, 0}, name = "صاروخ المنجم" }end
--🇾🇪🇾🇪🇾🇪??🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾??🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- قسم المجوهرات

-- التوباز الأصفر
function DD1()
return { values = {1835362056, 49, 0, 0, 0, 0}, name = "التوباز الأصفر" }end
-- الزمرد الأخضر
function DD2()
return { values = {1835362056, 50, 0, 0, 0, 0}, name = "الزمرد الأخضر" }end
-- الياقوت الأحمر
function DD3()
return { values = {1835362056, 51, 0, 0, 0, 0}, name = "الياقوت الأحمر" }end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾??🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- قسم اكواد الشونه 

-- مطرقه شونه
function A1()
return { values = {1835100178, 1299342701, 29793, 0, 0, 0}, name = "مطرقه شونه" }end
-- مسمار شونه
function A2()
return { values = {1767992846, 1952533868, 29793, 0, 0, 0}, name = "مسمار شونه" }end
-- طلاء احمر شونه
function A3()
return { values = {1767993366, 1699902574, 1952533860, 0, 0, 0}, name = "طلاء احمر شونه" }end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- قسم اكواد البناء

-- طوب احمر 
function AA1()
return { values = {1769095690, 1107323747, 1768713333, 1866690159, 1702129269, 114}, name = "طوب احمر" }end
-- بلاط ابيض
function AA2()
return { values = {1768706058, 1107321204, 1768713333, 1866690159, 1702129269, 114}, name = "بلاط ابيض" }end
-- زجاج
function AA3()
return { values = {1634486026, 29555, 0, 0, 0, 0}, name = "زجاج" }end
-- مثقاب
function AA4()
return { values = {1769104394, 27756, 0, 0, 0, 0}, name = "مثقاب" }end
-- مطرقة ثاقبه
function AA5()
return { values = {1667328532, 1835100267, 7497069, 0, 0, 0}, name = "مطرقة ثاقبة" }end
-- منشار كهربائي 
function AA6()
return { values = {2003791888, 1634955877, 119, 0, 0, 0}, name = "منشار كهربائي" }end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- قسم حدث الوان

-- مطرقة ثاقبة حدث الوان
function B1()
return { values = {1211329808, 1701670241, 114, 0, 0, 0}, name = "مطرقة ثاقبة حدث الوان" }end
-- صنبور حدث الوان
function B2()
return { values = {1395879196, 1734632812, 1835100261, 7497069, 0, 0}, name = "صنبور حدث الوان" }end
-- قفاز حدث الوان
function B3()
return { values = {1194552590, 1702260588, 0, 0, 0, 0}, name = "قفاز حدث الوان" }end
-- صاروخ حدث الوان
function B4()
return { values = {1278438668, 6647401, 0, 0, 0, 0}, name = "صاروخ حدث الوان" }end
-- ديناميت حدث الوان
function B5()
return { values = {1110666508, 6450543, 0, 0, 0, 0}, name = "ديناميت حدث الوان" }end
-- كرة قوس قزح حدث الوان
function B6()
return { values = {1379101978, 1651403105, 1631745903, 27756, 0, 0}, name = "كرة قوس قزح حدث الوان" }end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--قسم حدث الالوان الجديد

-- مطرقة ثاقبة 
function C1()
return { values = {1295215888,1701604449,116,0,0,0}, name = "مطرقة ثاقبة" }end
-- مثقاب
function C2()
return { values = {1211329824,2053730927,1635020399,1852394604,101,0}, name = "مثقاب" }end
-- ثقل
function C3()
return { values = {1446210844,1769239141,1282171235,6647401,0,0}, name = "ثقل" }end
-- مروحية 
function C4()
return { values = {1379101974,1969779557,1701602918,0,0,0}, name = "مروحية" }end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪??🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪

--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- قسم علف الحيوانات 

-- علف أبقار
function WW1()
return { values = {2003788558, 1684366694, 0, 0, 0, 0}, name = "علف أبقار" }end
-- علف دجاج
function WW2()
return { values = {1768448790, 1852140387, 1684366694, 0, 0, 0}, name = "علف دجاج" }end
-- علف الخروف
function WW3()
return { values = {1701344018, 1701212261, 25701, 0, 0, 0}, name = "علف الخروف" }end
-- غذاء النحل
function WW4()
return { values = {1701143054, 1684366694, 0, 0, 0, 0}, name = "غذاء النحل" }end
-- طعام الخنزير
function WW5()
return { values = {1734963214, 1684366694, 0, 0, 0, 0}, name = "طعام الخنزير" }end
-- المادة
function WW6()
return { values = {1937075480, 1869574760, 1701144173, 100, 0, 0}, name = "المادة" }end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾??🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--اكواد تصفير الوقت

-- تصفير وقت المحاصيل
function WWW1()
return { values = {1599099692, 1936682818, 1701860212, 1884644453, 1987207496, 7631717}, name = "تصفير وقت المحاصيل" }end
-- تصفير وقت الطائرة
function WWW2()
return { values = {1599099684, 1936682818, 1701860212, 1884644453, 7498049, 0}, name = "تصفير وقت الطائرة" }end


--تصفير وقت الحيوانات ثابت
function WWW3() 
gg.alert("قبل البدء عليك استلام هديه قسيمه المصانع")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("65537;1970225964;7631471;-1::89", gg.TYPE_DWORD)
gg.refineNumber("1970225964", gg.TYPE_DWORD)
n = gg.getResultCount()
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
local checkValue = gg.getValues({{address = jz[i].address - 4, flags = gg.TYPE_DWORD}})[1]
    if checkValue.value == 0 then
        gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0"}})
        gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0"}})
        gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0"}})
    end
end 
-- هديه قسيمه المصانع 
gg.clearResults()
gg.searchNumber("1B;1970225960D;-1D:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1970225960", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 0,flags = gg.TYPE_DWORD,freeze = true,value = "1599099688",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 4,flags = gg.TYPE_DWORD,freeze = true,value = "1936682818",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 8,flags = gg.TYPE_DWORD,freeze = true,value = "1701860212",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 12,flags = gg.TYPE_DWORD,freeze = true,value = "1884644453",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 16,flags = gg.TYPE_DWORD,freeze = true,value = "1836212550",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 20,flags = gg.TYPE_DWORD,freeze = true,value = "115",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 24,flags = gg.TYPE_QWORD,freeze = true,value = "100",gg.TYPE_QWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("65537~65542;1970225964;5;29::457", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("29", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)


for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 16,flags = gg.TYPE_DWORD,freeze = true,value = "1599099688",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 20,flags = gg.TYPE_DWORD,freeze = true,value = "1936682818",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 24,flags = gg.TYPE_DWORD,freeze = true,value = "1701860212",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 28,flags = gg.TYPE_DWORD,freeze = true,value = "1884644453",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 32,flags = gg.TYPE_DWORD,freeze = true,value = "1836212550",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 36,flags = gg.TYPE_DWORD,freeze = true,value = "115",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 40,flags = gg.TYPE_QWORD,freeze = true,value = "100",gg.TYPE_QWORD}})
gg.alert("كل ما تفعله الان اذهب الي الهديه 29 واحصل عليها")
gg.toast("🏴‍☠️🔥MAHMOUDHERO🔥??‍☠️")
end -- 👹تم الانتهاء👹
end


--البناء
function WWW4()
applyStatue({1113542739, 1953722223, 1701146707, 1114658148, 1684826485, 1936158313, 24}, "تصفير البناء", true)end
--الشونه

function WWW5()
applyStatue({1113542739, 1953722223, 1919906899, 1130719073, 1667330145, 7959657, 25, 23}, "زيادة الشونه", true)end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--اكواد طاقه وقمبله

-- الطاقة
function W1()
applyTicket({1886938400, 1953064037, 1164865385, 1735550318, 121, 0},"الطاقة", true)end
-- القنبلة
function W2()
applyTicket({1886938394, 1953064037, 1416523625, 21582, 0, 0},"القنبلة", true)end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- قسم العناصر العامة

-- الكاش
function G1()
gg.alert("⚠️ ملحوظه يجب ان يكون العدد صغير حتي لا يتم حظرك⚠️")
applyTicket({1935762184, 104, 0, 0, 0, 0},"الكاش", true)end
-- الفلوس
function G2()
gg.alert("⚠️ملحوظه وضع العدد 950 الف او اقل  حتي لا يتم حظرك⚠️")
applyTicket({1768907530, 29550, 0, 0, 0, 0},"الفلوس", true)end
-- المستوي
function G3()
gg.alert("⚠️ ملحوظة لا تضع عدد كبير حتي لا يتم ارتفاع المستوي بشكل كبير⚠️")
applyTicket({1886938374, 0, 0, 0, 0, 0},"المستوى", true)end
-- كود الكتاب الاول
function G4()
applyTicket({1635021594, 1600484724, 1953067639, 29285, 0, 0},"الكتاب الأول")end
-- حدث الإطار  عملات الثروة المتحمدة
function G5()
applyTicket({1634878494,1315860327,1416917861,1852140399,0,0},"حدث الإطار", true)end
--حدث الاسم
function G6()
    local choice = gg.choice({
        "شكل اظهار وطنين",
        "شكل عناصر الأربعه",
        "🔙 رجوع"
    }, nil, "اختر شكل حدث الاسم")

    if choice == nil then return end

    if choice == 1 then
        -- شكل اظهار وطنين 
        applyTicket({1634882594, 1867148905, 1701737077, 1802458233, 28261, 0}, "حدث الاسم (اظهار وطنين)", true)

    elseif choice == 2 then
        -- شكل عناصر الأربعه
        applyTicket({1970226726, 1701594482, 1953391981, 1867800435, 1936614763, 0}, "حدث الاسم (عناصر الأربعه)", true)

    elseif choice == 3 then
        return
    end
end

-- ═══════════════════════════════════════════════
-- G7: مضاعف الحدث
-- ═══════════════════════════════════════════════
function G7()
gg.alert("⏱️ تنبيه مهم ⏱️\n\n" ..
         "عدد ثواني اليوم الواحد = 86400\n\n" ..
         "• لو عايز يوم واحد → اكتب 86400\n" ..
         "• لو عايز 3 أيام → 86400 × 3 = 259200\n" ..
         "• لو عايز أسبوع → 86400 × 7 = 604800\n\n" ..
         "💡 اضرب 86400 في عدد الأيام اللي تريدها")
applyTicket({1835619372, 1850041445, 2037672308, 1635214674, 1816224882, 3299436},"مضاعف الحدث", true)end


-- ═══════════════════════════════════════════════
-- G8: مضاعفة خام المنجم
-- ═══════════════════════════════════════════════
function G8()
gg.alert("⏱️ تنبيه مهم ⏱️\n\n" ..
         "عدد ثواني اليوم الواحد = 86400\n\n" ..
         "• لو عايز يوم واحد → اكتب 86400\n" ..
         "• لو عايز 3 أيام → 86400 × 3 = 259200\n" ..
         "• لو عايز أسبوع → 86400 × 7 = 604800\n\n" ..
         "💡 اضرب 86400 في عدد الأيام اللي تريدها")
applyTicket({1835619372, 1850041445, 2037672308, 1635214674, 1766679666, 3237230},"مضاعفة خام المنجم", true)end --👹تم الانتهاء👹

--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--اكواد الأكياس--


-- الكيس البرونزي 
function Cartas1()
applyTicket({1918976790,1348420452,829121377,0,0,0},"الكيس البرونزي", true)end

-- الكيس الأخضر 
function Cartas2()
applyTicket({1918976790,1348420452,845898593,0,0,0},"الكيس الأخضر", true)end

-- الكيس الأزرق 
function Cartas3()
applyTicket({1918976790,1348420452,862675809,0,0,0},"الكيس الأزرق", true)end

-- الكيس البنفسجي 
function Cartas4()
applyTicket({1918976790,1348420452,879453025,0,0,0},"الكيس البنفسجي", true)end

-- الكيس الذهبي 
function Cartas5()
applyTicket({1918976790,1348420452,896230241,0,0,0},"الكيس الذهبي", true)end

--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪??🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪


-- اكواد القطار 

-- قطار فائق السرعة
function Train1()
applyTicket({1768641308, 1918132078, 1601071457, 3297363, 0, 0}, "قطار فائق السرعة")end
-- قطار الأشباح
function Train2()
applyTicket({1768641308, 1918132078, 1601071457, 3493971, 0, 0}, "قطار الأشباح")end
-- قطار الديسكو
function Train3()
applyTicket({1768641308, 1918132078, 1601071457, 3690579, 0, 0}, "قطار الديسكو")end
-- قطار رعاة البقر
function Train4()
applyTicket({1768641316, 1918132078, 1601071457, 1953719671, 7238245, 0}, "قطار رعاة البقر")end
-- قطار الكريسماس
function Train5()
applyTicket({1768641320, 1918132078, 1601071457, 1769105507, 1634563187, 115}, "قطار الكريسماس")end
-- قطار عيد الفصح
function Train6()
applyTicket({1768641314, 1918132078, 1601071457, 1953718629, 29285, 0}, "قطار عيد الفصح")end
-- قطار بدائي سريع
function Train7()
applyTicket({1768641324, 1918132078, 1601071457, 1751478896, 1869902697, 6515058}, "قطار بدائي سريع")end
-- قطار مسرحي سريع
function Train8()
applyTicket({1768641322, 1918132078, 1601071457, 1634035828, 1667854964, 27745}, "قطار مسرحي سريع")end
-- قطار التنين
function Train9()
applyTicket({1768641324, 1918132078, 1601071457, 1634628972, 844713586, 3289648}, "قطار التنين")end
-- مسبار المريخ
function Train10()
applyTicket({1768641310, 1918132078, 1601071457, 1936875885, 0, 0}, "مسبار المريخ")end
-- قطار العربة الخشبية
function Train11()
applyTicket({1768641320, 1918132078, 1601071457, 1768058738, 1869564014, 100}, "قطار العربة الخشبية")end
-- قطار الموسيقى السريع
function Train12()
applyTicket({1768641320, 1918132078, 1601071457, 1801678706, 1819243118, 108}, "قطار الموسيقى السريع")end
-- قطار الفرسان
function Train13()
applyTicket({1768641314, 1918132078, 1601071457, 1734962795, 29800, 0}, "قطار الفرسان")end
-- قطار الترام السريع
function Train14()
applyTicket({1768641320, 1918132078, 1601071457, 1818326121, 842019449, 52}, "قطار الترام السريع")end
--قطار الهالوين 
function Train15()
applyStatue({1852402515, 1634882655, 1751084649, 1869376609, 1852138871, 875704370, 24}, "قطار الهاليون")end
--قطار عيد الميلاد 
function Train16()
applyStatue({1852402515, 1634882655, 1667198569, 1936290408, 1935764852, 875704370, 24}, "قطار عيد الميلاد")end
-- قطار الزهور
function Train17()
applyTicket({1768641318, 1918132078, 1601071457, 1953719654, 1818326633, 0}, "قطار الزهور")end
--القطار الأسطوري
function Train18()
applyTicket({1768641322, 1918132078, 1601071457, 1819043176, 808612705, 13618}, "القطار الأسطوري")end
--قطار غاتسبي
function Train19()
applyTicket({1768641314, 1918132078, 1601071457, 1937006919, 31074, 0}, "قطار غاتسبي")end
--القطار الفرنسي 
function Train20()
applyTicket({1768641320, 1918132078, 1601071457, 1851880038, 912221539, 56}, "القطار الفرنسي")end
--قطار المشاهير 
function Train21()
applyStatue({1852402515, 1634882655, 1667198569, 1650814053, 2037672306, 3356511, 23}, "قطار المشاهير")end
--قطار مستقبلي 
function Train22()
applyTicket({1768641320, 1918132078, 1601071457, 1970566502, 928998770, 54}, "قطار مستقبلي")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡

 --اكواد المحطه 

--بوابه القطار السريع 
function Station1()
applyTicket({1768641322, 1918132078, 1399744865, 1769234804, 1398763119, 12880}, "بوابة القطار السريع")end
-- محطة الاشباح
function Station2()
applyTicket({1768641322, 1918132078, 1399744865, 1769234804, 1398763119, 13648}, "محطة الأشباح")end
-- محطة الديسكو
function Station3()
applyTicket({1768641322, 1918132078, 1399744865, 1769234804, 1398763119, 14416}, "محطة الديسكو")end
--محطه رعاة البقر
function Station4()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1702322030, 1919251571, 110, 25}, "محطه رعاة البقر")end
--محطه الكريسماس 
function Station5()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1751342958, 1953720690, 7561581, 27}, "محطه الكريسماس")end
--محطه عيد الفصح 
function Station6()    
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1634033518, 1919251571, 24}, "محطة عيد الفصح")end
--مستوطنة قديمة
function Station7()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1919967086, 1936287845, 1769107316, 99, 29}, "مستوطنة قديمة")end
-- محطة مسرحية
function Station8()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1752457070, 1920229733, 1818321769, 28160, 28}, "محطة مسرحية")end
-- محطة صينية
function Station9()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1970036590, 1316118894, 842019417, 50, 29}, "محطة صينية")end
--محطه فضاء
function Station10()
applyTicket({1768641324, 1918132078, 1399744865, 1769234804, 1834970735, 7565921}, "محطه فضاء")end
-- معسكر التدريب
function Station11()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1869766510, 1215195490, 6582127, 27}, "معسكر التدريب")end
-- مركز التسجيل
function Station12()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1869766510, 1919839075, 7105647, 27}, "مركز التسجيل")end
-- محطة القلعة
function Station13()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1852530542, 1952999273, 24}, "محطة القلعة")end
-- محطة رومانية
function Station14()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1953062766, 846818401, 3420720, 27}, "محطة رومانية")end
-- محطة الهالوين
function Station15()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1634230126, 2003790956, 846095717, 3420720, 31}, "محطة الهالوين")end
-- محطة عيد الميلاد
function Station16()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1751342958, 1953720690, 846422381, 3420720, 31}, "محطة عيد الميلاد")end
-- محطة الزهور
function Station17()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1701207918, 1986622579, 27745, 26}, "محطة الزهور")end
-- المحطة الأسطورية
function Station18()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1701338990, 1935764588, 892481586, 28}, "المحطة الأسطورية")end
-- محطة غاتسبي
function Station19()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1632067438, 2036495220, 24}, "محطة غاتسبي")end
-- المحطة الفرنسية
function Station20()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1919311726, 1701015137, 3683935, 27}, "المحطة الفرنسية")end
--محطة المشاهير
function Station21()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1701011310, 1919051116, 1601795177, 13111, 30}, "محطة المشاهير")end
--محطة مستقبلي
function Station22()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1969643374, 1701999988, 3553119, 27}, "محطة مستقبلي")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??

--اكواد الميناء 

--ميناء القرصان
function Port1()
applyTicket({1768641310, 1632132974, 1919902322, 827609951, 0, 0}, "ميناء القرصان")end
--ميناء إستوائي
function Port2()
applyTicket({1768641310, 1632132974, 1919902322, 961565535, 0, 0}, "ميناء إستوائي")end
--ميناء جميل
function Port3()
applyTicket({1768641314, 1632132974, 1919902322, 1918988383, 29545, 0}, "ميناء جميل")end
--رصيف اللورد
function Port4()
applyTicket({1768641316, 1632132974, 1919902322, 1852143199, 6644585, 0}, "رصيف اللورد")end
--ميناء الأهوال
function Port5()
applyStatue({1852402515, 1918978143, 1601335138, 1819042152, 1701148527, 842019438, 1031012402, 573976866, 25}, "ميناء الأهوال")end
--ميناء الرومانسية
function Port6()
applyStatue({1852402515, 1918978143, 1601335138, 1701601654, 1852404846, 1631875941, 32112761, 25}, "ميناء الرومانسيه")end
--ميناء الفايكينج
function Port7()
applyTicket({1768641322, 1632132974, 1919902322, 1919905375, 1197697380, 25711}, "ميناء الفايكينج")end
--ميناء الغابة
function Port8()
applyTicket({1768641316, 1632132974, 1919902322, 1853188703, 6646887, 0}, "ميناء الغابة")end
--ميناء الكريسماس
function Port9()
applyStatue({1852402515, 1918978143, 1601335138, 1769105507, 1634563187, 842019443, 51 , 25}, "ميناء الكريسماس")end
--ميناء الفوانيس
function Port10()
applyTicket({1768641310, 1632132974, 1919902322, 1498301279, 0, 0}, "ميناء الفوانيس")end
--ميناء قديم
function Port11()
applyTicket({1768641316, 1632132974, 1919902322, 1818585183, 7561580, 0}, "ميناء قديم")end
--صالون على الماء
function Port12()
applyStatue({1852402515, 1918978143, 1601335138, 1684826487, 1953719671, 875704370, 24}, "صالون علي الماء")end
--ميناء الحلوى
function Port13()
applyStatue({1852402515, 1918978143, 1601335138, 1953655138, 2036425832, 875704370, 24}, "ميناء الحلوي")end
--الميناء ذو الطابع المصري
function Port14()
applyTicket({1768641314, 1632132974, 1919902322, 2036819295, 29808, 0}, "الميناء ذو الطابع المصري")end
--ميناء القطب الشمالي
function Port15()
applyTicket({1768641316, 1632132974, 1919902322, 1668440415, 6515060, 0}, "ميناء القطب الشمالي")end
--ميناء العطله
function Port16()
applyStatue({1852402515, 1918978143, 1601335138, 1768713313, 1970037614, 1702259059, 892481586 ,3486208, 28}, "ميناء العطله")end
--ميناء ياباني 
function Port17()
applyTicket({1768641314, 1632132974, 1919902322, 1885432415, 28257, 0}, "الميناء الياباني")end
--ميناء الفارس
function Port18()
applyTicket({1768641316, 1632132974, 1919902322, 1768835935, 7628903, 0}, "ميناء الفارس")end
--ميناء برودواي
function Port19()
applyStatue({1852402515, 1918978143, 1601335138, 1634693730, 2036430692, 3749471, 23}, "ميناء برودواي")end
--ميناء عيد الفصح 
function Port20()
applyTicket({1768641322, 1632132974, 1919902322, 1935762783, 1601332596, 12855}, "ميناء عيد الفصح")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🛳اكواد السفن 🛳--

--سفينة القرصان
function Ship1()
applyTicket({1768641306, 1750294382, 1398763625, 12628, 0, 0}, "سفينة القرصان")end
--سفينة سياحية
function Ship2()
applyTicket({1768641306, 1750294382, 1398763625, 14672, 0, 0}, "سفينة سياحية")end
--عبارة كرواسون 
function Ship3()
applyTicket({1768641310, 1750294382, 1885302889, 1936290401, 0, 0}, "عبارة كرواسون")end
--جندول
function Ship4()
applyTicket({1768641312, 1750294382, 1985966185, 1667853925, 101, 0}, "جندول")end
--سفينه الأشباح 
function Ship5()
applyStatue({1852402515, 1768444767, 1634230128, 2003790956, 846095717, 3289648, 23}, "سفينه الاشباح")end
--قارب الحب 
function Ship6()
applyStatue({1852402515, 1768444767, 1635147632, 1953391980, 1936027241, 7954756, 23}, "قارب الحب")end
--سفينه قويه
function Ship7()
applyTicket({1768641318, 1750294382, 1851748457, 1768190575, 1685014371, 0}, "سفينه قويه")end
--سفينه سياحيه 
function Ship8()
applyTicket({1768641312, 1750294382, 1784639593, 1818717813, 101, 0}, "سفينه سياحيه")end
--قارب الهدايا 
function Ship9()
applyStatue({1852402515, 1768444767, 1751342960, 1953720690, 846422381, 3355184, 23}, "قارب الهدايا")end
--قارب التنين
function Ship10()
applyTicket({1768641306, 1750294382, 1130328169, 22862, 0, 0}, "قارب التنين")end
--سفينه يونانية 
function Ship11()
applyTicket({1768641312, 1750294382, 1751085161, 1634495589, 115, 0}, "سفينه يونانية")end
--باخره نهريه
function Ship12()
applyTicket({1768641324, 1750294382, 2002743401, 2003070057, 846492517, 3420720}, "باخره نهريه")end
--قارب الحلولي
function Ship13()
applyTicket({1768641324, 1750294382, 1650421865, 1752461929, 846815588, 3420720}, "قارب الحلولي")end
--سفينه ذات الطابع المصري 
function Ship14()
applyTicket({1768641310, 1750294382, 1700753513, 1953528167, 0, 0}, "سفينه ذات الطابع المصري")end
--سفينه القطب الشمالي 
function Ship15()
applyTicket({1768641312, 1750294382, 1633644649, 1769235314, 99, 0}, "سفينه القطب الشمالي")end
--سفينة العطلة
function Ship16()
applyStatue({1852402515, 1768444767, 1818320752, 1668180332, 1769174380, 808609142, 26}, "سفينة العطلة")end
--السفينة اليابانية
function Ship17()
applyTicket({1768641310, 1750294382, 1784639593, 1851879521, 0, 0}, "السفينة اليابانية")end
--سفينه الفارس 
function Ship18()
applyTicket({1768641312, 1750294382, 1264545897, 1751607662, 116, 0}, "سفينة الفارس")end
--سفينة برودواي
function Ship19()
applyTicket({1768641322, 1750294382, 1650421865, 1684107122, 1601790327, 14646}, "سفينة برودواي")end
-- سفينة عيد الفصح
function Ship20()
applyTicket({1768641318, 1750294382, 1700753513, 1702130529, 842489714, 0}, "سفينة عيد الفصح")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--اكواد الطائره والمطار 
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??🤡🤡🤡🤡

--✈️اكواد الطائرة ✈️--

--الطائرة الضخمة
function Airplane1()
applyTicket({1768641314, 1765891950, 1634496626, 1398760814, 13136, 0},"الطائرة الضخمة")end
--تنين خارق
function Airplane2()
applyTicket({1768641318, 1765891950, 1634496626, 1398760814, 842676048, 0},"تنين خارق")end
--طائرة استوائية
function Airplane3()
applyTicket({1768641314, 1765891950, 1634496626, 1398760814, 14672, 0},"طائرة استوائية")end
--طائرة الأشباح
function Airplane4()
applyStatue({1852402515, 1919500639, 1851878512, 1634230117, 2003790956, 846095717, 976302640,50, 29},"طائرة الأشباح")end
--مركبة إطلاق
function Airplane5()
applyTicket({1768641318, 1765891950, 1634496626, 1935631726, 1701011824, 0},"مركبة إطلاق")end
--طائرة روك
function Airplane6()
applyTicket({1768641316, 1765891950, 1634496626, 1918854510, 7037807, 0},"طائرة روك")end
--طائرة النجوم
function Airplane7()
applyTicket({1768641318, 1765891950, 1634496626, 1834968430, 1701410415, 0},"طائرة النجوم")end
--طائرة الأعياد
function Airplane8()
applyStatue({1852402515, 1919500639, 1851878512, 1751342949, 1953720690, 846422381, 3289648, 27},"طائرة الأعياد")end
--طائرة على شكل طائر
function Airplane9()
applyStatue({1852402515, 1919500639, 1851878512, 1634033509, 1919251571, 858927154, 24},"طائرة على شكل طائر")end
--طائرة الإكلير
function Airplane10()
applyTicket({1768641318, 1765891950, 1634496626, 1935631726, 1952802167, 0},"طائرة الإكلير")end
--زلاجة هوائية
function Airplane11()
applyStatue({1852402515, 1919500639, 1851878512, 1769430885, 1919251566, 1919905875, 1953628276, 25},"زلاجة هوائية")end
--طائرة الحظ
function Airplane12()
applyTicket({1768641322, 1765891950, 1634496626, 1767859566, 1634493810, 25710},"طائرة الحظ")end
--طائرة شبح
function Airplane13()
applyTicket({1768641314, 1765891950, 1634496626, 1935631726, 31088, 0},"طائرة شبح")end
--طائرة مائية
function Airplane14()
applyStatue({1852402515, 1919500639, 1851878512, 1818320741, 1668180332, 1769174380, 1811965302, 26},"طائرة مائية")end
--طائرة السيمفونية
function Airplane15()
applyStatue({1852402515, 1919500639, 1851878512, 1818451813, 1769173857, 1937075555, 25449, 26},"طائرة السيمفونية")end
--طائرة الموضة
function Airplane16()
applyTicket({1768641322, 1765891950, 1634496626, 1717527918, 1768452961, 28271},"طائرة الموضة")end
-- طائرة مصاصه الدماء
function Airplane17()
applyStatue({1852402515,1919500639,1851878512,1632132965,2003790956,846095717,3486256,27},"طائرة مصاصه الدماء")end
--طائرة الكرنفال
function Airplane18()
applyStatue({1852402515,1919500639,1851878512,1633902437,1986621042,929000545,48,25},"طائرة الكرنفال")end
--طائرة الطهي
function Airplane19()
applyStatue({1852402515, 1919500639, 1851878512, 1969446757, 1634625900, 929003890, 52, 25}, "طائرة الطهي")end

--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡

--اكواد المطار

--البوابة الجوية
function Airport1()
applyTicket({1768641312, 1765891950, 1919905906, 1347641204, 51, 0},"البوابة الجوية")end
--مطار المهرجان
function Airport2()
applyTicket({1768641312, 1765891950, 1919905906, 1347641204, 55, 0},"مطار المهرجان")end
--مطار استوائي
function Airport3()
applyTicket({1768641312, 1765891950, 1919905906, 1347641204, 57, 0},"مطار استوائي")end
--مطار الأشباح
function Airport4()
applyStatue({1852402515, 1919500639, 1953656688, 1818323039, 1702326124, 808611429, 1845506354, 26},"مطار الأشباح")end
--ميناء فضائي
function Airport5()
applyTicket({1768641316, 1765891950, 1919905906, 1886609268, 6644577, 0},"ميناء فضائي")end
--مطار روك
function Airport6()
applyTicket({1768641314, 1765891950, 1919905906, 1869766516, 27491, 0},"مطار روك")end
--مطار سينمائي
function Airport7()
applyTicket({1768641316, 1765891950, 1919905906, 1869438836, 6646134, 0},"مطار سينمائي")end
--مسكن سانتا
function Airport8()
applyStatue({1852402515, 1919500639, 1953656688, 1919443807, 1836348265, 808612705, 1694511666, 26},"مسكن سانتا")end
--مطار الفصح
function Airport9()
applyStatue({1852402515, 1919500639, 1953656688, 1935762783, 846357876, 3355184, 23},"مطار الفصح")end
--مطار الحلوى
function Airport10()
applyTicket({1768641316, 1765891950, 1919905906, 2004049780, 7628133, 0},"مطار الحلوى")end
--مركز التزلج
function Airport11()
applyStatue({1852402515, 1919500639, 1953656688, 1852405599, 1400006004, 1953656688, 24},"مركز التزلج")end
--مطار قوس قزح
function Airport12()
applyTicket({1768641320, 1765891950, 1919905906, 1919508340, 1851878501, 100},"مطار قوس قزح")end
--قاعدة سرية
function Airport13()
applyTicket({1768641312, 1765891950, 1919905906, 1886609268, 121, 0},"قاعدة سرية")end
--مطار خمس نجوم
function Airport14()
applyStatue({1852402515, 1919500639, 1953656688, 1819042143, 1818455657, 1986622325,101, 25},"مطار خمس نجوم")end
--مطار السيمفونية
function Airport15()
applyStatue({1852402515, 1919500639, 1953656688, 1634493279, 1667855219, 1769174381,825688163, 25},"مطار السيمفونية")end
--مطار الموضة
function Airport16()
applyTicket({1768641320, 1765891950, 1919905906, 1634099060, 1869178995, 110},"مطار الموضة")end
--مطار دراكولا
function Airport17()
applyStatue({1852402515, 1919500639, 1953656688, 1818314847, 1702326124, 808611429, 838874418, 26},"مطار دراكولا")end
--مطار الكرنفال
function Airport18()
applyStatue({1852402515,1919500639,1953656688,1918985055,1635150190,808935276,24},"مطار الكرنفال")end
--مطار الطهي
function Airport19()
applyStatue({1852402515, 1919500639, 1953656688, 1819632479, 1918987881, 876044153, 24}, "مطار الطهي")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--اكواد الهليكوبتر والمهبط
--🤡🤡🤡🤡🤡🤡🤡??🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡


--اكواد  طائرة الهليكوبتر 

--طبق تربو
function Helicopter1()
applyTicket({1768641322, 1699241838, 1868786028, 1919251568, 1868977503, 12858},"طبق تربو")end
-- موصل آلي
function Helicopter2()
applyTicket({1768641322, 1699241838, 1868786028, 1919251568, 1651462751, 29807},"موصل آلي")end
-- مزلقة سانتا
function Helicopter3()
applyStatue({1852402515, 1818576991, 1886348137, 1601332596, 1768254547, 842688615, 24},"مزلقة سانتا")end
-- طائرة هليكوبتر خاصة
function Helicopter4()
applyTicket({1768641324, 1699241838, 1868786028, 1919251568, 1952532319, 7955059},"طائرة هليكوبتر خاصة")end
-- الطائرة الهليكوبتر الباذنجانة
function Helicopter5()
applyStatue({1852402515, 1818576991, 1886348137, 1601332596, 1987207496, 7631717, 23},"الطائرة الهليكوبتر الباذنجانة")end
-- بساط طائر
function Helicopter6()
applyTicket({1768641324, 1699241838, 1868786028, 1919251568, 1634877791, 6515042},"بساط طائر")end
-- طائرة على شكل أريكة
function Helicopter7()
applyTicket({1768641324, 1699241838, 1868786028, 1919251568, 1936020063, 7631471},"طائرة على شكل أريكة")end
-- السفينة الطائرة
function Helicopter8()
applyTicket({1768641324, 1699241838, 1868786028, 1919251568, 1634882655, 7103862},"السفينة الطائرة")end
-- طائرة هليكوبتر دراجة
function Helicopter9()
applyTicket({1768641322, 1699241838, 1868786028, 1919251568, 1869632351, 29810},"طائرة هليكوبتر دراجة")end
--طائرة هليكوبتر قرع العسل
function Helicopter10()
applyStatue({1852402515,1818576991,1886348137,1601332596,1684957539,1818587749,1811964268,26},"طائرة هليكوبتر قرع العسل")end
--المرجل الطائر
function Helicopter11()
applyStatue({1852402515,1818576991,1886348137,1601332596,1819042152,1701148527,842019438,51,29},"المرجل الطائر")end
--طائرة هليكوبتر ريشية
function Helicopter12()
applyTicket({1768641324,1699241838,1868786028,1919251568,1634886239,7104890},"طائرة هليكوبتر ريشية")end
--قطاعة البيض
function Helicopter13()
applyStatue({1852402515,1818576991,1886348137,1601332596,1953718629,808612453,13362,26},"قطاعة البيض")end
--غواصة الأعماق الطائرة
function Helicopter14()
applyStatue({1852402515,1818576991,1886348137,1601332596,1634497633,1936290926,1936028672, 24},"غواصة الأعماق الطائرة")end
--طائرة هليكوبتر للقراصنة
function Helicopter15()
applyStatue({1852402515,1818576991,1886348137,1601332596,1634888048,808609140,1694512178,26},"طائرة هليكوبتر للقراصنة")end
--الطائرة الهليكوبتر الإحتفالية
function Helicopter16()
applyStatue({1852402515,1818576991,1886348137,1601332596,846818915,3486256,25,23},"الطائرة الهليكوبتر الإحتفالية")end
--الطائرة الهليكوبتر لقاعة الرقص
function Helicopter17()
applyStatue({1852402515,1818576991,1886348137,1601332596,1903386989,1634887029,100689252,26},"الطائرة الهليكوبتر لقاعة الرقص")end
--طائرة الديسكو الهليكوبتر
function Helicopter18()
applyTicket({1768641322,1699241838,1868786028,1919251568,1936286815,28515},"طائرة الديسكو الهليكوبتر")end
--طائرة الفضاء الهليكوبتر
function Helicopter19()
applyStatue({1852402515,1818576991,1886348137,1601332596,1936875885,892481586,1852795136,24},"طائرة الفضاء الهليكوبتر")end
--الطائرة الهليكوبتر الروك آند رول
function Helicopter20()
applyStatue({1852402515,1818576991,1886348137,1601332596,1953655106,2036425832,842019423,151650357,29},"الطائرة الهليكوبتر الروك آند رول")end
--مروحية الكريسماس
function Helicopter21()
applyStatue({1852402515,1818576991,1886348137,1601332596,1769105507,1634563187,926310259;28},"مروحية الكريسماس")end
--مروحيه الربيع 
function Helicopter22()
applyStatue({1852402515,1818576991,1886348137,1601332596,1953789282,1818653285,825712505,28}, "مروحية الربيع")end
--مروحية إيطالية
function Helicopter23()
applyStatue({1852402515, 1818576991, 1886348137, 1601332596, 1818326121, 1601069417, 1946170679, 26}, "مروحية إيطالية")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--اكواد مهبط الهليكوبتر 


-- حظيرة الطبق الطائر
function Helipad1()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1868977503,1684107008,24}, "حظيرة الطبق الطائر")end
-- محطة رسو سفن
function Helipad2()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1651462751,1811969135,26}, "محطة رسو سفن")end
-- موقف المزلقة
function Helipad3()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1701598047,6842217,27}, "موقف المزلقة")end
-- مهبط طائرات هليكوبتر خاص
function Helipad4()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1952532319,7955059,27}, "مهبط طائرات هليكوبتر خاص")end
-- مهبط الطائرة الهليكوبتر النباتي
function Helipad5()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1918978143,1953719670,28}, "مهبط الطائرة الهليكوبتر النباتي")end
-- قصر السلطان
function Helipad6()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1634877791,6515042,27}, "قصر السلطان")end
-- مهبط طائرة هليكوبتر خمس نجوم
function Helipad7()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1936020063,7631471,27}, "مهبط طائرة هليكوبتر خمس نجوم")end
-- ميناء المتجولين
function Helipad8()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1634882655,7103862,27}, "ميناء المتجولين")end
-- مهبط رياضي
function Helipad9()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1869632351,1862300786,26}, "مهبط رياضي")end
-- القصر الملكي
function Helipad10()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1852400479,1701995876,6384748,31}, "القصر الملكي")end
-- البرج المسكون
function Helipad11()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1818323039,1702326124,808611429,13106,34}, "البرج المسكون")end
-- منصة الكرنفال
function Helipad12()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1634886239,7104890,27}, "منصة الكرنفال")end
-- مهبط طائرات الفصح
function Helipad13()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1935762783,846357876,3420720,31}, "مهبط طائرات الفصح")end
-- قصر الأعماق
function Helipad14()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1819566431,1769238113,115,29}, "قصر الأعماق")end
-- مهبط الطائرة الهليكوبتر للقراصنة
function Helipad15()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1919512671,845509729,3420720,31}, "مهبط الطائرة الهليكوبتر للقراصنة")end
-- مهبط الطائرة الهليكوبتر الإحتفالية
function Helipad16()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,2037277535,892481586,28}, "مهبط الطائرة الهليكوبتر الإحتفالية")end
-- مهبط طائرة هليكوبتر لقاعة الرقص
function Helipad17()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1935764831,1919251825,6644833,31}, "مهبط طائرة هليكوبتر لقاعة الرقص")end
-- مهبط طائرة هليكوبتر الديسكو
function Helipad18()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1936286815,989884259,26}, "مهبط طائرة هليكوبتر الديسكو")end
-- مهبط طائرة الفضاء الهليكوبتر
function Helipad19()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1918987615,842019443,53,29}, "مهبط طائرة الفضاء الهليكوبتر")end
-- مهبط طائرة هليكوبتر الروك آند رول
function Helipad20()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1919500895,1633970292,808607609,13618,34}, "مهبط طائرة هليكوبتر الروك آند رول")end
-- مهبط طائرة هليكوبتر الكريسماس
function Helipad21()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1919443807,1836348265,912225121,55,41,33}, "مهبط طائرة هليكوبتر الكريسماس")end
--مهبط الربيع 
function Helipad22()
applyStatue({1852402515,1818576991,1886348137,1349674356,1701011820,1953849951,1718773108,929003884,49,41,33}, "مهبط الربيع")end
--حظيرة طائرات إيطالية
function Helipad23()
applyStatue({1852402515, 1818576991, 1886348137, 1349674356, 1701011820, 1635019103, 1851877740, 3487583, 31}, "حظيرة طائرات إيطالية")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡

--اكواد الجزيرة 

-- كوخ القراصنة
function Island1()
applyTicket({1768641322,1866882926,1701999730,1348432755,1952543337,12645},"كوخ القراصنة")end
-- مركز القراصنة
function Island2()
applyTicket({1768641322,1866882926,1701999730,1348432755,1952543337,12901},"مركز القراصنة")end
-- حصن القراصنة
function Island3()
applyTicket({1768641322,1866882926,1701999730,1348432755,1952543337,13157},"حصن القراصنة")end
-- منزل الجزيرة
function Island4()
applyTicket({1768641322,1866882926,1701999730,1197437811,1651733601,12665},"منزل الجزيرة")end
-- قصر الجزيرة
function Island5()
applyTicket({1768641322,1866882926,1701999730,1197437811,1651733601,12921},"قصر الجزيرة")end
-- مسكن الجزيرة
function Island6()
applyTicket({1768641322,1866882926,1701999730,1197437811,1651733601,13177},"مسكن الجزيرة")end
-- منزل الساحرة
function Island7()
applyStatue({1852402515,1919895135,1936028276,1632132979,2003790956,846095717,1597059632,536870961,29},"منزل الساحرة")end
-- قصر الساحرة
function Island8()
applyStatue({1852402515,1919895135,1936028276,1632132979,2003790956,846095717,1597059632,1953693746,29},"قصر الساحرة")end
-- قلعة الساحرة
function Island9()
applyStatue({1852402515,1919895135,1936028276,1632132979,2003790956,846095717,1597059632,1862271027,29},"قلعة الساحرة")end
-- القلعة الجليدية
function Island10()
applyStatue({1852402515,1919895135,1936028276,1749245811,1953720690,7561581,23},"القلعة الجليدية")end
-- باريس صغيرة
function Island11()
applyTicket({1768641318,1866882926,1701999730,1885303667,1936290401,0},"باريس صغيرة")end
-- قرية عيد الفصح
function Island12()
applyTicket({1768641320,1866882926,1701999730,1700754291,1702130529,114},"قرية عيد الفصح")end
-- جزيرة الإنسان البدائي
function Island13()
applyStatue({1852402515,1919895135,1936028276,1919967091,1936287845,1769107316,858980451,25},"جزيرة الإنسان البدائي")end
-- جزيرة الآزتك
function Island14()
applyTicket({1768641320,1866882926,1701999730,1633645427,1667593338,115},"جزيرة الآزتك")end
-- جزيرة العطلات
function Island15()
applyStatue({1852402515,1919895135,1936028276,1751342963,1953720690,1601397101,808464947,28},"جزيرة العطلات")end
--🤡🤡🤡🤡🤡🤡🤡🤡??🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
-- أكواد الأبقار 

-- بقرة سينمائية
function Cow1()
applyTicket({1768641308,1866686318,1869438839,6646134},"بقرة سينمائية")end
-- البقرة القزمة
function Cow2()
applyTicket({1768641324,1866686318,1751342967,1953720690,846422381,3289648},"البقرة القزمة")end
-- بقرة مغازلة
function Cow3()
applyTicket({1768641316,1866686318,1635147639,1953391980,6647401,0},"بقرة مغازلة")end
-- البقرة رائدة الفضاء
function Cow4()
applyTicket({1768641306,1866686318,1634557815,29554,0,0},"البقرة رائدة الفضاء")end
-- بقرة الاحتفالات
function Cow5()
applyTicket({1768641314,1866686318,1768054647,1684567154,31073,0},"بقرة الاحتفالات")end
-- البقرة صانعة الحلويات
function Cow6()
applyTicket({1768641310,1866686318,2004049783,846488933,0,0},"البقرة صانعة الحلويات")end
-- مو-سفيراتو
function Cow7()
applyTicket({1768641324,1866686318,1634230135,2003790956,846095717,3355184},"مو-سفيراتو")end
-- بقرة جبلية
function Cow8()
applyTicket({1768641320,1866686318,1769430903,1919251566,1919905875,116},"بقرة جبلية")end
-- بقرة احتفالية
function Cow9()
applyTicket({1768641304,1866686318,1313038199,89,0,0},"بقرة احتفالية")end
-- بقرة الفصح
function Cow10()
applyTicket({1768641318,1866686318,1634033527,1919251571,875704370,0},"بقرة الفصح")end
-- بقرة جاسوسة
function Cow11()
applyTicket({1768641304,1866686318,1886609271,121,0,0},"بقرة جاسوسة")end
-- ملكة أطلانتس
function Cow12()
applyTicket({1768641314,1866686318,1952538487,1953390956,29545,0},"ملكة أطلانتس")end
-- بقرة أنيقة
function Cow13()
applyTicket({1768641316,1866686318,1953062775,846818401,3420720,0},"بقرة أنيقة")end
-- بقرة احتفالية
function Cow14()
applyTicket({1768641322,1866686318,1768054647,1684567154,808614241,13362},"بقرة احتفالية")end
-- بقرة القراصنة المعتمدين
function Cow15()
applyTicket({1768641318,1866686318,1768972151,1702125938,875704370,0},"بقرة القراصنة المعتمدين")end
-- بقرة القطب الشمالي
function Cow16()
applyTicket({1768641310,1866686318,1918984055,1667855459,0,0},"بقرة القطب الشمالي")end
-- بقرة السيمفونية
function Cow17()
applyTicket({1768641322,1866686318,1818451831,1769173857,1937075555,25449},"بقرة السيمفونية")end
-- بقرة الزهور
function Cow18()
applyTicket({1768641314,1866686318,1701207927,1986622579,27745,0},"بقرة الزهور")end
-- البقرة اليابانية
function Cow19()
applyTicket({1768641308,1866686318,1634361207,7233904,0,0},"البقرة اليابانية")end
-- نظارات شمسية الروك آند رول للأبقار
function Cow20()
applyTicket({1768641324,1866686318,1765957495,1684567154,845117793,3486256},"نظارات شمسية الروك آند رول للأبقار")end
-- البقرة الفرنسية
function Cow21()
applyTicket({1768641316,1866686318,1919311735,1701015137,3683935,0},"البقرة الفرنسية")end
-- بقرة الكرنفال
function Cow22()
applyTicket({1768641320,1866686318,1633902455,1986621042,929000545,48},"بقرة الكرنفال")end
-- بقرة المشاهير
function Cow23()
applyTicket({1768641322, 1866686318, 1701011319, 1919051116, 1601795177, 13111}, "بقرة المشاهير")end
-- بقرة مستقبلية
function Cow24()
applyTicket({1768641316, 1866686318, 1969643383, 1701999988, 3553119, 0}, "بقرة مستقبلية")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡

--اكواد الدجاجة


-- دجاجة طيارة
function Chicken1()
applyTicket({1768641318,1749245806,1701536617,1920229230,1818588769,0},"دجاجة طيارة")end
-- الدجاج المهرج
function Chicken2()
applyStatue({1852402515,1768440671,1852140387,1701344351,1769108577,7102819,23},"الدجاج المهرج")end
-- الدجاجة المشجعة
function Chicken3()
applyTicket({1768641316,1749245806,1701536617,1886609262,7631471,122},"الدجاجة المشجعة")end
-- الدجاجة الخيالية
function Chicken4()
applyStatue({1852402515,1768440671,1852140387,1852400479,1701995876,6384748,23},"الدجاجة الخيالية")end
-- الدجاجة المستكشفة
function Chicken5()
applyTicket({1768641318,1749245806,1701536617,1969905518,1701603182,0},"الدجاجة المستكشفة")end
-- دجاجة عيد الميلاد
function Chicken6()
applyTicket({1768641316,1749245806,1701536617,2004049774,7628133,0},"دجاجة عيد الميلاد")end
-- مساعد سانتا الصغير
function Chicken7()
applyStatue({1852402515,1768440671,1852140387,1919443807,1836348265,808612705,13106,26},"مساعد سانتا الصغير")end
-- دجاجة جنية
function Chicken8()
applyTicket({1768641320,1749245806,1701536617,1919508334,1851878501,100},"دجاجة جنية")end
-- دجاجة بثوب يوناني
function Chicken9()
applyTicket({1768641318,1749245806,1701536617,1701338990,1935764588,0},"دجاجة بثوب يوناني")end
-- دجاجة في إجازة
function Chicken10()
applyStatue({1852402515,1768440671,1852140387,1819042143,1818455657,1986622325,2037645413,13133,25},"دجاجة في إجازة")end
-- دجاجة احتفالية
function Chicken11()
applyStatue({1852402515,1768440671,1852140387,1919509087,1633970292,842019449,1702101044,7628115,25},"دجاجة احتفالية")end
-- دجاجة الحفلات
function Chicken12()
applyStatue({1852402515,1768440671,1852140387,1919509087,1633970292,842019449,2030068532,13133,26},"دجاجة الحفلات")end
-- دجاجة الهالوين
function Chicken13()
applyStatue({1852402515,1768440671,1852140387,1818323039,1702326124,808611429,2030056498,13133,26},"دجاجة الهالوين")end
-- الدجاجة الاحتفالية
function Chicken14()
applyTicket({1768641320,1749245806,1701536617,1852006254,842019449,53},"الدجاجة الاحتفالية")end
-- دجاجة الموضة
function Chicken15()
applyTicket({1768641320,1749245806,1701536617,1634099054,1869178995,110},"دجاجة الموضة")end
-- دجاجة الديسكو
function Chicken16()
applyTicket({1768641316,1749245806,1701536617,1768185710,7299955,0},"دجاجة الديسكو")end
-- دجاجة الفضاء
function Chicken17()
applyTicket({1768641322,1749245806,1701536617,1634557806,808612722,13618},"دجاجة الفضاء")end
-- نظارات شمسية الروك آند رول للدجاج
function Chicken18()
applyStatue({1852402515,1768440671,1852140387,1919500895,1633970292,808607609,7550258,27},"نظارات شمسية الروك آند رول للدجاج")end
-- دجاجة الروك آند رول
function Chicken19()
applyStatue({1852402515,1768440671,1852140387,1919500895,1633970292,808607609,13618,26},"دجاجة الروك آند رول")end
-- دجاجة الفارس
function Chicken20()
applyTicket({1768641318,1749245806,1701536617,1850433390,1952999273,0},"دجاجة الفارس")end
-- دجاجة الكريسماس
function Chicken21()
applyStatue({1852402515,1768440671,1852140387,1919443807,1836348265,912225121,55,25},"دجاجة الكريسماس")end
-- دجاجة برودواي
function Chicken22()
applyStatue({1852402515,1768440671,1852140387,1869767263,1635214433,959864697,24},"دجاجة برودواي")end
-- دجاجة عيد الفصح
function Chicken23()
--دجاجة الطهي
applyTicket({1768641324,1749245806,1701536617,1634033518,1919251571,3290975},"دجاجة عيد الفصح")end
function Chicken24()
applyStatue({1852402515, 1768440671, 1852140387, 1819632479, 1918987881, 876044153, 24}, "دجاجة برودواي")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--اكواد الخرفان 

-- النعجة الساحرة
function Sheep1()
applyStatue({1852402515,1701335903,1751085157,1869376609,1852138871,842149938,24},"النعجة الساحرة")end
-- نعجة مهرجان الربيع
function Sheep2()
applyTicket({1768641324,1750294382,1601201509,1634628972,844713586,3289648},"نعجة مهرجان الربيع")end
-- نعجة الفصح
function Sheep3()
applyTicket({1768641322,1750294382,1601201509,1953718629,808612453,13106},"نعجة الفصح")end
-- خروف شمالي
function Sheep4()
applyTicket({1768641320,1750294382,1601201509,1685221230,1866949481,100},"خروف شمالي")end
-- الخروف المحقق
function Sheep5()
applyTicket({1768641320,1750294382,1601201509,1702126948,1986622563,101},"الخروف المحقق")end
-- خروف عيد الميلاد
function Sheep6()
applyTicket({1768641312,1750294382,1601201509,1701148531,116,0},"خروف عيد الميلاد")end
-- بانديت النبيلة
function Sheep7()
applyTicket({1768641320,1750294382,1601201509,1768058738,1869564014,100},"بانديت النبيلة")end
-- خروف السامبا
function Sheep8()
applyTicket({1768641314,1750294382,1601201509,2053206626,27753,0},"خروف السامبا")end
-- خروف الروك آند رول
function Sheep9()
applyTicket({1768641320,1750294382,1601201509,1801678706,1819243118,108},"خروف الروك آند رول")end
-- الخروف المقاتل
function Sheep10()
applyTicket({1768641314,1750294382,1601201509,1734962795,29800,0},"الخروف المقاتل")end
-- عصابة الخرفان
function Sheep11()
applyStatue({1852402515,1701335903,2002743397,2003070057,846492517,3420720,23},"عصابة الخرفان")end
-- بيلي بونكا
function Sheep12()
applyStatue({1852402515,1701335903,1650421861,1752461929,846815588,3420720,23},"بيلي بونكا")end
-- خروف احتفالي
function Sheep13()
applyStatue({1852402515,1701335903,1650421861,1752461929,846815588,1932800560,24},"خروف احتفالي")end
-- الخراف المصرية
function Sheep14()
applyTicket({1768641312,1750294382,1601201509,1887004517,116,0},"الخراف المصرية")end
-- خروف عيد الميلاد (الثاني)
function Sheep15()
applyStatue({1852402515,1701335903,1667199077,1936290408,1935764852,875704370,24},"خروف عيد الميلاد")end
-- خراف قاعة الرقص
function Sheep16()
applyTicket({1768641322,1750294382,1601201509,1903386989,1634887029,25956},"خراف قاعة الرقص")end
-- خروف غاتسبي
function Sheep17()
applyTicket({1768641314,1750294382,1601201509,1937006919,31074,0},"خروف غاتسبي")end
-- خروف مصاص الدماء
function Sheep18()
applyStatue({1852402515,1701335903,1214214245,1869376609,1852138871,892481586,24},"خروف مصاص الدماء")end
-- نظارات شمسية الروك آند رول للخراف
function Sheep19()
applyStatue({1852402515,1701335903,1113550949,1752461929,1601790308,892481586,24},"نظارات شمسية الروك آند رول للخراف")end
-- الخروف الأسطوري
function Sheep20()
applyTicket({1768641322,1750294382,1601201509,1819043176,808612705,13618},"الخروف الأسطوري")end
-- خروف العطلة
function Sheep21()
applyStatue({1852402515,1701335903,1633644645,1852402796,1937075299,845510249,3486256,27},"خروف العطلة")end
-- الخروف نجم الروك
function Sheep22()
applyStatue({1852402515,1701335903,1650421861,1752461929,846815588,3486256,23},"الخروف نجم الروك")end
-- حروف الربيع 
function Sheep23()
applyStatue({1852402515,1701335903,1650421861,1702130805,2037147250,3225439,25,23},"خروف الربيع")end
--خروف ايطالي
function Sheep24()
applyStatue({1768641322, 1750294382, 1601201509, 1818326121, 1601069417, 13623}, "خروف إيطالي")end
--🤡🤡🤡🤡🤡🤡🤡🤡??🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡????🤡🤡🤡🤡🤡
--أكواد مظاهر الخنازير--
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
-- خنزير الكيوبيد
function Pigs1()
applyTicket({1768641324,1766874990,1635147623,1953391980,1936027241,7954756},"خنزير الكيوبيد")end
-- خنزير الاحتفالي
function Pigs2()
applyTicket({1768641304,1766874990,1313038183,89,0,0},"خنزير الاحتفالي")end
--🤡🤡🤡??🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡??🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--اكواد اللوحات 
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
-- لافته مدينه عيد الميلاد
function Sign1()
applyStatue({1852402547,1953063775,1769168761,1398763111,959930192,1769168688,28263,26},"لافته مدينه عيد الميلاد")end
-- لافته طيران المدينه
function Sign2()
applyStatue({1852402547,1953063775,1769168761,2002742887,1701277289,1769168740,28263,26},"لافته طيران المدينه")end
-- لافته مدينه بطابع خيالي
function Sign3()
applyStatue({1852402547,1953063775,1769168761,1633644135,1768055154,1769168739,-2063569305,26},"لافته مدينه بطابع خيالي")end
-- لافته مدينه بشاشه كبيره
function Sign4()
applyStatue({1852402547,1953063775,1769168761,1667198567,1835363945,1769168737,28263,26},"لافته مدينه بشاشه كبيره")end
-- لافته اعياد الربيع
function Sign5()
applyStatue({1852402547,1953063775,1769168761,1700752999,1702130529,1769168754,721448551,26},"لافته اعياد الربيع")end
-- لافته معكم علي الهواء مباشره
function Sign6()
applyStatue({1852402547,1953063775,1769168761,1415540327,1768120150,1935636852,7235433,27},"لافته معكم علي الهواء مباشره")end
-- لافته مدينه التفاحه الكبيره
function Sign7()
applyStatue({1852402547,1953063775,1769168761,1751084647,1702261345,1935635571,7235433,27},"لافته مدينه التفاحه الكبيره")end
-- لافته مدينه الهالوين الكبيره
function Sign8()
applyStatue({1852402547,1953063775,1769168761,1751084647,1869376609,1852138871,1734964063,110,29},"لافته مدينه الهالوين الكبيره")end
-- لافته ف عيد الميلاد
function Sign9()
applyStatue({1852402547,1953063775,1769168761,1667198567,1936290408,1935764852,1734964063,110,29},"لافته ف عيد الميلاد")end
-- لافته تزلج علي الجليد
function Sign10()
applyStatue({1852402547,1953063775,1769168761,1935634023,1651994478,1685217647,1734964063,110;29},"لافته تزلج علي الجليد")end
-- لافته مدينه منزل مريح
function Sign11()
applyStatue({1852402547,1953063775,1769168761,1717530215,1768845941,1701999988,1734964063,110,29},"لافته مدينه منزل مريح")end
-- لافته مدينه الروك
function Sign12()
applyStatue({1852402547,1953063775,1769168761,1918856807,1600873327,1852270963,24},"لافته مدينه الروك")end
-- لافته العلكه للجميع
function Sign13()
applyStatue({1852402547,1953063775,1769168761,1918856807,1852403061,1601465953,1751343469,6647401,31},"لافته العلكه للجميع")end
-- لافته كشك المشروبات
function Sign14()
applyStatue({1852402547,1953063775,1769168761,1935634023,1953460077,1650813288,1935635041,7235433,31},"لافته كشك المشروبات")end
-- لافته مدينه عشره سنوات
function Sign15()
applyStatue({1852402547,1953063775,1769168761,1650421351,1752461929,1601790308,1702441009,7565921,31},"لافته مدينه عشره سنوات")end
-- لافته تحيه المدينه
function Sign16()
applyStatue({1852402547,1953063775,1769168761,1885302375,1601006689,1701147252,115,25},"لافته تحيه المدينه")end
-- لافته مزرعه قديمه
function Sign17()
applyStatue({1852402547,1953063775,1769168761,1667198567,1935636335,7235433,1701210444,25,23},"لافته مزرعه قديمه")end
-- لافته عيد المدينه
function Sign18()
applyStatue({1852402547,1953063775,1769168761,1650421351,1752461929,1601790308,1852270963,85270963,28},"لافته عيد المدينه")end
-- لافتت وحش مطاطي
function Sign19()
applyStatue({1852402547,1953063775,1769168761,1717530215,1802396018,1818323039,1702326124,28261,30},"لافتت وحش مطاطي")end
-- لافتة رائعه قديمه
function Sign20()
applyStatue({1852402547,1953063775,1769168761,1834970727,1769239417,1600938339,1852143205,-1962904716,30},"لافتة رائعه قديمه")end
-- لافته مدينه لا تنام
function Sign21()
applyStatue({1852402547,1953063775,1769168761,1683975783,1868788585,1953063775,1769168761,855666279,30},"لافته مدينه لا تنام")end
-- لافته مدينه القراصنه
function Sign22()
applyStatue({1852402547,1953063775,1769168761,1918856807,1952540517,845111668,1596993585,1852270963,32},"لافته مدينه القراصنه")end
-- علامة المدينة الخفية
function Sign23()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597190766;808464946;1734964063;110,41,37},"علامة المدينة الخفية")end
-- لافتة المدينة الخارقة للطبيعة
function Sign24()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597190766,1597190766;808464946;1734964063;110,41,37},"لافتة المدينة الخارقة للطبيعة")end
-- لافتة مدينة كثوتون
function Sign25()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597256302,808465202;1734964063;110,41,37},"لافتة مدينة كثوتون")end
-- لافتة مدينة العطلات
function Sign26()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597321838,808465202;1734964063;110,41,37},"لافتة مدينة العطلات")end
-- لافتة المدينة الشنوية
function Sign27()
applyStatue({1852402547,1953063775,1769168761,1918856807,1952540517,845111668,1596993587,1852270963,1852270963,32},"لافتة المدينة الشنوية")end
-- لافتة المدينة خارج كوكب الأرض
function Sign28()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597387374,808465458,1734964063,110,41,37},"لافتة المدينة خارج كوكب الأرض")end
-- شعار المدينة الشبحية
function Sign29()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597452910,808465458,1734964063,110,41,37},"شعار المدينة الشبحية")end
-- لافتة المدينة القرمزية
function Sign30()
applyStatue({1852402547,1953063775,1769168761,1918856807,1952540517,845111668,1596993588,1852270963,41,32},"لافتة المدينة القرمزية")end
-- لافتة المدينة الصحراوية
function Sign31()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597518446,808465714,1734964063,110,41,37},"لافتة المدينة الصحراوية")end
-- لافتة مدينة راعي البقر
function Sign32()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597583982,808465714;1734964063;110,41,37},"لافتة مدينة راعي البقر")end
-- علامة مدينة قوة الأجداد
function Sign33()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1596994414,808465970;1734964063;110,41,37},"علامة مدينة قوة الأجداد")end
-- لافتة مدينة أطلانتس
function Sign34()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597059950,808465970;1734964063;110,41,37},"لافتة مدينة أطلانتس")end
-- لافتة مدينة بطابع الحديقة الذكية
function Sign35()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597125486,808466226;1734964063;110,41,37},"لافتة مدينة بطابع الحديقة الذكية")end
-- لافتة مدينة بتصميم حلوى
function Sign36()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597191022,808466226,1734964063,110,41,37},"لافتة مدينة بتصميم حلوى")end
-- لافتة مدينة منتجع البطاريق
function Sign37()
applyStatue({1852402547,1953063775,1769168761,1700752999,1684369528,1869182057,1597387630,808466738,1734964063,110,41,37},"لافتة مدينة منتجع البطاريق")end
-- علامة هالوين كبيرة
function Sign38()
applyStatue({1852402547,1953063775,1769168761,1918856807,1952540517,861888884,1596993584,1852270963,41,32},"علامة هالوين كبيرة")end
-- لافتة بلدة العجائب الشتوية
function Sign39()
applyStatue({1852402547,1953063775,1769168761,1918856807,1952540517,861888884,1596993585,1852270963,41,32},"لافتة بلدة العجائب الشتوية")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--اكواد التماثيل 
--🤡🤡??🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡


--ابطال الحديقة القديمة 
--التمثال الاول 
function Mahmoud1()
applyStatue({1701869637,1769236836,1698983535,1634889571,1852795252,1918988323,12660,26}, "التمثال الأول أبطال الحديقة") end
--التمثال الثاني 
function Mahmoud2()
applyStatue({1701869637,1769236836,1698983535,1634889571,1852795252,1918988323,12916,26}, "التمثال الثاني أبطال الحديقة")end
--التمثال الثالث 
function Mahmoud3()
applyStatue({1701869637,1769236836,1698983535,1634889571,1852795252,1935761955,101,27}, "التمثال الثالث أبطال الحديقة") end
--ملكة جزيرة السلحفاه
function Expedition2()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1634738994, 3372146, 27}, "ملكة جزيرة السلحفاه")end
--حارس الشمال
function Expedition3()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1634738995, 3241074, 27}, "حارس الشمال")end
--أوديسة القراصنة
function Expedition4()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1634738996, 3241074, 27}, "أوديسة القراصنة")end
--ميجالوث الوحش الثلجي
function Expedition5()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1634738997, 3241074, 27}, "ميجالوث الوحش الثلجي")end
--منتجع فندقي أسرار كليوباترا
function Expedition6()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1634738998, 3241074, 27}, "منتجع فندقي أسرار كليوباترا")end
--متنزه ترفيهي نباتي
function Expedition7()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1634738999, 3241074, 27}, "متنزه ترفيهي نباتي")end
--متحف مملكة بوسيدون
function Expedition8()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1634739000, 3241074, 27}, "متحف مملكة بوسيدون")end
--مركز أبحاث الحالات الشاذة
function Expedition9()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1634739001, 3241074, 27}, "مركز أبحاث الحالات الشاذة")end
--قصر ذكي
function Expedition10()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881354289, 829715041, 28}, "قصر ذكي")end
--منزل الغزال الذهبي الريفي
function Expedition11()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881354545, 829715041, 28}, "منزل الغزال الذهبي الريفي")end
--تمثال نافورة اللوتس
function Expedition12()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881354801, 829715041, 28}, "تمثال نافورة اللوتس")end
--مسرح باندورا القديم
function Expedition13()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881355057, 829715041, 28}, "مسرح باندورا القديم")end
--صوبة ملكة الدبابير
function Expedition14()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881355313, 829715041, 28}, "صوبة ملكة الدبابير")end
--منشأة أبحاث فضائية
function Expedition15()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881355569, 829715041, 28}, "منشأة أبحاث فضائية")end
--مكتبة الشجرة
function Expedition16()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881355825, 829715041, 28}, "مكتبة الشجرة")end
--قاعدة التخييم
function Expedition17()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881356081, 829715041, 28}, "قاعدة التخييم")end
--مقهى كوني
function Expedition18()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881356337, 829715041, 28}, "مقهى كوني")end
--حديقة أرض القرود المائية
function Expedition19()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881356593, 829715041, 28}, "حديقة أرض القرود المائية")end
--ملاذ جبلي
function Expedition20()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881354290, 829715041, 28}, "ملاذ جبلي")end
--حديقة ترفيهية رائعة
function Expedition21()
applyStatue({1701869637, 1769236836, 1698983535, 1634889571, 1852795252, 1881354546, 829715041, 28}, "حديقة ترفيهية رائعة")end

--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡



--♡ديكورات الدمج♡

--سنترال بارك
function Merge1()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634738993, 3372146, 23}, "سنترال بارك")end
--مركز المجتمع الصيني
function Merge2()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634738994, 3372146, 23}, "مركز المجتمع الصيني")end
--حديقة بيئية قوس قزح
function Merge3()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634738995, 3372146, 23}, "حديقة بيئية قوس قزح")end
--جولة الزواقة
function Merge4()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634738996, 3372146, 23}, "جولة الزواقة")end
--المعرض الزراعي
function Merge5()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634738997, 3306610, 23}, "المعرض الزراعي")end
--مجمع رياضي
function Merge6()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634738998, 3306610, 23}, "مجمع رياضي")end
--عالم البطريق
function Merge7()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634738999, 3306610, 23}, "عالم البطريق")end
--صالة ديسكو كلاسيكية
function Merge8()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634739000, 3241074, 23}, "صالة ديسكو كلاسيكية")end
--معرض الفنون والحرف اليدوية
function Merge9()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634739001, 3241074, 23}, "معرض الفنون والحرف اليدوية")end
--موقع مخيم مريح
function Merge10()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634738993, 3372146, 23}, "موقع مخيم مريح")end
--حفل شاطئي
function Merge11()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634738994, 3372146, 23}, "حفل شاطئي")end
--قلب ايطالي
function Merge12()
applyStatue({1735550285, 1698968165, 1634889571, 1852795252, 1634738995, 3372146, 23}, "قلب ايطالي")end

--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--حدث الاستكشاف 

--اكواد ديكورات غير مكتمله

-- أبطال الحديقة القديمة 1
function Expeditionn1()
applyTicket({1886930216,1953064037,1148088169,1919902565,1869182049,110},"أبطال الحديقة القديمة")end
-- ملكة جزيرة السلحفاه 2
function Expeditionn2()
applyTicket({1886930218,1953064037,1148088169,1919902565,1869182049,12910},"ملكة جزيرة السلحفاه")end
-- حارس الشمال 3
function Expeditionn3()
applyTicket({1886930218,1953064037,1148088169,1919902565,1869182049,13166},"حارس الشمال")end
-- أوديسة القراصنة 4
function Expeditionn4()
applyTicket({1886930218,1953064037,1148088169,1919902565,1869182049,13422},"أوديسة القراصنة")end
-- ميجالوث الوحش الثلجي 5
function Expeditionn5()
applyTicket({1886930218,1953064037,1148088169,1919902565,1869182049,13678},"ميجالوث الوحش الثلجي")end
-- منتجع فندقي أسرار كليوباترا 6
function Expeditionn6()
applyTicket({1886930218,1953064037,1148088169,1919902565,1869182049,13934},"منتجع فندقي أسرار كليوباترا")end
-- متنزه ترفيهي نباتي 7
function Expeditionn7()
applyTicket({1886930218,1953064037,1148088169,1919902565,1869182049,14190},"متنزه ترفيهي نباتي")end
-- متحف مملكة بوسيدون 8
function Expeditionn8()
applyTicket({1886930218,1953064037,1148088169,1919902565,1869182049,14446},"متحف مملكة بوسيدون")end
-- مركز أبحاث الحالات الشاذة الطبيعية 9
function Expeditionn9()
applyTicket({1886930218,1953064037,1148088169,1919902565,1869182049,14702},"مركز أبحاث الحالات الشاذة الطبيعية")end
-- قصر ذكي 10
function Expeditionn10()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3158382},"قصر ذكي")end
-- منزل الغزال الذهبي الريفي 11
function Expeditionn11()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3223918},"منزل الغزال الذهبي الريفي")end
-- تمثال نافوره اللوتس 12
function Expeditionn12()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3289454},"تمثال نافوره اللوتس")end
-- مسرح باندور1 القديم N13
function Expeditionn13()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3354990},"مسرح باندور1 القديم")end
-- صوبة ملكة الدبابير N14
function Expeditionn14()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3420526},"صوبة ملكة الدبابير")end
-- منشأت ابحاث فضائيه N15
function Expeditionn15()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3486062},"منشأت ابحاث فضائيه")end
-- مكتبة الشجره N16
function Expeditionn16()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3551598},"مكتبة الشجره")end
-- قاعده التخمين N17
function Expeditionn17()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3617134},"قاعده التخمين")end
-- المقهي الكوني N18
function Expeditionn18()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3682670},"المقهي الكوني")end
-- حديقه ارض القرود المائيه N19
function Expeditionn19()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3748206},"حديقه ارض القرود المائيه")end
-- ملاز جبلي N20
function Expeditionn20()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3158638},"ملاز جبلي")end
-- حديقه ترفيهيه رائعة N21
function Expeditionn21()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3224174},"حديقه ترفيهيه رائعة")end

--🤡🤡🤡🤡??🤡🤡🤡🤡🤡🤡🤡🤡🤡??
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--اكواد ديكورات الميرج غير مكتمل 

-- سنترال بارك N1
function Mergee1()
applyTicket({1919241506,1144153447,1919902565,1869182049,1862283630,3158382},"سنترال بارك")end
-- مركز المجتمع الصيني N2
function Mergee2()
applyTicket({1919241506,1144153447,1919902565,1869182049,1862283886,3158382},"مركز المجتمع الصيني")end
-- حديقه بيئيه بطابع قوس قزح N3
function Mergee3()
applyTicket({1919241506,1144153447,1919902565,1869182049,1862284142,3158382},"حديقه بيئيه بطابع قوس قزح")end
-- جواله الزواقه N4
function Mergee4()
applyTicket({1919241506,1144153447,1919902565,1869182049,1862284398,3158382},"جواله الزواقه")end
-- المعرض الزراعي N5
function Mergee5()
applyTicket({1919241506,1144153447,1919902565,1869182049,1862284654,3158382},"المعرض الزراعي")end
-- مجمع رياضي N6
function Mergee6()
applyTicket({1919241506,1144153447,1919902565,1869182049,1862284910,321137},"مجمع رياضي")end
-- عالم البطريق N7
function Mergee7()
applyTicket({1919241506,1144153447,1919902565,1869182049,1862285166,3276914},"عالم البطريق")end
-- صاله ديسكو كلاسيكيه N8
function Mergee8()
applyTicket({1919241506,1144153447,1919902565,1869182049,1862285422,3354990},"صاله ديسكو كلاسيكيه")end
-- معرض الفنون والحرف اليدوية N9
function Mergee9()
applyTicket({1919241506,1144153447,1919902565,1869182049,1862285678,3354990},"معرض الفنون والحرف اليدوية")end
-- موقع مخيم مريح N10
function Mergee10()
applyTicket({1919241508,1144153447,1919902565,1869182049,3158382,3420526},"موقع مخيم مريح")end
-- حفل شاطئ N11
function Mergee11()
applyTicket({1919241508,1144153447,1919902565,1869182049,3223918,3539058},"حفل شاطئ")end
-- قلب ايطالي N12
function Mergee12()
applyTicket({1919241508,1144153447,1919902565,1869182049,3289454,3604594},"قلب ايطالي")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡



--اكواد الإطار 
--الاطار بالون الزهري
function Style1()
applyStatue({1348423763,1768320882,1917216108,1600482657,1953719654,1818326633,24},"الاطار بالون الزهري")end
--الاطار بالون الأزرق
function Style2()
applyStatue({1348423763,1768320882,1917216108,1600482657,1835102822,825253733,24},"الاطار بالون الأزرق")end
function Style3()
applyStatue({1348423763,1768320882,1917216108,1600482657,1835102822,842030949,24},"الاطار بالون الثلجي")end
--الاطار بالون الأحمر
function Style4()
applyStatue({1348423763,1768320882,1917216108,1600482657,1835102822,858808165,24},"الاطار بالون الأحمر")end
--اطار الربيع 
function Style5()
applyStatue({1348423763,1768320882,1917216108,1600482657,1835102822,875585381,24},"إطار الربيع")end
--اطار عيد الفصح 
function Style6()
applyStatue({1348423763,1768320882,1917216108,1600482657,1835102822,892362597,24},"إطار عيد الفصح")end
--اطار ناري 
function Style7()
applyStatue({1348423763,1768320882,1917216108,1600482657,1835102822,909139813,24},"إطار ناري ")end
--اطار نيون
function Style8()
applyStatue({1348423763,1768320882,1917216108,1600482657,1835102822,925917029,24},"إطار نيون")end
--اطار رقم 9
function Style9()
applyStatue({1348423763,1768320882,1917216108,1600482657,1835102822,942694245,24},"اطار رقم 9")end
--اطار رقم 10
function Style10()
applyStatue({1348423763,1768320882,1917216108,1600482657,1835102822,959471461,24},"اطار رقم 10")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--اكواد النمط الاسم 

-- الاسم بالون الزهري 
function Frame1()
applyStatue({1348423763,1768320882,1951622508,1600482425,1953719654,1818326633,24}, "اسم الوردي")end
-- الاسم عيد الفصح 
function Frame2()
applyStatue({1348423763,1768320882,1951622508,1600482425,1953718629;29285,22}, "اسم عيد الفصح")end
-- ستايل الاسم الناري 
function Frame3()
applyStatue({1348423763,1768320882,1951622508,1600482425,1802465123,6778473,23}, "اسم الناري")end
--اسم نيون 
function Frame4()
applyStatue({1348423763,1768320882,1951622508,1600482425,1852794222,20}, "اسم نيون")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
-- شارات المدينة --

--شارة المدينة 1
function Badge1()
applyTicket({1684103706,811558247,1633836849,25971,0,0},"شارة المدينة 1")end
--شارة البلدة الأسطورية 1
function Badge2()
applyTicket({1684103708,811558247,1919377201,6581857,0,0},"شارة البلدة الأسطورية 1")end
--شارة المدينة 2
function Badge3()
applyTicket({1684103712,811558247,846618417,1935762015,101,0},"شارة المدينة 2")end
--شارة البلدة الأسطورية 2
function Badge4()
applyTicket({1684103714,811558247,846618417,1634887519,25710,0}, "شارة البلدة الأسطورية 2")end
--شارة الشتاء
function Badge5()
applyTicket({1684103706,811558247,1633836850,25971,0,0},"شارة الشتاء")end
--شارة الشتاء الأسطورية
function Badge6()
applyTicket({1684103708,811558247,1919377202,6581857,0,0},"شارة الشتاء الأسطورية")end
--شارة الرحلة 
function Badge7()
applyTicket({1684103706,811558247,1633836851,25971,0,0},"شارة الرحلة ")end
--شارة الرحلة الأسطورية
function Badge8()
applyTicket({1684103708,811558247,1919377203,6581857,0,0},"شارة الرحلة الأسطورية")end
--شارة الربيع 
function Badge9()
applyTicket({1684103706,811558247,1633836852,25971,0,0},"شارة الربيع")end
--شارة الربيع الاسطورية
function Badge10()
applyTicket({1684103708,811558247,1919377204,6581857,0,0},"شارة الربيع الاسطورية")end
--شارة الطهي 
function Badge11()
applyTicket({1684103706,811558247,1633836853,25971,0,0},"شارة الطهي")end
--شارة بطيخ  احمر 
function Badge13()
applyTicket({1684103706,811558247,1633836854,25971,0,0},"شاره بطيخ احمر")end
--شارة بطيخ  اخضر
function Badge14()
applyTicket({1684103708,811558247,1919377206,6581857,0,0},"شاره بطيخ اخضر")end

--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- اكواد الايموجي 

--البطة النعسانة 😴
function Emoji1()
applyTicket({1869440276,1935632746,3158384,0,0,0},"البطة النعسانة 😴")end

--خليط الفراولة ??
function Emoji2()
applyTicket({1869440276,1935632746,3158388,0,0,0},"خليط الفراولة 🍓")end

--نحلة تختفي في الملابس 🐝👕
function Emoji3()
applyTicket({1869440276,1935632746,3158900,0,0,0},"نحلة تختفي في الملابس 🐝👕")end

--بقرة الفشار 🍿🐮
function Emoji4()
applyTicket({1869440276,1935632746,3159156,0,0,0},"بقرة الفشار 🍿🐮")end

--خروف المهرجان الراقص المبتسم 🐑🎪💃
function Emoji5()
applyTicket({1869440276,1935632746,3159668,0,0,0},"خروف المهرجان الراقص المبتسم 🐑🎪💃")end

--الديك الصيف المستريح 🐓😎🌞
function Emoji6()
applyTicket({1869440276,1935632746,3159924,0,0,0},"الديك الصيف المستريح 🐓😎🌞")end

--الخضيرة الراقصة 🥬💃
function Emoji7()
applyTicket({1869440276,1935632746,3223920,0,0,0},"الخضيرة الراقصة 🥬💃")end

--النحلة الراقصة 🐝💃
function Emoji8()
applyTicket({1869440276,1935632746,3223924,0,0,0},"النحلة الراقصة 🐝💃")end

--خنزير يلعب بالعملة 🐷💰
function Emoji9()
applyTicket({1869440276,1935632746,3224176,0,0,0},"خنزير يلعب بالعملة 🐷💰")end

--بقرة تعزف على العود 🐮🎵
function Emoji10()
applyTicket({1869440276,1935632746,3224436,0,0,0},"بقرة تعزف على العود 🐮🎵")end

--فرخة الصابون 🐔🧼
function Emoji11()
applyTicket({1869440276,1935632746,3224692,0,0,0},"فرخة الصابون 🐔🧼")end

--الخنزير يحتسي الشراب 🐷☕
function Emoji12()
applyTicket({1869440276,1935632746,3225204,0,0,0},"الخنزير يحتسي الشراب 🐷☕")end

--بقرة راكبة على الدراجة النارية 🐮🏍️
function Emoji13()
applyTicket({1869440276,1935632746,3225460,0,0,0},"بقرة راكبة على الدراجة النارية 🐮🏍️")end

--خروف وقناع الشبح 🐑👻
function Emoji14()
applyTicket({1869440276,1935632746,3289460,0,0,0},"خروف وقناع الشبح 🐑👻")end

--مركب السماعة بالأذن ويرقص 🎧💃
function Emoji15()
applyTicket({1869440276,1935632746,3289712,0,0,0},"مركب السماعة بالأذن ويرقص 🎧💃")end

--بقرة الفضاء 🐮🚀
function Emoji16()
applyTicket({1869440276,1935632746,3289716,0,0,0},"بقرة الفضاء 🐮🚀")end

--ضارب على الدفوف 🥁
function Emoji17()
applyTicket({1869440276,1935632746,3289972,0,0,0},"ضارب على الدفوف 🥁")end

--خروج البطة الزرقاء الجميلة تلقى بوسة 🦆💋
function Emoji18()
applyTicket({1869440276,1935632746,3290228,0,0,0},"خروج البطة الزرقاء الجميلة تلقى بوسة 🦆??")end

--البقرة وعصا الكهرباء 🐮⚡
function Emoji19()
applyTicket({1869440276,1935632746,3290484,0,0,0},"البقرة وعصا الكهرباء 🐮⚡")end

--الديك الراقص بيده غصن أخضر 🐓🌿💃
function Emoji20()
applyTicket({1869440276,1935632746,3290740,0,0,0},"الديك الراقص بيده غصن أخضر 🐓🌿💃")end

--صندوق الهدايا تخرج من داخله بقرة 🎁🐮
function Emoji21()
applyTicket({1869440276,1935632746,3290996,0,0,0},"صندوق الهدايا تخرج من داخله بقرة 🎁🐮")end

--بقرة حلوة وسلة التسوق 🐮🛒
function Emoji22()
applyTicket({1869440276,1935632746,3354996,0,0,0},"بقرة حلوة وسلة التسوق 🐮🛒")end

--خنزير فوق الطيارة 🐷✈️
function Emoji23()
applyTicket({1869440276,1935632746,3355252,0,0,0},"خنزير فوق الطيارة 🐷✈️")end

--نحلة تحول سائل أزرق إلى بطيخ 🐝💧🍉
function Emoji24()
applyTicket({1869440276,1935632746,3355764,0,0,0},"نحلة تحول سائل أزرق إلى بطيخ 🐝💧🍉")end

--خروف وأداة بحث 🐑🔍
function Emoji25()
applyTicket({1869440276,1935632746,3356020,0,0,0},"خروف وأداة بحث 🐑🔍")end

--بقرة تخرج من البيضة 🐮🥚
function Emoji26()
applyTicket({1869440276,1935632746,3356276,0,0,0},"بقرة تخرج من البيضة 🐮🥚")end

--فرخة وكرة الضوء 🐔💡
function Emoji27()
applyTicket({1869440276,1935632746,3356532,0,0,0},"فرخة وكرة الضوء 🐔💡")end

--القبعة الساحرة 🎩✨
function Emoji28()
applyTicket({1869440276,1935632746,3420528,0,0,0},"القبعة الساحرة 🎩✨")end

--لايك 👍
function Emoji29()
applyTicket({1869440276,1935632746,3420532,0,0,0},"لايك 👍")end

--بطة تعطي إشارة لا 🦆🚫
function Emoji30()
applyTicket({1869440276,1935632746,3420784,0,0,0},"بطة تعطي إشارة لا 🦆🚫")end

--الديك الطاهي 🐓👨‍🍳
function Emoji31()
applyTicket({1869440276,1935632746,3420788,0,0,0},"الديك الطاهي 🐓👨‍🍳")end

--تجديف القارب 🚣
function Emoji32()
applyTicket({1869440276,1935632746,3421044,0,0,0},"تجديف القارب 🚣")end

--قبعة الديك مع الغمزة 🐓😉🎩
function Emoji33()
applyTicket({1869440276,1935632746,3421556,0,0,0},"قبعة الديك مع الغمزة 🐓😉🎩")end

--الخروف العازف 🐑🎵
function Emoji34()
applyTicket({1869440276,1935632746,3421812,0,0,0},"الخروف العازف 🐑🎵")end

--الخروف المصري يمين وشمال 🐑🇪🇬🔄
function Emoji35()
applyTicket({1869440276,1935632746,3422068,0,0,0},"الخروف المصري يمين وشمال 🐑🇪🇬🔄")end

--استعراض العضلات 💪
function Emoji36()
applyTicket({1869440276,1935632746,3486068,0,0,0},"استعراض العضلات 💪")end

--البنت الراقصة 👧💃
function Emoji37()
applyTicket({1869440276,1935632746,3486320,0,0,0},"البنت الراقصة 👧💃")end

--البوسة والقلب 💋❤️
function Emoji38()
applyTicket({1869440276,1935632746,3486324,0,0,0},"البوسة والقلب 💋❤️")end

--الخروف يحطم التلفاز 🐑📺💥
function Emoji39()
applyTicket({1869440276,1935632746,3486580,0,0,0},"الخروف يحطم التلفاز 🐑📺💥")end

--البقرة تزين الحلوى 🐮🍬
function Emoji40()
applyTicket({1869440276,1935632746,3487092,0,0,0},"البقرة تزين الحلوى 🐮🍬")end

--دجاجة تعزف على جيتار 🐔🎸
function Emoji41()
applyTicket({1869440276,1935632746,3487348,0,0,0},"دجاجة تعزف على جيتار 🐔🎸")end

--البقرة تقرأ 🐮📖
function Emoji42()
applyTicket({1869440276,1935632746,3487604,0,0,0},"البقرة تقرأ 🐮📖")end

--النحلة والهدية المغلفة 🐝🎁
function Emoji43()
applyTicket({1869440276,1935632746,3551604,0,0,0},"النحلة والهدية المغلفة 🐝🎁")end

--نحلة تلعب على الزجاج 🐝
function Emoji44()
applyTicket({1869440276,1935632746,3551860,0,0,0},"نحلة تلعب على الزجاج 🐝")end

--بقرة تنظف الأذن 🐮👂
function Emoji45()
applyTicket({1869440276,1935632746,3552116,0,0,0},"بقرة تنظف الأذن 🐮👂")end

--بقرة تتحول إلى خفاش 🐮🦇
function Emoji46()
applyTicket({1869440276,1935632746,3552628,0,0,0},"بقرة تتحول إلى خفاش 🐮🦇")end

--بقرة تصور 🐮📸
function Emoji47()
applyTicket({1869440276,1935632746,3552884,0,0,0},"بقرة تصور 🐮📸")end

--البقرة السارقة 🐮💰
function Emoji48()
applyTicket({1869440276,1935632746,3553140,0,0,0},"البقرة السارقة 🐮💰")end

--بقرة الزينة 🐮✨
function Emoji49()
applyTicket({1869440276,1935632746,3617136,0,0,0},"بقرة الزينة 🐮✨")end

--الخروف الطائر 🐑🪽
function Emoji50()
applyTicket({1869440276,1935632746,3617140,0,0,0},"الخروف الطائر 🐑🪽")end

--الخروف يزمر 🐑📯
function Emoji51()
applyTicket({1869440276,1935632746,3617396,0,0,0},"الخروف يزمر 🐑📯")end

--بقرة القلب تبتسم قلوب 🐮❤️😊
function Emoji52()
applyTicket({1869440276,1935632746,3617908,0,0,0},"بقرة القلب تبتسم قلوب 🐮❤️😊")end

--الخروف يطلق السهم 🐑🏹
function Emoji53()
applyTicket({1869440276,1935632746,3618164,0,0,0},"الخروف يطلق السهم 🐑🏹")end

--بقرة تشرب القهوة 🐮☕
function Emoji54()
applyTicket({1869440276,1935632746,3618676,0,0,0},"بقرة تشرب القهوة 🐮☕")end

--دجاجة الثلج والشاي 🐔❄️🍵
function Emoji55()
applyTicket({1869440276,1935632746,3682672,0,0,0},"دجاجة الثلج والشاي 🐔❄️🍵")end

--دجاجة تتبختر 🐔💃
function Emoji56()
applyTicket({1869440276,1935632746,3682676,0,0,0},"دجاجة تتبختر 🐔💃")end

--الخروج من الفانوس السحري 🪔✨
function Emoji57()
applyTicket({1869440276,1935632746,3682932,0,0,0},"الخروج من الفانوس السحري 🪔✨")end

--دجاجة منبطحه مع MP3 🐔🎧
function Emoji58()
applyTicket({1869440276,1935632746,3683188,0,0,0},"دجاجة منبطحه مع MP3 🐔🎧")end

--دجاجة الأوزان 🐔??️
function Emoji59()
applyTicket({1869440276,1935632746,3683444,0,0,0},"دجاجة الأوزان 🐔🏋️")end

--قرون الزينة 🎄✨
function Emoji60()
applyTicket({1869440276,1935632746,3683700,0,0,0},"قرون الزينة 🎄✨")end

--التاج والعصا الملكية 👑✨
function Emoji61()
applyTicket({1869440276,1935632746,3683956,0,0,0},"التاج والعصا الملكية 👑✨")end

--شيطان يقبل الهدية 👿💋🎁
function Emoji62()
applyTicket({1869440276,1935632746,3748208,0,0,0},"شيطان يقبل الهدية 👿💋🎁")end

--دجاجة تزين البيضة 🐔🥚✨
function Emoji63()
applyTicket({1869440276,1935632746,3748468,0,0,0},"دجاجة تزين البيضة 🐔🥚✨")end

--البنت والعروسة 👧👰
function Emoji64()
applyTicket({1869440276,1935632746,3748724,0,0,0},"البنت والعروسة 👧👰")end


--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
                         --قسم اكواد الزينه 
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾??🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪

-- ============================================================
-- اكواد زينات الطائرات (البالونات والمناطيد)
-- ============================================================

-- بالون الببغاء
function AirDec1()
applyStatue({1667592275, 1114399081, 1953849701, 1818648441, 1918980217, 7630706, 23},"بالون الببغاء")end
-- بالون السلحفاة
function AirDec2()
applyStatue({1667592275, 1114399081, 1953849701, 1818648441, 1920291961, 6646900, 23},"بالون السلحفاة")end
-- بالون الأخطبوط
function AirDec3()
applyStatue({1667592275, 1114399081, 1953849701, 1818648441, 1952665465, 1937076335, 24},"بالون الأخطبوط")end
-- بالون البطريق
function AirDec4()
applyStatue({1667592275, 1114399081, 1953849701, 1818648441, 1852133497, 1852405095, 24},"بالون البطريق")end
-- بالون الدجاجة
function AirDec5()
applyStatue({1667592275, 1114399081, 1953849701, 1818648441, 1768440697, 1852140387, 24},"بالون الدجاجة")end
-- بالون الخنزير
function AirDec6()
applyTicket({1701860136,1818323299,1969317186,1717533044,1766881644,103},"بالون الخنزير")end
-- بالون الخروف
function AirDec7()
applyTicket({1701860140,1818323299,1969317186,1717533044,1750301036,7365989},"بالون الخروف")end
-- بالون البقرة
function AirDec8()
applyTicket({1701860136,1818323299,1969317186,1717533044,1866692972,119},"بالون البقرة")end
-- بالون الفيل
function AirDec9()
applyTicket({1701860138,1818323299,1969317186,1717533044,1816492396,28773},"بالون الفيل")end
-- بالون السمكة
function AirDec10()
applyTicket({1634034212,1601795189,1752394086,1818321503,7237484,0},"بالون السمكة")end
-- بالون الفراشة
function AirDec11()
applyStatue({1667592275,1114399081,1953849701,1818648441,1953841785,1718773108,31084,26},"بالون الفراشة")end
-- الحوت المطاطي
function AirDec12()
applyTicket({1701860140,1818323299,1969317186,1717533044,1750563180,6646881},"الحوت المطاطي")end
-- بالون البطة
function AirDec13()
applyTicket({1701860138,1818323299,1969317186,1717533044,1967421804,27491},"بالون البطة")end
-- الطائرة المطاطية
function AirDec14()
applyTicket({1701860140,1818323299,1969317186,1717533044,1817213292,6647393},"الطائرة المطاطية")end
-- بالون الرقم 3
function AirDec15()
applyTicket({1634034206,1601795189,1633836851,1852796012,0,0},"بالون الرقم 3")end
-- المنزل الطائر
function AirDec16()
applyTicket({1634034206,1601795189,1215917158,1702065519,0,0},"المنزل الطائر")end
-- بالون الكلب
function AirDec17()
applyTicket({1634034210,1601795189,1600614244,1819042146,28271,0},"بالون الكلب")end
-- الدمية الراقصة
function AirDec18()
applyTicket({1634034218,1601795189,1819042146,1601073007,1668178276,29285},"الدمية الراقصة")end
-- قنديل البحر المطاطي
function AirDec19()
applyTicket({1634034208,1601795189,1299803238,1937073253,97,0},"قنديل البحر المطاطي")end
-- قوس البالون
function AirDec20()
applyTicket({1634034214,1601795189,1751347809,1818321503,1852796780,0},"قوس البالون")end
-- منطاد القبعة
function AirDec21()
applyStatue({1667592275,1114399081,1953849701,1751342969,1650419301,1869376609,28271,26},"منطاد القبعة")end
-- بيتسي رائدة الفضاء
function AirDec22()
applyStatue({1969317218,1935636852,1701011824,1936679775,1634627437,1667200117,30575,26},"بيتسي رائدة الفضاء")end
-- المنطاد
function AirDec23()
applyTicket({1919508760, 1885956211, 1935762015, 101, 0, 0},"المنطاد")end
-- منطاد الخنزير
function AirDec24()
applyTicket({1919509536,1634035561,1936026722,1970561396,1701707877,114},"منطاد الخنزير")end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- ============================================================
-- اكواد الزينات المائية
-- ============================================================

-- الجسر الأحمر
function WaterDec1()
applyStatue({1667592275,1114399081,1953849701,1701994361,1769095780,6645604,23},"الجسر الأحمر")end
-- طاحونة مائية
function WaterDec2()
applyStatue({1667592275,1114399081,1953849701,1633116025,1299342708,7105641,23},"طاحونة مائية")end
-- معبد الأعماق
function WaterDec3()
applyStatue({1667592275,1114399081,1953849701,1968332665,1148415593,6649449,23},"معبد الأعماق")end
-- سيف ف الحجر
function WaterDec4()
applyStatue({1667592275,1114399081,1953849701,2017812345,1768710499,7501154,23},"سيف ف الحجر")end
-- البرج المغمور
function WaterDec5()
applyStatue({1667592275,1114399081,1953849701,1818648441,1701080943,1869897572,7497079,27},"البرج المغمور")end
-- حانة القراصنة
function WaterDec6()
applyStatue({1667592275,1114399081,1953849701,1766875001,1702125938,1702256980,28274,26},"حانة القراصنة")end
-- سفينة أوديسيوس
function WaterDec7()
applyStatue({1969317218,1935636852,1433430376,1936947564,1633645413,1701405550,1946186862,26},"سفينة أوديسيوس")end
-- طائرة برمائية
function WaterDec8()
applyStatue({1667592275,1114399081,1953849701,1819303801,1097166433,1768452205,1851877730,28},"طائرة برمائية")end
-- لعبة جهاز الطيران
function WaterDec9()
applyStatue({1667592275,1114399081,1953849701,1900109689,1769234805,1952795235,1801675120,28},"لعبة جهاز الطيران")end
-- يخت عالق
function WaterDec10()
applyStatue({1667592275,1114399081,1953849701,1816223609,1920229730,1332966255,1634681454,1049231476,29},"يخت عالق")end
-- منزل الصياد
function WaterDec11()
applyStatue({1667592275,1114399081,1953849701,1768316793,1919248499,1936613741,1970235487,25971,30},"منزل الصياد")end
-- سفينة القراصنة
function WaterDec12()
applyStatue({1667592275,1114399081,1953849701,1866620793,1767339105,1766877300,1702125938,1734437958,32},"سفينة القراصنة")end
-- قارب مع أزهار
function WaterDec13()
applyStatue({1667592275,1114399081,1953849701,1766023033,1631877492,1868717945,1868526689,1818648422,1919252335,115,37},"قارب مع أزهار")end
-- قرية الغابة
function WaterDec14()
applyStatue({1969317218,1784641908,1818717813,1769103205,1752327542,1702065519,24},"قرية الغابة")end
-- حورية البحر
function WaterDec15()
applyTicket({1701860138,1818323299,1969317186,1834973556,1634562661,25705},"حورية البحر")end
-- الزنبق المائي الأحمر
function WaterDec16()
applyTicket({1952544542,1717531237,1702326124,828339058,-419430400,111},"الزنبق المائي الأحمر")end
-- زهرة زنبق مائية وردية
function WaterDec17()
applyTicket({1952544542,1717531237,1702326124,845116274,-419430400,111},"زهرة زنبق مائية وردية")end
-- الطوف
function WaterDec18()
applyTicket({1952541458,1918987617,1811967585,7602297,6648431,0},"الطوف")end
-- قارب هوائي
function WaterDec19()
applyTicket({1919508762,1952542562,1634496607,1593863022,1735292266,25964},"قارب هوائي")end
-- عطلة
function WaterDec20()
applyTicket({1819502872,1600417377,1718185579,101,0,0},"عطلة")end
-- جسر خشبي
function WaterDec21()
applyTicket({1769103896,811951972,1768316721,1701970030,875585381,0},"جسر خشبي")end
-- مرسى
function WaterDec22()
applyTicket({1635086608,1768316793,1593835630,3307569,875585381,0},"مرسى")end
-- جسر حجري
function WaterDec23()
applyTicket({1769103896,811951972,1768316720,3276910,875585381,0},"جسر حجري")end
-- يخت
function WaterDec24()
applyTicket({1667332370,1717531752,1946185321,829841253,0,0},"يخت")end
-- جسر البوابة الذهبية
function WaterDec25()
applyTicket({1819240214,1601070436,1702125927,829841152,0,0},"جسر البوابة الذهبية")end
-- سحر السينما
function WaterDec26()
applyTicket({1818846758,1801547117,1600613993,1634038388,1701999987,0},"سحر السينما")end
-- الفوانيس الطافية
function WaterDec27()
applyTicket({1869375010,1852404833,1634492263,1919251566,872444782,0},"الفوانيس الطافية")end
-- جسر فينيسي
function WaterDec28()
applyTicket({1634292250,1601139820,1684632130,25959,0,0},"جسر فينيسي")end
-- مخيم عائم
function WaterDec29()
applyTicket({1767985960,1735289196,1952866642,1701999711,1920299873,101},"مخيم عائم")end
-- الجسر الزجاجي
function WaterDec30()
applyTicket({1634486038,1916957555,1701274729,0,0,0},"الجسر الزجاجي")end
-- المدينة الغارقة
function WaterDec31()
applyTicket({1668440360,1868915048,2036821868,1819566431,1769238113,115},"المدينة الغارقة")end
-- يخت متعة
function WaterDec32()
applyTicket({1667332362,1862300776,0,0,0,0},"يخت متعة")end
-- المحطة البحرية
function WaterDec33()
applyTicket({1634038558,1952543827,1601073001,1702259044,0,0},"المحطة البحرية")end
-- بوابات البحر
function WaterDec34()
applyTicket({1634038544,1952540511,1702101093,0,0,0},"بوابات البحر")end
-- قارب
function WaterDec35()
applyTicket({1634689556,1597124724,7235942,0,0,0},"قارب")end
-- الفندق الشراعي
function WaterDec36()
applyTicket({1767994130,1953450092,1761635429,0,0,0},"الفندق الشراعي")end
-- قارب صيد
function WaterDec37()
applyTicket({1768452872,1635057776,1751082098,29813,0,0},"قارب صيد")end
-- الشعب المرجانية
function WaterDec38()
applyTicket({1701147156,1701338982,6645604,0,0,0},"الشعب المرجانية")end
-- جنية الماء
function WaterDec39()
applyTicket({1767990806,2002745714,1919251553,0,0,0},"جنية الماء")end
-- البوابة الجليدية
function WaterDec40()
applyTicket({1701013788,1751347777,1668440415,6515060,0,0},"البوابة الجليدية")end
-- فيلا مائية
function WaterDec41()
applyTicket({1952536352,1967288933,1818322798,1347647343,3670073,7566444},"فيلا مائية")end
-- السفينة القديمة
function WaterDec42()
applyTicket({1634034206,1601795189,1818845555,1952542562,0,0},"السفينة القديمة")end
-- قارب المتعة
function WaterDec43()
applyTicket({1634034212,1601795189,1734439524,1650421359,7627119,0},"قارب المتعة")end
-- قارب الجندول
function WaterDec44()
applyTicket({1634034204,1601795189,1684959079,6384751,0,0},"قارب الجندول")end
-- زلاقة مائية
function WaterDec45()
applyTicket({1634034210,1601795189,1702125943,1768706930,25956,0},"زلاقة مائية")end
-- زلاجة
function WaterDec46()
applyTicket({1634034210,1601795189,1702125943,1634886514,29798,0},"زلاجة")end
-- سوق رصيف الصيد
function WaterDec47()
applyTicket({1634034212,1601795189,1752394086,1918987615,7628139,0},"سوق رصيف الصيد")end
-- حديقة مرجانية
function WaterDec48()
applyTicket({1634034214,1601795189,1634889571,1634164588,1852138610,0},"حديقة مرجانية")end
-- زيارة الدلافين
function WaterDec49()
applyTicket({1634034206,1601795189,1886154596,1936615784,0,0},"زيارة الدلافين")end
-- الغواصة
function WaterDec50()
applyTicket({1634034208,1601795189,1835169139,1852404321,101,0},"الغواصة")end
--مستكشف اعماق البحار
function WaterDec51()
applyTicket({1634034220,1601795189,1600218483,1702061426,1751347809,7565925},"مستكشف اعماق البحار")end
-- جسر الحلوى
function WaterDec52()
applyTicket({1634034214,1601795189,1684955491,1919049593,1701274729,0},"جسر الحلوى")end
-- حديقة مائية قطبية
function WaterDec53()
applyTicket({1634034220,1601795189,1650811753,1600615013,1735288176,7235957},"حديقة مائية قطبية")end
-- الغواصون
function WaterDec54()
applyTicket({1634034212,1601795189,1702259044,1650422642,7627119,0},"الغواصون")end
-- فندق في أطلانتس
function WaterDec55()
applyTicket({1634034218,1601795189,1634497633,1936290926,1953458271,27749},"فندق في أطلانتس")end
-- رمح ثلاثي 
function WaterDec56()
applyTicket({1634034210,1601795189,1634497633,1634230131,25710,0},"رمح ثلاثي")end
-- كسارة الثلج
function WaterDec57()
applyTicket({1634034210,1601795189,1650811753,1801545074,29285,0},"كسارة الثلج")end
-- نيسي
function WaterDec58()
applyTicket({1634034216,1601795189,1702125943,1869438834,1702130542,114},"نيسي")end
-- سفينة مسكونة
function WaterDec59()
applyTicket({1634034210,1601795189,1936681063,1752391540,28777,0},"سفينة مسكونة")end
-- بيت من طابق واحد
function WaterDec60()
applyTicket({1634034216,1601795189,1937076072,1818316133,1702259044,115},"بيت من طابق واحد")end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- ============================================================
-- 🌲 أشجار وأزهار (Trees)
-- ============================================================

-- شجرة أرز
function Tree1()
applyTicket({1701996302,842100325,0,0,0,0},"شجرة أرز")end

-- شجرة تنوب
function Tree2()
applyTicket({1701996302,808611429,0,0,0,0},"شجرة تنوب")end

-- شجرة جزر
function Tree3()
applyStatue({1851877492,1768387435,1735289206,1918976863,1416916850,6645106,23},"شجرة جزر")end

-- نبات الوستريا
function Tree4()
applyTicket({1634034206,1601795189,1953720695,1634300517,0,0},"نبات الوستريا")end

-- شجرة الأرجواني
function Tree5()
applyTicket({1634034208,1601795189,1734439521,1701732725,121,0},"شجرة الأرجواني")end

-- الوردية
function Tree6()
applyTicket({1634034214,1601795189,1685022834,1852138607,1852797540,0},"الوردية")end

-- شجرة البونسيانا
function Tree7()
applyTicket({1634034204,1601795189,1869374820,7891310,0,0},"شجرة البونسيانا")end

-- السنط
function Tree8()
applyTicket({1634034218,1601795189,1667326817,1734304105,1717662313,25958},"السنط")end

-- نخيل البلح
function Tree9()
applyTicket({1634034210,1601795189,1768843622,1634754403,28012,0},"نخيل البلح")end

-- الصنوبر الياباني
function Tree10()
applyTicket({1634034208,1601795189,1701734768,1701999711,101,0},"الصنوبر الياباني")end

-- شجرة السكوية
function Tree11()
applyTicket({1634034204,1601795189,1970365811,6383983,0,0},"شجرة السكوية")end

-- شجرة شبكة العنكبوت
function Tree12()
applyStatue({1667592275,1114399081,1953849701,1884512121,1919247465,1701147220,24},"شجرة شبكة العنكبوت")end

-- شجرة قابلة للنفخ
function Tree13()
applyTicket({1634034212,1601795189,1701147252,1818321503,7237484,0},"شجرة قابلة للنفخ")end

-- أزهار برية
function Tree14()
applyTicket({1701996302,808545893,0,0,0,0},"أزهار برية")end

-- باقة بالونات
function Tree15()
applyTicket({1634034218,1601795189,1869373794,1717530223,1702326124,29554},"باقة بالونات")end

-- مزهرية الأزهار
function Tree16()
applyTicket({1634034212,1601795189,2003790950,1985966693,6648673,0},"مزهرية الأزهار")end

-- عمود إنارة من الزهور
function Tree17()
applyTicket({1634034218,1601795189,1953718629,1818194533,1702129249,28274},"عمود إنارة من الزهور")end

-- شجرة البروكلي
function Tree18()
applyStatue({1667592275,1114399081,1953849701,1918132089,1916953957,1868784495,1124100460,26},"شجرة البروكلي")end

-- مشتل الأزهار على شكل طاووس
function Tree19()
applyStatue({1667592275,1114399081,1953849701,1766023033,1631877492,1634754425,1852402806,28},"مشتل الأزهار على شكل طاووس")end

-- شجرة الحصاد
function Tree20()
applyStatue({1667592275,1114399081,1953849701,1634230137,1936029298,1768316788,1701999975,28},"شجرة الحصاد")end

-- شجرة المصباح
function Tree21()
applyStatue({1667592275,1114399081,1953849701,1749245817,1600220777,1751607660,1701991540,1049231461,29},"شجرة المصباح")end

-- شجرة عيد الفصح
function Tree22()
applyStatue({1667592275,1114399081,1953849701,1631936377,1919251571,1935754591,1416783220,6645106,31},"شجرة عيد الفصح")end

-- تمثال النصر
function Tree23()
applyTicket({1768649504,2003780467,2037149535,1634300013,668926052,110},"تمثال النصر")end

-- نافورة شجرة الحياة
function Tree24()
applyTicket({1970234906,1767994478,1920229230,25957,0,0},"نافورة شجرة الحياة")end

-- عمل مشبك الغسيل الفني
function Tree25()
applyTicket({1852395544,1819632467,1920300144,1701314661,0,0},"عمل مشبك الغسيل الفني")end

-- الشراع الذهبي
function Tree26()
applyTicket({1634231064,1869181037,1969446766,1601372272,1953718640,97},"الشراع الذهبي")end

-- المنتزه البري
function Tree27()
applyTicket({1818851088,1918988388,1969422443,1601372272,1953718640,97},"المنتزه البري")end

-- نافورة مشتل الأزهار 1
function Tree28()
applyTicket({1869374996,1651664247,3236965,1869768558,2037540195,0},"نافورة مشتل الأزهار 1")end

-- نافورة مشتل الأزهار 2
function Tree29()
applyTicket({1869374996,1651664247,3302501,1869768558,2037540195,0},"نافورة مشتل الأزهار 2")end

-- حديقة الأزهار
function Tree30()
applyTicket({1918988306,828322155,822096248,3307520,875585381,0},"حديقة الأزهار")end

-- ازدهار الكرز
function Tree31()
applyTicket({1701991446,1634951013,1634891115,3307520,875585381,0},"ازدهار الكرز")end

-- شجرة نخيل
function Tree32()
applyTicket({1818325004,3432813,1634891115,3307520,875585381,0},"شجرة نخيل")end

-- معدات الشاطئ
function Tree33()
applyTicket({1818325014,1952407917,1835365487,3276800,875585381,0},"معدات الشاطئ")end

-- الباوباب
function Tree34()
applyTicket({1868653068,6447458,1953718627,25964,0,0},"الباوباب")end

-- لوحة الزهور
function Tree35()
applyTicket({1818316832,1702130789,1819632467,1920300144,-414711707,111},"لوحة الزهور")end

-- وردة القصة الخيالية
function Tree36()
applyTicket({1869375006,1433560439,1919247470,1685024584,3670016,7566444},"وردة القصة الخيالية")end

-- زهور دوار الشمس
function Tree37()
applyTicket({1853190930,2003790950,1694528101,845116274,0,0},"زهور دوار الشمس")end

-- شجرة التفاح
function Tree38()
applyTicket({1886413076,1952408940,6645106,7237475,-469733771,111},"شجرة التفاح")end

-- ورود صفراء
function Tree39()
applyTicket({1818589464,1601662828,1702063986,6619251,875585381,0},"ورود صفراء")end

-- الجربارة
function Tree40()
applyTicket({1869375010,1651664247,1734304869,1700950629,1929404786,0},"الجربارة")end

-- السوسنيات
function Tree41()
applyTicket({1869375014,1651664247,1734304869,1768186220,1937075311,0},"السوسنيات")end

-- الخشخاش
function Tree42()
applyTicket({1869375010,1651664247,1885299813,1768976495,1929409381,0},"الخشخاش")end

-- القزحية
function Tree43()
applyTicket({1869375008,1651664247,1767859301,1702062450,1936457843,0},"القزحية")end

-- نرجسي
function Tree44()
applyTicket({1869375014,1651664247,1683973221,1868981857,1936484708,0},"نرجسي")end

-- حقل الزهور
function Tree45()
applyTicket({1869375000,1601332599,1734632808,101,872444782,0},"حقل الزهور")end

-- تشذيب القلعة
function Tree46()
applyTicket({1886352412,2037539177,1935762271,6646900,0,0},"تشذيب القلعة")end

-- شجرة في طور الازدهار
function Tree47()
applyTicket({1869375004,1769104759,1952409454,6645106,0,0},"شجرة في طور الازدهار")end

-- شجرة السلة
function Tree48()
applyTicket({1701999640,1752391525,1852403809,103,0,0},"شجرة السلة")end

-- الصبار
function Tree49()
applyTicket({1667326732,7566708,1701079404,0,0,0},"الصبار")end

-- شجرة السكر
function Tree50()
applyTicket({1702318868,1415541861,6645106,0,0,0},"شجرة السكر")end

-- شجرتا أرز
function Tree51()
applyTicket({1701996300,3698277,0,0,0,0},"شجرتا أرز")end

-- شجرة مورقة 1
function Tree52()
applyTicket({1701996302,909209189,0,0,0,0},"شجرة مورقة 1")end

-- شجرة مورقة 2
function Tree53()
applyTicket({1701996300,3305061,0,0,0,0},"شجرة مورقة 2")end

-- شجرة مورقة 3
function Tree54()
applyTicket({1701996302,875654757,0,0,0,0},"شجرة مورقة 3")end

-- شجرة مورقة 4
function Tree55()
applyTicket({1634562854,1734306924,1852138866,1701999711,875585381,0},"شجرة مورقة 4")end

-- شجرة التنوب 1
function Tree56()
applyTicket({1701996302,808611429,0,0,0,0},"شجرة التنوب 1")end

-- شجرة التنوب 2
function Tree57()
applyTicket({1701996304,1597337189,50,0,0,0},"شجرة التنوب 2")end

-- حديقة الفضاء
function Tree58()
applyTicket({1634759446,1634166115,1852138610,0,0,0},"حديقة الفضاء")end

-- شجرة تزيين
function Tree59()
applyTicket({1701996310,1952411237,828728690,0,0,0},"شجرة تزيين")end

-- شجرة زينة
function Tree60()
applyTicket({1701996310,1952411237,845505906,0,0,0},"شجرة زينة")end

-- شجيرة زينة
function Tree61()
applyTicket({1701996310,1952411237,862283122,0,0,0},"شجيرة زينة")end

-- أرنب المنتزه
function Tree62()
applyTicket({1701996310,1650421349,2037280373,0,0,0},"أرنب المنتزه")end

-- شرفة
function Tree63()
applyTicket({1701996312,1868721765,1768316792,7536750,0,0},"شرفة")end

-- نبات الصفصاف المتهدل
function Tree64()
applyTicket({1701148444,1735289200,1818851167,7827308,0,0},"نبات الصفصاف المتهدل")end

-- بيت الشجرة
function Tree65()
applyTicket({1701999648,1769430885,1935632500,1919508852,-352321421,0},"بيت الشجرة")end

-- شجرة الضوء
function Tree66()
applyTicket({1768440602,1702061422,1918130510,1862296933,0,0},"شجرة الضوء")end

-- التشذيب على شكل طير
function Tree67()
applyTicket({1701996308,1650421349,6582889,0,0,0},"التشذيب على شكل طير")end

-- التشذيب على شكل دولفين
function Tree68()
applyTicket({1701996314,1683975781,1752198255,1946185321,0,0},"التشذيب على شكل دولفين")end

-- التشذيب على شكل طاووس
function Tree69()
applyTicket({1701996314,1885302373,1868783973,1946184547,0,0},"التشذيب على شكل طاووس")end

-- تشذيب على شكل سلحفاة
function Tree70()
applyTicket({1701996312,1952411237,1819570805,1946157157,0,0},"تشذيب على شكل سلحفاة")end

-- التشذيب على شكل فيل
function Tree71()
applyTicket({1701996316,1700752997,1752196460,7630433,0,0},"التشذيب على شكل فيل")end

-- نبات العدينة
function Tree72()
applyTicket({1701999640,1684103013,1969843813,1702494317,0,0},"نبات العدينة")end

-- شجرة ساقطة
function Tree73()
applyTicket({1701344022,1684370017,1701147220,0,0,0},"شجرة ساقطة")end

-- تمثال الزرافة
function Tree74()
applyTicket({1919510286,1701208434,1868783872,1946184547,6648431,0},"تمثال الزرافة")end

-- تمثال الغوريلا
function Tree75()
applyTicket({1919903502,1634495593,1744830464,7630433,6648431,0},"تمثال الغوريلا")end

-- ورود حمراء
function Tree76()
applyTicket({1936683538,1969381221,1845520499,25955,875585381,0},"ورود حمراء")end

-- خليج صغير
function Tree77()
applyTicket({1920234264,1601003877,1734632808,101,872444782,0},"خليج صغير")end

-- تركيب الأعجوبة الطبيعية
function Tree78()
applyTicket({1936615712,1819042164,1869182049,1918984046,1718157428,7536741},"تركيب الأعجوبة الطبيعية")end

-- شجرة توت
function Tree79()
applyTicket({1919246878,1918138738,1801413989,1701210478,1701999872,0},"شجرة توت")end

-- عربة الزهور
function Tree80()
applyStatue({1667592275,1114399081,1953849701,1633050489,1953391980,1600482921,2003790950,1633907301,905999474,34},"عربة الزهور")end

-- قوس الأزهار
function Tree81()
applyStatue({1667592275,1114399081,1953849701,1766023033,1631877492,1918984057,1868523619,1818648422,1919252335,115,37},"قوس الأزهار")end

-- مشتل الأزهار على شكل سيارة
function Tree82()
applyStatue({1667592275,1114399081,1953849701,1766023033,1631877492,1818648441,1919252335,1600415074,7496035,35},"مشتل الأزهار على شكل سيارة")end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪

-- ============================================================
-- 🚧 سياج وجسور (Fences)
-- ============================================================

-- السياج الذهبي
function Fence1()
applyTicket({2020961304,1601794677,1668179302,7536741,875585381,0},"السياج الذهبي")end

-- فوانيس ورقية
function Fence2()
applyStatue({1667592275,1114399081,1953849701,1749245817,1600220777,1953390956,7238245,27},"فوانيس ورقية")end

-- جسر الفاكهة
function Fence3()
applyStatue({1667592275,1114399081,1953849701,1917214585,1114925429,1734633842,65637,25},"جسر الفاكهة")end

-- سياج من بسكويت الزنجبيل
function Fence4()
applyTicket({1851876118,1717533028,1701015141,1752392960,1929408623,29440},"سياج من بسكويت الزنجبيل")end

-- سياج الزهور
function Fence5()
applyTicket({1869375000,1601332599,1668179302,7536741,0,0},"سياج الزهور")end

-- سياج البحر
function Fence6()
applyTicket({1634030364,1668179270,1701207909,6644590,1701015137,0},"سياج البحر")end

-- سياج شجيرات
function Fence7()
applyTicket({1684367370,1627415911,0,0,0,0},"سياج شجيرات")end

-- سياج ديكوري
function Fence8()
applyTicket({1634887450,1702127982,1852139103,25955,0,0},"سياج ديكوري")end

-- سياج خشبي
function Fence9()
applyTicket({1768453910,1717527924,1701015141,0,0,0},"سياج خشبي")end

-- سياج شرقي
function Fence10()
applyTicket({1768440602,1702061422,1852139103,25955,0,0},"سياج شرقي")end

-- سياج عيد الفصح
function Fence11()
applyTicket({1935754520,1601332596,1668179302,1852375141,-368251136,111},"سياج عيد الفصح")end

-- بوابة الزهور
function Fence12()
applyTicket({1634034214,1601795189,2003790918,1734308453,1936028769,0},"بوابة الزهور")end

-- بوابات المجد
function Fence13()
applyTicket({1634034214,1601795189,1970828620,1734310258,1936028769,0},"بوابات المجد")end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪

-- ============================================================
-- 🗿 تماثيل ونوافير (Statues)
-- ============================================================

-- مصمم الطائرات الأول
function Statue1()
applyTicket({1635021594,1600484724,1652124774,1744861551,1702065519,0},"مصمم الطائرات الأول")end

-- العالم الأول
function Statue2()
applyTicket({1635021604,1600484724,1851876718,1953654116,7102824,0},"العالم الأول")end

-- لاعب كرة القدم الأول
function Statue3()
applyTicket({1635021602,1600484724,1953460070,1819042146,29285,0},"لاعب كرة القدم الأول")end

-- عالم الوراثة الأول
function Statue4()
applyTicket({1635021602,1600484724,1701733735,1768122740,29811,0},"عالم الوراثة الأول")end

-- السائح الأول
function Statue5()
applyTicket({1635021596,1600484724,1920298868,7631721,29811,0},"السائح الأول")end

-- الكيميائي الأول
function Statue6()
applyTicket({1635021596,1600484724,1835362403,7631721,29811,0},"الكيميائي الأول")end

-- المفكر الأول
function Statue7()
applyTicket({1635021596,1600484724,1852401780,7497067,29811,0},"المفكر الأول")end

-- رجل إطفاء الحرائق الأول
function Statue8()
applyTicket({1635021596,1600484724,1701996902,7233901,29811,0},"رجل إطفاء الحرائق الأول")end

-- الكاتب الأول
function Statue9()
applyTicket({1635021594,1600484724,1953067639,29285,29811,0},"الكاتب الأول")end

-- الشرطي الأول
function Statue10()
applyTicket({1635021600,1600484724,1768714096,1634559331,110,0},"الشرطي الأول")end

-- الموسيقي الأول
function Statue11()
applyTicket({1635021596,1600484724,1769174381,7233891,110,0},"الموسيقي الأول")end

-- الرسام الأول
function Statue12()
applyTicket({1635021594,1600484724,1769239137,29811,110,0},"الرسام الأول")end

-- قاهر البحار
function Statue13()
applyTicket({1635021600,1600484724,1952542562,1819240287,1701707876,114},"قاهر البحار")end

-- درج لا نهاية له
function Statue14()
applyTicket({1635021594,1601401449,1668571501,1962947432,1862296947,110},"درج لا نهاية له")end

-- افضل تمثال صنعه العمدة
function Statue15()
applyTicket({1919509036,1633970292,1852403321,1667581029,1952543343,7237481},"افضل تمثال صنعه العمدة")end

-- تمثال حامل الشعلة
function Statue16()
applyStatue({1969317218,1952414068,1751347823,1918985570,1868526181,1886222700,6578537,27},"تمثال حامل الشعلة")end

-- بركة بها إوز
function Statue17()
applyStatue({1701601622,1852404846,1867538277,2002740334,1600681065,1851881331,1702232179,25},"بركة بها إوز")end

-- صائدة الأشباح
function Statue18()
applyStatue({1667592275,1114399081,1953849701,1749507961,1651798895,1702130549,301138034,25},"صائدة الأشباح")end

-- نافورة الأصدقاء
function Statue19()
applyStatue({1667592275,1114399081,1953849701,1851875193,1818324329,2003792991,1124102757,26},"نافورة الأصدقاء")end

-- تمثال القرد
function Statue20()
applyStatue({1667592275,1114399081,1953849701,1749245817,1600220777,1802399597,1711307109,26},"تمثال القرد")end

-- تمثال عيد مدينة سعيد
function Statue21()
applyStatue({1667592275,1114399081,1953849701,1768054649,1684567154,1650424161,1869376609,110,29},"تمثال عيد مدينة سعيد")end

-- الطاهي
function Statue22()
applyStatue({1667592275,1114399081,1953849701,1951620985,1702196321,1750361679,1869562725,1049231467,29},"الطاهي")end

-- نافورة الغرام
function Statue23()
applyStatue({1701601622,1852404846,1868980069,1635020405,1700753001,1852990836,1869376609,25974,30},"نافورة الغرام")end

-- الربيع
function Statue24()
applyStatue({1667592275,1114399081,1953849701,1631936377,1919251571,1919963999,1197960809,7107177,31},"الربيع")end

-- بركة سمك الشبوط
function Statue25()
applyTicket({1852796956,1769430884,1667197044,7369313,0,0},"بركة سمك الشبوط")end

-- تمثال القائد
function Statue26()
applyTicket({1852796178,1852140917,1845506420,1701999711,875585381,0},"تمثال القائد")end

-- نافورة عصرية
function Statue27()
applyTicket({1970234898,1767994478,1761620590,1701970030,875585381,0},"نافورة عصرية")end

-- تمثال الملك
function Statue28()
applyTicket({1852796178,1852140917,13172,1701970030,875585381,0},"تمثال الملك")end

-- المسلة الحجرية
function Statue29()
applyTicket({1852796178,1852140917,1593848948,3307569,875585381,0},"المسلة الحجرية")end

-- الكرة الحجرية
function Statue30()
applyTicket({1852796178,1852140917,12916,3307569,875585381,0},"الكرة الحجرية")end

-- نافورة كلاسيكية
function Statue31()
applyTicket({1970234898,1767994478,822096238,3307520,875585381,0},"نافورة كلاسيكية")end

-- تمثال الأسد
function Statue32()
applyTicket({1869179912,1701183598,1868783872,1946184547,6648431,0},"تمثال الأسد")end

-- تمثال البطريق
function Statue33()
applyTicket({1852141582,1852405095,1819570688,1946157157,6648431,0},"تمثال البطريق")end

-- تمثال التمساح
function Statue34()
applyTicket({1869767442,1768189795,1744856428,7630433,6648431,0},"تمثال التمساح")end

-- تمثال الباندا
function Statue35()
applyTicket({1851879434,1627414884,1744830464,7630433,6648431,0},"تمثال الباندا")end

-- تماثيل الحديقة
function Statue36()
applyTicket({1869506316,7562605,1919247470,1685024584,3670016,0},"تماثيل الحديقة")end

-- سيد الفاكهة
function Statue37()
applyTicket({1852403222,1801412970,1701210478,1761638144,1852795252,7566336},"سيد الفاكهة")end

-- القراصنة
function Statue38()
applyTicket({1885430568,1852399988,1952543827,1885300085,1952543337,101},"القراصنة")end

-- النافورة التفاعلية
function Statue39()
applyTicket({1819239208,1866887791,1635020405,1834970729,1751348321,51},"النافورة التفاعلية")end

-- الثور الغاضب
function Statue40()
applyTicket({1869767190,1600485998,1819047266,7237376,0,0},"الثور الغاضب")end

-- دليل البحر
function Statue41()
applyTicket({1818585130,1333028205,1886352483,1633645429,1701405550,29806},"دليل البحر")end

-- الثور الذهبي
function Statue42()
applyTicket({1819632162,1635013484,1600484724,1852732786,1694528101,114},"الثور الذهبي")end

-- النوافير الراقصة
function Statue43()
applyTicket({1851876384,1735289187,1853189958,1852399988,6619251,0},"النوافير الراقصة")end

-- تمثال الحمار الوحشي
function Statue44()
applyTicket({1650817546,1627414898,0,0,0,0},"تمثال الحمار الوحشي")end

-- تمثال فقمة الفراء
function Statue45()
applyTicket({1634038536,1627390060,0,0,0,0},"تمثال فقمة الفراء")end

-- تمثال الفلامينجو
function Statue46()
applyTicket({1634493968,1735289197,1744830575,0,0,0},"تمثال الفلامينجو")end

-- تمثال نمر البحر
function Statue47()
applyTicket({1734964234,1845523045,0,0,0,0},"تمثال نمر البحر")end

-- تمثال الكوالا
function Statue48()
applyTicket({1634691850,1677746540,1752198255,1946185321,0,0},"تمثال الكوالا")end

-- تمثال البجعة
function Statue49()
applyTicket({1635218184,1683947630,1752198255,1946185321,0,0},"تمثال البجعة")end

-- نافورة جنية مزهرة
function Statue50()
applyTicket({1767982620,1180662130,1953396079,7235937,0,0},"نافورة جنية مزهرة")end

-- حارس الثروة
function Statue51()
applyTicket({1634886696,1601072999,1952543859,1398760821,809000784,48},"حارس الثروة")end

-- المصباح السحري
function Statue52()
applyTicket({1634885918,1600350562,1601071466,1886216556,1667329024,101},"المصباح السحري")end

-- تمثال الجعران
function Statue53()
applyTicket({1633907480,1600282994,1887004517,1634533492,0,0},"تمثال الجعران")end

-- الخيول العربية
function Statue54()
applyTicket({1634885926,1600350562,1936879464,1953718117,1702196321,0},"الخيول العربية")end

-- الثلاثي الرائع
function Statue55()
applyTicket({1769100296,1631780975,1937076082,6646885,0,0},"الثلاثي الرائع")end

-- تمثال المخرج المشهور
function Statue56()
applyTicket({1734955024,1633907535,1937047666,0,0,0},"تمثال المخرج المشهور")end

-- الصنبور السحري
function Statue57()
applyTicket({1634878234,1866884462,1635020405,1912630889,0,0},"الصنبور السحري")end

-- الكلب الأصفر
function Statue58()
applyTicket({1768440596,1702061422,6778692,0,0,0},"الكلب الأصفر")end

-- رمز العام الجديد
function Statue59()
applyTicket({1768440614,1702061422,1885296974,1951623017,1702196321,0},"رمز العام الجديد")end

-- نافورة عيد الفصح
function Statue60()
applyTicket({1935754526,1601332596,1853189990,1852399988,-368251136,111},"نافورة عيد الفصح")end

-- رامي القرص
function Statue61()
applyTicket({1936286762,1416852835,2003792488,1633645157,1701405550,29806},"رامي القرص")end

-- نافورة الأنغام
function Statue62()
applyTicket({1919503384,1970226785,1767994478,1912602734,-368902043,111},"نافورة الأنغام")end

-- نافورة الحوت
function Statue63()
applyTicket({1970234908,1767994478,1752653678,6646881,7566446,29806},"نافورة الحوت")end

-- نافورة عصرية
function Statue64()
applyTicket({1970234898,1767994478,1761620590,1701970030,875585381,0},"نافورة عصرية")end

-- نافورة الشهرة
function Statue65()
applyTicket({1970234906,1767994478,2004049774,28257,872444782,0},"نافورة الشهرة")end

-- نافورة الشلال
function Statue66()
applyTicket({1970234898,1767994478,1946170478,6645106,875585381,0},"نافورة الشلال")end

-- حارس اللفائف
function Statue67()
applyTicket({1919512618,1399157857,1970561396,1920229221,1970495845,25970},"حارس اللفائف")end

-- تمثال الشمس
function Statue68()
applyTicket({1701860130,1818323299,1969317186,1398765940,28277,0},"تمثال الشمس")end

-- تمثال موجة الثلج
function Statue69()
applyStatue({2003791475,1918988130,1701335908,1868525669,1886222700,6578537,23},"تمثال موجة الثلج")end

-- تمثال المحبين
function Statue70()
applyStatue({1701601622,1852404846,1951620965,1702196321,1987005535,7565925,23},"تمثال المحبين")end

-- تمثال خبز الزنجبيل
function Statue71()
applyStatue({1769105475,1634563187,1766285171,1919248238,1634038370,1851870564,24},"تمثال خبز الزنجبيل")end

-- تمثال الطاووس
function Statue72()
applyTicket({1634034218,1601795189,1667327344,1600873327,1952543859,25973},"تمثال الطاووس")end

-- تمثال عائلة الدببة
function Statue73()
applyTicket({1634034200,1717531506,1818848609,121,0,0},"تمثال عائلة الدببة")end

-- تمثال وحيد القرن
function Statue74()
applyTicket({1634034200,1601795189,1852401778,111,0,0},"تمثال وحيد القرن")end

-- تمثال الدب القطبي
function Statue75()
applyTicket({1634034210,1601795189,1634496368,1700945778,29281,0},"تمثال الدب القطبي")end

-- تمثال قديم
function Statue76()
applyTicket({1634034216,1601795189,1735292266,1952408940,1835365487,115},"تمثال قديم")end

-- تمثال بوسيدون
function Statue77()
applyTicket({1634034206,1601795189,1702063984,1852793961,0,0},"تمثال بوسيدون")end

-- تمثال الثروات البحرية
function Statue78()
applyTicket({1634034220,1601795189,1634497633,1936290926,1635021663,6649204},"تمثال الثروات البحرية")end

-- تمثال جليدي لحيوان الرنة
function Statue79()
applyTicket({1634034204,1601795189,1147495273,7497061,0,0},"تمثال جليدي لحيوان الرنة")end

-- أمير على حصان أبيض
function Statue80()
applyStatue({1701601622,1852404846,1953718117,1702196321,1769107551,6644590,23},"أمير على حصان أبيض")end

-- بطل العالم
function Statue81()
applyTicket({1634034212,1601795189,1953460038,1819042146,6778692,0},"بطل العالم")end

-- عمد Wild West
function Statue82()
applyStatue({1667592275,1114399081,1953849701,1866686329,1852796269,1818322295,1951623284,1702196321,32},"عمد Wild West")end

-- الجبابرة
function Statue83()
applyTicket({1634034202,1601795189,1635019124,29550,0,0},"الجبابرة")end

-- نافورة الفيلم
function Statue84()
applyTicket({1634034216,1601795189,1769369421,1970226789,1767994478,110},"نافورة الفيلم")end

-- فنان شارع
function Statue85()
applyTicket({2003780370,1769239105,29811,0,872694720,124},"فنان شارع")end

-- نافورة الشوكولاتة
function Statue86()
applyStatue({1667592275,1114399081,1953849701,1631936377,1919251571,1869103967,1634496355,1866884468,905997941,34},"نافورة الشوكولاتة")end

-- نافورة حفل الشاي
function Statue87()
applyStatue({1667592275,1114399081,1953849701,1868980089,1635020405,1918856809,1869902693,1851880053,838886772,34},"نافورة حفل الشاي")end

-- نافورة الرقم القياسي الجديد
function Statue88()
applyTicket({1634034220,1601795189,1836674127,1180920176,1953396079,7235937},"نافورة الرقم القياسي الجديد")end

-- ============================================================
-- 🎃 هالوين ورعب (Halloween)
-- ============================================================

-- مصباح الأشباح
function Halloween1()
applyStatue({1667592275,1114399081,1953849701,1632395129,1919251566,1869105006,1845523571,26},"مصباح الأشباح")end

-- عربة المطاردة
function Halloween2()
applyStatue({1667592275,1114399081,1953849701,1867014009,1919906418,1936879432,1694528357,26},"عربة المطاردة")end

-- عجلة قرع العسل
function Halloween3()
applyStatue({1667592275,1114399081,1953849701,1968201593,1768648813,1701336942,1241541733,26},"عجلة قرع العسل")end

-- قبو مخيف
function Halloween4()
applyStatue({1969317218,1751087476,1869376609,1852138871,1633907551,1667201394,1953528178,28},"قبو مخيف")end

-- عربة الأشباح
function Halloween5()
applyTicket({1869113118,2037150835,1920098627,1701273961,7471104,111},"عربة الأشباح")end

-- بقعة خضر رائعة
function Halloween6()
applyTicket({1869104918,1632072819,1852138610,1633645312,1701405550,29806},"بقعة خضر رائعة")end

-- غرفة الرعب
function Halloween7()
applyTicket({1818322976,1702326124,1834970725,1969582965,1238237293,114},"غرفة الرعب")end

-- ساحرة مع جرعة
function Halloween8()
applyTicket({1818322974,1702326124,2002742885,1751348329,6646784,97},"ساحرة مع جرعة")end

-- رجل اليقطين
function Halloween9()
applyTicket({1818322972,1702326124,1885302373,7368053,6646784,97},"رجل اليقطين")end

-- القطة السوداء
function Halloween10()
applyTicket({1818322970,1702326124,1667198565,29793,6646784,97},"القطة السوداء")end

-- شجرة مع ثمار يقطين
function Halloween11()
applyTicket({1818322972,1702326124,1952411237,6645106,6646784,97},"شجرة مع ثمار يقطين")end

-- زينة عادية
function Halloween12()
applyTicket({1818322984,1702326124,1734307429,1953722216,1768452959,112},"زينة عادية")end

-- السفينة الشبح
function Halloween13()
applyTicket({1818322984,1702326124,2002742885,1751348329,1919510623,101},"السفينة الشبح")end

-- متنزه الساحرات
function Halloween14()
applyTicket({1818322980,1702326124,1717530213,1953396079,7235937,29557},"متنزه الساحرات")end

-- نافورة مشؤومة
function Halloween15()
applyTicket({1818322976,1702326124,1667198565,1819571041,6619237,97},"نافورة مشؤومة")end

-- المزراب
function Halloween16()
applyTicket({1818322980,1702326124,1734307429,1869050465,6646905,97},"المزراب")end

-- فزاعة من اليقطين
function Halloween17()
applyTicket({1818322982,1702326124,1935634021,1701994851,2003792483,0},"فزاعة من اليقطين")end

-- طريق سري
function Halloween18()
applyTicket({1836404762,1852402544,1952795999,1828745074,0,0},"طريق سري")end

-- معصرة العنب
function Halloween19()
applyTicket({1634879254,1348429168,1936942450,0,0,0},"معصرة العنب")end

-- متجر الساحرة
function Halloween20()
applyTicket({1634488340,1398762350,7368552,0,0,0},"متجر الساحرة")end

-- فارس برأس قرع عسل
function Halloween21()
applyTicket({1634027554,1936026724,1867014003,1835365234,1912630881,0},"فارس برأس قرع عسل")end

-- البيت الزجاجي لآكل اللحوم
function Halloween22()
applyTicket({1701988134,1869114981,1600484213,1684370000,1919906913,0},"البيت الزجاجي لآكل اللحوم")end

-- عرض المستذئب
function Halloween23()
applyTicket({1634488348,1465871214,2003137125,6712431,0,0},"عرض المستذئب")end

-- بيت الرعب
function Halloween24()
applyTicket({1634231074,1919246957,1818323039,1702326124,28261,0},"بيت الرعب")end

-- البرج المرعب
function Halloween25()
applyTicket({1953449752,1600350568,1702326100,1835335794,1912630881,0},"البرج المرعب")end

-- مرجل سحري
function Halloween26()
applyTicket({1953060624,1867540579,1852113012,1633645312,1701405550,29806},"مرجل سحري")end

-- دورة ركوب المكنسة
function Halloween27()
applyTicket({1953060650,1951623267,1702196321,1818323039,1702326124,28261},"دورة ركوب المكنسة")end

-- المنزل الملعون
function Halloween28()
applyStatue({1819042152,1701148527,1634230126,1702129269,1869111140,6648693,23},"المنزل الملعون")end

-- أوركسترا مذهلة
function Halloween29()
applyStatue({1969317218,1751087476,1869376609,1852138871,1701540703,1869899116,1919901550,1936025699,6386292,35},"أوركسترا مذهلة")end

-- ============================================================
-- ❄️ كريسماس وثلج (Christmas)
-- ============================================================

-- الرقم السحري 2022
function Christmas1()
applyTicket({2003127824,1634031967,1912602738,7173481,1912602725,0},"الرقم السحري 2022")end

-- الكرة الثلجية 2
function Christmas2()
applyTicket({2003127832,1918985593,1651469383,101,872605664,124},"الكرة الثلجية 2")end

-- مدفع الثلج
function Christmas3()
applyTicket({2037141286,1667854445,1869501279,1667329399,1701734760,0},"مدفع الثلج")end

-- متجر هدايا الأعياد
function Christmas4()
applyStatue({808465457,1919435615,1836348265,1147106145,1919902565,1869182049,110,25},"متجر هدايا الأعياد")end

-- منزل هاسكي
function Christmas5()
applyStatue({1853189965,1852399988,1818323011,1214215269,2037085045,1937076040,1868955749,25},"منزل هاسكي")end

-- السيد بسكويت الزنجبيل
function Christmas6()
applyStatue({1735289159,1919054437,1298424165,1867017825,1869103988,1634496355,25972,26},"السيد بسكويت الزنجبيل")end

-- كوخ الأعياد
function Christmas7()
applyTicket({1852405542,1500669300,1601466997,1935764856,842149938,3289600},"كوخ الأعياد")end

-- مطعم وجبات خفيفة
function Christmas8()
applyTicket({1869576724,1952539999,7959141,111,878968932,0},"مطعم وجبات خفيفة")end

-- مساعدو سانتا
function Christmas9()
applyTicket({1851872022,1817403764,1751607653,1851875840,1701999711,101},"مساعدو سانتا")end

-- معركة الثلج
function Christmas10()
applyTicket({1869509406,1734952567,1885303912,1802396012,0,0},"معركة الثلج")end

-- مكتب سانتا
function Christmas11()
applyTicket({1851872030,1381982580,1885692773,1852795252,1912602624,0},"مكتب سانتا")end

-- حلبة تزلج السناجب
function Christmas12()
applyTicket({1734960684,1399157365,1769234795,2019518318,846422381,3289648},"حلبة تزلج السناجب")end

-- منزل بسكويت الزنجبيل
function Christmas13()
applyTicket({1852393240,1601332583,1937076040,7143525,1912602725,0},"منزل بسكويت الزنجبيل")end

-- زلاقة النعجات
function Christmas14()
applyTicket({1701335828,1817407589,6644841,0,0,0},"زلاقة النعجات")end

-- معدات الرياضيات الشتوية
function Christmas15()
applyTicket({1768641296,1869108063,1130299504,6645345,0,0},"معدات الرياضيات الشتوية")end

-- سوق شجرة العيد
function Christmas16()
applyTicket({1701991446,1632460645,1952803698,0,0,0},"سوق شجرة العيد")end

-- كوخ رجل الثلج
function Christmas17()
applyTicket({1634289434,1398764654,1836543854,1845522017,0,0},"كوخ رجل الثلج")end

-- مساعد سانتا
function Christmas18()
applyTicket({1701335838,1816490085,1970429798,1919250030,0,0},"مساعد سانتا")end

-- تماثيل جليدية
function Christmas19()
applyTicket({1701005608,1768454213,1769236834,1918856815,1701736053,114},"تماثيل جليدية")end

-- متحف الجليد
function Christmas20()
applyTicket({1701013798,1819632467,1920300144,1885303653,1802396012,0},"متحف الجليد")end

-- روديو حيوانات الرنة
function Christmas21()
applyTicket({1701143584,1684623986,1600613993,1851878512,1701249131,29554},"روديو حيوانات الرنة")end

-- كشك سوق الأعياد
function Christmas22()
applyTicket({1769304344,1600877423,1851878512,1718747243,0,0},"كشك سوق الأعياد")end

-- تنين الجليد
function Christmas23()
applyTicket({1701013778,1734439492,1224765039,0,0,0},"تنين الجليد")end

-- منحدر القلعة الجليدية
function Christmas24()
applyTicket({1768715032,1834968420,1751348321,1751318579,0,0},"منحدر القلعة الجليدية")end

-- بحيرة متجمدة
function Christmas25()
applyTicket({1701013774,1701536076,0,0,0,0},"بحيرة متجمدة")end

-- الينابيع الساخنة 1
function Christmas26()
applyTicket({1953450008,1970226783,1767994478,7143534,1912602725,0},"الينابيع الساخنة 1")end

-- ورشة سانتا
function Christmas27()
applyTicket({1987003156,1197437541,7628393,1852795252,1912602624,0},"ورشة سانتا")end

-- منزل سانتا
function Christmas28()
applyTicket({1919435562,1836348265,1398764385,1635020385,1970227295,25971},"منزل سانتا")end

-- منزل مساعد سانتا
function Christmas29()
applyTicket({1919443756,1836348265,1935635297,1635020385,1818585183,7497072},"منزل مساعد سانتا")end

-- ملك الثلج
function Christmas30()
applyTicket({1919435550,1836348265,1633645409,1818584942,7105536,111},"ملك الثلج")end

-- شجرة احتفالية
function Christmas31()
applyTicket({1919443756,1836348265,1918137185,2019517797,846422381,3289648},"شجرة احتفالية")end

-- الكرة الثلجية
function Christmas32()
applyTicket({1919443748,1836348265,1935635297,1651994478,7105633,111},"الكرة الثلجية")end

-- ليلة رأس السنة
function Christmas33()
applyTicket({1935764508,1970227316,1819303794,7040609,1970495845,25970},"ليلة رأس السنة")end

-- حادث في الورشة
function Christmas34()
applyTicket({1919907610,1869116267,1634878320,1912629363,1701735936,114},"حادث في الورشة")end

-- الكرلنج
function Christmas35()
applyTicket({1920295708,1735289196,1853190751,7497070,1761607800,26478},"الكرلنج")end

-- موسم الأعياد
function Christmas36()
applyTicket({1919443742,1836348265,1866691425,1735289197,1761607680,26478},"موسم الأعياد")end

-- مزلقة سانتا التربو
function Christmas37()
applyTicket({1920300066,1819504482,1701274725,1851880287,1761632628,26478},"مزلقة سانتا التربو")end

-- القلعة الثلجية 1
function Christmas38()
applyStatue({1769105475,1634563187,1850957683,1717532527,1920234095,7566181,23},"القلعة الثلجية 1")end

-- رنة سانتا
function Christmas39()
applyStatue({1769105475,1634563187,1632853875,1935766638,1768247903,6644846,23},"رنة سانتا")end

-- أنشطة شتوية
function Christmas40()
applyStatue({1735288176,1231972725,1869112675,2019517804,846422381,3289648,23},"أنشطة شتوية")end

-- ساحة الكريسماس
function Christmas41()
applyStatue({1769105507,1634563187,1634488435,2019517795,846422381,3289648,23},"ساحة الكريسماس")end

-- شاليه مريح
function Christmas42()
applyStatue({1853189965,1852399988,1818323011,1130329189,1215920751,1702065519,24},"شاليه مريح")end

-- القلعة الثلجية 2
function Christmas43()
applyTicket({1634034214,1601795189,2003791475,1953656678,1936942450,0},"القلعة الثلجية 2")end

-- زلاجة الثلج
function Christmas44()
applyTicket({1634034208,1601795189,2003791475,1684630643,101,0},"زلاجة الثلج")end

-- النهر الجليدي في القطب الشمالي
function Christmas45()
applyTicket({1634034204,1601795189,1650811753,6779493,0,0},"النهر الجليدي في القطب الشمالي")end

-- القلعة الجليدية
function Christmas46()
applyTicket({1634034210,1601795189,1600480105,1953718627,25964,0},"القلعة الجليدية")end

-- مصعد التزلج
function Christmas47()
applyTicket({1634034220,1601795189,1852732786,1667199589,1701601889,7496035},"مصعد التزلج")end

-- متعة الشتاء
function Christmas48()
applyTicket({1634034216,1601795189,1953393015,1667199589,1869508193,110},"متعة الشتاء")end

-- حلبة تزلج البطاريق
function Christmas49()
applyTicket({1634034220,1601795189,1952541555,1348955753,1969712741,7564905},"حلبة تزلج البطاريق")end

-- زلاجة كلاب
function Christmas50()
applyTicket({1634034212,1601795189,1936158564,1668440415,6515060,0},"زلاجة كلاب")end

-- محطة قطبية
function Christmas51()
applyTicket({1634034214,1601795189,1634496368,1635013490,1852795252,0},"محطة قطبية")end

-- منزل البحيرة
function Christmas52()
applyTicket({1634034210,1601795189,1701536108,1970235487,25971,0},"منزل البحيرة")end

-- صورة مع سانتا
function Christmas53()
applyTicket({1634034212,1601795189,1953390963,1819303777,7040609,0},"صورة مع سانتا")end

-- حلبة تزلج على الجليد
function Christmas54()
applyTicket({1634034218,1601795189,2003791475,1601069421,1952541555,29285},"حلبة تزلج على الجليد")end

-- منزل الأقزام
function Christmas55()
applyTicket({1634034208,1601795189,1600547941,1937076072,101,0},"منزل الأقزام")end

-- ============================================================
-- 🏛️ معالم أثرية (Ancient)
-- ============================================================

-- التقويم القديم
function Ancient1()
applyTicket({2036428058,1633902433,1684956524,1593864801,1735292266,25964},"التقويم القديم")end

-- برج بيزا المائل
function Ancient2()
applyTicket({2053196304,1970029434,1767964770,1912602734,872677477,124},"برج بيزا المائل")end

-- تمثال الفرعون
function Ancient3()
applyTicket({2036811044,1750103152,1868657249,1635013480,6649204,6357102},"تمثال الفرعون")end

-- هرم خوفو
function Ancient4()
applyTicket({2036811032,2035315824,1768776050,1929379940,7368552,6357102},"هرم خوفو")end

-- برج خليفة
function Ancient5()
applyTicket({1634034216,1601795189,1685222754,1751083130,1718185057,97},"برج خليفة")end

-- معبد تايلاندي
function Ancient6()
applyTicket({1634034212,1601795189,1767991412,1835365471,6646896,0},"معبد تايلاندي")end

-- مقدمة سفينة القرصان
function Ancient7()
applyTicket({1634034220,1601795189,1634888048,1935631732,1601202536,7827298},"مقدمة سفينة القرصان")end

-- صندوق كنز
function Ancient8()
applyTicket({1634034218,1601795189,1634038388,1701999987,1701339999,29811},"صندوق كنز")end

-- أطلال أتلانتس
function Ancient9()
applyTicket({1634034218,1601795189,1634497633,1936290926,1769304671,29550},"أطلال أتلانتس")end

-- المدينة المفقودة
function Ancient10()
applyTicket({1634034214,1601795189,1735292266,1918854508,1936615797,0},"المدينة المفقودة")end

-- المنزل الصيني
function Ancient11()
applyStatue({1667592275,1114399081,1953849701,1749245817,1600220777,1937076072,1132658789,25},"المنزل الصيني")end

-- وعاء الثروة
function Ancient12()
applyStatue({1667592275,1114399081,1953849701,1702322041,1752460385,2003788383,1170145388,25},"وعاء الثروة")end

-- عرش صاحب الجلالة
function Ancient13()
applyStatue({1667592275,1114399081,1953849701,1766547321,1416849262,1852797544,101,25},"عرش صاحب الجلالة")end

-- أبو الهول
function Ancient14()
applyTicket({1752199954,1601728105,1929392502,101,0,0},"أبو الهول")end

-- بناء ناطحة سحاب
function Ancient15()
applyTicket({1886217502,1600483945,1952543859,829841253,0,0},"بناء ناطحة سحاب")end

-- الهرم
function Ancient16()
applyTicket({1920561168,1684630881,1946157157,829841253,0,0},"الهرم")end

-- معبد الفردوس
function Ancient17()
applyTicket({1818316834,1600480097,1952409199,1935631720,-419399317,111},"معبد الفردوس")end

-- قوس النصر
function Ancient18()
applyTicket({1852796178,1852140917,1694512500,3241567,-416496384,111},"قوس النصر")end

-- قصر الشيخ
function Ancient19()
applyTicket({1634885928,1600350562,1633643617,1885302377,1667329121,101},"قصر الشيخ")end

-- فوهة بركان
function Ancient20()
applyTicket({1634886412,7497076,0,0,0,0},"فوهة بركان")end

-- دار أوبرا سيدني
function Ancient21()
applyTicket({1685680920,1601791342,1919250543,1929379937,0,0},"دار أوبرا سيدني")end

-- برج إيفل
function Ancient22()
applyTicket({1718183190,1952410725,1919252335,0,0,0},"برج إيفل")end

-- ساعة بيج بن
function Ancient23()
applyTicket({1734959630,1851875935,1702125824,829841152,0,0},"ساعة بيج بن")end

-- تاج محل
function Ancient24()
applyTicket({1784771606,1634230637,829841260,0,0,0},"تاج محل")end

-- تمثال الحرية
function Ancient25()
applyTicket({1701996052,1836016741,3241567,0,0,0},"تمثال الحرية")end

-- كاتدرائية نوتردام في باريس
function Ancient26()
applyTicket({1953451540,1147102578,6647137,1929379937,-369067669,111},"كاتدرائية نوتردام في باريس")end

-- كاتدرائية القديس باسيل
function Ancient27()
applyTicket({1935753748,1130327145,6845537,29696,-368923392,111},"كاتدرائية القديس باسيل")end

-- تيرانوسورس
function Ancient28()
applyStatue({1667592275,1114399081,1953849701,1766088569,1852401511,2035572583,1852727666,1969320815,7566706,35},"تيرانوسورس")end

-- بتروناس
function Ancient29()
applyTicket({1952804880,1634627442,1694498931,3241567,-368923392,111},"بتروناس")end

-- ============================================================
-- 🎮 ألعاب ومرح (Games)
-- ============================================================

-- سينما قديمة الطراز
function Game1()
applyTicket({2003127840,1701734723,1734304109,1651733601,873398393,124},"سينما قديمة الطراز")end

-- سيارات منخفضة
function Game2()
applyTicket({2003790880,1701079410,1918858098,1969451877,1761607781,26478},"سيارات منخفضة")end

-- راكب الدراجة الأنيق
function Game3()
applyTicket({2003788586,1400467298,1970561396,1769430885,1702323308,29811},"راكب الدراجة الأنيق")end

-- ملعب رعاة البقر الصغار
function Game4()
applyTicket({2003780376,1601793890,1702326100,6750322,1694524672,0},"ملعب رعاة البقر الصغار")end

-- ركن القراصنة
function Game5()
applyTicket({2003784722,1632001902,1593864809,1835102804,1768714096,25966},"ركن القراصنة")end

-- قواطع البيتزا
function Game6()
applyTicket({2053730340,1969447290,1852404852,1634754407,6386803,29811},"قواطع البيتزا")end

-- آلة المخلب
function Game7()
applyTicket({2037347360,1751343437,1600482921,1768711528,1761607800,26478},"آلة المخلب")end

-- قش طازج
function Game8()
applyTicket({2036426758,1717531136,1702326124,845116274,469762048,124},"قش طازج")end

-- روبوت آلي
function Game9()
applyStatue({1667592275,1114399081,1953849701,1634164601,1869770604,7630690,23},"روبوت آلي")end

-- مسابقة ثلاثية
function Game10()
applyStatue({1969317218,1952414068,1952541042,1852796008,1853190751,7497070,23},"مسابقة ثلاثية")end

-- آلة متطورة
function Game11()
applyStatue({1969317218,1734310260,1650748527,1600615013,1751343469,6647401,23},"آلة متطورة")end

-- جوال المريخ
function Game12()
applyStatue({1969317218,1935636852,1701011824,1918987615,1869766515,7497078,23},"جوال المريخ")end

-- ملعب القراصنة
function Game13()
applyStatue({1969317218,1667201396,1684826472,1601070450,1634888048,7562612,23},"ملعب القراصنة")end

-- التخييم الصيفي
function Game14()
applyStatue({1920298836,1349809001,1768649313,1952409454,1935762802,6648437,23},"التخييم الصيفي")end

-- تفاحة بالكراميل
function Game15()
applyStatue({1634885987,1097622893,1701605488,1920299871,1735289190,7565925,23},"تفاحة بالكراميل")end

-- منزل مقلوب
function Game16()
applyStatue({1769173109,1866753380,1867017847,1600484213,1735292258,2003790945,24},"منزل مقلوب")end

-- طائرة تجريبية
function Game17()
applyStatue({1969317218,1885305204,1701732716,1970239071,1601464423,859255158,24},"طائرة تجريبية")end

-- ملعب جزيرة الكنز
function Game18()
applyStatue({1768711496,1836403320,1918132080,1970495845,1934189938,1684955500,24},"ملعب جزيرة الكنز")end

-- ممارسة البيسبول
function Game19()
applyStatue({1836674127,1600350576,1702060354,1819042146,1767993972,1735289198,24},"ممارسة البيسبول")end

-- جولة الإقلاع
function Game20()
applyStatue({1667592275,1114399081,1953849701,2001952633,1348955753,1701732716,24},"جولة الإقلاع")end

-- كرة بلازما
function Game21()
applyStatue({1969317218,1700755828,1919250552,1852140905,1819303796,1634562913,24},"كرة بلازما")end

-- خبير صناعة الطائرة الورقية
function Game22()
applyTicket({1701860138,1818323299,1969317186,1264548212,1766548585,25972},"خبير صناعة الطائرة الورقية")end

-- طائرة تعمل بالكتلة الحيوية
function Game23()
applyTicket({1701860138,1818323299,1969317186,1650424180,1819307881,28257},"طائرة تعمل بالكتلة الحيوية")end

-- عنكبوت آلي
function Game24()
applyTicket({1701860140,1818323299,1969317186,1885305204,1869313377,6582120},"عنكبوت آلي")end

-- جرس
function Game25()
applyTicket({1634034198,1601795189,1735290695,0,0,0},"جرس")end

-- حامل الألعاب النارية
function Game26()
applyTicket({1634034214,1601795189,1701996902,1802661751,1886349427,0},"حامل الألعاب النارية")end

-- الماسة الكبرى
function Game27()
applyTicket({1634034204,1601795189,1835100516,6581871,0,0},"الماسة الكبرى")end

-- الأرجوحات
function Game28()
applyTicket({1634034216,1601795189,1852405619,1768382311,1717985650,101},"الأرجوحات")end

-- أرجوحة الأطفال
function Game29()
applyTicket({1634034206,1601795189,1869767011,1818588021,0,0},"أرجوحة الأطفال")end

-- ملعب الأطفال
function Game30()
applyTicket({1634034212,1601795189,2036427888,1970238055,3302510,0},"ملعب الأطفال")end

-- القرص الشمسي
function Game31()
applyTicket({1634034216,1601795189,1735549292,1970495333,1634296942,108},"القرص الشمسي")end

-- رمي السكاكين
function Game32()
applyTicket({1634034220,1601795189,1869768820,1735289207,1768844127,7562614},"رمي السكاكين")end

-- الأعوام الخمسة المذهلة
function Game33()
applyTicket({1634034212,1601795189,1834973493,1836412527,7630437,0},"الأعوام الخمسة المذهلة")end

-- أداء الركائز
function Game34()
applyTicket({1634034220,1601795189,1869767521,1937006946,1769239391,7566444},"أداء الركائز")end

-- متزلجون
function Game35()
applyTicket({1634034218,1601795189,1952803667,1919902309,1634488420,25955},"متزلجون")end

-- محاكي الطيران
function Game36()
applyTicket({1634034220,1601795189,1970104691,1869898092,1819303794,6647393},"محاكي الطيران")end

-- طائرة بجناحين أحدهما فوق الآخر
function Game37()
applyTicket({1634034214,1601795189,1684305264,1967809900,1919250541,0},"طائرة بجناحين أحدهما فوق الآخر")end

-- سفينة شراعية هوائية
function Game38()
applyTicket({1634034210,1601795189,1769565286,1752393582,28777,0},"سفينة شراعية هوائية")end

-- طائرة بخارية
function Game39()
applyTicket({1634034212,1601795189,1851878512,1953718117,7168357,0},"طائرة بخارية")end

-- رقصة التنين
function Game40()
applyTicket({1634034214,1601795189,1734439524,1683975791,1701015137,0},"رقصة التنين")end

-- الرسامون المرحون
function Game41()
applyTicket({1634034218,1601795189,1869377379,1735289202,1651860319,29541},"الرسامون المرحون")end

-- لعبة دوارة من الحلوى
function Game42()
applyTicket({1634034218,1601795189,1684955491,1633902457,1937076082,27749},"لعبة دوارة من الحلوى")end

-- حاو
function Game43()
applyTicket({1634034204,1601795189,1734833514,7497068,0,0},"حاو")end

-- لعبة مهرجان سباق الزوارق
function Game44()
applyTicket({1634034208,1601795189,1885956211,1869574239,108,0},"لعبة مهرجان سباق الزوارق")end

-- حارس مرمى منهك
function Game45()
applyTicket({1634034210,1601795189,1818324807,1885693291,29285,0},"حارس مرمى منهك")end

-- ساحة رقص زهرية
function Game46()
applyTicket({1634034210,1683974243,1701015137,1869375071,29295,0},"ساحة رقص زهرية")end

-- قبة سماوية مفتوحة
function Game47()
applyTicket({1634034214,1601795189,1634496371,2037604210,1835365491,0},"قبة سماوية مفتوحة")end

-- ستونهنج
function Game48()
applyTicket({1634034210,1601795189,1852798067,1852139621,25959,0},"ستونهنج")end

-- موجة فائقة
function Game49()
applyTicket({1920291602,1867538278,1728081007,1651733601,-388759431,111},"موجة فائقة")end

-- أرجوحة الأفيال الطائرة
function Game50()
applyTicket({1918984996,1702065519,1818582892,1634234469,7566446,29806},"أرجوحة الأفيال الطائرة")end

-- دوامة خيل عالمية تحت الماء
function Game51()
applyStatue({1667592275,1114399081,1953849701,1699962745,1918976865,1702065519,1132658796,25},"دوامة خيل عالمية تحت الماء")end

-- الصندوق المقدس
function Game52()
applyStatue({1667592275,1114399081,1953849701,1666146169,1970302836,1701331827,1711305843,26},"الصندوق المقدس")end

-- نصب تجريبي
function Game53()
applyStatue({1969317218,1700755828,1919250552,1852140905,1869438836,1701672302,1862300782,26},"نصب تجريبي")end

-- لافتة لصورة ذاتية للاحتفال
function Game54()
applyStatue({1667592275,1114399081,1953849701,1765957497,1684567154,1631746401,1919250030,28},"لافتة لصورة ذاتية للاحتفال")end

-- أصبحت لعبة township لعبتين
function Game55()
applyStatue({1667592275,1114399081,1953849701,1766023033,1631877492,1752391545,1936745829,28},"أصبحت لعبة township لعبتين")end

-- القلعة المتحركة
function Game56()
applyStatue({1667592275,1114399081,1953849701,1635213177,1852402540,1633902439,1701606515,28},"القلعة المتحركة")end

-- نموذج غواصة الأعماق
function Game57()
applyStatue({1667592275,1114399081,1953849701,1631739769,1937336436,1752195427,1702259012,28},"نموذج غواصة الأعماق")end

-- لعبة السيارات الاصطدامية
function Game58()
applyStatue({1667592275,1114399081,1953849701,1983995769,1950445428,1667330676,1852795252,28},"لعبة السيارات الاصطدامية")end

-- الثور الآلي
function Game59()
applyStatue({1667592275,1114399081,1953849701,1699569529,1851877475,1818321769,1701080914,1049231471,29},"الثور الآلي")end

-- ساحة الأبطال
function Game60()
applyStatue({1969317218,2002745716,1701736041,1885303666,1701011820,2037149535,1634300013,1049231460,29},"ساحة الأبطال")end

-- بطيخة عملاقة
function Game61()
applyStatue({1667592275,1114399081,1953849701,1766285177,1467248225,1919251553,1869374829,110,29},"بطيخة عملاقة")end

-- حلبة الهوكي
function Game62()
applyTicket({1668245540,1182360939,1684825449,1853190751,7497070,0},"حلبة الهوكي")end

-- بطارية داخلية
function Game63()
applyStatue({1667592275,1114399081,1953849701,1701863289,1952804978,1970040181,1852990819,97,29},"بطارية داخلية")end

-- العربة الملكية
function Game64()
applyStatue({1667592275,1114399081,1953849701,1699569529,1986357604,1631808617,1734963826,1040187493,29},"العربة الملكية")end

-- ملعب التدريب
function Game65()
applyStatue({1969317218,1415543156,1852399986,1197960809,1853190002,1819238244,1768975737,1040213089,30},"ملعب التدريب")end

-- قلعة مطاطية
function Game66()
applyStatue({1667592275,1114399081,1953849701,1850302329,1952541798,1701601889,1953718595,1677747564,30},"قلعة مطاطية")end

-- لافتة 5 أعوام معاً
function Game67()
applyTicket({1702442252,7565921,1969317186,1113553268,1701736033,114},"لافتة 5 أعوام معاً")end

-- المضمار المنزلق
function Game68()
applyTicket({1651458586,1768254579,1632790631,1845519715,7497070,110},"المضمار المنزلق")end

-- منحدر بلا نهاية
function Game69()
applyTicket({1869509408,1634689655,1918854258,1701736053,7471218,110},"منحدر بلا نهاية")end

-- الفائز المجنح
function Game70()
applyTicket({1634496550,1765893486,1634886514,1699902566,1685217655,0},"الفائز المجنح")end

-- الملعب
function Game71()
applyTicket({1634496532,1869768569,6581877,1869768558,2037540195,0},"الملعب")end

-- ملعب التنس
function Game72()
applyTicket({1852142604,7563630,7234916,1701999711,875585381,0},"ملعب التنس")end

-- ملعب كرة القدم
function Game73()
applyTicket({1869571600,1818321524,108,1701999711,875585381,0},"ملعب كرة القدم")end

-- ملعب البيسبول
function Game74()
applyTicket({1935761936,1818321509,108,3307569,875585381,0},"ملعب البيسبول")end

-- البالونات
function Game75()
applyTicket({1818321422,1936617327,1818848512,7602297,6648431,0},"البالونات")end

-- ترامبولين الأسد
function Game76()
applyTicket({1869179926,1819500398,1936024681,25856,0,0},"ترامبولين الأسد")end

-- حوض زهور الفاكهة
function Game77()
applyTicket({1852403742,1886413157,1801413996,1701210478,3670016,7566444},"حوض زهور الفاكهة")end

-- مصنع قوس قزح
function Game78()
applyTicket({1851876122,1918859620,1651403105,1761638255,1852795252,7566336},"مصنع قوس قزح")end

-- جولة عالمية
function Game79()
applyTicket({1869375268,1181507938,1751607660,1819303796,6647393,0},"جولة عالمية")end

-- نطاق التصويب على الفاكهة
function Game80()
applyTicket({1869116190,1852404847,1701994343,1702191987,6647296,0},"نطاق التصويب على الفاكهة")end

-- مهاجم قوي
function Game81()
applyTicket({1853449252,1836019041,1919251557,1936028255,6649187,7536741},"مهاجم قوي")end

-- لعبة بينبول
function Game82()
applyTicket({1852403738,1819042146,1818585183,1711306857,1768452969,26478},"لعبة بينبول")end

-- قلعة الحلوى
function Game83()
applyTicket({1851876130,1631811940,1701606515,1818585183,1761638505,26478},"قلعة الحلوى")end

-- مؤسس ألعاب الهاتف المحمول
function Game84()
applyTicket({1835099930,2037342821,1818585183,1761638505,1761607800,26478},"مؤسس ألعاب الهاتف المحمول")end

-- ترامبولين هلامي
function Game85()
applyTicket({1818585622,1866627436,1701015157,7496960,1761607800,26478},"ترامبولين هلامي")end

-- مستكشف قطبي
function Game86()
applyTicket({1819242526,1634562657,1918984046,1667855459,1761607680,26478},"مستكشف قطبي")end

-- الفنانون المتجولين
function Game87()
applyTicket({1869771812,1919252085,1834972005,1701405797,7102838,51},"الفنانون المتجولين")end

-- مسابقة الرقص
function Game88()
applyTicket({1851876388,1632462179,1852401763,1701338981,7891308,0},"مسابقة الرقص")end

-- سباق طائرات آلية
function Game89()
applyTicket({1869759518,1632789870,1885300067,1701732716,1852732672,29285},"سباق طائرات آلية")end

-- ميدان رماية نجوم
function Game90()
applyTicket({1818321444,1869108076,1852404847,1701338983,7891308,0},"ميدان رماية نجوم")end

-- قطار حلوى سريع
function Game91()
applyTicket({1851876138,1918138724,1601071457,1718777203,1701277289,29554},"قطار حلوى سريع")end

-- لعبة رمي الحلقات
function Game92()
applyTicket({1852404262,1835091815,1970495333,1852401266,1936876903,29440},"لعبة رمي الحلقات")end

-- سباق فرع العسل
function Game93()
applyTicket({1836412950,1852402544,1701011826,1936876800,1701707776,114},"سباق فرع العسل")end

-- لغز ضخم
function Game94()
applyTicket({1818576922,1348434025,1819966049,1660973925,1701734760,0},"لغز ضخم")end

-- آثار الأطباق الطائرة
function Game95()
applyTicket({1868985614,1702194243,7235840,3276800,0,0},"آثار الأطباق الطائرة")end

-- حديقة المغامرات
function Game96()
applyTicket({1667580958,1415541359,1214604658,1702065519,0,0},"حديقة المغامرات")end

-- ترامبولين فك القرش
function Game97()
applyTicket({1634235158,1935633266,1701079404,0,0,0},"ترامبولين فك القرش")end

-- موقف الدراجات
function Game98()
applyTicket({1668891418,1348429164,1768649313,26478,0,0},"موقف الدراجات")end

-- زلاقة قطار
function Game99()
applyTicket({1634882588,1866690153,1668637806,7499636,0,0},"زلاقة قطار")end

-- روديو الشاحنات الصغيرة
function Game100()
applyTicket({1667583256,1768841576,1631805283,7078002,0,0},"روديو الشاحنات الصغيرة")end

-- محطة الوادي
function Game101()
applyTicket({1734432540,1298099823,1953396079,7235937,0,0},"محطة الوادي")end

-- مبارزة الإبحار
function Game102()
applyTicket({1767994136,1735289196,1667330655,1920204901,1970495845,25970},"مبارزة الإبحار")end

-- لقاء بحري
function Game103()
applyTicket({1768444692,1766219632,7628903,0,0,0},"لقاء بحري")end

-- لعبة الموجة التاسعة
function Game104()
applyTicket({1768444690,2003784816,29285,0,0,0},"لعبة الموجة التاسعة")end

-- لعبة قوس قزح
function Game105()
applyTicket({1767993890,2003788398,1919508806,1818585183,956332137,0},"لعبة قوس قزح")end

-- الرماية
function Game106()
applyTicket({1668440348,2037540200,1853190751,7497070,0,0},"الرماية")end

-- لعبة القطار للأطفال
function Game107()
applyTicket({1684622102,1767985779,2036430700,0,0,0},"لعبة القطار للأطفال")end

-- درج لا نهاية له
function Game108()
applyTicket({1635021594,1601401449,1668571501,1962947432,0,0},"درج لا نهاية له")end

-- انصهار
function Game109()
applyTicket({1685025314,1699245925,1600350572,1852732786,1711305317,0},"انصهار")end

-- فزاعة ميكانيكية
function Game110()
applyTicket({1667591448,1920226152,1634563937,1761607790,0,0},"فزاعة ميكانيكية")end

-- متسابقو الشوارع الصغار
function Game111()
applyTicket({1684107808,1634889577,1918854499,1969451877,101,0},"متسابقو الشوارع الصغار")end

-- صنع القش
function Game112()
applyTicket({1634890782,1919906915,1684955487,2036426847,0,0},"صنع القش")end

-- حارس الكنز
function Game113()
applyTicket({1667591462,1634878568,1601072999,1768187245,1818326629,0},"حارس الكنز")end

-- مباراة الشطرنج
function Game114()
applyTicket({1701339928,1633645427,1768055154,6750307,0,0},"مباراة الشطرنج")end

-- نافورة عصير البرتقال
function Game115()
applyTicket({1769302556,1717527907,1953396079,7235937,0,0},"نافورة عصير البرتقال")end

-- عربة مع ثمار اليقطين
function Game116()
applyTicket({1734702612,1650553957,7562604,0,0,0},"عربة مع ثمار اليقطين")end

-- أكبر كعكة
function Game117()
applyTicket({1734692112,1801536353,7274597,0,0,0},"أكبر كعكة")end

-- خلاط عملاق
function Game118()
applyTicket({1701601818,1919247470,1768844127,1342203238,0,0},"خلاط عملاق")end

-- ركوب البحر الجامح
function Game119()
applyTicket({1768452906,1953775984,1952670066,1601073001,1634888048,25972},"ركوب البحر الجامح")end

-- سباق الأكياس
function Game120()
applyTicket({1734435362,1852732786,1600613993,1953718629,1627419237,0},"سباق الأكياس")end

-- لعبة الصدفة
function Game121()
applyTicket({1701344030,1634167916,1751082349,2020174949,0,0},"لعبة الصدفة")end

-- عرض السيارة الكلاسيكية
function Game122()
applyTicket({1918976798,2017812339,1769172848,1852795252,1694524672,0},"عرض السيارة الكلاسيكية")end

-- جولة الغرب الأمريكي
function Game123()
applyTicket({1919895580,1130325363,1970238049,7103859,1694524672,0},"جولة الغرب الأمريكي")end

-- شاحنة عملاقة
function Game124()
applyTicket({1734959650,1667330644,1601335156,1668506994,25973,0},"شاحنة عملاقة")end

-- القلعة النطاطة
function Game125()
applyTicket({1935754018,1600482420,1835102804,1768714096,1694524782,0},"القلعة النطاطة")end

-- أرجوحة النقانق
function Game126()
applyTicket({1953450006,1399287620,1735289207,1919906816,1667581049,29295},"أرجوحة النقانق")end

-- لعبة ركوب القارب
function Game127()
applyTicket({1935762710,1601332596,1684959088,7959040,-368251072,111},"لعبة ركوب القارب")end

-- ملعب كرة السلة
function Game128()
applyTicket({1935761948,1651795307,1600941153,3307569,875585381,0},"ملعب كرة السلة")end

-- كره فاكهة
function Game129()
applyTicket({1970431526,1866888297,1633842287,1801415788,1701210478,0},"كره فاكهة")end

-- ديسكو إلى الأبد
function Game130()
applyTicket({1936286756,1866887011,1702258034,1970102130,6515059,6649187},"ديسكو إلى الأبد")end

-- دوامة خيل طائرة
function Game131()
applyTicket({1918984988,1702065519,1701338988,7891308,1702326124,28261},"دوامة خيل طائرة")end

-- مغامرة مائية
function Game132()
applyTicket({1970364700,1918988385,1701338987,7891308,1701707877,114},"مغامرة مائية")end

-- حفلة آلات البانجو
function Game133()
applyTicket({1918985746,1937075565,1694524265,1936876800,1701707776,114},"حفلة آلات البانجو")end

-- العجلة الدوارة
function Game134()
applyTicket({1918984990,1702065519,1970429804,1919250030,1694528000,114},"العجلة الدوارة")end

-- الشاحنات العملاقة
function Game135()
applyTicket({1970426908,1601399651,1868784964,7499636,-388697088,111},"الشاحنات العملاقة")end

-- غارة القراصنة
function Game136()
applyTicket({1919504404,1181054049,7631471,1701999711,7340133,111},"غارة القراصنة")end

-- أرجوحة سماوية
function Game137()
applyTicket({1920291626,1735289190,1601401445,1835102804,1768714096,25966},"أرجوحة سماوية")end

-- لعبة الأحصنة الدوارة الأخطبوطية
function Game138()
applyTicket({1918976800,1702065519,1666146156,1970302836,1768685683,25966},"لعبة الأحصنة الدوارة الأخطبوطية")end

-- ترامبولين الطائرة الهليكوبتر
function Game139()
applyStatue({1667592275,1114399081,1953849701,1699241849,1868786028,1919251568,1835102804,1768714096,922772846,34},"ترامبولين الطائرة الهليكوبتر")end

-- لافتة انفجار قصاصات الورق الملون
function Game140()
applyTicket({1768440602,1702061422,1852727618,29285,0,0},"لافتة انفجار قصاصات الورق الملون")end

-- راية الطبخ الرائعة
function Game141()
applyTicket({1701860136,1818323299,1969317186,1113553268,1701736033,114},"راية الطبخ الرائعة")end

-- ============================================================
-- 🦁 حيوانات وحديقة (Animals)
-- ============================================================

-- مصنع المشروبات
function Animal1()
applyTicket({1869576740,1668244319,1767994475,1953718124,6648431,1},"مصنع المشروبات")end

-- حديقة الحيوانات المدللة
function Animal2()
applyTicket({1869576726,1852793695,1952670068,7630336,872444015,1},"حديقة الحيوانات المدللة")end

-- المطعم
function Animal3()
applyTicket({1869576732,1936028255,1920295284,7630433,872444015,1},"المطعم")end

-- متجر الهدايا
function Animal4()
applyTicket({1869576720,1869116255,1634009200,1752391533,872444015,1},"متجر الهدايا")end

-- متجر الآيس كريم
function Animal5()
applyTicket({1869576738,1701013855,1634038371,1752391533,872444015,1},"متجر الآيس كريم")end

-- حديقة الحيوانات
function Animal6()
applyTicket({1869576722,1667589215,1728082543,101,872444782,0},"حديقة الحيوانات")end

-- مطعم وجبات خفيفة
function Animal7()
applyTicket({1869576724,1952539999,7959141,114,878968932,1},"مطعم وجبات خفيفة")end

-- مقهى
function Animal8()
applyTicket({1869576722,1717658463,25958,114,878968932,1},"مقهى")end

-- المسرح رباعي الأبعاد
function Animal9()
applyTicket({1869576724,1852400479,6384997,114,878968932,1},"المسرح رباعي الأبعاد")end

-- جهاز عرض ثلاثي الأبعاد
function Animal10()
applyStatue({1969317218,1700755828,1919250552,1852140905,1919967092,1667590767,7499636,27},"جهاز عرض ثلاثي الأبعاد")end

-- الديك الناري
function Animal11()
applyStatue({1667592275,1114399081,1953849701,1768316793,1869768050,1702130543,1718485106,25},"الديك الناري")end

-- قط الحظ
function Animal12()
applyStatue({1667592275,1114399081,1953849701,1749245817,1600220777,1701732717,26987,26},"قط الحظ")end

-- الأسد الصيني
function Animal13()
applyStatue({1667592275,1114399081,1953849701,1749245817,1600220777,1734439524,16805487,26},"الأسد الصيني")end

-- كوي الرقص
function Animal14()
applyStatue({1667592275,1114399081,1953849701,1969905529,1852403821,1768316775,1627416691,26},"كوي الرقص")end

-- التنين الأحمر
function Animal15()
applyStatue({1667592275,1114399081,1953849701,1751342969,1600220777,1734439524,808611439,1040201521,30},"التنين الأحمر")end

-- الماموث المتجمد
function Animal16()
applyTicket({1835101468,1752461165,1952542047,3369059,0,0},"الماموث المتجمد")end

-- حوض سمك عملاق
function Animal17()
applyTicket({1970364694,1969844833,829841261,3307520,875585381,0},"حوض سمك عملاق")end

-- ترامبولين حديقة الحيوانات
function Animal18()
applyTicket({1818321434,1601073007,1953718627,25964,0,0},"ترامبولين حديقة الحيوانات")end

-- حضانة القرود
function Animal19()
applyTicket({1852796186,1937335659,1634496607,1593863022,0,0},"حضانة القرود")end

-- المينوتور
function Animal20()
applyTicket({1852402976,1969321071,1851875186,1852139875,-414711692,111},"المينوتور")end

-- حصان طروادة
function Animal21()
applyTicket({1869771814,1215193450,1702064751,1668178271,1953391977,7630848},"حصان طروادة")end

-- حديقة الحيوانات
function Animal22()
applyTicket({1869576722,1667589215,1728082543,101,872444782,0},"حديقة الحيوانات")end

-- حوض أسماك سعيد
function Animal23()
applyTicket({1885423644,1096776048,1918989681,7173481,1912602725,0},"حوض أسماك سعيد")end

-- حديقة الديناصورات
function Animal24()
applyTicket({1852392466,1632853871,1677747558,25959,0,0},"حديقة الديناصورات")end

-- سقسقة
function Animal25()
applyTicket({1768448786,1751346019,1694526313,7891308,0,0},"سقسقة")end

-- أفعوانية كلاكي
function Animal26()
applyTicket({1634890776,1751346793,1701536617,1912602734,0,0},"أفعوانية كلاكي")end

-- نزهة الذروة
function Animal27()
applyTicket({1734959634,1852008784,1845519209,0,0,0},"نزهة الذروة")end

-- كيتي روك
function Animal28()
applyTicket({1668248090,1952531307,1937075551,1795187561,1701210478,0},"كيتي روك")end

-- التي ريكس المتجمد
function Animal29()
applyTicket({1701013776,1852400735,1634467951,0,0,0},"التي ريكس المتجمد")end

-- بطل الوزن الثقيل
function Animal30()
applyTicket({1768257318,1819568231,1702127209,1970429810,1919250030,0},"بطل الوزن الثقيل")end

-- قوس قزح
function Animal31()
applyTicket({1767985686,2003788398,1751347777,0,0,0},"قوس قزح")end

-- حديقة الفئران الذهبية
function Animal32()
applyTicket({1952543260,1685217607,1784639077,7368053,1761607781,26478},"حديقة الفئران الذهبية")end

-- النحلة الطيارة
function Animal33()
applyTicket({1701860140,1818323299,1969317186,1113553268,1766876517,7630700},"النحلة الطيارة")end

-- طوطم المزارع
function Animal34()
applyTicket({1701860134,1818323299,1969317186,1415543156,1835365487,0},"طوطم المزارع")end

-- برج الحمام
function Animal35()
applyTicket({1701860140,1818323299,1969317186,1147107700,1667593839,6648943},"برج الحمام")end

-- بقرة الحلوى
function Animal36()
applyStatue({1969317218,1667201396,1701211759,1869182051,1601332590,7827299,23},"بقرة الحلوى")end

-- مقعد الصداقة
function Animal37()
applyStatue({1969317218,1717533044,1852139890,1852129892,1717528675,7954788,23},"مقعد الصداقة")end

-- رسام بدائي
function Animal38()
applyStatue({1969317218,1885305204,1768778098,1702259060,1953653087,7631721,23},"رسام بدائي")end

-- محمية الحياة البرية
function Animal39()
applyStatue({1969317218,1784641908,1818717813,1634951013,1970561902,7959137,23},"محمية الحياة البرية")end

-- معرض صديق للبيئة
function Animal40()
applyStatue({1819632467,1920300144,1752712549,1953063529,1601073001,7631457,23},"معرض صديق للبيئة")end

-- طاووس عاشق
function Animal41()
applyStatue({1701601622,1852404846,1701863269,1668244321,1852399467,1702260588,24},"طاووس عاشق")end

-- التخييم
function Animal42()
applyStatue({1667592275,1114399081,1953849701,1953718137,1702196321,1734963295,24},"التخييم")end

-- حوض سمك يوناني
function Animal43()
applyStatue({1635086657,1836411250,1634497601,1667855470,1668178271,1953391977,24},"حوض سمك يوناني")end

-- حوض سمك أطلنطي
function Animal44()
applyStatue({1969317218,1633646964,1851878516,1601399156,1635086689,1836411250,24},"حوض سمك أطلنطي")end

-- حوض سمك المدينة
function Animal45()
applyTicket({1701860140,1818323299,1969317186,1096776052,1918989681,7173481},"حوض سمك المدينة")end

-- ضفدع المال
function Animal46()
applyStatue({1667592275,1114399081,1953849701,1917214585,1951623023,1702196321,24},"ضفدع المال")end

-- سمكة ذهبية
function Animal47()
applyStatue({1667592275,1114399081,1953849701,1749245817,1600220777,1752394086,24},"سمكة ذهبية")end

-- لوحة الفيل
function Animal48()
applyTicket({1634034218,1601795189,1818323043,1818582891,1634234469,29806},"لوحة الفيل")end

-- لوحة الزرافة
function Animal49()
applyTicket({1634034216,1601795189,1818323043,1768578923,1717985650,101},"لوحة الزرافة")end

-- رشات سعيدة
function Animal50()
applyStatue({1667592275,1114399081,1953849701,1752653689,1717922913,1953396079,1601071457,1752394086,6778473,35},"رشات سعيدة")end

-- لوحة الحمار الوحشي
function Animal51()
applyTicket({1634034212,1601795189,1818323043,1702518635,6386274,0},"لوحة الحمار الوحشي")end

-- لوحة الأسد
function Animal52()
applyTicket({1634034210,1601795189,1818323043,1768709995,28271,0},"لوحة الأسد")end

-- زرافة ميكانيكية
function Animal53()
applyTicket({1634034212,1601795189,1634888042,1683973478,7105633,0},"زرافة ميكانيكية")end

-- مشتل أزهار على شكل خروف
function Animal54()
applyTicket({1634034216,1601795189,1919904870,1935633505,1885693288,115},"مشتل أزهار على شكل خروف")end

-- أفيال سعيدة
function Animal55()
applyTicket({1634034208,1601795189,1885695077,1953390952,115,0},"أفيال سعيدة")end

-- خروف محشو
function Animal56()
applyTicket({1634034210,1601795189,1937075312,1701335912,28773,0},"خروف محشو")end

-- طهاة سعداء
function Animal57()
applyTicket({1634034216,1601795189,1835626081,1601399905,1953718640,97},"طهاة سعداء")end

-- خبز الموز
function Animal58()
applyTicket({1634034212,1601795189,1735292266,1834968428,7040623,0},"خبز الموز")end

-- ديبلودوكس
function Animal59()
applyTicket({1634034206,1601795189,1869506916,1920295283,0,0},"ديبلودوكس")end

-- ويلات الفن
function Animal60()
applyStatue({1667592275,1114399081,1953849701,1631936377,1919251571,1935754591,1131570548,1801677160,905997925,34},"ويلات الفن")end

-- العمل الجماعي
function Animal61()
applyStatue({1667592275,1114399081,1953849701,1951620985,1702196321,1802661719,1701277524,1919248500,32},"العمل الجماعي")end

-- الراكب الأول
function Animal62()
applyTicket({1634034204,1601795189,1835884909,6845551,0,0},"الراكب الأول")end


-- ============================================================
-- ❤️ حب وفلانتين (Love)
-- ============================================================

-- حديقة حب
function Love1()
applyTicket({1987013652,1918986085,7234916,1701999711,875585381,0},"حديقة حب")end

-- لحن غرامي لا نهاية له
function Love2()
applyTicket({1987013650,2003784805,1761636965,1912602736,1694528000,114},"لحن غرامي لا نهاية له")end

-- طيار عاشق
function Love3()
applyTicket({1987013650,1852397413,1761637223,1912602736,1694528000,114},"طيار عاشق")end

-- جسر الحب
function Love4()
applyTicket({1987013654,1919049573,1701274729,3276800,875585381,0},"جسر الحب")end

-- عربة مع أزهار
function Love5()
applyTicket({1987013656,1818648421,1919252335,7209075,1275096693,114},"عربة مع أزهار")end

-- كيوبيد
function Love6()
applyStatue({1701601622,1852404846,1951620965,1702196321,1600548703,1768977763,100,25},"كيوبيد")end

-- هدية غير متوقعة
function Love7()
applyStatue({1701601622,1852404846,1869438821,1717530223,1601007474,1986094440,28261,26},"هدية غير متوقعة")end

-- عشاء رومانسي
function Love8()
applyStatue({1667592275,1114399081,1953849701,1867669369,1953390957,1766089577,1919250030,28},"عشاء رومانسي")end

-- موعد مزدوج
function Love9()
applyTicket({1801546788,1970235493,1650419059,1953784175,7367026,111},"موعد مزدوج")end

-- منطقة صورة الزوجين الرائعين
function Love10()
applyTicket({1869115432,1951625076,1600417377,1701601654,1852404846,101},"منطقة صورة الزوجين الرائعين")end

-- عشب حفل الزفاف
function Love11()
applyTicket({1684363038,1735289188,1147094067,1919902565,0,0},"عشب حفل الزفاف")end

-- نفق الغرام
function Love12()
applyTicket({1987005460,1853183077,7103854,1919252079,1700945779,6841198},"نفق الغرام")end

-- قفل الغرام
function Love13()
applyTicket({1987005456,1668238437,1818165355,1919252079,1700945779,6841198},"قفل الغرام")end

-- حديقة رومانسية
function Love14()
applyTicket({1634035750,1918137458,1985963365,1852140641,1701734772,0},"حديقة رومانسية")end

-- الكشك
function Love15()
applyTicket({1651663114,1845523055,0,0,0,0},"الكشك")end

-- وحيد قرن محشو
function Love16()
applyTicket({1970040876,1851091059,1919902569,1635147630,1953391980,6647401},"وحيد قرن محشو")end

-- حديقة الحب
function Love17()
applyTicket({1987013652,1918986085,7234916,1701999711,875585381,0},"حديقة الحب")end

-- طيار العاشق
function Love18()
applyTicket({1987013650,1852397413,1761637223,1912602736,1694528000,114},"طيار العاشق")end

-- لحن غرامي لا نهاية له
function Love19()
applyTicket({1987013650,2003784805,1761636965,1912602736,1694528000,114},"لحن غرامي لا نهاية له")end

-- قلب على شكل ياقوتة
function Love20()
applyStatue({1701601622,1852404846,1768185701,1852796257,1701338980,7631457,23},"قلب على شكل ياقوتة")end

-- الحب الخالد
function Love21()
applyTicket({1818318380,1769238117,1751082350,1953653093,1632136777,7562350},"الحب الخالد")end

-- متزوجان حديثا
function Love22()
applyTicket({1818318378,1769238117,1784636782,1299477365,1769108065,25701},"متزوجان حديثا")end

-- مشتل أزهار على شكل قلب
function Love23()
applyTicket({1818318374,1769238117,1717527918,1702326124,1684365938,7562496},"مشتل أزهار على شكل قلب")end

-- حمام عاشق
function Love24()
applyTicket({1818318380,1769238117,1885300078,1868916585,1818194798,6649455},"حمام عاشق")end

-- النقل
function Love25()
applyTicket({1818318378,1769238117,1818191214,1919252079,1633902451,29810},"النقل")end

-- تمثال رسول الحب
function Love26()
applyTicket({1818318374,1769238117,1885300078,1937011567,1885693288,29696},"تمثال رسول الحب")end

-- موعد رومانسي
function Love27()
applyTicket({1818318372,1769238117,1935631726,1852142181,6644833,29696},"موعد رومانسي")end

-- دمية دب
function Love28()
applyTicket({1818318378,1769238117,1415538030,2036622437,1634034271,12914},"دمية دب")end

-- المفتاح إلى القلب
function Love29()
applyTicket({1818318362,1769238117,1801413998,31077,1234898304,114},"المفتاح إلى القلب")end

-- قوس الحب
function Love30()
applyTicket({1818318372,1769238117,1818191214,1634039407,6841202,30464},"قوس الحب")end

-- القطة المحبوبة
function Love31()
applyTicket({1818318374,1769238117,1885300078,1752397164,1952539487,30464},"القطة المحبوبة")end

-- دمية أرنب
function Love32()
applyTicket({1818318366,1769238117,1113548142,2037280373,1920090368,30575},"دمية أرنب")end

-- سهم كيوبيد
function Love33()
applyTicket({1818318378,1769238117,1130325358,1684631669,1920090483,30575},"سهم كيوبيد")end

-- مقعد المحبين
function Love34()
applyTicket({1818318380,1769238117,1818191214,1919252079,1700945779,6841198},"مقعد المحبين")end

-- تمثال عاطفي
function Love35()
applyTicket({1818318364,1769238117,1667196270,7566433,1953391980,6647401},"تمثال عاطفي")end

-- شجيرة مشدبة
function Love36()
applyTicket({1818318370,1769238117,1415538030,1634300015,1224767858,114},"شجيرة مشدبة")end

-- دب الدمية
function Love37()
applyTicket({1818318376,1769238117,1415538030,2036622437,1634034271,114},"دب الدمية")end

-- مشتل الأزهار مع الملائكة
function Love38()
applyTicket({1818318374,1769238117,1180657006,1702326124,1684365938,0},"مشتل الأزهار مع الملائكة")end

-- أرجوحة دوارة
function Love39()
applyTicket({1818318380,1769238117,1398760814,1735289207,1987013727,7565925},"أرجوحة دوارة")end

-- الكشك الرومانسي
function Love40()
applyStatue({1701601622,1852404846,1632067429,1868719482,1987013727,7565925,23},"الكشك الرومانسي")end

-- منحوتة الحب الأبدي
function Love41()
applyStatue({1701601622,1852404846,1701338981,1601466977,1701078384,1818326131,24},"منحوتة الحب الأبدي")end

-- ============================================================
-- 🍃 زينة الطبيعة (Nature)
-- ============================================================

-- الينابيع الساخنة 2
function Nature1()
applyTicket({1953458208,1769107539,1834968942,1751348321,1761607731,26478},"الينابيع الساخنة 2")end

-- قلعة
function Nature2()
applyTicket({1935762188,6646900,3241567,29696,-368923392,111},"قلعة")end

-- بيت لبلاب
function Nature3()
applyTicket({1970227224,1197434227,1701081697,110,-388697088,111},"بيت لبلاب")end

-- بيت الشاي
function Nature4()
applyTicket({1634038800,1937076072,2004025445,0,0,0},"بيت الشاي")end

-- لعبة الشلال
function Nature5()
applyStatue({1702125943,1818322546,1869438828,1635020405,1935634025,1768321653,1919248238,115,29},"لعبة الشلال")end

-- بحيرة الطبيعة الأم
function Nature6()
applyTicket({1852796962,1869438820,1919248500,1918985567,26740,0},"بحيرة الطبيعة الأم")end

-- عرض توبياري
function Nature7()
applyTicket({1886352422,2037539177,1836016479,1769235824,1852795252,7566336},"عرض توبياري")end

-- عرض فني
function Nature8()
applyTicket({1818322710,2037540204,1953653087,1852732672,1711305317,7536741},"عرض فني")end

-- زيارة الأرانب
function Nature9()
applyTicket({1852793634,1952670068,1601138522,1668506994,25973,7536741},"زيارة الأرانب")end

-- كتاب الطبيعة
function Nature10()
applyTicket({1869570590,1701991531,1969905509,1701603182,1769238016,115},"كتاب الطبيعة")end

-- مستوطنة بدائية
function Nature11()
applyTicket({1818850844,1701273964,1853188703,6646887,1752393067,28783},"مستوطنة بدائية")end

-- متعة نار المعسكر
function Nature12()
applyTicket({1835098912,1735289200,1818851167,1936029540,1702297716,29811},"متعة نار المعسكر")end

-- نبع
function Nature13()
applyTicket({1852796936,1717502052,1702326124,845116274,0,0},"نبع")end

-- بئر
function Nature14()
applyTicket({1818588936,1818820716,1694498924,845116274,0,0},"بئر")end

-- بستان الخيزران
function Nature15()
applyTicket({1835098650,1601138530,1852732786,1912631909,1694528000,114},"بستان الخيزران")end

-- منزل البحار
function Nature16()
applyTicket({1801546780,1970235493,1751082355,6647151,7367026,111},"منزل البحار")end

-- عش العائلة
function Nature17()
applyTicket({1869902616,1935633266,1970561396,6619237,7367026,111},"عش العائلة")end

-- بئر نفط
function Nature18()
applyTicket({1818849044,1920099652,7037801,1935605874,6644841,0},"بئر نفط")end

-- فندق الواحة
function Nature19()
applyTicket({1818325010,1953450093,1694526565,1935634021,6644841,0},"فندق الواحة")end

-- متجر الشعيرية
function Nature20()
applyTicket({1869573654,1600482404,1886349427,6384640,1929404786,0},"متجر الشعيرية")end

-- بركة البجع
function Nature21()
applyTicket({1852796946,1635210084,1744860014,29813,0,0},"بركة البجع")end

-- بستان التفاح
function Nature22()
applyTicket({1886404888,1197434220,1701081697,1970339950,1912602725,0},"بستان التفاح")end

-- خيمة ملونة
function Nature23()
applyTicket({1634877718,1600350562,1953391956,0,0,0},"خيمة ملونة")end

-- جناح الزهور
function Nature24()
applyTicket({1667580960,1180660335,1702326124,1869108082,112,0},"جناح الزهور")end

-- الشلال
function Nature25()
applyTicket({1634554652,1633119340,1718773108,7105633,0,0},"الشلال")end

-- واحة حضرية
function Nature26()
applyTicket({1634486042,1852403821,1631805287,1845522541,0,0},"واحة حضرية")end

-- كشك النزهة
function Nature27()
applyTicket({1667854348,6515054,0,0,0,0},"كشك النزهة")end

-- بحيرة زهور الزئبق الحمراء
function Nature28()
applyTicket({1684369946,1768712524,1867543397,1962959982,0,0},"بحيرة زهور الزئبق الحمراء")end

-- جسر حبال
function Nature29()
applyTicket({1668178204,1953391977,1769103967,6645604,0,0},"جسر حبال")end

-- شرفة الشلال
function Nature30()
applyTicket({1717650204,1633116005,1718773108,7105633,0,0},"شرفة الشلال")end

-- شرفة مزرعة العنب
function Nature31()
applyTicket({1717650202,1767268197,1635345774,1761633394,0,0},"شرفة مزرعة العنب")end

-- ملاذ الكهف
function Nature32()
applyTicket({1986085652,1817206629,6644577,25959,7499636,111},"ملاذ الكهف")end

-- مزرعة العنب
function Nature33()
applyTicket({1935754524,1450337652,2036690537,6582881,-368251072,111},"مزرعة العنب")end

-- عيد الربيع
function Nature34()
applyTicket({1935762714,1383228788,1868718697,1694528366,1751347809,7565925},"عيد الربيع")end

-- خيمة الجنة
function Nature35()
applyTicket({1935765270,1700754281,1953528167,1634533376,-368868608,111},"خيمة الجنة")end

-- الحدائق المعلقة
function Nature36()
applyTicket({1918986012,1936614756,1634885983,6515042,1702196321,0},"الحدائق المعلقة")end

-- بركة المتنزه
function Nature37()
applyTicket({1936028186,1702261349,1597143089,838873462,-419430400,111},"بركة المتنزه")end

-- المتنزه الصغير
function Nature38()
applyTicket({1936028186,1702261349,1597143090,838873462,-419430400,111},"المتنزه الصغير")end

-- المتنزه الكبير
function Nature39()
applyTicket({1936028186,1702261349,1597208627,838873462,-419430400,111},"المتنزه الكبير")end

-- بئر الأمنيات
function Nature40()
applyTicket({1936291606,1735289192,1819043159,1701338880,7891308,28261},"بئر الأمنيات")end

-- شاحنة الزهور
function Nature41()
applyTicket({1970238238,1919248500,1869375086,1936876919,1701707776,114},"شاحنة الزهور")end

-- بحيرة الغموض
function Nature42()
applyTicket({1918979356,1952409715,1935762802,6648437,6386803,29811},"بحيرة الغموض")end

-- توبياري شاعري
function Nature43()
applyStatue({1701601622,1852404846,1869897573,1918986608,1701339001,1937011297,24},"توبياري شاعري")end

-- المناطق الاستوائية المريحة
function Nature44()
applyStatue({1868787555,1098151278,1751346546,1601333601,1735292258,2003790945,24},"المناطق الاستوائية المريحة")end

-- بيت العصر الحجري
function Nature45()
applyStatue({1969317218,1885305204,1768449394,1919906931,1751081833,1702065519,24},"بيت العصر الحجري")end

-- نبات آكل للحوم
function Nature46()
applyTicket({1634034216,1601795189,1970169206,1818648435,1634890873,112},"نبات آكل للحوم")end

-- هرم من المشروبات
function Nature47()
applyTicket({1634034216,1601795189,1634892144,1600416109,1718185579,101},"هرم من المشروبات")end

-- تشكيلة فواكه
function Nature48()
applyTicket({1634034206,1717528675,1953068402,2020175199,0,0},"تشكيلة فواكه")end

-- جبل الحلوى
function Nature49()
applyTicket({1634034210,1601795189,1701148531,1768447860,27756,0},"جبل الحلوى")end

-- منزل الحلوى
function Nature50()
applyTicket({1634034212,1601795189,1684955491,1869111161,6648693,0},"منزل الحلوى")end

-- جزيرة المرح الصيفي
function Nature51()
applyTicket({1634034212,1601795189,2054316404,1952411233,6645106,0},"جزيرة المرح الصيفي")end

-- بوابة المدينة المفقودة
function Nature52()
applyTicket({1634034216,1601795189,1768124001,1601465957,1836413540,115},"بوابة المدينة المفقودة")end

-- موقع المدينة القديمة
function Nature53()
applyTicket({1634034214,1601795189,1768124001,1601465957,1853321076,0},"موقع المدينة القديمة")end

-- كهف الغابة
function Nature54()
applyTicket({1634034218,1601795189,1702256995,1601071455,1735292266,25964},"كهف الغابة")end

-- جذع عيش الغراب
function Nature55()
applyTicket({1634034214,1601795189,1953718629,1935635045,1886221684,0},"جذع عيش الغراب")end

-- الوحش الثلجي
function Nature56()
applyTicket({1634034198,1601795189,1769235833,0,0,0},"الوحش الثلجي")end

-- الاتصال الأول
function Nature57()
applyTicket({1634034196,1601795189,7300725,0,0,0},"الاتصال الأول")end


-- ============================================================
-- 🏙️ زينة المدينة (City)
-- ============================================================

-- القرية الأوليمبية
function City1()
applyTicket({2037149482,1667854445,1819044182,1600481121,1852732786,29285},"القرية الأوليمبية")end

-- منصة الكاميرا
function City2()
applyStatue({1935762803,1766026863,1633903982,1634887021,1852400479,6384997,23},"منصة الكاميرا")end

-- برج فلكي
function City3()
applyStatue({1969317218,1633646964,1869771891,1701670766,1869897586,7497079,23},"برج فلكي")end

-- برج المعرفة
function City4()
applyStatue({1969317218,1700755828,1919250552,1852140905,1852530548,1701607279,1952802660,1919252335,32},"برج المعرفة")end

-- برج المياه
function City5()
applyStatue({1667592275,1114399081,1953849701,1633116025,1416783220,1919252335,24},"برج المياه")end

-- حانة الكمثرى
function City6()
applyStatue({1667592275,1114399081,1953849701,1917214585,1265920373,1802727273,24},"حانة الكمثرى")end

-- قريباً
function City7()
applyStatue({1634625862,2003128940,1600418401,1685217639,1766026853,1634559342,24},"قريباً")end

-- منزل منسق الأزهار
function City8()
applyTicket({1634034212,1601795189,2003790950,1869116005,6648693,0},"منزل منسق الأزهار")end

-- منزل راق
function City9()
applyTicket({1634034214,1601795189,1970828652,1751087474,1702065519,0},"منزل راق")end

-- عربة الخضراوات
function City10()
applyTicket({1634034214,1601795189,1701147239,1869768558,2037540195,0},"عربة الخضراوات")end

-- مقهى 2
function City11()
applyTicket({1634034202,1601795189,1869373811,28271,0,0},"مقهى 2")end

-- منطقة الفنون
function City12()
applyTicket({1634034218,1601795189,1769239137,1902081139,1953653109,29285},"منطقة الفنون")end

-- شارع الحلوى
function City13()
applyTicket({1634034214,1601795189,1953787747,1600481121,1852993384,0},"شارع الحلوى")end

-- قاطع صور الأصدقاء الخارقون
function City14()
applyTicket({1634034218,1601795189,1701868883,1919248498,1635013487,25710},"قاطع صور الأصدقاء الخارقون")end

-- متجر التذكارات
function City15()
applyTicket({1634034216,1601795189,1987407731,1919512165,1869116255,112},"متجر التذكارات")end

-- الحي الصيني
function City16()
applyTicket({1634034210,1601795189,1852401763,1869897569,28279,0},"الحي الصيني")end

-- مطعم بيتزا في الهواء الطلق
function City17()
applyTicket({1634034218,1601795189,2054842736,1634300517,1935765599,24948},"مطعم بيتزا في الهواء الطلق")end

-- مقهى المكوك
function City18()
applyTicket({1634034216,1601795189,1667330163,1752391525,1819571317,101},"مقهى المكوك")end

-- متحف أطلانتس
function City19()
applyTicket({1937075486,1601008997,1634497633,1936290926,1769238016,115},"متحف أطلانتس")end

-- سينما خارجية
function City20()
applyTicket({1920234282,1131701605,1835363945,1633902433,1752393067,28783},"سينما خارجية")end

-- متعة التسوق
function City21()
applyTicket({1918985000,1667322484,1818386277,1718313825,1633970546,121},"متعة التسوق")end

-- مقهى القراصنة
function City22()
applyTicket({1970426918,1601399651,1634888016,1765959028,1869771891,25856},"مقهى القراصنة")end

-- منشأة إنسومانيا
function City23()
applyTicket({1936607530,1819042164,1869182049,1850302318,1852665715,24937},"منشأة إنسومانيا")end

-- توربينات الرياح
function City24()
applyTicket({1952806414,1801550194,1734304768,1700950629,1929404786,0},"توربينات الرياح")end

-- ورشة الكاتب
function City25()
applyTicket({1919120168,1869901929,1836411250,1684368735,1635149161,108},"ورشة الكاتب")end

-- ورشة النحات
function City26()
applyTicket({1969451808,1869901932,1851875186,1852139875,-368902028,111},"ورشة النحات")end

-- مولف ضخم
function City27()
applyTicket({1937067286,1398760297,1701733731,0,-388697088,111},"مولف ضخم")end

-- عربة نقانق
function City28()
applyTicket({1969320740,1701273971,1936028255,1634889588,7499636,111},"عربة نقانق")end

-- الإبرة الفضائية
function City29()
applyTicket({1634759452,1701733731,1701602405,3241567,0,0},"الإبرة الفضائية")end

-- بطولة الجرافيتي
function City30()
applyStatue({1969317218,1734310260,1717985650,1600746601,1886220131,1953068133,7237481,27},"بطولة الجرافيتي")end

-- بيت التوابل
function City31()
applyStatue({1851877492,1768387435,1735289206,1734702687,1650553957,1867015532,6648693,27},"بيت التوابل")end

-- ساحة الحصاد الكبيرة
function City32()
applyStatue({1851877492,1768387435,1735289206,1734702687,1650553957,1817208172,6644577,27},"ساحة الحصاد الكبيرة")end

-- لوحة الغوص
function City33()
applyStatue({1969317218,1147107700,1852405353,2003784807,1868526181,1886222700,6578537,27},"لوحة الغوص")end

-- حشد متحمس
function City34()
applyTicket({1920291604,1698979686,7499619,1768714096,1694524782,0},"حشد متحمس")end

-- مسرح مفتوح
function City35()
applyTicket({1920291602,1632853862,25964,1768714096,1694524782,0},"مسرح مفتوح")end

-- موقع التخييم
function City36()
applyStatue({1667592275,1114399081,1953849701,1866620793,1919510126,1835090789,1701052528,25},"موقع التخييم")end

-- مدينة راعي البقر
function City37()
applyStatue({1667592275,1114399081,1953849701,1750359929,1214604658,1702065519,115,25},"مدينة راعي البقر")end

-- كوخ صانع الطعوم
function City38()
applyStatue({1969317218,1935636852,1869111653,1600484213,1868784996,1769234802,28271,26},"كوخ صانع الطعوم")end

-- عربة بيتزا ساخنة
function City39()
applyStatue({1667592275,1114399081,1953849701,1918132089,1131111285,1768975713,50358126,26},"عربة بيتزا ساخنة")end

-- مقهى آيس كريم
function City40()
applyStatue({1667592275,1114399081,1953849701,1667850105,1919115109,1601003877,1701208419,28},"مقهى آيس كريم")end

-- أصدقاء متمرسون في الطيران
function City41()
applyStatue({1667592275,1114399081,1953849701,1968332665,2036430702,1886546241,1701732716,28},"أصدقاء متمرسون في الطيران")end

-- مركز أبحاث
function City42()
applyStatue({1969317218,1700755828,1919250552,1852140905,1634492276,1634889570,2037542772,28},"مركز أبحاث")end

-- حصاد عملاق
function City43()
applyStatue({1851877492,1768387435,1735289206,1734702687,1650553957,1631741292,1952803699,28},"حصاد عملاق")end

-- الحانة
function City44()
applyStatue({1667592275,1114399081,1953849701,1699569529,1986357604,1632922729,1852990838,1049231457,29},"الحانة")end

-- البرج الفلكي
function City45()
applyStatue({1667592275,1114399081,1953849701,1933664121,1819243124,1919248239,1702326100,1040187506,29},"البرج الفلكي")end

-- طاحونة الشوكولاتة
function City46()
applyTicket({1869103914,1634496355,1632003444,1919906915,1667581049,29295},"طاحونة الشوكولاتة")end

-- منطقة التخفيضات
function City47()
applyTicket({1818317588,1970361189,6648417,1919906816,1667581049,29295},"منطقة التخفيضات")end

-- وضع علامة
function City48()
applyTicket({1634493960,103,0,0,0,0},"وضع علامة")end

-- المسرح رباعي الأبعاد
function City49()
applyTicket({1869576724,1852400479,6384997,111,878968932,0},"المسرح رباعي الأبعاد")end

-- قاعة المشاهير
function City50()
applyTicket({1818314770,1632001900,25965,1818321529,7471212,111},"قاعة المشاهير")end

-- مقهى 1
function City51()
applyTicket({1869576722,1717658463,25958,111,878968932,0},"مقهى 1")end

-- متجر الآيس كريم
function City52()
applyTicket({1869576738,1701013855,1634038371,1752391533,872444015,0},"متجر الآيس كريم")end

-- متجر الهدايا
function City53()
applyTicket({1869576720,1869116255,1634009200,1752391533,872444015,0},"متجر الهدايا")end

-- المطعم 1
function City54()
applyTicket({1869576732,1936028255,1920295284,7630433,872444015,0},"المطعم 1")end

-- مصنع المشروبات
function City55()
applyTicket({1869576740,1668244319,1767994475,1953718124,6648431,0},"مصنع المشروبات")end

-- المطعم 2
function City56()
applyTicket({1801546258,1851880033,1694523748,0,0,0},"المطعم 2")end

-- مركز الفنون
function City57()
applyTicket({1852133406,1215064419,1702065519,1953653087,0,0},"مركز الفنون")end

-- مركز المملكة
function City58()
applyTicket({1852394266,1836016743,1953391939,1761633650,1761607800,26478},"مركز المملكة")end

-- كشك الهاتف
function City59()
applyTicket({1869115410,1650419054,1912633455,7209075,0,0},"كشك الهاتف")end

-- برنامج طهي
function City60()
applyTicket({1869571614,1869116260,1969381239,1919248242,0,0},"برنامج طهي")end

-- حديقة المصغرات
function City61()
applyTicket({1852394776,2003784809,1768452974,1912602736,1694528000,114},"حديقة المصغرات")end

-- مجموعة الأفلام الغربية
function City62()
applyTicket({1818851102,1936029540,1768120180,1634559342,0,0},"مجموعة الأفلام الغربية")end

-- مقهى صيفي
function City63()
applyTicket({1836405526,1601332589,1701208387,0,0,0},"مقهى صيفي")end

-- منجم ذهب
function City64()
applyTicket({1819232024,1766088548,1919248231,115,0,0},"منجم ذهب")end

-- محطة الاتصالات
function City65()
applyTicket({1852785438,1952671086,1635013471,1852795252,1912602624,0},"محطة الاتصالات")end

-- متجر الكتب
function City66()
applyTicket({1869562388,1951620971,6648431,116,0,0},"متجر الكتب")end

-- متجر زهور
function City67()
applyTicket({1869366808,1601332599,1919906899,101,0,0},"متجر زهور")end

-- مسار الحبال
function City68()
applyTicket({1667580956,1381986927,1885696111,7041633,0,0},"مسار الحبال")end

-- السوق المتنقل
function City69()
applyTicket({1651461402,1600482409,1802658125,1845523557,0,0},"السوق المتنقل")end

-- متجر منتجات عضوية
function City70()
applyTicket({1735544600,1667853921,1869108063,1851850864,0,0},"متجر منتجات عضوية")end

-- استديو تغيير المظهر
function City71()
applyTicket({1818317600,1601073007,2036429383,1937076045,7471205,111},"استديو تغيير المظهر")end

-- منزل المأمور
function City72()
applyTicket({1634488342,1147104110,1919902565,0,0,0},"منزل المأمور")end

-- سفاري حضرية
function City73()
applyTicket({1634488340,1247767406,7365989,1667329399,1701734760,0},"سفاري حضرية")end

-- عرض الخضراوات
function City74()
applyTicket({1634297644,1700164718,1635018087,1936026722,1936028255,6649187},"عرض الخضراوات")end

-- مقهى الروبوت
function City75()
applyTicket({1651470882,1717658479,1633902437,1752393067,1929408623,29440},"مقهى الروبوت")end

-- قاعدة إطلاق المركبات الفضائية
function City76()
applyTicket({1634751254,1867670883,1952803683,0,0,0},"قاعدة إطلاق المركبات الفضائية")end

-- الحياة على الطريق
function City77()
applyTicket({1634890794,1768711542,1918134126,1600873333,1668506994,25973},"الحياة على الطريق")end

-- رادار الأطباق الطائرة
function City78()
applyTicket({1684107786,1644196449,0,0,0,0},"رادار الأطباق الطائرة")end

-- متجر ورق البردي
function City79()
applyTicket({1634886444,1836282982,1868000865,1852402546,1734696807,7630969},"متجر ورق البردي")end

-- طقم الفيلم
function City80()
applyTicket({1634038572,1433300851,1951625062,1869177973,1852400479,6384997},"طقم الفيلم")end

-- مدرج مكشوف
function City81()
applyTicket({1701344296,1919251553,1868915791,1851875182,1852139875,7602292},"مدرج مكشوف")end

-- ملعب الرجبي
function City82()
applyTicket({1735750170,1935636834,1768186228,28021,0,0},"ملعب الرجبي")end

-- برج الحراسة
function City83()
applyTicket({1718184986,1635084133,1751082098,29813,0,0},"برج الحراسة")end

-- عازف الأرجن
function City84()
applyTicket({1735552790,1834970721,1667855221,0,0,0},"عازف الأرجن")end

-- مطعم على الطريق
function City85()
applyTicket({1717658390,1701994341,1702191987,0,0,0},"مطعم على الطريق")end

-- سوق المزارعين
function City86()
applyTicket({1767990806,1701994354,1702191987,0,0,0},"سوق المزارعين")end

-- عرض متنقل
function City87()
applyTicket({1919501084,1601402211,1886216515,6778473,1694524672,0},"عرض متنقل")end

-- معرض الأزياء
function City88()
applyTicket({1935754784,1852795240,1970225759,1970366836,1912602725,0,-387072416,111},"معرض الأزياء")end

-- قرن الوفرة
function City89()
applyTicket({1919895576,1632132974,1936029298,1970339956,1912602725,0},"قرن الوفرة")end

-- بلازا باريسية
function City90()
applyTicket({1918980120,1398764393,1701147252,116,-388697088,111},"بلازا باريسية")end

-- منزل المصريين
function City91()
applyTicket({1970227226,1732601203,1769238649,1929408097,7368552,6357102},"منزل المصريين")end

-- متجر الموسيقى
function City92()
applyTicket({1936607524,1836413556,1467248229,1936421487,7368552,6357102},"متجر الموسيقى")end

-- جرامافون دوار
function City93()
applyTicket({1937067292,1631806313,1937076082,6646885,-368902043,111},"جرامافون دوار")end

-- مطبخ ميداني
function City94()
applyTicket({1953065754,1852139619,1634496607,1845521262,1711305317,7536741},"مطبخ ميداني")end

-- منطقة موسيقية
function City95()
applyTicket({1937075492,1968268137,1702130273,1970102130,6515059,7536741},"منطقة موسيقية")end

-- مدرسة البستاني
function City96()
applyTicket({1970239774,1734305646,1701081697,1936876910,3670016,7566444},"مدرسة البستاني")end

-- بيت بحوض سمك
function City97()
applyTicket({1970364714,1969844833,1970227309,1717527923,1768452969,26478},"بيت بحوض سمك")end

-- قرية الفاكهة
function City98()
applyTicket({1970431518,1632662633,1801415538,1701210478,1752392960,28783},"قرية الفاكهة")end

-- تجارب مجموعة الطيران
function City99()
applyTicket({1952803354,1801675120,1634496607,1694524782,1752392960,28783},"تجارب مجموعة الطيران")end

-- بيت المعكرونة
function City100()
applyTicket({1936020000,1634889588,1114795892,1684826485,3276850,3748974},"بيت المعكرونة")end

-- حي الديسكو
function City101()
applyTicket({1936278564,1698983779,1634889571,1852795252,3690579,7566444},"حي الديسكو")end

-- متحف الأفلام
function City102()
applyTicket({1987013910,1968006505,1836410227,1953652992,-388697088,111},"متحف الأفلام")end

-- الأضواء الكاميرا الحركة
function City103()
applyTicket({1987013914,1867343209,1701672302,1694528622,1852732672,29285},"الأضواء الكاميرا الحركة")end

-- دراجة القهوة
function City104()
applyStatue({1667592275,1114399081,1953849701,1869438841,1701603682,1718575967,1600480614,1668641396,854589547,33},"دراجة القهوة")end

-- العرش القديم
function City105()
applyTicket({1919448102,1214606959,1600941153,1768187245,1818326629,0},"العرش القديم")end


-- ============================================================
-- ⚓ ساحل وبحر (Beach)
-- ============================================================

-- ممر الانتظار
function Beach1()
applyTicket({1634890762,805333859,7234816,1701999711,875585381,0},"ممر الانتظار")end

-- مقاعد في الشمس
function Beach2()
applyTicket({1634496532,1597205358,7235942,1701997003,875585381,0},"مقاعد في الشمس")end

-- مقاعد في الشمس 2
function Beach3()
applyTicket({1634496532,1597074286,7235942,3307569,875585381,0},"مقاعد في الشمس 2")end

-- قارب على الشاطئ
function Beach4()
applyTicket({1634689556,1596993652,7235942,3307569,875585381,0},"قارب على الشاطئ")end

-- حانة تيكي
function Beach5()
applyTicket({1918984718,1852401247,1768316672,3276910,875585381,0},"حانة تيكي")end

-- حمام سباحة
function Beach6()
applyTicket({1869574152,1952383084,1835365487,3276800,875585381,0},"حمام سباحة")end

-- برج المراقبة
function Beach7()
applyTicket({1869573146,1953853291,1768910943,29806,-416496384,111},"برج المراقبة")end

-- مقهى مشروبات شاطئي
function Beach8()
applyTicket({1802064912,1631739753,1952514162,1694524789,7340133,111},"مقهى مشروبات شاطئي")end

-- أرجوحة زهرية
function Beach9()
applyTicket({1853178400,1869373799,1634230135,1668246893,7340139,111},"أرجوحة زهرية")end

-- الكرة الطائرة الشاطئية
function Beach10()
applyTicket({1634026016,1985964131,1701604463,1818321529,7471212,0},"الكرة الطائرة الشاطئية")end

-- طاهي السلطعون
function Beach11()
applyTicket({1634878226,1866686306,1912630127,0,0,0},"طاهي السلطعون")end

-- كوخ شاطئي
function Beach12()
applyTicket({1634486044,1852403821,1867013991,6648693,0,0},"كوخ شاطئي")end

-- الواحة
function Beach13()
applyTicket({1634885912,1600350562,1769169263,1852113011,0,0},"الواحة")end

-- جادة قصيرة
function Beach14()
applyTicket({1918988306,828322411,12664,1701999711,875585381,0},"جادة قصيرة")end

-- جادة طويلة
function Beach15()
applyTicket({1918988306,828322155,12920,3307569,875585381,0},"جادة طويلة")end

-- اللوح الأول
function Beach16()
applyTicket({1920291606,1699897190,1818326126,1694524672,7340133,111},"اللوح الأول")end

-- كنز بالداساري
function Beach17()
applyTicket({1919512614,1399157857,1601202536,1634038388,1701999987,0},"كنز بالداساري")end

-- مدفع الفاكهة
function Beach18()
applyTicket({1970431524,1817408617,1852400489,1852530535,6645353,28783},"مدفع الفاكهة")end

-- مدفع بحري
function Beach19()
applyTicket({1701860138,1818323299,1969317186,1398765940,1198549352,28277},"مدفع بحري")end

-- مرساة الأميرالية
function Beach20()
applyTicket({1701860134,1818323299,1969317186,1633646964,1919902574,0},"مرساة الأميرالية")end

-- فرس البحر
function Beach21()
applyTicket({1701860140,1818323299,1969317186,1935636852,1869111653,6648690},"فرس البحر")end

-- صيد الأخطبوط
function Beach22()
applyTicket({1701860138,1818323299,1969317186,1868527988,1886352483,29557},"صيد الأخطبوط")end

-- الجسر الأحمر
function Beach23()
applyStatue({1667592275,1114399081,1953849701,1701994361,1769095780,6645604,23},"الجسر الأحمر")end

-- السرطان الناسك
function Beach24()
applyTicket({1634034216,1601795189,1668178275,1751085669,1768780389,116},"السرطان الناسك")end

-- نادي الغواصة الصفراء
function Beach25()
applyTicket({1634034220,2036295779,1869376613,1970495351,1918987618,6647401},"نادي الغواصة الصفراء")end

-- مقهى عصير شجرة النخيل
function Beach26()
applyTicket({1634034206,1885300835,2037674593,1918984799,0,0},"مقهى عصير شجرة النخيل")end

-- معسكر القراصنة
function Beach27()
applyTicket({1634034216,1601795189,1953653104,1768972153,1702125938,115},"معسكر القراصنة")end

-- القائد الأسطوري
function Beach28()
applyStatue({1667592275,1114399081,1953849701,1631805305,1767994480,1635013486,1399158132,1869832549,853606510,33},"القائد الأسطوري")end

-- الحق بجولة ركوب الأمواج
function Beach29()
applyTicket({1634034208,1601795189,1718773107,1869574239,108,0},"الحق بجولة ركوب الأمواج")end

-- أرجوحة الشاطئ
function Beach30()
applyTicket({1634034210,1601795189,1852405619,1634754407,28012,0},"أرجوحة الشاطئ")end

-- حانة عصير جوز الهند
function Beach31()
applyTicket({1634034212,1601795189,1868787523,1601467758,7496034,0},"حانة عصير جوز الهند")end

-- ============================================================
-- 🐇 عيد الفصح (Easter)
-- ============================================================

-- توبياري البيض
function Easter1()
applyStatue({1667592275,1114399081,1953849701,1869897593,1918986608,1734696825,103,25},"توبياري البيض")end

-- عربة ممتلئة بالهدايا
function Easter2()
applyStatue({1667592275,1114399081,1953849701,1631936377,1919251571,1651341651,1124101231,26},"عربة ممتلئة بالهدايا")end

-- تمثال الأرنب الموهوب
function Easter3()
applyStatue({1667592275,1114399081,1953849701,1631936377,1919251571,1650614610,1124103273,26},"تمثال الأرنب الموهوب")end

-- بيضة فابرجي
function Easter4()
applyStatue({1667592275,1114399081,1953849701,1631936377,1919251571,1650542175,1701278309,6776645,31},"بيضة فابرجي")end

-- بيض فابرجيه
function Easter5()
applyStatue({1667592275,1114399081,1953849701,1631936377,1919251571,1650542175,1701278309,1600612165,1702194274,36},"بيض فابرجيه")end

-- توبياري عيد الفصح
function Easter6()
applyStatue({1667592275,1114399081,1953849701,1631936377,1919251571,1768976212,7959137,27},"توبياري عيد الفصح")end

-- متجر عيد الفصح
function Easter7()
applyTicket({1819230994,1163883119,1946183527,26368,0,0},"متجر عيد الفصح")end

-- متاهة عيد الفصح
function Easter8()
applyTicket({1650551840,1852404345,1700751476,1702130529,1952514162,0},"متاهة عيد الفصح")end

-- كنز الأرانب
function Easter9()
applyTicket({1935754524,1601332596,1852732770,7562601,1702129249,28274},"كنز الأرانب")end

-- بيت الأرانب
function Easter10()
applyTicket({1935754518,1400006004,1886221684,6582784,-368251072,111},"بيت الأرانب")end

-- منزل أرنب عيد الفصح
function Easter11()
applyStatue({1667592275,1114399081,1953849701,1631936377,1919251571,1650545247,1215588706,1702065519,32},"منزل أرنب عيد الفصح")end

-- دمية أرنب
function Easter12()
applyStatue({1667592275,1114399081,1953849701,1631936377,1919251571,1935754591,1114793332,2037280373,32},"دمية أرنب")end

-- أرجوحة عيد الفصح
function Easter13()
applyTicket({1935762714,1215456628,1869442401,27491,-368251072,111},"أرجوحة عيد الفصح")end

-- سكة حديد عيد الفصح
function Easter14()
applyTicket({1935762716,1383228788,1919707489,6578543,-368251072,111},"سكة حديد عيد الفصح")end

-- ورشة عيد الفصح
function Easter15()
applyTicket({1935762716,1601332596,1952670054,7959151,-368251072,111},"ورشة عيد الفصح")end

-- متعة عيد الفصح
function Easter16()
applyTicket({1935762720,1752327540,1702065519,1701999711,7340133,111},"متعة عيد الفصح")end

-- قرية الأرانب
function Easter17()
applyTicket({1935754526,846357876,1144467760,1919902565,3289344,3748974},"قرية الأرانب")end

-- رشاش مياه عيد الفصح
function Easter18()
applyTicket({1952544548,1852404325,1851868007,1935762783,7497076,101},"رشاش مياه عيد الفصح")end


-- ============================================================
-- 🎉 زينة الأحداث (Events)
-- ============================================================

-- طاحونة هواء الهالوين
function Event1()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3289710},"طاحونة هواء الهالوين")end

-- قرية سانتا
function Event2()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3486318},"قرية سانتا")end

-- بوابة سايبر سيتي
function Event3()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3421038},"بوابة سايبر سيتي")end

-- مكتب المأمور
function Event4()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3617646},"مكتب المأمور")end

-- نادي الجاز
function Event5()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3683182},"نادي الجاز")end

-- العربية المشؤومة
function Event6()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3748718},"العربية المشؤومة")end

-- بوابة الفايكنج
function Event7()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3159150},"بوابة الفايكنج")end

-- ديك الحبش الوفير
function Event8()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3224686},"ديك الحبش الوفير")end

-- شاليه جبلي
function Event9()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3355758},"شاليه جبلي")end

-- مذبح باستيت
function Event10()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3421294},"مذبح باستيت")end

-- الريشة الذهبية
function Event11()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3486830},"الريشة الذهبية")end

-- دراكار الفايكنج
function Event12()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3552366},"دراكار الفايكنج")end

-- منطقة تصوير القراصنة
function Event13()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3748974},"منطقة تصوير القراصنة")end

-- مسرح خارجي
function Event14()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3683438},"مسرح خارجي")end

-- نافورة المياه الحية
function Event15()
applyTicket({1886930220,1953064037,1148088169,1919902565,1869182049,3617902},"نافورة المياه الحية")end




function EXIT()
gg.alert("🤡مع السلامه ياغالي هات خمسه جنيه🤡")
gg.setVisible(false)
gg.clearResults()  
gg.clearList()    
print("                                                                          🏴‍☠️⚔️▬▬▬▬▬๑۩ⒽⒺⓇⓄ۩๑▬▬▬▬▬⚔️🏴‍☠️\n\n                                                                🏴‍☠️⚔️🆂🅲🆁🅸🅿🆃🅼🅰🅷🅼🅾🆄🅳🅷🅴🆁🅾⚔️🏴‍☠️                \n \n                                                                🏴‍☠️⚔️🆆🅴🅻🅲🅾🅼🅴 🅼🆈 🅵🆁🅸🅴🅽🅳⚔️🏴‍☠️  \n \n                                                                🏴‍☠️⚔️🅴🅳🅸🆃🅴🅳 🅱🆈 🅼🅰🅷🅼🅾🆄🅳🅷🅴🆁🅾⚔️🏴‍☠️  \n\n                                                                          🏴‍☠️⚔️▬▬▬▬▬๑۩ⒽⒺⓇⓄ۩๑▬▬▬▬▬⚔️🏴‍☠️")
gg.toast("🏴‍☠️🤡MAHMOUDHERO🤡🏴‍☠️")
os.exit()
end -- 👹MAHMOUDHERO👹

HOME()

while true do
	if gg.isVisible(true) then
        gg.setVisible(false)
        HOME()
    end
    gg.sleep(100)
end
