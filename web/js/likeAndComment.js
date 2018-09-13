$(document).ready(function()
{
    $(document).on("click", ".likes", function(e) //Onclick sull'elenco like
    {
      var idPost = e.target.id.replace("m-","");
      var url= "../includes/searchPost.jsp?opz=1&idPost="+idPost;
      $.ajax({
        type: "POST",
        url: url,
        success: function(res)
        {
          $(".lista").html(res); //Agiorno modal lista like
        }
        });
    });
    var idPostAll;
    $(document).on("click", ".comment-href", function(e) //Lista dei commenti
    {
      console.log(e.target);
      var idPost = e.target.id.replace("c-","");
      console.log(idPost);
      idPostAll = idPost;
      updateAll();
    });
    $(document).on("click", ".leaveComment", function(e) //Onclick sul pulsante per lasciare un messaggio
    {
      updateAll();
      var value = $("#textAreaComment").val();
      if(value!=="")
      {
        $("#textAreaComment").addClass("is-valid");
        var url = "../includes/searchPost.jsp?opz=3&idPost="+idPostAll+"&comment="+value;
        $.ajax({
          type: "POST",
          url: url,
          success: function()
          {
            $("#textAreaComment").val("");
            updateAll();
          }
          });
      }
      else
         $("#textAreaComment").addClass("is-invalid");

    });
    function updateAll()
    {
      var url= "../includes/searchPost.jsp?opz=2&idPost="+idPostAll;
      $.ajax({
        type: "POST",
        url: url,
        success: function(res)
        {
          $(".listaComment").html(res);
        }
        });
    }
});
