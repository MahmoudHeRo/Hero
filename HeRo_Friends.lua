--****************************************************************************************************************************************************************
-- Tool by : '' MAHMOUDHERO ''
-- Modify  by HERO
-- Decrypted by : '' MAHMOUDHERO '' 
--****************************************************************************************************************************************************************
-- ██╗  ██╗███████╗██████╗  ██████╗ 
-- ██║  ██║██╔════╝██╔══██╗██╔═══██╗
-- ███████║█████╗  ██████╔╝██║   ██║
-- ██╔══██║██╔══╝  ██╔══██╗██║   ██║
-- ██║  ██║███████╗██║  ██║╚██████╔╝
-- ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝--

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
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع الاكواد  🟡 𝄟\n╚═══════════════╝",--21
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--22
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--23
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--24
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
        {name = "الملصقات", prefix = "Emoji"}
    }
    
    local choice = gg.multiChoice(categories, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊       ❪ اختر مجموعة الاكواد التي تريدها ❫               𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
    
    if not choice then 

        Mahmoud()
        return 
    end
    
    
    if choice[22] then  
        Mahmoud()
        return
    end
    
    if choice[23] then  
        Home()
        return
    end
    
    if choice[24] then  
        EXIT()
        return
    end
    
    
    local functionsToApply = {}
    local categoryName = ""
    
    
        if choice[21] then
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
        for i = 1, 19 do
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

gg.alert("⚠️تم اضافه التحديث الجديد ديكورات إطار اسم⚠️")


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
    "╔══════⟬⚜️⟭══════╗\n𝄟🕵️‍♂️        قسم الحظر        🕵️‍♂️𝄟\n╚═══════════════╝",--17
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
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--4
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== HeRoBan then else
if MH[1]== true then HH1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then HH2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[4]== true then EXIT() end -- 👹MAHMOUDHERO👹
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
"╔══════⟬⚜️⟭══════╗\n𝄟               اكواد الزينة           𝄟 \n╚═══════════════╝",--29
"╔══════⟬⚜️⟭══════╗\n𝄟    🔥تنزيل جميع الاكواد🔥  𝄟 \n╚═══════════════╝",--30
"╔══════⟬⚜️⟭══════╗\n𝄟           رجـــــــــــــــــــوع       𝄟 \n╚═══════════════╝",--30
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
if hero[30]== true then selectAllDecorations()  return  end
if hero[31]== true then Home() end
end
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
	"╔══════⟬⚜️⟭══════╗\n𝄟               الزمرد الاخضر        𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟               الياقوت الاحمر       𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع المجوهرات🟡𝄟 \n╚═══════════════╝",--4
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--7
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n??⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
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
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--6
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


--ذهب وكاش
function U12 ()
lastMenu = U12
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟              كود الكاش              𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟             كود الفلوس             𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟            كود المستوى            𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟         كود الكاتب الأول          𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟 كود زيادة نقاط حدث الإطار   𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟 كود زيادة نقاط حدث الاسم   𝄟 \n╚═══════════════╝",--6
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--8
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--9
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U12 then else
if MH[1]== true then G1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then G2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then G3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then G4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then G5() end -- 👹MAHMOUDHERO👹
if MH[6]== true then G6() end -- 👹MAHMOUDHERO👹
if MH[7]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[8]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[9]== true then EXIT() end -- 👹MAHMOUDHERO👹
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
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--14
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
lastMenu = U25
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
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 10
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Style"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Style"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الإطارات")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end



----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------


--النمط الاسم 
function U26 ()
lastMenu = U26
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟              نمط الوردي            𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟          نمط عيد الفصح          𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟              نمط الناري              𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟               نمط نيون             𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡   اختيار جميع النمط   🟡𝄟 \n╚═══════════════╝",--
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 4
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Frame"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Frame"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "النمط")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
end

----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------

--اكواد الشارات 
function U27 ()
lastMenu = U27
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
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
local total = 14
local list = {}

for i = 1, total do if MH[i] then list[#list + 1] = _G["Badge"..i] end end
if MH[total + 1] and #list == 0 then for i = 1, total do list[i] = _G["Badge"..i] end end
if #list == 1 then list[1]() return end if #list > 1 then applyAllWithTracking(list, "الشارات")return end

if MH[total + 2] then Mahmoud() end
if MH[total + 3] then Home() end
if MH[total + 4] then EXIT() end

HERO = -1
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
function U29 ()
gg.alert("🕵️‍♂️جاري العمل عليها عليك الانتظار حتي يتم الانتهاء هات خمسه جنيه🕵️‍♂️")
end -- 👹MAHMOUDHERO👹
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


-- زياده المستوي من الطائره   
function F3()
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

    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
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




--طلب مساعده في القطار 
function HH1()    
gg.setVisible(false)
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
local options = {
"╔══════⟬⚜️⟭══════╗\n𝄟 ارسال البرسيم فقط للاصدقاء𝄟\n╚═══════════════╝",
"╔══════⟬⚜️⟭══════╗\n𝄟     زيادة المستوى للاصدقاء   𝄟\n╚═══════════════╝"}
local choice = gg.multiChoice(options, nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊                     ❪ اختيار ما تريده ❫                         𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

if not choice then return end
local val1 = 1701345034
local val2 = 1677751393
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


gg.clearResults()
gg.searchNumber("50;1801519104;51;52:65", gg.TYPE_DWORD)
gg.refineNumber("51", gg.TYPE_DWORD)

local results = gg.getResults(3)

if #results == 0 then
    gg.alert("❌ كود طلب المساعدة في القطار لا يعمل ❌\n\n📸 تحدث مع مطور الاسكربت وأرسل صوره📸 ")
    return
end

local freezeList = {}

for i, v in ipairs(results) do

    local modifications = {
        {address = v.address + 52, flags = gg.TYPE_FLOAT, value = 1, freeze = true},

        {address = v.address - 388, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
        {address = v.address - 340, flags = gg.TYPE_DWORD, value = 1, freeze = true},

        {address = v.address - 412, flags = gg.TYPE_DWORD, value = val1, freeze = true},
        {address = v.address - 408, flags = gg.TYPE_DWORD, value = val2, freeze = true},

        {address = v.address - 644, flags = gg.TYPE_DWORD, value = 1, freeze = true},

        {address = v.address - 692, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
        {address = v.address - 716, flags = gg.TYPE_DWORD, value = val1, freeze = true},
        {address = v.address - 712, flags = gg.TYPE_DWORD, value = val2, freeze = true},

        {address = v.address - 948, flags = gg.TYPE_DWORD, value = 1, freeze = true},

        {address = v.address - 996, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
        {address = v.address - 1020, flags = gg.TYPE_DWORD, value = val1, freeze = true},
        {address = v.address - 1016, flags = gg.TYPE_DWORD, value = val2, freeze = true},

        {address = v.address - 1252, flags = gg.TYPE_DWORD, value = 1, freeze = true},

        {address = v.address - 1300, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
        {address = v.address - 1324, flags = gg.TYPE_DWORD, value = val1, freeze = true},
        {address = v.address - 1320, flags = gg.TYPE_DWORD, value = val2, freeze = true},

        {address = v.address - 1556, flags = gg.TYPE_DWORD, value = 1, freeze = true},

        {address = v.address - 1604, flags = gg.TYPE_QWORD, value = qwordValue, freeze = true},
        {address = v.address - 1628, flags = gg.TYPE_DWORD, value = val1, freeze = true},
        {address = v.address - 1624, flags = gg.TYPE_DWORD, value = val2, freeze = true},
    }

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

if #freezeList > 0 then
    gg.addListItems(freezeList)

    if choice[1] == true then
   gg.alert("🕵️‍♂️يمكن ارسال البرسيم للاصدقاء بعد المساعدة🕵️‍♂️")
 else   
 end
 gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
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
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
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
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
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
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
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
gg.toast("🏴‍☠️🔥MAHMOUDHERO🔥🏴‍☠️")
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
applyTicket({1634882594, 1867148905, 1701737077, 1802458233, 28261, 0},"حدث الاسم", true)end


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
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡

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
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
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
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
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
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
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

--خليط الفراولة 🍓
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
