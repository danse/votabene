padding = 20;
height = 300;
width = 800;
excluded = [2, 14]
log = (m) ->
  if console?
    console.log(m)

class Chart

  constructor: (selector) ->
    @processed = []
    @ranges = []
    @requestCounter = 0
    @datasets = []
    @received = []

    selector = selector or 'body'
    @svg = d3.select(selector).append('svg')
      .attr('width', width)
      .attr('height', height)

  require: ->
    for i in [1..14]
      if i not in excluded
        d3.json("/data/#{ i }/original.json", (data) => @draw(data))
        @requestCounter += 1

  detach: -> $(@svg.node).detach()

  line: (d) ->
    domain = d3.extent(d, (d) -> d[1])
    y = d3.scale.linear().domain(domain).range([padding, height-padding])
    x = d3.scale.linear().domain([1997, 2015]).range([padding, width-padding])
    line = d3.svg.line()
      .y((d) => y(d[1]))
      .x((d) => x(Number(d[0])))
    line(d)

  draw: (data) ->
    @received.push(data)
    body = data.body
    log body
    @svg.append('path')
      .datum(body)
      .attr('d', (d) => @line(d))
