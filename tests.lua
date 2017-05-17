Collection = require "collections"

--- Dump and die (for debugging purposes)
function dd(value)
    if type(value) == 'table' then
        print(Collection:tableToString(value))
    elseif type(value) == 'string' then
        print('"' .. value .. '"')
    else
        print(value)
    end
    os.exit()
end

--- Assert that two tables are equal
function assert_tables_equal(tbl1, tbl2)
    if collect(tbl1):equals(tbl2) then
        return true
    end
    return error('Compared tables are not identical.')
end

--[[ all ]]--
do
    assert_tables_equal(
        collect({'a', 'b', 'c'}):all(),
        {'a', 'b', 'c'}
    )
end

--[[ append ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4}):append(5):all(),
        {1, 2, 3, 4, 5}
    )
end

--[[ average ]]--
do
    assert(collect({1, 1, 2, 4}):average() == 2)

    assert(collect({ {foo = 10}, {foo = 10}, {foo = 20}, {foo = 40} }):average('foo') == 20)
end

--[[ chunk ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4, 5, 6, 7}):chunk(4):all(),
        { {1, 2, 3, 4}, {5, 6, 7} }
    )

    assert_tables_equal(
        collect({1, 2, 3, 4, 5, 6, 7}):chunk(0):all(),
        { {} }
    )
end

--[[ clone ]]--
do
    local collection = collect({1, 2, 3, 4, 5})
    local clone = collection:clone():append(6)

    assert_tables_equal(
        clone:all(),
        {1, 2, 3, 4, 5, 6}
    )

    assert_tables_equal(
        collection:all(),
        {1, 2, 3, 4, 5}
    )

end

--[[ collapse ]]--
do
    assert_tables_equal(
        collect({ {1, 2, 3}, {4, 5, 6}, {7, 8, 9} }):collapse():all(),
        {1, 2, 3, 4, 5, 6, 7, 8, 9}
    )
end

--[[ combine ]]--
do
    assert_tables_equal(
        collect({'name', 'age'}):combine({'George', 29}):all(),
        {name = 'George', age = 29}
    )
end

--[[ contains ]]--
do
    assert(collect({'Cat', 'Dog'}):contains('Cat') == true)

    assert(collect({'Cat', 'Dog'}):contains('Walrus') == false)

    assert(collect({evil = 'Cat', good = 'Dog'}):contains('Cat') == true)

    assert(collect({1, 2, 3, 4, 5}):contains(function(key, value)
        return value > 5
    end) == false)

    assert(collect({ {'Cat', 'Dog'}, {'Rabbit', 'Mouse'} }):contains('Cat', true) == true)

    assert(collect({ {'Cat', 'Dog'}, {'Rabbit', 'Mouse'} }):contains('Cat') == false)
end

--[[ convertToIndexed ]]--
do
    assert_tables_equal(
        collect({name = 'Liam', language = 'Lua'}):convertToIndexed():all(),
        {'Liam', 'Lua'}
    )
end

--[[ count ]]--
do
    assert(collect({'a', 'b', 'c', 'd', 'e'}):count() == 5)
end

--[[ deal ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):deal(3):all(),
        { {1, 4, 7, 10}, {2, 5, 8}, {3, 6, 9} }
    )
end

--[[ diff ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4, 5, 6}):diff({2, 4, 6, 8}):all(),
        {1, 3, 5}
    )
end

--[[ diffKeys ]]--
do
    assert_tables_equal(
        collect({one = 10, two = 20, three = 30, four = 40, five = 50})
                :diffKeys({two = 2, four = 4, six = 6, eight = 8})
                :all(),
        {one = 10, three = 30, five = 50}
    )

end

--[[ each ]]--
do
    local tbl = {}
    collect({'a', 'b', 'c'}):each(function(key, value)
        tbl[key] = value
    end)

    assert_tables_equal(tbl, {'a', 'b', 'c'})
end

--[[ every ]]--
do
    assert(collect({1, 2, 3, 4}):every(function(key, value)
        return value > 2
    end) == false)
end

--[[ except ]]--
do
    assert_tables_equal(
        collect({productID = 1, price=100, discount = false})
            :except({'price', 'discount'})
            :all(),
        {productID = 1}
    )
end

--[[ equals ]]--
do
    local collection = collect({
        1, 2, 3,
        [97] = 97, [98] = 98, [99] = 99, key = true,
        sub = {1, 2, 3, sub = 'Hello world.'}
    })

    assert(collection.table[1] == 1)
    assert(collection.table[2] == 2)
    assert(collection.table[3] == 3)
    assert(collection.table[97] == 97)
    assert(collection.table[98] == 98)
    assert(collection.table[99] == 99)
    assert(collection.table['key'] == true)
    assert(collection.table['sub'][1] == 1)
    assert(collection.table['sub'][2] == 2)
    assert(collection.table['sub'][3] == 3)
    assert(collection.table['sub']['sub'] == 'Hello world.')

    assert(collection:equals({1, 2, 3, 4, 5}) == false)

    assert(collection:equals({
        1, 2, 3,
        [97] = 97, [98] = 98, [99] = 99, key = true,
        sub = {1, 2, 3, sub = 'Hello world.'}
    }) == true)

    assert(collection:equals({
        1, 2, 3, 4,
        [97] = 97, [98] = 98, [99] = 99, key = true,
        sub = {1, 2, 3, sub = 'Hello world.'}
    }) == false)

    assert(collect({1, 2, 3, 4, 5}):equals({1, 2, 3, 4, 5}) == true)

    assert(collect({1, 2, 3, 4, 5}):equals({1, 2, 3}) == false)
end

--[[ filter ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4}):filter(function(key, value)
            return value > 2
        end):all(),
        {[3] = 3, [4] = 4}
    )

    assert_tables_equal(
        collect({1, 2, 3, nil, false, '', 0, {}}):filter():all(),
        {1, 2, 3}
    )
end

--[[ first ]]--
do
    assert(collect({1, 2, 3, 4}):first() == 1)

    assert(collect({1, 2, 3, 4}):first(function(key, value)
        return value > 2
    end) == 3)
end

--[[ flatten ]]--
do
    assert_tables_equal(
        collect({name = 'Taylor', languages = {'php', 'javascript', 'lua'} }):flatten():all(),
        {'Taylor', 'php', 'javascript', 'lua'}
    )

    assert_tables_equal(
        collect({Apple = {name = 'iPhone 6S', brand = 'Apple'}, Samsung = {name = 'Galaxy S7', brand = 'Samsung'} })
            :flatten(1):resort():all(),
        { {name = 'iPhone 6S', brand = 'Apple'}, {name = 'Galaxy S7', brand = 'Samsung'} }
    )

    assert_tables_equal(
        collect({Apple = {name = 'iPhone 6S', brand = 'Apple'}, Samsung = {name = 'Galaxy S7', brand = 'Samsung'} })
            :flatten(2):resort():all(),
        {'iPhone 6S', 'Apple', 'Galaxy S7', 'Samsung'}
    )
end

--[[ flip ]]--
do
    assert_tables_equal(
        collect({name = 'Liam', language = 'Lua'}):flip():all(),
        {Liam = 'name', Lua = 'language'}
    )
end

--[[ forget ]]--
do
    assert_tables_equal(
        collect({name = 'Liam', language = 'Lua'}):forget('language'):all(),
        {name = 'Liam'}
    )

end

--[[ forPage ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4, 5, 6, 7, 8, 9}):forPage(2, 3):all(),
        {4, 5, 6}
    )
end

--[[ get ]]--
do
    assert(collect({name = 'Liam', language = 'Lua'}):get('name') == 'Liam')

    assert(collect({name = 'Liam', language = 'Lua'}):get('foo', 'Default value') == 'Default value')

    assert(collect({name = 'Liam', language = 'Lua'}):get('foo', function(key)
        return '"' .. key .. '" was not found in the collection'
    end) == '"foo" was not found in the collection')
end

--[[ groupBy ]]--
do
    assert_tables_equal(
        collect({
            {name = 'Liam', language = 'Lua'},
            {name = 'Jeffrey', language = 'PHP'},
            {name = 'Taylor', language = 'PHP'}
        }):groupBy('language'):all(),

        {
            PHP = {
                {name = 'Jeffrey', language = 'PHP'},
                {name = 'Taylor', language = 'PHP'}
            },
            Lua = {
                {name = 'Liam', language = 'Lua'}
            }
        }
    )
end

--[[ has ]]--
do
    assert(collect({name = 'Liam', language = 'Lua'}):has('language') == true)
end

--[[ implode ]]--
do
    assert(collect({'Lua', 'PHP'}):implode() == 'Lua, PHP')

    assert(collect({'Lua', 'PHP'}):implode(' | ') == 'Lua | PHP')

    assert(collect({
        {name = 'Liam', language = 'Lua'},
        {name = 'Jeffrey', language = 'PHP'}
    }):implode('language') == 'Lua, PHP')

    assert(collect({
        {name = 'Liam', language = 'Lua'},
        {name = 'Jeffrey', language = 'PHP'}
    }):implode('language', ' | ') == 'Lua | PHP')
end

--[[ intersect ]]--
do
    assert_tables_equal(
        collect({'Desk', 'Sofa', 'Chair'})
            :intersect({'Desk', 'Chair', 'Bookcase'})
            :all(),
        {[1] = 'Desk', [3] = 'Chair'}
    )
end

--[[ isAssociative ]]--
do
    assert(collect({1, 2, 3, 4, 5}):isAssociative() == false)

    assert(collect({name = 'Liam', language = 'Lua'}):isAssociative() == true)
end

--[[ isEmpty ]]--
do
    assert(collect({'Desk', 'Sofa', 'Chair'}):isEmpty() == false)

    assert(collect():isEmpty() == true)
end

--[[ isNotEmpty ]]--
do
    assert(collect({'Desk', 'Sofa', 'Chair'}):isNotEmpty() == true)

    assert(collect():isNotEmpty() == false)
end

--[[ keyBy ]]--
do
    assert_tables_equal(
        collect({
            {name = 'Liam', language = 'Lua'},
            {name = 'Jeffrey', language = 'PHP'}
        }):keyBy('language'):all(),
        {
            Lua = {name = 'Liam', language = 'Lua'},
            PHP = {name = 'Jeffrey', language = 'PHP'}
        }
    )

    assert_tables_equal(
        collect({
            {name = 'Liam', language = 'Lua'},
            {name = 'Jeffrey', language = 'PHP'}
        }):keyBy(function(key, value)
            return value['language']:lower()
        end):all(),
        {
            lua = {name = 'Liam', language = 'Lua'},
            php = {name = 'Jeffrey', language = 'PHP'}
        }
    )
end

--[[ keys ]]--
do
    assert_tables_equal(
        collect({name = 'Liam', language = 'Lua'}):keys():all(),
        {'name', 'language'}
    )
end

--[[ last ]]--
do
    assert(collect({1, 2, 3, 4}):last() == 4)

    assert(collect({1, 2, 3, 4}):last(function(key, value)
        return value > 2
    end) == 4)
end

--[[ map ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4, 5}):map(function(key, value)
            return key, value * 2
        end):all(),
        {2, 4, 6, 8, 10}
    )
end

--[[ mapWithKeys ]]--
do
    assert_tables_equal(
        collect({
            {name = 'Liam', language = 'Lua'},
            {name = 'Jeffrey', language = 'PHP'}
        }):mapWithKeys(function(key, value)
            return value['language'], value['name']
        end):all(),
        {
            Lua = 'Liam',
            PHP = 'Jeffrey'
        }
    )
end

--[[ max ]]--
do
    assert(collect({1, 2, 3, 4, 5}):max() == 5)

    assert(collect({ {foo = 10}, {foo = 20} }):max('foo') == 20)
end

--[[ median ]]--
do
    assert(collect({1, 1, 2, 4}):median() == 1.5)

    assert(collect({ {foo = 10}, {foo = 10}, {foo = 20}, {foo = 40} }):median('foo') == 15)
end

--[[ merge ]]--
do
    assert_tables_equal(
        collect({'Desk', 'Chair'}):merge({'Bookcase', 'Door'}):all(),
        {'Desk', 'Chair', 'Bookcase', 'Door'}
    )

    assert_tables_equal(
        collect({name = 'Liam', language = 'Lua'})
            :merge({name = 'Taylor', experiencedYears = 14 })
            :all(),
        {name = 'Taylor', language = 'Lua', experiencedYears = 14}
    )
end

--[[ min ]]--
do
    assert(collect({1, 2, 3, 4, 5}):min() == 1)

    assert(collect({ {foo = 10}, {foo = 20} }):min('foo') == 10)
end

--[[ mode ]]--
do
    assert_tables_equal(
        collect({1, 1, 2, 4}):mode():all(),
        {1}
    )

    assert_tables_equal(
        collect({ {foo = 10}, {foo = 10}, {foo = 20}, {foo = 20}, {foo = 40} })
            :mode('foo')
            :all(),
        {10, 20}
    )
end

--[[ new ]]--
do
    assert_tables_equal(
        Collection:new({'Hello', 'world'}):all(),
        {'Hello', 'world'}
    )
end

--[[ nth ]]--
do
    assert_tables_equal(
        collect({'a', 'b', 'c', 'd', 'e', 'f'}):nth(4):all(),
        {'a', 'e'}
    )

    assert_tables_equal(
        collect({'a', 'b', 'c', 'd', 'e', 'f'}):nth(4, 1):all(),
        {'b', 'f'}
    )
end

--[[ only ]]--
do
    assert_tables_equal(
        collect({name = 'Taylor', language = 'Lua', experiencedYears = 14})
            :only({'name', 'experiencedYears'})
            :all(),
        {name = 'Taylor', experiencedYears = 14}
    )
end

--[[ partition ]]--
do
    local passed, failed = collect({1, 2, 3, 4, 5, 6}):partition(function(key, value)
        return value < 3
    end)

    assert_tables_equal(
        passed:all(),
        {1, 2}
    )

    assert_tables_equal(
        failed:all(),
        {3, 4, 5, 6}
    )
end

--[[ pipe ]]--
do
    assert(collect({1, 2, 3}):pipe(function(collection)
        return collection:sum()
    end) == 6)
end

--[[ pluck ]]--
do
    assert_tables_equal(
        collect({
            {name = 'Liam', language = 'Lua'},
            {name = 'Jeffrey', language = 'PHP'}
        }):pluck('name'):all(),
        {'Liam', 'Jeffrey'}
    )

    assert_tables_equal(
        collect({
            {name = 'Liam', language = 'Lua'},
            {name = 'Jeffrey', language = 'PHP'}
        }):pluck('name', 'language'):all(),
        {Lua = 'Liam', PHP = 'Jeffrey'}
    )
end

--[[ pop ]]--
do
    local collection = collect({1, 2, 3, 4, 5})

    assert(collection:pop() == 5)

    assert_tables_equal(
        collection:all(),
        {1, 2, 3, 4}
    )
end

--[[ prepend ]]--
do
    local collection = collect({1, 2, 3, 4, 5})
    collection:prepend(0)

    assert_tables_equal(
        collection:all(),
        {0, 1, 2, 3, 4, 5}
    )
end

--[[ pull ]]--
do
    local collection = collect({name = 'Liam', language = 'Lua'})

    assert(collection:pull('language') == 'Lua')

    assert_tables_equal(
        collection:all(),
        {name = 'Liam'}
    )
end

--[[ put ]]--
do
    assert_tables_equal(
        collect({name = 'Liam', language = 'Lua'})
            :put('count', 12)
            :all(),
        {name = 'Liam', language = 'Lua', count = 12}
    )
end

--[[ random ]]--
do
    assert(type(collect({1, 2, 3, 4, 5}):random():first()) == 'number')

    assert(type(collect({1, 2, 3, 4, 5}):random(3):all()) == 'table')

    assert(collect({1, 2, 3, 4, 5}):random(12):count() == 5)

    assert(collect({1, 2, 3, 4, 5}):random(12, true):count() == 12)
end

--[[ reduce ]]--
do
    assert(collect({1, 2, 3}):reduce(function(carry, value)
        return carry + value
    end, 4) == 10)
end

--[[ reject ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4}):reject(function(key, value)
            return value > 2
        end):all(),
        {1, 2}
    )
end

--[[ resort ]]--
do
    assert_tables_equal(
        collect({[1] = 'a', [5] = 'b'}):resort():all(),
        {[1] = 'a', [2] = 'b'}
    )
end

--[[ reverse ]]--
do    
    assert_tables_equal(
        collect({1, 2, 3, 4, 5}):reverse():all(),
        {5, 4, 3, 2, 1}
    )
end

--[[ search ]]--
do
    assert(collect({2, 4, 6, 8}):search(4) == 2)

    assert(collect({2, 4, 6, 8}):search(function(key, value)
        return value > 5
    end) == 3)
end

--[[ shift ]]--
do
    local collection = collect({1, 2, 3, 4, 5})

    assert(collection:shift() == 1)

    assert_tables_equal(
        collection:all(),
        {2, 3, 4, 5}
    )

end

--[[ shuffle ]]--
do
    assert(type(collect({1, 2, 3, 4, 5}):shuffle():all()) == 'table')

    assert(collect({1, 2, 3, 4, 5}):shuffle():count() == 5)
end

--[[ slice ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):slice(4):all(),
        {5, 6, 7, 8, 9, 10}
    )

    assert_tables_equal(
        collect({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):slice(4, 2):all(),
        {5, 6}
    )
end

--[[ sort ]]--
do
    assert_tables_equal(
        collect({5, 3, 1, 2, 4}):sort():all(),
        {1, 2, 3, 4, 5}
    )

    assert_tables_equal(
        collect({
            {application = 'Google +', users = 12},
            {application = 'Facebook', users = 593},
            {application = 'MySpace', users = 62}
        }):sort('users'):all(),
        {
            {application = 'Google +', users = 12},
            {application = 'MySpace', users = 62},
            {application = 'Facebook', users = 593}
        }
    )

    assert_tables_equal(
        collect({
            {name = 'Desk', colors = {'Black', 'Mahogany'}},
            {name = 'Chair', colors = {'Black'}},
            {name = 'Bookcase', colors = {'Red', 'Beige', 'Brown'}}
        }):sort(function(a, b)
            return #a['colors'] < #b['colors']
        end):all(),
        {
            {name = 'Chair', colors = {'Black'}},
            {name = 'Desk', colors = {'Black', 'Mahogany'}},
            {name = 'Bookcase', colors = {'Red', 'Beige', 'Brown'}}
        }
    )
end

--[[ sortDesc ]]--
do
    assert_tables_equal(
        collect({5, 3, 1, 2, 4}):sortDesc():all(),
        {5, 4, 3, 2, 1}
    )

    assert_tables_equal(
        collect({
            {application = 'Google +', users = 12},
            {application = 'Facebook', users = 593},
            {application = 'MySpace', users = 62}
        }):sortDesc('users'):all(),
        {
            {application = 'Facebook', users = 593},
            {application = 'MySpace', users = 62},
            {application = 'Google +', users = 12}
        }
    )

    assert_tables_equal(
        collect({
            {name = 'Desk', colors = {'Black', 'Mahogany'}},
            {name = 'Chair', colors = {'Black'}},
            {name = 'Bookcase', colors = {'Red', 'Beige', 'Brown'}}
        }):sortDesc(function(a, b)
            return #a['colors'] < #b['colors']
        end):all(),
        {
            {name = 'Bookcase', colors = {'Red', 'Beige', 'Brown'}},
            {name = 'Desk', colors = {'Black', 'Mahogany'}},
            {name = 'Chair', colors = {'Black'}}
        }
    )
end

--[[ splice ]]--
do
    local collection1 = collect({1, 2, 3, 4, 5})

    assert_tables_equal(
        collection1:splice(2):all(),
        {3, 4, 5}
    )

    assert_tables_equal(
        collection1:all(),
        {1, 2}
    )



    local collection2 = collect({1, 2, 3, 4, 5})

    assert_tables_equal(
        collection2:splice(2, 2):all(),
        {3, 4}
    )

    assert_tables_equal(
        collection2:all(),
        {1, 2, 5}
    )



    local collection3 = collect({1, 2, 3, 4, 5})

    assert_tables_equal(
        collection3:splice(2, 2, {'c', 'd'}):all(),
        {3, 4}
    )

    assert_tables_equal(
        collection3:all(),
        {1, 2, 'c', 'd', 5}
    )
end

--[[ split ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4, 5}):split(3):all(),
        { {1, 2}, {3, 4}, {5} }
    )

    assert_tables_equal(
        collect({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):split(3):all(),
        { {1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10} }
    )
end

--[[ sum ]]--
do
    assert(collect({1, 2, 3, 4, 5}):sum() == 15)

    assert(collect({ {pages = 176}, {pages = 1096} }):sum('pages') == 1272)
end

--[[ take ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4, 5}):take(2):all(),
        {1, 2}
    )

    assert_tables_equal(
        collect({1, 2, 3, 4, 5}):take(-2):all(),
        {4, 5}
    )
end

--[[ tap ]]--
do
    local count
    collect({1, 2, 3, 4, 5}):tap(function(collection)
        count = collection:count()
    end)
    assert(count == 5)
end

--[[ times ]]--
do
    assert_tables_equal(
        Collection:times(10, function(count)
            return count * 9
        end):all(),
        {9, 18, 27, 36, 45, 54, 63, 72, 81, 90}
    )
end

--[[ toJSON ]]--
do
    local jsonString = collect({
        {name = 'Desk', colors = {'Black', 'Mahogany'}},
        {name = 'Chair', colors = {'Black'}},
        {name = 'Bookcase', colors = {'Red', 'Beige', 'Brown'}}
    }):toJSON()

    assert(jsonString == '[{"name":"Desk","colors":["Black","Mahogany"]},{"name":"Chair","colors":["Black"]},{"name":"Bookcase","colors":["Red","Beige","Brown"]}]')
end

--[[ toString ]]--
do
    local tableString = collect({
        {name = 'Desk', colors = {'Black', 'Mahogany'}},
        {name = 'Chair', colors = {'Black'}},
        {name = 'Bookcase', colors = {'Red', 'Beige', 'Brown'}}
    }):toString()

    assert(tableString == '{[1]={name="Desk",colors={[1]="Black",[2]="Mahogany"}},[2]={name="Chair",colors={[1]="Black"}},[3]={name="Bookcase",colors={[1]="Red",[2]="Beige",[3]="Brown"}}}')

end

--[[ toTable ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4, 5}):toTable(),
        {1, 2, 3, 4, 5}
    )
end

--[[ transform ]]--
do
    assert_tables_equal(
        collect({1, 2, 3, 4, 5}):transform(function(key, value)
            return value * 2
        end):all(),
        {2, 4, 6, 8, 10}
    )
end

--[[ union ]]--
do
    assert_tables_equal(
        collect({a = 'Hello', b = 'Goodbye'})
            :union({a = 'Howdy', c = 'Pleasure to meet you'})
            :all(),
        {a = 'Hello', b = 'Goodbye', c = 'Pleasure to meet you'}
    )
end

--[[ unique ]]--
do
    assert_tables_equal(
        collect({1, 1, 2, 2, 3, 4, 2}):unique():all(),
        {3, 4}
    )

    assert_tables_equal(
        collect({
            {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
            {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
            {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
            {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'},
            {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'},
            {name = 'Pixel', brand = 'Google', type = 'phone'}
        }):unique('brand'):all(),
        {
            {name = 'Pixel', brand = 'Google', type = 'phone'}
        }
    )

    assert_tables_equal(
        collect({
            {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
            {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
            {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
            {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'},
            {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'},
            {name = 'Pixel', brand = 'Google', type = 'phone'}
        }):unique(function(key, value)
            return value['brand'] .. value['type']
        end):all(),
        {
            {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'},
            {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
            {name = 'Pixel', brand = 'Google', type = 'phone'},
            {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'}
        }
    )
end

--[[ when ]]--
do
    assert_tables_equal(
        collect({1, 2, 3}):when(true, function(collection)
            return collection:push(4)
        end):all(),
        {1, 2, 3, 4}
    )
end

--[[ where ]]--
do
    assert_tables_equal(
        collect({
            {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
            {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
            {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
            {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'},
            {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'}
        }):where('type', 'watch'):all(),
        {
            {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
            {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'}
        }
    )
end

--[[ whereIn ]]--
do
    assert_tables_equal(
        collect({
            {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
            {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
            {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
            {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'},
            {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'}
        }):whereIn('name', {'iPhone 6', 'iPhone 5', 'Galaxy S6'}):all(),
        {
            {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
            {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
            {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'}
        }
    )
end

--[[ whereNotIn ]]--
do
    assert_tables_equal(
        collect({
            {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
            {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
            {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
            {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'},
            {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'}
        }):whereNotIn('name', {'iPhone 6', 'iPhone 5', 'Galaxy S6'}):all(),
        {
            {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
            {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'}
        }
    )
end

--[[ zip ]]--
do
    assert_tables_equal(
        collect({'Chair', 'Desk'}):zip({100, 200}):all(),
        { {'Chair', 100}, {'Desk', 200} }
    )

    assert_tables_equal(
        collect({'Chair', 'Desk'}):zip({100, 200, 300}):all(),
        { {'Chair', 100}, {'Desk', 200} }
    )
end

print('All tests passed.')
