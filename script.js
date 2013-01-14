// Generated by CoffeeScript 1.4.0
var Chart, axisMap, height, indexUpdateSub, lineClassMap, log, padding, responsibleUpdateSub, width;

padding = 20;

height = 400;

width = 777;

lineClassMap = {};

axisMap = {};

indexUpdateSub = function(event) {
  var cl, display, text, title;
  if (event.type === 'mouseenter') {
    title = $(event.target).text();
    text = 'indice: ' + title;
    cl = lineClassMap[title];
    display = '';
  } else {
    title = $(event.target).text();
    text = cl = '';
    display = 'none';
  }
  $('div#submessage').text(text);
  $('div#submessage').attr('class', cl);
  return axisMap[title].transition().duration(200).style('display', display);
};

responsibleUpdateSub = function(event) {
  var color, text;
  if (event.type === 'mouseenter') {
    text = 'governo: ' + ($(event.target).text());
    color = 'gray';
  } else {
    text = '';
    color = '';
  }
  return $('div#submessage').text(text).css('color', color);
};

log = function(m) {
  if (typeof console !== "undefined" && console !== null) {
    return console.log(m);
  }
};

Chart = (function() {

  function Chart(selector) {
    selector = selector || 'body';
    this.svg = d3.select(selector).append('svg').attr('width', width).attr('height', height);
    this.x = d3.scale.linear().domain([2000, 2012]).range([padding, width - padding]);
    this.axis = d3.svg.axis().scale(this.x).ticks(13).tickFormat(d3.format('0'));
    this.axisSelection = this.svg.append('g').attr('class', 'axis').attr('transform', 'translate(0, ' + (height - padding) + ')').call(this.axis);
  }

  Chart.prototype.load = function() {
    var _this = this;
    return d3.json('data/governments-integer.json', function(data) {
      return _this.handleGovernments(data);
    });
  };

  Chart.prototype.detach = function() {
    return $(this.svg.node).detach();
  };

  Chart.prototype.yScale = function(d) {
    var domain;
    domain = d3.extent(d, function(d) {
      return d[1];
    });
    return d3.scale.linear().domain(domain).range([height - 2 * padding, padding]);
  };

  Chart.prototype.line = function(d, y) {
    var line,
      _this = this;
    line = d3.svg.line().y(function(d) {
      return y(d[1]);
    }).x(function(d) {
      return _this.x(Number(d[0]));
    });
    return line(d);
  };

  Chart.prototype.handle = function(data) {
    var index, _i, _len, _ref, _results;
    this.data = data;
    _ref = this.data;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      index = _ref[_i];
      _results.push(this.draw(index));
    }
    return _results;
  };

  Chart.prototype.handleGovernments = function(governments) {
    var _this = this;
    this.governments = governments;
    this.svg.selectAll('rect.responsible').data(this.governments).enter().append('rect').attr('class', 'responsible').attr('y', padding).attr('height', height - 2 * padding).attr('x', function(d) {
      return _this.x(d.start);
    }).attr('width', function(d) {
      return _this.x(d.end) - _this.x(d.start);
    }).append('title').text(function(d) {
      return d.responsible;
    });
    d3.json('info', function(data) {
      return _this.handle(data);
    });
    return $('rect.responsible').hover(responsibleUpdateSub);
  };

  Chart.prototype.draw = function(index) {
    var drawn, path, year, _i, _len, _ref,
      _this = this;
    path = this.svg.append('path').attr('class', 'line ' + index["class"]);
    path.append('title').text(index.description);
    lineClassMap[index.description] = index["class"];
    drawn = [];
    _ref = index.data.body;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      year = _ref[_i];
      drawn.push(year);
      path.datum(drawn);
      path.transition().duration(500).attr('d', function(d) {
        return _this.line(d, _this.yScale(d));
      });
    }
    this.axis = d3.svg.axis().scale(this.yScale(index.data.body)).ticks(13).tickFormat(d3.format('0.0f')).orient('left');
    this.axisSelection = this.svg.append('g').attr('class', 'axis').attr('id', index.description).attr('transform', 'translate(' + (20 + Number(padding)) + ', 0)').call(this.axis).style('display', 'none');
    axisMap[index.description] = this.axisSelection;
    return $('path.line').hover(indexUpdateSub);
  };

  return Chart;

})();
