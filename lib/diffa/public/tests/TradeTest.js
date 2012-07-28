describe('Diffa.Trade', function(){
    function tradeMatch () { return everyItem(instanceOf(Diffa.Trade)); }

    describe('.random()', function(){
        function subject() { return Diffa.Trade.random() };

        it('should generate a trade', function() {
            assertThat(subject(), instanceOf(Diffa.Trade));
        });
        it('should have a valid id', function() {
            assertThat(subject(), hasMember('id', matches(/^[FO]\d+$/)));
        });
        it('should have a type that is either a F(uture) or O(ption)', function() {
            assertThat(subject(), hasMember('type', matches(/^[FO]$/)));
        });
        it('should have an integer quantity between 1-1000', function() {
            assertThat(subject(), hasMember('quantity', between(1).and(1000)));
        });
        it('should have an expiry date', function() {
            assertThat(subject(), hasMember('expiry', instanceOf(Date)));
        });
    })
})
