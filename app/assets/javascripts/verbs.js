window.onload = function(){
  var uncheck_button = document.getElementById("uncheck_all");
  if (uncheck_button) {
    uncheck_button.addEventListener("click", function(){

      var tenses = document.querySelectorAll("div.choose_tense input");
      if(uncheck_button.getAttribute("data-check") == "1"){
        for (var i = tenses.length - 1; i >= 0; i--) {
          tenses[i].removeAttribute('checked');
        }
        uncheck_button.innerHTML = "Check all";
        uncheck_button.setAttribute("data-check", "0");
      }
      else{
        for (var j = tenses.length - 1; j >= 0; j--) {
          tenses[j].setAttribute('checked', 'checked');
        }
        uncheck_button.innerHTML = "Uncheck All";
        uncheck_button.setAttribute("data-check", "1");

      }
    }, false);


  }

  var chars = document.querySelectorAll("div#special_char button");
  var input_ans = document.getElementById("answer");
  input_ans.focus();
  input_ans.setAttribute("autocomplete", "off");

  var add_char = function(){
    var val = this.innerHTML;
    input_ans.value = input_ans.value + val.replace(/ /g, '');
  };

  for (var i = chars.length - 1; i >= 0; i--) {
    chars[i].addEventListener("click", add_char, false);
  }

  var trans_button = document.getElementById("show_trans");
  if (trans_button) {
    trans_button.addEventListener("click", function(){
      document.getElementById("trans").className = "show";
    }
    );
  }


};