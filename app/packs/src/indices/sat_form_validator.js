$(() => {

  //  [Abide | Foundation for Sites 6 Docs](https://get.foundation/sites/docs/abide.html)
  let $survey = $("form.answer-questionnaire");
  let $sumbitButton = $survey.find(".js--submit").first();

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
      if($element.hasClass("collection-input_checkbox_group")) {
        validateCheckboxGroups($element);
      }
    });
    $buttonNextTextContinue();
  };

  let $visibleErrors = () => {
    return $currentStep().find(".form-error").filter(":visible");
  };

  let $hasErrorsCurrentStep = () => {
    return $visibleErrors().length > 0
  };


  let validateCheckboxGroups = ($elem) => {
    if($elem.hasClass("collection-input_checkbox_group")) {
      let checkboxGroupIdx = $elem.data("row-idx");
      let checkboxGroupSelector = "input:checkbox[data-row-idx='"+checkboxGroupIdx+"']:checked";
      let $group = $elem.closest(".check-box-collection").first();
      let $fieldset = $elem.closest(".js--sat-mandatory-fieldset");
      let $alert = $fieldset.find(".js--sat-fieldset-error, .js--max-choices-alert");
      if (!$(checkboxGroupSelector).val()) {
        $group.find(".form-error").addClass("is-visible")
        $group.addClass("is-invalid-label");
        $alert.removeClass("hide");
      } else {
        $group.find(".form-error").removeClass("is-visible")
        $group.removeClass("is-invalid-label");
        $alert.addClass("hide");
      }
    }
  };

  let showValidationAlert = () => {
    let maxChoicesVisible = false;
    $visibleErrors().each(function(){
      let $element = $(this);
      let $fieldset = $element.closest(".js--sat-mandatory-fieldset");
      let $alert1 = $fieldset.find(".js--sat-fieldset-error");
      let $alert2 = $fieldset.find(".js--max-choices-alert");

      if($alert1.length){
        $alert1.removeClass("hide");
      }
      if($alert2.length){
        maxChoicesVisible = true;
      }

      $element.closest(".check-box-collection").addClass("is-invalid-label");
      $element.closest(".radio-button-collection").find("label").addClass("is-invalid-label");
    });
  };

  let hideValidationAlert = () => {
    $survey.find(".js--sat-mandatory-fieldset").each(function(){
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
    let $checkboxes = $currentStep().find(".collection-input_checkbox_group");
    $checkboxes.each(function(){
      validateCheckboxGroups($(this));
    })

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
    let $checkboxes = $currentStep().find(".collection-input_checkbox_group");
    $checkboxes.each(function(){
      validateCheckboxGroups($(this));
    })

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
