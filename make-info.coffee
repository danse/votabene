iniparser = require './node-iniparser'
fs = require 'fs'

excluded = [2, 14]
allInfo = []
for i in [1..14]
  if i not in excluded
    info = iniparser.parseSync "./data/#{ i }/info"
    info.index = i
    allInfo.push(info)
fs.writeFile('info', JSON.stringify(allInfo))
