describe('RandomDataSource', function(){
    var datum = JsHamcrest.Matchers.anything;
    describe('#generate()', function(){
        it('should pass the data to a listener', function(){
            console.log("example this: ", this);
            var listener = mockFunction();
            var it = new Diffa.RandomDataSource(listener);

            it.generate()
            
            console.log("window.verify", window.verify);
            verify(listener)(allOf(datum()));
        })

        it('should adjust .length', function(){
            var arr = [1,2,3];
            arr.pop();
            assert(arr.length == 2);
        })
    })
})
