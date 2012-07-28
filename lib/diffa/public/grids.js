window.Diffa = window.Diffa || new Object;

Diffa.data = [
      { id: 'sample-id0', version: 'sample-version0' }
];

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

Diffa.RandomDataSource = function() {
    this._listeners = [];
}

Diffa.RandomDataSource.prototype.generate = function generate(nitems) {
    var data = _.range(nitems).map ( function () { return Diffa.Trade.random() });
    this._listeners.forEach(function(l) { l(data); });
}

Diffa.RandomDataSource.prototype.whenUpdated = function whenUpdated(listener) {
    this._listeners.push(listener);
}

Diffa.GridView = function(elt, source, columns, options) { 
    this._elt = elt;
    this._source = source;
    this._source.whenUpdated(this.update.bind(this));
    this._dataCache = []

    this._grid = new Slick.Grid(elt, this._dataCache, columns, options);
    this.render()
};

Diffa.GridView.prototype.render = function render() {
    this._grid.invalidate()
    this._elt.addClass('-rendered');
}

Diffa.GridView.prototype.update = function update(trades) { 
    var data = this._dataCache;
    // console.log("GridView#update", trades);
    data.slice(0, this._dataCache.length);
    trades.forEach(function(t) { data.push(t) });
    this.render();
}

// Currently, I don't test that this function gets used, as I really don't 
// have a good way of abstracting over the different column orders used.

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

    Diffa.dataSource = dataSource = new Diffa.RandomDataSource();

    Diffa.tradeEntryView = new Diffa.GridView($("#grid_trade_entry"), dataSource, tradeEntryColumns, options);
    Diffa.futuresRiskGrid = new Diffa.GridView($("#grid_futures_risk"), dataSource, futuresRiskColumns, options);
    Diffa.optionsRiskGrid = new Diffa.GridView($("#grid_options_risk"), dataSource, optionsRiskColumns, options);


    dataSource.generate(10)
};


/*
  $(function DiffaOnLoad () {
    $.ajax({
        dataType: 'json', 
        url: '/data',
    }).done(function(data) {
        // I can only pray to be eaten first for this. 
        Diffa.data.splice(0, Diffa.data.length);
        data.forEach(function(e) { Diffa.data.push(e); });
	Diffa.gridView.updateRowCount();
        Diffa.gridView.render()
        $("#grid_trade_entry, #grid_futures_risk, #grid_options_risk").addClass('-rendered');
        console.log("Fetch done");
    }).fail(function() { 
        console.log("Fail: ", arguments);
    });

    $('#addRow').click(function() {
	var num = Diffa.data.length
	var ndata = {id: "Id" + num, version: "Version " + num }
	Diffa.data.push(ndata);
	Diffa.gridView.updateRowCount();
	Diffa.gridView.render();
    });
	
    $('#save').click(function() {
        $('#status').html($('<span class="waiting">In progress</span>'));
	jQuery.ajax({
	    type: 'POST',
	    dataType: 'json',
	    url: '/',
	    contentType: "application/json",
	    data: JSON.stringify(Diffa.data)
	}).complete(function(event, state) {
	    console.log("Save -> ", state);
	}).done(function() {
	    $('#status').html($('<span class="done">Done</span>'));
	}).fail(function() { 
	// TODO: Proper error handling! 
            console.log("Fail: ", arguments);
        });
    })
   console.log("init done");
  });
*/
