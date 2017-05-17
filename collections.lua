-- collections.lua - A robust collection class based on Laravel collections
--
-- @module collections.lua
-- @alias Collection
-- @url https://github.com/ImLiam/Lua-Collections

local Collection = {}
Collection.version = '0.2.0'



--- Alias for the Collection:new() method
function collect(tbl)
    return Collection:new(tbl)
end



-----[[ COLLECTION METHODS ]]-----



--- Returns all elements from a collection as a table
function Collection:all()
    local tbl = {}
    for key, value in pairs(self.table) do
        tbl[key] = value
    end
    return tbl
end

--- Adds an item to the end of a collection
function Collection:append(value)
    table.insert(self.table, value)
    return self
end

--- Returns the average value of a list or given key
function Collection:average(key)
    local count = self:count()
    if count > 0 then
        return self:sum(key) / count
    end
end

--- Breaks the collection into multiple smaller collections of a given size
function Collection:chunk(count)
    local chunks = self:new()
    local currentChunk = {}

    if count <= 0 then
        return Collection:new({ {} })
    end

    for key, value in pairs(self.table) do
        table.insert(currentChunk, value)
        if #currentChunk == count then
            chunks:push(currentChunk)
            currentChunk = {}
        end
    end
    if #currentChunk > 0 then
        chunks:push(currentChunk)
    end
    return chunks
end

--- Returns a copy of the collection
function Collection:clone()
    local cloned = {}
    for key, value in pairs(self.table) do
        cloned[key] = value
    end
    return self:new(cloned)
end

--- Collapses a collection of tables into a single, flat collection
function Collection:collapse()
    local collapsed = self:new()
    for key, value in pairs(self.table) do
        for innerKey, innerValue in pairs(value) do
            collapsed:push(innerValue)
        end
    end
    return collapsed
end

--- Combines the keys of the collection with the values of another table
function Collection:combine(values)
    local combined = self:new()
    for key, value in pairs(values) do
        if self.table[key] then
            combined:set(self.table[key], value)
        end
    end
    return combined
end

--- Determines whether the collection contains a given item
function Collection:contains(containValue, recursive)

    local function checkContains(key, value)
        if type(containValue) == 'function' then
            result = containValue(key, value)
            if result then
                return true
            end
        else
            if value == containValue then
                return true
            end
        end
        return false
    end

    for key, value in pairs(self.table) do
        local result
        if type(value) == 'table' and recursive then
            for innerKey, innerValue in pairs(value) do
                if checkContains(innerKey, innerValue) then
                    return true
                end
            end
        else
            if checkContains(key, value) then
                return true
            end
        end
    end

    return false
end

--- Turns an associative table into an indexed one, removing string keys
function Collection:convertToIndexed()
    local notAssociative = self:new()
    for key, value in pairs(self.table) do
        notAssociative:push(value)
    end
    return notAssociative
end

--- Returns the total number of items in the collection
function Collection:count()
    local i = 0
    for key, value in pairs(self.table) do
        i = i + 1
    end
    return i
end

--- Deals the collection into a number of groups in order, one at a time
function Collection:deal(hands)
    local splitted = self:times(hands, function() return {} end)
    local currentSection = 1

    for key, value in pairs(self.table) do
        table.insert(splitted.table[currentSection], value)

        currentSection = currentSection + 1
        if currentSection > #splitted.table then
            currentSection = 1
        end
    end

    return splitted
end

--- Compares a collection against another table based on its values
--- Returns the values in the original collection that are not present in the given table
function Collection:diff(difference)
    local differenceList = {}
    for key, value in pairs(difference) do
        differenceList[value] = true
    end

    local finalDifferences = self:new()
    for key, value in pairs(self.table) do
        if not differenceList[value] then
            finalDifferences:push(value)
        end
    end
    return finalDifferences
end

--- Compares the collection against another table based on its keys
--- Returns the key / value pairs in the original collection that are not present in the table
function Collection:diffKeys(difference)
    local differenceList = {}
    for key, value in pairs(difference) do
        differenceList[key] = true
    end

    local finalDifferences = self:new()
    for key, value in pairs(self.table) do
        if not differenceList[key] then
            finalDifferences:set(key, value)
        end
    end
    return finalDifferences
end

--- Iterates over the items in the collection and passes each to a callback
function Collection:each(callback)
    for key, value in pairs(self.table) do
        if callback(key, value) == false then
            break
        end
    end
    return self
end

--- Iterates over the numerically indexed items in the collection and passes each to a callback
function Collection:eachi(callback)
    for key, value in ipairs(self.table) do
        if callback(key, value) == false then
            break
        end
    end
    return self
end

--- Compares a table with the internal table of the collection
function Collection:equals(tbl, ignoreMetatables, tbl2)
    tbl2 = tbl2 or self.table
    if tbl == tbl2 then return true end
    local tblType = type(tbl)
    local tbl2Type = type(tbl2)
    if tblType ~= tbl2Type then return false end
    if tblType ~= 'table' then return false end

    if not ignoreMetatables then
        local mt1 = getmetatable(tbl)
        if mt1 and mt1.__eq then
            return tbl == tbl2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(tbl) do
        local value2 = tbl2[key1]
        if value2 == nil or self:equals(value1, ignoreMetatables, value2) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(tbl2) do
        if not keySet[key2] then return false end
    end
    return true
end

--- Verify that all elements of the collection pass a truth test
function Collection:every(callback)
    for key, value in pairs(self.table) do
        if not callback(key, value) then
            return false
        end
    end
    return true
end

--- Returns all items in the collection except for those with specified keys
function Collection:except(keys)
    local exceptList = {}
    for key, value in pairs(keys) do
        exceptList[value] = true
    end

    local tbl = self:new()
    for key, value in pairs(self.table) do
        if not exceptList[key] then
            tbl:set(key, value)
        end
    end
    return tbl
end

--- Internal function used to determine if a value is falsey
function Collection:falsyValue(value)
    for k, v in ipairs({0, false, ''}) do
        if v == value then
            return true
        end
    end

    if type(value) == 'table' then
        if next(value) == nil then
            return true
        end
    end

    if not value then
        return true
    end

    return false
end

--- Filters the collection using the given callback, keeping only items that pass a truth test
function Collection:filter(callback)
    local filtered = self:new()
    for key, value in pairs(self.table) do
        local response = false
        if callback then
            response = callback(key, value)
        elseif not self:falsyValue(value) then
            response = true
        end
        if response then
            filtered:set(key, value)
        end
    end
    return filtered
end

--- Returns the first element in the collection, or that passes a truth test
function Collection:first(callback)
    for key, value in pairs(self.table) do
        if callback then
            if callback(key, value) then
                return value
            end
        else
            return value
        end
    end
end

--- Flattens a multi-dimensional collection into a single dimension
function Collection:flatten(depth, tbl, currentDepth)
    local flattened = self:new()
    local iterable = tbl or self.table
    currentDepth = currentDepth or 0
    for key, value in pairs(iterable) do
        if type(value) == 'table'
           and ((depth and currentDepth < depth - 1) or not depth) then
            flatInside = self:flatten(depth, value, currentDepth + 1):all()
            for k, v in pairs(flatInside) do
                flattened:push(v)
            end
        else
            flattened:push(value)
        end
    end
    if tbl then
        return flattened
    else
        return flattened
    end
end

--- Swaps the collection's keys with their corresponding values
function Collection:flip()
    local flipped = self:new()
    for key, value in pairs(self.table) do
        flipped:set(value, key)
    end
    return flipped
end

--- Removes an item from the collection by its key
function Collection:forget(key)
    if self.table[key] then
        self.table[key] = nil
    end
    return self
end

--- Returns a collection containing the items that would be present for a given page number
function Collection:forPage(pageNumber, perPage)
    local page = self:new()
    local i = 1
    for key, value in pairs(self.table) do
        if i > (pageNumber - 1) * perPage and i <= pageNumber * perPage then
            page:push(value)
        end
        i = i + 1
    end
    return page
end

--- Returns the itiem of a given key
function Collection:get(key, default)
    if self.table[key] then
        return self.table[key]
    elseif default then
        if type(default) == 'function' then
            return default(key)
        else
            return default
        end
    end
end

--- Groups the collection's items by a given key
function Collection:groupBy(groupKey)
    local grouped = self:new()
    for key, value in pairs(self.table) do

        local currentGroupKey = groupKey

        if value[currentGroupKey] then
            if not grouped:has(value[currentGroupKey]) then
                grouped:set(value[currentGroupKey], {})
            end
            table.insert(grouped.table[value[currentGroupKey]], value)
        end

    end
    return grouped
end

--- Determines if a given key exists in the collection
function Collection:has(key)
    if self.table[key] then
        return true
    end
    return false
end

--- Joins the items in a collection into a string
function Collection:implode(implodedKey, delimeter)
    if type(self:first()) == 'table' then
        local toImplode = {}
        for key, value in pairs(self.table) do
            if value[implodedKey] then
                table.insert(toImplode, value[implodedKey])
            end
        end
        return table.concat(toImplode, delimeter or ', ')
    else
        return table.concat(self.table, implodedKey or ', ')
    end
end

--- Inserts a value at a given numeric index
function Collection:insert(value, position)
    table.insert(self.table, position, value)
    return self
end

--- Removes any values from the original collection that are not present in the passed table
function Collection:intersect(intersection)
    local intersected = self:new()
    local intersection = collect(intersection):flip():all()

    for key, value in pairs(self.table) do
        if intersection[value] then
            intersected:set(key, value)
        end
    end

    return intersected
end

--- Determines whether the collection is associative
function Collection:isAssociative()
    if self:count() > #self.table then
        return true
    end
    return false
end

--- Determines if the collection is empty
function Collection:isEmpty()
    if next(self.table) == nil then
        return true
    end
    return false
end

--- Determines if the collection is not empty
function Collection:isNotEmpty()
    if next(self.table) ~= nil then
        return true
    end
    return false
end

--- Keys the collection by the given key
function Collection:keyBy(keyName)
    local keyed = self:new()
    for key, value in pairs(self.table) do
        if type(keyName) == 'function' then
            local response = keyName(key, value)
            keyed:set(response, value)
        else
            keyed:set(value[keyName], value)
        end
    end
    return keyed
end

--- Returns a list of the collection's keys
function Collection:keys()
    local keys = self:new()
    for key, value in pairs(self.table) do
        keys:push(key)
    end
    return keys
end

--- Returns the last element in the collection, or that passes a truth test
function Collection:last(callback)
    local currentValue
    for key, value in pairs(self.table) do
        if callback then
            if callback(key, value) then
                currentValue = value
            end
        else
            currentValue = value
        end
    end
    return currentValue
end

--- Iterates through the collection and passes each value to the callback, which can then modify the values
function Collection:map(callback)
    local remapped = self:new()
    for key, value in pairs(self.table) do
        newKey, newValue = callback(key, value)
        remapped:set(newKey, newValue)
    end
    return remapped
end

--- Iterates through the the collection and remaps the key and value based on the return of a callback
function Collection:mapWithKeys(callback)
    local mapped = self:new()
    for key, value in pairs(self.table) do
        local k, v = callback(key, value)
        mapped:set(k, v)
    end
    return mapped
end

--- Returns the maximum value of a set of given values
function Collection:max(maxKey)
    local max
    for key, value in pairs(self.table) do
        if maxKey then
            if not max or value[maxKey] > max then
                max = value[maxKey]
            end
        else
            if not max or value > max then
                max = value
            end
        end
    end
    return max
end

--- Returns the median value of a set of given values
function Collection:median(medianKey)
    local all = {}
    for key, value in pairs(self.table) do
        if medianKey then
            table.insert(all, value[medianKey])
        else
            table.insert(all, value)
        end
    end
    table.sort(all, function(a, b) return a < b end)

    if math.fmod(#all, 2) == 0 then
        return (all[#all / 2] + all[(#all / 2) + 1] ) / 2
    else
        return all[math.ceil(#all/2)]
    end
end

--- Merges the given table with the original collection
function Collection:merge(toMerge)
    local merged = self:clone()
    for key, value in pairs(toMerge) do
        if type(key) == 'number' then
            merged:push(value)
        else
            merged:set(key, value)
        end
    end
    return merged
end

--- Returns the minimum value of a set of given values
function Collection:min(minKey)
    local min
    for key, value in pairs(self.table) do
        if minKey then
            if not min or value[minKey] < min then
                min = value[minKey]
            end
        else
            if not min or value < min then
                min = value
            end
        end
    end
    return min
end

--- Returns the mode value of a given key
function Collection:mode(modeKey)
    local counts = {}

    for key, value in pairs(self.table) do
        if modeKey then
            value = value[modeKey]
        end
        if counts[value] == nil then
            counts[value] = 1
        else
            counts[value] = counts[value] + 1
        end
    end

    local biggestCount = 0

    for key, value  in pairs(counts) do
        if value > biggestCount then
            biggestCount = value
        end
    end

    local temp = self:new()

    for key, value in pairs(counts) do
        if value == biggestCount then
            temp:push(key)
        end
    end

    return temp
end

--- Creates a new collection instance
function Collection:new(tbl)
    return setmetatable({ table = tbl or {} }, { __index = self, __tostring = self.toString })
end

--- Creates a new collection consisting of every nth element
function Collection:nth(step, offset)
    local nth = self:new()
    local position = 1
    offset = (offset and offset + 1) or 1

    for key, value in pairs(self.table) do
        if position % step == offset then
            nth:push(value)
        end
        position = position + 1
    end

    return nth
end

--- Returns the items in the collection with the specified keys
function Collection:only(keys)
    local onlyList = {}
    for key, value in pairs(keys) do
        onlyList[value] = true
    end

    local tbl = self:new()
    for key, value in pairs(self.table) do
        if onlyList[key] then
            tbl:set(key, value)
        end
    end
    return tbl
end

--- Returns a pair of elements that pass and fail a given truth test
function Collection:partition(callback)
    local valid = Collection:new()
    local invalid = Collection:new()

    for key, value in pairs(self.table) do
        local result = callback(key, value)
        if result then
            valid:push(value)
        else
            invalid:push(value)
        end
    end

    return valid, invalid
end

-- Passes the collection to the given callback and returns the result
function Collection:pipe(callback)
    return callback(self)
end

--- Retrives all of the values for a given key
function Collection:pluck(valueName, keyName)
    local plucked = self:new()
    for key, value in pairs(self.table) do
        if value[valueName] then
            if keyName then
                plucked:set(value[keyName], value[valueName])
            else
                plucked:push(value[valueName])
            end
        end
    end
    return plucked
end

--- Removes and returns the last item from the collection
function Collection:pop()
    return table.remove(self.table, #self.table)
end

--- Adds an item to the beginning of the collection
function Collection:prepend(value)
    table.insert(self.table, 1, value)
    return self
end

--- Removes and returns an item from the collection by key
function Collection:pull(key)
    if type(key) == 'number' then
        return table.remove(self.table, key)
    else
        local pulled = self.table[key]
        self.table[key] = nil
        return pulled
    end
end

--- Sets the given key and value in the collection
function Collection:put(key, value)
    self.table[key] = value
    return self
end


--- Returns a random item or number of items from the collection
function Collection:random(count, rep)
    local all = self:new(self.table):convertToIndexed():all()
    local random = self:new()
    count = count or 1

    if count < 0 then
        error('Positive number expected, negative number given.')
    end

    for i = 1, count do
        if #all > 0 then
            local randomElement
            if rep then
                randomElement = all[math.random(#all)]
            else
                randomElement = table.remove(all, math.random(#all))
            end
            random:push(randomElement)
        end
    end

    if count == 1 and random[1] then
        return random[1]
    end
    return random
end

--- Reduces the collection to a single value, passing the result of each iteration into the next
function Collection:reduce(callback, default)
    local carry = default
    for key, value in pairs(self.table) do
        carry = callback(carry, value)
    end
    return carry
end

--- Filters the collection using the given fallback
function Collection:reject(callback)
    local notRejected = self:new()
    for key, value in pairs(self.table) do
        local rejected = false
        if callback then
            rejected = callback(key, value)
        elseif not self:falsyValue(value) then
            rejected = true
        end
        if not rejected then
            notRejected:set(key, value)
        end
    end
    return notRejected
end

--- Fixes numerical keys to put them in order
function Collection:resort()
    local sorted = self:new()
    for key, value in pairs(self.table) do
        if type(key) == 'number' then
            sorted:push(value)
        else
            sorted[key] = value
        end
    end
    return sorted
end

--- Reverses the order of the numerical keys in the collection
function Collection:reverse()
    local reversed = self:new()
    for key, value in pairs(self.table) do
        if type(key) == 'number' then
            reversed:prepend(value)
        else
            reversed:set(key, value)
        end
    end
    return reversed
end

--- Searches the collection for a value and returns the key
function Collection:search(callback)
    for key, value in pairs(self.table) do
        if type(callback) == 'function' then
            result = callback(key, value)
            if result then
                return key
            end
        else
            if callback == value then
                return key
            end
        end
    end
end

--- Removes and returns the first item from the collection
function Collection:shift()
    for key, value in pairs(self.table) do
        if type(key) == 'number' then
            return table.remove(self.table, key)
        else
            local response = value
            self.table[key] = nil
            return value
        end
    end
end

--- Randomly shuffles the order of items in the collection
function Collection:shuffle()
    local shuffled = self:new()
    local numericKeys = {}
    local numericValues = {}
    for key, value in pairs(self.table) do
        if type(key) == 'number' then
            table.insert(numericKeys, key)
            table.insert(numericValues, value)
        end
    end

    for key, value in pairs(self.table) do
        if type(key) == 'number' then
            shuffled:set(table.remove(numericKeys, math.random(#numericKeys)), table.remove(numericValues, math.random(#numericValues)))
            -- todo: make this push into a random spot in the array
        else
            shuffled:set(key, value)
        end
    end
    return shuffled
end

--- Returns a slice of the collection at the given index
function Collection:slice(index, size)
    local slice = self:new()
    local i = 0
    for key, value in ipairs(self.table) do
        if key >= index + 1 then
            slice:append(value)
            if size then
                i = i + 1
                if i == size then
                    return slice
                end
            end
        end
    end
    return slice
end

--- Sorts the items in the collection
function Collection:sort(callback)
    local sorted = self:clone()
    if callback and type(callback) == 'function' then
        table.sort(sorted.table, callback)
    elseif callback then
        table.sort(sorted.table, function(a, b) return a[callback] < b[callback] end)
    else
        table.sort(sorted.table, function(a, b) return a < b end)
    end
    return sorted
end

--- Same as the Collection:sort() method, but returns the collection in the opposite order
function Collection:sortDesc(callback)
    local sorted = self:clone()
    if callback and type(callback) == 'function' then
        table.sort(sorted.table, callback)
        sorted = sorted:reverse()
    elseif callback then
        table.sort(sorted.table, function(a, b) return a[callback] > b[callback] end)
    else
        table.sort(sorted.table, function(a, b) return a > b end)
    end
    return sorted
end

--- Removes and returns a slice of items starting at the specified index
function Collection:splice(index, size, replacements)
    local spliced = self:new()
    local toRemove = {}
    local i = 0
    for key, value in ipairs(self.table) do
        if key >= index + 1 then

            spliced:append(value)
            table.insert(toRemove, key)

            if size then
                i = i + 1
                if i == size then
                    break
                end
            end

        end
    end

    local removedIndex = 0
    for _, key in pairs(toRemove) do
        if type(key) == 'number' then
            table.remove(self.table, key + removedIndex)
            removedIndex = removedIndex - 1
        else
            self.table[key] = nil
        end
    end

    if replacements then
        for i = 1, #replacements do
            self:insert(table.remove(replacements, #replacements), index + 1)
        end
    end

    return spliced
end

--- Breaks the collection into the given number of groups
function Collection:split(count)
    local groupSize = math.ceil(self:count() / count)
    return self:chunk(groupSize)
end

--- Returns the sum of items in the collection
function Collection:sum(key)
    local sum = 0
    for i, value in pairs(self.table) do
        if key then
            if value[key] then
                sum = sum + value[key]
            else
                error('Value "' .. key .. '" does not exist in collection object with key "' .. i .. '"')
            end
        else
            sum = sum + value
        end
    end
    return sum
end

--- Returns a collection with the specified number of items
function Collection:take(count)
    taken = self:new()
    if count >= 0 then
        for i = 1, count do
            if self.table[i] then
                taken:append(self.table[i])
            else
                break
            end
        end
    else
        local iterations = 0
        for i = #self.table, 1, -1 do
            if self.table[i] then
                taken:prepend(self.table[i])
            else
                break
            end
            iterations = iterations + 1
            if iterations == -count then
                break
            end
        end
    end
    return taken
end

--- Internal function used to determine if a table is associative
function Collection:tableIsAssociative(tbl)
    local totalCount = 0
    for key, value in pairs(tbl) do
        totalCount = totalCount + 1
    end
    if totalCount > #tbl then
        return true
    end
    return false
end

--- Internal method used by the Collection:toJSON method to recursively convert tables
function Collection:tableToJSON(tbl)
    local jsonRepresentation = function(value)
        if type(value) == 'table' then
            return self:tableToJSON(value)
        elseif type(value) == 'string' then
            return '"' .. value:gsub('"', '\\"') .. '"'
        elseif type(value) == 'number' then
            return value
        elseif type(value) == 'boolean' then
            return (value and 'true' or 'false')
        end
    end

    local jsonElements = {}
    if self:tableIsAssociative(tbl) then
        for key, value in pairs(tbl) do
            local json = jsonRepresentation(value)
            if json then
                json = '"' .. key:gsub('"', '\\"') .. '":' .. json
                table.insert(jsonElements, json)
            end
        end
        return '{' .. table.concat(jsonElements, ',') .. '}'
    else
        for key, value in pairs(tbl) do
            local json = jsonRepresentation(value)
            table.insert(jsonElements, json)
        end
        return '[' .. table.concat(jsonElements, ',') .. ']'
    end
end

--- Internal method used by the Collection:toString method to recursively convert tables
function Collection:tableToString(tbl)
    local luaRepresentation = function(value)
        if type(value) == 'table' then
            return self:tableToString(value)
        elseif type(value) == 'string' then
            return '"' .. value .. '"'
        elseif type(value) == 'number' then
            return value
        elseif type(value) == 'boolean' then
            return (value and 'true' or 'false')
        end
    end

    local luaElements = {}

    for key, value in pairs(tbl) do
        local luaString = luaRepresentation(value)
        if luaString then
            if type(key) == 'number' then
                luaString = '[' .. key .. ']=' .. luaString
            elseif type(key) == 'string' then
                if key:match('%W') then
                    luaString = '["' .. key:gsub('"', '\\"') .. '"]=' .. luaString
                else
                    luaString = key .. '=' .. luaString
                end
            end
            table.insert(luaElements, luaString)
        end
    end
    return '{' .. table.concat(luaElements, ',') .. '}'
end

--- Executes the given callback without affecting the collection itself
function Collection:tap(callback)
    callback(self)
    return self
end

--- Creates a new collection by invoking the callback a given amount of times
function Collection:times(count, callback)
    local tbl = {}
    for i = 1, count do
        table.insert(tbl, callback(i, tbl))
    end
    return self:new(tbl)
end

--- Returns a reference to the underlying table of the collection
function Collection:toTable()
    return self.table
end

--- Returns a JSON string representation of the collection's values
function Collection:toJSON()
    return self:tableToJSON(self.table)
end

--- Returns a string representation of a Lua table
function Collection:toString(tbl)
    return self:tableToString(self.table)
end

--- Iterates over the collection and calls the given callback with each item in the collection, replacing the values in the collection with the response
function Collection:transform(callback)
    local transformed = self:new()
    for key, value in pairs(self.table) do
        transformed:set(key, callback(key, value))
    end
    return transformed
end

--- Adds the given table to the collection
function Collection:union(tbl)
    local unionised = self:clone()
    for key, value in pairs(tbl) do
        if not unionised:has(key) then
            unionised:set(key, value)
        end
    end
    return unionised
end

--- Returns all of the unique items in the collection
function Collection:unique(callback)
    local unique = self:new()
    local keyList = {}

    for key, value in pairs(self.table) do
        local result

        local valueToCheck = value
        if type(callback) == 'function' then
            valueToCheck = callback(key, value)
        elseif callback then
            valueToCheck = value[callback]
        end
        if keyList[valueToCheck] ~= nil then
            keyList[valueToCheck] = false
        else
            keyList[valueToCheck] = key
        end
    end

    for value, key in pairs(keyList) do
        if key ~= false then
            unique:push(self:get(key))
        end
    end

    return unique
end

--- Executes the given callback when a condition is met
function Collection:when(condition, callback)
    if condition then
        callback(self)
    end
    return self
end

--- Filters the collection by a given key / value pair
function Collection:where(filterKey, filterValue)
    local filtered = self:new()
    for key, value in pairs(self.table) do
        if value[filterKey] == filterValue then
            filtered:push(value)
        end
    end
    return filtered
end

--- Filters the collection by a given key / value contained within the given table
function Collection:whereIn(filterKey, filterValues)
    local filtered = self:new()
    for key, value in pairs(self.table) do
        for _, filterValue in ipairs(filterValues) do
            if value[filterKey] == filterValue then
                filtered:push(value)
            end
        end
    end
    return filtered
end

--- Filters the collection by a given key / value not contained within the given table
function Collection:whereNotIn(filterKey, filterValues)
    local filtered = self:new()
    for key, value in pairs(self.table) do
        local allowed = true
        for _, filterValue in ipairs(filterValues) do
            if value[filterKey] == filterValue then
                allowed = false
            end
        end
        if allowed then
            filtered:push(value)
        end
    end
    return filtered
end

--- Merges the value of the given table to the value of the original collection at the same index
function Collection:zip(values)
    local zipped = self:clone()
    for key, value in pairs(values) do
        if zipped:has(key) then
            zipped:set(key, {zipped:get(key), value})
        end
    end
    return zipped
end



-----[[ ALIASES FOR OTHER FUNCTIONS ]]-----



--- Alias for the Collection:average() method
Collection.avg = Collection.average

--- Alias for the Collection:average() method
Collection.mean = Collection.average

--- Alias for the Collection:each() method
Collection.forEach = Collection.each

--- Alias for the Collection:eachi() method
Collection.forEachi = Collection.eachi

--- Alias for the Collection:forget() method
Collection.remove = Collection.forget

--- Alias for the Collection:convertToIndexed() method
Collection.deassociate = Collection.convertToIndexed

--- Alias for the Collection:append() method
Collection.push = Collection.append

--- Alias for the Collection:put() method
Collection.set = Collection.put

--- Alias for the Collection:resort() method
Collection.values = Collection.resort

--- Alias for the Collection:sort() method
Collection.sortAsc = Collection.sort

--- Alias for the Collection:average() method
Collection.replace = Collection.splice



-----[[ RETURN COLLECTION OBJECT ]]-----



if require then
    return Collection
end