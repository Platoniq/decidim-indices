$(() => {
  $('.weblyzard .tools input.source').on("change", (e) =>  {
    let sources = [];
    $('.weblyzard .tools input.source:checked').each((i, input) => {
      sources.push(input.value)
    });
    if(sources.length == 0) {
      $('.weblyzard .tools input.source:first').prop("checked", true);
      sources.push($('.weblyzard .tools input.source:first').val());
    }
    $('.weblyzard iframe.weblyzard-widget').each((i,iframe) => {
      iframe.src = iframe.src.replace(/\/source=([a-z,]*)\//, `/source=${sources.join(",")}/`);
    });
  })
});