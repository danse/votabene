describe("Chart", function() {
  var chart;

  beforeEach(function() {
    chart = new Chart();
  });

  afterEach(function() {
    chart.detach();
  });

  it("can compute a correct line", function() {
    var d = chart.line([['12', '2003'], ['11', '2004']]);
    expect(d).toBe('M-166972,380L-167056,20');
  });

  it("should load everything and draw", function() {

    runs(function(){
      chart.load();
    });

    waitsFor(function(){
      return chart.data !== undefined;
    }, 'receiving data', 1000);

    runs(function(){
      expect($('path.line').length).toBe(chart.data.length);
    });
  });
});
