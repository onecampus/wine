/*
  options: {
    data:
    depth:
    allowEmpty:
    nodes:
  }
*/

function MultilevelSelect(options) {
  var getKeys = function(o) {
    var keys = [];
    var key;
    for (key in o) {
      keys.push(key);
    }
    return keys;
  };

  var changeOptions = function(selectNode, options) {
    var html = '';
    for (var i = 0; i < options.length; i++) {
      html += '<option>' + options[i] + '</option>';
    }
    selectNode.html(html);
  };

  var level1 = getKeys(options.data);
  changeOptions(options.nodes[0], level1);

  options.nodes[0].on('change', function(e) {
    var selected = options.nodes[0].val();
    var keys = getKeys(options.data[selected]);
    changeOptions(options.nodes[1], keys);

    options.nodes[1].trigger('change');
  });

  options.nodes[1].on('change', function() {
    var selected1 = options.nodes[0].val();
    if (selected1) {
      var selected2 = options.nodes[1].val();
      var keys = options.data[selected1][selected2];
      changeOptions(options.nodes[2], keys);
    }
  });

  if (options.nodes[0].attr('data-value')) {
    options.nodes[0].val(options.nodes[0].attr('data-value'));
    options.nodes[0].trigger('change');

    options.nodes[1].val(options.nodes[1].attr('data-value'));
    options.nodes[1].trigger('chang');

    options.nodes[2].val(options.nodes[2].attr('data-value'));
  } else {
    setTimeout(function() {
      options.nodes[0].find('option:first').prop('selected', true);
      options.nodes[0].trigger('change');
    }, 0);
  }
}
