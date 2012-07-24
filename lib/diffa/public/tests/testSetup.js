        // This is a hack.
    JsMockito.Integration.importTo(window);
    JsHamcrest.Integration.copyMembers(window);

      window.assertThat = function(actual, matcher, message) {
        return JsHamcrest.Operators.assert(actual, matcher, {
          message: message,
          fail: function(message) { throw new Error(message); },
          pass: function(message) { console.log("Okay", message); }
        });
      };

