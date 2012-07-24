describe('Diffa.Trade', function(){
    function datum () { return everyItem(instanceOf(Diffa.Trade)); }

    describe('.random()', function(){
        function subject() { return Diffa.Trade.random() };

        it('should generate a trade', function() {
            assertThat(subject(), instanceOf(Diffa.Trade));
        });
        it('should have a valid id', function() {
            assertThat(subject(), hasMember('id', matches(/^[FO]\d+$/)));
        });
    })
})
