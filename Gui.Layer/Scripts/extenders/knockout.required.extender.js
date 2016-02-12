ko.extenders.required = function (target, control) {
    //add some sub-observables to our observable
    var $control = $("#".concat(control));
    target.hasError = ko.observable();
    target.validationMessage = ko.observable(); //define a function to do validation

    function validate(newValue) {
        if (newValue !== undefined) {

            if (newValue) {
                target.hasError(false);
                $control.removeClass("input-validation-error");
            } else {
                target.hasError(true);
                $control.addClass("input-validation-error");
            }
        }
    }

    //initial validation
    validate(target());

    //validate whenever the value changes
    target.subscribe(validate);

    //return the original observable
    return target;
};