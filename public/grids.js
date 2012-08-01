window.Diffa = window.Diffa || new Object;

function urlTemplate(tmpl) { 
    return function template() { 
        var attrs = this.attributes;
        return tmpl.replace(/:([([a-zA-Z0-9]*)/g, function(_whole, name) {
            return attrs[name] || '';
        });
    }
}


Diffa.Trade = Backbone.Model.extend({
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
    url: urlTemplate("/grid/trades/:id"),
    defaults: { 
        ttype: 'O',
        quantity: 1,
        price: 0.0001,
        entered_at: new Date(),
        expiry: new Date(),
    }
});

Diffa.Future = Diffa.Trade.extend({
    url: urlTemplate("/grid/futures/:id"),
});

Diffa.Option = Diffa.Trade.extend({
    url: urlTemplate("/grid/options/:id"),
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
    ];    

    var futuresRiskColumns = [
        {id: "id", name: "Id", field: "id"},
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
        {id: "id", name: "Id", field: "id"},
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

    function GridComponent(url, baseElt, modelType, gridViewType) {
        this.CollectionType = Slickback.Collection.extend({
            model: modelType,
            url: url,
        });

        this.collection = new this.CollectionType();

        this.tradeEntryView = new gridViewType({
            el: baseElt.find(".entry-grid"),
            collection: this.collection,
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
