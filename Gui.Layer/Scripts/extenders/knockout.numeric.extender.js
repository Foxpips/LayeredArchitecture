ko.extenders.numeric = function (target) {
    function isNumeric(obj) {
        return !isNaN(parseInt(obj, 10)) && isFinite(obj);
    }

    function forceNumeric(input) {
        if (!isNumeric(input)) {
            return input.replace(/\D/g, "");
        }
        return input;
    }

    //create a writable computed observable to intercept writes to our observable
    var result = ko.pureComputed({
        read: target,  //always return the original observables value
        write: function (newValue) {
            if (newValue === undefined) {
                return;
            }
            var current = target(),
		        valueToWrite = forceNumeric(newValue);
            //only write if it changed
            if (valueToWrite !== current) {
                target(valueToWrite);
            } else {
                //if the rounded value is the same, but a different value was written, force a notification for the current field
                if (newValue !== current) {
                    target.notifySubscribers(valueToWrite);
                }
            }
        }
    }).extend({ notify: "always" });

    //initialize with current value to make sure it is rounded appropriately
    result(target());

    //return the new computed observable
    return result;
}