package = 'Collections'
version = '0.2.0'
source = {
   url = 'git@github.com:ImLiam/Lua-Collections.git'
}
description = {
   summary = 'A robust Lua collection class based on Laravel collections.',
   detailed = 'Collections are like tables on steroids. They are designed to act as a fluent wrapper when working with structured data, offering the developer convenience for common tasks.',
   homepage = 'https://github.com/ImLiam/Lua-Collections',
   license = 'MIT'
}
dependencies = {
   'lua >= 5.1'
}
build = {
   type = 'builtin',
   modules = {
      ['collections'] = 'collections.lua',
   }
}