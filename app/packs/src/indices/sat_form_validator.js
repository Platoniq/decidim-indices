$(() => {

  //  [Abide | Foundation for Sites 6 Docs](https://get.foundation/sites/docs/abide.html)
  let $survey = $("form.answer-questionnaire");
  let $sumbitButton = $survey.find(".js--submit");

    let $currentStep = () => {
    return $survey.find(".questionnaire-step:visible")
  }

  let $buttonNext = () => {
    return $currentStep().find(".js--one-step-beyond");
  }

  let $buttonBack = () => {
    return $currentStep().find(".js--one-step-back");
  }

  let disableBtnContinue = () => {
    $buttonNext().addClass("disabled");
    // console.log('🍅 disabled Continue');
  };

  let enableBtnContinue = () => {
    // console.log('🍏 Continue');
    $buttonNext().removeClass("disabled");
  };

  let disableSubmitBtn = () => {
    $sumbitButton.addClass("disabled");
  }

  let enableSubmitBtn = () => {
    $sumbitButton.removeClass("disabled");
  }

  let validateStep = () => {
    let $inputs = $currentStep().find("input")
    $inputs.each(function(){
      let $element = $(this)
      $survey.foundation('validateInput', $element);
    });
  };

  let $visibleErrors = () => {
    return $currentStep().find(".form-error.is-visible");
  }

  let $hasErrorsCurrentStep = () => {
    return $visibleErrors().length > 0
  }

  let showValidationAlert = () => {
    $visibleErrors().each(function(i){
      let $element = $(this)
      let $fieldset = $element.closest(".js--sat-mandatory-fieldset");
      let $alert = $fieldset.find(".js--sat-fieldset-error");
      $alert.removeClass("hide");
      $element.closest(".check-box-collection").addClass("is-invalid-label");

    });
  }

  let hideValidationAlert = () => {
    // console.log("--------> hidealert")
    $survey.find(".js--sat-mandatory-fieldset").each(function(i){
      let $fieldset = $(this)
      let $alert = $fieldset.find(".js--sat-fieldset-error");
      $alert.addClass("hide");
      $fieldset.find(".check-box-collection").removeClass("is-invalid-label");
    });
  }

  // disable continue button on int
  $(function ($) {
    disableBtnContinue();
    disableSubmitBtn();
  });

  // disable continue button on step shown
  // $survey.on("on.zf.toggler", () => {
  //   if(direction != "back") {
  //     disableBtnContinue();
  //   }
  // });


  $survey.find(".js--one-step-beyond").on("click", function(ev) {
    // console.log('⏩ [click next] validate form!');
    validateStep();
    // console.log("❓ hasErrorsCurrentStep", $hasErrorsCurrentStep())
    if($hasErrorsCurrentStep()) {
      // console.log("👎 the step has errors")
      ev.stopImmediatePropagation();
      ev.preventDefault();
    } else {
      // console.log("👍 the step is valid")
    }
  });

  $sumbitButton.on("click", function(ev) {
    // console.log('⏩ [click SEND] validate form!');
    validateStep();
    // console.log("❓ hasErrorsCurrentStep", $hasErrorsCurrentStep())
    if($hasErrorsCurrentStep()) {
      // console.log("👎 the FORM has errors")
      ev.stopImmediatePropagation();
      ev.preventDefault();
    } else {
      // console.log("👍 the FORM is valid")
    }
  })

  // when an input is invalid
  $survey.on("invalid.zf.abide", function(ev,frm) {
    // console.log(" ❌ Input id "+ev.target.id+" is invalid :(");
    if($hasErrorsCurrentStep()) {
      disableBtnContinue();
      disableSubmitBtn();
      showValidationAlert();
    } else {
      enableBtnContinue();
      enableSubmitBtn();
      hideValidationAlert();
    }
  });

  // when an input is valid
  $survey.on("valid.zf.abide", function(ev,frm) {
    // console.log("✅ Input id "+ev.target.id+" is valid");
    if($hasErrorsCurrentStep()) {
      disableBtnContinue();
      disableSubmitBtn();
      showValidationAlert();
    } else {
      enableBtnContinue();
      enableSubmitBtn();
      hideValidationAlert();
    }
  });

  // form validation failed
  $survey.on("forminvalid.zf.abide", function(ev,frm) {
    // console.log("🚫 Form id "+ev.target.id+" is invalid");
    disableSubmitBtn();
  })

  // form validation passed, form will submit if submit event not returned false
  $survey.on("formvalid.zf.abide", function(ev,frm) {
    // console.log("📬 Form id "+frm.attr('id')+" is valid");
    enableSubmitBtn();
  });

  // to prevent form from submitting upon successful validation
  // $survey.on("submit", function(ev) {
  //   ev.preventDefault();
  //   console.log("Submit for form id "+ev.target.id+" intercepted");
  // });
});
