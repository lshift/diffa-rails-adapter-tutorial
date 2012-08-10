window.Diffa = window.Diffa || new Object;

function urlTemplate(tmpl) { 
    return function template() { 
        var attrs = this.attributes;
        return tmpl.replace(/:([([a-zA-Z0-9]*)/g, function(_whole, name) {
            return attrs[name] || '';
        });
    }
}


Diffa.Instrument = Backbone.Model.extend({
    validate: function validate(attributes) {
        if (!/^[FO]/.test(attributes.ttype)) { return "invalid trade type: " + attributes.ttype; };
        if (attributes.price < 0) { return "invalid price: " + attributes.price; };
        if (attributes.expiry < attributes.entered_at) { 
            return "Expiry date " + Diffa.dateToString(attributes.expiry) + 
                    " must be after entry date " + Diffa.dateToString(attributes.entered_at);
        }
    },
    parse: function(json) {
        if (json) { 
            json.expiry = new Date(json.expiry);
            json.entered_at = new Date(json.entered_at);
            return json;
        }
    },
    // url: urlTemplate("/grid/trades/:id"),
    defaults: { 
        ttype: 'O',
        quantity: 1,
        price: 0.0001,
        entered_at: new Date(),
        expiry: new Date(),
    },

    save: function save(key, value, options) {
        var model = this;
        var promise = Diffa.Instrument.__super__.save.call(this, key, value, options);
        promise.then(function(response) { 
            if (response) model.set(response);
        });
    }

});

Diffa.Trade = Diffa.Instrument.extend({
    pushDownstream: function () {
        var rpcEndpoint = this.url() + '/push';
        return $.post(rpcEndpoint, null).
            pipe(function(futureJson, state, xhr) {
                console.log(futureJson);
                return new Diffa.Future(futureJson);
        });
    }
});
Diffa.Future = Diffa.Instrument.extend({
});

Diffa.Option = Diffa.Instrument.extend({
});



Diffa.Trade.prototype.__properties = ['id', 'type', 'quantity', 'expiry', 'price', 'direction',
                      'entered_at', 'version'];

Diffa.Trade.prototype.toString = function() { 
    return "<Diffa.Trade " + JSON.stringify(this) + ">";
}

Diffa.DateEditor = function(args) {
    this.container    = args.container;
    this.column       = args.column;
    this.defaultValue = null;
    this.$input       = this.createTextInputElement();
//     this.picker       = this.$input.glDatePicker({
//         position: 'static', showAlways: true,
//         onChange: this.whenChanged.bind(this)
//     });
}

_.extend(Diffa.DateEditor.prototype, Slickback.EditorMixin, {
    serializeValue: function() {
        var parsed = new Date(this.$input.val());
        console.log("Serialize: ", this.$input.val(), parsed);
        // return this.currval || this.$input.val();
        return parsed;
    },

    validate: function() {
        var column = this.column;
        return column.validator ?  column.validator(this.$input.val()) : { valid: true, msg: null };
    },
    whenChanged: function(target, value) {
        var serialized = Diffa.dateToString(value);
        console.log("whenChanged", target, value, serialized);
        this.$input.val(serialized);
        this.currval = value;
    }
});

Diffa.dateToString = function dateToString(date) {
    return [date.getFullYear(), date.getMonth() +1, date.getDate()].join("/");
}
Diffa.GridView = {};
Diffa.GridView.DateFormatter = function DateFormatter(row, cell, value, columnDef, dataContext) {
    var value = dataContext.get(columnDef.field);
    return Diffa.dateToString(value);
}

Diffa.GridView.ButtonFormatter = function ButtonFormatter(row, cell, value, columnDef, trade) {
    return $('<button/>').attr('id', 'tradepusher-' + trade.cid).text('Push').wrap('<div/>').parent().html();
}

Diffa.BootstrapGrids = function() {
    var dateWidth = 120;
    var tradeEntryColumns = [
        {id: "id", name: "Id", field: "id", width:80},
        {id: "version", name: "Version", field: "version"},
        {id: "ttype", name: "Type", field: "ttype", width: 30,
            editor: Slickback.DropdownCellEditor, choices: ['F', 'O'] },
        {id: "quantity", name: "Qty.", field: "quantity", width: 60, 
            editor: Slickback.NumberCellEditor},
        {id: "price", name: "Price", field: "price", width: 80, 
            editor: Slickback.NumberCellEditor, precision: 2},
        {id: "direction", name: "Buy/Sell", field: "direction", width: 30,
            editor: Slickback.DropdownCellEditor, choices: ['B', 'S'] },
        {id: "entered_at", name: "Entry Date", field: "entered_at", width: dateWidth,
            formatter: Diffa.GridView.DateFormatter},
        {id: "contractDate", name: "Contract Date", field: "expiry", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter,
             editor: Diffa.DateEditor},
        {id: "propagate", name: "Push to Downstream", field: "trade_id", width: dateWidth,
             formatter: Diffa.GridView.ButtonFormatter}
    ];    

    var futuresRiskColumns = [
        {id: "id", name: "Id", field: "trade_id"},
        {id: "version", name: "Version", field: "version"},
        {id: "quantity", name: "Quantity", field: "quantity", 
            editor: Slickback.NumberCellEditor},
        {id: "expiry", name: "Expires", field: "expiry", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter, editor: Diffa.DateEditor},
        {id: "price", name: "Price", field: "price",
            editor: Slickback.NumberCellEditor, precision: 2},
        {id: "direction", name: "Buy/Sell", field: "direction",
            editor: Slickback.DropdownCellEditor, choices: ['B', 'S'] },
        {id: "entered_at", name: "Entry Date", field: "entered_at", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter},
    ]; 
            
    var optionsRiskColumns = [
        {id: "id", name: "Id", field: "trade_id"},
        {id: "version", name: "Version", field: "version"},
        {id: "quantity", name: "Quantity", field: "quantity", 
            editor: Slickback.NumberCellEditor},
        {id: "strike", name: "Strike", field: "price",
            editor: Slickback.NumberCellEditor, precision: 2},
        {id: "expiry", name: "Expires", field: "expiry", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter,
             editor: Diffa.DateEditor},
        {id: "direction", name: "Call/Put", field: "direction",
            editor: Slickback.DropdownCellEditor, choices: ['C', 'P'] },
        {id: "entered_at", name: "Entry Date", field: "entered_at", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter},
    ]; 

    Diffa.Views = Diffa.Views || {};
    Diffa.Views.AutoSaveGrid = Backbone.View.extend({
        initialize: function initialize(initOptions) {
            var gridOptions = _.extend({},{
                editable:         true,
                formatterFactory: Slickback.BackboneModelFormatterFactory
            }, initOptions.grid);

            var collection = this.collection;

            var grid = new Slick.Grid(this.el,collection, this.columns, gridOptions);
            collection.bind('change',function(model,attributes) {
                model.save();
            });

            collection.onRowCountChanged.subscribe(function() {
                grid.updateRowCount();
                grid.render();
            });

            collection.onRowsChanged.subscribe(function() {
                grid.invalidateAllRows();
                grid.render();
            });

            collection.fetch();
        }
    });
    Diffa.Views.TradesGrid = Diffa.Views.AutoSaveGrid.extend({
        columns: tradeEntryColumns,
        initialize: function initialize(initOptions) { 
            Diffa.Views.TradesGrid.__super__.initialize.call(this, initOptions);
            _.bindAll(this, 'propagateButtonPressed');
            this.$el.on('click', this.propagateButtonPressed);
            this.bigbus = initOptions.bigbus;
        
        },
        propagateButtonPressed: function propagateButtonPressed(evt) {
            var id = $(evt.target).attr('id');
            console.log("pressed", evt.target, id);
            if (!id) return;
            var m = id.match(/^tradepusher-(.+)$/);
            if (!m) return;
            var bus = this.bigbus;
            this.collection.getByCid(m[1]).pushDownstream().then(function (riskything) {
                bus.trigger('refreshallthethings');
            });
        }
    });

    Diffa.Views.FuturesGrid = Diffa.Views.AutoSaveGrid.extend({
        columns: futuresRiskColumns
    });

    Diffa.Views.OptionsGrid = Diffa.Views.AutoSaveGrid.extend({
        columns: optionsRiskColumns
    });


    Diffa.Views.TradeErrors = Backbone.View.extend({
        initialize: function initialize(options) {
            this.collection.on('error', this.showError.bind(this));
        },

        showError: function showError(model, error, _options) {
            $('<div/>').hide().addClass('error').text(error.toString()).appendTo(this.el).slideDown().
                delay(1000).slideUp(function () {
                    $(this).remove();
                });
        }
    });

    Diffa.Views.Control = Backbone.View.extend({
        markup: '<button/>',
        render: function () {
            $(this.el).html(this.markup).find('button').text('Add Row');
        },
        initialize: function initialize(options) {
            this.render();
            this.$('button').click(this.addRow.bind(this));
        },
        addRow: function addRow() { 
            this.collection.create();
        }
    });

    Diffa.Models = Diffa.Models || {};
    var bigbus = _.clone(Backbone.Events);

    bigbus.on('all', function() { console.log('all of the things', arguments); });
    function GridComponent(url, baseElt, modelType, gridViewType) {
        this.CollectionType = Slickback.Collection.extend({
            model: modelType,
            url: url,
        });

        var collection = new this.CollectionType();
        bigbus.on('refreshallthethings', function() { collection.fetch() ; })
        this.collection = collection;
        

        this.tradeEntryView = new gridViewType({
            el: baseElt.find(".entry-grid"),
            collection: this.collection,
            bigbus: bigbus,
        });
        this.errorView = new Diffa.Views.TradeErrors({
            el: baseElt.find(".errors"),
            collection: this.collection
        });
        this.control = new Diffa.Views.Control({
            el: baseElt.find(".controls"),
            collection: this.collection
        });
    };

    Diffa.tradesGrid = new GridComponent(
        $('link[rel="diffa.data.trades"]').attr('href'), $('#trades'), 
        Diffa.Trade, Diffa.Views.TradesGrid
    );

    Diffa.futuresGrid = new GridComponent(
        $('link[rel="diffa.data.futures"]').attr('href'), $('#futures'), 
        Diffa.Future, Diffa.Views.FuturesGrid
    );

    Diffa.futuresGrid = new GridComponent(
        $('link[rel="diffa.data.options"]').attr('href'), $('#options'), 
        Diffa.Option, Diffa.Views.OptionsGrid
    );
        
};
