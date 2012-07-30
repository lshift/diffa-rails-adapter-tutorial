describe('HttpDataSource', function(){
    function isTradeList () { 
        return allOf(
            everyItem(instanceOf(Diffa.Trade)), 
            hasSize(greaterThanOrEqualTo(1))
        ); 
    }

    describe('#retreive()', function(){
        it('should return a promise with trades', function(done){
            var it = new Diffa.HttpDataSource('/tests/fake-datasource.json');
            console.log(it);
            var p = it.retrieve();
            p.then(function(data) { assertThat(data, isTradeList()); }).
                fail(function(e) { done(e)} ).
                fin(function() { done() });
        });

        it('should handle multipe listeners', undefined && function(){
            var it = new Diffa.HttpDataSource();
            var listeners = [mockFunction(), mockFunction()];
            listeners.forEach(function(l) { it.whenUpdated(l); });
            it.generate()
            listeners.forEach(function(l) { verify(l)(allOf(tradeList())); });
        });

    });
})
