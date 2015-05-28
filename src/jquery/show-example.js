var urlParams = {};
(function () {
    var match,
        pl     = /\+/g,
        search = /([^&=]+)=?([^&]*)/g,
        decode = function (s) { return decodeURIComponent(s.replace(pl, " ")); },
        query  = window.location.search.substring(1);

    while (match = search.exec(query))
       urlParams[decode(match[1])] = decode(match[2]);
})();

$(document).ready(
  function() {
    var url = urlParams["url"];
    $("h2").text(url);
    $("iframe").attr("src",url+".html");
    $.get (url+".html",
      function(code){
        code=code.replace(/&/mg,'&#38;');
        code=code.replace(/</mg,'&#60;');
        code=code.replace(/>/mg,'&#62;');
        code=code.replace(/\"/mg,'&#34;');
        code=code.replace(/\t/g,'  ');
        code=code.replace(/\r?\n/g,'<br>');
        code=code.replace(/<br><br>/g,'<br>');
        code=code.replace(/ /g,'&nbsp;');
        $("pre").html(code);
      }
    );
  }
);
