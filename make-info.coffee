iniparser = require './node-iniparser'
fs = require 'fs'

excluded = [
  4, # detaineds (not so monotone)
  7, # debit (not so monotone)
  11, # exports (not so monotone)
  12, # unemployment (not so monotone)
  #14 # not JSON
  ]
allInfo = []
for i in [1..14]
  if i not in excluded
    dir = "./data/#{ i }/"
    info = iniparser.parseSync dir + 'info'
    info.index = i
    info.data = JSON.parse(fs.readFileSync(dir + 'standard.json', 'utf-8'))
    allInfo.push(info)
fs.writeFile('info', JSON.stringify(allInfo))
