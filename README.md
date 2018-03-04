Lua Collections
==========

# Introduction

Collections are like tables on steroids. They are designed to act as a fluent wrapper when working with structured data, offering the developer convenience for common tasks.

For example, we can use the `collect()` helper to create a new collection, shuffle the items around, capitalise the words, add something to it, and then return it in a list suitable for pagination.

```lua
collect({'Cat', 'Dog', 'Mouse', 'Elephant', 'Hamster', 'Lion'})
        :shuffle()
        :map(function(key, value)
            return key, value:upper()
        end)
        :append('Coyote')
        :split(3)
        :all()

--[[
    {
        {'DOG', 'CAT', 'LION'},
        {'MOUSE', 'HAMSTER', 'ELEPHANT'},
        {'Coyote'}
    }
]]
```

This collection class was heavily inspired by the collection functionality found in the [Laravel Framework](https://laravel.com/docs/master/collections) for PHP, and implements many of the methods from it, although with some changes to functionality to account for how Lua handles data.

Please note that most collection methods are immutable, meaning they return a modified copy of the original collection. However, some methods modify the original collection by design: append *(push)*, forget *(remove)*, insert, pop, prepend, pull, put *(set)*, shift, splice

## Features

- Pure Lua - no C package to worry about!
- Wide range of pre-built methods
- Method chaining reads like a sentence, and is easy to understand
- Immutable tables *(for the most part)*
- Convenience for developing
- Tests, open source, and used in production software

## Installing

Collections can be installed into a Lua project like any other Lua package.

1) [LuaRocks](http://luarocks.org/modules/imliam/collections) is a package manager for Lua projects, which can install the Collections library.

2) Include `collections.lua` in the project's directory, and add `Collection = require 'collection'` to the file that collections are to be used in.

## Creating Collections

A collection can be created with the `collect()` helper function, which is merely an alias for [Collection:new()](#method-new). It accepts an existing table as an argument to create the collection, or will be empty if none is supplied.

```lua
collect({'Hello', 'world'})
```

## Available Methods

This section covers all of the available methods.

|  -  |  -  |  -  |  -  |
| --- | --- | --- | --- |
| [all](#method-all) | [append](#method-append) | [average](#method-average) | [avg](#method-avg) |
| [chunk](#method-chunk) | [clone](#method-clone) | [collapse](#method-collapse) | [combine](#method-combine) |
| [contains](#method-contains) | [convertToIndexed](#method-convertToIndexed) | [count](#method-count) | [diff](#method-diff) |
| [diffKeys](#method-diffKeys) | [each](#method-each) | [eachi](#method-eachi) | [equals](#method-equals) |
| [every](#method-every) | [except](#method-except) | [filter](#method-filter) | [first](#method-first) |
| [flatten](#method-flatten) | [flip](#method-flip) | [forEach](#method-forEach) | [forEachi](#method-forEachi) |
| [forget](#method-forget) | [forPage](#method-forPage) | [get](#method-get) | [groupBy](#method-groupBy) |
| [has](#method-has) | [implode](#method-implode) | [insert](#method-insert) | [intersect](#method-intersect) |
| [isAssociative](#method-isAssociative) | [isEmpty](#method-isEmpty) | [isNotEmpty](#method-isNotEmpty) | [keyBy](#method-keyBy) |
| [keys](#method-keys) | [last](#method-last) | [map](#method-map) | [mapWithKeys](#method-mapWithKeys) |
| [max](#method-max) | [mean](#method-mean) | [median](#method-median) | [merge](#method-merge) |
| [min](#method-min) | [mode](#method-mode) | [new](#method-new) | [notAssociative](#method-notAssociative) |
| [nth](#method-nth) | [only](#method-only) | [partition](#method-partition) | [pipe](#method-pipe) |
| [pluck](#method-pluck) | [pop](#method-pop) | [prepend](#method-prepend) | [pull](#method-pull) |
| [push](#method-push) | [put](#method-put) | [random](#method-random) | [reduce](#method-reduce) |
| [reject](#method-reject) | [remove](#method-remove) | [replace](#method-replace) | [resort](#method-resort) |
| [reverse](#method-reverse) | [search](#method-search) | [set](#method-set) | [shift](#method-shift) |
| [shuffle](#method-shuffle) | [slice](#method-slice) | [sort](#method-sort) | [sortAsc](#method-sortAsc) |
| [sortDesc](#method-sortDesc) | [splice](#method-splice) | [split](#method-split) | [sum](#method-sum) |
| [take](#method-take) | [tap](#method-tap) | [times](#method-times) | [toJSON](#method-toJSON) |
| [toString](#method-toString) | [toTable](#method-toTable) | [transform](#method-transform) | [union](#method-union) |
| [unique](#method-unique) | [values](#method-values) | [when](#method-when) | [where](#method-where) |
| [whereIn](#method-whereIn) | [whereNotIn](#method-whereNotIn) | [zip](#method-zip) |

# Method Listing

<a name="method-all"></a>
## `all()`

**Description:** Returns all elements from a collection as a table

**Returns:** `table`

**Example:**

```lua
collect({'Hello', 'world'}):all()

-- {'Hello', 'world'}
```

<hr>

<a name="method-append"></a>
## `append(value)`

**Description:** Adds an item to the end of a collection.

To add an item to the beginning of a collection, see the [prepend](#method-prepend) method.

**Returns:** Original `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | Any | value | The value to be added to the end of the collection |

**Example:**

```lua
collect({1, 2, 3, 4}):append(5):all()
-- {1, 2, 3, 4, 5}
```

<hr>

<a name="method-average"></a>
## `average([key])`

**Description:** Returns the [average value](https://en.wikipedia.org/wiki/Average) of a list or given key

**Returns:** `number`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string` | `key` | *(Optional)* Key to be used in an associative table |

**Example:**

```lua
collect({1, 1, 2, 4}):average()
-- 2

collect({ {foo = 10}, {foo = 10}, {foo = 20}, {foo = 40} }):average('foo')
-- 20
```

<hr>

<a name="method-avg"></a>
## `avg()`

**Description:** Alias for the [Collection:average()](#method-average) method

<hr>

<a name="method-chunk"></a>
## `chunk(count)`

**Description:** Breaks the collection into multiple smaller collections of a given size. Especially useful when dynamically paginating data, or displaying items in a grid. If the count is less than 1, a single empty table will be returned in the collection.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `number` | count | Number of items in each chunk |

**Example:**

```lua
collect({1, 2, 3, 4, 5, 6, 7}):chunk(4):all()
--[[
    {
        {1, 2, 3, 4},
        {5, 6, 7}
    }
]]
```

<hr>

<a name="method-clone"></a>
## `clone()`

**Description:** Returns a copy of the collection.

**Returns:** New `Collection`

**Example:**

```lua
collection = collect({1, 2, 3, 4, 5})

clone = collection:clone():append(6):all()
-- {1, 2, 3, 4, 5, 6}

collection:all()
-- {1, 2, 3, 4, 5}
```

<hr>

<a name="method-collapse"></a>
## `collapse()`

**Description:** Collapses a collection of tables into a single, flat collection

**Returns:** New `Collection`

**Example:**

```lua
collect({ {1, 2, 3}, {4, 5, 6}, {7, 8, 9} }):collapse():all()
-- {1, 2, 3, 4, 5, 6, 7, 8, 9}
```

<hr>

<a name="method-combine"></a>
## `combine(values)`

**Description:** Combines the keys of the collection with the values of another table

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `table` | values | The values to be combined into the main collection |

**Example:**

```lua
collect({'name', 'age'}):combine({'George', 29}):all()
-- {name = 'George', age = 29}
```

<hr>

<a name="method-contains"></a>
## `contains(containValue, recursive)`

**Description:** Determines whether the collection contains a given item as a value.

**Returns:** `boolean`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string` | containValue | The value to be searched for |
| 1 | `function` | containValue | A function to determine a truth test on the value |
| 2 | `boolean` | recursive | If true, the table will be searched recursively for the value |

**Example:**

```lua
collect({'Cat', 'Dog'}):contains('Cat')
-- true

collect({'Cat', 'Dog'}):contains('Walrus')
-- false

collect({evil = 'Cat', good = 'Dog'}):contains('Cat')
-- true

collect({1, 2, 3, 4, 5}):contains(function(key, value)
    return value > 5
end)
-- false

collect({ {'Cat', 'Dog'}, {'Rabbit', 'Mouse'} }):contains('Cat', true)
-- true

assert(collect({ {'Cat', 'Dog'}, {'Rabbit', 'Mouse'} }):contains('Cat')
-- false
```

<hr>

<a name="method-convertToIndexed"></a>
## `convertToIndexed()`

**Description:** Turns an associative table into an indexed one, removing string keys.

**Returns:** New `Collection`

**Example:**

```lua
collect({name = 'Liam', language = 'Lua'}):convertToIndexed():all()
-- {'Liam', 'Lua'}
```

<hr>

<a name="method-count"></a>
## `count()`

**Description:** Returns the total number of items in the collection

**Returns:** `number`

**Example:**

```lua
collect({'a', 'b', 'c', 'd', 'e'}):count()

-- 5
```

<hr>

<a name="method-deal"></a>
## `deal(hands)`

**Description:** Deals the collection into a number of groups in order one at a time - like dealing a hand of cards.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `number` | hands | The number of groups to turn the collection into |

**Example:**

```lua
collect({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):deal(3):all()
--[[
    {
        {1, 4, 7, 10},
        {2, 5, 8},
        {3, 6, 9}
    }
]]
```

<hr>

<a name="method-deassociate"></a>
## `deassociate()`

**Description:** Alias for the [Collection:convertToIndexed()](#method-convertToIndexed) method

<hr>

<a name="method-diff"></a>
## `diff(difference)`

**Description:** Compares a collection against another table based on its values. Returns the values in the original collection that are not present in the given table.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `table` | difference | The value to be represented as a string |

**Example:**

```lua
collect({1, 2, 3, 4, 5, 6}):diff({2, 4, 6, 8}):all()
-- {1, 3, 5}
```

<hr>

<a name="method-diffKeys"></a>
## `diffKeys(difference)`

**Description:** Compares the collection against another table based on its keys. Returns the key / value pairs in the original collection that are not present in the table.


**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `table` | difference | The value to be represented as a string |

**Example:**

```lua
collect({one = 10, two = 20, three = 30, four = 40, five = 50})
        :diffKeys({two = 2, four = 4, six = 6, eight = 8})
        :all()

-- {one = 10, three = 30, five = 50}
```

<hr>

<a name="method-each"></a>
## `each(callback)`

**Description:** Iterates over the items in the collection and passes each to a callback.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | A function to be executed on each item in the collection. Returning `false` from this callback will break the loop. |

**Example:**

```lua
collect({'a', 'b', 'c'}):each(function(key, value)
    print(key, value)
end)

-- 1    a
-- 2    b
-- 3    c
```

<hr>

<a name="method-eachi"></a>
## `eachi(callback)`

**Description:** Iterates over the items with a consecutive numeric index in the collection and passes each to a callback.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | A function to be executed on each item in the collection. Returning `false` from this callback will break the loop. |

**Example:**

```lua
collect({'a', 'b', 'c', key = 'Value', [26] = 'z'}):eachi(function(key, value)
    print(key, value)
end)

-- 1    a
-- 2    b
-- 3    c
```

<hr>

<a name="method-equals"></a>
## `equals(tbl, ignoreMetaTables, [subtbl])`

**Description:** Compares a table with the internal table of the collection to determine if they are the same.

**Returns:** `boolean`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `table` | tbl | The table to compare to the collection. |
| 1 | `boolean` | ignoreMetaTables | If true, metatables won't be compared. |
| 1 | `table` | subtbl | *(Internal argument)* Optionally compare a table other than the collection's internal table. |

**Example:**

```lua
collect({'a', 'b', 'c'}):equals({'a', 'b', 'c'})
-- true

collect({'a', 'b', 'c'}):equals({'Liam', 'Taylor', 'Jeffrey'})
-- false
```

<hr>

<a name="method-every"></a>
## `every(callback)`

**Description:** Verify that all elements of the collection pass a truth test

**Returns:** `boolean`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | The function that will return a boolean based on a given truth test |

**Example:**

```lua
collect({1, 2, 3, 4}):every(function(key, value)
    return value > 2
end)
-- false
```

<hr>

<a name="method-except"></a>
## `except(keys)`

**Description:** Returns all items in the collection except those with specified keys.

For the inverse of `except`, see the [only](#method-only) method.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `table` | keys | The list of keys to be checked against |

**Example:**

```lua
collect({productID = 1, price=100, discount = false})
        :except({'price', 'discount'})
        :all()

-- {productID = 1}
```

<hr>

<a name="method-filter"></a>
## `filter([callback])`

**Description:** Filters the collection using the given callback, keeping only items that pass a truth test. If no callback is supplied, any "falsy" values will be removed. The items in the resulting collection retain their original keys

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | The function that will return a boolean based on a given truth test |

**Example:**

```lua
collect({1, 2, 3, 4}):filter(function(key, value)
    return value > 2
end):all()
-- {[3] = 3, [4] = 4}

collect({1, 2, 3, nil, false, '', 0, {}}):filter():all()
-- {1, 2, 3}
```

<hr>

<a name="method-first"></a>
## `first([callback])`

**Description:** Returns the first element in the collection, or if a callback is given, the last element that passes a truth test.

To get the last item in a collection, see the [last](#method-last) method.

**Returns:** Item inside the collection

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | The function to determine if the value is true |

**Example:**

```lua
collect({1, 2, 3, 4}):first()
-- 1

collect({1, 2, 3, 4}):first(function(key, value)
    return value > 2
end)
-- 3
```

<hr>

<a name="method-flatten"></a>
## `flatten(depth, [tbl], [currentDepth])`

**Description:** Flattens a multi-dimensional collection into a single dimension.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `number` | depth | The amount of levels deep into subtables the flattening should occur |
| 2 | `table` | tbl | *(Internal argument)* Used to pass a sub-table to flatten |
| 3 | `number` | currentDepth | *(Internal argument)* The depth of the current iteration |

**Example:**

```lua
collect({name = 'Taylor', languages = {'php', 'javascript', 'lua'} }):flatten():all()
-- {'Taylor', 'php', 'javascript', 'lua'}

collect({Apple = {name = 'iPhone 6S', brand = 'Apple'}, Samsung = {name = 'Galaxy S7', brand = 'Samsung'} })
        :flatten(1):values():all()
--[[
    {
        {name = 'iPhone 6S', brand = 'Apple'},
        {name = 'Galaxy S7', brand = 'Samsung'}
    }
]]
```

<hr>

<a name="method-flip"></a>
## `flip()`

**Description:** Swaps the collection's keys with their corresponding values.

**Returns:** New `Collection`

**Example:**

```lua
collect({name = 'Liam', language = 'Lua'}):flip():all()
-- {Liam = 'name', Lua = 'language'}
```

<hr>

<a name="method-forEach"></a>
## `forEach()`

**Description:** Alias for the [Collection:each()](#method-each) method

<hr>

<a name="method-forEachi"></a>
## `forEachi()`

**Description:** Alias for the [Collection:eachi()](#method-eachi) method

<hr>

<a name="method-forget"></a>
## `forget(key)`

**Description:** Removes an item from the collection by its key.

**Returns:** Original `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | key | The key of the value in the collection |

**Example:**

```lua
collect({name = 'Liam', language = 'Lua'}):forget('language'):all()
-- {name = 'Liam'}
```

<hr>

<a name="method-forPage"></a>
## `forPage(pageNumber, perPage)`

**Description:** Returns a collection containing the items that would be present for a given page number.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `number` | pageNumber | The number of the current page |
| 2 | `number` | perPage | The number of items to show per page |

**Example:**

```lua
collect({1, 2, 3, 4, 5, 6, 7, 8, 9}):forPage(2, 3):all()
-- {4, 5, 6}
```

<hr>

<a name="method-get"></a>
## `get(key, [default])`

**Description:** Returns the item of a given key

**Returns:** Any

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | key | The value to be represented as a string |
| 2 | Any | default | *(Optional)* A value to be returned if the value was not found in the collection. If this is a function, it will be executred as a callback |

**Example:**

```lua
collect({name = 'Liam', language = 'Lua'}):get('name')
-- 'Liam'

collect({name = 'Liam', language = 'Lua'}):get('foo', 'Default value')
-- 'Default value'

collect({name = 'Liam', language = 'Lua'}):get('foo', function(key)
    return '"' .. key .. '" was not found in the collection'
end)
-- '"foo" was not found in the collection'
```

<hr>

<a name="method-groupBy"></a>
## `groupBy(groupKey)`

**Description:** Groups the collection's items by a given key

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | groupKey | Key to group the collections by |

**Example:**

```lua
collect({
    {name = 'Liam', language = 'Lua'},
    {name = 'Jeffrey', language = 'PHP'},
    {name = 'Taylor', language = 'PHP'}
}):groupBy('language'):all()

--[[
    {
        PHP = {
            {name = 'Jeffrey', language = 'PHP'},
            {name = 'Taylor', language = 'PHP'}
        },
        Lua = {
            {name = 'Liam', language = 'Lua'}
        }
    }
]]
```

<hr>

<a name="method-has"></a>
## `has(key)`

**Description:** Determines if a given key exists in the collection

**Returns:** `boolean`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | key | The key to be checked for in the collection |

**Example:**

```lua
collect({name = 'Liam', language = 'Lua'}):has('language')
-- true
```

<hr>

<a name="method-implode"></a>
## `implode(implodedKey, [delimeter = ', '])`

**Description:** Joins the items in a collection into a string

**Returns:** `string`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | implodedKey | The key to implode the value of. Not required if the table has one dimension (If so, delimeter takes place of this argument in the function call) |
| 2 | `string` | delimeter | *(Optional)* String to use as a delimeter between items |

**Example:**

```lua
collect({'Lua', 'PHP'}):implode()
-- 'Lua, PHP'

collect({'Lua', 'PHP'}):implode(' | ')
-- 'Lua | PHP'

collect({
    {name = 'Liam', language = 'Lua'},
    {name = 'Jeffrey', language = 'PHP'}
}):implode('language')
-- 'Lua, PHP'

collect({
    {name = 'Liam', language = 'Lua'},
    {name = 'Jeffrey', language = 'PHP'}
}):implode('language', ' | ')
-- 'Lua | PHP'
```

<hr>

<a name="method-insert"></a>
## `insert(value, position)`

**Description:** Inserts a value at a given numeric index.

**Returns:** Original `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | Any | value | The value to be inserted into the collection |
| 2 | `number` | position | Position in the collection to insert the new value |

**Example:**

```lua
collect({'Cat', 'Dog', 'Hamster', 'Walrus'}):insert('Mouse', 3):all()
-- {'Cat', 'Dog', 'Mouse', 'Hamster', 'Walrus'}
```

<hr>

<a name="method-intersect"></a>
## `intersect(intersection)`

**Description:** Removes any values from the original collection that are not present in the passed table. The resulting collection preserves the original collection's keys.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `table` | intersection | The list of values to intersect with the original collection |

**Example:**

```lua
collect({'Desk', 'Sofa', 'Chair'})
        :intersect({'Desk', 'Chair', 'Bookcase'})
        :all()
-- {[1] = 'Desk', [3] = 'Chair'}
```

<a name="method-isAssociative"></a>
## `isAssociative()`

**Description:** Determines whether the collection is associative, or has ordered string keys.

**Returns:** `boolean`

**Example:**

```lua
collect({1, 2, 3, 4, 5}):isAssociative()
-- false

collect({name = 'Liam', language = 'Lua'}):isAssociative()
-- true
```

<hr>

<a name="method-isEmpty"></a>
## `isEmpty()`

**Description:** Determines if the collection is empty.

To determine if a collection contains values, see the [isNotEmpty](#method-isNotEmpty) method.

**Returns:** `boolean`

**Example:**

```lua
collect({'Desk', 'Sofa', 'Chair'}):isEmpty()
-- false

collect():isEmpty()
-- true
```

<hr>

<a name="method-isNotEmpty"></a>
## `isNotEmpty()`

**Description:** Determines if the collection is not empty.

To determine if a collection contains no values, see the [isEmpty](#method-isEmpty) method.

**Returns:** `boolean`

**Example:**

```lua
collect({'Desk', 'Sofa', 'Chair'}):isNotEmpty()
-- true

collect():isNotEmpty()
-- false
```

<a name="method-keyBy"></a>
## `keyBy(keyName)`

**Description:** Keys the collection by the given key. If multiple items have the same key, only the last one will appear in the returned collection.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | keyName | The key for the collection's value to be identified by |
| 1 | `function` | keyName | The callback function to determine a key value for the collection |

**Example:**

```lua
collect({
    {name = 'Liam', language = 'Lua'},
    {name = 'Jeffrey', language = 'PHP'}
}):keyBy('language'):all()

--[[
    {
        Lua = {name = 'Liam', language = 'Lua'},
        PHP = {name = 'Jeffrey', language = 'PHP'}
    }
]]


collect({
    {name = 'Liam', language = 'Lua'},
    {name = 'Jeffrey', language = 'PHP'}
}):keyBy(function(key, value)
    return value['language']:lower()
end):all()

--[[
    {
        lua = {name = 'Liam', language = 'Lua'},
        php = {name = 'Jeffrey', language = 'PHP'}
    }
]]
```

<hr>

<a name="method-keys"></a>
## `keys()`

**Description:** Returns a list of the collection's keys

**Returns:** New `Collection`

**Example:**

```lua
collect({name = 'Liam', language = 'Lua'}):keys():all()
-- {'name', 'language'}
```

<hr>

<a name="method-last"></a>
## `last([callback])`

**Description:** Returns the last element in the collection, or if a callback is given, the last element that passes a truth test.

To get the first item in a collection, see the [first](#method-first) method.

**Returns:** Item inside the collection

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | The function to determine if the value is true |

**Example:**

```lua
collect({1, 2, 3, 4}):last()
-- 4

collect({1, 2, 3, 4}):last(function(key, value)
    return value > 2
end)
-- 4
```

<hr>

<a name="method-map"></a>
## `map(callback)`

**Description:** Iterates through the collection and passes each value to the callback, which can then modify the values, forming a new collection.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | The function to determine the changes to be made to the current iteration's key and value. |

**Example:**

```lua
collect({1, 2, 3, 4, 5}):map(function(key, value)
    return key, value * 2
end):all()
-- {2, 4, 6, 8, 10}
```

<hr>

<a name="method-mapWithKeys"></a>
## `mapWithKeys(callback)`

**Description:** Iterates through the the collection and remaps the key and value based on the return of a callback.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | A function that returns a key / value pair |

**Example:**

```lua
collect({
    {name = 'Liam', language = 'Lua'},
    {name = 'Jeffrey', language = 'PHP'}
}):mapWithKeys(function(key, value)
    return value['language'], value['name']
end):all()
--[[
    {
        Lua = 'Liam',
        PHP = 'Jeffrey'
    }
]]
```

<hr>

<a name="method-max"></a>
## `max([maxKey])`

**Description:** Returns the maximum value of a set of given values.

For the reverse of `max`, see the [min](#method-min) method.

**Returns:** `number`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string` | maxKey | The key to be evaluated in an associative table |

**Example:**

```lua
collect({1, 2, 3, 4, 5}):max()
-- 5

collect({ {foo = 10}, {foo = 20} }):max('foo')
-- 20
```

<hr>

<a name="method-mean"></a>
## `mean()`

**Description:** Alias for the [Collection:average()](#method-average) method

<hr>

<a name="method-median"></a>
## `median([medianKey])`

**Description:** Returns the [median value](https://en.wikipedia.org/wiki/Median) of a set of given values.

**Returns:** `number`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string` | medianKey | The key to be evaluated in an associative table |

**Example:**

```lua
collect({1, 1, 2, 4}):median()
-- 1.5

collect({ {foo = 10}, {foo = 10}, {foo = 20}, {foo = 40} }):median('foo')
-- 15
```

<hr>

<a name="method-merge"></a>
## `merge(toMerge)`

**Description:** Merges the given table with the original collection. If a string key in the passed table matches a string key in the original collection, the given table's value will overwrite the value in the original collection.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `table` | toMerge | The table to merge into the collection |

**Example:**

```lua
collect({'Desk', 'Chair'}):merge({'Bookcase', 'Door'}):all()
-- {'Desk', 'Chair', 'Bookcase', 'Door'}

collect({name = 'Liam', language = 'Lua'})
        :merge({name = 'Taylor', experiencedYears = 14 })
        :all()
-- {name = 'Taylor', language = 'Lua', experiencedYears = 14}
```

<hr>

<a name="method-min"></a>
## `min([minKey])`

**Description:** Returns the minimum value of a set of given values.

For the reverse of `min`, see the [max](#method-max) method.

**Returns:** `number`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string` | minKey | The key to be evaluated in an associative table |

**Example:**

```lua
collect({1, 2, 3, 4, 5}):min()
-- 1

collect({ {foo = 10}, {foo = 20} }):min('foo')
-- 10
```

<hr>

<a name="method-mode"></a>
## `mode([modeKey])`

**Description:** Returns the <a href="https://en.wikipedia.org/wiki/Mode_(statistics)">mode value</a> of a given key. The value returned is a collection of numbers.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string` | modeKey | The key to be evaluated in an associative table |

**Example:**

```lua
collect({1, 1, 2, 4}):mode():all()
-- {1}

collect({ {foo = 10}, {foo = 10}, {foo = 20}, {foo = 20}, {foo = 40} })
    :mode('foo')
    :all()
-- {10, 20}
```

<hr>

<a name="method-new"></a>
## `new([tbl])`

**Description:** Creates a new collection instance

**Returns:** `Collection` *New (new)*

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `table` | tbl | *(Optional)* Table to use for the collection. If no table is passed, the collection will assume a blank one |

**Example:**

```lua
Collection:new({'Hello', 'world'}):all()

-- {'Hello', 'world'}
```

<hr>

<a name="method-nth"></a>
## `nth(step, [offset])`

**Description:** -- Creates a new collection consisting of every nth element, with an optional offset.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `number` | step | The nth step to be returned |
| 2 | `number` | offset | *(Optional)* A value to offset the nth result by |

**Example:**

```lua
collect({'a', 'b', 'c', 'd', 'e', 'f'}):nth(4):all()
-- {'a', 'e'}

collect({'a', 'b', 'c', 'd', 'e', 'f'}):nth(4, 1):all()
-- {'b', 'f'}
```

<hr>

<a name="method-only"></a>
## `only(keys)`

**Description:** Returns only the items in the collection with the specified keys.

For the inverse of `only`, see the [except](#method-except) method.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `table` | keys | The list of keys to be returned from the original collection |

**Example:**

```lua
collect({name = 'Taylor', language = 'Lua', experiencedYears = 14})
        :only({'name', 'experiencedYears'})
        :all()
-- {name = 'Taylor', experiencedYears = 14}
```

<hr>

<a name="method-partition"></a>
## `partition(callback)`

**Description:** Returns a pair of collections, one containing elements that pass a given truth test, and the other containing elements that fail the given truth test.

**Returns:** `Collection`, `Collection` *New (pair)*

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | A function to determine a truth test on the value |

**Example:**

```lua
passed, failed = collect({1, 2, 3, 4, 5, 6}):partition(function(key, value)
    return value < 3
end)

passed:all()
-- {1, 2}
failed:all()
--{3, 4, 5, 6}
```

<hr>

<a name="method-pipe"></a>
## `pipe(callback)`

**Description:** Passes the collection to the given callback and returns the result.

**Returns:** The return value of the callback

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | The function to execute |

**Example:**

```lua
collect({1, 2, 3}):pipe(function(collection)
    return collection:sum()
end)
-- 6
```

<hr>

<a name="method-pluck"></a>
## `pluck(valueName, [keyName])`

**Description:** Retrives all of the values for a given key.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string` | valueName | The string key of the value to be plucked from the collection |
| 2 | `string` | keyName | *(Optional)* The name of the key to be set as the key for valueName in the resulting collection |

**Example:**

```lua
collect({
    {name = 'Liam', language = 'Lua'},
    {name = 'Jeffrey', language = 'PHP'}
}):pluck('name'):all()
-- {'Liam', 'Jeffrey'}

collect({
    {name = 'Liam', language = 'Lua'},
    {name = 'Jeffrey', language = 'PHP'}
}):pluck('name', 'language'):all()
-- {Lua = 'Liam', PHP = 'Jeffrey'}
```

<hr>

<a name="method-pop"></a>
## `pop()`

**Description:** Removes and returns the last item from the collection. This method modifies the original collection.

To remove and return the first item in a collection, see the [shift](#method-shift) method.

**Returns:** Last item from the collection

**Example:**

```lua
collection = collect({1, 2, 3, 4, 5})

collection:pop()
-- 5

collection:all()
-- {1, 2, 3, 4}
```

<hr>

<a name="method-prepend"></a>
## `prepend(value)`

**Description:** Adds an item to the beginning of the collection.

To add an item to the end of a collection, see the [append](#method-append) method.

**Returns:** Original `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | Any | value | The value to be added to the beginning of the collection |

**Example:**

```lua
collection = collect({1, 2, 3, 4, 5})
collection:prepend(0)
collection:all()
-- {0, 1, 2, 3, 4, 5}
```

<hr>

<a name="method-pull"></a>
## `pull(key)`

**Description:** Removes and returns an item from the collection by key. This method modifies the original collection.

**Returns:** Item from the collection

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string` | key | The key of the value in the collection |

**Example:**

```lua
collection = collect({name = 'Liam', language = 'Lua'})

collection:pull('language')
-- 'Lua'

collection:all()
-- {name = 'Liam'}
```

<hr>

<a name="method-push"></a>
## `push()`

**Description:** Alias for the [Collection:append()](#method-append) method

<hr>

<a name="method-put"></a>
## `put(key, value)`

**Description:** Sets the given key and value in the collection. If a key already exists in the collection, it is overwritten.

**Returns:** Original `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | key | The key of the item to be set in the collection |
| 2 | Any | value | The value of the item to be set in the collection |

**Example:**

```lua
collect({name = 'Liam', language = 'Lua'})
        :put('count', 12)
        :all()

-- {name = 'Liam', language = 'Lua', count = 12}
```

<hr>

<a name="method-random"></a>
## `random([count = 1], [rep = false])`

**Description:** Returns a random item or as many random unique items from the collection as possible.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `number` | count | The number of items to be returned from the collection. |
| 2 | `boolean` | rep | Whether items can be repeated in the return value. |

**Example:**

```lua
collect({1, 2, 3, 4, 5}):random():first()
-- 4

collect({1, 2, 3, 4, 5}):random(3)
-- {2, 4, 5}

collect({1, 2, 3, 4, 5}):random(10)
-- {2, 4, 5, 1, 3}

collect({1, 2, 3, 4, 5}):random(10, true)
-- {5, 2, 3, 3, 1, 4, 1, 2, 3, 5}
```

<hr>

<a name="method-reduce"></a>
## `reduce(callback, [default])`

**Description:** Reduces the collection to a single value, passing the result of each iteration into the next.

**Returns:** Value returned by the callback

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | Function to iterate over the collection with |
| 2 | Any | default | The default value for carry, as one is not set before the first iteration |

**Example:**

```lua
collect({1, 2, 3}):reduce(function(carry, value)
    return carry + value
end, 4)
-- 10
```

<hr>

<a name="method-reject"></a>
## `reject(callback)`

**Description:** Filters the collection using the given fallback. If the callback returns `true`, the item is removed from the collection.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | The function for a truth test to be executed in |

**Example:**

```lua
collect({1, 2, 3, 4}):reject(function(key, value)
    return value > 2
end):all()
-- {1, 2}
```

<hr>

<a name="method-remove"></a>
## `remove()`

**Description:** Alias for the [Collection:forget()](#method-forget) method

<hr>

<a name="method-replace"></a>
## `replace()`

**Description:** Alias for the [Collection:splice()](#method-splice) method

<hr>

<a name="method-resort"></a>
## `resort()`

**Description:** Fixes numerical keys to put them in consecutive order.

**Returns:** New `Collection`

**Example:**

```lua
collect({[1] = 'a', [5] = 'b'}):resort():all()
-- {[1] = 'a', [2] = 'b'}
```

<hr>

<a name="method-reverse"></a>
## `reverse()`

**Description:** Reverses the order of the numerical keys in the collection.

**Returns:** New `Collection`

**Example:**

```lua
collect({1, 2, 3, 4, 5}):reverse():all()
-- {5, 4, 3, 2, 1}
```

<hr>

<a name="method-search"></a>
## `search(callback)`

**Description:** Searches the collection for a value and returns the key of the first valid result.

**Returns:** `string`, `number`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number`, `boolean` | callback | The value to be found in the collection |
| 1 | `function` | callback | A callback function to perform a truth test |

**Example:**

```lua
collect({2, 4, 6, 8}):search(4)
-- 2

collect({2, 4, 6, 8}):search(function(key, value)
    return value > 5
end)
-- 3
```

<hr>

<a name="method-set"></a>
## `set()`

**Description:** Alias for the [Collection:put()](#method-put) method

<hr>

<a name="method-shift"></a>
## `shift()`

**Description:** Removes and returns the first item from the collection. This method modifies the original collection.

To remove and return the last item in a collection, see the [pop](#method-pop) method.

**Returns:** First item from the collection

**Example:**

```lua
collection = collect({1, 2, 3, 4, 5})

collection:shift()
-- 1

collection:all()
-- {2, 3, 4, 5}
```

<hr>

<a name="method-shuffle"></a>
## `shuffle()`

**Description:** Randomly shuffles the order of items in the collection.

**Returns:** New `Collection`

**Example:**

```lua
collect({1, 2, 3, 4, 5}):shuffle():all()
-- {3, 2, 5, 1, 4}
```

<hr>

<a name="method-slice"></a>
## `slice(index, [length])`

**Description:** Returns a slice of the collection at the given numerical index.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `number` | index | The numerical index to start the slice at |
| 2 | `number` | length | *(Optional)* The number of items to include in the slice. If this is left blank, the slice will contain all items in the collection with an index higher than the given index |

**Example:**

```lua
collect({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):slice(4):all()
-- {5, 6, 7, 8, 9, 10}

collect({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):slice(4, 2):all()
-- {5, 6}
```

<hr>

<a name="method-sort"></a>
## `sort([callback])`

**Description:** Sorts the items in the collection.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | callback | *(Optional)* The key of an associative table to sort by |
| 1 | `function` | callback | *(Optional)* A function to define a custom algorithm to sort by |

**Example:**

```lua
collect({5, 3, 1, 2, 4}):sort():all()
-- {1, 2, 3, 4, 5}

collect({
    {application = 'Google +', users = 12},
    {application = 'Facebook', users = 593},
    {application = 'MySpace', users = 62}
}):sort('users'):all()
--[[
    {
        {application = 'Facebook', users = 593},
        {application = 'MySpace', users = 62},
        {application = 'Google +', users = 12}
    }
]]

collect({
    {name = 'Desk', colors = {'Black', 'Mahogany'}},
    {name = 'Chair', colors = {'Black'}},
    {name = 'Bookcase', colors = {'Red', 'Beige', 'Brown'}}
}):sort(function(a, b)
    return #a['colors'] < #b['colors']
end):all()
--[[
    {
        {name = 'Chair', colors = {'Black'}},
        {name = 'Desk', colors = {'Black', 'Mahogany'}},
        {name = 'Bookcase', colors = {'Red', 'Beige', 'Brown'}}
    }
]]
```

<hr>

<a name="method-sortAsc"></a>
## `sortAsc()`

**Description:** Alias for the [Collection:sort()](#method-sort) method.

<hr>

<a name="method-sortDesc"></a>
## `sortDesc()`

**Description:** `sortDesc()` accepts the same arguments as the [Collection:sort()](#method-sort) method, but will sort the collection in the opposite order.

<hr>

<a name="method-splice"></a>
## `splice(index, [size], [replacements])`

**Description:** Returns a slice of items from the original collection, and optionally also replaces them. This method modifies the original collection

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `number` | index | The numerical index to start the slice at |
| 2 | `number` | length | *(Optional)* The number of items to include in the slice. If this is left blank, the slice will contain all items in the collection with an index higher than the given index |
| 3 | `table` | replacements | *(Optional)* New list of items to replace the ones removed from the collection |

**Example:**

```lua
collection1 = collect({1, 2, 3, 4, 5})

collection1:splice(2):all()
-- {3, 4, 5}

collection1:all()
-- {1, 2}



collection2 = collect({1, 2, 3, 4, 5})

collection2:splice(2, 2):all()
-- {3, 4}

collection2:all()
-- {1, 2, 5}



collection3 = collect({1, 2, 3, 4, 5})

collection3:splice(2, 2, {'c', 'd'}):all()
-- {3, 4}

collection3:all()
-- {1, 2, 'c', 'd', 5}
```

<hr>

<a name="method-split"></a>
## `split(count)`

**Description:** Breaks the collection into the given number of groups, provided the original collection has at least that many. Note that the groups will be first-heavy, not evenly distributed.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `number` | count | The number of groups to split the collection into |

**Example:**

```lua
collect({1, 2, 3, 4, 5}):split(3):all()
--[[
    {
        {1, 2},
        {3, 4},
        {5}
    }
]]

collect({1, 2, 3, 4, 5, 6, 7, 8, 9, 10}):split(3):all()
--[[
    {
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 10}
    }
]]
```

<hr>

<a name="method-sum"></a>
## `sum([key])`

**Description:** Returns the sum of items in the collection

**Returns:** `number`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string` | key | *(Optional)* Key to be used in an associative table |

**Example:**

```lua
collect({1, 2, 3, 4, 5}):sum()
-- 15

collect({ {pages = 176}, {pages = 1096} }):sum('pages')
-- 1272
```

<hr>

<a name="method-take"></a>
## `take(count)`

**Description:** Returns a collection with the specified number of items.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `number` | count | The number of items to take. If the count is negative, it will take the the specified number of items from the end of the collection |

**Example:**

```lua
collect({1, 2, 3, 4, 5}):take(2):all()
-- {1, 2}

collect({1, 2, 3, 4, 5}):take(-2):all()
-- {4, 5}
```

<hr>

<a name="method-tap"></a>
## `tap(callback)`

**Description:** Executes the given callback, passing the collection as an argument, without affecting the collection itself.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | The function to be executed |

**Example:**

```lua
collect({1, 2, 3, 4, 5}):tap(function(collection)
    print('There are ' .. collection:count() .. ' items in the collection.')
end)
```

<hr>

<a name="method-times"></a>
## `times(count, callback)`

**Description:** Creates a new collection by invoking the callback a given amount of times.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `number` | count | Number of times the callback should be executed |
| 2 | `function` | callback | The callback function to execute a number of times |

**Example:**

```lua
Collection:times(10, function(count)
    return count * 9
end):all()
-- {9, 18, 27, 36, 45, 54, 63, 72, 81, 90}
```

<hr>

<a name="method-toJSON"></a>
## `toJSON()`

**Description:** Returns a JSON string representation of the collection's values

**Returns:** `string`

**Example:**

```lua
collect({
    {name = 'Desk', colors = {'Black', 'Mahogany'}},
    {name = 'Chair', colors = {'Black'}},
    {name = 'Bookcase', colors = {'Red', 'Beige', 'Brown'}}
}):toJSON()

-- '[{"name" : 'Desk', "colors" : ['Black', 'Mahogany']},{"name" : 'Chair', "colors" : ['Black']},{"name" : 'Bookcase', "colors" : ['Red', 'Beige', 'Brown']}]'
```

<hr>

<a name="method-toString"></a>
## `toString()`

**Description:** Returns a string representation of a Lua table, to be used by the native Lua `load()` function.

**Returns:** `string`

**Example:**

```lua
collect({
    {name = 'Desk', colors = {'Black', 'Mahogany'}},
    {name = 'Chair', colors = {'Black'}},
    {name = 'Bookcase', colors = {'Red', 'Beige', 'Brown'}}
}):toString()

-- '{{name = "Desk", colors = {"Black", "Mahogany"}},{name = "Chair", colors = {"Black"}},{name = "Bookcase", colors = {"Red", "Beige", "Brown"}}}'
```

<hr>

<a name="method-toTable"></a>
## `toTable()`

**Description:** Returns a reference to the underlying table of the collection.

**Returns:** `table`

**Example:**

```lua
collect({1, 2, 3, 4, 5}):toTable()
-- {1, 2, 3, 4, 5}
```

<hr>

<a name="method-transform"></a>
## `transform(callback)`

**Description:** Iterates over the collection and calls the given callback with each item in the collection, replacing the values in the collection with the response.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `function` | callback | The function to execute to determine the new value of a collection's current iteration |

**Example:**

```lua
collect({1, 2, 3, 4, 5}):transform(function(key, value)
    return value * 2
end):all()
-- {2, 4, 6, 8, 10}
```

<hr>

<a name="method-union"></a>
## `union(tbl)`

**Description:** Adds the given table to the collection. If the given table contains keys that are in the collection, the original collection's values will be kept.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `table` | tbl | The table to add to the collection |

**Example:**

```lua
collect({a = 'Hello', b = 'Goodbye'})
        :union({a = 'Howdy', c = 'Pleasure to meet you'})
        :all()
-- {a = 'Hello', b = 'Goodbye', c = 'Pleasure to meet you'}
```

<hr>

<a name="method-unique"></a>
## `unique(callback)`

**Description:** Returns all of the unique items in the collection

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | callback | The key to be checked for uniqueness in an associative table |
| 1 | `function` | callback | A callback that returns a custom uniqueness value |

**Example:**

```lua
collect({1, 1, 2, 2, 3, 4, 2}):unique():all()
-- {3, 4}



collect({
    {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
    {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
    {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
    {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'},
    {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'},
    {name = 'Pixel', brand = 'Google', type = 'phone'}
}):unique('brand'):all()
--[[
    {
        {name = 'Pixel', brand = 'Google', type = 'phone'}
    }
]]



collect({
    {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
    {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
    {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
    {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'},
    {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'},
    {name = 'Pixel', brand = 'Google', type = 'phone'}
}):unique(function(key, value)
    return value['brand'] .. value['type']
end):all()
--[[
    {
        {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'},
        {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
        {name = 'Pixel', brand = 'Google', type = 'phone'},
        {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'}
    }
]]
```

<hr>

<a name="method-values"></a>
## `values()`

**Description:** Alias for the [Collection:resort()](#method-resort) method

<hr>

<a name="method-when"></a>
## `when(condition, callback)`

**Description:** Executes the given callback when a condition is met.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `boolean` | condition | The condition to check, if `true`, the callback function will be executed |
| 2 | `function` | callback | The function to be executed when the condition is met |

**Example:**

```lua
collect({1, 2, 3}):when(true, function(collection)
    return collection:push(4)
end):all()
-- {1, 2, 3, 4}
```

<hr>

<a name="method-where"></a>
## `where(filterKey, filterValue)`

**Description:** Filters the collection by a given key / value pair.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | filterKey | The key in the collection to check |
| 2 | `string`, `number` | filterValue | The value in the collection to compare |

**Example:**

```lua
collect({
    {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
    {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
    {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
    {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'},
    {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'}
}):where('type', 'watch'):all()
--[[
    {
        {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
        {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'}
    }
]]
```

<hr>

<a name="method-whereIn"></a>
## `whereIn(filterKey, filterValues)`

**Description:** Filters the collection by a given key / value pair contained within the given table.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | filterKey | The key in the collection to check |
| 2 | `table` | filterValues | The list of values in the collection to compare |

**Example:**

```lua
collect({
    {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
    {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
    {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
    {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'},
    {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'}
}):whereIn('name', {'iPhone 6', 'iPhone 5', 'Galaxy S6'}):all()
--[[
    {
        {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
        {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
        {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'}
    }
]]
```

<hr>

<a name="method-whereNotIn"></a>
## `whereNotIn(filterKey, filterValues)`

**Description:** Filters the collection by a given key / value pair not contained within the given table.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `string`, `number` | filterKey | The key in the collection to check |
| 2 | `table` | filterValues | The list of values in the collection to compare |

**Example:**

```lua
collect({
    {name = 'iPhone 6', brand = 'Apple', type = 'phone'},
    {name = 'iPhone 5', brand = 'Apple', type = 'phone'},
    {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
    {name = 'Galaxy S6', brand = 'Samsung', type = 'phone'},
    {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'}
}):whereNotIn('name', {'iPhone 6', 'iPhone 5', 'Galaxy S6'}):all()
--[[
    {
        {name = 'Apple Watch', brand = 'Apple', type = 'watch'},
        {name = 'Galaxy Gear', brand = 'Samsung', type = 'watch'}
    }
]]
```

<hr>

<a name="method-zip"></a>
## `zip(values)`

**Description:** Merges the value of the given table to the value of the original collection at the same index, if it exists in the original collection.

**Returns:** New `Collection`

**Arguments:**

| # | Type | Name | Description |
| --- | --- | --- | --- |
| 1 | `table` | values | The list of values to merge into the collection |

**Example:**

```lua
collect({'Chair', 'Desk'}):zip({100, 200}):all()
--[[
    {
        {'Chair', 100},
        {'Desk', 200}
    }
]]

collect({'Chair', 'Desk'}):zip({100, 200, 300}):all()
--[[
    {
        {'Chair', 100},
        {'Desk', 200}
    }
]]
```
