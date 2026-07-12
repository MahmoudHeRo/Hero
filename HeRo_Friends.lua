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

local __FULL_INDEX = nil

-- أدوات مساعدة
local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
local function starts_with_comment(s) return trim(s):sub(1,2) == "--" end

local function unescape_lua_string(s)
    -- فك أشهر الهروب لتحويل "\n" إلى سطر جديد...إلخ
    s = s:gsub("\\\\", "\x00")       -- مؤقت
    s = s:gsub('\\"', '"')
    s = s:gsub("\\'", "'")
    s = s:gsub("\\n", "\n")
    s = s:gsub("\\r", "\r")
    s = s:gsub("\\t", "\t")
    s = s:gsub("\x00", "\\")
    return s
end

-- عدّ الأقواس {} في سطر مع تجاهل النصوص والتعليقات
local function brace_delta(line)
    local i, n = 1, #line
    local delta = 0
    local in_q, qch = false, nil

    while i <= n do
        local ch = line:sub(i,i)
        local two = line:sub(i,i+1)

        if not in_q then
            -- تعليق سطري --
            if two == "--" then
                break
            elseif ch == "'" or ch == '"' then
                in_q, qch = true, ch
            elseif ch == "{" then
                delta = delta + 1
            elseif ch == "}" then
                delta = delta - 1
            end
            i = i + 1
        else
            if ch == "\\" then
                i = i + 2
            elseif ch == qch then
                in_q, qch = false, nil
                i = i + 1
            else
                i = i + 1
            end
        end
    end
    return delta
end

-- استخرج جسم الجدول بين أول { وآخر } المطابقين (مع تجاهل النصوص/التعليقات)
local function extract_table_body(block)
    local i, n = 1, #block
    local in_q, qch = false, nil
    local depth = 0
    local start_pos, end_pos = nil, nil

    while i <= n do
        local ch = block:sub(i,i)
        local two = block:sub(i,i+1)

        if not in_q then
            if two == "--" then
                -- تخطّ بقية السطر
                local nl = block:find("\n", i+2) or (n+1)
                i = nl
            elseif ch == "'" or ch == '"' then
                in_q, qch = true, ch
                i = i + 1
            elseif ch == "{" then
                depth = depth + 1
                if not start_pos then start_pos = i end
                i = i + 1
            elseif ch == "}" then
                depth = depth - 1
                if depth == 0 then end_pos = i; break end
                i = i + 1
            else
                i = i + 1
            end
        else
            if ch == "\\" then
                i = i + 2
            elseif ch == qch then
                in_q, qch = false, nil
                i = i + 1
            else
                i = i + 1
            end
        end
    end

    if start_pos and end_pos and end_pos > start_pos then
        return block:sub(start_pos+1, end_pos-1)
    end
    return ""
end

-- تحليل عناوين القائمة من جسم الجدول: يدعم "..." و '...' ويحافظ على ترتيب/فهرسة الخيارات
local function parse_items_from_table(body)
    local items = {}
    local i, n = 1, #body
    local optIndex = 0

    while i <= n do
        local ch = body:sub(i,i)
        local two = body:sub(i,i+1)

        -- تجاهل التعليق السطري
        if two == "--" then
            local nl = body:find("\n", i+2) or (n+1)
            i = nl
        elseif ch == '"' or ch == "'" then
            -- سلسلة نصية
            local q = ch
            local j = i + 1
            local buf = {}
            while j <= n do
                local cj = body:sub(j,j)
                if cj == "\\" then
                    table.insert(buf, body:sub(j, j+1))
                    j = j + 2
                elseif cj == q then
                    break
                else
                    table.insert(buf, cj)
                    j = j + 1
                end
            end
            local raw = table.concat(buf)
            local text = unescape_lua_string(raw)
            optIndex = optIndex + 1
            table.insert(items, {
                text = text,
                pos = optIndex,
                disabled = starts_with_comment(text)
            })
            i = (body:sub(j,j) == q) and (j + 1) or (n + 1)
        else
            -- أي شيء آخر (فواصل/مسافات/قيم غير نصية)
            if ch == "," then
                -- قد يكون عنصر غير نصي قبلها، ومع ذلك لا نزيد الفهرس إلا للنصوص
            end
            i = i + 1
        end
    end

    return items
end

local function BuildFullIndex()
    if __FULL_INDEX then return __FULL_INDEX end

    local path = gg.getFile()
    local f = io.open(path, "r")
    if not f then
        gg.alert("⚠️ تعذر فتح ملف السكربت.")
        return nil
    end
    local content = f:read("*a")
    f:close()

    local index = {}
    local currentFunction = nil

    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local waitingForBrace = false
    local capturing = false
    local depth = 0
    local multiBuf = {}

    local function finish_capture()
        local multiContent = table.concat(multiBuf, "\n")
        multiBuf = {}
        capturing = false
        waitingForBrace = false
        depth = 0

        -- استخرج جسم الجدول فقط ثم العناوين
        local body = extract_table_body(multiContent)
        local items = parse_items_from_table(body)

        if currentFunction then
            index[currentFunction] = index[currentFunction] or { items = {}, map = {} }
            index[currentFunction].items = items
        end
    end

    for _, line in ipairs(lines) do
        local fn = line:match("^%s*function%s+([%w_]+)%s*%(")
        if fn then
            currentFunction = fn
            waitingForBrace, capturing, depth = false, false, 0
            multiBuf = {}
            index[currentFunction] = index[currentFunction] or { items = {}, map = {} }
        end

        if currentFunction then
            -- بدء اكتشاف استدعاء multiChoice/choice
            if not capturing and not waitingForBrace then
                if line:find("=%s*gg%.multiChoice%s*%(") or line:find("=%s*gg%.choice%s*%(") then
                    if line:find("{") then
                        capturing = true
                        table.insert(multiBuf, line)
                        depth = depth + brace_delta(line)
                        if depth == 0 then finish_capture() end
                    else
                        waitingForBrace = true
                        table.insert(multiBuf, line)
                    end
                end
            elseif waitingForBrace and not capturing then
                table.insert(multiBuf, line)
                if line:find("{") then
                    capturing = true
                    depth = depth + brace_delta(line)
                    if depth == 0 then finish_capture() end
                end
            elseif capturing then
                table.insert(multiBuf, line)
                depth = depth + brace_delta(line)
                if depth == 0 then finish_capture() end
            end

            -- ربط الخيارات بالدوال (أنماط شائعة)
            local patterns = {
                "if%s*[%w_]+%[(%d+)%]%s*==%s*true%s*then%s*([%w_]+)%s*%(",
                "if%s*[%w_]+%[(%d+)%]%s*then%s*([%w_]+)%s*%(",
                "elseif%s*[%w_]+%[(%d+)%]%s*then%s*([%w_]+)%s*%(",
                "if%s*[%w_]+%[(%d+)%]%s*==%s*true%s*then%s*([%w_]+)%s*%(%)",
                "if%s*[%w_]+%[(%d+)%]%s*then%s*([%w_]+)%s*%(%)",
                "([%w_]+)%s*%(%)%s*%-%-%s*[%w_]+%[(%d+)%]" -- استدلال بالتعليق
            }
            for _, p in ipairs(patterns) do
                local idx, fnm = line:match(p)
                if idx and fnm then
                    index[currentFunction].map[tonumber(idx)] = fnm
                end
            end
        end
    end

    __FULL_INDEX = index
    return __FULL_INDEX
end

-- 🔎 البحث الذكي (يحافظ على التنسيق ويتجاهل العناوين التي تبدأ بـ --)
function SmartSearch()
    local index = BuildFullIndex()
    if not index or type(index) ~= "table" then
        gg.alert("⚠️ لم أستطع بناء فهرس القوائم.")
        return
    end

    local input = gg.prompt({"🙋ضع هنا كلمه البحث التي تريدها🙋:"}, nil, {"text"})
if not input or not input[1] or #input[1] < 3 then
    gg.alert("😂معلش تعالا علي نفسك شويه واكتب كلمه صح ايدك فيها شلل هات خمسه جنيه 😂")
    return
end
    local key = input[1]:lower()
    local shown, funcNames, sourceFunctions, originalTitles = {}, {}, {}, {}

    for funcName, data in pairs(index) do
        local items = (data and data.items) or {}
        for _, it in ipairs(items) do
            -- تجاهل العناصر المعطّلة المكتوبة بهذه الصيغة: "--اسم"
            if not it.disabled then
                local title = it.text or ""
                if title:lower():find(key, 1, true) then
                    local fnName = data.map and data.map[it.pos] or false
                    table.insert(shown, title)
                    table.insert(funcNames, fnName)
                    table.insert(sourceFunctions, funcName)
                    table.insert(originalTitles, title)
                end
            end
        end
    end

    if #shown == 0 then
        gg.alert("❌ لا توجد نتائج مطابقة: " .. input[1])
        return
    end

    -- لا نرتّب أبجديًا للحفاظ على ترتيب السكربت الأصلي
    local pick = gg.choice(shown, nil, "✅ النتائج (" .. #shown .. "):")
    if not pick then return end

    local fnName = funcNames[pick]
    local sourceFunc = sourceFunctions[pick]
    local originalTitle = originalTitles[pick]

    if fnName and type(_G[fnName]) == "function" then
        local alertMsg = "🚀 جاري التشغيل:\n\n"
        alertMsg = alertMsg .. originalTitle .. "\n\n"
        
        gg.alert(alertMsg)
        return _G[fnName]()
    else
        gg.alert("📋 العنوان (مع التنسيق الكامل):\n\n" .. originalTitle ..
                 "\n\n⚠️ لا يوجد دالة مرتبطة بهذا الخيار.")
    end
end






-- اختبار سريع لعرض تنسيق متعدد الأسطر
function TestFormatting()
    local testText = "╔══════⟬⚜️⟭══════╗\n𝄟       فتح التذكرة الذهبية       𝄟\n╚═══════════════╝"
    gg.alert("📋 اختبار التنسيق:\n\n" .. testText)
end




gg.setVisible(false)
local selectedRange = gg.REGION_C_ALLOC
local cachedValues = {
    primary = nil,
    secondary = nil,
    mainPattern = nil
}

-- ============= دوال التخزين المؤقت المحسنة =============

function cachePrimaryPattern()
    if cachedValues.primary then return true end
    
    gg.clearResults()
    gg.setRanges(selectedRange)
    gg.searchNumber("1599361808;65537;1599099674::449", gg.TYPE_DWORD)
    gg.refineNumber("1599361808", gg.TYPE_DWORD)
    
    local results = gg.getResults(999)
    if #results == 0 then
        gg.alert("⚠️كود الاستعادة لا يعمل تحدث مع مطور الاسكربت⚠️")
        return false
    end
    
    local address = results[#results].address
    local edits = {
        {address = address - 8, flags = gg.TYPE_DWORD, value = 0, freeze = true},
        {address = address - 12, flags = gg.TYPE_DWORD, value = 0, freeze = true},
        {address = address - 16, flags = gg.TYPE_DWORD, value = 0, freeze = true}
    }
    
    gg.setValues(edits)
    gg.addListItems(edits)
    
    cachedValues.primary = {
        address = address,
        edits = edits
    }
    
    return true
end

function cacheSecondaryPattern()
    if cachedValues.secondary then return true end
    
    gg.clearResults()
    local success = pcall(function()
        gg.searchNumber('33;24;1936682818;7631717', gg.TYPE_DWORD)
        gg.refineNumber('33', gg.TYPE_DWORD)
    end)
    
    if not success or gg.getResultsCount() == 0 then
        gg.alert("⚠️كود استخراج قيمه 33 لا يعمل تحدث مع مطور الاسكربت⚠️")
        return false
    end
    
    local address = gg.getResults(1)[1].address
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
    gg.searchNumber('1970225960;1599361808:257', gg.TYPE_DWORD)
    gg.refineNumber('1970225960', gg.TYPE_DWORD)
    
    local results = gg.getResults(1)
    if #results == 0 then
        gg.alert("⚠️كود الاستبدال لا يعمل تحدث مع مطور الاسكربت⚠️")
        return false
    end
    
    cachedValues.mainPattern = results[1].address
    return true
end

-- ============= أدوات مساعدة =============
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

-- ============= الدالة الرئيسية المحسنة =============

function applyStatue(values, statueName, showInput)
    -- 1. التحميل الأولي للأنماط
    if not cachePrimaryPattern() or not cacheSecondaryPattern() or not cacheMainPattern() then
        return
    end

    local mainAddress = cachedValues.mainPattern
    local refValues   = cachedValues.secondary.values

    -- 2. إدخال مخصص
    if showInput then
        local input = gg.prompt(
            {"🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n🙋 اكتب الرقم الذي تريده 🙋"},
            {""},
            {"number"}
        )
        if input then
            local customValue = toNum(input[1], 0)
            pcall(function()
                gg.setValues({{address = mainAddress + 664, flags = gg.TYPE_QWORD, value = customValue}})
            end)
        else
            gg.toast("تم الإلغاء")
            return
        end
    end

    gg.toast("جاري استبدال كود " .. (statueName or ""))
    gg.sleep(3000)
    -- 3. كتابة القيم الأساسية
    local okBase = pcall(function()
        gg.setValues({
            {address = mainAddress + 640, flags = gg.TYPE_DWORD, value = refValues[1].value},
            {address = mainAddress + 644, flags = gg.TYPE_DWORD, value = refValues[2].value},
            {address = mainAddress + 648, flags = gg.TYPE_DWORD, value = refValues[3].value}, -- سيتم تحديثها لاحقاً
            {address = mainAddress + 652, flags = gg.TYPE_DWORD, value = refValues[4].value},
            {address = mainAddress + 656, flags = gg.TYPE_DWORD, value = refValues[5].value},
            {address = mainAddress + 660, flags = gg.TYPE_DWORD, value = refValues[6].value},
            {address = mainAddress + 728, flags = gg.TYPE_QWORD, value = 0},
            {address = mainAddress + 736, flags = gg.TYPE_QWORD, value = 0},
            {address = mainAddress + 744, flags = gg.TYPE_QWORD, value = 0}
        })
    end)
    if not okBase then
        gg.alert("⚠️ خطأ أثناء التعديلات الأساسية")
        return
    end

    -- 4. المؤشر
    local pointer = safeQword(mainAddress + 656)
if isValidPtr(pointer) then
    local mods = {}
    local count = #values or 0

    -- نحدد عدد القيم المخصصة للبوينتر
    -- إذا 7 قيم → 6 للبوينتر + 1 للأوفيس 648
    -- إذا 8 قيم → 7 للبوينتر + 1 للأوفيس 648
    -- إذا 9 قيم → 8 للبوينتر + 1 للأوفيس 648
    -- إذا 10 قيم → 9 للبوينتر + 1 للأوفيس 648
    local ptrCount = math.min(count - 1, 9)
    if ptrCount < 0 then ptrCount = 0 end

    -- تعبئة القيم للبوينتر
    for i = 1, ptrCount do
        mods[#mods + 1] = {
            address = pointer + (i - 1) * 4,
            flags   = gg.TYPE_DWORD,
            value   = toNum(values and values[i], 0)
        }
    end

    -- تكملة باقي الخانات حتى 9 قيم بالبوينتر (أصفار)
    for i = ptrCount + 1, 9 do
        mods[#mods + 1] = {
            address = pointer + (i - 1) * 4,
            flags   = gg.TYPE_DWORD,
            value   = 0
        }
    end

    -- القيمة الأخيرة دايمًا تتحط في الأوفيس 648
    mods[#mods + 1] = {
        address = mainAddress + 648,
        flags   = gg.TYPE_DWORD,
        value   = toNum(values and values[count], 0)
    }

    -- تطبيق التعديلات
    pcall(function() gg.setValues(mods) end)
else
    gg.toast("⚠️ Pointer غير صالح، تم تخطي تعديلات المؤشر")
end

    -- 5. رسائل واجهة المستخدم
    if statueName then
        gg.sleep(2000)
        gg.toast("تم استبدال كود " .. statueName)
        gg.sleep(1000)
        gg.alert(
            "🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n" ..
            "✨ تم تعديل كود " .. statueName .. " بنجاح ✨\n\n" ..
            "⚠️ ملاحظة: يجب استلام الهديه رقم 30 لتظهر التغييرات\n\n" ..
            "🇪🇬 Egypt Mother of the World 🇪🇬"
        )
    end
end
-- ============= نظام applyTicket الكامل المعزول =============
local ticketSystem = {
    initialized = false,
    firstResults = {},
    secondResults = {},
    
    init = function(self)
        if self.initialized then return true end      
        gg.toast("🏴‍☠️𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🏴‍☠️")
        
        -- البحث الأولي
        gg.clearResults()
        gg.setRanges(gg.REGION_C_ALLOC)
        gg.searchNumber("1599361808;65537;1599099674", gg.TYPE_DWORD)
        gg.refineNumber("1599361808", gg.TYPE_DWORD)
        
        local res = gg.getResults(100)
        if #res == 0 then
            gg.alert("⚠️كود الاستعادة لا يعمل تحدث مع مطور الاسكربت⚠️")
            return false
        end
        
        for _, v in ipairs(res) do
            local edits = {
                {address = v.address - 8, flags = gg.TYPE_DWORD, value = 0},
                {address = v.address - 12, flags = gg.TYPE_DWORD, value = 0},
                {address = v.address - 16, flags = gg.TYPE_DWORD, value = 0, freeze = true}
            }
            gg.setValues(edits)
            table.insert(self.firstResults, edits[3])
        end
        gg.addListItems(self.firstResults)
        
        -- البحث الثانوي
        gg.clearResults()
        gg.searchNumber("1970225960;1599361808:257", gg.TYPE_DWORD)
        gg.refineNumber("1970225960", gg.TYPE_DWORD)
        
        local secondRes = gg.getResults(100)
        if #secondRes == 0 then
            gg.alert("⚠️كود الاستبدال لا يعمل تحدث مع مطور الاسكربت⚠️")
            return false
        end
        
        self.secondResults = secondRes
        self.initialized = true        
        return true
    end
}

-- ============= نظام applyTicket الكامل المعزول =============
function applyTicket(values, name, showInput)
    if not ticketSystem:init() then return end

    local tickets = {}
    local shouldShowInput = false
    
    -- النوع الجديد: { values = {...}, name = "..." } (يعرض مربع)
    if type(values) == "table" and values.values and values.name then
        table.insert(tickets, {name = values.name, values = values.values})
        shouldShowInput = true
    -- فردي: values = table من الأرقام + اسم (لا يعرض مربع)
    elseif type(values[1]) == "number" and name then
        table.insert(tickets, {name = name, values = values})
        shouldShowInput = false
    -- جماعي: table of tickets (يتحقق من كل تذكرة)
    elseif type(values[1]) == "table" and values[1].name then
        tickets = values
        for _, ticket in ipairs(tickets) do
            if ticket.values and ticket.name then
                shouldShowInput = true
                break
            end
        end
    else
        gg.alert("❌ تنسيق القسائم غير صحيح")
        return
    end

    local inp = {}
    
    -- إذا يجب عرض المربع
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
        -- إذا لا نريد إدخال، استخدم قيم افتراضية (0)
        for i = 1, #tickets do
            inp[i] = 0
        end
    end

    -- تطبيق التعديلات
    for i, ticket in ipairs(tickets) do
        if shouldShowInput then
            gg.sleep(1000)
            gg.toast(ticket.name.." العدد هو  "..inp[i])
        end
        
        
        gg.toast(" جاري استبدل كود "..ticket.name.."  ")
         gg.sleep(3000)
        for _, result in ipairs(ticketSystem.secondResults) do
            local mods = {
                {address = result.address + 640, flags = gg.TYPE_DWORD, value = ticket.values[1], freeze = true},
                {address = result.address + 644, flags = gg.TYPE_DWORD, value = ticket.values[2], freeze = true},
                {address = result.address + 648, flags = gg.TYPE_DWORD, value = ticket.values[3], freeze = true},
                {address = result.address + 652, flags = gg.TYPE_DWORD, value = ticket.values[4], freeze = true},
                {address = result.address + 656, flags = gg.TYPE_DWORD, value = ticket.values[5], freeze = true},
                {address = result.address + 660, flags = gg.TYPE_DWORD, value = ticket.values[6], freeze = true},
                {address = result.address + 664, flags = gg.TYPE_QWORD, value = inp[i], freeze = true},
                {address = result.address + 728, flags = gg.TYPE_QWORD, value = 0, freeze = true},
                {address = result.address + 736, flags = gg.TYPE_QWORD, value = 0, freeze = true},
                {address = result.address + 744, flags = gg.TYPE_QWORD, value = 0, freeze = true}
            }
            gg.setValues(mods)
        end

        gg.sleep(2000)
        gg.toast(" تم استبدل كود "..ticket.name.."  ")
         gg.sleep(2000)
        gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n" ..
                "✨ تم تعديل كود " .. ticket.name .. " بنجاح ✨\n\n" ..
                "⚠️ ملاحظة: يجب استلام الهديه رقم 30 لتظهر التغييرات\n\n" ..
                "🇪🇬 Egypt Mother of the World 🇪🇬")
   
    end
end



 
--  ⚔️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️🛡️⚔️
  --⚔️🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥⚔️

Detector = gg.getFile():match('[^/]+$')
endtime=load("return os.time{year=2035,month=8,day=22}")()
if(os.time()>endtime) then
gg.alert('🙋جاري العمل واضافه قسم الحيوانات الان انتظر او تحدث مع مطور البرنامج لمعرفة وقت الانتهاء🙋')
os.exit()
end



-- متغير لتخزين آخر قائمة تم فتحها
lastMenu = nil
function HOME()
    if isLoggedIn then
        -- إذا كان هناك آخر قائمة محفوظة، ارجع إليها
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
        setMemoryRange()
        Home()
    elseif loginChoice == 3 then
        EXIT()
    end
end


function setMemoryRange()
    gg.setVisible(false)
    local rangeChoice = gg.choice({
        "Ⓜ️ Ca: alloc Ⓜ️",
        "Ⓜ️ Ca: alloc + O: Other Ⓜ️",
        "Ⓜ️ Ca: alloc + A: Anonymous Ⓜ️",       
        "Ⓜ️ O: Other Ⓜ️",       
        "Ⓜ️ Ca: alloc + A: Anonymous + O: Other Ⓜ️"  }, 
        nil, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟               ❪ 🙋 إختيار نطاقات الذاكرة🙋 ❫                𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

    if rangeChoice == 1 then
        selectedRange = gg.REGION_C_ALLOC
        gg.toast("✅ Memory Range Selected: Ca: alloc ✅")
    elseif rangeChoice == 2 then
        selectedRange = gg.REGION_OTHER
        gg.toast("✅ Memory Range Selected: O: Other ✅")
    elseif rangeChoice == 3 then
        selectedRange = bit32.bor(gg.REGION_C_ALLOC, gg.REGION_ANONYMOUS)
        gg.toast("✅ Memory Range Selected: Ca: alloc + A: Anonymous ✅")
    elseif rangeChoice == 4 then
        selectedRange = bit32.bor(gg.REGION_C_ALLOC, gg.REGION_OTHER)
        gg.toast("✅ Memory Range Selected: Ca: alloc + O: Other ✅")
    elseif rangeChoice == 5 then
        selectedRange = bit32.bor(gg.REGION_C_ALLOC, gg.REGION_ANONYMOUS, gg.REGION_OTHER)
        gg.toast("✅ Memory Range Selected: Ca: alloc + A: Anonymous + O: Other ✅")
    else
        gg.alert("💠 No Range Selected. Defaulting to Ca: alloc 💠")
        selectedRange = gg.REGION_C_ALLOC
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
	"╔══════⟬⚜️⟭══════╗\n𝄟  تصفير وقت المسبك مؤقت   𝄟\n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟تصفير طلب الهليكوبتر مؤقت 𝄟\n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟    ارسال الطائره بدون وقت   𝄟\n╚═══════════════╝",--8
    "╔══════⟬⚜️⟭══════╗\n𝄟 زياده الشونه الي 5000 ثابت 𝄟\n╚═══════════════╝",--9
    "╔══════⟬⚜️⟭══════╗\n𝄟      فتح المباني المجتمعيه     𝄟\n╚═══════════════╝",--10
    "╔══════⟬⚜️⟭══════╗\n𝄟 توسيع المدينه بدون اي شي  𝄟\n╚═══════════════╝",--11   
    "╔══════⟬⚜️⟭══════╗\n𝄟   ارسال المركب بدون وقت    𝄟\n╚═══════════════╝",--12
    "╔══════⟬⚜️⟭══════╗\n𝄟   فتح جميع صنديق المصانع  𝄟\n╚═══════════════╝",--13
    "╔══════⟬⚜️⟭══════╗\n𝄟    زيادة عدد صناديق السوق   𝄟\n╚═══════════════╝",--14 
    "╔══════⟬⚜️⟭══════╗\n𝄟🗃️قسم حديقه الحيوانات🗃️ 𝄟\n╚═══════════════╝",--15
    "╔══════⟬⚜️⟭══════╗\n𝄟🗃️ قسم كل اكواد المدينه🗃️ 𝄟\n╚═══════════════╝",--16
    "╔══════⟬⚜️⟭══════╗\n𝄟🕵️‍♂️      البحث الشامل      🕵️‍♂️𝄟\n╚═══════════════╝",--17
    "╔══════⟬⚜️⟭══════╗\n𝄟⏏️خــــــــــــــــــــــــــروج⏏️𝄟\n╚═══════════════╝",--18
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== Home then else
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
if MH[17]== true then SmartSearch() end -- 👹MAHMOUDHERO👹
if MH[18]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹




--قسم الحيوانات 
function F15 ()
lastMenu = F15
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟          حيوانات السفانا             𝄟 \n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟          حيوانات المستنقع          𝄟 \n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟             حيوانات الغابه            𝄟 \n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟            حيوانات الجليد           𝄟 \n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟           حيوانات الادغال           ?? \n╚═══════════════╝",--5
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
"╔══════⟬⚜️⟭══════╗\n𝄟          اكواد حدث الالوان      𝄟 \n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟          اكواد لغز المتفجرات    𝄟 \n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟           اكواد بقعة مطابقة      𝄟 \n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟         اكواد علف الحيوانات    𝄟 \n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟           اكواد تصفير الوقت     𝄟 \n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟           كود الطاقه +القنبله     𝄟 \n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟   كود كاش_فلوس _مستوي   𝄟 \n╚═══════════════╝",--13
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
"╔══════⟬⚜️⟭══════╗\n𝄟           رجـــــــــــــــــــوع       𝄟 \n╚═══════════════╝",--25
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if hero== Mahmoud then else
if hero[1]== true then U1() end -- 👹MAHMOUDHERO👹
if hero[2]== true then U2() end -- 👹MAHMOUDHERO👹
if hero[3]== true then U3() end -- 👹MAHMOUDHERO👹
if hero[4]== true then U4() end -- 👹MAHMOUDHERO👹
if hero[5]== true then U5() end -- 👹MAHMOUDHERO👹
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
if hero[25]== true then Home() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹


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

if MH[8] then
local allTickets = {} for i = 1, 7 do
table.insert(allTickets, _G["M"..i]())end
    
if #allTickets > 0 then   
applyTicket(allTickets, true) 
gg.sleep(2000)
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n\n✨ تم استبدال جميع أكواد القسائم ✨\n\n🙋 هات خمسه جنيه بقا 🙋\n\n🇪🇬 Egypt Mother of the World 🇪🇬") end return end
        
local tickets = {}for i = 1, 7 do
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

local tickets = {}
for i = 1, 4 do if MH[i] then table.insert(tickets, _G["K"..i]()) end end
if #tickets > 0 then applyTicket(tickets, true) end

if MH[5] then Mahmoud() end
if MH[6] then Home() end
if MH[7] then EXIT() end

HERO = -1
end




--ادوات المنجم 
function U3 ()
lastMenu = U3
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                     معول              𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                    ديناميت           𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n??                    متفجرات          𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟                صاروخ المنجم       𝄟 \n╚═══════════════╝",--4
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--7
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U3 then else
if MH[1]== true then V1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then V2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then V3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then V4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[6]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[7]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹

--اكواد الشونه 
function U4 ()
lastMenu = U4
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                    مطرقه              𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                    مسمار               𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟                طلاء احمر             ?? \n╚═══════════════╝",--3
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--6
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝?? ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U4 then else
if MH[1]== true then A1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then A2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then A3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[5]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[6]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹

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
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--8
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--9
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U5 then else
if MH[1]== true then AA1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then AA2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then AA3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then AA4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then AA5() end -- 👹MAHMOUDHERO👹
if MH[6]== true then AA6() end -- 👹MAHMOUDHERO👹
if MH[7]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[8]== true then Home() end -- ??MAHMOUDHERO👹
if MH[9]== true then EXIT() end -- 👹MAHMOUDHERO??
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹

--المجوهرات 
function U6 ()
lastMenu = U6
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟               التوباز الاصفر         𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟               الزمرد الاخضر        𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟               الياقوت الاحمر       𝄟 \n╚═══════════════╝",--3
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--6
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U6 then else
if MH[1]== true then DD1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then DD2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then DD3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[5]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[6]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹

--الالوان
function U7 ()
lastMenu = U7
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                مطرقة ثاقبة          𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                     صنبور              𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟                       قفاز               𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟                     صاروخ             𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟                  الديناميت            𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟               كرة قوس قزح       𝄟 \n╚═══════════════╝",--6
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--8
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U7 then else
if MH[1]== true then B1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then B2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then B3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then B4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then B5() end -- 👹MAHMOUDHERO👹
if MH[6]== true then B6() end -- 👹MAHMOUDHERO👹
if MH[7]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[8]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[9]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹

--حدث متفجرات 
function U8 ()
lastMenu = U8
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                 دلو من الحلوة       𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                     القنبله              𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟                   الصاروخ            𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟                      سهم               𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟                    مكنسه              𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟                      قفل                𝄟 \n╚═══════════════╝",--6
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--8
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--9
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U8 then else
if MH[1]== true then C1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then C2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then C3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then C4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then C5() end -- 👹MAHMOUDHERO👹
if MH[6]== true then C6() end -- 👹MAHMOUDHERO👹
if MH[7]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[8]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[9]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹

--بقعة مطابقه 
function U9 ()
lastMenu = U9
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟            معزز إخلاء الشريط    𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                  معزز الزهر           𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟                 معزز التراجع        𝄟 \n╚═══════════════╝",--3
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--6
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U9 then else
if MH[1]== true then CC1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then CC2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then CC3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[5]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[6]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹

--اكواد العلف 
function U10 ()
lastMenu = U10
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                  علف أبقار            𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟                 علف دجاج           𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟                علف خروف           𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟                 غذاء النحل           𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟               طعام الخنزير          𝄟 \n╚═══════════════╝",--5
	"╔══════⟬⚜️⟭══════╗\n𝄟                     المادة               𝄟 \n╚═══════════════╝",--6
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--8
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--9
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 ?? ?? 🇴 🇺 🇩 ?? 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U10 then else
if MH[1]== true then WW1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then WW2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then WW3() end -- 👹MAHMOUDHERO👹
if MH[4]== true then WW4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then WW5() end -- 👹MAHMOUDHERO👹
if MH[6]== true then WW6() end -- 👹MAHMOUDHERO??
if MH[7]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[8]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[9]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹

--اكواد تصفير الوقت
function U11 ()
lastMenu = U11
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟  تصفير وقت المحاصيل ثابت 𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟    تصفير وقت الطائره ثابت    𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟 تصفير وقت الحيوانات ثابت  𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟     تصفير وقت البناء ثابت    𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟         زيادة الشونه ثابت         𝄟 \n╚═══════════════╝",--5
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
function U12 ()
lastMenu = U12
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟                معزز الطاقه           𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n??                معزز القنبله           𝄟 \n╚═══════════════╝",--2
    "╔══════⟬⚜️⟭══════╗\n𝄟??  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--5
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U12 then else
if MH[1]== true then W1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then W2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[5]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹

--ذهب وكاش
function U13 ()
lastMenu = U13
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟              كود الكاش              𝄟 \n╚═══════════════╝",--1
	"╔══════⟬⚜️⟭══════╗\n𝄟             كود الفلوس             𝄟 \n╚═══════════════╝",--2
	"╔══════⟬⚜️⟭══════╗\n𝄟            كود المستوى            𝄟 \n╚═══════════════╝",--3
	"╔══════⟬⚜️⟭══════╗\n𝄟         كود الكاتب الأول          𝄟 \n╚═══════════════╝",--4
	"╔══════⟬⚜️⟭══════╗\n𝄟         كود ضعف النقاط          𝄟 \n╚═══════════════╝",--5
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--6
	"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--7
	"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--8
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U13 then else
if MH[1]== true then G1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then G2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then G3() end -- ??MAHMOUDHERO👹
if MH[4]== true then G4() end -- 👹MAHMOUDHERO👹
if MH[5]== true then G5() end -- 👹MAHMOUDHERO👹
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


-- القطار 

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
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع القطارات 🟡𝄟\n╚═══════════════╝",--18
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--19
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--20
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--21
    }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n??⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

    if not MH then return end
if MH[18] then
for i = 1, 17 do _G["GGG"..i]() end
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨ تم استبدال جميع القطارات ✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
gg.sleep(4000)end

for i = 1, 17 do if MH[i] then _G["GGG"..i]() end end

if MH[19] then Mahmoud() end
if MH[20] then Home() end  
if MH[21] then EXIT() end
HERO = -1
end



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
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع المحطات🟡 𝄟\n╚═══════════════╝",--18
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--19
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--20
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--21
    }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
    
if not MH then return end
if MH[18] then
for i = 1, 17 do _G["GGGG"..i]() end
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨ تم استبدل جميع اكواد المحطات✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
gg.sleep(4000)end

for i = 1, 17 do if MH[i] then _G["GGGG"..i]() end end

if MH[19] then Mahmoud() end
if MH[20] then Home() end  
if MH[21] then EXIT() end
HERO = -1
end









--المحطه
function GG882 ()
    lastMenu = GG882
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
        "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--18
        "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--19
        "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--20
    }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== GG882 then else

 if MH[1] then GGGG1() end
 if MH[2] then GGGG2() end
 if MH[3] then GGGG3() end
 if MH[4] then GGGG4() end             
 if MH[5] then  GGGG5() end
 if MH[6] then  GGGG6() end
 if MH[7] then  GGGG7() end
 if MH[8] then  GGGG8() end
 if MH[9] then GGGG9() end       
 if MH[10] then GGGG9() end       
 if MH[11] then GGGG11() end
 if MH[12] then GGGG12() end
 if MH[13] then GGGG13() end
 if MH[14] then GGGG14() end
 if MH[15] then GGGG15() end
 if MH[16] then GGGG16() end
 if MH[17] then GGGG17() end         
if MH[18] then Mahmoud() end
if MH[19] then Home() end
if MH[20] then EXIT() end
end
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
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع المواني  🟡𝄟 \n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--21
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[18] then
for i = 1, 17 do _G["BBB"..i]() end
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨ تم استبدل جميع المواني✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
gg.sleep(4000)end

for i = 1, 17 do if MH[i] then _G["BBB"..i]() end end

if MH[19] then Mahmoud() end
if MH[20] then Home() end  
if MH[21] then EXIT() end
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
"╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار جميع المراكب 🟡𝄟 \n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--21
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[18] then
for i = 1, 17 do _G["BBBB"..i]() end
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨تم استبدال جميع المراكب✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
gg.sleep(4000)end

for i = 1, 17 do if MH[i] then _G["BBBB"..i]() end end

if MH[19] then Mahmoud() end
if MH[20] then Home() end  
if MH[21] then EXIT() end
HERO = -1
end




--اكود الطائره والمطار 
function U16 ()
lastMenu = U16
MH = gg.multiChoice({
	"╔══════⟬⚜️⟭══════╗\n𝄟            اكواد الطائره             ??\n╚═══════════════╝",--1
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
"╔══════⟬⚜️⟭══════╗\n𝄟           الطائرة الضخمة          ??\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟                تنين خارق            𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟           طائرة استوائية          𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟             طائرة الأشباح          𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟               مركبة إطلاق          𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟                 طائرة روك           𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟              طائرة النجوم          𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟               طائرة الأعياد          𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟       طائرة على شكل طائر      𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟              طائرة الإكلير           𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟              زلاجة هوائية          𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟                طائرة الحظ          𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟                 طائرة شبح          𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟                طائرة مائية          𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟           طائرة السيمفونية       𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟              طائرة الموضة         𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار جميع الطائرات🟡𝄟 \n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--20
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[17] then
for i = 1, 16 do _G["VVV"..i]() end
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨تم استبدال جميع الطائرات✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
gg.sleep(4000)end

for i = 1, 16 do if MH[i] then _G["VVV"..i]() end end

if MH[18] then Mahmoud() end
if MH[19] then Home() end  
if MH[20] then EXIT() end
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
"╔══════⟬⚜️⟭══════╗\n𝄟🟡 اختيار جميع المطارات🟡𝄟 \n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--20
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[17] then
for i = 1, 16 do _G["VVVV"..i]() end
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨تم استبدال جميع المطارات✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
gg.sleep(4000)end

for i = 1, 16 do if MH[i] then _G["VVVV"..i]() end end

if MH[18] then Mahmoud() end
if MH[19] then Home() end  
if MH[20] then EXIT() end
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
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if MH== U17 then else
if MH[1]== true then NN1() end -- 👹MAHMOUDHERO👹
if MH[2]== true then NN2() end -- 👹MAHMOUDHERO👹
if MH[3]== true then Mahmoud() end -- 👹MAHMOUDHERO👹
if MH[4]== true then Home() end -- 👹MAHMOUDHERO👹
if MH[5]== true then EXIT() end -- 👹MAHMOUDHERO👹
end -- 👹MAHMOUDHERO👹
HERO = -1
end -- 👹MAHMOUDHERO👹




--هليكوبتر
function NN1 ()
lastMenu = NN1
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟                 طبق تربو             𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟                موصل آلي            𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟                مزلقة سانتا           𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟      طائرة هليكوبتر خاصة      𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟  الطائره الهليكوبتر الباذنجانة  𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟                بساط طائر            ??\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟      طائرة على شكل أريكة      ??\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟              السفينة الطائرة        𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟    طائرة هليكوبتر دراجة        𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟  طائرة هليكوبتر قرع العسل   𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟              المرجل الطائر          𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟      طائرة هليكوبتر ريشية      𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟             قطاعة البيض           𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟      غواصة الأعماق الطائرة     𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟    طائرة هليكوبتر للقراصنة    𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟   الطائرة الهليكوبتر القرمزي   𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟طائرة الهليكوبتر لقاعة الرقص 𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟    طائرة الديسكو الهليكوبتر   𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع الهليكوبتر🟡𝄟 \n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--22
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")
if not MH then return end
if MH[19] then
for i = 1, 18 do _G["NNN"..i]() end
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨تم استبدال جميع  طائرات الهليكوبتر ✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
gg.sleep(4000)end

for i = 1, 18 do if MH[i] then _G["NNN"..i]() end end

if MH[20] then Mahmoud() end
if MH[21] then Home() end  
if MH[22] then EXIT() end
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
"╔══════⟬⚜️⟭══════╗\n𝄟     مهبط الطائرة القرمزية      𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟  مهبط طائرة لقاعة الرقص     𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟    مهبط هليكوبتر الديسكو     𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع المهابط 🟡𝄟 \n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--22
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 ?? 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

if not MH then return end
if MH[19] then
for i = 1, 18 do _G["NNNN"..i]() end
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨تم استبدال جميع مهابط الهليكوبتر ✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
gg.sleep(4000)end

for i = 1, 18 do if MH[i] then _G["NNNN"..i]() end end

if MH[20] then Mahmoud() end
if MH[21] then Home() end  
if MH[22] then EXIT() end
HERO = -1
end





--قسم الجزيرة 
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
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع الجزائر 🟡𝄟 \n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--16
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

if not MH then return end
if MH[14] then
for i = 1, 13 do _G["NNNN"..i]() end
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨تم استبدال جميع الجزائر ✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
gg.sleep(4000)end

for i = 1, 13 do if MH[i] then _G["NNNN"..i]() end end

if MH[15] then Mahmoud() end
if MH[16] then Home() end  
if MH[17] then EXIT() end
HERO = -1
end




--اكواد الإبقار
function U19 ()
lastMenu = U19
MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟            بقرة سينمائية            𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n??              البقرة القزمة            𝄟\n╚═══════════════╝",--2
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
"╔══════⟬⚜️⟭══════╗\n𝄟                     بقرة الزهور      𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟                     بقرة الزهور      𝄟\n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟🟡   اختيار جميع الأبقار  🟡𝄟 \n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--22
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--23
}, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

if not MH then return end
if MH[19] then
for i = 1, 19 do _G["COW"..i]() end
gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨تم استبدال جميع الجزائر ✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
gg.sleep(4000)end

for i = 1, 19 do if MH[i] then _G["COW"..i]() end end

if MH[12] then Mahmoud() end
if MH[22] then Home() end  
if MH[23] then EXIT() end
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
    "╔══════⟬⚜️⟭══════╗\n𝄟🟡اختيار جميع الدجاجات🟡𝄟 \n╚═══════════════╝",--18
    "╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--19
    "╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--20
    "╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--21
  }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

  if not MH then return end
  if MH[18] then
    for i = 1, 17 do _G["CHICKEN"..i]() end
    gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨تم استبدال جميع الدجاجات ✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
    gg.sleep(4000)
  end

  for i = 1, 17 do if MH[i] then _G["CHICKEN"..i]() end end

  if MH[19] then Mahmoud() end
  if MH[20] then Home() end  
  if MH[21] then EXIT() end
  HERO = -1
end


--اكواد الخرفان 
function U21()
  lastMenu = U21
  MH = gg.multiChoice({
"╔══════⟬⚜️⟭══════╗\n𝄟          النعجه الساحره            𝄟\n╚═══════════════╝",--1
"╔══════⟬⚜️⟭══════╗\n𝄟      نعجه مهرجان الربيع         𝄟\n╚═══════════════╝",--2
"╔══════⟬⚜️⟭══════╗\n𝄟         نعجه الفصح                 𝄟\n╚═══════════════╝",--3
"╔══════⟬⚜️⟭══════╗\n𝄟          خروف شمالي              𝄟\n╚═══════════════╝",--4
"╔══════⟬⚜️⟭══════╗\n𝄟         الخروف المحقق            𝄟\n╚═══════════════╝",--5
"╔══════⟬⚜️⟭══════╗\n𝄟      خروف عيد الميلاد           𝄟\n╚═══════════════╝",--6
"╔══════⟬⚜️⟭══════╗\n𝄟     خروف بانديت النبيله        𝄟\n╚═══════════════╝",--7
"╔══════⟬⚜️⟭══════╗\n𝄟         خروف السامبا              𝄟\n╚═══════════════╝",--8
"╔══════⟬⚜️⟭══════╗\n𝄟      خروف الروك اند رول       𝄟\n╚═══════════════╝",--9
"╔══════⟬⚜️⟭══════╗\n𝄟         الخروف المقاتل            𝄟\n╚═══════════════╝",--10
"╔══════⟬⚜️⟭══════╗\n𝄟      خروف عصابه الخرفان     𝄟\n╚═══════════════╝",--11
"╔══════⟬⚜️⟭══════╗\n𝄟        خروف بيلي بونكا          𝄟\n╚═══════════════╝",--12
"╔══════⟬⚜️⟭══════╗\n𝄟         خروف احتفالي            𝄟\n╚═══════════════╝",--13
"╔══════⟬⚜️⟭══════╗\n𝄟        الخراف المصريه            𝄟\n╚═══════════════╝",--14
"╔══════⟬⚜️⟭══════╗\n𝄟       خروف عيد الميلاد          𝄟\n╚═══════════════╝",--15
"╔══════⟬⚜️⟭══════╗\n𝄟       خراف قاعه الرقص         𝄟\n╚═══════════════╝",--16
"╔══════⟬⚜️⟭══════╗\n𝄟       الخروف الاسطوري         𝄟\n╚═══════════════╝",--17
"╔══════⟬⚜️⟭══════╗\n𝄟          خروف العطله              𝄟\n╚═══════════════╝",--18
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  اختيار جميع الخراف 🟡𝄟 \n╚═══════════════╝",--19
"╔══════⟬⚜️⟭══════╗\n𝄟🟣  العوده لقائمه الأكواد  🟣𝄟 \n╚═══════════════╝",--20
"╔══════⟬⚜️⟭══════╗\n𝄟🔴العوده للقائمه الرئيسيه🔴𝄟 \n╚═══════════════╝",--21
"╔══════⟬⚜️⟭══════╗\n𝄟🟡  الخروج بشكل نهائي  🟡𝄟 \n╚═══════════════╝",--22
  }, MAHMOUD, "╔══════════✦❘༻༺❘✦══════════╗\n𝄟⃝🕊 ❪ 🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴 ❫   𝄟\n╚══════════✦❘༻༺❘✦══════════╝")

  if not MH then return end
  if MH[19] then
    for i = 1, 18 do _G["SHEEP"..i]() end
    gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨تم استبدال جميع الخراف ✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
    gg.sleep(4000)
  end

  for i = 1, 18 do if MH[i] then _G["SHEEP"..i]() end end

  if MH[20] then Mahmoud() end
  if MH[21] then Home() end  
  if MH[22] then EXIT() end
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
  if MH[3] then
    for i = 1, 2 do _G["pigs"..i]() end
    gg.alert("🇪🇬 Edited by MAHMOUDHERO 🇪🇬\n✨تم استبدال جميع الخنازير ✨\n🙋Ⓜ️ هات خمسه جنيه بقا Ⓜ️🙋\n🇪🇬 Egypt Mother of the World 🇪🇬")
    gg.sleep(4000)
  end

  for i = 1, 2 do if MH[i] then _G["pigs"..i]() end end

  if MH[4] then Mahmoud() end
  if MH[5] then Home() end  
  if MH[6] then EXIT() end
  HERO = -1
end

----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
-- كود جديد تحت التجربه 
function F1 ()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)

gg.searchNumber("1937011470;1701998435", gg.TYPE_DWORD)
gg.refineNumber("1937011470", gg.TYPE_DWORD)

local results = gg.getResults(gg.getResultCount())
if #results == 0 then
    gg.alert("الكود لا يعمل تحدث مع مطور الاسكربت وأرسل صوره")
    return
end

local success = false

for i, v in ipairs(results) do
    local off24 = gg.getValues({{address = v.address + 24, flags = gg.TYPE_DWORD}})[1]
    local off36 = gg.getValues({{address = v.address + 36, flags = gg.TYPE_DWORD}})[1]

    if off24.value and off36.value then
        local val24 = math.abs(off24.value)
        local val36 = math.abs(off36.value)

        local str24 = tostring(val24)
        local str36 = tostring(val36)

        local len24 = #str24
        local len36 = #str36

        local validLength =
            (len24 == 3 or len24 == 4) and
            (len36 == 3 or len36 == 4)

        local sameValue = (val24 == val36)

        if validLength and sameValue then
            gg.setValues({
                {address = v.address + 232, flags = gg.TYPE_QWORD, value = 5000},
                {address = v.address + 248, flags = gg.TYPE_DWORD, value = 1}
            })
            success = true
        end
    end
end

if success then
    gg.alert("🤡مبروك فتح التذكره الذهبيه🤡")
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
else
    gg.alert("للاسف لم يتم التحقق من اي شي تحدث مع مطور الاسكربت")
end

gg.clearList()
gg.clearResults()
end --👹تم الانتهاء👹



function F1 ()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber("1937011470;1701998435", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.refineNumber("1937011470", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
local results = gg.getResults(gg.getResultCount())
if #results == 0 then
gg.alert("الكود لا يعمل تحدث مع مطور الاسكربت وأرسل صوره")
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
          
gg.setValues({{address = v.address + 232, flags = gg.TYPE_QWORD, value = 5000},
{address = v.address + 248, flags = gg.TYPE_DWORD, value = 1}})
success = true
end
end
end
if success then
gg.alert("🤡مبروك فتح التذكره الذهبيه🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
else
gg.alert("للاسف لم يتم التحقق من اي شي تحدث مع مطور الاسكربت")
end
gg.clearList()
 gg.clearResults()
 end --👹تم الانتهاء👹
 
 
--كود التصريح القديم  الصقل هنا علي تاني رقم 
    function Fh1 ()
    gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.clearResults()
    gg.setVisible(false)
    gg.setRanges(gg.REGION_C_ALLOC)
    gg.searchNumber("1937011470;1701998435;49::257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.refineNumber("1701998435", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    n = gg.getResultCount()
    jz = gg.getResults(n)
    local messageShown = false 
    local toastShown = false

        for i = 1, n do
        gg.addListItems({[1] = {address = jz[i].address + 228, flags = gg.TYPE_QWORD, freeze = true, value = "5000", gg.TYPE_QWORD}})
        gg.addListItems({[1] = {address = jz[i].address + 244, flags = gg.TYPE_DWORD, freeze = true, value = "1", gg.TYPE_DWORD}})
        end 

    gg.clearResults()
    gg.searchNumber("1937011470;1701998435;-1;1819042054:641", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.refineNumber("1701998435", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    n = gg.getResultCount()
    jz = gg.getResults(n)

         for i = 1, n do
        gg.addListItems({[1] = {address = jz[i].address + 228, flags = gg.TYPE_QWORD, freeze = true, value = "5000", gg.TYPE_QWORD}})
        gg.addListItems({[1] = {address = jz[i].address + 244, flags = gg.TYPE_DWORD, freeze = true, value = "1", gg.TYPE_DWORD}})

        if not messageShown then
        if not toastShown then
        gg.alert("🤡مبروك فتح التذكره الذهبيه🤡")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍??🔥🏴‍☠️")
        toastShown = true
        messageShown = true 
        end 
        end
        end
    gg.clearList()
    gg.clearResults()
       end -- 👹تم الانتهاء👹



--زياده المستوى من الزراعة 
function F2 ()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber('1701345046;1935635553;1819042157;1919902484;1836277614;7105633', gg.TYPE_DWORD) --gg.searchNumber('16842753;1919902484;1836277614;7105633', gg.TYPE_DWORD)
gg.refineNumber('7105633', gg.TYPE_DWORD)
n = gg.getResultCount()
gg.toast(n)
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
local M12 = gg.prompt({" 🇪🇬Edited by MAHMOUDHERO🇪🇬".."\n🇪🇬 Egypt mother of the world 🇪🇬\n"},{[1]="\n🙋اكتب الرقم الذي تريده🙋\n"},nil,{'number'})
if M12 == nil then
else
end
if M12[1] ==nil then
else
end
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 72,flags = gg.TYPE_DWORD,freeze = true,value = 0}})
gg.addListItems({[1] = {address = jz[i].address + 88,flags = gg.TYPE_QWORD,freeze = true,value = M12[1],gg.TYPE_QWORD}})
if not messageShown then
if not toastShown then
gg.alert("🤡كل ما تفعله ازرع الذرة واحصده🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊??🏴‍☠️")
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
    gg.setRanges(gg.REGION_C_ALLOC)
    gg.searchNumber('1885433110;1852403807;1684105299', gg.TYPE_DWORD)
    gg.refineNumber('1885433110', gg.TYPE_DWORD)
    local refinedResults = gg.getResults(1)
    if #refinedResults == 0 then
        gg.alert("🤡الكود لا يعمل تحدث مع مطور الاسكربت🤡")
        return
    end

    local baseAddress = refinedResults[1].address

    local currentValues = gg.getValues({
        {address = baseAddress - 216, flags = gg.TYPE_QWORD},
        {address = baseAddress - 208, flags = gg.TYPE_QWORD},
        {address = baseAddress - 200, flags = gg.TYPE_QWORD}
    })

    
    local input = gg.prompt({[1] = "🇪🇬Edited by MAHMOUDHERO🇪🇬", [2] = "🇪🇬Edited by MAHMOUDHERO🇪🇬", [3] = "🇪🇬Edited by MAHMOUDHERO🇪🇬"},{[1] = "\n🤡زيادة الذهب🤡\n", [2] = "\n🤡زياده الدولارات 🤡\n", [3] = "\n🤡زياده المستوى🤡\n"},nil, {'number', 'number', 'number'})

    if not input then
        gg.alert("🤡لا يتم تعديل اي شيء🤡")
        return
    end

    
    gg.setValues({
        {address = baseAddress - 216, flags = gg.TYPE_QWORD, value = tonumber(input[1]) or currentValues[1].value},
        {address = baseAddress - 208, flags = gg.TYPE_QWORD, value = tonumber(input[2]) or currentValues[2].value},
        {address = baseAddress - 200, flags = gg.TYPE_QWORD, value = tonumber(input[3]) or currentValues[3].value}
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
gg.setRanges(gg.REGION_C_ALLOC)
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
gg.setRanges(gg.REGION_C_ALLOC)
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
gg.setRanges(gg.REGION_C_ALLOC)
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
gg.setRanges(gg.REGION_C_ALLOC)
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
gg.toast("الكود لا يعمل تحدث مع المطور" .. tostring(code))
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



--وقت المسبك
function F6()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("1869759002;1163984896;1172373504;1177075712;1180762112", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1163984896;1172373504;1177075712;1180762112", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
revert = gg.getResults(100, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll("1", gg.TYPE_DWORD)
gg.processResume()
gg.alert("🤡مبروك عليك تصفير وقت المسبك مؤقت🤡")
gg.toast("❤️لا تنسي الصلاة علي النبي❤️")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.clearList() 
end


--تصفير طلبات الطائره
function F7()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
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



--وقت الطائره 
function F8()
gg.toast("❤️لا تنسي الصلاة علي النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("18000;54000;18000;54000::117", gg.TYPE_DWORD)
gg.refineNumber("18000", gg.TYPE_DWORD)
n = gg.getResultCount()
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 4,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearResults()
gg.alert("🤡 مبروك عليك تصفير وقت الطائره وارسالها بدون تعبئة الصندوق 🤡")
gg.alert(" الاستفادة من هذا زياده العدد في الملف التعرفي كل ما عليك تشغيل برنامج النقر التلقائي ")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
end
end

--الشونه 
function F9 ()
    gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.clearResults()
    gg.setVisible(false)
    gg.setRanges(gg.REGION_C_ALLOC)
    gg.searchNumber("50;1;70;2;90;3;110;4::113", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.refineNumber("50", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)

    
    local startOffset = gg.getResults(1)[1].address 
    local endOffset = startOffset + 0xC4C

    
    local modifications = {}
    for offset = 0, 0xC4C, 4 do 
        table.insert(modifications, {
            address = startOffset + offset,
            flags = gg.TYPE_DWORD,
            value = 0
        })
    end

    gg.setValues(modifications)
    
gg.alert("  هناك حظر في ترقيه الشونه بشكل سريع يجب أن تكون بطئ جدا في تريقه الشونه تم التفعيل اذهب الان وقم برفع الشونه")
gg.alert("وانت تقوم بعمل زيادة الشونه سوف يظهر الرقم 0 في كل مره ليس هناك مشكله عند إغلاق اللعبه وفتحها سوف يظهر كل شي طبيعي")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.clearList() 
end -- 👹MAHMOUDHERO👹


--المباني المجتمعيه 
function F10()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber('1634554642;2037666572;2;2:293', gg.TYPE_DWORD)
gg.refineNumber("2037666572", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 604,flags = gg.TYPE_FLOAT,freeze = true,value = 0}})
gg.addListItems({[1] = {address = jz[i].address - 608,flags = gg.TYPE_DWORD,freeze = true,value = 0}})
gg.addListItems({[1] = {address = jz[i].address - 612,flags = gg.TYPE_DWORD,freeze = true,value = 0}})
gg.addListItems({[1] = {address = jz[i].address - 616,flags = gg.TYPE_DWORD, freeze = true,value = 0}})
gg.alert("🤡اذهب الان وافتح جميع المباني المجتمعيه🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.clearList() 
end -- 👹MahmoudHeRo👹
end




function F11()
    gg.alert("لحظه من فضلك يجب فتح قائمه شروط التوسيع حتي يعمل الكود... انتظر حتي ينتهي البرنامج من البحث ويظهر رساله اخري")
    gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.clearResults()
    gg.setVisible(false)

    -- البحث والصقل
    gg.searchNumber("384;385:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    gg.refineNumber("385", gg.TYPE_DWORD)

    local results = gg.getResults(gg.getResultCount())
    if #results < 1 then
        gg.toast('🤡MAHMOUDHERO🤡')
        gg.alert("🚫 لم يتم العثور على أي نتيجة، تأكد من فتح قائمة شروط التوسيع")
        return
    end

    -- دالة تتحقق من أن القيمة رقم صحيح وعدد أرقامه 8 أو 9 أو 10
    local function isValidNumber(v)
        if v == nil or type(v) ~= "number" then return false end
        
        -- استخدام القيمة المطلقة للتخلص من الإشارة السالبة
        local absoluteValue = math.abs(v)
        local numString = tostring(absoluteValue)
        local length = #numString
        
        return (length == 8 or length == 9 or length == 10)
    end

    -- جمع النتائج الصالحة
    local validResults = {}
    for i, r in ipairs(results) do
        -- الحصول على القيم عند الأوفيس 4 و 8
        local val4 = gg.getValues({{address = r.address + 4, flags = gg.TYPE_DWORD}})[1].value
        local val8 = gg.getValues({{address = r.address + 8, flags = gg.TYPE_DWORD}})[1].value

        -- التحقق من الشروط
        if isValidNumber(val4) and isValidNumber(val8) then
            table.insert(validResults, r)
        end
    end

    if #validResults == 0 then
        gg.alert("🚫 لم يتم العثور على أي نتيجة تحقق الشروط المطلوبة")
        gg.alert("💡 تأكد من فتح قائمة شروط التوسيع ثم حاول مرة أخرى")
        return
    end

    -- إعداد حساب الوقت
    local totalOffsets = #validResults * ((0x7070 / 4) + (0x68 / 4))
    local completedOffsets = 0
    local totalDuration = 60
    local lastToastTime = os.time() - 7 -- لجعل أول toast يظهر فوراً

    -- معالجة كل نتيجة صالحة
    for i, r in ipairs(validResults) do
        -- تعديل من الأوفيس 0 إلى -8000
        for offset = 0, -0x7070, -4 do
            gg.setValues({{address = r.address + offset, flags = gg.TYPE_DWORD, value = 0}})
            completedOffsets = completedOffsets + 1
            
            -- عرض الرسالة كل 7 ثواني بدقة
            local currentTime = os.time()
            if currentTime - lastToastTime >= 7 then
                local remainingTime = totalDuration * (totalOffsets - completedOffsets) / totalOffsets 
                gg.toast("انتظر باقي " .. math.ceil(remainingTime) .. " ثانية هات خمسه جنيه")
                lastToastTime = currentTime
            end
        end

        -- تعديل من الأوفيس 0 إلى +68
        for offset = 0, 0x68, 4 do
            gg.setValues({{address = r.address + offset, flags = gg.TYPE_DWORD, value = 0}})
            completedOffsets = completedOffsets + 1
            
            -- عرض الرسالة كل 7 ثواني بدقة
            local currentTime = os.time()
            if currentTime - lastToastTime >= 7 then
                local remainingTime = totalDuration * (totalOffsets - completedOffsets) / totalOffsets 
                gg.toast("انتظر باقي " .. math.ceil(remainingTime) .. " ثانية هات خمسه جنيه")
                lastToastTime = currentTime
            end
        end
    end

    

    gg.alert("🤡تم التفعيل اذهب الي المدينه وقم بتوسيعها🤡")
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
end

--القديم 
--توسيع المدينه 
function F1881()
gg.alert("لحظه من فضلك يجب فتح قائمه شروط التوسيع حتي يعمل الكود يمكن توسيع المدينه بالكامل بدون الحاجه الي قسائم التوسع او كود وقت البناء يجب الانتظار حتي ينتهي البرنامج من البحث ويظهر رساله اخري بتفعيل كل شي سوف يأخذ وقت دقيقه او اقل من دقيقه لاظهار الرساله الاخري")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.searchNumber('1634554642;1886930200;110::173', gg.TYPE_DWORD) 
gg.refineNumber('1886930200', gg.TYPE_DWORD)
local results = gg.getResults(1)  
if #results < 1 then
gg.toast('🤡MAHMOUDHERO🤡')
return
end
local totalOffsets = 0x7000 / 0x4 + 1 
local completedOffsets = 0  
local totalDuration = 60  
local updateInterval = 15
for i, result in ipairs(results) do
result.address = result.address - 96 
local pointerAddress = gg.getValues({{address = result.address, flags = gg.TYPE_QWORD}})[1].value      
gg.addListItems({{address = pointerAddress, flags = gg.TYPE_QWORD, value = pointerAddress}})
for offset = 0x4, 0x7000, 0x4 do
local currentAddress = pointerAddress + offset
gg.setValues({{address = currentAddress, flags = gg.TYPE_DWORD, value = 0}})
completedOffsets = completedOffsets + 1
if completedOffsets % (updateInterval / (0.7)) == 0 then
local remainingTime = totalDuration * (totalOffsets - completedOffsets) / totalOffsets 
gg.toast("انتظر باقي" .. math.ceil(remainingTime) .. "ثانية")
end
end
end
gg.clearResults()
gg.clearList()
gg.alert("🤡تم التفعيل اذهب الي المدينه وقم بتوسيعها🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
end


--تصفير وقت المركب
function F12()
gg.alert("جاري العمل عليها او ارسل صوره للمطور لتذكره")
 end

--صندوق المصانع 
function F13()
gg.alert("🤡يجب فتح اي مصنع قبل عمليه البحث حتي يتم التفعيل🤡")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("1088421888;8;127;62;2037666582", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("127", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.processResume()
n = gg.getResultCount()
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 4 ,flags = 4,freeze = true,value = 0}})
gg.alert("🤡اذهب الان لفتح جميع صنديق المصانع🤡")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
end -- 👹MahmoudHeRo👹
end

--صندوق السوق 
function F14 ()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber('1953063700;1133510656;1199382528;1185464320', gg.TYPE_DWORD)
gg.refineNumber('1199382528', gg.TYPE_DWORD)
n = gg.getResultCount()
gg.toast(n)
jz = gg.getResults(n)
local M12 = gg.prompt({"🇪🇬Edited by MAHMOUDHERO🇪🇬".."\n🇪🇬 Egypt mother of the world 🇪🇬\n"},{[1]="\n🙋اكتب الرقم الذي تريده🙋\n"},nil,{'number'})
if M12 == nil then
else
end
if M12[1] ==nil then
else
end
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 144,flags = gg.TYPE_QWORD,freeze = true,value = M12[1],gg.TYPE_QWORD}})
gg.alert("🤡مبروك عليك زياده عدد صناديق السوق🤡")
gg.clearResults()
gg.clearList() 
end
end
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------
----------🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡----------

--قسم حديقه الحيوانات 
--حيوانات السافانا
function H1()
gg.alert("🤡 تنزيل كل يوم قسم من اقسام الحيوانات لتجنب الحظر 🤡")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
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
gg.setRanges(gg.REGION_C_ALLOC)
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
gg.setRanges(gg.REGION_C_ALLOC)
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
gg.setRanges(gg.REGION_C_ALLOC)
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
gg.alert("🤡 تنزيل كل يوم قسم من اقسام الحيوانات لتجنب الحظر 🤡")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
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
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
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
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
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
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
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
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
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
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- قسم حدث المتفجرات

-- دلو حلوي حدث المتفجرات
function C1()
return { values = {1952541994, 1395877987, 1953653108, 1869377347, 1952533874, 26723}, name = "دلو حلوي حدث المتفجرات" }end
-- قنبلة حدث المتفجرات
function C2()
return { values = {1952541990, 1395877987, 1953653108, 1651339074, 1819242324, 0}, name = "قنبلة حدث المتفجرات" }end
-- صاروخ حدث المتفجرات
function C3()
return { values = {1952541982, 1395877987, 1953653108, 1701734732, 0, 0}, name = "صاروخ حدث المتفجرات" }end
-- سهم حدث المتفجرات
function C4()
return { values = {1952541978, 1211328611, 1766617711, 25966, 0, 0}, name = "سهم حدث المتفجرات" }end
-- مكنسة حدث المتفجرات
function C5()
return { values = {1952541976, 1211328611, 1701670241, 114, 0, 0}, name = "مكنسة حدث المتفجرات" }end
-- قفل حدث المتفجرات
function C6()
return { values = {1323877082, 1319921361, 1322424549, 1187699712, 0, 0}, name = "قفل حدث المتفجرات" }end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- قسم بقعة مطابقة

-- معزز اخلاء نشط
function CC1()
return { values = {1852144168, 1668571469, 1869562472, 1750299763, 1818650229, 101}, name = "معزز اخلاء نشط" }end
-- معزز الزهر
function CC2()
return { values = {1852144172, 1668571469, 1869562472, 1816360051, 1400004965, 7630700}, name = "معزز الزهر" }end
-- معزز التراجع
function CC3()
return { values = {1852144162, 1668571469, 1869562472, 1851094131, 28516, 0}, name = "معزز التراجع" }end
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
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
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
gg.alert("اذهب اولا وعليك استلام صوره الايموجي اضغط حسنا واسرع في الاستلام")
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 


gg.clearResults()
gg.searchNumber("1869440276;1935632746;2::33", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1869440276", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("الكود لا يعمل تحدث مع مطور الاسكربت لتحديث الكود")
  gg.clearResults()
  gg.clearList()
  return
end
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
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1599099688",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1936682818",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1701860212",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1884644453",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1836212550",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "115",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 536,flags = gg.TYPE_QWORD,freeze = true,value = "100",gg.TYPE_QWORD}})
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي العدد المطلوب")
gg.toast("❤️لا تنسي الصلاة على النبي❤️")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
  gg.clearList()
end -- 👹تم الانتهاء👹
end

--البناء
function WWW4()
applyStatue({1113542739, 1953722223, 1701146707, 1114658148, 1684826485, 1936158313, 0, 0, 24}, "تصفير البناء", true)end
--الشونه
function WWW5()
applyStatue({1113542739, 1953722223, 1919906899, 1130719073, 1667330145, 7959657, 0, 0, 23}, "زيادة الشونه", true)end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
-- قسم العناصر العامة

-- الطاقة
function W1()
return { values = {1886938400, 1953064037, 1164865385, 1735550318, 121, 0}, name = "الطاقة" }end
-- القنبلة
function W2()
return { values = {1886938394, 1953064037, 1416523625, 21582, 0, 0}, name = "القنبلة" }end
-- الكاش
function G1()
return { values = {1935762184, 104, 0, 0, 0, 0}, name = "الكاش" }end
-- الفلوس
function G2()
return { values = {1768907530, 29550, 0, 0, 0, 0}, name = "الفلوس" }end
-- المستوي
function G3()
return { values = {1886938374, 0, 0, 0, 0, 0}, name = "المستوى" }end
-- كود الكتاب الاول
function G4()
return { values = {1635021594, 1600484724, 1953067639, 29285, 0, 0}, name = "الكتاب الأول" }end
-- ضعف النقاط
function G5()
return { values = {1835619372, 1850041445, 2037672308, 1635214674, 1816224882, 3299436}, name = "ضعف النقاط" }end
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪
--🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪🇾🇪

-- اكواد القطار 

-- قسم قطارات السكك الحديدية
-- قطار فائق السرعة
function GGG1()
applyTicket({1768641308, 1918132078, 1601071457, 3297363, 0, 0}, "قطار فائق السرعة")end
-- قطار الأشباح
function GGG2()
applyTicket({1768641308, 1918132078, 1601071457, 3493971, 0, 0}, "قطار الأشباح")end
-- قطار الديسكو
function GGG3()
applyTicket({1768641308, 1918132078, 1601071457, 3690579, 0, 0}, "قطار الديسكو")end
-- قطار رعاة البقر
function GGG4()
applyTicket({1768641316, 1918132078, 1601071457, 1953719671, 7238245, 0}, "قطار رعاة البقر")end
-- قطار الكريسماس
function GGG5()
applyTicket({1768641320, 1918132078, 1601071457, 1769105507, 1634563187, 115}, "قطار الكريسماس")end
-- قطار عيد الفصح
function GGG6()
applyTicket({1768641314, 1918132078, 1601071457, 1953718629, 29285, 0}, "قطار عيد الفصح")end
-- قطار بدائي سريع
function GGG7()
applyTicket({1768641324, 1918132078, 1601071457, 1751478896, 1869902697, 6515058}, "قطار بدائي سريع")end
-- قطار مسرحي سريع
function GGG8()
applyTicket({1768641322, 1918132078, 1601071457, 1634035828, 1667854964, 27745}, "قطار مسرحي سريع")end
-- قطار التنين
function GGG9()
applyTicket({1768641324, 1918132078, 1601071457, 1634628972, 844713586, 3289648}, "قطار التنين")end
-- مسبار المريخ
function GGG10()
applyTicket({1768641310, 1918132078, 1601071457, 1936875885, 0, 0}, "مسبار المريخ")end
-- قطار العربة الخشبية
function GGG11()
applyTicket({1768641320, 1918132078, 1601071457, 1768058738, 1869564014, 100}, "قطار العربة الخشبية")end
-- قطار الموسيقى السريع
function GGG12()
applyTicket({1768641320, 1918132078, 1601071457, 1801678706, 1819243118, 108}, "قطار الموسيقى السريع")end
-- قطار الفرسان
function GGG13()
applyTicket({1768641314, 1918132078, 1601071457, 1734962795, 29800, 0}, "قطار الفرسان")end
-- قطار الترام السريع
function GGG14()
applyTicket({1768641320, 1918132078, 1601071457, 1818326121, 842019449, 52}, "قطار الترام السريع")end
--قطار الهالوين 
function GGG15()
applyStatue({1852402515, 1634882655, 1751084649, 1869376609, 1852138871, 875704370, 0, 0, 24}, "قطار الهاليون")end
--قطار عيد الميلاد 
function GGG16()
applyStatue({1852402515, 1634882655, 1667198569, 1936290408, 1935764852, 875704370, 0, 0, 24}, "قطار عيد الميلاد")end
-- قطار الزهور
function GGG17()
applyTicket({1768641318, 1918132078, 1601071457, 1953719654, 1818326633, 0}, "قطار الزهور")end

--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡

 --اكواد المحطه 

--بوابه القطار السريع 
function GGGG1()
applyTicket({176641322, 1918132078, 1399744865, 1769234804, 1398763119, 12880}, "بوابة القطار السريع")end
-- محطة الاشباح
function GGGG2()
applyTicket({1768641322, 1918132078, 1399744865, 1769234804, 1398763119, 13648}, "محطة الأشباح")end
-- محطة الديسكو
function GGGG3()
applyTicket({1768641322, 1918132078, 1399744865, 1769234804, 1398763119, 14416}, "محطة الديسكو")end
--محطه رعاة البقر
function GGGG4()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1702322030, 1919251571, 0, 0, 25}, "محطه رعاة البقر")end
--محطه الكريسماس 
function GGGG5()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1751342958, 1953720690, 7561581, 0, 27}, "محطه الكريسماس")end
--محطه عيد الفصح 
function GGGG6()    
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1634033518, 1919251571, 24}, "محطة عيد الفصح")end
--مستوطنة قديمة
function GGGG7()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1919967086, 1936287845, 1769107316, 99, 29}, "مستوطنة قديمة")end
-- محطة مسرحية
function GGGG8()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1752457070, 1920229733, 1818321769, 28160, 28}, "محطة مسرحية")end
-- محطة صينية
function GGGG9()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1970036590, 1316118894, 842019417, 50, 29}, "محطة صينية")end
--محطه فضاء
function GGGG10()
applyTicket({1768641324, 1918132078, 1399744865, 1769234804, 1834970735, 7565921}, "محطه فضاء")end
-- معسكر التدريب
function GGGG11()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1869766510, 1215195490, 6582127, 0, 27}, "معسكر التدريب")end
-- مركز التسجيل
function GGGG12()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1869766510, 1919839075, 7105647, 0, 27}, "مركز التسجيل")end
-- محطة القلعة
function GGGG13()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1852530542, 1952999273, 24}, "محطة القلعة")end
-- محطة رومانية
function GGGG14()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1953062766, 846818401, 3420720, 0, 27}, "محطة رومانية")end
-- محطة الهالوين
function GGGG15()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1634230126, 2003790956, 846095717, 3420720, 31}, "محطة الهالوين")end
-- محطة عيد الميلاد
function GGGG16()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1751342958, 1953720690, 846422381, 3420720, 31}, "محطة عيد الميلاد")end
-- محطة الزهور
function GGGG17()
applyStatue({1852402515, 1634882655, 1951624809, 1869182049, 1701207918, 1986622579, 27745, 0, 26}, "محطة الزهور")end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??🤡

--اكواد الميناء 

--ميناء القرصان
function BBB1()
applyTicket({1768641310, 1632132974, 1919902322, 827609951, 0, 0}, "ميناء القرصان")end
--ميناء إستوائي
function BBB2()
applyTicket({1768641310, 1632132974, 1919902322, 961565535, 0, 0}, "ميناء إستوائي")end
--ميناء جميل
function BBB3()
applyTicket({1768641314, 1632132974, 1919902322, 1918988383, 29545, 0}, "ميناء جميل")end
--رصيف اللورد
function BBB4()
applyTicket({1768641316, 1632132974, 1919902322, 1852143199, 6644585, 0}, "رصيف اللورد")end
--ميناء الأهوال
function BBB5()
applyStatue({1852402515, 1918978143, 1601335138, 1819042152, 1701148527, 842019438, 1031012402, 573976866, 25}, "ميناء الأهوال")end
--ميناء الرومانسية
function BBB6()
applyStatue({1852402515, 1918978143, 1601335138, 1701601654, 1852404846, 1631875941, 32112761, 25}, "ميناء الرومانسيه")end
--ميناء الفايكينج
function BBB7()
applyTicket({1768641322, 1632132974, 1919902322, 1919905375, 1197697380, 25711}, "ميناء الفايكينج")end
--ميناء الغابة
function BBB8()
applyTicket({1768641316, 1632132974, 1919902322, 1853188703, 6646887, 0}, "ميناء الغابة")end
--ميناء الكريسماس
function BBB9()
applyStatue({1852402515, 1918978143, 1601335138, 1769105507, 1634563187, 842019443, 25}, "ميناء الكريسماس")end
--ميناء الفوانيس
function BBB10()
applyTicket({1768641310, 1632132974, 1919902322, 1498301279, 0, 0}, "ميناء الفوانيس")end
--ميناء قديم
function BBB11()
applyTicket({1768641316, 1632132974, 1919902322, 1818585183, 7561580, 0}, "ميناء قديم")end
--صالون على الماء
function BBB12()
applyStatue({1852402515, 1918978143, 1601335138, 1684826487, 1953719671, 875704370, 24}, "صالون علي الماء")end
--ميناء الحلوى
function BBB13()
applyStatue({1852402515, 1918978143, 1601335138, 1953655138, 2036425832, 875704370, 24}, "ميناء الحلوي")end
--الميناء ذو الطابع المصري
function BBB14()
applyTicket({1768641314, 1632132974, 1919902322, 2036819295, 29808, 0}, "الميناء ذو الطابع المصري")end
--ميناء القطب الشمالي
function BBB15()
applyTicket({1768641316, 1632132974, 1919902322, 1668440415, 6515060, 0}, "ميناء القطب الشمالي")end
--ميناء العطله
function BBB16()
applyStatue({1852402515, 1918978143, 1601335138, 1768713313, 1970037614, 1702259059, 892481586, 28}, "ميناء العطله")end
--ميناء ياباني 
function BBB17()
applyTicket({1768641314, 1632132974, 1919902322, 1885432415, 28257, 0}, "الميناء الياباني")end

--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡??
--اكواد السفن 

--سفينة القرصان
function BBBB1()
applyTicket({1768641306, 1750294382, 1398763625, 12628, 0, 0}, "سفينة القرصان")end
--سفينة سياحية
function BBBB2()
applyTicket({1768641306, 1750294382, 1398763625, 14672, 0, 0}, "سفينة سياحية")end
--عبارة كرواسون 
function BBBB3()
applyTicket({1768641310, 1750294382, 1885302889, 1936290401, 0, 0}, "عبارة كرواسون")end
--جندول
function BBBB4()
applyTicket({1768641312, 1750294382, 1958699185, 1667853925, 101, 0}, "جندول")end
--سفينه الأشباح 
function BBBB5()
applyStatue({1852402515, 1768444767, 1634230128, 2003790956, 846095717, 3289648, 23}, "سفينه الاشباح")end
--قارب الحب 
function BBBB6()
applyStatue({1852402515, 1768444767, 1635147632, 1953391980, 1936027241, 7954756}, "قارب الحب")end
--سفينه قويه
function BBBB7()
applyTicket({1768641318, 1750294382, 1851748457, 1768190575, 1685014371, 0}, "سفينه قويه")end
--سفينه سياحيه 
function BBBB8()
applyTicket({1768641312, 1750294382, 1784639593, 1818717813, 101, 0}, "سفينه سياحيه")end
--قارب الهدايا 
function BBBB9()
applyStatue({1852402515, 1768444767, 1751342960, 1953720690, 846422381, 3355184, 23}, "قارب الهدايا")end
--قارب التنين
function BBBB10()
applyTicket({1768641306, 1750294382, 1130328169, 22862, 0, 0}, "قارب التنين")end
--سفينه يونانية 
function BBBB11()
applyTicket({1768641312, 1750294382, 1751085161, 1634495589, 115, 0}, "سفينه يونانية")end
--باخره نهريه
function BBBB12()
applyTicket({1768641324, 1750294382, 2002743401, 2003070057, 846492517, 3420720}, "باخره نهريه")end
--قارب الحلولي
function BBBB13()
applyTicket({1768641324, 1750294382, 1650421865, 1752461929, 846815588, 3420720}, "قارب الحلولي")end
--سفينه ذات الطابع المصري 
function BBBB14()
applyTicket({1768641310, 1750294382, 1700753513, 1953528167, 0, 0}, "سفينه ذات الطابع المصري")end
--سفينه القطب الشمالي 
function BBBB15()
applyTicket({1768641312, 1750294382, 1633644649, 1769235314, 99, 0}, "سفينه القطب الشمالي")end
--سفينة العطلة
function BBBB16()
applyStatue({1852402515, 1768444767, 1818320752, 1668180332, 1769174380, 808609142, 0, 26}, "سفينة العطلة")end
--السفينة اليابانية
function BBBB17()
applyTicket({1768641310, 1750294382, 1784639593, 1851879521, 0, 0}, "السفينة اليابانية")end

--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡

--اكواد الطائره والمطار 

--اكواد الطائره 

--الطائرة الضخمة
function VVVV1()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641314",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634496626",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1398760814",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "13136",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end





--تنين خارق
function VVVV2()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634496626",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1398760814",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "842676048",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--طائرة استوائية
function VVVV3()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641314",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634496626",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1398760814",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "14672",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


--طائرة الأشباح
function VVVV4()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
local jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end

gg.clearResults()
gg.searchNumber('49;29;1768641314;14672:185', gg.TYPE_DWORD)
gg.refineNumber('29', gg.TYPE_DWORD)
local results = gg.getResults(5)
 if #results < 1 then
return
end

 local res = results[1].address
 local temp1_value = gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value
 local temp2_value = gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
 gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
return
end
res = results[1].address
gg.setValues({{address = res + 512, flags = gg.TYPE_DWORD, value = 33}})
 local changes = {
{offset = 516, value = 0},
{offset = 520, value = 29},
{offset = 524, value = 0},
{offset = 528, value = temp1_value},
{offset = 532, value = temp2_value}
 }
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
gg.clearResults()
gg.clearList()

 if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
 shownAlert = true 
end
end


--مركبة إطلاق
function VVVV5()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634496626",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1935631726",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1701011824",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


--طائرة روك
function VVVV6()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641316",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634496626",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1918854510",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "7037807",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


--طائرة النجوم
function VVVV7()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634496626",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1834968430",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1701410415",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


--طائرة الأعياد
function VVVV8()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
local jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('33;27;1768641318;1952802167:145', gg.TYPE_DWORD)
gg.refineNumber('27', gg.TYPE_DWORD)
local results = gg.getResults(5)
 if #results < 1 then
return
end

 local res = results[1].address
 local temp1_value = gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value
 local temp2_value = gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
 gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
return
end
res = results[1].address
gg.setValues({{address = res + 512, flags = gg.TYPE_DWORD, value = 33}})
 local changes = {
{offset = 516, value = 0},
{offset = 520, value = 27},
{offset = 524, value = 0},
{offset = 528, value = temp1_value},
{offset = 532, value = temp2_value}
 }
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
gg.clearResults()
gg.clearList()

 if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
 shownAlert = true 
end
end


--طائرة على شكل طائر
function VVVV9()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
local jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('33;24;1768641318;1952802167:81', gg.TYPE_DWORD)
gg.refineNumber('24', gg.TYPE_DWORD)
local results = gg.getResults(5)
 if #results < 1 then
return
end

 local res = results[1].address
 local temp1_value = gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value
 local temp2_value = gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
 gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
return
end
res = results[1].address
gg.setValues({{address = res + 512, flags = gg.TYPE_DWORD, value = 33}})
 local changes = {
{offset = 516, value = 0},
{offset = 520, value = 24},
{offset = 524, value = 0},
{offset = 528, value = temp1_value},
{offset = 532, value = temp2_value}
 }
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
gg.clearResults()
gg.clearList()

 if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
 shownAlert = true 
end
end

--طائرة الإكلير
function VVVV10()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634496626",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1935631726",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1952802167",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--زلاجة هوائية
function VVVV11()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
local jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('33;25;1768641322;25710:85', gg.TYPE_DWORD)
gg.refineNumber('25', gg.TYPE_DWORD)
local results = gg.getResults(5)
 if #results < 1 then
return
end

 local res = results[1].address
 local temp1_value = gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value
 local temp2_value = gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
 gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
return
end
res = results[1].address
gg.setValues({{address = res + 512, flags = gg.TYPE_DWORD, value = 33}})
 local changes = {
{offset = 516, value = 0},
{offset = 520, value = 25},
{offset = 524, value = 0},
{offset = 528, value = temp1_value},
{offset = 532, value = temp2_value}
 }
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
gg.clearResults()
gg.clearList()

 if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
 shownAlert = true 
end
end

--طائرة الحظ
function VVVV12()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634496626",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1767859566",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1634493810",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "25710",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐??𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


--طائرة شبح
function VVVV13()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641314",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634496626",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1935631726",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "31088",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


--طائرة مائية
function VVVV14()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
local jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('33;26;1768641314;14160:81', gg.TYPE_DWORD)
gg.refineNumber('26', gg.TYPE_DWORD)
local results = gg.getResults(5)
 if #results < 1 then
return
end

 local res = results[1].address
 local temp1_value = gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value
 local temp2_value = gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
 gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
return
end
res = results[1].address
gg.setValues({{address = res + 512, flags = gg.TYPE_DWORD, value = 33}})
 local changes = {
{offset = 516, value = 0},
{offset = 520, value = 26},
{offset = 524, value = 0},
{offset = 528, value = temp1_value},
{offset = 532, value = temp2_value}
 }
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
gg.clearResults()
gg.clearList()

 if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
 shownAlert = true 
end
end


--مظبوط من هنا
--طائرة السيمفونية
function VVV15()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
local jz = gg.getResults(n)
local shownAlert = false
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('33;26;1768641314;1768641318;842676048::145', gg.TYPE_DWORD)
gg.refineNumber('26', gg.TYPE_DWORD)
local results = gg.getResults(1)
if #results < 1 then
gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
return
end
local res = results[1].address
local temp_values = {
gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value}
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
res = results[1].address
local changes = {
{offset = 512, value = temp_values[1]},
{offset = 516, value = temp_values[2]},
{offset = 520, value = temp_values[3]},
{offset = 524, value = temp_values[4]},
{offset = 528, value = temp_values[5]},
{offset = 532, value = temp_values[6]}}
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("??‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
shownAlert = true 
end
gg.clearResults()
gg.clearList()
end


--طائرة الموضة
function VVV16()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
end 
gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634496626",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1717527918",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1768452961",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "28271",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡

--اكواد المطار

--البوابة الجوية
function VVVV1()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641312",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1919905906",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1347641204",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "51",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("??‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--مطار المهرجان
function VVVV2()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641312",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1919905906",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1347641204",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "55",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--مطار استوائي
function VVVV3()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641312",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1919905906",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1347641204",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "57",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end



--مطار الأشباح
function VVVV4()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1598903072;1667330163;101;49;26:105', gg.TYPE_DWORD)
    gg.refineNumber('26', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
    end



--ميناء فضائي
function VVVV5()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641316",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1919905906",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1886609268",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "6644577",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--مطار روك
function VVVV6()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641314",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1919905906",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1869766516",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "27491",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--مطار سينمائي
function VVVV7()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641316",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1919905906",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1869438836",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "6646134",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--مسكن سانتا
function VVVV8()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641316;1886546241;1886546241;49;26::321', gg.TYPE_DWORD)
    gg.refineNumber('26', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
    end
    
--مطار الفصح
function VVVV9()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641316;1765891950;1919905906;1869438836;6646134;33;23', gg.TYPE_DWORD)
    gg.refineNumber('23', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end



--مطار الحلوي
function VVVV10()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641316",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1919905906",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "2004049780",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "7628133",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


--مركز التزلج
function VVVV11()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641316;2004049780;33;24::73', gg.TYPE_DWORD)
    gg.refineNumber('24', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐??𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end

--مطار قوس قزح
function VVVV12()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641320",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1919905906",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919508340",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1851878501",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "100",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 536,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


--قاعدة سرية
function VVVV13()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641312",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1919905906",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1886609268",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "121",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--مطار خمس نجوم
function VVVV14()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641316;2004049780;33;24::73', gg.TYPE_DWORD)
    gg.refineNumber('24', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end




--مظبوط من هنا 
--مطار السيمفونية
function VVVV15()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
local jz = gg.getResults(n)
local shownAlert = false
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('33;25;1768641320;1765891950;1869438836::205', gg.TYPE_DWORD)
gg.refineNumber('25', gg.TYPE_DWORD)
local results = gg.getResults(1)
if #results < 1 then
gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
return
end
local res = results[1].address
local temp_values = {
gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value}
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
res = results[1].address
local changes = {
{offset = 512, value = temp_values[1]},
{offset = 516, value = temp_values[2]},
{offset = 520, value = temp_values[3]},
{offset = 524, value = temp_values[4]},
{offset = 528, value = temp_values[5]},
{offset = 532, value = temp_values[6]}}
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
shownAlert = true 
end
gg.clearResults()
gg.clearList()
end


--مطار الموضه
function VVVV16()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
end 
gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641320",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1765891950",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1919905906",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1634099060",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1869178995",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "110",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈??𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--اكواد الهليكوبتر والمهبط

--اكواد  طائرة الهليكوبتر 

-- طبق تربو
function NNN1()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1699241838",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1868786028",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919251568",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1868977503",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "12858",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

-- موصل آلي
function NNN2()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1699241838",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1868786028",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919251568",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1651462751",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "29807",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


-- مزلقة سانتا
function NNN3()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1734960144;7497076;33;24::97', gg.TYPE_DWORD)
    gg.refineNumber('24', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- طائرة هليكوبتر خاصة
function NNN4()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641324",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1699241838",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1868786028",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919251568",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1952532319",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "7955059",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

-- الطائرة الهليكوبتر الباذنجانة
function NNN5()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1699241838;7955059;33;23::69', gg.TYPE_DWORD)
    gg.refineNumber('23', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- بساط طائر
function NNN6()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641324",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1699241838",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1868786028",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919251568",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1634877791",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "6515042",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


-- طائرة على شكل أريكة
function NNN7()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641324",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1699241838",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1868786028",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919251568",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1936020063",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "7631471",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍??🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


-- السفينة الطائرة
function NNN8()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641324",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1699241838",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1868786028",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919251568",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1634882655",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "7103862",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end


-- طائرة هليكوبتر دراجة
function NNN9()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1699241838",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1868786028",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919251568",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1869632351",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "29810",gg.TYPE_DWORD}})
if not messageShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end


-- طائرة هليكوبتر قرع العسل
function NNN10()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641322;29810;33;26::73', gg.TYPE_DWORD)
    gg.refineNumber('26', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️??MAHMOUDHERO🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end

-- المرجل الطائر
function NNN11()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('33;29;1768641324;3355184::69', gg.TYPE_DWORD)
    gg.refineNumber('29', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- طائرة هليكوبتر ريشية
function NNN12()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641324",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1699241838",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1868786028",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919251568",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1634886239",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "7104890",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end
-- قطاعة البيض
function NNN13()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641320;1851878501;33;26::121', gg.TYPE_DWORD)
    gg.refineNumber('26', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- غواصة الأعماق الطائرة
function NNN14()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641324;7104890;33;24::137', gg.TYPE_DWORD)
    gg.refineNumber('24', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end

--طائرة هليكوبتر للقراصنة
function NNN15()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('33;26;1768641318;1953264993::145', gg.TYPE_DWORD)
    gg.refineNumber('26', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


--الطائرة الهليكوبتر القرمزية
function NNN16()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
local jz = gg.getResults(n)
local shownAlert = false
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('1768641318;875704370;33;23:121', gg.TYPE_DWORD)
gg.refineNumber('23', gg.TYPE_DWORD)
local results = gg.getResults(1)
if #results < 1 then
gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
return
end
local res = results[1].address
local temp_values = {
gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value}
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
res = results[1].address
local changes = {
{offset = 512, value = temp_values[1]},
{offset = 516, value = temp_values[2]},
{offset = 520, value = temp_values[3]},
{offset = 524, value = temp_values[4]},
{offset = 528, value = temp_values[5]},
{offset = 532, value = temp_values[6]}}
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
shownAlert = true 
end
gg.clearResults()
gg.clearList()
end

--طائرة الهليكوبتر لقاعة الرقص
function NNN17()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
local jz = gg.getResults(n)
local shownAlert = false
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('33;26;1768641318;961565535::205', gg.TYPE_DWORD)
gg.refineNumber('26', gg.TYPE_DWORD)
local results = gg.getResults(1)
if #results < 1 then
gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
return
end
local res = results[1].address
local temp_values = {
gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value}
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
res = results[1].address
local changes = {
{offset = 512, value = temp_values[1]},
{offset = 516, value = temp_values[2]},
{offset = 520, value = temp_values[3]},
{offset = 524, value = temp_values[4]},
{offset = 528, value = temp_values[5]},
{offset = 532, value = temp_values[6]}}
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
shownAlert = true 
end
gg.clearResults()
gg.clearList()
end

--طائرة الديسكو الهليكوبتر 
function NNN18()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
end 
gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1699241838",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1868786028",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919251568",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1936286815",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "28515",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃??𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--اكواد المهبط 

-- حظيرة الطبق الطائر
function NNNN1()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641322;12858;33;24::57', gg.TYPE_DWORD)
    gg.refineNumber('24', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- محطة رسو سفن
function NNNN2()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641322;29807;33;26::57', gg.TYPE_DWORD)
    gg.refineNumber('26', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- موقف المزلقة
function NNNN3()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('33;27;1768641318;842676048:65', gg.TYPE_DWORD)
    gg.refineNumber('27', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- مهبط طائرات هليكوبتر خاص
function NNNN4()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641324;7955059;33;27::57', gg.TYPE_DWORD)
    gg.refineNumber('27', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end

-- مهبط الطائرة الهليكوبتر النباتي
function NNNN5()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('33;28;1768641316;6644577::65', gg.TYPE_DWORD)
    gg.refineNumber('28', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- قصر السلطان
function NNNN6()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641318;1701011824;33;27::57', gg.TYPE_DWORD)
    gg.refineNumber('27', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- مهبط طائرة هليكوبتر خمس نجوم
function NNNN7()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641316;7037807;33;27::57', gg.TYPE_DWORD)
    gg.refineNumber('27', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- ميناء المتجولين
function NNNN8()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641308;6646134;33;27::73', gg.TYPE_DWORD)
    gg.refineNumber('27', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- مهبط رياضي
function NNNN9()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641324;3289648;33;26::73', gg.TYPE_DWORD)
    gg.refineNumber('26', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- القصر الملكي
function NNNN10()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1750294382;13106;33;31::69', gg.TYPE_DWORD)
    gg.refineNumber('31', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end
-- البرج المسكون
function NNNN11()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('49;34;1768641324;3355184::117', gg.TYPE_DWORD)
    gg.refineNumber('34', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


-- منصة الكرنفال
function NNNN12()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('33;27;1768641324;7104890::69', gg.TYPE_DWORD)
    gg.refineNumber('27', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end

-- مهبط طائرات الفصح
function NNNN13()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('33;31;1768641318;875704370::113', gg.TYPE_DWORD)
    gg.refineNumber('31', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end

-- قصر الأعماق
function NNNN14()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
local jz = gg.getResults(n)
local shownAlert = false
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('33;29;1768641324;6842217::85', gg.TYPE_DWORD)
gg.refineNumber('29', gg.TYPE_DWORD)
local results = gg.getResults(1)
if #results < 1 then
gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
return
end
local res = results[1].address
local temp_values = {
gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value}
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿??𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
res = results[1].address
local changes = {
{offset = 512, value = temp_values[1]},
{offset = 516, value = temp_values[2]},
{offset = 520, value = temp_values[3]},
{offset = 524, value = temp_values[4]},
{offset = 528, value = temp_values[5]},
{offset = 532, value = temp_values[6]}}
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
shownAlert = true 
end
gg.clearResults()
gg.clearList()
end

--مهبط الطائرة الهليكوبتر للقراصنة
function NNNN15()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('33;31;1768641324;6842217::85', gg.TYPE_DWORD)
    gg.refineNumber('31', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }
    
    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end
    gg.clearResults()
    gg.clearList()
    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end

--مهبط الطائرة الهليكوبتر القرمزية
function NNNN16()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
local jz = gg.getResults(n)
local shownAlert = false
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('33;28;1768641324;6842217:469', gg.TYPE_DWORD)
gg.refineNumber('28', gg.TYPE_DWORD)
local results = gg.getResults(1)
if #results < 1 then
gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
return
end
local res = results[1].address
local temp_values = {
gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value}
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
res = results[1].address
local changes = {
{offset = 512, value = temp_values[1]},
{offset = 516, value = temp_values[2]},
{offset = 520, value = temp_values[3]},
{offset = 524, value = temp_values[4]},
{offset = 528, value = temp_values[5]},
{offset = 532, value = temp_values[6]}}
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
shownAlert = true 
end
gg.clearResults()
gg.clearList()
end


--مهبط طائرة هليكوبتر لقاعة الرقص
function NNNN17()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
local jz = gg.getResults(n)
local shownAlert = false
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('33;31;1768641324;29807::213', gg.TYPE_DWORD)
gg.refineNumber('31', gg.TYPE_DWORD)
local results = gg.getResults(1)
if #results < 1 then
gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
return
end
local res = results[1].address
local temp_values = {
gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value}
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
res = results[1].address
local changes = {
{offset = 512, value = temp_values[1]},
{offset = 516, value = temp_values[2]},
{offset = 520, value = temp_values[3]},
{offset = 524, value = temp_values[4]},
{offset = 528, value = temp_values[5]},
{offset = 532, value = temp_values[6]}}
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
shownAlert = true 
end
gg.clearResults()
gg.clearList()
end

--مهبط طائرة الديسكو 
function NNNN18()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.setVisible(false)
gg.clearResults()
gg.setRanges(gg.REGION_C_ALLOC) 
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
local n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
local jz = gg.getResults(n)
local shownAlert = false
for i = 1, n do
gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
end
gg.clearResults()
gg.searchNumber('1768641322;28515;33;26::57', gg.TYPE_DWORD)
gg.refineNumber('26', gg.TYPE_DWORD)
local results = gg.getResults(1)
if #results < 1 then
gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
return
end
local res = results[1].address
local temp_values = {
gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value}
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
gg.clearResults()
gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
gg.refineNumber('1701996056', gg.TYPE_DWORD)
results = gg.getResults(1)
if #results == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
res = results[1].address
local changes = {
{offset = 512, value = temp_values[1]},
{offset = 516, value = temp_values[2]},
{offset = 520, value = temp_values[3]},
{offset = 524, value = temp_values[4]},
{offset = 528, value = temp_values[5]},
{offset = 532, value = temp_values[6]}}
for _, change in ipairs(changes) do
local address = res + change.offset
gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
end
if not shownAlert then 
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
shownAlert = true 
end
gg.clearResults()
gg.clearList()
end
--🤡🤡??🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡

--اكواد الجزيرة 

--كوخ القراصنة 
function ZZ1()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866882926",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1701999730",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1348432755",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1952543337",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "12645",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--مركز القراصنة 
function ZZ2()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866882926",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1701999730",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1348432755",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1952543337",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "12901",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--حصن القراصنه
function ZZ3()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866882926",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1701999730",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1348432755",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1952543337",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "13157",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--منزل الجزيرة 
function ZZ4()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866882926",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1701999730",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1197437811",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1651733601",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "12665",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--قصر الجزيرة 
function ZZ5()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866882926",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1701999730",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1197437811",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1651733601",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "12921",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end
--مسكن الجزيرة 
function ZZ6()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866882926",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1701999730",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1197437811",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1651733601",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "13177",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--منزل الساحرة 
function ZZ7()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("1970225964;65537;1599361808::449", gg.TYPE_DWORD)
    gg.refineNumber("1599361808", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('33;29;1768641318;1936290401::273', gg.TYPE_DWORD)
    gg.refineNumber('29', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber("1970225960;1599361808:257", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.refineNumber("1970225960", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end






--قصر الساحره
function ZZ8()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('33;29;1768641318;1936290401::273', gg.TYPE_DWORD)
    gg.refineNumber('29', gg.TYPE_DWORD)

    local results = gg.getResults(100)
    if #results < 2 then
        gg.alert("الكود لا يعمل تحدث مع مطور الاسكربت لتحديث الكود")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[2].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end

--قلعه الساحره 
function ZZ9()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('33;29;1768641318;1936290401::273', gg.TYPE_DWORD)
    gg.refineNumber('29', gg.TYPE_DWORD)

    local results = gg.getResults(100)
    if #results < 3 then
        gg.alert("الكود لا يعمل تحدث مع مطور الاسكربت لتحديث الكود")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[3].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("??‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end


--القلعه الجليدية 
function ZZ10()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('33;23;1768641318;1936290401::81', gg.TYPE_DWORD)
    gg.refineNumber('23', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end

--باريس صغيرة 
function ZZ11()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866882926",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1701999730",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1885303667",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1936290401",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀??𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--قريه عيد الفصح 
function ZZ12()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641320",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866882926",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1701999730",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1700754291",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1702130529",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "114",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--جزيره الإنسان البدائي 
function ZZ13()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
    gg.setVisible(false)
    gg.clearResults()
    gg.setRanges(gg.REGION_C_ALLOC) 
    gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
    gg.refineNumber("1635148044", gg.TYPE_DWORD)

    local n = gg.getResultCount()
    if n == 0 then
        gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local jz = gg.getResults(n)
    for i = 1, n do
        gg.addListItems({{address = jz[i].address - 8, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 12, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
        gg.addListItems({{address = jz[i].address - 16, flags = gg.TYPE_DWORD, freeze = true, value = "0"}})
    end

    gg.clearResults()
    gg.searchNumber('1768641324;6515058;33;25::105', gg.TYPE_DWORD)
    gg.refineNumber('25', gg.TYPE_DWORD)

    local results = gg.getResults(1)
    if #results < 1 then
        gg.alert("كود الديكور لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()  
        gg.clearList()
        return
    end

    local res = results[1].address

    local temp_values = {
        gg.getValues({{address = res - 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res - 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 0, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 4, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 8, flags = gg.TYPE_DWORD}})[1].value,
        gg.getValues({{address = res + 12, flags = gg.TYPE_DWORD}})[1].value
    }
    gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")

    gg.clearResults()
    gg.searchNumber('1701996056;1651327333;5;34:73', gg.TYPE_DWORD)
    gg.refineNumber('1701996056', gg.TYPE_DWORD)

    results = gg.getResults(1)
    if #results == 0 then
        gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
        gg.clearResults()
        gg.clearList()
        return
    end

    res = results[1].address
    local changes = {
        {offset = 512, value = temp_values[1]},
        {offset = 516, value = temp_values[2]},
        {offset = 520, value = temp_values[3]},
        {offset = 524, value = temp_values[4]},
        {offset = 528, value = temp_values[5]},
        {offset = 532, value = temp_values[6]}
    }

    for _, change in ipairs(changes) do
        local address = res + change.offset
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = change.value}})
    end

    gg.clearResults()
    gg.clearList()

    if not shownAlert then 
        gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
        gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
        shownAlert = true 
    end
end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡

--بقرة سينمائية
function COW1()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641308",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1869438839",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "6646134",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--البقرة القزمة
function COW2()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641324",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1751342967",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1953720690",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "846422381",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "3289648",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة مغازلة
function COW3()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641316",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1635147639",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1953391980",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "6647401",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--البقرة رائدة الفضاء
function COW4()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641306",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634557815",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "29554",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة الاحتفالات
function COW5()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641314",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1768054647",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1684567154",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "31073",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--البقرة صانعة الحلويات
function COW6()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641310",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "2004049783",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "846488933",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--مو-سفيراتو
function COW7()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641324",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634230135",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "2003790956",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "846095717",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "3355184",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊??🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة جبلية
function COW8()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641320",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1769430903",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919251566",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1919905875",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "116",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة احتفالية
function COW9()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641304",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1313038199",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "89",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة الفصح
function COW10()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1634033527",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1919251571",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "875704370",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة جاسوسة
function COW11()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641304",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1886609271",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "121",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--ملكة أطلانتس
function COW12()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641314",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1952538487",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1953390956",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "29545",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة أنيقة
function COW13()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641316",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1953062775",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "846818401",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "3420720",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة احتفالية
function COW14()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1768054647",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1684567154",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "808614241",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "13362",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة القراصنة المعتمدين
function COW15()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.clearList()
end 

gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
  gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
  gg.clearResults()
  gg.clearList()
  return
end
jz = gg.getResults(n)

for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1768972151",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1702125938",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "875704370",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة القطب الشمالي
function COW16()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
end 
gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641310",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1918984055",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1667855459",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة السيمفونية
function COW17()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
end 
gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641322",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1818451831",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1769173857",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "1937075555",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "25449",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end

--بقرة الزهور
function COW18()
gg.toast("❤️لا تنسى الصلاة على النبي❤️")
gg.clearResults()
gg.setVisible(false)
gg.setRanges(gg.REGION_C_ALLOC)
gg.searchNumber("65537;1635148044;3::65", gg.TYPE_DWORD)
gg.refineNumber("1635148044", gg.TYPE_DWORD)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استعادة الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
local messageShown = false 
local toastShown = false 
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address - 8,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 12,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address - 16,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
end 
gg.clearResults()
gg.searchNumber("1701996056;1651327333;5;34:73", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
gg.refineNumber("1701996056", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
n = gg.getResultCount()
if n == 0 then
gg.alert("كود استبدال الصوره لا يعمل تحدث مع مطور الاسكربت")
return
end
jz = gg.getResults(n)
for i = 1, n do
gg.addListItems({[1] = {address = jz[i].address + 512,flags = gg.TYPE_DWORD,freeze = true,value = "1768641314",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 516,flags = gg.TYPE_DWORD,freeze = true,value = "1866686318",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 520,flags = gg.TYPE_DWORD,freeze = true,value = "1701207927",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 524,flags = gg.TYPE_DWORD,freeze = true,value = "1986622579",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 528,flags = gg.TYPE_DWORD,freeze = true,value = "27745",gg.TYPE_DWORD}})
gg.addListItems({[1] = {address = jz[i].address + 532,flags = gg.TYPE_DWORD,freeze = true,value = "0",gg.TYPE_DWORD}})
if not messageShown then
if not toastShown then
gg.alert("اذهب الان الي التذكره الذهبيه ثم بعد ذلك  عليك استلام هديه الصوره للحصول علي الديكور المطلوب")
gg.toast("🏴‍☠️🔥𝙈𝘼𝙃𝙈𝙊𝙐𝘿𝙃𝙀𝙍𝙊🔥🏴‍☠️")
toastShown = true
messageShown = true 
end 
gg.clearResults()
gg.clearList() 
end
end
end
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡
--🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡

function F17()
    gg.setVisible(false)
    gg.alert(
        "╔═══════════════════════╗\n"..
        "𝄟🇲 🇦 🇭 🇲 🇴 🇺 🇩 🇭 🇪 🇷 🇴𝄟\n"..
        "╚═══════════════════════╝\n\n"..
        
        "╔═══════════════════════╗\n"..
        "𝄟              (🇾🇪 كريم المصري 🇾🇪)                  𝄟\n"..
        "╚═══════════════════════╝\n\n"..
        
        "╔═══════════════════════╗\n"..
        "𝄟                     (🇮🇶 ديدار 🇮🇶)                      𝄟\n"..
        "╚═══════════════════════╝\n\n"..
        
        "╔═══════════════════════╗\n"..
        "𝄟                     (🇾🇪 احمد 🇾🇪)                      𝄟\n"..
        "╚═══════════════════════╝\n\n"..
        
        "╔═══════════════════════╗\n"..
        "𝄟                    (🇾🇪 حنان 🇾🇪)                       𝄟\n"..
        "╚═══════════════════════╝\n\n"..
        
        "╔═══════════════════════╗\n"..
        "𝄟                   (🇾🇪 جولي 🇾🇪)                       𝄟\n"..
        "╚═══════════════════════╝\n\n"..
        
        "╔═══════════════════════╗\n"..
        "𝄟                   (🇾🇪 نيفو 🇾🇪)                         𝄟\n"..
        "╚═══════════════════════╝"
    )
end  -- هذه النهاية كانت مفقودة



function EXIT()
gg.alert("🤡مع السلامه ياغالي هات خمسه جنيه🤡")
gg.setVisible(false)
print("                                                                          🏴‍☠️⚔️▬▬▬▬▬๑۩ⒽⒺⓇⓄ۩๑▬▬▬▬▬⚔️🏴‍☠️\n\n                                                                🏴‍☠️⚔️🆂🅲🆁🅸🅿🆃🅼🅰🅷🅼🅾🆄🅳🅷🅴🆁🅾⚔️🏴‍☠️                \n \n                                                                🏴‍☠️⚔️🆆🅴🅻🅲🅾🅼🅴 🅼🆈 🅵🆁🅸🅴🅽🅳⚔️🏴‍☠️  \n \n                                                                🏴‍☠️⚔️🅴🅳🅸🆃🅴🅳 🅱🆈 🅼🅰🅷🅼🅾??🅳🅷🅴🆁🅾⚔️🏴‍☠️  \n\n                                                                          🏴‍☠️⚔️▬▬▬▬▬๑۩ⒽⒺⓇⓄ۩๑▬▬▬▬▬⚔️🏴‍☠️")
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







    


