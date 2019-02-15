class RangeSelector {
    constructor($element, callback) {
        this.$element = $element;
        this.callback = callback;

        var self = this;

        $('button', this.$element).each(function() {
            $(this).on('click', { element: this, callback: callback }, self.elementHandler);
        });

        $('input', this.$element).each(function() {
            $(this).on('keypress', { element: this, callback: callback }, function(e) {
                if (e.which == 13)
                    self.elementHandler(e);
            });
        });
    }

    elementHandler(e) {
        var element = e.data.element;
        var callback = e.data.callback;

        callback({date_range: element.value});
    }
}
