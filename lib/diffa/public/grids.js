window.Diffa = window.Diffa || new Object;

Diffa.Trade = function(data) {
    data = data || {};
    var self = this;
    this.__properties.forEach(function(property) {
        self[property] = data[property];
    });

    self.version = murmurhash3_32_gc(
        _.map(this.__properties, function(p) { return self[p] }).join("|")).
        toString(16).toUpperCase();
}

Diffa.Trade.prototype.__properties = ['id', 'type', 'quantity', 'expiry', 'price', 'direction',
                      'entered_at', 'version'];

Diffa.Trade.prototype.toString = function() { 
    return "<Diffa.Trade " + JSON.stringify(this) + ">";
}

Diffa.Trade.__id = 0;
Diffa.Trade.random = function () {
    var width = 4;
    function choice(a) {
        return a[Math.floor(Math.random() * a.length)];
    };
    
    var kind = choice(["O", "F"]);
    var id = (++Diffa.Trade.__id).toString();
    var id_padding = Array(width - id.length +1).join('0');
    var now = new Date();
    var entered_at = new Date(now.valueOf() - (7 * 24 * 3600 * 1000));
    var props = {
        id: kind + id_padding+ id, 
        type: kind,
        quantity: Math.ceil(Math.random() * 1000),
        expiry: now,
        price: Math.random(100),
        direction: choice(['B', 'S']),
        entered_at: entered_at,
    };
    return new this(props)
}

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
