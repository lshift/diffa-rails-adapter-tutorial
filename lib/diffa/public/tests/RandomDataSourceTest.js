describe('RandomDataSource', function(){
    function tradeList () { return everyItem(instanceOf(Diffa.Trade)); }
    describe('#generate()', function(){
        it('should pass new trades to a listener when generate is called', function(){
            var it = new Diffa.RandomDataSource();
            var listener = mockFunction();
            it.whenUpdated(listener);
            it.generate()
            verify(listener)(allOf(tradeList()));
        });

        it('should handle multipe listeners', function(){
            var it = new Diffa.RandomDataSource();
            var listeners = [mockFunction(), mockFunction()];
            listeners.forEach(function(l) { it.whenUpdated(l); });
            it.generate()
            listeners.forEach(function(l) { verify(l)(allOf(tradeList())); });
        });

    });
})
