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
    expect(d).toBe('M-122076.33333333333,360L-122137.75,20');
  });

  it("scales x values", function() {
    expect(chart.x(2002)).toBe(142.83333333333331);
    expect(chart.x(2002.5)).toBe(173.54166666666666);
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
      expect($('rect.responsible').eq(0).attr('width')).toBe('239.52499999999162');
    });
  });
});
