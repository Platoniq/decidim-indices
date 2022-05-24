$(() => {

  //  [Abide | Foundation for Sites 6 Docs](https://get.foundation/sites/docs/abide.html)
  let $survey = $("form.answer-questionnaire");
  let $sumbitButton = $survey.find(".js--submit").first();
  let $checkBox = $survey.find("input:checkbox");

  let $currentStep = () => {
    return $survey.find(".questionnaire-step").filter(":visible");
  };

  let $buttonNext = () => {
    return $currentStep().find(".js--one-step-beyond").first();
  };

  let $buttonNextTextContinue = () => {
    let text = $buttonNext().data("text-continue");
    $buttonNext().text(text);
  };

  let $buttonNextTextWait = () => {
    let text = $buttonNext().data("text-wait");
    $buttonNext().text(text);
  };

  let $alertEmptyFields = () => {
    return $currentStep().find(".js--step-empty--fields");
  };

  let disableBtnContinue = () => {
    $buttonNext().addClass("disabled");
    $alertEmptyFields().removeClass("hide");
  };

  let enableBtnContinue = () => {
    $buttonNext().removeClass("disabled");
    $alertEmptyFields().addClass("hide");
  };

  let disableSubmitBtn = () => {
    $sumbitButton.addClass("disabled");
    $alertEmptyFields().removeClass("hide");
  };

  let enableSubmitBtn = () => {
    $sumbitButton.removeClass("disabled");
    $alertEmptyFields().addClass("hide");
  };

  let validateStep = () => {
    $buttonNextTextWait();
    let $inputs = $currentStep().find("input, textarea").not(".free-text");
    $inputs.each(function(){
      let $element = $(this);
      $survey.foundation('validateInput', $element);
    });
    $buttonNextTextContinue();
  };

  let $visibleErrors = () => {
    return $currentStep().find(".form-error").filter(":visible");
  };

  let $hasErrorsCurrentStep = () => {
    return $visibleErrors().length > 0
  };

  let showValidationAlert = () => {
    let maxChoicesVisible = false;
    $visibleErrors().each(function(){
      let $element = $(this);
      let $fieldset = $element.closest(".js--sat-mandatory-fieldset");
      let $alert = $fieldset.find(".js--sat-fieldset-error, .js--max-choices-alert");
      if($alert.hasClass("js--max-choices-alert")){
        maxChoicesVisible = true;
      } else if(maxChoicesVisible){
      }else{
        $alert.removeClass("hide");
      }

      $element.closest(".check-box-collection").addClass("is-invalid-label");
      $element.closest(".radio-button-collection").find("label").addClass("is-invalid-label");
    });
  };

  let hideValidationAlert = () => {
    $survey.find(".js--sat-mandatory-fieldset").each(function(i){
      let $fieldset = $(this);
      let $alert = $fieldset.find(".js--sat-fieldset-error");
      $alert.addClass("hide");
      if($alert.hasClass("js--max-choices-alert")){
      }else{
        $alert.addClass("hide");
      }
      $fieldset.find(".check-box-collection").removeClass("is-invalid-label");
      $fieldset.find(".radio-button-collection label").removeClass("is-invalid-label");
    });
  };

  // disable continue button on init
  $(function ($) {
    if($hasErrorsCurrentStep()){
      disableBtnContinue();
      disableSubmitBtn();
    }
  });


  $survey.find(".js--one-step-beyond").on("click", function(ev) {
    validateStep();
    if($hasErrorsCurrentStep()) {
      ev.stopImmediatePropagation();
      ev.preventDefault();
    }
  });

  $sumbitButton.on("click", function(ev) {
    validateStep();
    if($hasErrorsCurrentStep()) {
      ev.stopImmediatePropagation();
      ev.preventDefault();
    }
  });

  // $checkBox.on("click", function() {
  //   console.log(">> checkox click")
  //   if($hasErrorsCurrentStep()) {
  //     disableBtnContinue();
  //     disableSubmitBtn();
  //     showValidationAlert();
  //   } else {
  //     enableBtnContinue();
  //     enableSubmitBtn();
  //     hideValidationAlert();
  //   }
  // });

  // when an input is invalid
  $survey.on("invalid.zf.abide", function(ev,frm) {
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

  let $inputs = $currentStep().find("input, textarea").not(".free-text")

  $inputs.on("change", function(ev,frm) {
    validateStep();
  });

  // form validation failed
  $survey.on("forminvalid.zf.abide", function(ev,frm) {
    disableSubmitBtn();
  });

  // form validation passed, form will submit if submit event not returned false
  $survey.on("formvalid.zf.abide", function(ev,frm) {
    enableSubmitBtn();
  });

  // to prevent form from submitting upon successful validation
  // $survey.on("submit", function(ev) {
  //   ev.preventDefault();
  //   console.log("Submit for form id "+ev.target.id+" intercepted");
  // });
});
