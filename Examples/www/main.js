function set(key, value){
  $.get("uiw://nativestorage/setItem", {key: key, value: value})
    .success(function(){
      alert(text);
    });
}

function get(key){
  $.get("uiw://nativestorage/getItem?key=testkey", function(response){
    alert(response)
  });
}
