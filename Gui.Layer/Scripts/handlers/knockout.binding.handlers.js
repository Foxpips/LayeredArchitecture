ko.bindingHandlers["href"] = {
    update: function (element, valueAccessor) {
        element.href = ko.utils.unwrapObservable(valueAccessor());
    }
};

ko.bindingHandlers["title"] = {
    update: function (element, valueAccessor) {
        element.title = ko.utils.unwrapObservable(valueAccessor());
    }
};

var showElement = function (element) {
    var $element = $(element);
    $element.removeClass(appSettings.hideCssClass);
    $element.addClass(appSettings.showCssClass);
}

var hideElement = function (element) {
    var $element = $(element);
    $element.addClass(appSettings.hideCssClass);
    $element.removeClass(appSettings.showCssClass);
}

ko.bindingHandlers["clickable"] = {
    'update': function (element, valueAccessor) {
        var value = ko.utils.unwrapObservable(valueAccessor());
        var $element = $(element);

        if (value && element.disabled) {
            element.removeAttribute("disabled");
            $element.removeClass("disabled");
        } else if ((!value) && (!element.disabled)) {
            element.disabled = true;
            $element.addClass("disabled");
        }
    }
};


ko.bindingHandlers["show"] = {
    update: function (element, valueAccessor) {
        var isVisible = ko.utils.unwrapObservable(valueAccessor());
        if (isVisible) {
            showElement(element);
        } else {
            hideElement(element);
        }
    }
};

ko.bindingHandlers["hide"] = {
    update: function (element, valueAccessor) {
        var unwrapObservable = ko.utils.unwrapObservable(valueAccessor());
        if (unwrapObservable) {
            hideElement(element);
        }
        else {
            showElement(element);
        }
    }
};