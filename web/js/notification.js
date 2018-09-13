$(document).ready(function()
{
    $(document).on("click", ".notifica", function(e)
    {
      var idNotifica = e.target.id.replace("n-","");
      var url= "../includes/notification.jsp?opz=1&idNotifica="+idNotifica;
      console.log(url);
      $.ajax({
        type: "POST",
        url: url,
        success: function()
        {
          console.log("updated");
        }
      });
    });
    $("#modalPost").on("hidden.bs.modal", function () {
      location.reload(true);
    });
    $(document).on("click", ".openNotifiche", function(e)
    {
      var url= "../includes/notification.jsp?opz=2";
      console.log(url);
      $.ajax({
        type: "POST",
        url: url,
        success: function(res)
        {
          $(".dropdown-menu").html(res);
        }
      });
    });
});
