var windowURL = window.URL || window.webkitURL;

var koExtensions = function () {
    ko.bindingHandlers.slideToggle = {
        init: function (element, valueAccessor) {
            // Initially set the element to be instantly visible/hidden depending on the value
            var value = valueAccessor();
            $(element).toggle(ko.unwrap(value)); // Use "unwrapObservable" so we can handle values that may or may not be observable
        },
        update: function (element, valueAccessor) {
            // Whenever the value subsequently changes, slowly slide the element in or out
            var value = valueAccessor();
            ko.unwrap(value) ? $(element).slideDown() : $(element).slideUp();
        }
    };

    ko.bindingHandlers.radioButton = {
        init: function (element, valueAccessor, allBindingsAccessor, data, context) {
            ko.bindingHandlers.checked.init(element, valueAccessor, allBindingsAccessor, data, context);

            if ($(element).prop("checked") === true) {
                $(element).parent().addClass("selected");
            }
        },
        update: function (element) {

            $(element).on("click", function () {
                $(this).parent().addClass("selected");
                $(this).parent().siblings(".radio-inline").removeClass("selected");
            });
        }
    };

    ko.bindingHandlers.showModal = {
        update: function (element, valueAccessor) {
            var value = valueAccessor();
            var valueUnwrapped = ko.unwrap(value);

            if (valueUnwrapped === true)
                $(element).modal("show"); // Make the element visible
            else
                $(element).modal("hide"); // Make the element invisible
        }
    };

    ko.bindingHandlers.file = {
        init: function (element, valueAccessor) {
            $(element).change(function () {
                var file = this.files[0];
                if (ko.isObservable(valueAccessor())) {
                    valueAccessor()(file);
                }
            });
        },

        update: function (element, valueAccessor, allBindingsAccessor) {
            var file = ko.utils.unwrapObservable(valueAccessor());
            var bindings = allBindingsAccessor();

            if (bindings.fileObjectURL && ko.isObservable(bindings.fileObjectURL)) {
                var oldUrl = bindings.fileObjectURL();
                if (oldUrl) {
                    windowURL.revokeObjectURL(oldUrl);
                }
                bindings.fileObjectURL(file && windowURL.createObjectURL(file));
            }

            if (bindings.fileBinaryData && ko.isObservable(bindings.fileBinaryData)) {
                if (!file) {
                    bindings.fileBinaryData(null);
                } else {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        bindings.fileBinaryData(e.target.result);
                    };
                    reader.readAsArrayBuffer(file);
                }
            }
        }
    };
};