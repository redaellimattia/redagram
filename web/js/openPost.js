$(document).ready(function()
{
    $('#modalPost').on('show.bs.modal', function (event)
    {
      var button = $(event.relatedTarget);
      var recipient = button.data('whatever')
      var idPost =recipient.replace("f-","");
      updatingModal(idPost);
    });
});
function updatingModal(idPost) {
  var url= "../includes/searchPost.jsp?opz=4&idPost="+idPost;
  $.ajax({
    type: "POST",
    url: url,
    success: function(res)
    {
      $(".bodyContent").html(res);
    }
    });
}
