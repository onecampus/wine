var TableExport = function() {
	"use strict";
	//function to initiate HTML Table Export
	var runTableExportTools = function() {
		$(".export-pdf").on("click", function(e) {
					e.preventDefault();
					var exportTable = $(this).data("table");
					var ignoreColumn = $(this).data("ignorecolumn");
					$(exportTable).tableExport({
						type: 'pdf',
						escape: 'false',
						ignoreColumn: '['+ignoreColumn+']'
					});
				});
				$(".export-png").on("click", function(e) {
					e.preventDefault();
					e.preventDefault();
					var exportTable = $(this).data("table");
					var ignoreColumn = $(this).data("ignorecolumn");
					$(exportTable).tableExport({
						type: 'png',
						escape: 'false',
						ignoreColumn: '['+ignoreColumn+']'
					});
				});
				$(".export-excel").on("click", function(e) {
					e.preventDefault();
					var exportTable = $(this).data("table");
					var ignoreColumn = $(this).data("ignorecolumn");
					$(exportTable).tableExport({
						type: 'excel',
						escape: 'false',
						ignoreColumn: '['+ignoreColumn+']'
					});
				});
				$(".export-doc").on("click", function(e) {
					e.preventDefault();
					var exportTable = $(this).data("table");
					var ignoreColumn = $(this).data("ignorecolumn");
					$(exportTable).tableExport({
						type: 'doc',
						escape: 'false',
						ignoreColumn: '['+ignoreColumn+']'
					});
				});
				$(".export-powerpoint").on("click", function(e) {
					e.preventDefault();
					var exportTable = $(this).data("table");
					var ignoreColumn = $(this).data("ignorecolumn");
					$(exportTable).tableExport({
						type: 'powerpoint',
						escape: 'false',
						ignoreColumn: '['+ignoreColumn+']'
					});
				});
				$(".export-csv").on("click", function(e) {
					e.preventDefault();
					var exportTable = $(this).data("table");
					var ignoreColumn = $(this).data("ignorecolumn");
					$(exportTable).tableExport({
						type: 'csv',
						escape: 'false',
						ignoreColumn: '['+ignoreColumn+']'
					});
				});
				$(".export-txt").on("click", function(e) {
					e.preventDefault();
					var exportTable = $(this).data("table");
					var ignoreColumn = $(this).data("ignorecolumn");
					$(exportTable).tableExport({
						type: 'txt',
						escape: 'false',
						ignoreColumn: '['+ignoreColumn+']'
					});
				});
				$(".export-xml").on("click", function(e) {
					e.preventDefault();
					var exportTable = $(this).data("table");
					var ignoreColumn = $(this).data("ignorecolumn");
					$(exportTable).tableExport({
						type: 'xml',
						escape: 'false',
						ignoreColumn: '['+ignoreColumn+']'
					});
				});
				$(".export-sql").on("click", function(e) {
					e.preventDefault();
					var exportTable = $(this).data("table");
					var ignoreColumn = $(this).data("ignorecolumn");
					$(exportTable).tableExport({
						type: 'sql',
						escape: 'false',
						ignoreColumn: '['+ignoreColumn+']'
					});
				});
				$(".export-json").on("click", function(e) {
					e.preventDefault();
					var exportTable = $(this).data("table");
					var ignoreColumn = $(this).data("ignorecolumn");
					$(exportTable).tableExport({
						type: 'json',
						escape: 'false',
						ignoreColumn: '['+ignoreColumn+']'
					});
				});
	};
	
	//function to initiate DataTable
	//DataTable is a highly flexible tool, based upon the foundations of progressive enhancement,
	//which will add advanced interaction controls to any HTML table
	//For more information, please visit https://datatables.net/
	var runDataTableWithExport = function() {
		var oTable = $('#data-table-with-export').dataTable({
			"aoColumnDefs" : [{
				"aTargets" : [0]
			}],
            "oLanguage" : {
                "sLengthMenu": "每页显示 _MENU_ 条记录",
                "sInfo": "从 _START_ 到 _END_ /共 _TOTAL_ 条数据",
                "sInfoEmpty": "没有数据",
                "sInfoFiltered": "(从 _MAX_ 条数据中检索)",
                "sZeroRecords": "没有检索到数据",
                "sSearch": "搜索:",
                "oPaginate": {
                    "sFirst": "首页",
                    "sPrevious": "前一页",
                    "sNext": "后一页",
                    "sLast": "尾页"
                }
            },
			"aaSorting" : [[0, 'desc']],
			"aLengthMenu" : [[5, 10, 15, 20, -1], [5, 10, 15, 20, "All"] // change per page values here
			],
			// set the initial value
			"iDisplayLength" : 10
		});
		$('#data-table-with-export_wrapper .dataTables_filter input').addClass("form-control input-sm").attr("placeholder", "Search");
		// modify table search input
		$('#data-table-with-export_wrapper .dataTables_length select').addClass("m-wrap small");
		// modify table per page dropdown
		$('#data-table-with-export_wrapper .dataTables_length select').select2();
		// initialzie select2 dropdown
		$('#data-table-with-export_column_toggler input[type="checkbox"]').change(function() {
			/* Get the DataTables object again - this is not a recreation, just a get of the object */
			var iCol = parseInt($(this).attr("data-column"));
			var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
			oTable.fnSetColumnVis(iCol, ( bVis ? false : true));
		});
	};
	return {
		//main function to initiate template pages
		init : function() {
			runTableExportTools();
			runDataTableWithExport();
		}
	};
}();
