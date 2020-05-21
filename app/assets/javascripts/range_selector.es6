class RangeSelector {
    constructor($element, callback) {
        // $element is the actual jquery object representing this instance of a range selector
        // callback is the callback function to call when something in the range selector happens
        this.callback = callback;
        this.$element = $element;

        this.date_range = '';

        // store text input elements
        this.$from_input = $('.from_input', this.$element);
        this.$to_input = $('.to_input', this.$element);

        // store instance in self, so that we can use access instance inside closures and event handlers
        var self = this;

        // add event handler for all range buttons
        $('.range-btn', this.$element).each(function() {
            $(this).on('click', { self: self, button: this }, self.rangeButtonHandler);
        });

        // add handler for refresh button - this button is for 'specific' date ranges
        $('.filter-btn', this.$element).on('click', { self: self, button: this }, self.refreshButtonHandler);

        // disable 'all' button because 'all' is the default date range
        this.update_button($("button[value='all']", this.$element));
    }

    rangeButtonHandler(e) {
        var self = e.data.self;
        var button = e.data.button;
        var callback = self.callback;

        self.date_range = { from_date: button.value };

        callback(self.date_range);
        self.update_button(button);
    }

    refreshButtonHandler(e) {
        var self = e.data.self;
        var callback = self.callback;

        var from_date = $(self.$from_input).val();
        var to_date = $(self.$to_input).val();

        if ((new Date(from_date).getTime()) < (new Date(to_date).getTime())) {
            self.date_range = { from_date: from_date, to_date: to_date };
            callback(self.date_range);
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
