var formHelperVm = function() {
    var self = this;

    self.checkBool = function (val) {
        if (val == null) {
            return "";
        } else if (val) {
            return "True";
        } else {
            return "False";
        }
    };

    self.ResetInputVals = function ($section) {
        $section.find('input[type="text"]').each(function () {
            $(this).val('');
        });

        $section.find('input[type="radio"]').each(function () {
            $(this).removeAttr('checked');
            $(this).parent().removeClass("selected");
        });
    };
};

function onFormSubmit(form) {
    $(form).find("input[type='submit']").attr("disabled", "disabled").addClass("disabled");
    return true;
}