describe('RandomDataSource', function(){
    function datum () { return everyItem(instanceOf(Diffa.Trade)); }
    describe('#generate()', function(){
        it('should pass some data to a listener', function(){
            var listener = mockFunction();
            var it = new Diffa.RandomDataSource(listener);

            it.generate()
            
            verify(listener)(allOf(datum()));
        });
    })
})
