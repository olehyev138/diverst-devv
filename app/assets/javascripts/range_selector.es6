class RangeSelector {
    constructor($element, callback) {
        // $element is the actual jquery object representing this instance of a range selector
        // callback is the callback function to call when something in the range selector happens
        this.$element = $element;
        this.callback = callback;

        // set the event handlers for all range selector buttons and text inputs
        // store this in self, so that we can use access instance inside closures and event handlers

        var self = this;

        $('button', this.$element).each(function() {
            $(this).on('click', { self: self, button: this }, self.buttonHandler);
        });

        $('input', this.$element).each(function() {
            $(this).on('keypress', { self: self, input: this }, self.inputHandler);
        });

        // disable all 'all' buttons because 'all' is the default date range
        this.update_button($("button[value='all']"));
    }

    buttonHandler(e) {
        var self = e.data.self;
        var button = e.data.button;
        var callback = self.callback;

        callback({date_range: button.value});

        self.update_button(button);
    }

    inputHandler(e) {
        if (e.which == 13) {
            var self = e.data.self;
            var input = e.data.input;
            var callback = self.callback;

            callback({date_range: input.value});
        }
    }

    update_button(button) {
        // enable old current button, store & disable new current button
        // this is just to disable the current button, ie no reason to have users keep clicking it

        $(button).prop('disabled', true);

        if ($(this.current_button).length)
            $(this.current_button).prop('disabled', false);

        this.current_button = button;
    }
}
