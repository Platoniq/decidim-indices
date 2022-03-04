window.loadedWeblyzardIframe = (iframe) => {
  // console.log("loaded", iframe);
  $(iframe).closest(".tabs-panel").removeClass("loading");
};

$(() => {
  const currentState = () => {
    let state = {
      source: [],
      begindate: $('.weblyzard .tools input[name="begindate"]').val(),
      enddate: $('.weblyzard .tools input[name="enddate"]').val()
    };
    $('.weblyzard .tools input.source:checked').each((_i, input) => {
      state.source.push(input.value)
    });
    if(!state.begindate) {
      state.begindate = new Date();
      state.begindate.setMonth(state.begindate.getMonth() - 6);
      state.begindate = state.begindate.getFullYear() + '-' + state.begindate.getMonth() + '-' + state.begindate.getDate();
    }
    if(!state.enddate) {
      state.enddate = new Date();
      state.enddate = state.enddate.getFullYear() + '-' + state.enddate.getMonth() + '-' + state.enddate.getDate();
    }
    return state;
  };

  const replaceIframes = (search, replacement) => {
    $('.weblyzard iframe.weblyzard-widget').each((_i, iframe) => {
      $(iframe).closest(".tabs-panel").addClass("loading");
      iframe.src = iframe.src.replace(search, replacement);
    });
  };

  const showMsg = (type, msg, time) => {
    $(`.weblyzard .config .result.text-${type}`).removeClass("hide").show().html(msg);
    setTimeout(() => {
      $(`.weblyzard .config .result.text-${type}`).fadeOut(3000);
    }, time || 5000);
  };

  $('.weblyzard .tools input.source').on("change", () =>  {
    let sources = currentState().source;

    if(!sources.length) {
      $('.weblyzard .tools input.source:first').prop("checked", true);
      sources.push($('.weblyzard .tools input.source:first').val());
    }
    replaceIframes(/\/source=([a-z,]*)\//, `/source=${sources.join(",")}/`);
  })

  $('.weblyzard .tools input.date').on("change", () =>  {
    let state = currentState();
    replaceIframes(/\/date=([0-9,-]*)\//, `/date=${state.begindate},${state.enddate}/`);
  });
  
  let $button = $('.weblyzard .config button.submit');
  
  $('.weblyzard .config input.keywords').on("change", () =>  {
    let keywords = $('.weblyzard .config input.keywords').val();
    replaceIframes(/\/similarto=([^\/]*)\//, `/similarto=${encodeURIComponent(keywords)}/`);
  });
  $('.weblyzard .config input.disabled').on("change", (e) =>  {
    $('.weblyzard .tabs-content,.weblyzard .info').toggleClass("hide");
  });

  $button.on("click", () => {
    $button.addClass("disabled");
    let post = {
      defaults: currentState(), 
      keywords: $('.weblyzard .config input.keywords').val(),
      active: !$('.weblyzard .config input.disabled').prop("checked"),
      document: {
        resource_type: $('.weblyzard .config').data("resource-type"),
        resource_id: $('.weblyzard .config').data("resource-id"),
      }
    };
    // console.log("post", post)
    $.ajax({
      method: "POST",
      url: "/weblyzard_logs",
      data: JSON.stringify(post),
      dataType: 'json',
      contentType: "application/json",
      headers: {
        'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')
      },
      success: (data) => {
        // console.log("ok", data)
        showMsg('success', data.msg);
        $button.removeClass("disabled");
      },
      error: (jq) => {
        const error = (jq.responseJSON && jq.responseJSON.error) || "Unknown error";
        console.error("error", error);
        showMsg('alert', error, 10000);
        $button.removeClass("disabled");
      }
    });
  });

});