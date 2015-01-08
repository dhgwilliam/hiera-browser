// Load the node list
$(document).ready(function() {
  $.getJSON('/api/v1/nodes', function(data) {
    $('#node_list ul').empty();
    $.each(data, function(index, value) {
      $('#node_list ul').append("<li onclick='query(\""+value+"\");'>"+value+"</li>");
    });
  });
})

// auery the REST endpoint for node data, and render it
function query(node) {
  $('#wrapper').html('<img src="images/loader_purple.gif">');
  params = {
    additive: $('#additive').is(':checked'),
    overrides: get_overrides()
  }
  $.getJSON('/api/v1/node/'+node, params, function(data) {
    $('#wrapper').empty();
    $.each(data, function(index, value) {
      prettyvalue = library.json.prettyPrint(value['value'])
      $('#wrapper').append('<div class="key"><div class="header">'+value['key']+'</div><div class="value">'+prettyvalue+'</div><div class="origin">origin: '+value['origin']+'</div></div>');
    });
  });
}

// Add an override to the view
function add_override() {
  $('#overrides').append('<div class="override"><input class="fact" type="text"> = <input class="value" type="text"><a onclick="remove_override($(this));"> -</a></div>');
}

// Remove an override from the view
function remove_override(obj) {
  $(obj).closest('div').remove();
}

// Returns JSON containing the fact overrides
function get_overrides() {
  var out = []
  facts = $('#overrides .override').map(function () {
    out.push ({
      key: $(this).find('.fact:text').val(),
      value :$(this).find('.value:text').val()
    }); 
  });
  return out
}
