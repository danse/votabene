iniparser = require './node-iniparser'
fs = require 'fs'

excluded = [
  2,
  4, # breaks the y range
  10, # breaks the y range
  14 # not JSON
  ]
allInfo = []
for i in [1..14]
  if i not in excluded
    dir = "./data/#{ i }/"
    info = iniparser.parseSync dir + 'info'
    info.index = i
    info.data = JSON.parse(fs.readFileSync(dir + 'original.json', 'utf-8'))
    allInfo.push(info)
fs.writeFile('info', JSON.stringify(allInfo))
