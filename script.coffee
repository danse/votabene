padding = 20
height = 400
width = 777
lineClassMap = {}
axisMap = {}

indexUpdateSub = (event) ->
  if event.type is 'mouseenter'
    title = $(event.target).text()
    text = 'indice: ' + title
    cl = lineClassMap[title]
    display = ''
  else
    title = $(event.target).text()
    text = cl = ''
    display = 'none'
  $('div#submessage').text(text)
  $('div#submessage').attr('class', cl)
  axisMap[title].transition().duration(200).style('display', display)

responsibleUpdateSub = (event) ->
  if event.type is 'mouseenter'
    text = 'governo: ' + ($(event.target).text())
    color = 'gray'
  else
    text = ''
    color = ''
  $('div#submessage').text(text).css('color', color)

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
    d3.json('data/governments-integer.json', (data) => @handleGovernments(data))

  detach: -> $(@svg.node).detach()

  yScale: (d) ->
    domain = d3.extent(d, (d) -> d[1])
    d3.scale.linear().domain(domain).range([height-2*padding, padding])

  line: (d, y) ->
    line = d3.svg.line()
      .y((d) => y(d[1]))
      .x((d) => @x(Number(d[0])))
    line(d)

  handle: (@data) ->
    for index in @data
      @draw(index)

  handleGovernments: (@governments) ->
    @svg.selectAll('rect.responsible')
      .data(@governments)
      .enter()
      .append('rect')
      .attr('class', 'responsible')
      .attr('y', padding)
      .attr('height', height - 2*padding)
      .attr('x', (d) => @x(d.start))
      .attr('width', (d) => @x(d.end) - @x(d.start))
      .append('title')
        .text((d) -> d.responsible)
    d3.json('info', (data) => @handle(data))
    $('rect.responsible').hover(responsibleUpdateSub);

  draw: (index) ->
    path = @svg.append('path')
      .attr('class', 'line ' + index.class)

    path.append('title')
        .text(index.description)

    lineClassMap[index.description] = index.class

    # Attempt to add animation, not working
    drawn = []
    for year in index.data.body
      drawn.push year
      path.datum(drawn)
      path.transition().duration(500)
        .attr('d', (d) => @line(d, @yScale(d)))

    @axis = d3.svg.axis().scale(@yScale(index.data.body)).ticks(13)
      .tickFormat(d3.format '0.0f')
      .orient('left')
    @axisSelection = @svg.append('g')
      .attr('class', 'axis')
      .attr('id', index.description)
      .attr('transform', 'translate(' + (20+Number(padding)) + ', 0)')
      .call(@axis)
      .style('display', 'none')

    axisMap[index.description] = @axisSelection
    $('path.line').hover(indexUpdateSub);

