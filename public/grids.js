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

Diffa.GridView = {}
Diffa.GridView.DateFormatter = function DateFormatter(row, cell, value, columnDef, dataContext) {
    value = dataContext.get(columnDef.field);
    return [value.getFullYear(), value.getMonth(), value.getDay()].join("/");
}

Diffa.BootstrapGrids = function() {
    var dateWidth = 120;
    var tradeEntryColumns = [
        {id: "id", name: "Id", field: "id", width:80},
        {id: "version", name: "Version", field: "version"},
        {id: "ttype", name: "Type", field: "ttype", width: 30},
        {id: "quantity", name: "Qty.", field: "quantity", width: 60, 
            editor: Slickback.NumberCellEditor},
        {id: "price", name: "Price", field: "price", width: 80, 
            editor: Slickback.NumberCellEditor, precision: 2},
        {id: "direction", name: "Buy/Sell", field: "direction", width: 30},
        {id: "entered_at", name: "Entry Date", field: "entered_at", width: dateWidth,
            formatter: Diffa.GridView.DateFormatter},
        {id: "contractDate", name: "Contract Date", field: "expiry", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter},
    ];    

    var futuresRiskColumns = [
        {id: "id", name: "Id", field: "id"},
        {id: "version", name: "Version", field: "version"},
        {id: "quantity", name: "Quantity", field: "quantity", 
            editor: Slickback.NumberCellEditor},
        {id: "expiry", name: "Expires", field: "expiry", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter},
        {id: "price", name: "Price", field: "price",
            editor: Slickback.NumberCellEditor, precision: 2},
        {id: "direction", name: "Buy/Sell", field: "direction"},
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
             formatter: Diffa.GridView.DateFormatter},
        {id: "direction", name: "Call/Put", field: "direction"},
        {id: "entered_at", name: "Entry Date", field: "entered_at", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter},
    ]; 

    Diffa.Views = Diffa.Views || {};
    Diffa.Views.TradesGrid = Backbone.View.extend({
        columns: tradeEntryColumns,
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

    Diffa.Views.FuturesGrid = Diffa.Views.TradesGrid.extend({
        columns: futuresRiskColumns
    });

    Diffa.Views.OptionsGrid = Diffa.Views.TradesGrid.extend({
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
