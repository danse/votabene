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
    text = 'Andamento di alcuni indici italiani negli ultimi anni'
    cl = ''
    display = 'none'
  $('div#submessage').text(text)
  $('div#submessage').attr('class', cl)
  axisMap[title].transition().duration(300).style('display', display)

responsibleUpdateSub = (event) ->
  if event.type is 'mouseenter'
    text = 'governo: ' + ($(event.target).text())
    color = 'gray'
  else
    text = 'Andamento di alcuni indici italiani negli ultimi anni'
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

    @delay = 0

  load: ->
    d3.json('data.json', (data) => @handle(data))

  detach: -> $(@svg.node).detach()

  handle: (@data) ->

    # Draw governments
    @governments = @data[0]
    @data = @data[1..]
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
    @svg.selectAll('line.elections')
      .data(@governments.slice(1))
      .enter()
      .append('line')
      .attr('class', 'elections')
      .attr('y1', padding)
      .attr('y2', height - padding)
      .attr('x1', (d) => @x(d.start))
      .attr('x2', (d) => @x(d.start))
    $('rect.responsible').hover(responsibleUpdateSub);

    # Draw indexes
    for index in @data
      @draw(index)

  draw: (index) ->

    yScale = d3.scale.linear().range([height-2*padding, 2*padding])
    line = d3.svg.line()
      .x((d) => @x(Number(d[0])))
      .y((d) -> yScale(d[1]))
      .interpolate('cardinal')
      .tension(0.9)

    path = @svg.append('path')
      .attr('class', 'line ' + index.class)

    path.append('title')
        .text(index.description)

    lineClassMap[index.description] = index.class

    extent = d3.extent(index.data.body, (d) -> d[1])
    yScale.domain(extent)
    init = index.data.body[0][1] # initial value
    zero = ([d[0], init] for d in index.data.body) # needed for animation
    path.datum(zero).attr('d', line)
    path.datum(index.data.body).transition()
     #.duration(duration).ease('elastic')
      .duration(4000)
      .delay(200 * @delay)
      .attr('d', line)

    @delay += 1

    @axis = d3.svg.axis().scale(yScale).ticks(13)
      .tickFormat(d3.format '0.0f')
      .orient('left')
    @axisSelection = @svg.append('g')
      .attr('class', 'axis')
      .attr('id', index.description)
      .attr('transform', 'translate(' + (30+Number(padding)) + ', 0)')
      .call(@axis)
      .style('display', 'none')

    axisMap[index.description] = @axisSelection
    $('path.line').hover(indexUpdateSub);

