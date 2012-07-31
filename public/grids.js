window.Diffa = window.Diffa || new Object;

Diffa.Trade = Backbone.Model.extend({
    validate: function validate() {
        if (!/^[FO]/.test(this.attributes.ttype)) { return "invalid trade type: " + this.attributes.ttype; };
        if (this.attributes.price <= 0) { return "invalid price: " + this.attributes.price; };
    },
    parse: function(json) {
        console.log("parse", json);
        // TODO: Validation
        json.expiry = new Date(json.expiry);
        json.entered_at = new Date(json.entered_at);
        return json;
    }
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
            editor: Slickback.NumberCellEditor},
        {id: "direction", name: "Buy/Sell", field: "direction", width: 30},
        {id: "entered_at", name: "Entry Date", field: "entered_at", width: dateWidth,
            formatter: Diffa.GridView.DateFormatter},
        {id: "contractDate", name: "Contract Date", field: "expiry", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter},
    ];    

    var futuresRiskColumns = [
        {id: "id", name: "Id", field: "id"},
        {id: "version", name: "Version", field: "version"},
        {id: "quantity", name: "Quantity", field: "quantity"},
        {id: "expiry", name: "Expires", field: "expiry", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter},
        {id: "price", name: "Price", field: "price"},
        {id: "direction", name: "Buy/Sell", field: "direction"},
        {id: "entered_at", name: "Entry Date", field: "entered_at", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter},
    ]; 
            
    var optionsRiskColumns = [
        {id: "id", name: "Id", field: "id"},
        {id: "version", name: "Version", field: "version"},
        {id: "quantity", name: "Quantity", field: "quantity"},
        {id: "strike", name: "Strike", field: "price"},
        {id: "expiry", name: "Expires", field: "expiry", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter},
        {id: "direction", name: "Call/Put", field: "direction"},
        {id: "entered_at", name: "Entry Date", field: "entered_at", width: dateWidth,
             formatter: Diffa.GridView.DateFormatter},
    ]; 

    Diffa.Views = Diffa.Views || {};
    Diffa.Views.TradesGrid = Backbone.View.extend({
        initialize: function initialize(initOptions) {

            var gridOptions = _.extend({},{
                editable:         true,
                formatterFactory: Slickback.BackboneModelFormatterFactory
            }, initOptions.grid);

            var collection = this.collection;

            var grid = new Slick.Grid(this.el,collection, tradeEntryColumns, gridOptions);
            collection.bind('change',function(model,attributes) {
                console.log("Changed", model.changedAttributes());
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

    Diffa.Models = Diffa.Models || {};
    Diffa.Models.TradesCollection = Slickback.Collection.extend({
        model: Diffa.Trade,
        url: $('link[rel="diffa.data.trades"]').attr('href'),
    });

    Diffa.tradesCollection = new Diffa.Models.TradesCollection()

//    Diffa.tradeEntryView = new Diffa.GridView($("#grid_trade_entry"), dataSource, tradeEntryColumns, options);
//    Diffa.futuresRiskGrid = new Diffa.GridView($("#grid_futures_risk"), dataSource, futuresRiskColumns, options);
//    Diffa.optionsRiskGrid = new Diffa.GridView($("#grid_options_risk"), dataSource, optionsRiskColumns, options);

    Diffa.tradeEntryView = new Diffa.Views.TradesGrid({
        el: $("#grid_trade_entry"),
        collection: Diffa.tradesCollection
    });
};
