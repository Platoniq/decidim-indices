$(() => {
  $('.weblyzard .tools input.source').on("change", () =>  {
    let sources = [];
    $('.weblyzard .tools input.source:checked').each((_i, input) => {
      sources.push(input.value)
    });
    if(sources.length == 0) {
      $('.weblyzard .tools input.source:first').prop("checked", true);
      sources.push($('.weblyzard .tools input.source:first').val());
    }
    $('.weblyzard iframe.weblyzard-widget').each((_i, iframe) => {
      iframe.src = iframe.src.replace(/\/source=([a-z,]*)\//, `/source=${sources.join(",")}/`);
    });

  })

  $('.weblyzard .tools input.date').on("change", () =>  {
    let begindate = $('.weblyzard .tools input[name="begindate"]').val();
    let enddate = $('.weblyzard .tools input[name="enddate"]').val();
    console.log("date",begindate, enddate);
    if(!begindate) {
      begindate = new Date();
      begindate.setMonth(begindate.getMonth() - 6);
      begindate = begindate.getFullYear() + '-' + begindate.getMonth() + '-' + begindate.getDate();
    }
    if(!enddate) {
      enddate = new Date();
      enddate = enddate.getFullYear() + '-' + enddate.getMonth() + '-' + enddate.getDate();
    }
    $('.weblyzard iframe.weblyzard-widget').each((_i, iframe) => {
      iframe.src = iframe.src.replace(/\/date=([0-9,-]*)\//, `/date=${begindate},${enddate}/`);
    });
  });

});