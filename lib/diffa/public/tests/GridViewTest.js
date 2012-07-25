describe('GridView', function(){
    function datum () { return everyItem(instanceOf(Diffa.Trade)); }
    function noop () {};
    var UpdateSource = {whenUpdated: noop};

    describe('GridView()', function(){
        it('register itself with the passed datasource', function(){
            var dataSource = mock(UpdateSource);
            var placeHolder = $('<div/>');
            var it = new Diffa.GridView(placeHolder, dataSource, []);

            verify(dataSource).whenUpdated(func());
        });


        it('when the source updates, it will render the passed trades', function() {
            var listener = null;
            var stashListener = function(callback) { listener = callback; }
            var dataSource = { whenUpdated: stashListener }
            var placeHolder = $('<div/>'); 
            var dummyColumns = [{id: "id", name:"Id", field: "id"}];
            var it = new Diffa.GridView(placeHolder, dataSource, dummyColumns);
            var aTrade = Diffa.Trade.random();
            
            listener([aTrade]);

            assertThat(placeHolder.text(), allOf(
                        containsString("Id"),
                        containsString(aTrade.id)));
        });
    })
})
