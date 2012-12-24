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
    expect(d).toBe('M1997.72,2009.6766666666667L1997.66,2009.68');
  });

  it("should load everything and draw", function() {

    runs(function(){
      chart.require();
    });

    waitsFor(function(){
      return chart.received.length == chart.requestCounter;
    }, 'receiving all requested data', 1000);

    runs(function(){
      expect($('path').length).toBe(chart.requestCounter);
    });
  });
});
