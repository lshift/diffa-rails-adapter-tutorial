window.Diffa = window.Diffa || new Object;

Diffa.Trade = Backbone.Model.extend({
    validate: function validate() {
        if (!/^[FO]/.test(this.attributes.ttype)) { return "invalid trade type: " + this.attributes.ttype; };
        if (this.attributes.price <= 0) { return "invalid price: " + this.attributes.price; };
    }
});

Diffa.Trade.prototype.__properties = ['id', 'type', 'quantity', 'expiry', 'price', 'direction',
                      'entered_at', 'version'];

Diffa.Trade.prototype.toString = function() { 
    return "<Diffa.Trade " + JSON.stringify(this) + ">";
}

Diffa.GridView = {}
Diffa.GridView.DateFormatter = function DateFormatter(row, cell, value, columnDef, dataContext) {
    return [value.getFullYear(), value.getMonth(), value.getDay()].join("/");
}

Diffa.BootstrapGrids = function() {
    var dateWidth = 120;
    var tradeEntryColumns = [
        {id: "id", name: "Id", field: "id", width:80},
        {id: "version", name: "Version", field: "version"},
        {id: "type", name: "Type", field: "type", width: 30},
        {id: "quantity", name: "Qty.", field: "quantity", width: 60},
        {id: "price", name: "Price", field: "price", width: 80},
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

    var options = {
        enableCellNavigation: true,
        enableColumnReorder: false,
        editable: false,
    };

    Diffa.dataSource = []

    Diffa.tradeEntryView = new Diffa.GridView($("#grid_trade_entry"), dataSource, tradeEntryColumns, options);
    Diffa.futuresRiskGrid = new Diffa.GridView($("#grid_futures_risk"), dataSource, futuresRiskColumns, options);
    Diffa.optionsRiskGrid = new Diffa.GridView($("#grid_options_risk"), dataSource, optionsRiskColumns, options);
};
