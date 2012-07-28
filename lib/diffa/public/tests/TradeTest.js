describe('Diffa.Trade', function(){
    function tradeMatch () { return everyItem(instanceOf(Diffa.Trade)); }

    /* This would likely be better done with some quickCheck style magic,
     * but for the sake of getting *something* done, we can punt that out. 
     */

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

        it('should have non-negative price', function() {
            assertThat(subject(), hasMember('price', greaterThan(0)));
        });
        it('should be either bought or sold, or undefined', function() {
            assertThat(subject(), hasMember('direction', oneOf('B', 'S')));
        });
        it('should have an entry date', function() {
            assertThat(subject(), hasMember('entered_at', instanceOf(Date)));
        });
        it('the entry date should be before the expiry', function() {
            var theTrade = subject();
            assertThat(theTrade, hasMember('entered_at', lessThan(theTrade.expiry)));
        });
    })
})
