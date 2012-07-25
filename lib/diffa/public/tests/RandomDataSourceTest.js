describe('RandomDataSource', function(){
    function datum () { return everyItem(instanceOf(Diffa.Trade)); }
    describe('#generate()', function(){
        it('should pass some data to a listener', function(){
            var it = new Diffa.RandomDataSource();
            var listener = mockFunction();
            it.whenUpdated(listener);

            it.generate()
            
            verify(listener)(allOf(datum()));
        });
    });
})
