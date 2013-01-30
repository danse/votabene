iniparser = require './node-iniparser'
fs = require 'fs'

excluded = [
  4, # detaineds (not so monotone)
  7, # debit (not so monotone)
  11, # exports (not so monotone)
  12, # unemployment (not so monotone)
  16, # gross domestic product (not so monotone)
  ]
data = []
data.push JSON.parse(fs.readFileSync('data/governments-integer.json', 'utf-8'))
for i in [1..16]
  if i not in excluded
    dir = "./data/#{ i }/"
    index = iniparser.parseSync dir + 'info'
    index.index = i
    index.data = JSON.parse(fs.readFileSync(dir + 'standard.json', 'utf-8'))
    data.push index 
fs.writeFile('data.json', JSON.stringify(data))
