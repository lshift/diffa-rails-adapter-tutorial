var columns = [
    {id: "id", name: "Id", field: "id", width: 120, editor: Slick.Editors.Text},
    {id: "version", name: "Version", width: 120, field: "version", editor: Slick.Editors.Text},
];

var options = {
    enableCellNavigation: true,
    enableColumnReorder: false,
    editable: true
};

window.Diffa = window.Diffa || new Object;
Diffa.data = [
      { id: 'sample-id0', version: 'sample-version0' }
];

Diffa.GridView = function(elt, source) { 
    this._elt = elt;
    this._source = source;
    // this._source.whenUpdated(this.update.bind(this));
    this._dataCache = []

    this._grid = new Slick.Grid(elt, this._dataCache, columns, options);
    this.render()
};

Diffa.GridView.prototype.render = function render() {
    this._elt.addClass('-rendered');
}

Diffa.tradeEntryView = new Diffa.GridView($("#grid_trade_entry"), null);
Diffa.futuresRiskGrid = new Diffa.GridView($("#grid_futures_risk"), null);
Diffa.optionsRiskGrid = new Diffa.GridView($("#grid_options_risk"), null);


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
