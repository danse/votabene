padding = 20;
height = 400;
width = 1000;
excluded = [2, 14]
log = (m) ->
  if console?
    console.log(m)

class Chart

  constructor: (selector) ->

    selector = selector or 'body'
    @svg = d3.select(selector).append('svg')
      .attr('width', width)
      .attr('height', height)
    @x = d3.scale.linear().domain([2000, 2012]).range([padding, width-padding])
    @axis = d3.svg.axis().scale(@x).ticks(13)
      .tickFormat(d3.format '0')
    @axisSelection = @svg.append('g')
      .attr('class', 'axis')
      .attr('transform', 'translate(0, ' + (height - padding) + ')')
      .call(@axis)

  load: ->
    d3.json('info', (data) => @handle(data))

  detach: -> $(@svg.node).detach()

  line: (d) ->
    domain = d3.extent(d, (d) -> d[1])
    y = d3.scale.linear().domain(domain).range([height-2*padding, padding])
    x = d3.scale.linear().domain([2000, 2015]).range([padding, width-padding])
    line = d3.svg.line()
      .y((d) => y(d[1]))
      .x((d) => @x(Number(d[0])))
    line(d)

  handle: (@data) ->
    for index in @data
      @draw(index)

  draw: (index) ->
    @svg.append('path')
      .datum(index.data.body)
      .attr('class', 'line ' + index.class)
      .attr('d', (d) => @line(d))
      .append('title')
        .text(index.description)
