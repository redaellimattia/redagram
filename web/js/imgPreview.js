var loadFile = function(event)
{
  var output = document.getElementById('output');
  output.src = URL.createObjectURL(event.target.files[0]);
};
function test()
{
  $("#custom-file").trigger('click');
};
