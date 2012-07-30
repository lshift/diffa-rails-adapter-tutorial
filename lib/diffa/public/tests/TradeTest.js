describe('Diffa.Trade', function(){
    function tradeMatch () { return everyItem(instanceOf(Diffa.Trade)); }
    
    function isValid () { 
        return new JsHamcrest.SimpleMatcher({
            matches: function(object) {
                return object.isValid();
            },
            describeTo: function(description) {
                description.append('valid model');
            },
            describeValueTo: function(actual, description) {
                var messages = actual.validate();
                description.append(messages);
                description.append(' with ');
                description.append(JSON.stringify(actual.toJSON()));
            }
        });
    }

    /* This would likely be better done with some quickCheck style magic,
     * but for the sake of getting *something* done, we can punt that out. 
     */

    describe('validation', function(){
        function subject(props) { 
            var defaults = { ttype: 'F' };
            return new Diffa.Trade(_.extend({}, defaults, props));
        };

        describe('ttype', function() {
            it('should be valid with F(uture)', function() {
                assertThat(subject({ttype: 'F'}), isValid());
            });
            it('should be valid with O(ption)', function() {
                assertThat(subject({ttype: 'O'}), isValid());
            });
            it('should not be valid with any other value', function() {
                assertThat(subject({ttype: 'otherthing'}), not(isValid()));
            });
        });

        describe ('price', function() {
            it('0.0001 is valid as a price', function() {
                assertThat(subject({price: 0.001}), isValid());
            });
            it('0.0000 is not a valid price', function() {
                assertThat(subject({price: 0.000}), not(isValid()));
            });
        });

    /*
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

        it('should have a derived version rendered in hex', function() {
            // Upper case is more ENTERPRISE. No, really. Just ask ORACLE.
            assertThat(subject(), hasMember('version', matches(/^[0-9A-F]+$/i)));
        }); */
    });
});
