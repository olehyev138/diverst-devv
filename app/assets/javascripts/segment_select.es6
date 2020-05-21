const STARTING_PAGE = 1;
const LIMIT = 8;
const MULTISELECT_DEFAULT = false;

const SEGMENT_CLASSES = {
    CONTENT: 'segments-content',
    HEADER: 'modal-header',
    FOOTER: 'modal-footer',
    PARENT_SEGMENT: 'parent',
    CHILD_SEGMENT: 'child',
    COLLAPSE_CONTAINER: 'collapse-container',
    SEGMENT_CONTAINER_PREFIX: 'segment_container_',
    SEGMENT_PREFIX: 'segment_',
    EXPAND_BUTTON: 'expand-segment-btn',
    SELECT_ALL_BUTTON: 'select-all-btn',
    CLEAR_BUTTON: 'clear-btn',
    SAVE_BUTTON: 'save-segments-btn',
    PAGINATION_ROW: 'pagination-row',
    HELPER_ROW: 'helper-row',
    TOTAL_PAGES_TEXT: 'total-pages-text',
    CURRENT_PAGE_INPUT: 'current-page-input',
    PAGINATION_TEXT: 'pagination-text',
    PAGINATION_BUTTON: 'pagination-button',
    NEXT_PAGE_BUTTON: 'next-page-btn',
    PREVIOUS_PAGE_BUTTON: 'previous-page-btn',
    FIRST_PAGE_BUTTON: 'first-page-btn',
    LAST_PAGE_BUTTON: 'last-page-btn',
    TITLE_CONTAINER: 'title-container',
    SEARCH_CONTAINER: 'search-container',
    SEARCH_INPUT: 'search-input',
    SEARCH_BUTTON: 'search-btn',
    CLEAR_SEARCH_BUTTON: 'clear-search-btn'
};

const EXPAND_BUTTON_TEXT = {
    EXPAND: "+",
    COLLAPSE: "&ndash;"
};

const PAGINATION_TEXT = {
    PREVIOUS: "&lsaquo;",
    NEXT: "&rsaquo;",
    FIRST: "&laquo;",
    LAST: "&raquo;"
};

const DEFAULT_SEGMENT_TEXT = {
    SINGULAR: "segment",
    PLURALIZED: "segments"
};

// ----- Segment Selector -----
// Reads from 2..3 data attributes on the segment selector element itself
// 'data-multiselect' is a REQUIRED boolean value that switches the segment selector between multi select or single select
// 'data-url' is a REQUIRED string that represents the URL to pull segment data from
// 'data-all-url' is an OPTIONAL string that represents the URL to pull
// 
// Bind directly on the 'segment-selector' element to the event 'saveSegments', which is called when the Save button is clicked, to retrieve the list of selected segments
class SegmentSelector {
    constructor($element) {
        // console.log(this);
        // $element is the actual jQuery object representing this instance of a segment selector
        this.$element = $element;
        // multiselect is a boolean that defines whether multiple segments can be selected
        this.multiselect = this.$element.data('multiselect');
        // dataUrl is the URL that the segment selector fetches from
        this.dataUrl = this.$element.data('url');
        // allDataUrl is the URL that the segment selector 'Select All' fetches from
        this.allDataUrl = this.$element.data('all-url');
        // segmentsElement is the jQuery object where segment data will be inserted
        this.segmentsElement = $("." + SEGMENT_CLASSES.CONTENT, this.$element);
        // preselectedSegments is an optional array of segment IDs to pre-select
        this.preselectedSegments = this.$element.data('preselected-segments') || [];

        // Store the data on the object so we can use it when expanding, etc.
        this.data = {};
        // Stores the currently selected segments
        this.selectedSegments = [];


        // Pagination & search variables
        this.currentPage = STARTING_PAGE;
        this.totalPages = this.currentPage;
        this.searchTerm = "";

        // Store instance in self, so that we can use access instance inside closures and event handlers
        let self = this;

        // Add pagination html
        $("." + SEGMENT_CLASSES.FOOTER + " > .row." + SEGMENT_CLASSES.PAGINATION_ROW, this.$element).html(this.buildPaginationHtml());

        // Add selector helper html
        $("." + SEGMENT_CLASSES.FOOTER + " > .row." + SEGMENT_CLASSES.HELPER_ROW, this.$element).append(this.buildHelperHtml());

        // Add initial click event listeners
        $("." + SEGMENT_CLASSES.SAVE_BUTTON, this.$element).click({ self: self }, self.saveHandler);
        $("." + SEGMENT_CLASSES.SELECT_ALL_BUTTON, this.$element).click({ self: self }, self.selectAllHandler);
        $("." + SEGMENT_CLASSES.CLEAR_BUTTON, this.$element).click({ self: self }, self.clearHandler);
        $("." + SEGMENT_CLASSES.PREVIOUS_PAGE_BUTTON, this.$element).click({ self: self }, self.previousPageHandler);
        $("." + SEGMENT_CLASSES.NEXT_PAGE_BUTTON, this.$element).click({ self: self }, self.nextPageHandler);
        $("." + SEGMENT_CLASSES.FIRST_PAGE_BUTTON, this.$element).click({ self: self }, self.firstPageHandler);
        $("." + SEGMENT_CLASSES.LAST_PAGE_BUTTON, this.$element).click({ self: self }, self.lastPageHandler);
        $("." + SEGMENT_CLASSES.SEARCH_BUTTON, this.$element).click({ self: self }, self.searchHandler);
        $("." + SEGMENT_CLASSES.CLEAR_SEARCH_BUTTON, this.$element).click({ self: self }, self.clearSearchHandler);

        // Search input on 'Enter' event listener
        $("." + SEGMENT_CLASSES.SEARCH_INPUT, this.$element).keypress({ self: self }, function(e) {
            if (e.keyCode === 10 || e.keyCode === 13) {
              e.preventDefault();
              self.searchHandler(e);
            }
        });

        // Current page input on 'Enter' event listener
        $("." + SEGMENT_CLASSES.CURRENT_PAGE_INPUT, this.$element).keypress({ self: self }, function(e) {
            if (e.keyCode === 10 || e.keyCode === 13) {
              e.preventDefault();
              self.currentPageHandler(e);
            }
        });

        this.preselectSegments();
        this.updateData();
    }

    updateData() {
        let self = this;

        $.get(this.dataUrl, { page: this.currentPage, limit: LIMIT, term: this.searchTerm }, (data) => {
            // Get the custom segment text
            self.segmentText = data.segment_text;
            self.segmentTextPluralized = data.segment_text_pluralized;

            self.totalPages = data.total_pages; // Get the total page count

            // Update the segment data
            self.data = data.segments;
            self.onDataUpdate();
        });
    }

    onDataUpdate() {
        let self = this;
        let data = this.data;

        this.segmentsElement.html(''); // Clear the list of segments

        // The segments list is not defined or empty
        if (data == undefined || data.length == 0) {
            self.segmentsElement.append('<div class="card__section"><h4>No results.</h4></div>');
            return;
        }

        // Check if the parents have any logos, if so add the logo or the space for the logo
        var parentHasLogo = false;
        $.each(data, function(i, segment) {
            if (segment.logo_expiring_thumb)
                parentHasLogo = true;
        });

        // For each segment, add it and it's children to the HTML
        $.each(data, function(i, segment) {
            var html = self.buildSegmentHtml(segment, parentHasLogo, i == data.length - 1);

            $.each(segment.children, function (j, child) {
                html += self.buildSegmentHtml(child);
            });

            self.segmentsElement.append(html);

            $("." + SEGMENT_CLASSES.SEGMENT_CONTAINER_PREFIX + segment.id, self.segmentsElement).find("." + SEGMENT_CLASSES.EXPAND_BUTTON).click();
        });

        // Post data calls
        this.checkSelectedSegments();
        this.addPostDataEventListeners();
        this.updatePaginationButtons();

        // Add title html
        $("." + SEGMENT_CLASSES.TITLE_CONTAINER, this.$element).html(this.buildTitleHtml());

        // Set the total pages count
        $("." + SEGMENT_CLASSES.TOTAL_PAGES_TEXT, this.$element).text(self.totalPages);
    }

    // ************* HTML Builders *************

    buildSegmentHtml(segment, renderLogo = true, lastParentSegment = false) {
        var containerClass = SEGMENT_CLASSES.CHILD_SEGMENT;
        var childIndicatorHtml = "";
        var segmentLogoHtml = "";
        var expandButtonHtml = "";
        var booleanHtml = "";

        // The segment is a parent
        if (!$.isNumeric(segment.parent_id)) {
            // Don't put a border on the last parent
            if (lastParentSegment)
                containerClass = SEGMENT_CLASSES.PARENT_SEGMENT;
            else
                containerClass = SEGMENT_CLASSES.PARENT_SEGMENT + " card__section--border";

            // The segment is a parent with children
            if (segment.children != undefined && segment.children.length > 0) {
                // Add the expand/collapse button
                expandButtonHtml = `
                    <div class="col pull-right">
                        <button type="button" class="${SEGMENT_CLASSES.EXPAND_BUTTON} btn btn--tertiary btn--small" data-segment-id="${segment.id}">${EXPAND_BUTTON_TEXT.EXPAND}</button>
                    </div>
                `;
            }
        }
        else {
            childIndicatorHtml = `
                <div class="col">
                    <hr class="child-indicator">
                </div>
            `;
        }

        if (renderLogo) {
            // The segment has a logo
            if (segment.logo_expiring_thumb) {
                // Add the segment logo
                segmentLogoHtml = `
                    <div class="col segment-logo-container">
                        <img src="${segment.logo_expiring_thumb}" alt="${segment.name} Logo" width="48px" height="48px">
                    </div>
                `;
            }
            else {
                segmentLogoHtml = `
                    <div class="col segment-logo-container" style="width: 48px;"></div>
                `;
            }
        }

        if (this.multiselect === true) {
            booleanHtml = `
                <input value="0" type="hidden" class="${SEGMENT_CLASSES.SEGMENT_PREFIX}${segment.id}" name="${SEGMENT_CLASSES.SEGMENT_PREFIX}${segment.id}">
                <input type="checkbox" class="control__input boolean optional ${SEGMENT_CLASSES.SEGMENT_PREFIX}${segment.id}" name="${SEGMENT_CLASSES.SEGMENT_PREFIX}${segment.id}" data-segment-id="${segment.id}" data-segment-name="${segment.name}">
                <span class="control__indicator control__indicator--checkbox"></span>
            `;
        }
        else {
            booleanHtml = `
                <input type="radio" class="control__input radio ${SEGMENT_CLASSES.SEGMENT_PREFIX}${segment.id}" name="segments" value="${segment.id}" data-segment-id="${segment.id}" data-segment-name="${segment.name}">
                <span class="control__indicator control__indicator--radio"></span>
            `;
        }

        let segmentHtml = `
            <div class="${containerClass} card__section ${SEGMENT_CLASSES.SEGMENT_CONTAINER_PREFIX}${segment.id}" data-segment-id="${segment.id}" data-segment-name="${segment.name}">
                <div class="row">
                    ${childIndicatorHtml}
                    ${segmentLogoHtml}
                    <div class="col">
                        <label class="control">
                            ${booleanHtml}
                        </label>
                    </div>
                    <div class="col">
                        ${segment.name}
                    </div>
                    ${expandButtonHtml}
                </div>
            </div>
        `;

        // The segment is a child
        if ($.isNumeric(segment.parent_id)) {
            // Return collapsed HTML
            return `
                  <div class="${SEGMENT_CLASSES.COLLAPSE_CONTAINER} collapse card__section--border">
                      ${segmentHtml}
                  </div>
            `;
        }
        else
            return segmentHtml; // Return normal HTML
    }

    buildTitleHtml() {
        var title = "";
        var subText = "";
        var closeButton = '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>';

        var segmentText = this.segmentText;
        var segmentTextPluralized = this.segmentTextPluralized;

        if (!segmentText) {
            segmentText = DEFAULT_SEGMENT_TEXT.SINGULAR;
            segmentTextPluralized = DEFAULT_SEGMENT_TEXT.PLURALIZED;
        }

        if ((this.multiselect == null))
            this.multiselect = MULTISELECT_DEFAULT;

        if (this.multiselect == true) {
            title = segmentTextPluralized;
            subText = "<small>Double click to select all sub-" + segmentTextPluralized.toLowerCase() + "</small>";
        }
        else
            title = segmentText;

        return closeButton + '<h4 class="modal-title">Choose ' + title + '</h4>' + subText;
    }

    buildPaginationHtml() {
        var html = `
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--extra--small ${SEGMENT_CLASSES.PAGINATION_BUTTON} ${SEGMENT_CLASSES.FIRST_PAGE_BUTTON}">${PAGINATION_TEXT.FIRST}</button>
            </div>
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--extra--small ${SEGMENT_CLASSES.PAGINATION_BUTTON} ${SEGMENT_CLASSES.PREVIOUS_PAGE_BUTTON}">${PAGINATION_TEXT.PREVIOUS}</button>
            </div>
            <div class="col">
                <div class="${SEGMENT_CLASSES.PAGINATION_TEXT}">
                    <input type="text" class="field__input ${SEGMENT_CLASSES.CURRENT_PAGE_INPUT}" value="${this.currentPage}"> / <span class="${SEGMENT_CLASSES.TOTAL_PAGES_TEXT}">${STARTING_PAGE}</span>
                </div>
            </div>
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--extra--small ${SEGMENT_CLASSES.PAGINATION_BUTTON} ${SEGMENT_CLASSES.NEXT_PAGE_BUTTON}">${PAGINATION_TEXT.NEXT}</button>
            </div>
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--extra--small ${SEGMENT_CLASSES.PAGINATION_BUTTON} ${SEGMENT_CLASSES.LAST_PAGE_BUTTON}">${PAGINATION_TEXT.LAST}</button>
            </div>
        `;

        return html;
    }

    buildHelperHtml() {
        var helperHtml = "";

        if (this.allDataUrl && this.multiselect) {
          helperHtml += `
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--small ${SEGMENT_CLASSES.SELECT_ALL_BUTTON}">Select All</button>
            </div>
          `;
        }

        helperHtml += `
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--small ${SEGMENT_CLASSES.CLEAR_BUTTON}">Clear</button>
            </div>
        `;

        return helperHtml;
    }

    // ************* Handlers *************

    expandSegmentHandler(e) {
        let self = e.data.self;
        let button = e.data.button;
        $(button).attr("disabled", true); // Disable the button (until transition is complete)

        // Get the children of the parent segment that was expanded/collapsed
        let children = self.getSegmentChildren(button);

        // Toggle the collapse for each child of the parent segment
        $.each(children, function(index, child) {
            self.toggleCollapse($("." + SEGMENT_CLASSES.SEGMENT_CONTAINER_PREFIX + child.id, self.segmentsElement).closest("." + SEGMENT_CLASSES.COLLAPSE_CONTAINER));
        });

        var lastParentElement = $("." + SEGMENT_CLASSES.PARENT_SEGMENT + ":last-of-type", this.segmentsElement);
        lastParentElement.hasClass("card__section--border") ? lastParentElement.removeClass("card__section--border") : lastParentElement.addClass("card__section--border");
        
        // Toggle the expand/collapse button text
        $(button).html() == EXPAND_BUTTON_TEXT.EXPAND ? $(button).html(EXPAND_BUTTON_TEXT.COLLAPSE) : $(button).html(EXPAND_BUTTON_TEXT.EXPAND);

        // Toggle the expand/collapse button segment_classes
        $(button).hasClass("expanded") ? $(button).removeClass("expanded") : $(button).addClass("expanded");
    }

    selectAllHandler(e) {
        let self = e.data.self;

        if (!self.allDataUrl)
            return;

        self.selectedSegments = [];

        $.get(self.allDataUrl, { term: self.searchTerm }, (data) => {
            $.each(data, function(index, segment) {
                self.addToSelectedSegments(segment.id, segment.text);
            });

            self.checkSelectedSegments();
        });
    }

    clearHandler(e) {
        let self = e.data.self;

        self.selectedSegments = [];

        $(".boolean, .radio", self.segmentsElement).each(function() {
            $(this).prop("checked", false);
        });
    }

    saveHandler(e) {
        let self = e.data.self;

        self.$element.modal('hide');
        self.$element.trigger("saveSegments", [self.selectedSegments]);
    }

    previousPageHandler(e) {
        let self = e.data.self;

        if (self.currentPage > STARTING_PAGE) {
            self.currentPage--;
            self.updateCurrentPageText();
            self.updatePaginationButtons();
            self.updateData();
        }
    }

    nextPageHandler(e) {
        let self = e.data.self;

        if (self.currentPage < self.totalPages) {
            self.currentPage++;
            self.updateCurrentPageText();
            self.updatePaginationButtons();
            self.updateData();
        }
    }

    firstPageHandler(e) {
        let self = e.data.self;

        if (self.currentPage != STARTING_PAGE) {
            self.currentPage = STARTING_PAGE;
            self.updateCurrentPageText();
            self.updatePaginationButtons();
            self.updateData();
        }
    }
    
    lastPageHandler(e) {
        let self = e.data.self;

        if (self.currentPage != self.totalPages) {
            self.currentPage = self.totalPages;
            self.updateCurrentPageText();
            self.updatePaginationButtons();
            self.updateData();
        }
    }

    currentPageHandler(e) {
        let self = e.data.self;
        let newPage = $("." + SEGMENT_CLASSES.CURRENT_PAGE_INPUT, this.$element).val();

        if ($.isNumeric(newPage) && newPage >= STARTING_PAGE && newPage <= self.totalPages) {
            self.currentPage = newPage;
            self.updatePaginationButtons();
            self.updateData();
        }
        else
            self.updateCurrentPageText();
    }

    searchHandler(e) {
      let self = e.data.self;

      self.searchTerm = $("." + SEGMENT_CLASSES.SEARCH_INPUT, self.$element).val().toLowerCase();
      self.updateData();
    }

    clearSearchHandler(e) {
      let self = e.data.self;

      self.searchTerm = "";
      $("." + SEGMENT_CLASSES.SEARCH_INPUT).val("");
      self.updateData();
    }


    // ************* Helpers *************


    // Adds the event listeners for elements created on data pull
    addPostDataEventListeners() {
        let self = this;

        // Add event listener for the expand buttons
        $("." + SEGMENT_CLASSES.EXPAND_BUTTON, this.segmentsElement).each(function() {
            $(this).on('click', { self: self, button: this }, self.expandSegmentHandler);

            // Enable expand/collapse button when expand/collapse is complete
            var button = this;
            $(button).closest("." + SEGMENT_CLASSES.PARENT_SEGMENT).siblings("." + SEGMENT_CLASSES.COLLAPSE_CONTAINER).on('shown.bs.collapse', function () {
                $(button).removeAttr("disabled");
            });

            $(button).closest("." + SEGMENT_CLASSES.PARENT_SEGMENT).siblings("." + SEGMENT_CLASSES.COLLAPSE_CONTAINER).on('hidden.bs.collapse', function () {
                $(button).removeAttr("disabled");
            });
        });

        // *************** Single select Event Listeners ***************

        // Enable the segment radio button if the row is clicked
        $("." + SEGMENT_CLASSES.PARENT_SEGMENT + ", ." + SEGMENT_CLASSES.CHILD_SEGMENT, this.segmentsElement).click(function (e) {
          let radio = $(this).find(".radio");
          if (!radio.length || $(e.target).hasClass(SEGMENT_CLASSES.EXPAND_BUTTON) || $(e.target).hasClass('radio') || $(e.target).hasClass('control__indicator--radio'))
            return;

          radio.prop("checked", true);
          self.setElementAsSelectedSegment(radio);
        });

        // Add or remove selected segment if checkbox is checked
        $(".radio", this.segmentsElement).click(function () {
          self.setElementAsSelectedSegment(this);
        });

        // *************** Multiselect Event Listeners ***************

        // Enable the segment checkbox if the row is clicked
        $("." + SEGMENT_CLASSES.PARENT_SEGMENT + ", ." + SEGMENT_CLASSES.CHILD_SEGMENT, this.segmentsElement).click(function (e) {
            let checkbox = $(this).find(".boolean");
            if (!checkbox.length ||  $(e.target).hasClass(SEGMENT_CLASSES.EXPAND_BUTTON) || $(e.target).hasClass('boolean') || $(e.target).hasClass('control__indicator--checkbox'))
                return;

            checkbox.prop("checked", !checkbox.prop("checked"));

            if (checkbox.prop("checked"))
                self.addElementAsSelectedSegment(checkbox);
            else
                self.removeElementAsSelectedSegment(checkbox);
        });

        // Add or remove selected segment if checkbox is checked
        $(".boolean", this.segmentsElement).click(function () {
            if ($(this).prop("checked"))
                self.addElementAsSelectedSegment(this);
            else
                self.removeElementAsSelectedSegment(this);
        });

        // Enable parent and all child segment checkboxes if the row is double clicked
        $("." + SEGMENT_CLASSES.PARENT_SEGMENT, this.segmentsElement).dblclick(function(e) {
            if ($(e.target).hasClass(SEGMENT_CLASSES.EXPAND_BUTTON))
                return;

            let parentCheckbox = $(this).find(".boolean");

            if (!parentCheckbox.length)
              return;

            parentCheckbox.prop("checked", !parentCheckbox.prop("checked"));

            if (parentCheckbox.prop("checked"))
                self.addElementAsSelectedSegment(parentCheckbox);
            else
                self.removeElementAsSelectedSegment(parentCheckbox);

            let children = self.getSegmentChildren(this);
            $.each(children, function(index, child) {
                let childCheckbox = self.getElementFromSegmentId(child.id);
                childCheckbox.prop("checked", parentCheckbox.prop("checked"));

                if (childCheckbox.prop("checked"))
                    self.addElementAsSelectedSegment(childCheckbox);
                else
                    self.removeElementAsSelectedSegment(childCheckbox);
            });

            let expandButton = $(this).find("." + SEGMENT_CLASSES.EXPAND_BUTTON);
            if (expandButton.html() === EXPAND_BUTTON_TEXT.EXPAND && parentCheckbox.prop("checked"))
                expandButton.click();
        });
    }

    // Checks all boxes who's segment is in the selected segments array
    checkSelectedSegments() {
        let self = this;

        $(".boolean, .radio", this.segmentsElement).each(function() {
            if (self.selectedSegments.some(segment => segment.id === $(this).data("segment-id"))) {
                $(this).prop("checked", true);
            }
        });
    }

    updatePaginationButtons() {
        if (this.currentPage <= STARTING_PAGE) {
            $("." + SEGMENT_CLASSES.PREVIOUS_PAGE_BUTTON, this.$element).attr("disabled", true);
            $("." + SEGMENT_CLASSES.FIRST_PAGE_BUTTON, this.$element).attr("disabled", true);
        }
        else {
            $("." + SEGMENT_CLASSES.PREVIOUS_PAGE_BUTTON, this.$element).attr("disabled", false);
            $("." + SEGMENT_CLASSES.FIRST_PAGE_BUTTON, this.$element).attr("disabled", false);
        }

        if (this.currentPage >= this.totalPages) {
            $("." + SEGMENT_CLASSES.NEXT_PAGE_BUTTON, this.$element).attr("disabled", true);
            $("." + SEGMENT_CLASSES.LAST_PAGE_BUTTON, this.$element).attr("disabled", true);
        }
        else {
            $("." + SEGMENT_CLASSES.NEXT_PAGE_BUTTON, this.$element).attr("disabled", false);
            $("." + SEGMENT_CLASSES.LAST_PAGE_BUTTON, this.$element).attr("disabled", false);
        }
    }

    // Updates the "current page" text
    updateCurrentPageText() {
        let self = this;
    
        $("." + SEGMENT_CLASSES.CURRENT_PAGE_INPUT).val(self.currentPage);
    }

    // Selects and triggers a save on preselected segments
    preselectSegments() {
      let self = this;

      if (!self.preselectedSegments || self.preselectedSegments.length <= 0)
        return;

      self.selectedSegments = [];

      $.get(self.allDataUrl, { ids: self.preselectedSegments }, (data) => {
        $.each(data, function(index, segment) {
          self.addToSelectedSegments(segment.id, segment.text);
        });

        self.checkSelectedSegments();

        self.$element.trigger("saveSegments", [self.selectedSegments]);
      });
    }

    // element is an element that contains a data field 'segment-id'
    // Gets the segment ID from the HTML element and sets it as the only selected segment
    setElementAsSelectedSegment(element) {
      this.selectedSegments = [];
      this.addElementAsSelectedSegment(element);
    }

    // element is an element that contains a data field 'segment-id'
    // Gets the segment ID from the HTML element and adds it to the selected segments array
    addElementAsSelectedSegment(element) {
        this.addToSelectedSegments($(element).data("segment-id"), $(element).data("segment-name"));
    }

    // element is an element that contains a data field 'segment-id'
    // Gets the segment ID from the HTML element and removes it from the selected segments array
    removeElementAsSelectedSegment(element) {
        this.removeFromSelectedSegments($(element).data("segment-id"));
    }

    // segmentId is the ID of the segment to add
    // Adds a segment ID to the array of selected segment IDs
    addToSelectedSegments(segmentId, segmentName) {
        if (!$.isNumeric(segmentId))
            return;

        this.selectedSegments.push({ id: segmentId, text: segmentName });
    }

    // segmentId is the ID of the segment to remove
    // Removes a segment ID from the array of selected segment IDs
    removeFromSelectedSegments(segmentId) {
        var idx = this.selectedSegments.findIndex(segment => segment.id === segmentId)
        if (idx == -1)
            return;

        this.selectedSegments.splice(idx, 1);
    }

    // jqObject is a jQuery object
    // Toggles the collapse of the object
    toggleCollapse(jqObject) {
        jqObject.collapse('toggle');
    }

    // segment_id is the ID of a segment
    // Returns the element relating to the segment ID
    getElementFromSegmentId(segment_id) {
      return $(".boolean." + SEGMENT_CLASSES.SEGMENT_PREFIX + segment_id, this.segmentsElement);
    }

    // element is a DOM element that has 'segment-id'
    // Returns an array of child elements
    getSegmentChildren(element) {
      let self = this;

      let parentId = parseInt($(element).data("segment-id"));
      if (isNaN(parentId))
        return;

      return self.data.find(g => g.id === parentId).children;
    }
}
