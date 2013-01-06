describe("Chart", function() {
  var chart;

  beforeEach(function() {
    chart = new Chart();
  });

  afterEach(function() {
    chart.detach();
  });

  it("can compute a correct line", function() {
    var data = [['12', '2003'], ['11', '2004']]
    var y = chart.yScale(data);
    var d = chart.line(data, y);
    expect(d).toBe('M-159020,360L-159100,20');
  });

  it("scales x values", function() {
    expect(chart.x(2002)).toBe(180);
    expect(chart.x(2002.5)).toBe(219.99999999999997);
  });

  it("should load everything and draw", function() {

    runs(function(){
      chart.load();
    });

    waitsFor(function(){
      return chart.data !== undefined && chart.governments !== undefined;
    }, 'receiving data', 1000);

    runs(function(){
      expect($('path.line').length).toBe(chart.data.length);
      expect(chart.governments).toBeDefined();
      expect($('rect.responsible').length).toBe(4);
      expect($('rect.responsible').eq(0).attr('width')).toBe('311.9999999999891');
    });
  });
});
